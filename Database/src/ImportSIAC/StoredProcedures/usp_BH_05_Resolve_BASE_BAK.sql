 
-- ================================================================================
-- ImportSIAC.usp_BH_05_Resolve (28351 caratteri)
-- ================================================================================
/*
    ImportSIAC.usp_BH_05_Resolve

    Refactoring dello step 05_RESOLVE.

    Obiettivi:
      - isolare lo step in una procedura figlia misurabile;
      - evitare insert di righe con ODC mancante e successivo DELETE;
      - materializzare una mappa cliente con chiavi non NULL per join piu stabile;
      - batchizzare opzionalmente per SnapshotYear/SnapshotMonth, riducendo durata
        della singola transazione e pressione su log/I/O in Azure SQL;
      - mantenere compatibilita con gli output usati da usp_BuildHistory_All.

    Deploy:
      :r "...\sql\15_importsiac_buildhistory_refactor_05_resolve.sql"
*/
CREATE PROCEDURE [ImportSIAC].[usp_BH_05_Resolve_BASE_BAK]
    @BuildHistoryLogId INT,
    @MaxDop TINYINT = 4,
    @BatchByMonth BIT = 1,
    @CreateSourceIndex BIT = 1,
    @RowsAffected BIGINT = NULL OUTPUT,
    @RigheDedup_PP INT = NULL OUTPUT,
    @RigheDedup_PRD INT = NULL OUTPUT,
    @RigheDedup_FPC INT = NULL OUTPUT,
    @ScartateODC_PP INT = NULL OUTPUT,
    @ScartateODC_PRD INT = NULL OUTPUT,
    @ScartateODC_FPC INT = NULL OUTPUT,
    @NormeFallback_PP INT = NULL OUTPUT,
    @NormeFallback_PRD INT = NULL OUTPUT,
    @NormeFallback_FPC INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT = NULL;
    DECLARE @Rows BIGINT = 0;
    DECLARE @RowsOut BIGINT = 0;
    DECLARE @RowsPP BIGINT = 0;
    DECLARE @RowsPRD BIGINT = 0;
    DECLARE @RowsFPC BIGINT = 0;
    DECLARE @BatchCount INT = 0;
    DECLARE @LockResult INT;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @MaxDopHint NVARCHAR(40) = N'';
    DECLARE @IndexOptions NVARCHAR(100);
    DECLARE @ExtraInfo NVARCHAR(4000);
    DECLARE @Y INT;
    DECLARE @M INT;
    DECLARE @SnapshotDate DATE;
    DECLARE @SnapshotBusinessTs DATETIME2(7);
    DECLARE @HasClusteredSource BIT = 0;
    DECLARE @HasResolveClusteredOrder BIT = 0;
    DECLARE @ClusteredSourceIndex SYSNAME = NULL;

    DECLARE @TipoAltro INT;
    DECLARE @NormaFallback INT;
    DECLARE @TipoQualificaFallback INT;

    IF @BuildHistoryLogId IS NULL
        THROW 51200, 'BuildHistoryLogId obbligatorio.', 1;

    IF @MaxDop IS NULL SET @MaxDop = 4;
    IF @MaxDop > 8
        THROW 51201, 'MaxDop non valido. Usare 0 oppure un valore tra 1 e 8.', 1;

    IF @MaxDop > 0
        SET @MaxDopHint = N' OPTION (MAXDOP ' + CONVERT(NVARCHAR(3), @MaxDop) + N')';

    SET @IndexOptions =
        CASE
            WHEN @MaxDop > 0 THEN N'MAXDOP = ' + CONVERT(NVARCHAR(3), @MaxDop) + N', ONLINE = OFF'
            ELSE N'ONLINE = OFF'
        END;

    EXEC @LockResult = sys.sp_getapplock
        @Resource = N'ImportSIAC.BuildHistory.05_RESOLVE',
        @LockMode = N'Exclusive',
        @LockOwner = N'Session',
        @LockTimeout = 0;

    IF @LockResult < 0
        THROW 51202, 'Step 05_RESOLVE gia in esecuzione in un altra sessione.', 1;

    BEGIN TRY
        IF OBJECT_ID(N'ImportSIAC.wrk_All_Src', N'U') IS NULL
            THROW 51203, 'ImportSIAC.wrk_All_Src non esiste.', 1;

        IF OBJECT_ID(N'ImportSIAC.wrk_NormaMap', N'U') IS NULL
            THROW 51204, 'ImportSIAC.wrk_NormaMap non esiste. Eseguire prima lo step 02.', 1;

        IF OBJECT_ID(N'ImportSIAC.wrk_ClienteMap', N'U') IS NULL
            THROW 51205, 'ImportSIAC.wrk_ClienteMap non esiste. Eseguire prima lo step 04B.', 1;

        SELECT @TipoAltro = TipoCertificazioneId
        FROM Certificazione.TipoCertificazione
        WHERE Codice = 'ALTRO' AND DataCancellazione IS NULL;

        SELECT @NormaFallback = MIN(NormaAccreditamentoId)
        FROM Standard.NormaAccreditamento
        WHERE DataCancellazione IS NULL AND Attivo = 1;

        SELECT @TipoQualificaFallback = TipoQualificaId
        FROM Tipologica.TipoQualifica
        WHERE Codice = 'ALTRO' AND DataCancellazione IS NULL;

        IF @TipoAltro IS NULL THROW 51206, 'Lookup: TipoCertificazione ALTRO.', 1;
        IF @NormaFallback IS NULL THROW 51207, 'Lookup: NormaAccreditamento.', 1;
        IF @TipoQualificaFallback IS NULL THROW 51208, 'Lookup: TipoQualifica ALTRO.', 1;

        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId, StepNo, StepCode, StepName, StartedAt, Status, SessionId, HostName, AppName)
        VALUES
            (@BuildHistoryLogId, 5, N'05_RESOLVE', N'Resolve + scarto ODC', @StepStart, N'RUNNING', @@SPID, HOST_NAME(), APP_NAME());


        SET @StepLogId = SCOPE_IDENTITY();

        DROP TABLE IF EXISTS ImportSIAC.wrk_All_Resolved;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteMapResolve;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Resolve_ODCScarti;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ResolvePeriods;

        IF @CreateSourceIndex = 1
        BEGIN
            UPDATE ImportSIAC.BuildHistory_StepLog
                SET ExtraInfo = N'EnsuringSourceResolveAccessPath'
            WHERE BuildHistoryStepLogId = @StepLogId;

            SELECT @ClusteredSourceIndex = i.name
            FROM sys.indexes i
            WHERE i.object_id = OBJECT_ID(N'ImportSIAC.wrk_All_Src', N'U')
              AND i.type = 1;

            SET @HasClusteredSource = CASE WHEN @ClusteredSourceIndex IS NULL THEN 0 ELSE 1 END;

            SELECT @HasResolveClusteredOrder =
                CASE WHEN COUNT_BIG(*) = 4 THEN 1 ELSE 0 END
            FROM sys.indexes i
            JOIN sys.index_columns ic
                ON ic.object_id = i.object_id
               AND ic.index_id = i.index_id
            JOIN sys.columns c
                ON c.object_id = ic.object_id
               AND c.column_id = ic.column_id
            WHERE i.object_id = OBJECT_ID(N'ImportSIAC.wrk_All_Src', N'U')
              AND i.type = 1
              AND ic.key_ordinal > 0
              AND (
                     (ic.key_ordinal = 1 AND c.name = N'Dominio')
                  OR (ic.key_ordinal = 2 AND c.name = N'SnapshotYear')
                  OR (ic.key_ordinal = 3 AND c.name = N'SnapshotMonth')
                  OR (ic.key_ordinal = 4 AND c.name = N'RawId')
              );

            -- Crea SEMPRE un NC (veloce ~5-8 min, niente spill tempdb)
            -- invece del CX (riordina 48GB heap -> 2h + spill tempdb 200GB).
            -- Il NC su (Dominio, SnapshotYear, SnapshotMonth) INCLUDE (RawId)
            -- copre i batch mensili del resolve.
            IF NOT EXISTS
            (
                SELECT 1
                FROM sys.indexes
                WHERE object_id = OBJECT_ID(N'ImportSIAC.wrk_All_Src', N'U')
                  AND name IN (N'IX_wrk_All_Src_DominioPeriodo',
                               N'IX_wrk_All_Src_Resolve_DominioPeriodo',
                               N'CX_wrk_All_Src_Resolve')
            )
            AND @HasResolveClusteredOrder = 0
            BEGIN
                SET @sql = N'CREATE NONCLUSTERED INDEX IX_wrk_All_Src_DominioPeriodo
