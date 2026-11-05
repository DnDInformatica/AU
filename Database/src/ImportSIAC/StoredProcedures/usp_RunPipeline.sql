 
-- ================================================================================
-- ImportSIAC.usp_RunPipeline (11088 caratteri)
-- ================================================================================
-- =============================================================================
-- ImportSIAC.usp_RunPipeline
-- Orchestratore robusto per il ciclo mensile BuildHistory su Azure SQL.
-- Gestisce: retry su errori transienti, ripristino stato temporal,
--           wake-up staging serverless, pulizia pre-run.
--
-- Ciclo mensile:
--   EXEC ImportSIAC.usp_RunPipeline;                          -- FULL
--   EXEC ImportSIAC.usp_RunPipeline @WindowMonths = 4;        -- finestra
--   EXEC ImportSIAC.usp_RunPipeline @SkipPopulate = 1;        -- solo BuildHistory
--   EXEC ImportSIAC.usp_RunPipeline @MaxRetries = 5;          -- piu tentativi
-- =============================================================================
CREATE   PROCEDURE ImportSIAC.usp_RunPipeline
    @WindowMonths    INT = NULL,      -- NULL=FULL, N=finestra mobile
    @SkipPopulate    BIT = 0,         -- 1=salta usp_PopulateWrkAllSrc
    @ResumePopulate  BIT = 0,         -- 1=riusa i chunk dominio/mese gia completi
    @MaxRetries      INT = 3,         -- tentativi per errori transienti
    @InitialDelaySec INT = 10,        -- delay iniziale tra retry (raddoppia)
    @MaxDop          INT = 4
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Retry INT, @ErrNum INT, @ErrMsg NVARCHAR(4000);
    DECLARE @DelaySec INT, @Delay VARCHAR(12);
    DECLARE @t0 DATETIME2 = SYSUTCDATETIME();
    DECLARE @sql NVARCHAR(MAX);
    -- MIG_130_RUNPIPELINE_RESUME_V1

    -- Lista errori transienti Azure SQL
    -- 4083:  connection recovered, rowcount lost
    -- 40197: service error processing request
    -- 40501: service busy
    -- 40613: database unavailable (auto-pause)
    -- 49918: insufficient resources
    -- 49919/49920: too many operations
    -- 233:   connection lost
    -- 10928/10929: resource limit exceeded
    -- 10060: TCP connection timeout (staging auto-pause)
    DECLARE @TransientErrors TABLE (ErrNum INT PRIMARY KEY);
    INSERT INTO @TransientErrors VALUES (4083),(46834),(40197),(40501),(40613),(49918),(49919),(49920),(233),(10928),(10929),(10060);

    PRINT '=== ImportSIAC.usp_RunPipeline ===';
    PRINT CONCAT('Parametri: WindowMonths=', ISNULL(CAST(@WindowMonths AS VARCHAR),'FULL'),
                 ' SkipPopulate=', @SkipPopulate,
                 ' ResumePopulate=', @ResumePopulate,
                 ' MaxRetries=', @MaxRetries,
                 ' MaxDop=', @MaxDop);

    -- =================================================================
    -- FASE 1: WAKE-UP STAGING (se non skip populate)
    -- =================================================================
    IF @SkipPopulate = 0
    BEGIN
        PRINT '--- Wake-up staging ---';
        SET @Retry = 0;
        WHILE @Retry <= @MaxRetries
        BEGIN
            BEGIN TRY
                EXEC sp_executesql N'SELECT TOP 1 RawId FROM ImportSIAC.Ext_PP_Flat';
                PRINT 'Staging attivo.';
                SET @Retry = @MaxRetries + 1; -- exit loop
            END TRY
            BEGIN CATCH
                SET @ErrNum = ERROR_NUMBER();
                SET @ErrMsg = LEFT(ERROR_MESSAGE(), 500);
                SET @Retry += 1;
                IF @Retry <= @MaxRetries
                BEGIN
                    SET @DelaySec = @InitialDelaySec * POWER(2, @Retry - 1);
                    IF @DelaySec > 120 SET @DelaySec = 120;
                    SET @Delay = '00:' + RIGHT('0' + CAST(@DelaySec / 60 AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(@DelaySec % 60 AS VARCHAR), 2);
                    PRINT CONCAT('  Staging non risponde (ERR ', @ErrNum, '). Retry ', @Retry, '/', @MaxRetries, ' tra ', @DelaySec, 's...');
                    WAITFOR DELAY @Delay;
                END
                ELSE
                BEGIN
                    PRINT CONCAT('FATAL: staging non raggiungibile dopo ', @MaxRetries, ' tentativi.');
                    THROW;
                END;
            END CATCH;
        END;

        -- =================================================================
        -- FASE 2: POPULATE wrk_All_Src
        -- =================================================================
        PRINT '--- usp_PopulateWrkAllSrc ---';
        SET @Retry = 0;

        WHILE @Retry <= @MaxRetries
        BEGIN
            BEGIN TRY
                IF @WindowMonths IS NULL
                    EXEC ImportSIAC.usp_PopulateWrkAllSrc @MaxDop = @MaxDop, @ResumeExisting = @ResumePopulate, @ChunkMaxRetries = @MaxRetries, @ChunkInitialDelaySec = @InitialDelaySec;
                ELSE
                    EXEC ImportSIAC.usp_PopulateWrkAllSrc @WindowMonths = @WindowMonths, @MaxDop = @MaxDop, @ResumeExisting = @ResumePopulate, @ChunkMaxRetries = @MaxRetries, @ChunkInitialDelaySec = @InitialDelaySec;
                PRINT 'Populate completato.';
                SET @Retry = @MaxRetries + 1;
            END TRY
            BEGIN CATCH
                SET @ErrNum = ERROR_NUMBER();
                SET @ErrMsg = LEFT(ERROR_MESSAGE(), 500);
                IF EXISTS (SELECT 1 FROM @TransientErrors WHERE ErrNum = @ErrNum) AND @Retry < @MaxRetries
                BEGIN
                    SET @Retry += 1;
                    SET @ResumePopulate = 1;
                    SET @DelaySec = @InitialDelaySec * POWER(2, @Retry - 1);
                    IF @DelaySec > 120 SET @DelaySec = 120;
                    SET @Delay = '00:' + RIGHT('0' + CAST(@DelaySec / 60 AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(@DelaySec % 60 AS VARCHAR), 2);
                    PRINT CONCAT('  Transient ERR ', @ErrNum, ': ', @ErrMsg);
                    PRINT CONCAT('  Retry ', @Retry, '/', @MaxRetries, ' tra ', @DelaySec, 's...');
                    WAITFOR DELAY @Delay;
                END
                ELSE
                BEGIN
                    PRINT CONCAT('FATAL Populate: ERR ', @ErrNum, ': ', @ErrMsg);
                    THROW;
                END;
            END CATCH;
        END;
    END
    ELSE
        PRINT '--- Populate SKIPPED ---';

    -- =================================================================
    -- FASE 3: ENSURE TEMPORAL ON (prerequisito per BuildHistory)
    -- =================================================================
    PRINT '--- Ensure temporal ON ---';
    DECLARE @tbl_name NVARCHAR(200), @hist_name NVARCHAR(200);
    DECLARE @temporal_pairs TABLE (tbl NVARCHAR(200), hist NVARCHAR(200));
    INSERT INTO @temporal_pairs VALUES
        ('Certificazione.Certificazione', 'Certificazione.CertificazioneStorico'),
        ('Certificazione.CertificazioneSG', 'Certificazione.CertificazioneSGStorico'),
        ('Certificazione.CertificazionePRD', 'Certificazione.CertificazionePRDStorico'),
        ('Certificazione.CertificazioneFPC', 'Certificazione.CertificazioneFPCStorico'),
        ('Certificazione.CertificazioneSede', 'Certificazione.CertificazioneSedeStorico');

    DECLARE cur_temp CURSOR LOCAL FAST_FORWARD FOR SELECT tbl, hist FROM @temporal_pairs;
    OPEN cur_temp;
    FETCH NEXT FROM cur_temp INTO @tbl_name, @hist_name;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Verifica se temporal è già ON
        IF NOT EXISTS (
            SELECT 1 FROM sys.tables t
            JOIN sys.schemas s ON s.schema_id = t.schema_id
            WHERE QUOTENAME(s.name) + '.' + QUOTENAME(t.name) = QUOTENAME(PARSENAME(@tbl_name,2)) + '.' + QUOTENAME(PARSENAME(@tbl_name,1))
              AND t.temporal_type = 2
        )
        BEGIN
            -- Assicura versioning OFF prima di tutto
            BEGIN TRY
                SET @sql = N'ALTER TABLE ' + @tbl_name + N' SET (SYSTEM_VERSIONING = OFF)';
                EXEC sp_executesql @sql;
            END TRY BEGIN CATCH END CATCH;

            -- Assicura period rimosso
            BEGIN TRY
                SET @sql = N'ALTER TABLE ' + @tbl_name + N' DROP PERIOD FOR SYSTEM_TIME';
                EXEC sp_executesql @sql;
            END TRY BEGIN CATCH END CATCH;

            -- Aggiungi period
            BEGIN TRY
                SET @sql = N'ALTER TABLE ' + @tbl_name + N' ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)';
                EXEC sp_executesql @sql;
            END TRY BEGIN CATCH END CATCH;

            -- Riattiva versioning
            SET @sql = N'ALTER TABLE ' + @tbl_name + N' SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE=' + @hist_name + N', DATA_CONSISTENCY_CHECK=OFF))';
            EXEC sp_executesql @sql;

            PRINT CONCAT('  ', @tbl_name, ' temporal riattivato.');
        END
        ELSE
            PRINT CONCAT('  ', @tbl_name, ' temporal OK.');

        FETCH NEXT FROM cur_temp INTO @tbl_name, @hist_name;
    END;
    CLOSE cur_temp; DEALLOCATE cur_temp;

    -- =================================================================
    -- FASE 4: BUILD HISTORY (con retry)
    -- =================================================================
    PRINT '--- usp_BuildHistory_All ---';
    SET @Retry = 0;
    WHILE @Retry <= @MaxRetries
    BEGIN
        -- Ensure temporal prima di ogni tentativo
        DECLARE cur_re CURSOR LOCAL FAST_FORWARD FOR SELECT tbl, hist FROM @temporal_pairs;
        OPEN cur_re;
        FETCH NEXT FROM cur_re INTO @tbl_name, @hist_name;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF NOT EXISTS (
                SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
                WHERE QUOTENAME(s.name)+'.'+QUOTENAME(t.name) = QUOTENAME(PARSENAME(@tbl_name,2))+'.'+QUOTENAME(PARSENAME(@tbl_name,1))
                  AND t.temporal_type = 2)
            BEGIN
                BEGIN TRY SET @sql=N'ALTER TABLE '+@tbl_name+N' SET (SYSTEM_VERSIONING=OFF)'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
                BEGIN TRY SET @sql=N'ALTER TABLE '+@tbl_name+N' DROP PERIOD FOR SYSTEM_TIME'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
                BEGIN TRY SET @sql=N'ALTER TABLE '+@tbl_name+N' ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql; END TRY BEGIN CATCH END CATCH;
                SET @sql=N'ALTER TABLE '+@tbl_name+N' SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@hist_name+N',DATA_CONSISTENCY_CHECK=OFF))'; EXEC sp_executesql @sql;
            END;
            FETCH NEXT FROM cur_re INTO @tbl_name, @hist_name;
        END;
        CLOSE cur_re; DEALLOCATE cur_re;

        BEGIN TRY
            EXEC ImportSIAC.usp_BuildHistory_All @MaxDop = @MaxDop;
            PRINT 'BuildHistory completato.';
            SET @Retry = @MaxRetries + 1;
        END TRY
        BEGIN CATCH
            SET @ErrNum = ERROR_NUMBER();
            SET @ErrMsg = LEFT(ERROR_MESSAGE(), 500);
            IF EXISTS (SELECT 1 FROM @TransientErrors WHERE ErrNum = @ErrNum) AND @Retry < @MaxRetries
            BEGIN
                SET @Retry += 1;
                SET @DelaySec = @InitialDelaySec * POWER(2, @Retry - 1);
                IF @DelaySec > 120 SET @DelaySec = 120;
                SET @Delay = '00:' + RIGHT('0' + CAST(@DelaySec / 60 AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(@DelaySec % 60 AS VARCHAR), 2);
                PRINT CONCAT('  Transient ERR ', @ErrNum, ': ', @ErrMsg);
                PRINT CONCAT('  Retry ', @Retry, '/', @MaxRetries, ' tra ', @DelaySec, 's...');
                WAITFOR DELAY @Delay;
            END
            ELSE
            BEGIN
                PRINT CONCAT('FATAL BuildHistory: ERR ', @ErrNum, ': ', @ErrMsg);
                THROW;
            END;
        END CATCH;
    END;

    EXEC ImportSIAC.usp_BH_VerificaIntegritaFinale;

    PRINT CONCAT('=== PIPELINE COMPLETATA in ', DATEDIFF(SECOND, @t0, SYSUTCDATETIME()), 's ===');
END;

GO

