-- ================================================================================
-- ImportSIAC.usp_BH_13_FPC
-- Estratto dal monolite (step 13_FPC). Ricostruisce CertificazioneFPC da
-- wrk_FPC_Final + wrk_FPC_PersonaMap. FASE 2: DML in transazione esplicita +
-- recovery versioning.
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_13_FPC
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT,
    @FPC_Correnti INT = NULL OUTPUT,
    @FPC_Storici INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;
    SET @FPC_Correnti = 0; SET @FPC_Storici = 0;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @fk_name NVARCHAR(200), @fk_parent NVARCHAR(300);
    DECLARE @HT_FPC NVARCHAR(300);
    -- MIG_107: profilo professionale FPC su certificato

    SELECT @HT_FPC=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.CertificazioneFPC');
    IF @HT_FPC IS NULL AND OBJECT_ID(N'Certificazione.CertificazioneFPCStorico', N'U') IS NOT NULL
        SET @HT_FPC = N'[Certificazione].[CertificazioneFPCStorico]';
    IF @HT_FPC IS NULL THROW 51305, 'History table CertificazioneFPC non determinabile.', 1;

    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'13_FPC', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        SET @Rows = (SELECT COUNT_BIG(*) FROM Certificazione.CertificazioneFPC);
        SET @RowsAffected = @Rows;
        SET @FPC_Correnti = @Rows; -- accurato: conteggio attuale
        SET @FPC_Storici = NULL;  -- non ricalcolato al resume, solo statistica di riepilogo
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,13,N'13_FPC',N'Rebuild FPC (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: CertificazioneFPC gia popolata.');
        PRINT CONCAT('STEP 13_FPC: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,13,N'13_FPC',N'Rebuild FPC',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazioneFPC') AND temporal_type=2)
        BEGIN SET @sql=N'ALTER TABLE Certificazione.CertificazioneFPC SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END;
        IF EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.CertificazioneFPC'))
        BEGIN SET @sql=N'ALTER TABLE Certificazione.CertificazioneFPC DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END;

        BEGIN TRANSACTION;

        SET @sql=N'DELETE FROM '+@HT_FPC; EXEC sp_executesql @sql;
        DELETE FROM Certificazione.CertificazioneFPC;


        -- MIG_108: chiave business canonica
        -- MIG_114: INSERT corrente FPC compilato dopo DROP PERIOD
        SET @sql = N'INSERT INTO Certificazione.CertificazioneFPC
        (
            CertificazioneId,
            PersonaId,
            TipoQualificaId,
            Settore,
            DataEmissioneCorrente,
            Straniero,
            CodicePersonaODC,
            SiacId,
            LivelloDigCompId,
            ProgrammaCertificazioneId,
            ProfiloProfessionaleVersioneId,
            DataCreazione,
            UniqueRowId,
            DataInizioValidita,
            DataFineValidita
        )
        SELECT
            c.CertificazioneId,
            pm.PersonaId,
            fpc.TipoQualificaId,
            fpc.Settore,
            fpc.DataEmissioneCorrente,
            fpc.Straniero,
            fpc.CodicePersonaODC,
            fpc.SiacId,
            fpc.LivelloDigCompId,
            fpc.ProgrammaCertificazioneId,
            fpc.ProfiloProfessionaleVersioneId,
            SYSUTCDATETIME(),
            NEWID(),
            fpc.DataInizioValiditaFPC,
            CAST(''9999-12-31 23:59:59.9999999'' AS datetime2(7))
        FROM ImportSIAC.wrk_FPC_Final AS fpc
        JOIN Certificazione.Certificazione AS c
          ON c.ChiaveBusinessHash = fpc.ChiaveBusinessHash
        JOIN ImportSIAC.wrk_FPC_PersonaMap AS pm
          ON pm.ChiaveBusinessHash = fpc.ChiaveBusinessHash
        WHERE fpc.IsCorrente = 1
          AND pm.PersonaId IS NOT NULL
          AND fpc.ProfiloProfessionaleVersioneId IS NOT NULL
        OPTION (MAXDOP 8);
        SET @Inserted = @@ROWCOUNT;';

        EXEC sys.sp_executesql
            @sql,
            N'@Inserted int OUTPUT',
            @Inserted = @FPC_Correnti OUTPUT;


        SET @sql = CONCAT
        (
            N'INSERT INTO ',
            @HT_FPC,
            N' WITH (TABLOCK)
            (
                CertificazioneFPCId,
                CertificazioneId,
                PersonaId,
                TipoQualificaId,
                Settore,
                DataEmissioneCorrente,
                Straniero,
                CodicePersonaODC,
                SiacId,
                LivelloDigCompId,
                ProgrammaCertificazioneId,
                ProfiloProfessionaleVersioneId,
                DataCreazione,
                UniqueRowId,
                DataInizioValidita,
                DataFineValidita
            )
            SELECT
                cfpc.CertificazioneFPCId,
                cfpc.CertificazioneId,
                pm.PersonaId,
                fpc.TipoQualificaId,
                fpc.Settore,
                fpc.DataEmissioneCorrente,
                fpc.Straniero,
                fpc.CodicePersonaODC,
                fpc.SiacId,
                fpc.LivelloDigCompId,
                fpc.ProgrammaCertificazioneId,
                fpc.ProfiloProfessionaleVersioneId,
                cfpc.DataCreazione,
                NEWID(),
                fpc.DataInizioValiditaFPC,
                fpc.DataFineValiditaFPC
            FROM ImportSIAC.wrk_FPC_Final AS fpc
            JOIN Certificazione.Certificazione AS c
              ON c.ChiaveBusinessHash = fpc.ChiaveBusinessHash
            JOIN Certificazione.CertificazioneFPC AS cfpc
              ON cfpc.CertificazioneId = c.CertificazioneId
            JOIN ImportSIAC.wrk_FPC_PersonaMap AS pm
              ON pm.ChiaveBusinessHash = fpc.ChiaveBusinessHash
            WHERE fpc.IsCorrente = 0
              AND pm.PersonaId IS NOT NULL
              AND fpc.ProfiloProfessionaleVersioneId IS NOT NULL
            OPTION (MAXDOP 8)'
        );
        EXEC sys.sp_executesql @sql;
        SET @FPC_Storici = @@ROWCOUNT;

        COMMIT TRANSACTION;

        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.CertificazioneFPC SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.CertificazioneFPC DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
        IF NOT EXISTS (
            SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
            JOIN sys.periods p ON p.object_id = t.object_id
            WHERE s.name = N'Certificazione' AND t.name = N'CertificazioneFPC'
        )
        BEGIN
            BEGIN TRY
                SET @sql=N'ALTER TABLE Certificazione.CertificazioneFPC ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql;
            END TRY
            BEGIN CATCH
                IF ERROR_NUMBER() <> 13597 THROW;
            END CATCH;
        END;
        SET @sql=N'ALTER TABLE Certificazione.CertificazioneFPC SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_FPC+N',DATA_CONSISTENCY_CHECK=OFF))';
        EXEC sp_executesql @sql;

        DECLARE fk_child_13_FPC CURSOR LOCAL FAST_FORWARD FOR
            SELECT fk.name, SCHEMA_NAME(pt.schema_id)+N'.'+pt.name FROM sys.foreign_keys fk
            JOIN sys.tables pt ON pt.object_id=fk.parent_object_id
            WHERE fk.referenced_object_id=OBJECT_ID('Certificazione.Certificazione') AND pt.name=N'CertificazioneFPC';
        OPEN fk_child_13_FPC; FETCH NEXT FROM fk_child_13_FPC INTO @fk_name, @fk_parent;
        WHILE @@FETCH_STATUS=0 BEGIN
            SET @sql=N'ALTER TABLE '+@fk_parent+N' WITH CHECK CHECK CONSTRAINT ['+@fk_name+N']'; EXEC sp_executesql @sql;
            FETCH NEXT FROM fk_child_13_FPC INTO @fk_name, @fk_parent;
        END; CLOSE fk_child_13_FPC; DEALLOCATE fk_child_13_FPC;

        -- MIG_117: conserva output 08 FPC
        -- MIG_117: conserva output 09 PersonaMap
        SET @Rows = @FPC_Correnti + @FPC_Storici;
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 13_FPC: ', @Rows);

        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'13_FPC', @OutputTable=N'Certificazione.CertificazioneFPC',
            @RowCountAtSave=@FPC_Correnti, @Notes=N'Rebuild FPC correnti+storico da wrk_FPC_Final + PersonaMap.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        BEGIN TRY
            IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazioneFPC') AND temporal_type=2)
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.CertificazioneFPC'))
                BEGIN
                    DECLARE @sqlRec NVARCHAR(MAX) = N'ALTER TABLE Certificazione.CertificazioneFPC ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)';
                    EXEC sp_executesql @sqlRec;
                END;
                DECLARE @sqlRec2 NVARCHAR(MAX) = N'ALTER TABLE Certificazione.CertificazioneFPC SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_FPC+N',DATA_CONSISTENCY_CHECK=OFF))';
                EXEC sp_executesql @sqlRec2;
            END;
        END TRY
        BEGIN CATCH END CATCH;
        IF @StepLogId IS NOT NULL
            UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
                DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
                Status=N'FAILED', ErrorMessage=@ErrMsg
            WHERE BuildHistoryStepLogId=@StepLogId;
        THROW;
    END CATCH;
END;

GO

