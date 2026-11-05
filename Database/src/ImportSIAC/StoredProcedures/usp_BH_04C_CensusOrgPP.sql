 
-- ================================================================================
-- ImportSIAC.usp_BH_04C_CensusOrgPP (15117 caratteri)
-- ================================================================================

/*
    Step 04C_PP refactor.

    Replace the original 04C_PP block in ImportSIAC.usp_BuildHistory_All with:

        EXEC ImportSIAC.usp_BH_04C_CensusOrgPP
             @BuildHistoryLogId = @LogId,
             @MaxDop = @MaxDop,
             @RowsAffected = @Rows OUTPUT,
             @OrgCensitePP = @OrgCensitePP OUTPUT;

        SET @OrgCensite = @OrgCensite + @OrgCensitePP;

    Preconditions:
      - ImportSIAC.wrk_All_Src exists and is populated.
      - ImportSIAC.wrk_ClienteMap exists from step 04B.
      - Lookup rows for the TipoSede / TipoOrganizzazioneSede codes exist.

    Design notes:
      - The old statement ranked all PP source rows, then discarded rows already
        resolved in wrk_ClienteMap. This version starts from unresolved map keys.
      - PP organization creation is deduplicated by fiscal_code. For Italian legal
        entities, the 11 digit fiscal_code is the stable organization key.
      - wrk_PP_OrgDaCensire is still produced for compatibility with downstream
        cleanup/diagnostics.
*/
CREATE PROCEDURE ImportSIAC.usp_BH_04C_CensusOrgPP
    @BuildHistoryLogId INT,
    @MaxDop TINYINT = 2,
    @RowsAffected BIGINT = NULL OUTPUT,
    @OrgCensitePP INT = NULL OUTPUT,
    @MapRowsUpdated BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT = NULL;
    DECLARE @Rows BIGINT = 0;
    DECLARE @CandidateKeys BIGINT = 0;
    DECLARE @CandidateRows BIGINT = 0;
    DECLARE @InsertedRows INT = 0;
    DECLARE @UpdatedMapRows BIGINT = 0;
    DECLARE @LockResult INT;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @MaxDopHint NVARCHAR(40) = N'';

    DECLARE @TipoSedeOperativa INT;
    DECLARE @TipoSedeLegaleOp INT;
    DECLARE @TipoSedeNonClass INT;
    DECLARE @TipoSedeSecondaria INT;
    DECLARE @TipoSedeAmministrativa INT;
    DECLARE @TipoSedeSitoEstero INT;
    DECLARE @TipoOrgSedeSecondaria INT;
    DECLARE @TipoOrgSedePrincipale INT;

    IF @BuildHistoryLogId IS NULL
        THROW 51000, 'BuildHistoryLogId obbligatorio.', 1;

    IF @MaxDop IS NULL SET @MaxDop = 2;
    IF @MaxDop > 8
        THROW 51001, 'MaxDop non valido. Usare 0 oppure un valore tra 1 e 8.', 1;

    IF @MaxDop > 0
        SET @MaxDopHint = N' OPTION (MAXDOP ' + CONVERT(NVARCHAR(3), @MaxDop) + N')';

    EXEC @LockResult = sys.sp_getapplock
        @Resource = N'ImportSIAC.BuildHistory.04C_PP',
        @LockMode = N'Exclusive',
        @LockOwner = N'Session',
        @LockTimeout = 0;

    IF @LockResult < 0
        THROW 51002, 'Step 04C_PP gia in esecuzione in un altra sessione.', 1;

    BEGIN TRY
        IF OBJECT_ID(N'ImportSIAC.wrk_All_Src', N'U') IS NULL
            THROW 51003, 'ImportSIAC.wrk_All_Src non esiste.', 1;

        IF OBJECT_ID(N'ImportSIAC.wrk_ClienteMap', N'U') IS NULL
            THROW 51004, 'ImportSIAC.wrk_ClienteMap non esiste. Eseguire prima lo step 04B.', 1;

        SELECT @TipoSedeOperativa = TipoSedeId
        FROM Tipologica.TipoSede
        WHERE Codice = 'SEDE_OPERATIVA' AND DataCancellazione IS NULL;

        SELECT @TipoSedeLegaleOp = TipoSedeId
        FROM Tipologica.TipoSede
        WHERE Codice = 'LEGALE_OPERATIVA' AND DataCancellazione IS NULL;

        SELECT @TipoSedeNonClass = TipoSedeId
        FROM Tipologica.TipoSede
        WHERE Codice = 'NON_CLASSIFICATO' AND DataCancellazione IS NULL;

        SELECT @TipoSedeSecondaria = TipoSedeId
        FROM Tipologica.TipoSede
        WHERE Codice = 'SEDE_SECONDARIA' AND DataCancellazione IS NULL;

        SELECT @TipoSedeAmministrativa = TipoSedeId
        FROM Tipologica.TipoSede
        WHERE Codice = 'SEDE_AMMINISTRATIVA' AND DataCancellazione IS NULL;

        SELECT @TipoSedeSitoEstero = TipoSedeId
        FROM Tipologica.TipoSede
        WHERE Codice = 'SITO_PRINC_ESTERO' AND DataCancellazione IS NULL;

        SELECT @TipoOrgSedeSecondaria = TipoOrganizzazioneSedeId
        FROM Tipologica.TipoOrganizzazioneSede

        WHERE Codice = 'SECONDARIA' AND DataCancellazione IS NULL;

        SELECT @TipoOrgSedePrincipale = TipoOrganizzazioneSedeId
        FROM Tipologica.TipoOrganizzazioneSede
        WHERE Codice = 'PRINCIPALE' AND DataCancellazione IS NULL;

        IF @TipoSedeOperativa IS NULL THROW 51005, 'Lookup TipoSede SEDE_OPERATIVA mancante.', 1;
        IF @TipoSedeLegaleOp IS NULL THROW 51006, 'Lookup TipoSede LEGALE_OPERATIVA mancante.', 1;
        IF @TipoSedeNonClass IS NULL THROW 51007, 'Lookup TipoSede NON_CLASSIFICATO mancante.', 1;
        IF @TipoSedeSecondaria IS NULL THROW 51008, 'Lookup TipoSede SEDE_SECONDARIA mancante.', 1;
        IF @TipoSedeAmministrativa IS NULL THROW 51009, 'Lookup TipoSede SEDE_AMMINISTRATIVA mancante.', 1;
        IF @TipoSedeSitoEstero IS NULL THROW 51010, 'Lookup TipoSede SITO_PRINC_ESTERO mancante.', 1;
        IF @TipoOrgSedeSecondaria IS NULL THROW 51011, 'Lookup TipoOrganizzazioneSede SECONDARIA mancante.', 1;
        IF @TipoOrgSedePrincipale IS NULL THROW 51012, 'Lookup TipoOrganizzazioneSede PRINCIPALE mancante.', 1;

        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId, StepNo, StepCode, StepName, StartedAt, Status)
        VALUES
            (@BuildHistoryLogId, 4, N'04C_PP', N'Censimento org PP', @StepStart, N'RUNNING');

        SET @StepLogId = SCOPE_IDENTITY();

        DROP TABLE IF EXISTS ImportSIAC.wrk_PP_MissingFiscalCode;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PP_OrgDaCensire;

        CREATE TABLE ImportSIAC.wrk_PP_MissingFiscalCode
        (
            fiscal_code NVARCHAR(100) NOT NULL
        );

        INSERT INTO ImportSIAC.wrk_PP_MissingFiscalCode (fiscal_code)
        SELECT DISTINCT cm.fiscal_code
        FROM ImportSIAC.wrk_ClienteMap cm
        WHERE cm.OrganizzazioneClienteId IS NULL
          AND cm.fiscal_code IS NOT NULL
          AND LEN(cm.fiscal_code) = 11
          AND cm.fiscal_code NOT LIKE '%[^0-9]%'
          AND (cm.vat_number IS NULL OR LEN(cm.vat_number) <= 11 OR cm.vat_number = cm.fiscal_code);

        -- MIG_115: conteggi PP indipendenti dal connection rowcount
        SELECT @CandidateKeys = COUNT_BIG(*)
        FROM ImportSIAC.wrk_PP_MissingFiscalCode;

        CREATE UNIQUE CLUSTERED INDEX CX_wrk_PP_MissingFiscalCode
            ON ImportSIAC.wrk_PP_MissingFiscalCode (fiscal_code);

        CREATE TABLE ImportSIAC.wrk_PP_OrgDaCensire
        (
            fiscal_code NVARCHAR(100) NOT NULL,
            vat_number NVARCHAR(100) NULL,
            raw_company_name NVARCHAR(500) NULL,
            raw_site_address NVARCHAR(250) NULL,
            raw_site_city NVARCHAR(150) NULL,
            raw_site_zip NVARCHAR(50) NULL,
            raw_site_province NVARCHAR(50) NULL,
            raw_site_country NVARCHAR(100) NULL,
            raw_site_type NVARCHAR(20) NULL,
            NuovoOrganizzazioneId INT NULL
        );

        IF @CandidateKeys > 0
        BEGIN
            SET @sql = N'
