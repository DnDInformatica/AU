-- ================================================================================
-- ImportSIAC.usp_BH_10_Rebuild_Cert
-- Estratto dal monolite (step 10_REBUILD_CERT). Ricostruisce Certificazione
-- (correnti + storico) da wrk_All_Final. Gestisce OFF/DROP PERIOD prima del
-- DML e ON/ADD PERIOD dopo (auto-contenuto: ricalcola le history table).
--
-- FASE 2 (atomicita'): il DML (DELETE+INSERT correnti+storico) e' racchiuso
-- in una transazione esplicita. In caso di errore DURANTE il DML, si tenta
-- comunque di ripristinare il versioning temporale (mai lasciare la tabella
-- in stato NON_TEMPORAL rotto) prima di ri-lanciare l'eccezione.
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_10_Rebuild_Cert
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT,
    @Cert_Correnti INT = NULL OUTPUT,
    @Cert_Storici INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;
    DECLARE @TipoFPC INT =
        (SELECT TipoCertificazioneId
         FROM Certificazione.TipoCertificazione
         WHERE Codice = N'FPC');
    DECLARE @TipoPRD INT =
        (SELECT TipoCertificazioneId
         FROM Certificazione.TipoCertificazione
         WHERE Codice = N'PRD');
    IF @TipoFPC IS NULL OR @TipoPRD IS NULL
        THROW 62120, 'Catalogo tipo FPC/PRD non disponibile.', 1;
    SET @Cert_Correnti = 0; SET @Cert_Storici = 0;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @fk_name NVARCHAR(200), @fk_parent NVARCHAR(300);
    DECLARE @HT_Cert NVARCHAR(300), @HT_Sede NVARCHAR(300);

    -- Discovery history table (auto-contenuto, con fallback se versioning e' OFF)
    SELECT @HT_Cert=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.Certificazione');
    SELECT @HT_Sede=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.CertificazioneSede');
    IF @HT_Cert IS NULL AND OBJECT_ID(N'Certificazione.CertificazioneStorico', N'U') IS NOT NULL
        SET @HT_Cert = N'[Certificazione].[CertificazioneStorico]';
    IF @HT_Sede IS NULL AND OBJECT_ID(N'Certificazione.CertificazioneSedeStorico', N'U') IS NOT NULL
        SET @HT_Sede = N'[Certificazione].[CertificazioneSedeStorico]';
    IF @HT_Cert IS NULL OR @HT_Sede IS NULL THROW 51301, 'History table Certificazione/Sede non determinabili.', 1;

    -- CHECKPOINT: skip se Certificazione e' gia' popolata con l'atteso conteggio
    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'10_REBUILD_CERT', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        SET @Rows = (SELECT COUNT_BIG(*) FROM Certificazione.Certificazione);
        SET @RowsAffected = @Rows;
        SET @Cert_Correnti = @Rows;
        SET @Cert_Storici = NULL;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,10,N'10_REBUILD_CERT',N'Rebuild Certificazione (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: Certificazione gia popolata.');
        PRINT CONCAT('STEP 10_REBUILD_CERT: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,10,N'10_REBUILD_CERT',N'Rebuild Certificazione',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        -- Temporal OFF (fuori transazione: DDL di preparazione)
        IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.Certificazione') AND temporal_type=2)
        BEGIN SET @sql=N'ALTER TABLE Certificazione.Certificazione SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END;
        IF EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.Certificazione'))
        BEGIN SET @sql=N'ALTER TABLE Certificazione.Certificazione DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END;
        IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSede') AND temporal_type=2)
        BEGIN SET @sql=N'ALTER TABLE Certificazione.CertificazioneSede SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END;
        IF EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSede'))
        BEGIN SET @sql=N'ALTER TABLE Certificazione.CertificazioneSede DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END;

        -- NOCHECK all FK -> Certificazione
        DECLARE fk_cur CURSOR LOCAL FAST_FORWARD FOR
            SELECT fk.name, SCHEMA_NAME(pt.schema_id)+'.'+pt.name FROM sys.foreign_keys fk
            JOIN sys.tables pt ON pt.object_id=fk.parent_object_id
            WHERE fk.referenced_object_id=OBJECT_ID('Certificazione.Certificazione');
        OPEN fk_cur; FETCH NEXT FROM fk_cur INTO @fk_name, @fk_parent;
        WHILE @@FETCH_STATUS=0 BEGIN
            SET @sql=N'ALTER TABLE '+@fk_parent+N' NOCHECK CONSTRAINT ['+@fk_name+N']'; EXEC sp_executesql @sql;
            FETCH NEXT FROM fk_cur INTO @fk_name, @fk_parent;
        END; CLOSE fk_cur; DEALLOCATE fk_cur;

        -- ===== FASE 2: DML in transazione esplicita =====
        BEGIN TRANSACTION;

        SET @sql=N'DELETE FROM '+@HT_Sede; EXEC sp_executesql @sql;
        DELETE FROM Certificazione.CertificazioneSede;
        SET @sql=N'DELETE FROM '+@HT_Cert; EXEC sp_executesql @sql;
        DELETE FROM Certificazione.Certificazione;

        -- MIG_108: chiave business canonica
        -- MIG_121: tipo certificazione canonico da Dominio
        SET @sql = N'INSERT INTO Certificazione.Certificazione (
            ChiaveBusinessHash, NumeroCertificato, OrganizzazioneODCId, TipoCertificazioneId,
            NormaAccreditamentoId, StatoCertificazioneId,
            DataEmissione, DataScadenza, DataRevoca, Privato, DataPrimoRilascio,
            DataCreazione, UniqueRowId, DataInizioValidita, DataFineValidita
        )
        SELECT f.ChiaveBusinessHash, f.NumeroCertificato, f.OrganizzazioneODCId, CASE f.Dominio WHEN N''FPC'' THEN @TipoFPC WHEN N''PRD'' THEN @TipoPRD ELSE f.TipoCertificazioneId END,
            f.NormaAccreditamentoId, f.StatoCertificazioneId,
            f.DataEmissione, f.DataScadenza, f.DataRevoca, f.Privato, f.DataPrimoRilascio,
            SYSUTCDATETIME(), NEWID(), f.DataInizioValidita,
            CAST(''9999-12-31 23:59:59.9999999'' AS DATETIME2(7))
        FROM ImportSIAC.wrk_All_Final f
        WHERE f.IsCorrente = 1
          -- MIG_124: non materializzare testate FPC senza PersonaMap
          AND
          (
              f.Dominio <> N''FPC''
              OR EXISTS
                 (
                     SELECT 1
                     FROM ImportSIAC.wrk_FPC_PersonaMap AS pm
                     WHERE pm.ChiaveBusinessHash = f.ChiaveBusinessHash
                 )
          )
        OPTION (MAXDOP 8);';
        EXEC sys.sp_executesql @sql, N'@TipoFPC int, @TipoPRD int', @TipoFPC=@TipoFPC, @TipoPRD=@TipoPRD;
        SET @Cert_Correnti = @@ROWCOUNT;

        SET @sql = CONCAT(N'INSERT INTO ', @HT_Cert, N' WITH (TABLOCK) (
            CertificazioneId, ChiaveBusinessHash, NumeroCertificato, OrganizzazioneODCId, TipoCertificazioneId,
            NormaAccreditamentoId, StatoCertificazioneId,
            DataEmissione, DataScadenza, DataRevoca, Privato, DataPrimoRilascio,
            DataCreazione, UniqueRowId, DataInizioValidita, DataFineValidita)
        SELECT c.CertificazioneId, f.ChiaveBusinessHash, f.NumeroCertificato, f.OrganizzazioneODCId, CASE f.Dominio WHEN N''FPC'' THEN @TipoFPC WHEN N''PRD'' THEN @TipoPRD ELSE f.TipoCertificazioneId END,
            f.NormaAccreditamentoId, f.StatoCertificazioneId,
            f.DataEmissione, f.DataScadenza, f.DataRevoca, f.Privato, f.DataPrimoRilascio,
            c.DataCreazione, NEWID(), f.DataInizioValidita, f.DataFineValidita
        FROM ImportSIAC.wrk_All_Final f
        JOIN Certificazione.Certificazione c
          ON c.ChiaveBusinessHash = f.ChiaveBusinessHash
        WHERE f.IsCorrente=0 OPTION (MAXDOP 8)');
        EXEC sys.sp_executesql @sql, N'@TipoFPC int, @TipoPRD int', @TipoFPC=@TipoFPC, @TipoPRD=@TipoPRD;
        SET @Cert_Storici = @@ROWCOUNT;

        COMMIT TRANSACTION;
        -- ===== FINE FASE 2 =====

        -- Temporal ON (ri-asserzione difensiva prima di ADD PERIOD)
        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.Certificazione SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.Certificazione DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
        IF NOT EXISTS (
            SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
            JOIN sys.periods p ON p.object_id = t.object_id
            WHERE s.name = N'Certificazione' AND t.name = N'Certificazione'
        )
        BEGIN
            BEGIN TRY
                SET @sql=N'ALTER TABLE Certificazione.Certificazione ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql;
            END TRY
            BEGIN CATCH
                IF ERROR_NUMBER() <> 13597 THROW;
            END CATCH;
        END;
        SET @sql=N'ALTER TABLE Certificazione.Certificazione SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_Cert+N',DATA_CONSISTENCY_CHECK=OFF))';
        EXEC sp_executesql @sql;

        -- CHECK FK (escluse figlie SG/PRD/FPC/Sede, ricontrollate nei rispettivi step)
        DECLARE fk_chk CURSOR LOCAL FAST_FORWARD FOR
            SELECT fk.name, SCHEMA_NAME(pt.schema_id)+'.'+pt.name FROM sys.foreign_keys fk
            JOIN sys.tables pt ON pt.object_id=fk.parent_object_id
            WHERE fk.referenced_object_id=OBJECT_ID('Certificazione.Certificazione')
              AND pt.name NOT IN ('CertificazioneSG','CertificazionePRD','CertificazioneFPC','CertificazioneSede');
        OPEN fk_chk; FETCH NEXT FROM fk_chk INTO @fk_name, @fk_parent;
        WHILE @@FETCH_STATUS=0 BEGIN
            SET @sql=N'ALTER TABLE '+@fk_parent+N' WITH CHECK CHECK CONSTRAINT ['+@fk_name+N']'; EXEC sp_executesql @sql;
            FETCH NEXT FROM fk_chk INTO @fk_name, @fk_parent;
        END; CLOSE fk_chk; DEALLOCATE fk_chk;

        -- MIG_117: conserva output 07_SCD2_PARENT
        SET @Rows = @Cert_Correnti + @Cert_Storici;
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 10_REBUILD_CERT: ', @Rows);

        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'10_REBUILD_CERT', @OutputTable=N'Certificazione.Certificazione',
            @RowCountAtSave=@Cert_Correnti, @Notes=N'Rebuild Certificazione correnti+storico da wrk_All_Final.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);

        -- FASE 2: se la transazione DML e' ancora aperta, rollback
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        -- Rete di sicurezza: mai lasciare Certificazione in stato NON_TEMPORAL rotto.
        -- Tento di ripristinare il versioning anche in caso di errore, senza propagare
        -- ulteriori eccezioni da questo tentativo di recovery.
        BEGIN TRY
            IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.Certificazione') AND temporal_type=2)
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.Certificazione'))
                BEGIN
                    DECLARE @sqlRec NVARCHAR(MAX) = N'ALTER TABLE Certificazione.Certificazione ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)';
                    EXEC sp_executesql @sqlRec;
                END;
                DECLARE @sqlRec2 NVARCHAR(MAX) = N'ALTER TABLE Certificazione.Certificazione SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_Cert+N',DATA_CONSISTENCY_CHECK=OFF))';
                EXEC sp_executesql @sqlRec2;
            END;
        END TRY
        BEGIN CATCH
            -- Recovery best-effort: se fallisce, l'errore originale resta quello prioritario
        END CATCH;

        IF @StepLogId IS NOT NULL
            UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
                DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
                Status=N'FAILED', ErrorMessage=@ErrMsg
            WHERE BuildHistoryStepLogId=@StepLogId;
        THROW;
    END CATCH;
END;

GO

