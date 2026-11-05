-- =============================================================================
-- ImportSIAC.usp_PopulateWrkAllSrc v3 (MIG_131)
-- MIG_164U_UNIFORM_SOURCE_CONTRACT_V1
-- Modifiche rispetto a v2:
--  1. Liste mesi per dominio derivate dalla sorgente (pushdown DISTINCT):
--     eliminati i probe remoti sui mesi vuoti (~197 per full load).
--  2. FULL mode: drop dinamico di TUTTI gli indici NC su wrk_All_Src
--     (v2 cercava nomi inesistenti): CCI senza NC = minimal logging reale
--     con TABLOCK e niente manutenzione indici riga-per-riga.
--  3. RESUME via ImportSIAC.wrk_Populate_Checkpoint (seed automatico dai
--     dati esistenti per compatibilita' con run legacy).
--  4. Ricreazione a fine load di IX_wrk_All_Src_DominioPeriodo e di
--     IX_wrkAllSrc_FPC_ProfCode in versione FILTRATA.
-- =============================================================================
CREATE   PROCEDURE ImportSIAC.usp_PopulateWrkAllSrc
    @WindowMonths         INT = NULL,
    @MaxDop               INT = 4,
    @ResumeExisting       BIT = 0,
    @ChunkMaxRetries      INT = 5,
    @ChunkInitialDelaySec INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @StatoAttivo   INT = (SELECT StatoCertificazioneId FROM Certificazione.StatoCertificazione WHERE Codice='ATTIVO'   AND DataCancellazione IS NULL);
    DECLARE @StatoRevocato INT = (SELECT StatoCertificazioneId FROM Certificazione.StatoCertificazione WHERE Codice='REVOCATO' AND DataCancellazione IS NULL);
    IF @StatoAttivo IS NULL OR @StatoRevocato IS NULL
    BEGIN RAISERROR('Lookup StatoCertificazione ATTIVO/REVOCATO mancanti.',16,1); RETURN; END;

    DECLARE @tStart DATETIME2 = SYSUTCDATETIME(), @t0 DATETIME2;
    DECLARE @Y SMALLINT, @M TINYINT, @n BIGINT;
    DECLARE @Threshold INT = 0;
    DECLARE @Mode NVARCHAR(30) = 'FULL';
    DECLARE @ChunkRetry INT, @ChunkErr INT, @ChunkDelaySec INT;
    DECLARE @ChunkDone BIT;
    DECLARE @ChunkErrMsg NVARCHAR(500), @ChunkDelay VARCHAR(12);
    IF @ChunkMaxRetries < 0 OR @ChunkMaxRetries > 20
        THROW 63020, '@ChunkMaxRetries deve essere compreso tra 0 e 20.', 1;
    IF @ChunkInitialDelaySec < 1 OR @ChunkInitialDelaySec > 120
        THROW 63021, '@ChunkInitialDelaySec deve essere compreso tra 1 e 120.', 1;

    -- =================================================================
    -- SOGLIA FINESTRA MOBILE
    -- =================================================================
    IF @WindowMonths IS NOT NULL AND @WindowMonths > 0
    BEGIN
        SET @Mode = CONCAT('WINDOW ', @WindowMonths, ' mesi');
        DECLARE @LatestYear INT, @LatestMonth INT;
        SELECT TOP 1 @LatestYear=SnapshotYear, @LatestMonth=SnapshotMonth
        FROM ImportSIAC.Ext_PP_Flat ORDER BY SnapshotYear DESC, SnapshotMonth DESC;
        IF @LatestYear IS NULL BEGIN RAISERROR('Staging vuoto.',16,1); RETURN; END;
        DECLARE @tot INT = @LatestYear*12+(@LatestMonth-1)-(@WindowMonths-1);
        SET @Threshold = (@tot/12)*100+(@tot%12+1);
        PRINT CONCAT('Modalita: ',@Mode,' | soglia >= ',@Threshold/100,'-',RIGHT('0'+CAST(@Threshold%100 AS VARCHAR),2));
    END
    ELSE
        PRINT 'Modalita: FULL reload';

    -- =================================================================
    -- LISTE MESI PER DOMINIO (dalla sorgente, pushdown remoto) - MIG_131
    -- =================================================================
    DECLARE @MonthsPP  TABLE (SnapshotYear SMALLINT, SnapshotMonth TINYINT, PRIMARY KEY (SnapshotYear, SnapshotMonth));
    DECLARE @MonthsPRD TABLE (SnapshotYear SMALLINT, SnapshotMonth TINYINT, PRIMARY KEY (SnapshotYear, SnapshotMonth));
    DECLARE @MonthsFPC TABLE (SnapshotYear SMALLINT, SnapshotMonth TINYINT, PRIMARY KEY (SnapshotYear, SnapshotMonth));

    INSERT INTO @MonthsPP
    SELECT DISTINCT SnapshotYear, SnapshotMonth FROM ImportSIAC.Ext_PP_Flat
    WHERE @Threshold = 0 OR SnapshotYear*100+SnapshotMonth >= @Threshold;

    INSERT INTO @MonthsPRD
    SELECT DISTINCT SnapshotYear, SnapshotMonth FROM ImportSIAC.Ext_PRD_Flat_Status
    WHERE @Threshold = 0 OR SnapshotYear*100+SnapshotMonth >= @Threshold;

    INSERT INTO @MonthsFPC
    SELECT DISTINCT SnapshotYear, SnapshotMonth FROM ImportSIAC.Ext_FPC_Flat_Status
    WHERE @Threshold = 0 OR SnapshotYear*100+SnapshotMonth >= @Threshold;

    DECLARE @CntPP INT = (SELECT COUNT(*) FROM @MonthsPP);
    DECLARE @CntPRD INT = (SELECT COUNT(*) FROM @MonthsPRD);
    DECLARE @CntFPC INT = (SELECT COUNT(*) FROM @MonthsFPC);
    PRINT CONCAT('Mesi con dati: PP=', @CntPP, ' PRD=', @CntPRD, ' FPC=', @CntFPC);

    -- MIG_128_SOURCE_GATE_V2: implicito nelle liste mesi
    IF @CntPP = 0 OR @CntPRD = 0 OR @CntFPC = 0
    BEGIN
        DECLARE @MissingSources nvarchar(200) = CONCAT(
            CASE WHEN @CntPP  = 0 THEN N' PP'  ELSE N'' END,
            CASE WHEN @CntPRD = 0 THEN N' PRD' ELSE N'' END,
            CASE WHEN @CntFPC = 0 THEN N' FPC' ELSE N'' END);
        DECLARE @SourceGateError nvarchar(2048) =
            CONCAT(N'Populate annullata prima di modificare wrk_All_Src. Sorgenti vuote nella finestra:',
                   @MissingSources, N'.');
        THROW 62810, @SourceGateError, 1;
    END;
    PRINT 'Source gate PP/PRD/FPC: OK';

    -- =================================================================
    -- PREPARAZIONE TARGET + CHECKPOINT - MIG_131
    -- =================================================================
    IF COALESCE(@ResumeExisting, 0) = 1
    BEGIN
        SET @Mode = CONCAT(@Mode, ' RESUME');
        -- Seed checkpoint dai dati gia' presenti (compatibilita' run legacy)
        INSERT INTO ImportSIAC.wrk_Populate_Checkpoint (Dominio, SnapshotYear, SnapshotMonth, RowsInserted)
        SELECT w.Dominio, w.SnapshotYear, w.SnapshotMonth, COUNT_BIG(*)
        FROM ImportSIAC.wrk_All_Src w
        WHERE NOT EXISTS (SELECT 1 FROM ImportSIAC.wrk_Populate_Checkpoint c
                          WHERE c.Dominio=w.Dominio AND c.SnapshotYear=w.SnapshotYear AND c.SnapshotMonth=w.SnapshotMonth)
        GROUP BY w.Dominio, w.SnapshotYear, w.SnapshotMonth;
        PRINT CONCAT('--- RESUME: checkpoint sincronizzato (+', @@ROWCOUNT, ' mesi), TRUNCATE/DELETE saltati ---');
    END
    ELSE IF @WindowMonths IS NULL
    BEGIN
        PRINT '--- TRUNCATE wrk_All_Src + checkpoint ---';
        TRUNCATE TABLE ImportSIAC.wrk_All_Src;
        TRUNCATE TABLE ImportSIAC.wrk_Populate_Checkpoint;
    END
    ELSE
    BEGIN
        PRINT '--- DELETE finestra ---';
        DELETE FROM ImportSIAC.wrk_All_Src WHERE SnapshotYear*100+SnapshotMonth >= @Threshold;
        DELETE FROM ImportSIAC.wrk_Populate_Checkpoint WHERE SnapshotYear*100+SnapshotMonth >= @Threshold;
        PRINT '  DELETE finestra completato';
    END;

    -- FULL mode: drop dinamico di TUTTI gli indici NC (nomi qualunque) - MIG_131
    IF @WindowMonths IS NULL
    BEGIN
        DECLARE @sqlDrop NVARCHAR(MAX) = N'';
        SELECT @sqlDrop += N'DROP INDEX ' + QUOTENAME(name) + N' ON ImportSIAC.wrk_All_Src;'
        FROM sys.indexes
        WHERE object_id = OBJECT_ID('ImportSIAC.wrk_All_Src') AND type = 2; -- MIG_136: solo NC rowstore, il CCI resta
        IF @sqlDrop <> N''
        BEGIN
            EXEC sys.sp_executesql @sqlDrop;
            PRINT 'Indici NC droppati: full load su CCI senza NC (minimal logging con TABLOCK)';
        END;
    END;

    -- =================================================================
    -- PP - chunk mensili con TABLOCK
    -- =================================================================
    SET @t0 = SYSUTCDATETIME();
    PRINT '--- INSERT PP (chunk mensili) ---';
    DECLARE @ppTotal BIGINT = 0, @ppMonth INT = 0;

    DECLARE cur_pp CURSOR LOCAL FAST_FORWARD FOR
        SELECT SnapshotYear, SnapshotMonth FROM @MonthsPP ORDER BY SnapshotYear, SnapshotMonth;
    OPEN cur_pp;
    FETCH NEXT FROM cur_pp INTO @Y, @M;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ChunkRetry = 0;
        SET @ChunkDone = 0;
        IF EXISTS (SELECT 1 FROM ImportSIAC.wrk_Populate_Checkpoint
                   WHERE Dominio = N'PP' AND SnapshotYear = @Y AND SnapshotMonth = @M)
        BEGIN
            SET @ChunkDone = 1;
            PRINT CONCAT('  PP ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2), ': RESUMED');
        END;

        WHILE @ChunkDone = 0
        BEGIN
            BEGIN TRY
        INSERT INTO ImportSIAC.wrk_All_Src WITH (TABLOCK) (
            RawId, Dominio, SnapshotYear, SnapshotMonth, NumeroCertificato, codente,
            DataPrimoRilascio, DataEmissione, DataScadenza, DataRevoca, Privato,
            norma_raw, siglaschema, StatoCertificazioneId, publication_date, insertdate,
            fiscal_code, vat_number, AmbitoIta, AmbitoEng, DataUltimoRinnovo,
            sede_address, sede_city, sede_zip, ScopoCertificato, NomeProdotto,
            SpecificaTecnica, enel_professional_profile, person_code, first_name,
            last_name, birth_date, birth_place, fpc_fiscal_code, professional_code_json,
            competence_level, foreigner_json, id_group_json, fpc_release_date,
            raw_company_name, raw_site_address, raw_site_city, raw_site_zip,
            raw_site_province, raw_site_country, raw_site_type,
            suspended, prev_cert_number, sector_code, sector_code_secondary_accredited,
            sector_code_secondary_notaccredited, source_record_id, source_archive_id,
            expired, region, site_description)
        SELECT
            v.RawId, 'PP', v.SnapshotYear, v.SnapshotMonth, v.NumeroCertificato, v.codente,
            v.DataPrimoRilascio, v.DataEmissione, v.DataScadenza, v.DataRevoca, v.Privato,
            v.norma_raw, v.siglaschema,
            CASE WHEN v.revoked=1 THEN @StatoRevocato ELSE @StatoAttivo END,
            v.publication_date, v.insertdate,
            NULLIF(CASE
                WHEN LTRIM(RTRIM(REPLACE(v.fiscal_code,CHAR(39),'')))='' AND NULLIF(v.json_piva,'') IS NOT NULL THEN v.json_piva
                WHEN LEN(LTRIM(RTRIM(REPLACE(v.fiscal_code,CHAR(39),'')))) BETWEEN 8 AND 10 AND LTRIM(RTRIM(REPLACE(v.fiscal_code,CHAR(39),''))) NOT LIKE '%[^0-9]%'
                    THEN RIGHT('00000000000'+LTRIM(RTRIM(REPLACE(v.fiscal_code,CHAR(39),''))),11)
                ELSE NULLIF(LTRIM(RTRIM(REPLACE(v.fiscal_code,CHAR(39),''))),'' )
            END,'00000000000'),
            NULLIF(CASE
                WHEN LTRIM(RTRIM(REPLACE(v.vat_number,CHAR(39),'')))='' AND NULLIF(v.json_piva,'') IS NOT NULL THEN v.json_piva
                WHEN LEN(LTRIM(RTRIM(REPLACE(v.vat_number,CHAR(39),'')))) BETWEEN 8 AND 10 AND LTRIM(RTRIM(REPLACE(v.vat_number,CHAR(39),''))) NOT LIKE '%[^0-9]%'
                    THEN RIGHT('00000000000'+LTRIM(RTRIM(REPLACE(v.vat_number,CHAR(39),''))),11)
                ELSE NULLIF(LTRIM(RTRIM(REPLACE(v.vat_number,CHAR(39),''))),'' )
            END,'00000000000'),
            v.scope_ita, v.scope_eng, v.DataUltimoRinnovo,
            v.json_address, v.json_city, v.json_zipcode,
            NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
            v.json_companyname, v.json_address, v.json_city, v.json_zipcode,
            v.json_province, v.json_country, v.json_sitetype,
            v.suspended, v.prev_cert_number, v.sector_code, v.sector_code_secondary_accredited, v.sector_code_secondary_notaccredited, v.source_record_id, v.source_archive_id, v.expired, v.region, v.site_description
        FROM ImportSIAC.Ext_PP_Flat v
        WHERE v.SnapshotYear=@Y AND v.SnapshotMonth=@M;
                SET @n = @@ROWCOUNT;
                INSERT INTO ImportSIAC.wrk_Populate_Checkpoint (Dominio, SnapshotYear, SnapshotMonth, RowsInserted)
                VALUES (N'PP', @Y, @M, @n);
                SET @ChunkDone = 1;
            END TRY
            BEGIN CATCH
                SET @ChunkErr = ERROR_NUMBER();
                SET @ChunkErrMsg = LEFT(ERROR_MESSAGE(), 500);
                IF @ChunkErr IN (4083,46834,40197,40501,40613,49918,49919,49920,233,10928,10929,10060)
                   AND @ChunkRetry < @ChunkMaxRetries
                BEGIN
                    IF EXISTS (SELECT 1 FROM ImportSIAC.wrk_All_Src
                               WHERE Dominio = N'PP' AND SnapshotYear = @Y AND SnapshotMonth = @M)
                    BEGIN
                        INSERT INTO ImportSIAC.wrk_Populate_Checkpoint (Dominio, SnapshotYear, SnapshotMonth, RowsInserted)
                        SELECT N'PP', @Y, @M, COUNT_BIG(*) FROM ImportSIAC.wrk_All_Src
                        WHERE Dominio = N'PP' AND SnapshotYear = @Y AND SnapshotMonth = @M;
                        SET @ChunkDone = 1;
                        PRINT CONCAT('  PP ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2),
                                     ': commit rilevato dopo ERR ', @ChunkErr, '.');
                    END
                    ELSE
                    BEGIN
                        SET @ChunkRetry += 1;
                        SET @ChunkDelaySec = @ChunkInitialDelaySec * POWER(2, @ChunkRetry - 1);
                        IF @ChunkDelaySec > 120 SET @ChunkDelaySec = 120;
                        SET @ChunkDelay = '00:' + RIGHT('0' + CAST(@ChunkDelaySec / 60 AS VARCHAR), 2)
                                        + ':' + RIGHT('0' + CAST(@ChunkDelaySec % 60 AS VARCHAR), 2);
                        PRINT CONCAT('  PP ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2),
                                     ': transient ERR ', @ChunkErr, ': ', @ChunkErrMsg);
                        PRINT CONCAT('  retry chunk ', @ChunkRetry, '/', @ChunkMaxRetries,
                                     ' tra ', @ChunkDelaySec, 's...');
                        WAITFOR DELAY @ChunkDelay;
                    END;
                END
                ELSE
                    THROW;
            END CATCH;
        END;

        SET @ppMonth = @ppMonth + 1;
        PRINT CONCAT('  PP ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2),
                     ': completato (', @ppMonth, '/', @CntPP, ')');
        FETCH NEXT FROM cur_pp INTO @Y, @M;
    END;
    CLOSE cur_pp; DEALLOCATE cur_pp;
    PRINT CONCAT('PP caricamento completato in ', DATEDIFF(SECOND,@t0,SYSUTCDATETIME()), 's');

    -- =================================================================
    -- PRD - chunk mensili con TABLOCK
    -- =================================================================
    SET @t0 = SYSUTCDATETIME();
    PRINT '--- INSERT PRD (chunk mensili) ---';
    DECLARE @prdTotal BIGINT = 0, @prdMonth INT = 0;

    DECLARE cur_prd CURSOR LOCAL FAST_FORWARD FOR
        SELECT SnapshotYear, SnapshotMonth FROM @MonthsPRD ORDER BY SnapshotYear, SnapshotMonth;
    OPEN cur_prd;
    FETCH NEXT FROM cur_prd INTO @Y, @M;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ChunkRetry = 0;
        SET @ChunkDone = 0;
        IF EXISTS (SELECT 1 FROM ImportSIAC.wrk_Populate_Checkpoint
                   WHERE Dominio = N'PRD' AND SnapshotYear = @Y AND SnapshotMonth = @M)
        BEGIN
            SET @ChunkDone = 1;
            PRINT CONCAT('  PRD ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2), ': RESUMED');
        END;

        WHILE @ChunkDone = 0
        BEGIN
            BEGIN TRY
        INSERT INTO ImportSIAC.wrk_All_Src WITH (TABLOCK) (
            RawId, Dominio, SnapshotYear, SnapshotMonth, NumeroCertificato, codente,
            DataPrimoRilascio, DataEmissione, DataScadenza, DataRevoca, Privato,
            norma_raw, siglaschema, StatoCertificazioneId, publication_date, insertdate,
            fiscal_code, vat_number, AmbitoIta, AmbitoEng, DataUltimoRinnovo,
            sede_address, sede_city, sede_zip, ScopoCertificato, NomeProdotto,
            SpecificaTecnica, enel_professional_profile, person_code, first_name,
            last_name, birth_date, birth_place, fpc_fiscal_code, professional_code_json,
            competence_level, foreigner_json, id_group_json, fpc_release_date,
            raw_company_name, raw_site_address, raw_site_city, raw_site_zip,
            raw_site_province, raw_site_country, raw_site_type,
            source_record_id, region)
        SELECT
            v.RawId, 'PRD', v.SnapshotYear, v.SnapshotMonth, v.NumeroCertificato, v.codente,
            v.DataPrimoRilascio, v.DataPrimoRilascio, v.DataScadenza,
            CASE WHEN v.source_status_resolved = 1 AND v.revoked = 1
                       AND (COALESCE(v.odc_revoke_date, v.revoked_date) IS NULL
                            OR COALESCE(v.odc_revoke_date, v.revoked_date)
                               <= DATEFROMPARTS(v.SnapshotYear, v.SnapshotMonth, 1))
                 THEN COALESCE(v.odc_revoke_date, v.revoked_date) END,
            CAST(0 AS BIT),
            v.norma_raw, v.siglaschema,
            CASE WHEN v.source_status_resolved = 1 AND v.revoked = 1
                       AND (COALESCE(v.odc_revoke_date, v.revoked_date) IS NULL
                            OR COALESCE(v.odc_revoke_date, v.revoked_date)
                               <= DATEFROMPARTS(v.SnapshotYear, v.SnapshotMonth, 1))
                 THEN @StatoRevocato ELSE @StatoAttivo END,
            v.LoadDts, v.LoadDts,
            NULLIF(LTRIM(RTRIM(REPLACE(v.fiscal_code,CHAR(39),''))),'' ),
            NULLIF(LTRIM(RTRIM(REPLACE(v.vat_number,CHAR(39),''))),'' ),
            NULL, NULL, v.DataPrimoRilascio, NULL, NULL, NULL,
            v.cert_purpose, v.cert_product_name, v.enel_technical_specification, v.enel_professional_profile,
            NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
            v.company_name, v.json_site_address, v.json_site_city, v.json_site_zip,
            v.json_site_province, v.json_site_country, v.json_site_type,
            v.source_record_id, v.region
        FROM ImportSIAC.Ext_PRD_Flat_Status v
        WHERE v.SnapshotYear=@Y AND v.SnapshotMonth=@M;
                SET @n = @@ROWCOUNT;
                INSERT INTO ImportSIAC.wrk_Populate_Checkpoint (Dominio, SnapshotYear, SnapshotMonth, RowsInserted)
                VALUES (N'PRD', @Y, @M, @n);
                SET @ChunkDone = 1;
            END TRY
            BEGIN CATCH
                SET @ChunkErr = ERROR_NUMBER();
                SET @ChunkErrMsg = LEFT(ERROR_MESSAGE(), 500);
                IF @ChunkErr IN (4083,46834,40197,40501,40613,49918,49919,49920,233,10928,10929,10060)
                   AND @ChunkRetry < @ChunkMaxRetries
                BEGIN
                    IF EXISTS (SELECT 1 FROM ImportSIAC.wrk_All_Src
                               WHERE Dominio = N'PRD' AND SnapshotYear = @Y AND SnapshotMonth = @M)
                    BEGIN
                        INSERT INTO ImportSIAC.wrk_Populate_Checkpoint (Dominio, SnapshotYear, SnapshotMonth, RowsInserted)
                        SELECT N'PRD', @Y, @M, COUNT_BIG(*) FROM ImportSIAC.wrk_All_Src
                        WHERE Dominio = N'PRD' AND SnapshotYear = @Y AND SnapshotMonth = @M;
                        SET @ChunkDone = 1;
                        PRINT CONCAT('  PRD ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2),
                                     ': commit rilevato dopo ERR ', @ChunkErr, '.');
                    END
                    ELSE
                    BEGIN
                        SET @ChunkRetry += 1;
                        SET @ChunkDelaySec = @ChunkInitialDelaySec * POWER(2, @ChunkRetry - 1);
                        IF @ChunkDelaySec > 120 SET @ChunkDelaySec = 120;
                        SET @ChunkDelay = '00:' + RIGHT('0' + CAST(@ChunkDelaySec / 60 AS VARCHAR), 2)
                                        + ':' + RIGHT('0' + CAST(@ChunkDelaySec % 60 AS VARCHAR), 2);
                        PRINT CONCAT('  PRD ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2),
                                     ': transient ERR ', @ChunkErr, ': ', @ChunkErrMsg);
                        PRINT CONCAT('  retry chunk ', @ChunkRetry, '/', @ChunkMaxRetries,
                                     ' tra ', @ChunkDelaySec, 's...');
                        WAITFOR DELAY @ChunkDelay;
                    END;
                END
                ELSE
                    THROW;
            END CATCH;
        END;

        SET @prdMonth = @prdMonth + 1;
        PRINT CONCAT('  PRD ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2),
                     ': completato (', @prdMonth, '/', @CntPRD, ')');
        FETCH NEXT FROM cur_prd INTO @Y, @M;
    END;
    CLOSE cur_prd; DEALLOCATE cur_prd;
    PRINT CONCAT('PRD caricamento completato in ', DATEDIFF(SECOND,@t0,SYSUTCDATETIME()), 's');

    -- =================================================================
    -- FPC - chunk mensili con TABLOCK
    -- =================================================================
    SET @t0 = SYSUTCDATETIME();
    PRINT '--- INSERT FPC (chunk mensili) ---';
    DECLARE @fpcTotal BIGINT = 0, @fpcMonth INT = 0;

    DECLARE cur_fpc CURSOR LOCAL FAST_FORWARD FOR
        SELECT SnapshotYear, SnapshotMonth FROM @MonthsFPC ORDER BY SnapshotYear, SnapshotMonth;
    OPEN cur_fpc;
    FETCH NEXT FROM cur_fpc INTO @Y, @M;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @ChunkRetry = 0;
        SET @ChunkDone = 0;
        IF EXISTS (SELECT 1 FROM ImportSIAC.wrk_Populate_Checkpoint
                   WHERE Dominio = N'FPC' AND SnapshotYear = @Y AND SnapshotMonth = @M)
        BEGIN
            SET @ChunkDone = 1;
            PRINT CONCAT('  FPC ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2), ': RESUMED');
        END;

        WHILE @ChunkDone = 0
        BEGIN
            BEGIN TRY
        INSERT INTO ImportSIAC.wrk_All_Src WITH (TABLOCK) (
            RawId, Dominio, SnapshotYear, SnapshotMonth, NumeroCertificato, codente,
            DataPrimoRilascio, DataEmissione, DataScadenza, DataRevoca, Privato,
            norma_raw, siglaschema, StatoCertificazioneId, publication_date, insertdate,
            fiscal_code, vat_number, AmbitoIta, AmbitoEng, DataUltimoRinnovo,
            sede_address, sede_city, sede_zip, ScopoCertificato, NomeProdotto,
            SpecificaTecnica, enel_professional_profile, person_code, first_name,
            last_name, birth_date, birth_place, fpc_fiscal_code, professional_code_json,
            competence_level, foreigner_json, id_group_json, fpc_release_date,
            raw_company_name, raw_site_address, raw_site_city, raw_site_zip,
            raw_site_province, raw_site_country, raw_site_type,
            source_record_id)
        SELECT
            v.RawId, 'FPC', v.SnapshotYear, v.SnapshotMonth, v.NumeroCertificato, v.codente,
            v.DataPrimoRilascio, v.DataEmissione, v.DataScadenza,
            CASE WHEN v.source_status_resolved = 1 AND v.revoked = 1
                       AND (COALESCE(v.odc_revoke_date, v.revoked_date) IS NULL
                            OR COALESCE(v.odc_revoke_date, v.revoked_date)
                               <= DATEFROMPARTS(v.SnapshotYear, v.SnapshotMonth, 1))
                 THEN COALESCE(v.odc_revoke_date, v.revoked_date) END,
            v.Privato,
            v.norma_raw, v.siglaschema,
            CASE WHEN v.source_status_resolved = 1 AND v.revoked = 1
                       AND (COALESCE(v.odc_revoke_date, v.revoked_date) IS NULL
                            OR COALESCE(v.odc_revoke_date, v.revoked_date)
                               <= DATEFROMPARTS(v.SnapshotYear, v.SnapshotMonth, 1))
                 THEN @StatoRevocato ELSE @StatoAttivo END,
            v.LoadDts, v.LoadDts,
            NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
            v.person_code, v.first_name, v.last_name,
            v.birth_date, v.birth_place, v.fpc_fiscal_code,
            v.json_professional_code, v.competence_level,
            v.json_foreigner, v.json_id_group,
            v.DataEmissione,
            NULL,NULL,NULL,NULL,NULL,NULL,NULL, v.source_record_id
        FROM ImportSIAC.Ext_FPC_Flat_Status v
        WHERE v.SnapshotYear=@Y AND v.SnapshotMonth=@M;
                SET @n = @@ROWCOUNT;
                INSERT INTO ImportSIAC.wrk_Populate_Checkpoint (Dominio, SnapshotYear, SnapshotMonth, RowsInserted)
                VALUES (N'FPC', @Y, @M, @n);
                SET @ChunkDone = 1;
            END TRY
            BEGIN CATCH
                SET @ChunkErr = ERROR_NUMBER();
                SET @ChunkErrMsg = LEFT(ERROR_MESSAGE(), 500);
                IF @ChunkErr IN (4083,46834,40197,40501,40613,49918,49919,49920,233,10928,10929,10060)
                   AND @ChunkRetry < @ChunkMaxRetries
                BEGIN
                    IF EXISTS (SELECT 1 FROM ImportSIAC.wrk_All_Src
                               WHERE Dominio = N'FPC' AND SnapshotYear = @Y AND SnapshotMonth = @M)
                    BEGIN
                        INSERT INTO ImportSIAC.wrk_Populate_Checkpoint (Dominio, SnapshotYear, SnapshotMonth, RowsInserted)
                        SELECT N'FPC', @Y, @M, COUNT_BIG(*) FROM ImportSIAC.wrk_All_Src
                        WHERE Dominio = N'FPC' AND SnapshotYear = @Y AND SnapshotMonth = @M;
                        SET @ChunkDone = 1;
                        PRINT CONCAT('  FPC ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2),
                                     ': commit rilevato dopo ERR ', @ChunkErr, '.');
                    END
                    ELSE
                    BEGIN
                        SET @ChunkRetry += 1;
                        SET @ChunkDelaySec = @ChunkInitialDelaySec * POWER(2, @ChunkRetry - 1);
                        IF @ChunkDelaySec > 120 SET @ChunkDelaySec = 120;
                        SET @ChunkDelay = '00:' + RIGHT('0' + CAST(@ChunkDelaySec / 60 AS VARCHAR), 2)
                                        + ':' + RIGHT('0' + CAST(@ChunkDelaySec % 60 AS VARCHAR), 2);
                        PRINT CONCAT('  FPC ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2),
                                     ': transient ERR ', @ChunkErr, ': ', @ChunkErrMsg);
                        PRINT CONCAT('  retry chunk ', @ChunkRetry, '/', @ChunkMaxRetries,
                                     ' tra ', @ChunkDelaySec, 's...');
                        WAITFOR DELAY @ChunkDelay;
                    END;
                END
                ELSE
                    THROW;
            END CATCH;
        END;

        SET @fpcMonth = @fpcMonth + 1;
        PRINT CONCAT('  FPC ', @Y, '-', RIGHT('0'+CAST(@M AS VARCHAR),2),
                     ': completato (', @fpcMonth, '/', @CntFPC, ')');
        FETCH NEXT FROM cur_fpc INTO @Y, @M;
    END;
    CLOSE cur_fpc; DEALLOCATE cur_fpc;
    PRINT CONCAT('FPC caricamento completato in ', DATEDIFF(SECOND,@t0,SYSUTCDATETIME()), 's');

    -- =================================================================
    -- RICREA INDICI (se mancanti) - MIG_131
    -- =================================================================
    IF NOT EXISTS (SELECT 1 FROM sys.indexes
                   WHERE object_id=OBJECT_ID('ImportSIAC.wrk_All_Src')
                     AND name='IX_wrk_All_Src_DominioPeriodo')
    BEGIN
        PRINT '--- Creazione indice NC IX_wrk_All_Src_DominioPeriodo ---';
        SET @t0 = SYSUTCDATETIME();
        CREATE NONCLUSTERED INDEX IX_wrk_All_Src_DominioPeriodo
            ON ImportSIAC.wrk_All_Src (Dominio, SnapshotYear, SnapshotMonth) INCLUDE (RawId)
            WITH (MAXDOP = 4, ONLINE = OFF, SORT_IN_TEMPDB = ON);
        PRINT CONCAT('Indice NC creato in ', DATEDIFF(SECOND,@t0,SYSUTCDATETIME()), 's');
    END;

    IF NOT EXISTS (SELECT 1 FROM sys.indexes
                   WHERE object_id=OBJECT_ID('ImportSIAC.wrk_All_Src')
                     AND name='IX_wrkAllSrc_FPC_ProfCode') AND 1=0 /* MIG_136b: indice non piu' ricreato (0 seek storici, decisione MIG_136) */
    BEGIN
        PRINT '--- Creazione indice NC filtrato IX_wrkAllSrc_FPC_ProfCode ---';
        SET @t0 = SYSUTCDATETIME();
        CREATE NONCLUSTERED INDEX IX_wrkAllSrc_FPC_ProfCode
            ON ImportSIAC.wrk_All_Src (Dominio, professional_code_json)
            WHERE Dominio = 'FPC' AND professional_code_json IS NOT NULL
            WITH (MAXDOP = 4, ONLINE = OFF, SORT_IN_TEMPDB = ON);
        PRINT CONCAT('Indice NC filtrato creato in ', DATEDIFF(SECOND,@t0,SYSUTCDATETIME()), 's');
    END;

    -- =================================================================
    -- MIG_136c: ricompatta i rowgroup dopo il full load (328 insert mensili
    -- producono rowgroup piccoli: -50% throughput negli scan a valle, misurato)
    IF @WindowMonths IS NULL
    BEGIN
        PRINT '--- REORGANIZE CCI (COMPRESS_ALL_ROW_GROUPS) ---';
        SET @t0 = SYSUTCDATETIME();
        ALTER INDEX CCI_wrk_All_Src ON ImportSIAC.wrk_All_Src
            REORGANIZE WITH (COMPRESS_ALL_ROW_GROUPS = ON);
        PRINT CONCAT('REORGANIZE completato in ', DATEDIFF(SECOND,@t0,SYSUTCDATETIME()), 's');
    END;

    -- RIEPILOGO
    -- =================================================================
    SELECT
        @ppTotal = COALESCE(SUM(CONVERT(bigint, CASE WHEN Dominio = 'PP' THEN 1 ELSE 0 END)), 0),
        @prdTotal = COALESCE(SUM(CONVERT(bigint, CASE WHEN Dominio = 'PRD' THEN 1 ELSE 0 END)), 0),
        @fpcTotal = COALESCE(SUM(CONVERT(bigint, CASE WHEN Dominio = 'FPC' THEN 1 ELSE 0 END)), 0)
    FROM ImportSIAC.wrk_All_Src;

    SELECT v.Dominio, FORMAT(v.righe, 'N0') AS righe
    FROM (VALUES
        (N'FPC', @fpcTotal),
        (N'PP',  @ppTotal),
        (N'PRD', @prdTotal)
    ) AS v(Dominio, righe)
    ORDER BY v.Dominio;

    PRINT CONCAT('--- ', @Mode, ' COMPLETATO in ', DATEDIFF(SECOND,@tStart,SYSUTCDATETIME()), 's ---');
    PRINT CONCAT('PP=', FORMAT(@ppTotal,'N0'), ' PRD=', FORMAT(@prdTotal,'N0'), ' FPC=', FORMAT(@fpcTotal,'N0'),
                 ' TOT=', FORMAT(@ppTotal+@prdTotal+@fpcTotal,'N0'));
END;

GO

