-- ================================================================================
-- ImportSIAC.usp_BH_11_SG
-- Estratto dal monolite (step 11_SG). Ricostruisce CertificazioneSG da
-- wrk_SG_Final. FASE 2: DML in transazione esplicita + recovery versioning.
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_11_SG
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT,
    @SG_Correnti INT = NULL OUTPUT,
    @SG_Storici INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;
    SET @SG_Correnti = 0; SET @SG_Storici = 0;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @fk_name NVARCHAR(200), @fk_parent NVARCHAR(300);
    DECLARE @HT_SG NVARCHAR(300);

    SELECT @HT_SG=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.CertificazioneSG');
    IF @HT_SG IS NULL AND OBJECT_ID(N'Certificazione.CertificazioneSGStorico', N'U') IS NOT NULL
        SET @HT_SG = N'[Certificazione].[CertificazioneSGStorico]';
    IF @HT_SG IS NULL THROW 51302, 'History table CertificazioneSG non determinabile.', 1;

    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'11_SG', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        SET @Rows = (SELECT COUNT_BIG(*) FROM Certificazione.CertificazioneSG);
        SET @RowsAffected = @Rows;
        SET @SG_Correnti = @Rows;
        SET @SG_Storici = NULL;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,11,N'11_SG',N'Rebuild SG (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: CertificazioneSG gia popolata.');
        PRINT CONCAT('STEP 11_SG: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,11,N'11_SG',N'Rebuild SG',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSG') AND temporal_type=2)
        BEGIN SET @sql=N'ALTER TABLE Certificazione.CertificazioneSG SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END;
        IF EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSG'))
        BEGIN SET @sql=N'ALTER TABLE Certificazione.CertificazioneSG DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END;

        BEGIN TRANSACTION;

        SET @sql=N'DELETE FROM '+@HT_SG; EXEC sp_executesql @sql;
        DELETE FROM Certificazione.CertificazioneSG;

        -- MIG_108: chiave business canonica
        SET @sql = N'INSERT INTO Certificazione.CertificazioneSG (
            CertificazioneId, OrganizzazioneClienteId, AmbitoIta, AmbitoEng, DataUltimoRinnovo,
            DataCreazione, UniqueRowId, DataInizioValidita, DataFineValidita
        )
        SELECT c.CertificazioneId, sg.OrganizzazioneClienteId, sg.AmbitoIta, sg.AmbitoEng, sg.DataUltimoRinnovo,
            SYSUTCDATETIME(), NEWID(), sg.DataInizioValiditaSG,
            CAST(''9999-12-31 23:59:59.9999999'' AS DATETIME2(7))
        FROM ImportSIAC.wrk_SG_Final sg
        JOIN Certificazione.Certificazione c
            ON c.ChiaveBusinessHash = sg.ChiaveBusinessHash
        WHERE sg.IsCorrente = 1 OPTION (MAXDOP 8);';
        EXEC sp_executesql @sql;
        SET @SG_Correnti = @@ROWCOUNT;

        SET @sql = CONCAT(N'INSERT INTO ', @HT_SG, N' WITH (TABLOCK) (CertificazioneSGId, CertificazioneId, OrganizzazioneClienteId, AmbitoIta, AmbitoEng, DataUltimoRinnovo,
            DataCreazione, UniqueRowId, DataInizioValidita, DataFineValidita)
        SELECT csg.CertificazioneSGId, csg.CertificazioneId, sg.OrganizzazioneClienteId,
            sg.AmbitoIta, sg.AmbitoEng, sg.DataUltimoRinnovo,
            csg.DataCreazione, NEWID(), sg.DataInizioValiditaSG, sg.DataFineValiditaSG
        FROM ImportSIAC.wrk_SG_Final sg
        JOIN Certificazione.Certificazione c
          ON c.ChiaveBusinessHash = sg.ChiaveBusinessHash
        JOIN Certificazione.CertificazioneSG csg ON csg.CertificazioneId=c.CertificazioneId
        WHERE sg.IsCorrente=0 OPTION (MAXDOP 8)');
        EXEC sp_executesql @sql;
        SET @SG_Storici = @@ROWCOUNT;

        COMMIT TRANSACTION;

        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.CertificazioneSG SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.CertificazioneSG DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
        IF NOT EXISTS (
            SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
            JOIN sys.periods p ON p.object_id = t.object_id
            WHERE s.name = N'Certificazione' AND t.name = N'CertificazioneSG'
        )
        BEGIN
            BEGIN TRY
                SET @sql=N'ALTER TABLE Certificazione.CertificazioneSG ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql;
            END TRY
            BEGIN CATCH
                IF ERROR_NUMBER() <> 13597 THROW;
            END CATCH;
        END;
        SET @sql=N'ALTER TABLE Certificazione.CertificazioneSG SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_SG+N',DATA_CONSISTENCY_CHECK=OFF))';
        EXEC sp_executesql @sql;

        DECLARE fk_child_11_SG CURSOR LOCAL FAST_FORWARD FOR
            SELECT fk.name, SCHEMA_NAME(pt.schema_id)+N'.'+pt.name FROM sys.foreign_keys fk
            JOIN sys.tables pt ON pt.object_id=fk.parent_object_id
            WHERE fk.referenced_object_id=OBJECT_ID('Certificazione.Certificazione') AND pt.name=N'CertificazioneSG';
        OPEN fk_child_11_SG; FETCH NEXT FROM fk_child_11_SG INTO @fk_name, @fk_parent;
        WHILE @@FETCH_STATUS=0 BEGIN
            SET @sql=N'ALTER TABLE '+@fk_parent+N' WITH CHECK CHECK CONSTRAINT ['+@fk_name+N']'; EXEC sp_executesql @sql;
            FETCH NEXT FROM fk_child_11_SG INTO @fk_name, @fk_parent;
        END; CLOSE fk_child_11_SG; DEALLOCATE fk_child_11_SG;

        -- MIG_117: conserva output 08 SG
        SET @Rows = @SG_Correnti + @SG_Storici;
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 11_SG: ', @Rows);

        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'11_SG', @OutputTable=N'Certificazione.CertificazioneSG',
            @RowCountAtSave=@SG_Correnti, @Notes=N'Rebuild SG correnti+storico da wrk_SG_Final.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        BEGIN TRY
            IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSG') AND temporal_type=2)
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSG'))
                BEGIN
                    DECLARE @sqlRec NVARCHAR(MAX) = N'ALTER TABLE Certificazione.CertificazioneSG ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)';
                    EXEC sp_executesql @sqlRec;
                END;
                DECLARE @sqlRec2 NVARCHAR(MAX) = N'ALTER TABLE Certificazione.CertificazioneSG SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_SG+N',DATA_CONSISTENCY_CHECK=OFF))';
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