ON ImportSIAC.wrk_All_Src (Dominio, SnapshotYear, SnapshotMonth) INCLUDE (RawId)
WITH (' + @IndexOptions + N');';
                EXEC sp_executesql @sql;
            END;
        END;

        SELECT
            ISNULL(fiscal_code, N'') AS fiscal_code_key,
            ISNULL(vat_number,  N'') AS vat_number_key,
            OrganizzazioneClienteId
        INTO ImportSIAC.wrk_ClienteMapResolve
        FROM ImportSIAC.wrk_ClienteMap;

        CREATE CLUSTERED INDEX CX_ClienteMapResolve
            ON ImportSIAC.wrk_ClienteMapResolve (fiscal_code_key, vat_number_key);

        SELECT TOP (0)
            src.RawId, src.Dominio, src.SnapshotYear, src.SnapshotMonth,
            DATEFROMPARTS(src.SnapshotYear, src.SnapshotMonth, 1) AS SnapshotDate,
            DATEADD(NANOSECOND, -100,
                DATEADD(DAY, 1,
                    CAST(EOMONTH(DATEFROMPARTS(src.SnapshotYear, src.SnapshotMonth, 1)) AS DATETIME2(7))
                )) AS SnapshotBusinessTs,
            src.NumeroCertificato, src.codente,
            src.DataPrimoRilascio, src.DataEmissione, src.DataScadenza,
            src.DataRevoca, src.Privato, src.StatoCertificazioneId,
            src.publication_date, src.insertdate,
            odc.OrganizzazioneId AS OrganizzazioneODCId,
            COALESCE(tc.TipoCertificazioneId, @TipoAltro) AS TipoCertificazioneId,
            COALESCE(nm.NormaAccreditamentoId, @NormaFallback) AS NormaAccreditamentoId,
            CASE WHEN nm.NormaAccreditamentoId IS NULL THEN 1 ELSE 0 END AS NormaFallbackUsata,
            cm.OrganizzazioneClienteId,
            src.AmbitoIta, src.AmbitoEng, src.DataUltimoRinnovo,
            src.sede_address, src.sede_city, src.sede_zip,
            src.raw_site_type, src.raw_site_province, src.raw_site_country,
            src.ScopoCertificato, src.NomeProdotto, src.SpecificaTecnica,
            CAST(NULL AS int) AS ProfiloProfessionaleId /* MIG_111A: PRD usa profilo tecnico */,
            src.person_code, src.first_name, src.last_name,
            src.birth_date, src.birth_place, src.fpc_fiscal_code,
            src.professional_code_json, src.competence_level,
            CASE WHEN src.foreigner_json = 'SI' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS Straniero,
            src.id_group_json AS SiacId, src.fpc_release_date,

            COALESCE(tq.TipoQualificaId, @TipoQualificaFallback) AS TipoQualificaId
        INTO ImportSIAC.wrk_All_Resolved
        FROM ImportSIAC.wrk_All_Src src
        LEFT JOIN Organizzazioni.Organizzazione odc
            ON odc.CodOrganizzazione = src.codente
           AND odc.DataCancellazione IS NULL
        LEFT JOIN Certificazione.TipoCertificazione tc
            ON tc.Codice = src.siglaschema
           AND tc.DataCancellazione IS NULL
        LEFT JOIN ImportSIAC.wrk_NormaMap nm
            ON nm.norma_raw = src.norma_raw
        LEFT JOIN ImportSIAC.wrk_ClienteMapResolve cm
            ON 1 = 0
        
        LEFT JOIN Tipologica.TipoQualifica tq
            ON 1 = 0;

        SELECT
            src.Dominio,
            src.RawId,
            src.SnapshotYear,
            src.SnapshotMonth,
            src.codente,
            src.NumeroCertificato
        INTO ImportSIAC.wrk_Resolve_ODCScarti
        FROM ImportSIAC.wrk_All_Src src
        LEFT JOIN Organizzazioni.Organizzazione odc
            ON odc.CodOrganizzazione = src.codente
           AND odc.DataCancellazione IS NULL
        WHERE odc.OrganizzazioneId IS NULL
          AND src.Dominio IN ('PP', 'PRD', 'FPC')
        OPTION (MAXDOP 8);

        SELECT
            @ScartateODC_PP = COALESCE(SUM(CASE WHEN Dominio = 'PP' THEN 1 ELSE 0 END), 0),
            @ScartateODC_PRD = COALESCE(SUM(CASE WHEN Dominio = 'PRD' THEN 1 ELSE 0 END), 0),
            @ScartateODC_FPC = COALESCE(SUM(CASE WHEN Dominio = 'FPC' THEN 1 ELSE 0 END), 0)
        FROM ImportSIAC.wrk_Resolve_ODCScarti;

        INSERT INTO ImportSIAC.BuildHistory_SkippedRow
            (BuildHistoryLogId, Dominio, RawId, SnapshotYear, SnapshotMonth, Codente, NumeroCertificato, MotivoScarto)
        SELECT
            @BuildHistoryLogId,
            Dominio,
            RawId,
            SnapshotYear,
            SnapshotMonth,
            codente,
            NumeroCertificato,
            'ODC_NOT_FOUND'
        FROM ImportSIAC.wrk_Resolve_ODCScarti
        OPTION (MAXDOP 8);

        SELECT DISTINCT Dominio, SnapshotYear, SnapshotMonth
        INTO ImportSIAC.wrk_ResolvePeriods
        FROM ImportSIAC.wrk_All_Src
        WHERE Dominio IN ('PP', 'PRD', 'FPC');

        CREATE CLUSTERED INDEX CX_ResolvePeriods
            ON ImportSIAC.wrk_ResolvePeriods (Dominio, SnapshotYear, SnapshotMonth);

        SET @sql = N'
