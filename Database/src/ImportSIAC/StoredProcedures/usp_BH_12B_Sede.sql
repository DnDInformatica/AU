CREATE   PROCEDURE ImportSIAC.usp_BH_12B_Sede
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT
AS
BEGIN
    -- ============================================================================
    -- MIG_146bc — Rebuild CertificazioneSede da wrk_Sede_Final.
    -- b) accoppiamento storico<->corrente per IDENTITA (hash + SedeId + chiave
    --    indirizzo per i NULL) al posto del MIN(CertificazioneSedeId) che
    --    collassava le identita indistinguibili; id sintetici (offset +10M) per
    --    le identita chiuse senza riga corrente.
    -- c) validazioni: intervalli positivi, zero sovrapposizioni per id,
    --    pairing completo; DATA_CONSISTENCY_CHECK=ON alla riattivazione.
    -- Richiede wrk_Sede_Final in versione MIG_146a.
    -- ============================================================================
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @fk_name NVARCHAR(200);
    DECLARE @HT_Sede NVARCHAR(300);

    SELECT @HT_Sede=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.CertificazioneSede');
    IF @HT_Sede IS NULL AND OBJECT_ID(N'Certificazione.CertificazioneSedeStorico', N'U') IS NOT NULL
        SET @HT_Sede = N'[Certificazione].[CertificazioneSedeStorico]';
    IF @HT_Sede IS NULL THROW 51303, 'History table CertificazioneSede non determinabile.', 1;

    IF COL_LENGTH('ImportSIAC.wrk_Sede_Final', 'SedeKeyNull') IS NULL
       OR COL_LENGTH('ImportSIAC.wrk_Sede_Final', 'IsUltimaVersione') IS NULL
        THROW 51309, 'wrk_Sede_Final non in versione MIG_146a: rieseguire lo step 08.', 1;

    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'12B_SEDE', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        SET @Rows = (SELECT COUNT_BIG(*) FROM Certificazione.CertificazioneSede);
        SET @RowsAffected = @Rows;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,12,N'12B_SEDE',N'Rebuild Sede (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: CertificazioneSede gia popolata.');
        PRINT CONCAT('STEP 12B_SEDE: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,12,N'12B_SEDE',N'Rebuild Sede (MIG_146)',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.CertificazioneSede SET (SYSTEM_VERSIONING = OFF)'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
        BEGIN TRY SET @sql=N'ALTER TABLE Certificazione.CertificazioneSede DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;

        BEGIN TRANSACTION;

        SET @sql = N'DELETE FROM ' + @HT_Sede;
        EXEC sys.sp_executesql @sql;
        DELETE FROM Certificazione.CertificazioneSede;

        SET @sql = N'INSERT INTO Certificazione.CertificazioneSede (
            CertificazioneId, SedeId, AmbitoIta, AmbitoEng, DataScadenzaSede,
            DataCreazione, UniqueRowId, DataInizioValidita, DataFineValidita
        )
        SELECT c.CertificazioneId, sf.SedeId, sf.AmbitoIta, sf.AmbitoEng, sf.DataScadenzaSede,
               SYSUTCDATETIME(), NEWID(), sf.DataInizioValiditaSede,
               CAST(''9999-12-31 23:59:59.9999999'' AS DATETIME2(7))
        FROM ImportSIAC.wrk_Sede_Final sf
        JOIN Certificazione.Certificazione c ON c.ChiaveBusinessHash = sf.ChiaveBusinessHash
        WHERE sf.IsCorrente = 1 OPTION (MAXDOP 8);';
        EXEC sys.sp_executesql @sql;
        DECLARE @RowsCorrenti BIGINT = (SELECT COUNT_BIG(*) FROM Certificazione.CertificazioneSede);

        DROP TABLE IF EXISTS ImportSIAC.wrk_SedePairing;
        SET @sql = N';WITH SfCur AS (
            SELECT sf.ChiaveBusinessHash, sf.SedeId, sf.SedeKeyNull,
                   sf.AmbitoIta, sf.AmbitoEng, sf.DataScadenzaSede, sf.DataInizioValiditaSede,
                   c.CertificazioneId,
                   ROW_NUMBER() OVER (PARTITION BY c.CertificazioneId, ISNULL(sf.SedeId,-1),
                        ISNULL(sf.AmbitoIta,N''''), ISNULL(sf.AmbitoEng,N''''),
                        ISNULL(sf.DataScadenzaSede,''19000101''), sf.DataInizioValiditaSede
                        ORDER BY sf.SedeKeyNull) AS rn
            FROM ImportSIAC.wrk_Sede_Final sf
            JOIN Certificazione.Certificazione c ON c.ChiaveBusinessHash = sf.ChiaveBusinessHash
            WHERE sf.IsCorrente = 1
        ), CsCur AS (
            SELECT cs.CertificazioneSedeId, cs.CertificazioneId, cs.SedeId,
                   cs.AmbitoIta, cs.AmbitoEng, cs.DataScadenzaSede, cs.DataInizioValidita,
                   ROW_NUMBER() OVER (PARTITION BY cs.CertificazioneId, ISNULL(cs.SedeId,-1),
                        ISNULL(cs.AmbitoIta,N''''), ISNULL(cs.AmbitoEng,N''''),
                        ISNULL(cs.DataScadenzaSede,''19000101''), cs.DataInizioValidita
                        ORDER BY cs.CertificazioneSedeId) AS rn
            FROM Certificazione.CertificazioneSede cs
        )
        SELECT s.ChiaveBusinessHash,
               ISNULL(CONVERT(VARCHAR(20), s.SedeId),''NULL'') AS SedeKey,
               s.SedeKeyNull, k.CertificazioneSedeId
        INTO ImportSIAC.wrk_SedePairing
        FROM SfCur s
        JOIN CsCur k ON k.CertificazioneId = s.CertificazioneId
            AND ISNULL(k.SedeId,-1) = ISNULL(s.SedeId,-1)
            AND ISNULL(k.AmbitoIta,N'''') = ISNULL(s.AmbitoIta,N'''')
            AND ISNULL(k.AmbitoEng,N'''') = ISNULL(s.AmbitoEng,N'''')
            AND ISNULL(k.DataScadenzaSede,''19000101'') = ISNULL(s.DataScadenzaSede,''19000101'')
            AND k.DataInizioValidita = s.DataInizioValiditaSede
            AND k.rn = s.rn
        OPTION (MAXDOP 8);';
        EXEC sys.sp_executesql @sql;

        IF (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_SedePairing) <> @RowsCorrenti
            THROW 51306, 'MIG_146b: pairing correnti incompleto.', 1;

        DECLARE @BaseSintetico BIGINT = 10000000 +
            ISNULL((SELECT MAX(CertificazioneSedeId) FROM Certificazione.CertificazioneSede),0);
        SET @sql = N'INSERT INTO ImportSIAC.wrk_SedePairing (ChiaveBusinessHash, SedeKey, SedeKeyNull, CertificazioneSedeId)
        SELECT x.ChiaveBusinessHash, x.SedeKey, x.SedeKeyNull,
               @Base + DENSE_RANK() OVER (ORDER BY x.ChiaveBusinessHash, x.SedeKey, x.SedeKeyNull)
        FROM (SELECT DISTINCT sf.ChiaveBusinessHash,
                     ISNULL(CONVERT(VARCHAR(20), sf.SedeId),''NULL'') AS SedeKey, sf.SedeKeyNull
              FROM ImportSIAC.wrk_Sede_Final sf
              WHERE NOT EXISTS (SELECT 1 FROM ImportSIAC.wrk_SedePairing p
                                WHERE p.ChiaveBusinessHash = sf.ChiaveBusinessHash
                                  AND p.SedeKey = ISNULL(CONVERT(VARCHAR(20), sf.SedeId),''NULL'')
                                  AND p.SedeKeyNull = sf.SedeKeyNull)) x;';
        EXEC sys.sp_executesql @sql, N'@Base bigint', @Base = @BaseSintetico;
        -- MIG_146e: nessun indice sul pairing (SedeKeyNull puo' superare i 900 byte, err 1946); hash join su heap adeguato (~1,3M righe).

        SET @sql = CONCAT(N'INSERT INTO ', @HT_Sede, N' WITH (TABLOCK) (
            CertificazioneSedeId, CertificazioneId, SedeId, AmbitoIta, AmbitoEng, DataScadenzaSede,
            DataCreazione, UniqueRowId, DataInizioValidita, DataFineValidita)
        SELECT p.CertificazioneSedeId, c.CertificazioneId, sf.SedeId,
            sf.AmbitoIta, sf.AmbitoEng, sf.DataScadenzaSede,
            SYSUTCDATETIME(), NEWID(), sf.DataInizioValiditaSede, sf.DataFineValiditaSede
        FROM ImportSIAC.wrk_Sede_Final sf
        JOIN Certificazione.Certificazione c ON c.ChiaveBusinessHash = sf.ChiaveBusinessHash
        JOIN ImportSIAC.wrk_SedePairing p ON p.ChiaveBusinessHash = sf.ChiaveBusinessHash
            AND p.SedeKey = ISNULL(CONVERT(VARCHAR(20), sf.SedeId), ''NULL'')
            AND p.SedeKeyNull = sf.SedeKeyNull
        WHERE sf.IsCorrente = 0
        OPTION (MAXDOP 8)');
        EXEC sys.sp_executesql @sql;
        DECLARE @RowsStoriche bigint = 0;
        SET @sql = N'SELECT @cnt = COUNT_BIG(*) FROM ' + @HT_Sede;
        EXEC sys.sp_executesql @sql, N'@cnt bigint OUTPUT', @cnt = @RowsStoriche OUTPUT;
        SET @Rows = @RowsCorrenti + @RowsStoriche;

        DECLARE @Bad BIGINT;
        SET @sql = N'SELECT @cnt = COUNT_BIG(*) FROM ' + @HT_Sede + N' WHERE DataInizioValidita >= DataFineValidita';
        EXEC sys.sp_executesql @sql, N'@cnt bigint OUTPUT', @cnt = @Bad OUTPUT;
        IF @Bad > 0 THROW 51307, 'MIG_146c: intervalli storici non positivi.', 1;
        SET @sql = N';WITH o AS (SELECT CertificazioneSedeId, DataInizioValidita,
                LAG(DataFineValidita) OVER (PARTITION BY CertificazioneSedeId ORDER BY DataInizioValidita) AS PrevFine
            FROM ' + @HT_Sede + N')
            SELECT @cnt = COUNT_BIG(*) FROM o WHERE PrevFine IS NOT NULL AND DataInizioValidita <= PrevFine';
        EXEC sys.sp_executesql @sql, N'@cnt bigint OUTPUT', @cnt = @Bad OUTPUT;
        IF @Bad > 0 THROW 51308, 'MIG_146c: sovrapposizioni nello storico per CertificazioneSedeId.', 1;

        COMMIT TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSede'))
            EXEC('ALTER TABLE Certificazione.CertificazioneSede ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)');
        SET @sql=N'ALTER TABLE Certificazione.CertificazioneSede SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_Sede+N',DATA_CONSISTENCY_CHECK=ON))';
        EXEC sp_executesql @sql;

        DECLARE fk_sede CURSOR LOCAL FAST_FORWARD FOR
            SELECT fk.name FROM sys.foreign_keys fk
            WHERE fk.parent_object_id=OBJECT_ID('Certificazione.CertificazioneSede')
              AND fk.referenced_object_id IN (OBJECT_ID('Certificazione.Certificazione'), OBJECT_ID('Organizzazioni.Sede'));
        OPEN fk_sede; FETCH NEXT FROM fk_sede INTO @fk_name;
        WHILE @@FETCH_STATUS=0 BEGIN
            SET @sql=N'ALTER TABLE Certificazione.CertificazioneSede WITH CHECK CHECK CONSTRAINT ['+@fk_name+N']'; EXEC sp_executesql @sql;
            FETCH NEXT FROM fk_sede INTO @fk_name;
        END; CLOSE fk_sede; DEALLOCATE fk_sede;

        SET @RowsAffected = @Rows;
        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 12B_SEDE: ', @Rows);

        DECLARE @SedeCorrentiRows BIGINT = (SELECT COUNT_BIG(*) FROM Certificazione.CertificazioneSede WHERE DataFineValidita >= '9999-12-31');
        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'12B_SEDE', @OutputTable=N'Certificazione.CertificazioneSede',
            @RowCountAtSave=@SedeCorrentiRows,
            @Notes=N'MIG_146: pairing per identita, id sintetici +10M, validazioni, CHECK=ON.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        BEGIN TRY
            IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSede') AND temporal_type=2)
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM sys.periods WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSede'))
                BEGIN
                    DECLARE @sqlRec NVARCHAR(MAX) = N'ALTER TABLE Certificazione.CertificazioneSede ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)';
                    EXEC sp_executesql @sqlRec;
                END;
                DECLARE @sqlRec2 NVARCHAR(MAX) = N'ALTER TABLE Certificazione.CertificazioneSede SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_Sede+N',DATA_CONSISTENCY_CHECK=OFF))';
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

