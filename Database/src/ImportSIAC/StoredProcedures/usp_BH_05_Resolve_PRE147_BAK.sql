-- ================================================================================
-- ImportSIAC.usp_BH_05_Resolve - RIMPIAZZATA con logica V3 (materializzazione FPC condizionale)
-- Backup della versione precedente: usp_BH_05_Resolve_BASE_BAK
--
-- CORREZIONI rispetto a V2:
--  1. wrk_All_Resolved creata con CREATE TABLE esplicito e TIPI DERIVATI DALLA SORGENTE
--     (no SELECT TOP(0) fragile, no rischio mismatch/troncamento).
--  2. Chunk FPC con lista colonne esplicita (no SELECT *).
--  3. Materializzazione FPC CONDIZIONALE per dimensione mese (@FpcChunkThreshold).
--  4. Mantiene: scarto ODC anticipato, NC su wrk_All_Src, mappa cliente non-NULL,
--     fix norme PRD (wrk_NormaMap), ProfiloProfessionale per PRD.
-- ================================================================================
CREATE   PROCEDURE [ImportSIAC].[usp_BH_05_Resolve_PRE147_BAK]
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
    DECLARE @FpcChunkThreshold INT = 50000;  -- soglia interna materializzazione FPC

    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT = NULL;
    DECLARE @Rows BIGINT = 0, @RowsOut BIGINT = 0;
    DECLARE @RowsPP BIGINT = 0, @RowsPRD BIGINT = 0, @RowsFPC BIGINT = 0;
    DECLARE @BatchCount INT = 0, @LockResult INT, @ChunkRows INT;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @MaxDopHint NVARCHAR(40) = N'';
    DECLARE @IndexOptions NVARCHAR(100);
    DECLARE @ExtraInfo NVARCHAR(4000);
    DECLARE @Y INT, @M INT;
    DECLARE @SnapshotDate DATE, @SnapshotBusinessTs DATETIME2(7);
    DECLARE @TipoAltro INT, @NormaFallback INT, @TipoQualificaFallback INT;

    IF @BuildHistoryLogId IS NULL THROW 51200, 'BuildHistoryLogId obbligatorio.', 1;
    IF @MaxDop IS NULL SET @MaxDop = 4;
    IF @MaxDop > 8 THROW 51201, 'MaxDop non valido (0 o 1-8).', 1;
    IF @MaxDop > 0 SET @MaxDopHint = N' OPTION (MAXDOP ' + CONVERT(NVARCHAR(3), @MaxDop) + N')';
    SET @IndexOptions = CASE WHEN @MaxDop > 0
        THEN N'MAXDOP = ' + CONVERT(NVARCHAR(3), @MaxDop) + N', ONLINE = OFF' ELSE N'ONLINE = OFF' END;

    EXEC @LockResult = sys.sp_getapplock
        @Resource = N'ImportSIAC.BuildHistory.05_RESOLVE',
        @LockMode = N'Exclusive', @LockOwner = N'Session', @LockTimeout = 0;
    IF @LockResult < 0 THROW 51202, 'Step 05_RESOLVE gia in esecuzione.', 1;

    -- ============ CHECKPOINT: skip se l'output e' ancora valido sul disco ============
    DECLARE @CkValid BIT = 0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'05_RESOLVE', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        -- MIG_119: resume 05 da metriche checkpoint
        DECLARE @CheckpointMetrics nvarchar(2000), @CheckpointRows bigint;
        SELECT @CheckpointMetrics=MetricsJson,@CheckpointRows=RowCountAtSave
        FROM ImportSIAC.BuildHistory_Checkpoint
        WHERE StepCode=N'05_RESOLVE' AND Status=N'VALID';
        SET @RigheDedup_PP=TRY_CONVERT(int,JSON_VALUE(@CheckpointMetrics,N'$.RigheDedup_PP'));
        SET @RigheDedup_PRD=TRY_CONVERT(int,JSON_VALUE(@CheckpointMetrics,N'$.RigheDedup_PRD'));
        SET @RigheDedup_FPC=TRY_CONVERT(int,JSON_VALUE(@CheckpointMetrics,N'$.RigheDedup_FPC'));
        SET @NormeFallback_PP=TRY_CONVERT(int,JSON_VALUE(@CheckpointMetrics,N'$.NormeFallback_PP'));
        SET @NormeFallback_PRD=TRY_CONVERT(int,JSON_VALUE(@CheckpointMetrics,N'$.NormeFallback_PRD'));
        SET @NormeFallback_FPC=TRY_CONVERT(int,JSON_VALUE(@CheckpointMetrics,N'$.NormeFallback_FPC'));
        IF @CheckpointMetrics IS NULL OR ISJSON(@CheckpointMetrics)<>1
           OR @RigheDedup_PP IS NULL OR @RigheDedup_PRD IS NULL OR @RigheDedup_FPC IS NULL
           OR @NormeFallback_PP IS NULL OR @NormeFallback_PRD IS NULL OR @NormeFallback_FPC IS NULL
           OR @RigheDedup_PP<0 OR @RigheDedup_PRD<0 OR @RigheDedup_FPC<0
           OR @NormeFallback_PP<0 OR @NormeFallback_PRD<0 OR @NormeFallback_FPC<0
           OR CONVERT(bigint,@RigheDedup_PP)+CONVERT(bigint,@RigheDedup_PRD)+CONVERT(bigint,@RigheDedup_FPC)<>@CheckpointRows
           OR @NormeFallback_PP>@RigheDedup_PP OR @NormeFallback_PRD>@RigheDedup_PRD OR @NormeFallback_FPC>@RigheDedup_FPC
        BEGIN
            SET @CkValid=0;
            UPDATE ImportSIAC.BuildHistory_Checkpoint
               SET Status=N'STALE',Notes=LEFT(CONCAT(N'Checkpoint invalidato: metriche 05 assenti o incoerenti. ',COALESCE(Notes,N'')),500)
             WHERE StepCode=N'05_RESOLVE' AND Status=N'VALID';
            INSERT ImportSIAC.BuildHistory_CheckpointAudit
                (StepCode,OutputTable,ExpectedRows,ActualRows,IsValid,Reason)
            VALUES
                (N'05_RESOLVE',N'ImportSIAC.wrk_All_Resolved',@CheckpointRows,NULL,0,N'Metriche checkpoint 05 assenti o incoerenti');
        END;
        IF @CkValid=1
        BEGIN
            SET @ScartateODC_PP=0; SET @ScartateODC_PRD=0; SET @ScartateODC_FPC=0;
            SET @RowsAffected=CONVERT(bigint,@RigheDedup_PP)+CONVERT(bigint,@RigheDedup_PRD)+CONVERT(bigint,@RigheDedup_FPC);
            INSERT INTO ImportSIAC.BuildHistory_StepLog
                (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,SessionId,HostName,AppName,RowsAffected,ExtraInfo)
            VALUES
                (@BuildHistoryLogId,5,N'05_RESOLVE',N'Resolve (RESUMED da metriche checkpoint)',@StepStart,SYSUTCDATETIME(),DATEDIFF_BIG(MILLISECOND,@StepStart,SYSUTCDATETIME()),
                 N'SUCCESS',@@SPID,HOST_NAME(),APP_NAME(),@RowsAffected,
                 CONCAT(N'RESUMED: metriche checkpoint; righe=',@RowsAffected,N'; NF_PP=',@NormeFallback_PP,N'; NF_PRD=',@NormeFallback_PRD,N'; NF_FPC=',@NormeFallback_FPC));
            EXEC sys.sp_releaseapplock @Resource=N'ImportSIAC.BuildHistory.05_RESOLVE',@LockOwner=N'Session';
            RETURN;
        END;
    END;
    -- ============ FINE CHECKPOINT: procedo con l'esecuzione normale ============

    BEGIN TRY
        IF OBJECT_ID(N'ImportSIAC.wrk_All_Src', N'U') IS NULL THROW 51203, 'wrk_All_Src non esiste.', 1;
        IF OBJECT_ID(N'ImportSIAC.wrk_NormaMap', N'U') IS NULL THROW 51204, 'wrk_NormaMap non esiste (step 02).', 1;
        IF OBJECT_ID(N'ImportSIAC.wrk_ClienteMap', N'U') IS NULL THROW 51205, 'wrk_ClienteMap non esiste (step 04B).', 1;

        SELECT @TipoAltro = TipoCertificazioneId FROM Certificazione.TipoCertificazione WHERE Codice='ALTRO' AND DataCancellazione IS NULL;
        SELECT @NormaFallback = MIN(NormaAccreditamentoId) FROM Standard.NormaAccreditamento WHERE DataCancellazione IS NULL AND Attivo=1;
        SELECT @TipoQualificaFallback = TipoQualificaId FROM Tipologica.TipoQualifica WHERE Codice='ALTRO' AND DataCancellazione IS NULL;
        IF @TipoAltro IS NULL THROW 51206, 'Lookup TipoCertificazione ALTRO.', 1;
        IF @NormaFallback IS NULL THROW 51207, 'Lookup NormaAccreditamento.', 1;
        IF @TipoQualificaFallback IS NULL THROW 51208, 'Lookup TipoQualifica ALTRO.', 1;

        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId, StepNo, StepCode, StepName, StartedAt, Status, SessionId, HostName, AppName)
        VALUES (@BuildHistoryLogId, 5, N'05_RESOLVE', N'Resolve + scarto ODC (V3)', @StepStart, N'RUNNING', @@SPID, HOST_NAME(), APP_NAME());
        SET @StepLogId = SCOPE_IDENTITY();

        DROP TABLE IF EXISTS ImportSIAC.wrk_All_Resolved;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteMapResolve;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Resolve_ODCScarti;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ResolvePeriods;
        DROP TABLE IF EXISTS ImportSIAC.wrk_CurrentResolve_FPC;

        -- Access path sorgente: NC veloce (evita CX da 2h + spill tempdb)
        IF @CreateSourceIndex = 1
        AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID(N'ImportSIAC.wrk_All_Src',N'U')
                        AND name IN (N'IX_wrk_All_Src_DominioPeriodo',N'IX_wrk_All_Src_Resolve_DominioPeriodo',N'CX_wrk_All_Src_Resolve'))
        BEGIN
            SET @sql = N'CREATE NONCLUSTERED INDEX IX_wrk_All_Src_DominioPeriodo