INSERT INTO ImportSIAC.wrk_All_Resolved WITH (TABLOCK)
SELECT
    src.RawId, src.Dominio, src.SnapshotYear, src.SnapshotMonth,
    /*SNAPSHOT_DATE*/ AS SnapshotDate,
    /*SNAPSHOT_BUSINESS_TS*/ AS SnapshotBusinessTs,
    src.NumeroCertificato, src.codente,
    src.DataPrimoRilascio, src.DataEmissione, src.DataScadenza,
    src.DataRevoca, src.Privato, src.StatoCertificazioneId,
    src.publication_date, src.insertdate,
    odc.OrganizzazioneId AS OrganizzazioneODCId,
    COALESCE(tc.TipoCertificazioneId, @TipoAltro) AS TipoCertificazioneId,
    COALESCE(nm.NormaAccreditamentoId, @NormaFallback) AS NormaAccreditamentoId,
    CASE WHEN nm.NormaAccreditamentoId IS NULL THEN 1 ELSE 0 END AS NormaFallbackUsata,

    cm.OrganizzazioneClienteId,
    src.AmbitoIta, src.AmbitoEng, src.DataUltimoRinnovo,
    src.sede_address, src.sede_city, src.sede_zip,
    src.raw_site_type, src.raw_site_province, src.raw_site_country,
    src.ScopoCertificato, src.NomeProdotto, src.SpecificaTecnica,
    CAST(NULL AS INT) AS ProfiloProfessionaleId,
    src.person_code, src.first_name, src.last_name,
    src.birth_date, src.birth_place, src.fpc_fiscal_code,
    src.professional_code_json, src.competence_level,
    CASE WHEN src.foreigner_json = ''SI'' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS Straniero,
    src.id_group_json AS SiacId, src.fpc_release_date,
    @TipoQualificaFallback AS TipoQualificaId