WITH RankedPP AS
(
    SELECT
        src.fiscal_code,
        src.vat_number,
        LEFT(src.raw_company_name, 500) AS raw_company_name,
        LEFT(src.raw_site_address, 250) AS raw_site_address,
        LEFT(src.raw_site_city, 150) AS raw_site_city,
        LEFT(src.raw_site_zip, 50) AS raw_site_zip,
        LEFT(src.raw_site_province, 50) AS raw_site_province,
        LEFT(src.raw_site_country, 100) AS raw_site_country,
        LEFT(src.raw_site_type, 20) AS raw_site_type,
        ROW_NUMBER() OVER
        (
            PARTITION BY src.fiscal_code
            ORDER BY
                CASE src.raw_site_type WHEN ''01'' THEN 0 ELSE 1 END,
                CASE WHEN src.raw_site_address IS NOT NULL AND src.raw_site_city IS NOT NULL THEN 0 ELSE 1 END,
                src.SnapshotYear DESC,
                src.SnapshotMonth DESC,
                src.RawId DESC
        ) AS Rn
    FROM ImportSIAC.wrk_PP_MissingFiscalCode m
    JOIN ImportSIAC.wrk_All_Src src
        ON src.Dominio = ''PP''
       AND src.fiscal_code = m.fiscal_code
    WHERE src.raw_company_name IS NOT NULL
      AND LTRIM(RTRIM(src.raw_company_name)) <> ''''

      AND (src.vat_number IS NULL OR LEN(src.vat_number) <= 11 OR src.vat_number = src.fiscal_code)
)
INSERT INTO ImportSIAC.wrk_PP_OrgDaCensire
(
    fiscal_code,
    vat_number,
    raw_company_name,
    raw_site_address,
    raw_site_city,
    raw_site_zip,
    raw_site_province,
    raw_site_country,
    raw_site_type,
    NuovoOrganizzazioneId
)
SELECT
    fiscal_code,
    vat_number,
    raw_company_name,
    raw_site_address,
    raw_site_city,
    raw_site_zip,
    raw_site_province,
    raw_site_country,
    raw_site_type,
    CAST(NULL AS INT)
FROM RankedPP
WHERE Rn = 1' + @MaxDopHint + N';

SELECT @CandidateRowsOut = COUNT_BIG(*)
FROM ImportSIAC.wrk_PP_OrgDaCensire;';

            EXEC sys.sp_executesql
                @sql,
                N'@CandidateRowsOut BIGINT OUTPUT',
                @CandidateRowsOut = @CandidateRows OUTPUT;
        END;

        CREATE UNIQUE CLUSTERED INDEX CX_wrk_PP_OrgDaCensire
            ON ImportSIAC.wrk_PP_OrgDaCensire (fiscal_code);

        UPDATE n
            SET n.NuovoOrganizzazioneId = ex.OrganizzazioneId
        FROM ImportSIAC.wrk_PP_OrgDaCensire n
        OUTER APPLY
        (
            SELECT TOP (1) o.OrganizzazioneId
            FROM Organizzazioni.Organizzazione o
            WHERE o.DataCancellazione IS NULL
              AND
              (
                   o.CodiceFiscale = n.fiscal_code
                OR o.PartitaIVA = n.fiscal_code
                OR (n.vat_number IS NOT NULL AND o.PartitaIVA = n.vat_number)
              )
            ORDER BY
                CASE WHEN o.CodiceFiscale = n.fiscal_code THEN 0 ELSE 1 END,
                o.OrganizzazioneId
        ) ex
        WHERE n.NuovoOrganizzazioneId IS NULL
          AND ex.OrganizzazioneId IS NOT NULL;

        CREATE TABLE #InsertedOrgPP
        (
            OrganizzazioneId INT NOT NULL,
            CodiceFiscale NVARCHAR(16) NOT NULL,
            PRIMARY KEY CLUSTERED (CodiceFiscale)
        );

        INSERT INTO Organizzazioni.Organizzazione
            (RagioneSociale, Denominazione, CodiceFiscale, PartitaIVA)
        OUTPUT INSERTED.OrganizzazioneId, INSERTED.CodiceFiscale
            INTO #InsertedOrgPP (OrganizzazioneId, CodiceFiscale)
        SELECT
            n.raw_company_name,
            n.raw_company_name,
            CASE WHEN LEN(n.fiscal_code) <= 16 THEN n.fiscal_code ELSE NULL END,
            CASE
                WHEN LEN(NULLIF(n.vat_number, n.fiscal_code)) <= 11
                    THEN NULLIF(n.vat_number, n.fiscal_code)
                ELSE NULL
            END
        FROM ImportSIAC.wrk_PP_OrgDaCensire n
        WHERE n.NuovoOrganizzazioneId IS NULL
          AND NOT EXISTS
          (
              SELECT 1
              FROM Organizzazioni.Organizzazione o
              WHERE o.DataCancellazione IS NULL
                AND
                (
                     o.CodiceFiscale = n.fiscal_code
                  OR o.PartitaIVA = n.fiscal_code
                  OR (n.vat_number IS NOT NULL AND o.PartitaIVA = n.vat_number)
                )
          );

        SELECT @InsertedRows = COUNT(*)
        FROM #InsertedOrgPP;

        UPDATE n
            SET n.NuovoOrganizzazioneId = ins.OrganizzazioneId
        FROM ImportSIAC.wrk_PP_OrgDaCensire n
        JOIN #InsertedOrgPP ins
            ON ins.CodiceFiscale = n.fiscal_code;

        INSERT INTO Organizzazioni.Sede
            (OrganizzazioneId, TipoSedeId, Indirizzo, Localita, CAP, Provincia, Nazione,
             IsSedePrincipale, IsSedeOperativa)
        SELECT
            ins.OrganizzazioneId,
            CASE n.raw_site_type
                WHEN '01' THEN @TipoSedeLegaleOp
                WHEN '02' THEN @TipoSedeOperativa
                WHEN '03' THEN @TipoSedeSecondaria
                WHEN '04' THEN @TipoSedeAmministrativa
                WHEN '05' THEN @TipoSedeSitoEstero
                WHEN '06' THEN @TipoSedeSitoEstero
                ELSE @TipoSedeNonClass
            END,
            n.raw_site_address,
            n.raw_site_city,
            LEFT(n.raw_site_zip, 10),

            n.raw_site_province,
            CASE
                WHEN n.raw_site_country IN ('IT', '') OR n.raw_site_country IS NULL THEN 'Italia'
                ELSE n.raw_site_country
            END,
            CASE WHEN n.raw_site_type = '01' THEN 1 ELSE 0 END,
            1
        FROM ImportSIAC.wrk_PP_OrgDaCensire n
        JOIN #InsertedOrgPP ins
            ON ins.CodiceFiscale = n.fiscal_code
        WHERE n.NuovoOrganizzazioneId IS NOT NULL
          AND n.raw_site_address IS NOT NULL
          AND LTRIM(RTRIM(n.raw_site_address)) <> '';
        -- MIG_120: OrganizzazioneSede dismessa; la sede canonica e' gia inserita in Organizzazioni.Sede.

        UPDATE cm
            SET cm.OrganizzazioneClienteId = n.NuovoOrganizzazioneId
        FROM ImportSIAC.wrk_ClienteMap cm
        JOIN ImportSIAC.wrk_PP_OrgDaCensire n
            ON cm.fiscal_code = n.fiscal_code
        WHERE cm.OrganizzazioneClienteId IS NULL
          AND n.NuovoOrganizzazioneId IS NOT NULL;

        SELECT @UpdatedMapRows = COUNT_BIG(*)
        FROM ImportSIAC.wrk_ClienteMap AS cm
        JOIN ImportSIAC.wrk_PP_OrgDaCensire AS n
          ON n.fiscal_code = cm.fiscal_code
        WHERE n.NuovoOrganizzazioneId IS NOT NULL
          AND cm.OrganizzazioneClienteId = n.NuovoOrganizzazioneId;

        DROP TABLE ImportSIAC.wrk_PP_MissingFiscalCode;

        SET @Rows = @InsertedRows;
        SET @RowsAffected = @Rows;
        SET @OrgCensitePP = @InsertedRows;
        SET @MapRowsUpdated = @UpdatedMapRows;

        UPDATE ImportSIAC.BuildHistory_StepLog
            SET FinishedAt = SYSUTCDATETIME(),
                DurationMs = DATEDIFF_BIG(MILLISECOND, StartedAt, SYSUTCDATETIME()),
                Status = N'SUCCESS',
                RowsAffected = @Rows,
                ExtraInfo = CONCAT
                (
                    N'CandidateKeys=', @CandidateKeys,
                    N'; CandidateRows=', @CandidateRows,
                    N'; MapRowsUpdated=', @UpdatedMapRows
                )
        WHERE BuildHistoryStepLogId = @StepLogId;

        EXEC sys.sp_releaseapplock
            @Resource = N'ImportSIAC.BuildHistory.04C_PP',
            @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) =
            LEFT(CONCAT(N'ERR ', ERROR_NUMBER(), N': ', ERROR_MESSAGE()), 4000);

        IF OBJECT_ID(N'ImportSIAC.wrk_PP_MissingFiscalCode', N'U') IS NOT NULL
            DROP TABLE ImportSIAC.wrk_PP_MissingFiscalCode;

        IF @StepLogId IS NOT NULL
        BEGIN
            UPDATE ImportSIAC.BuildHistory_StepLog
                SET FinishedAt = SYSUTCDATETIME(),
                    DurationMs = DATEDIFF_BIG(MILLISECOND, StartedAt, SYSUTCDATETIME()),
                    Status = N'FAILED',
                    ErrorMessage = @ErrMsg
            WHERE BuildHistoryStepLogId = @StepLogId;
        END;

        EXEC sys.sp_releaseapplock
            @Resource = N'ImportSIAC.BuildHistory.04C_PP',
            @LockOwner = N'Session';

        THROW;
    END CATCH;
END;

GO