ON ImportSIAC.wrk_All_Src (Dominio, SnapshotYear, SnapshotMonth) INCLUDE (RawId) WITH (' + @IndexOptions + N');';
            EXEC sp_executesql @sql;
        END;

        -- Mappa cliente con chiavi non-NULL
        SELECT ISNULL(fiscal_code, N'') AS fiscal_code_key, ISNULL(vat_number, N'') AS vat_number_key, OrganizzazioneClienteId
        INTO ImportSIAC.wrk_ClienteMapResolve FROM ImportSIAC.wrk_ClienteMap;
        CREATE CLUSTERED INDEX CX_ClienteMapResolve ON ImportSIAC.wrk_ClienteMapResolve (fiscal_code_key, vat_number_key);

        -- CORREZIONE 1: struttura esplicita con tipi DERIVATI dalla sorgente
        CREATE TABLE ImportSIAC.wrk_All_Resolved (
            RawId BIGINT, Dominio NVARCHAR(3), SnapshotYear SMALLINT, SnapshotMonth TINYINT,
            SnapshotDate DATE, SnapshotBusinessTs DATETIME2(7),
            NumeroCertificato NVARCHAR(200), codente NVARCHAR(300),
            DataPrimoRilascio DATE, DataEmissione DATE, DataScadenza DATE, DataRevoca DATE,
            Privato BIT, StatoCertificazioneId INT, publication_date DATETIME2(7), insertdate DATETIME2(7),
            OrganizzazioneODCId INT, TipoCertificazioneId INT, NormaAccreditamentoId INT, NormaFallbackUsata BIT,
            OrganizzazioneClienteId INT,
            AmbitoIta NVARCHAR(MAX), AmbitoEng NVARCHAR(MAX), DataUltimoRinnovo DATE,
            sede_address NVARCHAR(1000), sede_city NVARCHAR(400), sede_zip NVARCHAR(100),
            raw_site_type NVARCHAR(50), raw_site_province NVARCHAR(100), raw_site_country NVARCHAR(100),
            ScopoCertificato NVARCHAR(MAX), NomeProdotto NVARCHAR(MAX), SpecificaTecnica NVARCHAR(MAX),
            ProfiloProfessionaleId INT,
            person_code NVARCHAR(150), first_name NVARCHAR(400), last_name NVARCHAR(400),
            birth_date DATE, birth_place NVARCHAR(400), fpc_fiscal_code NVARCHAR(100),
            professional_code_json NVARCHAR(4000), competence_level NVARCHAR(MAX),
            Straniero BIT, SiacId INT, fpc_release_date DATE, TipoQualificaId INT
        );

        -- Scarti ODC anticipati (no INSERT+DELETE)
        SELECT src.Dominio, src.RawId, src.SnapshotYear, src.SnapshotMonth, src.codente, src.NumeroCertificato
        INTO ImportSIAC.wrk_Resolve_ODCScarti
        FROM ImportSIAC.wrk_All_Src src
        LEFT JOIN Organizzazioni.Organizzazione odc ON odc.CodOrganizzazione = src.codente AND odc.DataCancellazione IS NULL
        WHERE odc.OrganizzazioneId IS NULL AND src.Dominio IN ('PP','PRD','FPC')
        OPTION (MAXDOP 8);

        SELECT @ScartateODC_PP = COALESCE(SUM(CASE WHEN Dominio='PP' THEN 1 ELSE 0 END),0),
               @ScartateODC_PRD = COALESCE(SUM(CASE WHEN Dominio='PRD' THEN 1 ELSE 0 END),0),
               @ScartateODC_FPC = COALESCE(SUM(CASE WHEN Dominio='FPC' THEN 1 ELSE 0 END),0)
        FROM ImportSIAC.wrk_Resolve_ODCScarti;

        INSERT INTO ImportSIAC.BuildHistory_SkippedRow
            (BuildHistoryLogId, Dominio, RawId, SnapshotYear, SnapshotMonth, Codente, NumeroCertificato, MotivoScarto)
        SELECT @BuildHistoryLogId, Dominio, RawId, SnapshotYear, SnapshotMonth, codente, NumeroCertificato, 'ODC_NOT_FOUND'
        FROM ImportSIAC.wrk_Resolve_ODCScarti OPTION (MAXDOP 8);

        SELECT DISTINCT Dominio, SnapshotYear, SnapshotMonth
        INTO ImportSIAC.wrk_ResolvePeriods
        FROM ImportSIAC.wrk_All_Src WHERE Dominio IN ('PP','PRD','FPC');
        CREATE CLUSTERED INDEX CX_ResolvePeriods ON ImportSIAC.wrk_ResolvePeriods (Dominio, SnapshotYear, SnapshotMonth);

        -- ============ PP ============
        DECLARE cur_pp CURSOR LOCAL FAST_FORWARD FOR
            SELECT SnapshotYear, SnapshotMonth FROM ImportSIAC.wrk_ResolvePeriods WHERE Dominio='PP' ORDER BY SnapshotYear, SnapshotMonth;
        OPEN cur_pp; FETCH NEXT FROM cur_pp INTO @Y, @M;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @RowsOut = 0;
            SET @SnapshotDate = DATEFROMPARTS(@Y,@M,1);
            SET @SnapshotBusinessTs = DATEADD(NANOSECOND,-100, DATEADD(DAY,1, CAST(EOMONTH(@SnapshotDate) AS DATETIME2(7))));
            SET @sql = N'