FROM ImportSIAC.wrk_All_Src src
INNER JOIN Organizzazioni.Organizzazione odc
    ON odc.CodOrganizzazione = src.codente
   AND odc.DataCancellazione IS NULL
LEFT JOIN Certificazione.TipoCertificazione tc
    ON tc.Codice = src.siglaschema
   AND tc.DataCancellazione IS NULL
LEFT JOIN ImportSIAC.wrk_NormaMap nm
    ON nm.norma_raw = src.norma_raw
CROSS APPLY (
    SELECT
        ISNULL(NULLIF(LTRIM(RTRIM(src.fiscal_code)), ''''), '''') AS fiscal_code_key,
        ISNULL(NULLIF(LTRIM(RTRIM(src.vat_number)),  ''''), '''') AS vat_number_key
) k
LEFT JOIN ImportSIAC.wrk_ClienteMapResolve cm
    ON cm.fiscal_code_key = k.fiscal_code_key
   AND cm.vat_number_key  = k.vat_number_key
WHERE src.Dominio = ''PP''
/*PERIOD_FILTER*/'
            + @MaxDopHint + N';
SET @RowsOut = @@ROWCOUNT;';

        IF @BatchByMonth = 1
            SET @sql = REPLACE(@sql, N'/*PERIOD_FILTER*/',
                N'  AND src.SnapshotYear = @SnapshotYear
  AND src.SnapshotMonth = @SnapshotMonth');
        ELSE
            SET @sql = REPLACE(@sql, N'/*PERIOD_FILTER*/', N'');

        IF @BatchByMonth = 1
        BEGIN
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_DATE*/', N'@SnapshotDate');
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_BUSINESS_TS*/', N'@SnapshotBusinessTs');
        END
        ELSE
        BEGIN
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_DATE*/', N'DATEFROMPARTS(src.SnapshotYear, src.SnapshotMonth, 1)');
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_BUSINESS_TS*/', N'DATEADD(NANOSECOND, -100, DATEADD(DAY, 1, CAST(EOMONTH(DATEFROMPARTS(src.SnapshotYear, src.SnapshotMonth, 1)) AS DATETIME2(7))))');
        END;

        IF @BatchByMonth = 1
        BEGIN
            DECLARE cur_pp CURSOR LOCAL FAST_FORWARD FOR
                SELECT SnapshotYear, SnapshotMonth
                FROM ImportSIAC.wrk_ResolvePeriods
                WHERE Dominio = 'PP'
                ORDER BY SnapshotYear, SnapshotMonth;

            OPEN cur_pp;
            FETCH NEXT FROM cur_pp INTO @Y, @M;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @RowsOut = 0;
                SET @SnapshotDate = DATEFROMPARTS(@Y, @M, 1);
                SET @SnapshotBusinessTs = DATEADD(NANOSECOND, -100,
                    DATEADD(DAY, 1, CAST(EOMONTH(@SnapshotDate) AS DATETIME2(7))));

                EXEC sp_executesql
                    @sql,
                    N'@TipoAltro INT, @NormaFallback INT, @TipoQualificaFallback INT, @BatchByMonth BIT, @SnapshotYear INT, @SnapshotMonth INT, @SnapshotDate DATE, @SnapshotBusinessTs DATETIME2(7), @RowsOut BIGINT OUTPUT',
                    @TipoAltro = @TipoAltro,
                    @NormaFallback = @NormaFallback,
                    @TipoQualificaFallback = @TipoQualificaFallback,
                    @BatchByMonth = @BatchByMonth,
                    @SnapshotYear = @Y,
                    @SnapshotMonth = @M,
                    @SnapshotDate = @SnapshotDate,
                    @SnapshotBusinessTs = @SnapshotBusinessTs,
                    @RowsOut = @RowsOut OUTPUT;

                SET @RowsPP += @RowsOut;
                SET @BatchCount += 1;
                SET @ExtraInfo = CONCAT(N'CurrentBatch=PP ', @Y, N'-', RIGHT(CONCAT(N'0', @M), 2), N'; PP=', @RowsPP);

                UPDATE ImportSIAC.BuildHistory_StepLog
                    SET ExtraInfo = @ExtraInfo
                WHERE BuildHistoryStepLogId = @StepLogId;

                FETCH NEXT FROM cur_pp INTO @Y, @M;
            END;

            CLOSE cur_pp;
            DEALLOCATE cur_pp;
        END
        ELSE
        BEGIN
            EXEC sp_executesql
                @sql,
                N'@TipoAltro INT, @NormaFallback INT, @TipoQualificaFallback INT, @BatchByMonth BIT, @SnapshotYear INT, @SnapshotMonth INT, @SnapshotDate DATE, @SnapshotBusinessTs DATETIME2(7), @RowsOut BIGINT OUTPUT',
                @TipoAltro = @TipoAltro,
                @NormaFallback = @NormaFallback,
                @TipoQualificaFallback = @TipoQualificaFallback,
                @BatchByMonth = @BatchByMonth,
                @SnapshotYear = NULL,
                @SnapshotMonth = NULL,
                @SnapshotDate = NULL,
                @SnapshotBusinessTs = NULL,
                @RowsOut = @RowsPP OUTPUT;
        END;

        SET @sql = N'
INSERT INTO ImportSIAC.wrk_All_Resolved WITH (TABLOCK)
SELECT
    src.RawId, src.Dominio, src.SnapshotYear, src.SnapshotMonth,

    /*SNAPSHOT_DATE*/ AS SnapshotDate,
    /*SNAPSHOT_BUSINESS_TS*/ AS SnapshotBusinessTs,
    src.NumeroCertificato, src.codente,
    src.DataPrimoRilascio, src.DataEmissione, src.DataScadenza,
    src.DataRevoca, src.Privato, src.StatoCertificazioneId,
    src.publication_date, src.insertdate,
    odc.OrganizzazioneId AS OrganizzazioneODCId,
    @TipoAltro AS TipoCertificazioneId,
    COALESCE(nm.NormaAccreditamentoId, @NormaFallback) AS NormaAccreditamentoId,
    CASE WHEN nm.NormaAccreditamentoId IS NULL THEN 1 ELSE 0 END AS NormaFallbackUsata,
    cm.OrganizzazioneClienteId,
    src.AmbitoIta, src.AmbitoEng, src.DataUltimoRinnovo,
    src.sede_address, src.sede_city, src.sede_zip,
    src.raw_site_type, src.raw_site_province, src.raw_site_country,
    src.ScopoCertificato, src.NomeProdotto, src.SpecificaTecnica,
    CAST(NULL AS int) AS ProfiloProfessionaleId /* MIG_111A: PRD usa profilo tecnico */,
    src.person_code, src.first_name, src.last_name,
    src.birth_date, src.birth_place, src.fpc_fiscal_code,
    src.professional_code_json, src.competence_level,
    CASE WHEN src.foreigner_json = ''SI'' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS Straniero,
    src.id_group_json AS SiacId, src.fpc_release_date,
    @TipoQualificaFallback AS TipoQualificaId
FROM ImportSIAC.wrk_All_Src src
INNER JOIN Organizzazioni.Organizzazione odc
    ON odc.CodOrganizzazione = src.codente
   AND odc.DataCancellazione IS NULL
LEFT JOIN ImportSIAC.wrk_NormaMap nm
    ON nm.norma_raw = src.norma_raw
CROSS APPLY (
    SELECT
        ISNULL(NULLIF(LTRIM(RTRIM(src.fiscal_code)), ''''), '''') AS fiscal_code_key,
        ISNULL(NULLIF(LTRIM(RTRIM(src.vat_number)),  ''''), '''') AS vat_number_key
) k
LEFT JOIN ImportSIAC.wrk_ClienteMapResolve cm
    ON cm.fiscal_code_key = k.fiscal_code_key
   AND cm.vat_number_key  = k.vat_number_key

WHERE src.Dominio = ''PRD''
/*PERIOD_FILTER*/'
            + @MaxDopHint + N';
SET @RowsOut = @@ROWCOUNT;';

        IF @BatchByMonth = 1
            SET @sql = REPLACE(@sql, N'/*PERIOD_FILTER*/',
                N'  AND src.SnapshotYear = @SnapshotYear
  AND src.SnapshotMonth = @SnapshotMonth');
        ELSE
            SET @sql = REPLACE(@sql, N'/*PERIOD_FILTER*/', N'');

        IF @BatchByMonth = 1
        BEGIN
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_DATE*/', N'@SnapshotDate');
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_BUSINESS_TS*/', N'@SnapshotBusinessTs');
        END
        ELSE
        BEGIN
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_DATE*/', N'DATEFROMPARTS(src.SnapshotYear, src.SnapshotMonth, 1)');
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_BUSINESS_TS*/', N'DATEADD(NANOSECOND, -100, DATEADD(DAY, 1, CAST(EOMONTH(DATEFROMPARTS(src.SnapshotYear, src.SnapshotMonth, 1)) AS DATETIME2(7))))');
        END;

        IF @BatchByMonth = 1
        BEGIN
            DECLARE cur_prd CURSOR LOCAL FAST_FORWARD FOR
                SELECT SnapshotYear, SnapshotMonth
                FROM ImportSIAC.wrk_ResolvePeriods
                WHERE Dominio = 'PRD'
                ORDER BY SnapshotYear, SnapshotMonth;

            OPEN cur_prd;
            FETCH NEXT FROM cur_prd INTO @Y, @M;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @RowsOut = 0;
                SET @SnapshotDate = DATEFROMPARTS(@Y, @M, 1);
                SET @SnapshotBusinessTs = DATEADD(NANOSECOND, -100,
                    DATEADD(DAY, 1, CAST(EOMONTH(@SnapshotDate) AS DATETIME2(7))));

                EXEC sp_executesql
                    @sql,
                    N'@TipoAltro INT, @NormaFallback INT, @TipoQualificaFallback INT, @BatchByMonth BIT, @SnapshotYear INT, @SnapshotMonth INT, @SnapshotDate DATE, @SnapshotBusinessTs DATETIME2(7), @RowsOut BIGINT OUTPUT',
                    @TipoAltro = @TipoAltro,
                    @NormaFallback = @NormaFallback,
                    @TipoQualificaFallback = @TipoQualificaFallback,
                    @BatchByMonth = @BatchByMonth,
                    @SnapshotYear = @Y,
                    @SnapshotMonth = @M,
                    @SnapshotDate = @SnapshotDate,
                    @SnapshotBusinessTs = @SnapshotBusinessTs,
                    @RowsOut = @RowsOut OUTPUT;

                SET @RowsPRD += @RowsOut;
                SET @BatchCount += 1;
                SET @ExtraInfo = CONCAT(N'CurrentBatch=PRD ', @Y, N'-', RIGHT(CONCAT(N'0', @M), 2), N'; PP=', @RowsPP, N'; PRD=', @RowsPRD);

                UPDATE ImportSIAC.BuildHistory_StepLog
                    SET ExtraInfo = @ExtraInfo
                WHERE BuildHistoryStepLogId = @StepLogId;

                FETCH NEXT FROM cur_prd INTO @Y, @M;
            END;

            CLOSE cur_prd;
            DEALLOCATE cur_prd;
        END
        ELSE

        BEGIN
            EXEC sp_executesql
                @sql,
                N'@TipoAltro INT, @NormaFallback INT, @TipoQualificaFallback INT, @BatchByMonth BIT, @SnapshotYear INT, @SnapshotMonth INT, @SnapshotDate DATE, @SnapshotBusinessTs DATETIME2(7), @RowsOut BIGINT OUTPUT',
                @TipoAltro = @TipoAltro,
                @NormaFallback = @NormaFallback,
                @TipoQualificaFallback = @TipoQualificaFallback,
                @BatchByMonth = @BatchByMonth,
                @SnapshotYear = NULL,
                @SnapshotMonth = NULL,
                @SnapshotDate = NULL,
                @SnapshotBusinessTs = NULL,
                @RowsOut = @RowsPRD OUTPUT;
        END;

        SET @sql = N'
INSERT INTO ImportSIAC.wrk_All_Resolved WITH (TABLOCK)
SELECT
    src.RawId, src.Dominio, src.SnapshotYear, src.SnapshotMonth,
    /*SNAPSHOT_DATE*/ AS SnapshotDate,
    /*SNAPSHOT_BUSINESS_TS*/ AS SnapshotBusinessTs,
    src.NumeroCertificato, src.codente,
    src.DataPrimoRilascio, src.DataEmissione, src.DataScadenza,
    src.DataRevoca, src.Privato, src.StatoCertificazioneId,
    src.publication_date, src.insertdate,
    odc.OrganizzazioneId AS OrganizzazioneODCId,
    @TipoAltro AS TipoCertificazioneId,
    COALESCE(nm.NormaAccreditamentoId, @NormaFallback) AS NormaAccreditamentoId,
    CASE WHEN nm.NormaAccreditamentoId IS NULL THEN 1 ELSE 0 END AS NormaFallbackUsata,
    CAST(NULL AS INT) AS OrganizzazioneClienteId,
    src.AmbitoIta, src.AmbitoEng, src.DataUltimoRinnovo,
    src.sede_address, src.sede_city, src.sede_zip,
    src.raw_site_type, src.raw_site_province, src.raw_site_country,
    src.ScopoCertificato, src.NomeProdotto, src.SpecificaTecnica,
    CAST(NULL AS INT) AS ProfiloProfessionaleId,
    src.person_code, src.first_name, src.last_name,
    src.birth_date, src.birth_place, src.fpc_fiscal_code,
    src.professional_code_json, src.competence_level,
    CASE WHEN src.foreigner_json = ''SI'' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS Straniero,
    src.id_group_json AS SiacId, src.fpc_release_date,
    COALESCE(tq.TipoQualificaId, @TipoQualificaFallback) AS TipoQualificaId
FROM ImportSIAC.wrk_All_Src src
INNER JOIN Organizzazioni.Organizzazione odc
    ON odc.CodOrganizzazione = src.codente
   AND odc.DataCancellazione IS NULL
LEFT JOIN ImportSIAC.wrk_NormaMap nm
    ON nm.norma_raw = src.norma_raw
LEFT JOIN Tipologica.TipoQualifica tq
    ON tq.Codice = src.professional_code_json
   AND tq.DataCancellazione IS NULL
WHERE src.Dominio = ''FPC''
/*PERIOD_FILTER*/'
            + @MaxDopHint + N';
SET @RowsOut = @@ROWCOUNT;';

        IF @BatchByMonth = 1
            SET @sql = REPLACE(@sql, N'/*PERIOD_FILTER*/',
                N'  AND src.SnapshotYear = @SnapshotYear
  AND src.SnapshotMonth = @SnapshotMonth');
        ELSE
            SET @sql = REPLACE(@sql, N'/*PERIOD_FILTER*/', N'');

        IF @BatchByMonth = 1
        BEGIN
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_DATE*/', N'@SnapshotDate');
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_BUSINESS_TS*/', N'@SnapshotBusinessTs');
        END
        ELSE
        BEGIN
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_DATE*/', N'DATEFROMPARTS(src.SnapshotYear, src.SnapshotMonth, 1)');
            SET @sql = REPLACE(@sql, N'/*SNAPSHOT_BUSINESS_TS*/', N'DATEADD(NANOSECOND, -100, DATEADD(DAY, 1, CAST(EOMONTH(DATEFROMPARTS(src.SnapshotYear, src.SnapshotMonth, 1)) AS DATETIME2(7))))');
        END;

        IF @BatchByMonth = 1
        BEGIN
            DECLARE cur_fpc CURSOR LOCAL FAST_FORWARD FOR
                SELECT SnapshotYear, SnapshotMonth
                FROM ImportSIAC.wrk_ResolvePeriods
                WHERE Dominio = 'FPC'
                ORDER BY SnapshotYear, SnapshotMonth;

            OPEN cur_fpc;
            FETCH NEXT FROM cur_fpc INTO @Y, @M;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @RowsOut = 0;
                SET @SnapshotDate = DATEFROMPARTS(@Y, @M, 1);
                SET @SnapshotBusinessTs = DATEADD(NANOSECOND, -100,
                    DATEADD(DAY, 1, CAST(EOMONTH(@SnapshotDate) AS DATETIME2(7))));

                EXEC sp_executesql
                    @sql,
                    N'@TipoAltro INT, @NormaFallback INT, @TipoQualificaFallback INT, @BatchByMonth BIT, @SnapshotYear INT, @SnapshotMonth INT, @SnapshotDate DATE, @SnapshotBusinessTs DATETIME2(7), @RowsOut BIGINT OUTPUT',
                    @TipoAltro = @TipoAltro,
                    @NormaFallback = @NormaFallback,
                    @TipoQualificaFallback = @TipoQualificaFallback,
                    @BatchByMonth = @BatchByMonth,
                    @SnapshotYear = @Y,
                    @SnapshotMonth = @M,
                    @SnapshotDate = @SnapshotDate,
                    @SnapshotBusinessTs = @SnapshotBusinessTs,
                    @RowsOut = @RowsOut OUTPUT;

                SET @RowsFPC += @RowsOut;
                SET @BatchCount += 1;

                SET @ExtraInfo = CONCAT(N'CurrentBatch=FPC ', @Y, N'-', RIGHT(CONCAT(N'0', @M), 2), N'; PP=', @RowsPP, N'; PRD=', @RowsPRD, N'; FPC=', @RowsFPC);

                UPDATE ImportSIAC.BuildHistory_StepLog
                    SET ExtraInfo = @ExtraInfo
                WHERE BuildHistoryStepLogId = @StepLogId;

                FETCH NEXT FROM cur_fpc INTO @Y, @M;
            END;

            CLOSE cur_fpc;
            DEALLOCATE cur_fpc;
        END
        ELSE
        BEGIN
            EXEC sp_executesql
                @sql,
                N'@TipoAltro INT, @NormaFallback INT, @TipoQualificaFallback INT, @BatchByMonth BIT, @SnapshotYear INT, @SnapshotMonth INT, @SnapshotDate DATE, @SnapshotBusinessTs DATETIME2(7), @RowsOut BIGINT OUTPUT',
                @TipoAltro = @TipoAltro,
                @NormaFallback = @NormaFallback,
                @TipoQualificaFallback = @TipoQualificaFallback,
                @BatchByMonth = @BatchByMonth,
                @SnapshotYear = NULL,
                @SnapshotMonth = NULL,
                @SnapshotDate = NULL,
                @SnapshotBusinessTs = NULL,
                @RowsOut = @RowsFPC OUTPUT;
        END;

        SELECT
            @NormeFallback_PP = COALESCE(SUM(CASE WHEN Dominio = 'PP'  AND NormaFallbackUsata = 1 THEN 1 ELSE 0 END), 0),
            @NormeFallback_PRD = COALESCE(SUM(CASE WHEN Dominio = 'PRD' AND NormaFallbackUsata = 1 THEN 1 ELSE 0 END), 0),
            @NormeFallback_FPC = COALESCE(SUM(CASE WHEN Dominio = 'FPC' AND NormaFallbackUsata = 1 THEN 1 ELSE 0 END), 0)
        FROM ImportSIAC.wrk_All_Resolved
        OPTION (MAXDOP 8);

        CREATE CLUSTERED INDEX CX_All_Resolved
            ON ImportSIAC.wrk_All_Resolved
                (NumeroCertificato, OrganizzazioneODCId, DataPrimoRilascio, SnapshotYear, SnapshotMonth);

        SET @RigheDedup_PP = CONVERT(INT, @RowsPP);
        SET @RigheDedup_PRD = CONVERT(INT, @RowsPRD);
        SET @RigheDedup_FPC = CONVERT(INT, @RowsFPC);
        SET @Rows = @RowsPP + @RowsPRD + @RowsFPC;
        SET @RowsAffected = @Rows;

        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteMap;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteMapResolve;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PRD_OrgDaCensire;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PP_OrgDaCensire;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SG_OrgDaCensire;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ESTERO_OrgDaCensire;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Resolve_ODCScarti;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ResolvePeriods;

        SET @ExtraInfo = CONCAT
        (
            N'PP=', @RigheDedup_PP,
            N'; PRD=', @RigheDedup_PRD,
            N'; FPC=', @RigheDedup_FPC,
            N'; ODC_PP=', @ScartateODC_PP,
            N'; ODC_PRD=', @ScartateODC_PRD,
            N'; ODC_FPC=', @ScartateODC_FPC,
            N'; NF_PP=', @NormeFallback_PP,
            N'; NF_PRD=', @NormeFallback_PRD,
            N'; NF_FPC=', @NormeFallback_FPC,
            N'; Batches=', @BatchCount
        );

        UPDATE ImportSIAC.BuildHistory_StepLog
            SET FinishedAt = SYSUTCDATETIME(),
                DurationMs = DATEDIFF_BIG(MILLISECOND, StartedAt, SYSUTCDATETIME()),
                Status = N'SUCCESS',
                RowsAffected = @Rows,
                ExtraInfo = @ExtraInfo
        WHERE BuildHistoryStepLogId = @StepLogId;

        EXEC sys.sp_releaseapplock
            @Resource = N'ImportSIAC.BuildHistory.05_RESOLVE',
            @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) =
            LEFT(CONCAT(N'ERR ', ERROR_NUMBER(), N': ', ERROR_MESSAGE()), 4000);

        IF CURSOR_STATUS('local', 'cur_pp') >= 0
        BEGIN
            CLOSE cur_pp;
        END;

        IF CURSOR_STATUS('local', 'cur_pp') > -3
        BEGIN
            DEALLOCATE cur_pp;
        END;

        IF CURSOR_STATUS('local', 'cur_prd') >= 0
        BEGIN
            CLOSE cur_prd;
        END;

        IF CURSOR_STATUS('local', 'cur_prd') > -3
        BEGIN
            DEALLOCATE cur_prd;
        END;

        IF CURSOR_STATUS('local', 'cur_fpc') >= 0
        BEGIN
            CLOSE cur_fpc;
        END;

        IF CURSOR_STATUS('local', 'cur_fpc') > -3
        BEGIN
            DEALLOCATE cur_fpc;
        END;

        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteMapResolve;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Resolve_ODCScarti;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ResolvePeriods;

        IF @StepLogId IS NOT NULL
        BEGIN

            UPDATE ImportSIAC.BuildHistory_StepLog
                SET FinishedAt = SYSUTCDATETIME(),
                    DurationMs = DATEDIFF_BIG(MILLISECOND, StartedAt, SYSUTCDATETIME()),
                    Status = N'FAILED',
                    RowsAffected = @RowsPP + @RowsPRD + @RowsFPC,
                    ErrorMessage = @ErrMsg
            WHERE BuildHistoryStepLogId = @StepLogId;
        END;

        EXEC sys.sp_releaseapplock
            @Resource = N'ImportSIAC.BuildHistory.05_RESOLVE',
            @LockOwner = N'Session';

        THROW;
    END CATCH;
END;

GO

