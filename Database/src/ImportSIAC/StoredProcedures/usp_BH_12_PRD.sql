-- ================================================================================
-- ImportSIAC.usp_BH_12_PRD
-- Estratto dal monolite (step 12_PRD). Ricostruisce CertificazionePRD da
-- wrk_PRD_Final. FASE 2: DML in transazione esplicita + recovery versioning.
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_12_PRD
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT,
    @PRD_Correnti INT = NULL OUTPUT,
    @PRD_Storici INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;
    SET @PRD_Correnti = 0; SET @PRD_Storici = 0;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @fk_name NVARCHAR(200), @fk_parent NVARCHAR(300);
    DECLARE @HT_PRD NVARCHAR(300);
    -- MIG_107: profili tecnici PRD multivalore
    DECLARE @RowsProfiliTecnici BIGINT = 0;

    SELECT @HT_PRD=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.CertificazionePRD');
    IF @HT_PRD IS NULL AND OBJECT_ID(N'Certificazione.CertificazionePRDStorico', N'U') IS NOT NULL
        SET @HT_PRD = N'[Certificazione].[CertificazionePRDStorico]';
    IF @HT_PRD IS NULL THROW 51304, 'History table CertificazionePRD non determinabile.', 1;

    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'12_PRD', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        SET @Rows = (SELECT COUNT_BIG(*) FROM Certificazione.CertificazionePRD);
        SET @RowsAffected = @Rows;
        SET @PRD_Correnti = @Rows;
        SET @PRD_Storici = NULL;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,12,N'12_PRD',N'Rebuild PRD (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: CertificazionePRD gia popolata.');
        PRINT CONCAT('STEP 12_PRD: RESUMED, ', @Rows);
        EXEC ImportSIAC.usp_BH_12A_PRD_ProfiliTecnici
            @BuildHistoryLogId = @BuildHistoryLogId,
            @RowsAffected = @RowsProfiliTecnici OUTPUT;
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,12,N'12_PRD',N'Rebuild PRD',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazionePRD') AND temporal_type=2)
        BEGIN SET @sql=N'ALTER TABLE Certificazione.CertificazionePRD SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END;
        IF EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.CertificazionePRD'))
        BEGIN SET @sql=N'ALTER TABLE Certificazione.CertificazionePRD DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END;

        BEGIN TRANSACTION;

        SET @sql=N'DELETE FROM '+@HT_PRD; EXEC sp_executesql @sql;
        DELETE FROM Certificazione.CertificazionePRDProfiloTecnico;
        DELETE FROM Certificazione.CertificazionePRD;

        -- MIG_108: chiave business canonica
        -- MIG_114: INSERT corrente PRD compilato dopo DROP PERIOD
        SET @sql = N'INSERT INTO Certificazione.CertificazionePRD (
            CertificazioneId, OrganizzazioneClienteId,
            ScopoCertificato, NomeProdotto, SpecificaTecnica, DataUltimoRinnovo,
            DataCreazione, UniqueRowId, DataInizioValidita, DataFineValidita
        )
        SELECT c.CertificazioneId, prd.OrganizzazioneClienteId,
            prd.ScopoCertificato, prd.NomeProdotto, prd.SpecificaTecnica, prd.DataUltimoRinnovo,
            SYSUTCDATETIME(), NEWID(), prd.DataInizioValiditaPRD,
            CAST(''9999-12-31 23:59:59.9999999'' AS DATETIME2(7))
        FROM ImportSIAC.wrk_PRD_Final prd
        JOIN Certificazione.Certificazione c
            ON c.ChiaveBusinessHash = prd.ChiaveBusinessHash
        WHERE prd.IsCorrente = 1 OPTION (MAXDOP 8);
        SET @Inserted = @@ROWCOUNT;';

        EXEC sys.sp_executesql
            @sql,
            N'@Inserted int OUTPUT',
            @Inserted = @PRD_Correnti OUTPUT;

        SET @sql = CONCAT(N'INSERT INTO ', @HT_PRD, N' WITH (TABLOCK) (CertificazionePRDId, CertificazioneId, OrganizzazioneClienteId,
            ScopoCertificato, NomeProdotto, SpecificaTecnica, DataUltimoRinnovo,
            DataCreazione, UniqueRowId, DataInizioValidita, DataFineValidita)
        SELECT cprd.CertificazionePRDId, cprd.CertificazioneId, prd.OrganizzazioneClienteId,
            prd.ScopoCertificato, prd.NomeProdotto, prd.SpecificaTecnica, prd.DataUltimoRinnovo,
            cprd.DataCreazione, NEWID(), prd.DataInizioValiditaPRD, prd.DataFineValiditaPRD
        FROM ImportSIAC.wrk_PRD_Final prd
        JOIN Certificazione.Certificazione c
          ON c.ChiaveBusinessHash = prd.ChiaveBusinessHash
        JOIN Certificazione.CertificazionePRD cprd ON cprd.CertificazioneId=c.CertificazioneId
        WHERE prd.IsCorrente=0 OPTION (MAXDOP 8)');
        EXEC sp_executesql @sql;
        SET @PRD_Storici = @@ROWCOUNT;

        COMMIT TRANSACTION;

        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.CertificazionePRD SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.CertificazionePRD DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
        IF NOT EXISTS (
            SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
            JOIN sys.periods p ON p.object_id = t.object_id
            WHERE s.name = N'Certificazione' AND t.name = N'CertificazionePRD'
        )
        BEGIN
            BEGIN TRY
                SET @sql=N'ALTER TABLE Certificazione.CertificazionePRD ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql;
            END TRY
            BEGIN CATCH
                IF ERROR_NUMBER() <> 13597 THROW;
            END CATCH;
        END;
        SET @sql=N'ALTER TABLE Certificazione.CertificazionePRD SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_PRD+N',DATA_CONSISTENCY_CHECK=OFF))';
        EXEC sp_executesql @sql;

        DECLARE fk_child_12_PRD CURSOR LOCAL FAST_FORWARD FOR
            SELECT fk.name, SCHEMA_NAME(pt.schema_id)+N'.'+pt.name FROM sys.foreign_keys fk
            JOIN sys.tables pt ON pt.object_id=fk.parent_object_id
            WHERE fk.referenced_object_id=OBJECT_ID('Certificazione.Certificazione') AND pt.name=N'CertificazionePRD';
        OPEN fk_child_12_PRD; FETCH NEXT FROM fk_child_12_PRD INTO @fk_name, @fk_parent;
        WHILE @@FETCH_STATUS=0 BEGIN
            SET @sql=N'ALTER TABLE '+@fk_parent+N' WITH CHECK CHECK CONSTRAINT ['+@fk_name+N']'; EXEC sp_executesql @sql;
            FETCH NEXT FROM fk_child_12_PRD INTO @fk_name, @fk_parent;
        END; CLOSE fk_child_12_PRD; DEALLOCATE fk_child_12_PRD;

        EXEC ImportSIAC.usp_BH_12A_PRD_ProfiliTecnici
            @BuildHistoryLogId = @BuildHistoryLogId,
            @RowsAffected = @RowsProfiliTecnici OUTPUT;

        -- MIG_117: conserva output 08 PRD
        SET @Rows = @PRD_Correnti + @PRD_Storici;
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 12_PRD: ', @Rows);

        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'12_PRD', @OutputTable=N'Certificazione.CertificazionePRD',
            @RowCountAtSave=@PRD_Correnti, @Notes=N'Rebuild PRD correnti+storico da wrk_PRD_Final.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        BEGIN TRY
            IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazionePRD') AND temporal_type=2)
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.CertificazionePRD'))
                BEGIN
                    DECLARE @sqlRec NVARCHAR(MAX) = N'ALTER TABLE Certificazione.CertificazionePRD ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)';
                    EXEC sp_executesql @sqlRec;
                END;
                DECLARE @sqlRec2 NVARCHAR(MAX) = N'ALTER TABLE Certificazione.CertificazionePRD SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_PRD+N',DATA_CONSISTENCY_CHECK=OFF))';
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