INSERT INTO ImportSIAC.wrk_All_Resolved WITH (TABLOCK)
SELECT src.RawId, src.Dominio, src.SnapshotYear, src.SnapshotMonth, @SnapshotDate, @SnapshotBusinessTs,
    src.NumeroCertificato, src.codente, src.DataPrimoRilascio, src.DataEmissione, src.DataScadenza,
    src.DataRevoca, src.Privato, src.StatoCertificazioneId, src.publication_date, src.insertdate,
    odc.OrganizzazioneId, COALESCE(tc.TipoCertificazioneId,@TipoAltro),
    COALESCE(nm.NormaAccreditamentoId,@NormaFallback), CASE WHEN nm.NormaAccreditamentoId IS NULL THEN 1 ELSE 0 END,
    cm.OrganizzazioneClienteId, src.AmbitoIta, src.AmbitoEng, src.DataUltimoRinnovo,
    src.sede_address, src.sede_city, src.sede_zip, src.raw_site_type, src.raw_site_province, src.raw_site_country,
    src.ScopoCertificato, src.NomeProdotto, src.SpecificaTecnica, CAST(NULL AS INT),
    src.person_code, src.first_name, src.last_name, src.birth_date, src.birth_place, src.fpc_fiscal_code,
    src.professional_code_json, src.competence_level,
    CASE WHEN src.foreigner_json=''SI'' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END,
    src.id_group_json, src.fpc_release_date, @TipoQualificaFallback
FROM ImportSIAC.wrk_All_Src src
INNER JOIN Organizzazioni.Organizzazione odc ON odc.CodOrganizzazione=src.codente AND odc.DataCancellazione IS NULL
LEFT JOIN Certificazione.TipoCertificazione tc ON tc.Codice=src.siglaschema AND tc.DataCancellazione IS NULL
LEFT JOIN ImportSIAC.wrk_NormaMap nm ON nm.norma_raw=src.norma_raw
CROSS APPLY (SELECT ISNULL(NULLIF(LTRIM(RTRIM(src.fiscal_code)),''''),'''') AS fiscal_code_key,
                    ISNULL(NULLIF(LTRIM(RTRIM(src.vat_number)),''''),'''') AS vat_number_key) k
LEFT JOIN ImportSIAC.wrk_ClienteMapResolve cm ON cm.fiscal_code_key=k.fiscal_code_key AND cm.vat_number_key=k.vat_number_key
WHERE src.Dominio=''PP'' AND src.SnapshotYear=@SnapshotYear AND src.SnapshotMonth=@SnapshotMonth' + @MaxDopHint + N';
SET @RowsOut=@@ROWCOUNT;';
            EXEC sp_executesql @sql,
                N'@TipoAltro INT,@NormaFallback INT,@TipoQualificaFallback INT,@SnapshotYear INT,@SnapshotMonth INT,@SnapshotDate DATE,@SnapshotBusinessTs DATETIME2(7),@RowsOut BIGINT OUTPUT',
                @TipoAltro=@TipoAltro,@NormaFallback=@NormaFallback,@TipoQualificaFallback=@TipoQualificaFallback,
                @SnapshotYear=@Y,@SnapshotMonth=@M,@SnapshotDate=@SnapshotDate,@SnapshotBusinessTs=@SnapshotBusinessTs,@RowsOut=@RowsOut OUTPUT;
            SET @RowsPP += @RowsOut; SET @BatchCount += 1;
            UPDATE ImportSIAC.BuildHistory_StepLog SET ExtraInfo = CONCAT(N'PP ',@Y,'-',RIGHT(CONCAT('0',@M),2),'; PP=',@RowsPP) WHERE BuildHistoryStepLogId=@StepLogId;
            FETCH NEXT FROM cur_pp INTO @Y, @M;
        END;
        CLOSE cur_pp; DEALLOCATE cur_pp;

        -- ============ PRD (con ProfiloProfessionale) ============
        DECLARE cur_prd CURSOR LOCAL FAST_FORWARD FOR
            SELECT SnapshotYear, SnapshotMonth FROM ImportSIAC.wrk_ResolvePeriods WHERE Dominio='PRD' ORDER BY SnapshotYear, SnapshotMonth;
        OPEN cur_prd; FETCH NEXT FROM cur_prd INTO @Y, @M;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @RowsOut = 0;
            SET @SnapshotDate = DATEFROMPARTS(@Y,@M,1);
            SET @SnapshotBusinessTs = DATEADD(NANOSECOND,-100, DATEADD(DAY,1, CAST(EOMONTH(@SnapshotDate) AS DATETIME2(7))));
            SET @sql = N'
INSERT INTO ImportSIAC.wrk_All_Resolved WITH (TABLOCK)
SELECT src.RawId, src.Dominio, src.SnapshotYear, src.SnapshotMonth, @SnapshotDate, @SnapshotBusinessTs,
    src.NumeroCertificato, src.codente, src.DataPrimoRilascio, src.DataEmissione, src.DataScadenza,
    src.DataRevoca, src.Privato, src.StatoCertificazioneId, src.publication_date, src.insertdate,
    odc.OrganizzazioneId, @TipoAltro,
    COALESCE(nm.NormaAccreditamentoId,@NormaFallback), CASE WHEN nm.NormaAccreditamentoId IS NULL THEN 1 ELSE 0 END,
    cm.OrganizzazioneClienteId, src.AmbitoIta, src.AmbitoEng, src.DataUltimoRinnovo,
    src.sede_address, src.sede_city, src.sede_zip, src.raw_site_type, src.raw_site_province, src.raw_site_country,
    src.ScopoCertificato, src.NomeProdotto, src.SpecificaTecnica, CAST(NULL AS int) AS ProfiloProfessionaleId /* MIG_111A: PRD usa profilo tecnico */,
    src.person_code, src.first_name, src.last_name, src.birth_date, src.birth_place, src.fpc_fiscal_code,
    src.professional_code_json, src.competence_level,
    CASE WHEN src.foreigner_json=''SI'' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END,
    src.id_group_json, src.fpc_release_date, @TipoQualificaFallback
FROM ImportSIAC.wrk_All_Src src
INNER JOIN Organizzazioni.Organizzazione odc ON odc.CodOrganizzazione=src.codente AND odc.DataCancellazione IS NULL
LEFT JOIN ImportSIAC.wrk_NormaMap nm ON nm.norma_raw=src.norma_raw
CROSS APPLY (SELECT ISNULL(NULLIF(LTRIM(RTRIM(src.fiscal_code)),''''),'''') AS fiscal_code_key,
                    ISNULL(NULLIF(LTRIM(RTRIM(src.vat_number)),''''),'''') AS vat_number_key) k
LEFT JOIN ImportSIAC.wrk_ClienteMapResolve cm ON cm.fiscal_code_key=k.fiscal_code_key AND cm.vat_number_key=k.vat_number_key

WHERE src.Dominio=''PRD'' AND src.SnapshotYear=@SnapshotYear AND src.SnapshotMonth=@SnapshotMonth' + @MaxDopHint + N';
SET @RowsOut=@@ROWCOUNT;';
            EXEC sp_executesql @sql,
                N'@TipoAltro INT,@NormaFallback INT,@TipoQualificaFallback INT,@SnapshotYear INT,@SnapshotMonth INT,@SnapshotDate DATE,@SnapshotBusinessTs DATETIME2(7),@RowsOut BIGINT OUTPUT',
                @TipoAltro=@TipoAltro,@NormaFallback=@NormaFallback,@TipoQualificaFallback=@TipoQualificaFallback,
                @SnapshotYear=@Y,@SnapshotMonth=@M,@SnapshotDate=@SnapshotDate,@SnapshotBusinessTs=@SnapshotBusinessTs,@RowsOut=@RowsOut OUTPUT;
            SET @RowsPRD += @RowsOut; SET @BatchCount += 1;
            UPDATE ImportSIAC.BuildHistory_StepLog SET ExtraInfo = CONCAT(N'PRD ',@Y,'-',RIGHT(CONCAT('0',@M),2),'; PP=',@RowsPP,'; PRD=',@RowsPRD) WHERE BuildHistoryStepLogId=@StepLogId;
            FETCH NEXT FROM cur_prd INTO @Y, @M;
        END;
        CLOSE cur_prd; DEALLOCATE cur_prd;

        -- ============ FPC (materializzazione CONDIZIONALE per dimensione) ============
        DECLARE cur_fpc CURSOR LOCAL FAST_FORWARD FOR
            SELECT SnapshotYear, SnapshotMonth FROM ImportSIAC.wrk_ResolvePeriods WHERE Dominio='FPC' ORDER BY SnapshotYear, SnapshotMonth;
        OPEN cur_fpc; FETCH NEXT FROM cur_fpc INTO @Y, @M;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @RowsOut = 0;
            SET @SnapshotDate = DATEFROMPARTS(@Y,@M,1);
            SET @SnapshotBusinessTs = DATEADD(NANOSECOND,-100, DATEADD(DAY,1, CAST(EOMONTH(@SnapshotDate) AS DATETIME2(7))));

            -- Conta righe del mese per decidere la strategia
            SELECT @ChunkRows = COUNT_BIG(*) FROM ImportSIAC.wrk_All_Src
            WHERE Dominio='FPC' AND SnapshotYear=@Y AND SnapshotMonth=@M;

            IF @ChunkRows >= @FpcChunkThreshold
            BEGIN
                -- CORREZIONE 2+3: chunk grande -> materializza con lista colonne esplicita + CX
                DROP TABLE IF EXISTS ImportSIAC.wrk_CurrentResolve_FPC;
                SET @sql = N'
SELECT RawId, Dominio, SnapshotYear, SnapshotMonth, NumeroCertificato, codente,
       DataPrimoRilascio, DataEmissione, DataScadenza, DataRevoca, Privato, StatoCertificazioneId,
       publication_date, insertdate, norma_raw, AmbitoIta, AmbitoEng, DataUltimoRinnovo,
       sede_address, sede_city, sede_zip, raw_site_type, raw_site_province, raw_site_country,
       ScopoCertificato, NomeProdotto, SpecificaTecnica,
       person_code, first_name, last_name, birth_date, birth_place, fpc_fiscal_code,
       professional_code_json, competence_level, foreigner_json, id_group_json, fpc_release_date
INTO ImportSIAC.wrk_CurrentResolve_FPC
FROM ImportSIAC.wrk_All_Src
WHERE Dominio=''FPC'' AND SnapshotYear=@SnapshotYear AND SnapshotMonth=@SnapshotMonth
OPTION (RECOMPILE' + CASE WHEN @MaxDop>0 THEN N', MAXDOP '+CONVERT(NVARCHAR(3),@MaxDop) ELSE N'' END + N');';
                EXEC sp_executesql @sql, N'@SnapshotYear INT,@SnapshotMonth INT', @SnapshotYear=@Y,@SnapshotMonth=@M;

                SET @sql = N'CREATE CLUSTERED INDEX CX_wrk_CurrentResolve_FPC ON ImportSIAC.wrk_CurrentResolve_FPC (codente, RawId) WITH (' + @IndexOptions + N');';
                EXEC sp_executesql @sql;

                SET @sql = N'
INSERT INTO ImportSIAC.wrk_All_Resolved WITH (TABLOCK)
SELECT src.RawId, src.Dominio, src.SnapshotYear, src.SnapshotMonth, @SnapshotDate, @SnapshotBusinessTs,
    src.NumeroCertificato, src.codente, src.DataPrimoRilascio, src.DataEmissione, src.DataScadenza,
    src.DataRevoca, src.Privato, src.StatoCertificazioneId, src.publication_date, src.insertdate,
    odc.OrganizzazioneId, @TipoAltro,
    COALESCE(nm.NormaAccreditamentoId,@NormaFallback), CASE WHEN nm.NormaAccreditamentoId IS NULL THEN 1 ELSE 0 END,
    CAST(NULL AS INT), src.AmbitoIta, src.AmbitoEng, src.DataUltimoRinnovo,
    src.sede_address, src.sede_city, src.sede_zip, src.raw_site_type, src.raw_site_province, src.raw_site_country,
    src.ScopoCertificato, src.NomeProdotto, src.SpecificaTecnica, CAST(NULL AS INT),
    src.person_code, src.first_name, src.last_name, src.birth_date, src.birth_place, src.fpc_fiscal_code,
    src.professional_code_json, src.competence_level,
    CASE WHEN src.foreigner_json=''SI'' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END,
    src.id_group_json, src.fpc_release_date, COALESCE(tq.TipoQualificaId,@TipoQualificaFallback)
FROM ImportSIAC.wrk_CurrentResolve_FPC src
INNER JOIN Organizzazioni.Organizzazione odc ON odc.CodOrganizzazione=src.codente AND odc.DataCancellazione IS NULL
LEFT JOIN ImportSIAC.wrk_NormaMap nm ON nm.norma_raw=src.norma_raw
LEFT JOIN Tipologica.TipoQualifica tq ON tq.Codice=src.professional_code_json AND tq.DataCancellazione IS NULL
OPTION (RECOMPILE' + CASE WHEN @MaxDop>0 THEN N', MAXDOP '+CONVERT(NVARCHAR(3),@MaxDop) ELSE N'' END + N');
SET @RowsOut=@@ROWCOUNT;';
                EXEC sp_executesql @sql,
                    N'@TipoAltro INT,@NormaFallback INT,@TipoQualificaFallback INT,@SnapshotDate DATE,@SnapshotBusinessTs DATETIME2(7),@RowsOut BIGINT OUTPUT',
                    @TipoAltro=@TipoAltro,@NormaFallback=@NormaFallback,@TipoQualificaFallback=@TipoQualificaFallback,
                    @SnapshotDate=@SnapshotDate,@SnapshotBusinessTs=@SnapshotBusinessTs,@RowsOut=@RowsOut OUTPUT;
                DROP TABLE IF EXISTS ImportSIAC.wrk_CurrentResolve_FPC;
            END
            ELSE
            BEGIN
                -- Chunk piccolo -> join diretto (evita overhead create/index/drop)
                SET @sql = N'
INSERT INTO ImportSIAC.wrk_All_Resolved WITH (TABLOCK)
SELECT src.RawId, src.Dominio, src.SnapshotYear, src.SnapshotMonth, @SnapshotDate, @SnapshotBusinessTs,
    src.NumeroCertificato, src.codente, src.DataPrimoRilascio, src.DataEmissione, src.DataScadenza,
    src.DataRevoca, src.Privato, src.StatoCertificazioneId, src.publication_date, src.insertdate,
    odc.OrganizzazioneId, @TipoAltro,
    COALESCE(nm.NormaAccreditamentoId,@NormaFallback), CASE WHEN nm.NormaAccreditamentoId IS NULL THEN 1 ELSE 0 END,
    CAST(NULL AS INT), src.AmbitoIta, src.AmbitoEng, src.DataUltimoRinnovo,
    src.sede_address, src.sede_city, src.sede_zip, src.raw_site_type, src.raw_site_province, src.raw_site_country,
    src.ScopoCertificato, src.NomeProdotto, src.SpecificaTecnica, CAST(NULL AS INT),
    src.person_code, src.first_name, src.last_name, src.birth_date, src.birth_place, src.fpc_fiscal_code,
    src.professional_code_json, src.competence_level,
    CASE WHEN src.foreigner_json=''SI'' THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END,
    src.id_group_json, src.fpc_release_date, COALESCE(tq.TipoQualificaId,@TipoQualificaFallback)
FROM ImportSIAC.wrk_All_Src src
INNER JOIN Organizzazioni.Organizzazione odc ON odc.CodOrganizzazione=src.codente AND odc.DataCancellazione IS NULL
LEFT JOIN ImportSIAC.wrk_NormaMap nm ON nm.norma_raw=src.norma_raw
LEFT JOIN Tipologica.TipoQualifica tq ON tq.Codice=src.professional_code_json AND tq.DataCancellazione IS NULL
WHERE src.Dominio=''FPC'' AND src.SnapshotYear=@SnapshotYear AND src.SnapshotMonth=@SnapshotMonth' + @MaxDopHint + N';
SET @RowsOut=@@ROWCOUNT;';
                EXEC sp_executesql @sql,
                    N'@TipoAltro INT,@NormaFallback INT,@TipoQualificaFallback INT,@SnapshotYear INT,@SnapshotMonth INT,@SnapshotDate DATE,@SnapshotBusinessTs DATETIME2(7),@RowsOut BIGINT OUTPUT',
                    @TipoAltro=@TipoAltro,@NormaFallback=@NormaFallback,@TipoQualificaFallback=@TipoQualificaFallback,
                    @SnapshotYear=@Y,@SnapshotMonth=@M,@SnapshotDate=@SnapshotDate,@SnapshotBusinessTs=@SnapshotBusinessTs,@RowsOut=@RowsOut OUTPUT;
            END;

            SET @RowsFPC += @RowsOut; SET @BatchCount += 1;
            UPDATE ImportSIAC.BuildHistory_StepLog SET ExtraInfo = CONCAT(N'FPC ',@Y,'-',RIGHT(CONCAT('0',@M),2),'; PP=',@RowsPP,'; PRD=',@RowsPRD,'; FPC=',@RowsFPC) WHERE BuildHistoryStepLogId=@StepLogId;
            FETCH NEXT FROM cur_fpc INTO @Y, @M;
        END;
        CLOSE cur_fpc; DEALLOCATE cur_fpc;

        -- Conteggio norme fallback
        SELECT @NormeFallback_PP = COALESCE(SUM(CASE WHEN Dominio='PP' AND NormaFallbackUsata=1 THEN 1 ELSE 0 END),0),
               @NormeFallback_PRD = COALESCE(SUM(CASE WHEN Dominio='PRD' AND NormaFallbackUsata=1 THEN 1 ELSE 0 END),0),
               @NormeFallback_FPC = COALESCE(SUM(CASE WHEN Dominio='FPC' AND NormaFallbackUsata=1 THEN 1 ELSE 0 END),0)
        FROM ImportSIAC.wrk_All_Resolved OPTION (MAXDOP 8);

        CREATE CLUSTERED COLUMNSTORE INDEX CCI_All_Resolved ON ImportSIAC.wrk_All_Resolved WITH (MAXDOP = 4); -- MIG_137: CCI al posto del CX rowstore (log rate, batch mode)
            -- MIG_137: chiave rowstore rimossa: (NumeroCertificato, OrganizzazioneODCId, DataPrimoRilascio, SnapshotYear, SnapshotMonth)

        SET @RigheDedup_PP = CONVERT(INT,@RowsPP); SET @RigheDedup_PRD = CONVERT(INT,@RowsPRD); SET @RigheDedup_FPC = CONVERT(INT,@RowsFPC);
        SET @Rows = @RowsPP + @RowsPRD + @RowsFPC; SET @RowsAffected = @Rows;

        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteMapResolve;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Resolve_ODCScarti;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ResolvePeriods;
        DROP TABLE IF EXISTS ImportSIAC.wrk_CurrentResolve_FPC;

        SET @ExtraInfo = CONCAT(N'PP=',@RigheDedup_PP,'; PRD=',@RigheDedup_PRD,'; FPC=',@RigheDedup_FPC,
            '; ODC_PP=',@ScartateODC_PP,'; ODC_PRD=',@ScartateODC_PRD,'; ODC_FPC=',@ScartateODC_FPC,
            '; NF_PP=',@NormeFallback_PP,'; NF_PRD=',@NormeFallback_PRD,'; NF_FPC=',@NormeFallback_FPC,'; Batches=',@BatchCount);

        UPDATE ImportSIAC.BuildHistory_StepLog
            SET FinishedAt=SYSUTCDATETIME(), DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
                Status=N'SUCCESS', RowsAffected=@Rows, ExtraInfo=@ExtraInfo
        WHERE BuildHistoryStepLogId=@StepLogId;

        -- ============ CHECKPOINT + METRICHE: transazione atomica ============
        BEGIN TRANSACTION;
        BEGIN TRY
            EXEC ImportSIAC.usp_BH_Checkpoint_Mark
                @StepCode=N'05_RESOLVE',@OutputTable=N'ImportSIAC.wrk_All_Resolved',
                @RowCountAtSave=@Rows,@SourceSignature=NULL,
                @Notes=N'Resolve completo (V3): scarto ODC anticipato + materializzazione FPC condizionale.';
            UPDATE ImportSIAC.BuildHistory_Checkpoint
               SET MetricsJson=CONCAT
                   (N'{"Version":1,"SourceStepLogId":',@StepLogId,
                    N',"RigheDedup_PP":',@RigheDedup_PP,N',"RigheDedup_PRD":',@RigheDedup_PRD,
                    N',"RigheDedup_FPC":',@RigheDedup_FPC,N',"NormeFallback_PP":',@NormeFallback_PP,
                    N',"NormeFallback_PRD":',@NormeFallback_PRD,N',"NormeFallback_FPC":',@NormeFallback_FPC,N'}')
             WHERE StepCode=N'05_RESOLVE' AND Status=N'VALID';
            IF @@ROWCOUNT<>1 THROW 51229,'Checkpoint 05 non aggiornato con le metriche.',1;
            UPDATE ImportSIAC.BuildHistory_CheckpointOutput
               SET ValidationMode='METADATA'
             WHERE StepCode=N'05_RESOLVE' AND OutputTable=N'ImportSIAC.wrk_All_Resolved';
            IF @@ROWCOUNT<>1 THROW 51230,'Modalita di validazione checkpoint 05 non aggiornata.',1;
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF XACT_STATE()<>0 ROLLBACK TRANSACTION;
            THROW;
        END CATCH;

        EXEC sys.sp_releaseapplock @Resource=N'ImportSIAC.BuildHistory.05_RESOLVE', @LockOwner=N'Session';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
        IF CURSOR_STATUS('local','cur_pp')>=0 CLOSE cur_pp;
        IF CURSOR_STATUS('local','cur_pp')>-3 DEALLOCATE cur_pp;
        IF CURSOR_STATUS('local','cur_prd')>=0 CLOSE cur_prd;
        IF CURSOR_STATUS('local','cur_prd')>-3 DEALLOCATE cur_prd;
        IF CURSOR_STATUS('local','cur_fpc')>=0 CLOSE cur_fpc;
        IF CURSOR_STATUS('local','cur_fpc')>-3 DEALLOCATE cur_fpc;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteMapResolve;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Resolve_ODCScarti;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ResolvePeriods;
        DROP TABLE IF EXISTS ImportSIAC.wrk_CurrentResolve_FPC;
        IF @StepLogId IS NOT NULL
            UPDATE ImportSIAC.BuildHistory_StepLog
                SET FinishedAt=SYSUTCDATETIME(), DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
                    Status=N'FAILED', RowsAffected=@RowsPP+@RowsPRD+@RowsFPC, ErrorMessage=@ErrMsg
            WHERE BuildHistoryStepLogId=@StepLogId;
        EXEC sys.sp_releaseapplock @Resource=N'ImportSIAC.BuildHistory.05_RESOLVE', @LockOwner=N'Session';
        THROW;
    END CATCH;
END;

GO

