
-- ================================================================================
-- ImportSIAC.usp_BuildHistory_All (99915 caratteri)
-- ================================================================================
-- ImportSIAC.usp_BuildHistory_All
-- Port T-SQL completo della pipeline BuildHistory su Azure SQL (Accredia_SIDAC).
-- Sorgente: ImportSIAC.wrk_All_Src (popolata da usp_PopulateWrkAllSrc).
-- Round-trip staging: solo wake-up (Ext_PP_Flat); censimento locale da MIG_132.
-- Output: Certificazione.Certificazione/SG/PRD/FPC/Sede (temporal SCD2).
--
-- EXEC ImportSIAC.usp_BuildHistory_All;
-- EXEC ImportSIAC.usp_BuildHistory_All @MaxDop = 0;
-- =============================================================================
CREATE PROCEDURE [ImportSIAC].[usp_BuildHistory_All]
    @MaxDop TINYINT = 4
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LogId INT, @StepStart DATETIME2, @Rows BIGINT;
    DECLARE @tStart DATETIME2 = SYSUTCDATETIME();
    DECLARE @ErrMsg NVARCHAR(4000), @RecoveryErr NVARCHAR(4000) = N'';

    DECLARE @RigheLette_PP INT=0, @RigheLette_PRD INT=0, @RigheLette_FPC INT=0;
    DECLARE @RigheDedup_PP INT=0, @RigheDedup_PRD INT=0, @RigheDedup_FPC INT=0;
    DECLARE @ScartateODC_PP INT=0, @ScartateODC_PRD INT=0, @ScartateODC_FPC INT=0;
    DECLARE @NormeFallback_PP INT=0, @NormeFallback_PRD INT=0, @NormeFallback_FPC INT=0;
    DECLARE @PersoneInserite INT=0;
    DECLARE @Cert_Correnti INT=0, @Cert_Storici INT=0;
    DECLARE @SG_Correnti INT=0, @SG_Storici INT=0;
    DECLARE @PRD_Correnti INT=0, @PRD_Storici INT=0;
    DECLARE @FPC_Correnti INT=0, @FPC_Storici INT=0;
    DECLARE @OrgCensite INT=0, @OrgCensitePRD INT=0, @OrgCensitePP INT=0, @OrgCensiteSG INT=0, @OrgCensiteEstero INT=0;

    DECLARE @HT_Cert NVARCHAR(300), @HT_SG NVARCHAR(300), @HT_PRD NVARCHAR(300);
    DECLARE @HT_FPC NVARCHAR(300), @HT_Sede NVARCHAR(300);
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @fk_name NVARCHAR(200), @fk_parent NVARCHAR(300);

    -- =================================================================
    -- LOOKUPS
    -- =================================================================
    DECLARE @StatoAttivo INT=(SELECT StatoCertificazioneId FROM Certificazione.StatoCertificazione WHERE Codice='ATTIVO' AND DataCancellazione IS NULL);
    DECLARE @StatoRevocato INT=(SELECT StatoCertificazioneId FROM Certificazione.StatoCertificazione WHERE Codice='REVOCATO' AND DataCancellazione IS NULL);
    DECLARE @TipoAltro INT=(SELECT TipoCertificazioneId FROM Certificazione.TipoCertificazione WHERE Codice='ALTRO' AND DataCancellazione IS NULL);
    DECLARE @NormaFallback INT=(SELECT MIN(NormaAccreditamentoId) FROM Standard.NormaAccreditamento WHERE DataCancellazione IS NULL AND Attivo=1);
    DECLARE @TipoQualificaFallback INT=(SELECT TipoQualificaId FROM Tipologica.TipoQualifica WHERE Codice='ALTRO' AND DataCancellazione IS NULL);
    DECLARE @TipoSedeOperativa INT=(SELECT TipoSedeId FROM Tipologica.TipoSede WHERE Codice='SEDE_OPERATIVA' AND DataCancellazione IS NULL);
    DECLARE @TipoSedeLegale INT=(SELECT TipoSedeId FROM Tipologica.TipoSede WHERE Codice='SEDE_LEGALE' AND DataCancellazione IS NULL);
    DECLARE @TipoSedeLegaleOp INT=(SELECT TipoSedeId FROM Tipologica.TipoSede WHERE Codice='LEGALE_OPERATIVA' AND DataCancellazione IS NULL);
    DECLARE @TipoSedeNonClass INT=(SELECT TipoSedeId FROM Tipologica.TipoSede WHERE Codice='NON_CLASSIFICATO' AND DataCancellazione IS NULL);
    DECLARE @TipoOrgSedeSecondaria INT=(SELECT TipoOrganizzazioneSedeId FROM Tipologica.TipoOrganizzazioneSede WHERE Codice='SECONDARIA' AND DataCancellazione IS NULL);
    DECLARE @TipoOrgSedePrincipale INT=(SELECT TipoOrganizzazioneSedeId FROM Tipologica.TipoOrganizzazioneSede WHERE Codice='PRINCIPALE' AND DataCancellazione IS NULL);
    DECLARE @TipoSedeSecondaria INT=(SELECT TipoSedeId FROM Tipologica.TipoSede WHERE Codice='SEDE_SECONDARIA' AND DataCancellazione IS NULL);
    DECLARE @TipoSedeAmministrativa INT=(SELECT TipoSedeId FROM Tipologica.TipoSede WHERE Codice='SEDE_AMMINISTRATIVA' AND DataCancellazione IS NULL);


    DECLARE @TipoSedeSitoEstero INT=(SELECT TipoSedeId FROM Tipologica.TipoSede WHERE Codice='SITO_PRINC_ESTERO' AND DataCancellazione IS NULL);

    IF @StatoAttivo IS NULL THROW 50001,'Lookup: StatoCertificazione ATTIVO.',1;
    IF @StatoRevocato IS NULL THROW 50002,'Lookup: StatoCertificazione REVOCATO.',1;
    IF @TipoAltro IS NULL THROW 50003,'Lookup: TipoCertificazione ALTRO.',1;
    IF @NormaFallback IS NULL THROW 50004,'Lookup: NormaAccreditamento.',1;
    IF @TipoQualificaFallback IS NULL THROW 50005,'Lookup: TipoQualifica ALTRO.',1;
    IF @TipoSedeOperativa IS NULL THROW 50006,'Lookup: TipoSede SEDE_OPERATIVA.',1;
    IF @TipoSedeLegale IS NULL THROW 50007,'Lookup: TipoSede SEDE_LEGALE.',1;
    IF @TipoSedeLegaleOp IS NULL THROW 50008,'Lookup: TipoSede LEGALE_OPERATIVA.',1;
    IF @TipoSedeNonClass IS NULL THROW 50009,'Lookup: TipoSede NON_CLASSIFICATO.',1;
    IF @TipoOrgSedeSecondaria IS NULL THROW 50010,'Lookup: TipoOrganizzazioneSede SECONDARIA.',1;
    IF @TipoOrgSedePrincipale IS NULL THROW 50011,'Lookup: TipoOrganizzazioneSede PRINCIPALE.',1;
    IF @TipoSedeSecondaria IS NULL THROW 50012,'Lookup: TipoSede SEDE_SECONDARIA.',1;
    IF @TipoSedeAmministrativa IS NULL THROW 50013,'Lookup: TipoSede SEDE_AMMINISTRATIVA.',1;
    IF @TipoSedeSitoEstero IS NULL THROW 50014,'Lookup: TipoSede SITO_PRINC_ESTERO.',1;

    IF NOT EXISTS (SELECT 1 FROM ImportSIAC.wrk_All_Src) THROW 50100,'wrk_All_Src vuota.',1;

    SELECT @RigheLette_PP=SUM(CASE WHEN Dominio='PP' THEN 1 ELSE 0 END),
           @RigheLette_PRD=SUM(CASE WHEN Dominio='PRD' THEN 1 ELSE 0 END),
           @RigheLette_FPC=SUM(CASE WHEN Dominio='FPC' THEN 1 ELSE 0 END)
    FROM ImportSIAC.wrk_All_Src;

    -- Discovery history tables
    SELECT @HT_Cert=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.Certificazione');
    SELECT @HT_SG=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.CertificazioneSG');
    SELECT @HT_PRD=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.CertificazionePRD');
    SELECT @HT_FPC=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.CertificazioneFPC');
    SELECT @HT_Sede=QUOTENAME(hs.name)+'.'+QUOTENAME(h.name) FROM sys.tables t JOIN sys.tables h ON h.object_id=t.history_table_id JOIN sys.schemas hs ON hs.schema_id=h.schema_id WHERE t.object_id=OBJECT_ID('Certificazione.CertificazioneSede');
    -- Fallback history tables after interrupted temporal rebuild.
    -- When SYSTEM_VERSIONING is OFF, sys.tables.history_table_id can be NULL even if the history table exists.
    IF @HT_Cert IS NULL AND OBJECT_ID(N'Certificazione.CertificazioneStorico', N'U') IS NOT NULL
        SET @HT_Cert = N'[Certificazione].[CertificazioneStorico]';
    IF @HT_SG IS NULL AND OBJECT_ID(N'Certificazione.CertificazioneSGStorico', N'U') IS NOT NULL
        SET @HT_SG = N'[Certificazione].[CertificazioneSGStorico]';
    IF @HT_PRD IS NULL AND OBJECT_ID(N'Certificazione.CertificazionePRDStorico', N'U') IS NOT NULL
        SET @HT_PRD = N'[Certificazione].[CertificazionePRDStorico]';
    IF @HT_FPC IS NULL AND OBJECT_ID(N'Certificazione.CertificazioneFPCStorico', N'U') IS NOT NULL
        SET @HT_FPC = N'[Certificazione].[CertificazioneFPCStorico]';
    IF @HT_Sede IS NULL AND OBJECT_ID(N'Certificazione.CertificazioneSedeStorico', N'U') IS NOT NULL
        SET @HT_Sede = N'[Certificazione].[CertificazioneSedeStorico]';


    IF @HT_Cert IS NULL OR @HT_SG IS NULL OR @HT_PRD IS NULL OR @HT_FPC IS NULL OR @HT_Sede IS NULL
        THROW 50101,'History table non determinabili.',1;

    PRINT CONCAT('HT: ',@HT_Cert,' ',@HT_SG,' ',@HT_PRD,' ',@HT_FPC,' ',@HT_Sede);
    PRINT CONCAT('wrk: PP=',@RigheLette_PP,' PRD=',@RigheLette_PRD,' FPC=',@RigheLette_FPC);

    INSERT INTO ImportSIAC.BuildHistory_Log (Status) VALUES (N'RUNNING');
    SET @LogId = SCOPE_IDENTITY();
    PRINT CONCAT('BuildHistoryLogId=',@LogId);

    BEGIN TRY

    DECLARE @RowsWake BIGINT;
    EXEC ImportSIAC.usp_BH_00_WakeStaging @BuildHistoryLogId=@LogId, @RowsAffected=@RowsWake OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_01_Cleanup @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_02_NormaMap @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_04A_NormalizeIT @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_04B_ClienteMap @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT;

    EXEC ImportSIAC.usp_BH_04C_CensusOrgPRD

         @BuildHistoryLogId = @LogId,
         @MaxDop = @MaxDop,
         @RowsAffected = @Rows OUTPUT,
         @OrgCensitePRD = @OrgCensitePRD OUTPUT;

    SET @OrgCensite = @OrgCensite + @OrgCensitePRD;
    PRINT CONCAT('STEP 04C_PRD: ', @Rows);

    EXEC ImportSIAC.usp_BH_04C_CensusOrgPP
         @BuildHistoryLogId = @LogId,
         @MaxDop = @MaxDop,
         @RowsAffected = @Rows OUTPUT,
         @OrgCensitePP = @OrgCensitePP OUTPUT;

    SET @OrgCensite = @OrgCensite + @OrgCensitePP;
    PRINT CONCAT('STEP 04C_PP: ', @Rows);

    SET @StepStart = SYSUTCDATETIME();
    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@LogId,4,N'04C_SG',N'Censimento org SG (locale su wrk_All_Src, MIG_132)',@StepStart,N'RUNNING');

    -- Identifica PIVA residue non risolte
    DROP TABLE IF EXISTS ImportSIAC.wrk_PivaNullResidua;
    SELECT DISTINCT
        CAST
        (
            CASE
                WHEN LEN(cm.fiscal_code) = 11 AND cm.fiscal_code NOT LIKE '%[^0-9]%' THEN cm.fiscal_code
                WHEN LEN(cm.vat_number) = 11 AND cm.vat_number NOT LIKE '%[^0-9]%' THEN cm.vat_number
            END
            AS NVARCHAR(11)
        ) AS piva_normalizzata,
        cm.fiscal_code, cm.vat_number
    INTO ImportSIAC.wrk_PivaNullResidua
    FROM ImportSIAC.wrk_ClienteMap cm
    WHERE cm.OrganizzazioneClienteId IS NULL
      AND ((LEN(ISNULL(cm.fiscal_code,''))=11 AND cm.fiscal_code NOT LIKE '%[^0-9]%')
        OR (LEN(ISNULL(cm.vat_number,''))=11 AND cm.vat_number NOT LIKE '%[^0-9]%'));
    CREATE CLUSTERED INDEX CX_PivaNullResidua ON ImportSIAC.wrk_PivaNullResidua(piva_normalizzata);

    -- Lookup locale su wrk_All_Src via vw_Census_PP_Local (MIG_132)
    CREATE TABLE ImportSIAC.wrk_SG_OrgDaCensire (
        piva_normalizzata NVARCHAR(11) NULL, fiscal_code NVARCHAR(1000) NULL /* MIG_132b */,
        vat_number NVARCHAR(1000) NULL, raw_company_name NVARCHAR(500) NULL,
        raw_site_address NVARCHAR(1000) NULL, raw_site_city NVARCHAR(400) NULL,
        raw_site_zip NVARCHAR(100) NULL, raw_site_country NVARCHAR(100) NULL,
        NuovoOrganizzazioneId INT NULL);

    ;WITH RawByCF AS (
        SELECT pnr.piva_normalizzata,
            r.fiscal_code, r.vat_number, r.json_companyname AS raw_company_name,
            r.json_address AS raw_site_address, r.json_city AS raw_site_city,
            r.json_zipcode AS raw_site_zip, r.json_country AS raw_site_country,
            r.SnapshotYear, r.SnapshotMonth
        FROM ImportSIAC.vw_Census_PP_Local r /* MIG_132: locale, ex Ext_PP_Flat */
        JOIN ImportSIAC.wrk_PivaNullResidua pnr ON r.fiscal_code = pnr.piva_normalizzata
        WHERE LEN(r.fiscal_code)=11 AND r.fiscal_code NOT LIKE '%[^0-9]%'
        UNION ALL
        SELECT pnr.piva_normalizzata,
            r.fiscal_code, r.vat_number, r.json_companyname,
            r.json_address, r.json_city, r.json_zipcode, r.json_country,
            r.SnapshotYear, r.SnapshotMonth
        FROM ImportSIAC.vw_Census_PP_Local r /* MIG_132: locale, ex Ext_PP_Flat */
        JOIN ImportSIAC.wrk_PivaNullResidua pnr ON r.vat_number = pnr.piva_normalizzata
        WHERE LEN(r.vat_number)=11 AND r.vat_number NOT LIKE '%[^0-9]%'
    ), Ranked AS (
        SELECT *, ROW_NUMBER() OVER (
            PARTITION BY piva_normalizzata
            ORDER BY CASE WHEN NULLIF(LTRIM(RTRIM(raw_company_name)),'') IS NOT NULL THEN 0 ELSE 1 END,
                     SnapshotYear DESC, SnapshotMonth DESC) AS Rn
        FROM RawByCF
    )
    INSERT INTO ImportSIAC.wrk_SG_OrgDaCensire (piva_normalizzata,fiscal_code,vat_number,raw_company_name,raw_site_address,raw_site_city,raw_site_zip,raw_site_country)
    SELECT piva_normalizzata,fiscal_code,vat_number,raw_company_name,raw_site_address,raw_site_city,raw_site_zip,raw_site_country
    FROM Ranked WHERE Rn=1 AND raw_company_name IS NOT NULL AND LTRIM(RTRIM(raw_company_name)) <> ''
    OPTION (MAXDOP 8);

    DROP TABLE ImportSIAC.wrk_PivaNullResidua;
    
    DECLARE @InsertedOrgSG TABLE (OrganizzazioneId INT NOT NULL, PartitaIVA NVARCHAR(11) NULL);
    


    INSERT INTO Organizzazioni.Organizzazione
        (RagioneSociale, Denominazione, CodiceFiscale, PartitaIVA)
    OUTPUT INSERTED.OrganizzazioneId, INSERTED.PartitaIVA INTO @InsertedOrgSG
    SELECT
        LEFT(n.raw_company_name, 500),
        LEFT(n.raw_company_name, 500),
        CASE WHEN LEN(n.piva_normalizzata) = 11 THEN n.piva_normalizzata ELSE NULL END,
        CASE WHEN LEN(n.piva_normalizzata) = 11 THEN n.piva_normalizzata ELSE NULL END
    FROM ImportSIAC.wrk_SG_OrgDaCensire n
    WHERE NOT EXISTS (
        SELECT 1 FROM Organizzazioni.Organizzazione oe
        WHERE oe.DataCancellazione IS NULL
          AND (oe.CodiceFiscale = n.piva_normalizzata OR oe.PartitaIVA = n.piva_normalizzata)
    );
    
    -- MIG_116: conteggi SG/ESTERO indipendenti dal connection rowcount
    SELECT @OrgCensiteSG = COUNT(*)
    FROM @InsertedOrgSG;
    
    UPDATE n SET n.NuovoOrganizzazioneId = ins.OrganizzazioneId
    FROM ImportSIAC.wrk_SG_OrgDaCensire n
    JOIN @InsertedOrgSG ins ON ins.PartitaIVA = n.piva_normalizzata;
    
    INSERT INTO Organizzazioni.Sede
        (OrganizzazioneId, TipoSedeId, Indirizzo, Localita, CAP, Nazione,
         IsSedePrincipale, IsSedeOperativa)
    SELECT n.NuovoOrganizzazioneId, @TipoSedeNonClass,
        LEFT(n.raw_site_address, 250), LEFT(n.raw_site_city, 150),
        LEFT(n.raw_site_zip, 10),
        LEFT(CASE WHEN n.raw_site_country IN ('IT','') OR n.raw_site_country IS NULL
                  THEN 'Italia' ELSE n.raw_site_country END, 100),
        0, 1
    FROM ImportSIAC.wrk_SG_OrgDaCensire n
    WHERE n.NuovoOrganizzazioneId IS NOT NULL
      AND n.raw_site_address IS NOT NULL AND LTRIM(RTRIM(n.raw_site_address)) <> '';
        -- MIG_120: OrganizzazioneSede dismessa; la sede canonica e' gia inserita in Organizzazioni.Sede.
    
    UPDATE cm SET cm.OrganizzazioneClienteId = n.NuovoOrganizzazioneId
    FROM ImportSIAC.wrk_ClienteMap cm
    JOIN ImportSIAC.wrk_SG_OrgDaCensire n
        ON ISNULL(cm.fiscal_code,'') = ISNULL(n.piva_normalizzata,'')
        OR ISNULL(cm.vat_number,'')  = ISNULL(n.piva_normalizzata,'')
    WHERE cm.OrganizzazioneClienteId IS NULL AND n.NuovoOrganizzazioneId IS NOT NULL;
    
    SET @Rows = @OrgCensiteSG; SET @OrgCensite = @OrgCensite + @OrgCensiteSG;

    UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
        DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
        Status=N'SUCCESS', RowsAffected=@Rows
    WHERE BuildHistoryLogId=@LogId AND StepCode=N'04C_SG' AND Status=N'RUNNING';
    PRINT CONCAT('STEP 04C_SG: ', @Rows);

    SET @StepStart = SYSUTCDATETIME();
    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@LogId,4,N'04C_ESTERO',N'Censimento org estere',@StepStart,N'RUNNING');

    ;WITH EsteriPending AS (
        SELECT cm.fiscal_code AS map_fc, cm.vat_number AS map_vn,
               cm.parsed_paese_iso2, cm.parsed_valore_estero,
               CASE cm.parsed_paese_iso2 WHEN 'EL' THEN 'GR' ELSE cm.parsed_paese_iso2 END AS paese_iso2_norm
        FROM ImportSIAC.wrk_ClienteMap cm
        WHERE cm.OrganizzazioneClienteId IS NULL
          AND cm.parsed_paese_iso2 IS NOT NULL
          AND cm.parsed_valore_estero IS NOT NULL
          AND LEN(cm.parsed_valore_estero) <= 50
    ),
    BestRow AS (
        SELECT
            ep.map_fc, ep.map_vn, ep.parsed_paese_iso2, ep.parsed_valore_estero, ep.paese_iso2_norm,
            src.raw_company_name, src.raw_site_address, src.raw_site_city,
            src.raw_site_zip, src.raw_site_country,
            ROW_NUMBER() OVER (
                PARTITION BY ep.map_fc, ep.map_vn
                ORDER BY
                    CASE WHEN NULLIF(LTRIM(RTRIM(src.raw_company_name)), '') IS NOT NULL THEN 0 ELSE 1 END,


                    CASE WHEN src.raw_site_address IS NOT NULL AND src.raw_site_city IS NOT NULL THEN 0 ELSE 1 END,
                    src.SnapshotYear DESC, src.SnapshotMonth DESC
            ) AS Rn
        FROM EsteriPending ep
        JOIN ImportSIAC.wrk_All_Src src
            ON src.Dominio IN ('PP','PRD')
           AND ISNULL(NULLIF(LTRIM(RTRIM(src.fiscal_code)),''), '') = ISNULL(ep.map_fc, '')
           AND ISNULL(NULLIF(LTRIM(RTRIM(src.vat_number)),''),  '') = ISNULL(ep.map_vn, '')
    )
    SELECT
        map_fc, map_vn, parsed_paese_iso2, parsed_valore_estero, paese_iso2_norm,
        raw_company_name, raw_site_address, raw_site_city, raw_site_zip, raw_site_country,
        NEWID() AS TempGuid,
        CAST(NULL AS INT) AS NuovoOrganizzazioneId
    INTO ImportSIAC.wrk_ESTERO_OrgDaCensire
    FROM BestRow
    WHERE Rn = 1
      AND raw_company_name IS NOT NULL AND LTRIM(RTRIM(raw_company_name)) <> ''
    OPTION (MAXDOP 8);
    
    DECLARE @InsertedOrgEstero TABLE (OrganizzazioneId INT NOT NULL, TempGuid UNIQUEIDENTIFIER NOT NULL);
    
    INSERT INTO Organizzazioni.Organizzazione
        (RagioneSociale, Denominazione, CodiceFiscale, PartitaIVA, UniqueRowId)
    OUTPUT INSERTED.OrganizzazioneId, INSERTED.UniqueRowId
        INTO @InsertedOrgEstero (OrganizzazioneId, TempGuid)
    SELECT
        LEFT(n.raw_company_name, 500),
        LEFT(n.raw_company_name, 500),
        NULL,
        NULL,
        n.TempGuid
    FROM ImportSIAC.wrk_ESTERO_OrgDaCensire n;
    
    SELECT @OrgCensiteEstero = COUNT(*)
    FROM @InsertedOrgEstero;
    
    UPDATE n SET n.NuovoOrganizzazioneId = ins.OrganizzazioneId
    FROM ImportSIAC.wrk_ESTERO_OrgDaCensire n
    JOIN @InsertedOrgEstero ins ON ins.TempGuid = n.TempGuid;
    
    INSERT INTO Organizzazioni.OrganizzazioneIdentificativoFiscale
        (OrganizzazioneId, PaeseISO2, TipoIdentificativo, Valore, Principale)
    SELECT
        n.NuovoOrganizzazioneId,
        n.paese_iso2_norm,
        CASE WHEN rv.CountryCode IS NOT NULL THEN N'VAT' ELSE N'REG_ESTERO' END,
        LEFT(n.parsed_valore_estero, 50),
        1
    FROM ImportSIAC.wrk_ESTERO_OrgDaCensire n
    LEFT JOIN Utilita.RegolaValidazioneIdentificativoPaese rv
        ON rv.CountryCode = n.paese_iso2_norm
       AND rv.TipoIdentificativo = 'PIVA'
       AND rv.IsAttiva = 1
    WHERE n.NuovoOrganizzazioneId IS NOT NULL;
    
    INSERT INTO Organizzazioni.Sede
        (OrganizzazioneId, TipoSedeId, Indirizzo, Localita, CAP, Nazione,
         IsSedePrincipale, IsSedeOperativa)
    SELECT
        n.NuovoOrganizzazioneId,
        @TipoSedeSitoEstero,
        LEFT(n.raw_site_address, 250),
        LEFT(n.raw_site_city,    150),
        LEFT(n.raw_site_zip,      10),
        LEFT(ISNULL(NULLIF(n.raw_site_country, ''), n.paese_iso2_norm), 100),
        0, 1
    FROM ImportSIAC.wrk_ESTERO_OrgDaCensire n
    WHERE n.NuovoOrganizzazioneId IS NOT NULL
      AND n.raw_site_address IS NOT NULL AND LTRIM(RTRIM(n.raw_site_address)) <> '';
        -- MIG_120: OrganizzazioneSede dismessa; la sede canonica e' gia inserita in Organizzazioni.Sede.
    
    UPDATE cm SET cm.OrganizzazioneClienteId = n.NuovoOrganizzazioneId
    FROM ImportSIAC.wrk_ClienteMap cm
    JOIN ImportSIAC.wrk_ESTERO_OrgDaCensire n
        ON ISNULL(cm.fiscal_code, '') = ISNULL(n.map_fc, '')
       AND ISNULL(cm.vat_number,  '') = ISNULL(n.map_vn,  '')
    WHERE cm.OrganizzazioneClienteId IS NULL
      AND n.NuovoOrganizzazioneId IS NOT NULL;
    
    SET @Rows = @OrgCensiteEstero; SET @OrgCensite = @OrgCensite + @OrgCensiteEstero;

    UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
        DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
        Status=N'SUCCESS', RowsAffected=@Rows


    WHERE BuildHistoryLogId=@LogId AND StepCode=N'04C_ESTERO' AND Status=N'RUNNING';
    PRINT CONCAT('STEP 04C_ESTERO: ', @Rows);

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_04D_Scarti @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT;

    EXEC ImportSIAC.usp_BH_05_Resolve
         @BuildHistoryLogId = @LogId,
         @MaxDop = @MaxDop,
         @BatchByMonth = 1,

         @CreateSourceIndex = 1,
         @RowsAffected = @Rows OUTPUT,
         @RigheDedup_PP = @RigheDedup_PP OUTPUT,
         @RigheDedup_PRD = @RigheDedup_PRD OUTPUT,
         @RigheDedup_FPC = @RigheDedup_FPC OUTPUT,
         @ScartateODC_PP = @ScartateODC_PP OUTPUT,
         @ScartateODC_PRD = @ScartateODC_PRD OUTPUT,
         @ScartateODC_FPC = @ScartateODC_FPC OUTPUT,
         @NormeFallback_PP = @NormeFallback_PP OUTPUT,
         @NormeFallback_PRD = @NormeFallback_PRD OUTPUT,
         @NormeFallback_FPC = @NormeFallback_FPC OUTPUT;

    PRINT CONCAT('STEP 05_RESOLVE: ', @Rows);
    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_05B_SedeMap @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_06_Dedup @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT, @RigheDedup_PP=@RigheDedup_PP OUTPUT, @RigheDedup_PRD=@RigheDedup_PRD OUTPUT, @RigheDedup_FPC=@RigheDedup_FPC OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_07_SCD2_Parent @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_08_SCD2_Children @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_09_Persone @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT, @PersoneInserite=@PersoneInserite OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_10_Rebuild_Cert @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT, @Cert_Correnti=@Cert_Correnti OUTPUT, @Cert_Storici=@Cert_Storici OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_11_SG @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT, @SG_Correnti=@SG_Correnti OUTPUT, @SG_Storici=@SG_Storici OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_12B_Sede @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_12_PRD @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT, @PRD_Correnti=@PRD_Correnti OUTPUT, @PRD_Storici=@PRD_Storici OUTPUT;

    SET @StepStart = SYSUTCDATETIME();
    EXEC ImportSIAC.usp_BH_13_FPC @BuildHistoryLogId=@LogId, @RowsAffected=@Rows OUTPUT, @FPC_Correnti=@FPC_Correnti OUTPUT, @FPC_Storici=@FPC_Storici OUTPUT;

    -- =================================================================
    -- STEP 14 — SUCCESS
    -- =================================================================
    UPDATE ImportSIAC.BuildHistory_Log SET
        FinishedAt=SYSUTCDATETIME(), DurationMs=DATEDIFF_BIG(MILLISECOND,@tStart,SYSUTCDATETIME()),
        Status=N'SUCCESS',
        RigheLette_PP=@RigheLette_PP, RigheLette_PRD=@RigheLette_PRD, RigheLette_FPC=@RigheLette_FPC,
        RigheDedup_PP=@RigheDedup_PP, RigheDedup_PRD=@RigheDedup_PRD, RigheDedup_FPC=@RigheDedup_FPC,
        ScartateODC_PP=@ScartateODC_PP, ScartateODC_PRD=@ScartateODC_PRD, ScartateODC_FPC=@ScartateODC_FPC,


        NormeFallback_PP=@NormeFallback_PP, NormeFallback_PRD=@NormeFallback_PRD, NormeFallback_FPC=@NormeFallback_FPC,
        PersoneInserite=@PersoneInserite,
        Cert_Correnti=@Cert_Correnti, Cert_Storici=@Cert_Storici,
        SG_Correnti=@SG_Correnti, SG_Storici=@SG_Storici,
        PRD_Correnti=@PRD_Correnti, PRD_Storici=@PRD_Storici,
        FPC_Correnti=@FPC_Correnti, FPC_Storici=@FPC_Storici,
        TotaleRigheTarget=@Cert_Correnti+@Cert_Storici+@SG_Correnti+@SG_Storici+@PRD_Correnti+@PRD_Storici+@FPC_Correnti+@FPC_Storici
    WHERE BuildHistoryLogId=@LogId;
    PRINT CONCAT('=== SUCCESS LogId=',@LogId,' durata=',DATEDIFF(SECOND,@tStart,SYSUTCDATETIME()),'s ===');

    END TRY
    BEGIN CATCH
        SET @ErrMsg = LEFT(CONCAT('ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
        PRINT @ErrMsg;

        BEGIN TRY
            IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.Certificazione') AND temporal_type=0) BEGIN
                IF NOT EXISTS (
                    SELECT 1
                    FROM sys.tables t
                    JOIN sys.schemas s ON s.schema_id = t.schema_id
                    JOIN sys.periods p ON p.object_id = t.object_id
                    WHERE s.name = N'Certificazione'
                      AND t.name = N'Certificazione'
                )
                BEGIN
                    BEGIN TRY
                        SET @sql=N'ALTER TABLE Certificazione.Certificazione ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql;
                    END TRY
                    BEGIN CATCH
                        IF ERROR_NUMBER() <> 13597

                        BEGIN

                            THROW;

                        END;
                    END CATCH;
                END;
                SET @sql=N'ALTER TABLE Certificazione.Certificazione SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_Cert+N',DATA_CONSISTENCY_CHECK=OFF))'; EXEC sp_executesql @sql;
            END;
        END TRY BEGIN CATCH SET @RecoveryErr=@RecoveryErr+N' | REC_Certificazione: '+LEFT(ERROR_MESSAGE(),200); END CATCH;

        BEGIN TRY
            IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSede') AND temporal_type=0) BEGIN
                IF NOT EXISTS (
                    SELECT 1
                    FROM sys.tables t
                    JOIN sys.schemas s ON s.schema_id = t.schema_id
                    JOIN sys.periods p ON p.object_id = t.object_id
                    WHERE s.name = N'Certificazione'
                      AND t.name = N'CertificazioneSede'
                )
                BEGIN
                    BEGIN TRY
                        SET @sql=N'ALTER TABLE Certificazione.CertificazioneSede ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql;
                    END TRY
                    BEGIN CATCH
                        IF ERROR_NUMBER() <> 13597

                        BEGIN

                            THROW;

                        END;
                    END CATCH;
                END;
                SET @sql=N'ALTER TABLE Certificazione.CertificazioneSede SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_Sede+N',DATA_CONSISTENCY_CHECK=OFF))'; EXEC sp_executesql @sql;
            END;
        END TRY BEGIN CATCH SET @RecoveryErr=@RecoveryErr+N' | REC_CertificazioneSede: '+LEFT(ERROR_MESSAGE(),200); END CATCH;

        BEGIN TRY
            IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazioneSG') AND temporal_type=0) BEGIN
                IF NOT EXISTS (
                    SELECT 1
                    FROM sys.tables t
                    JOIN sys.schemas s ON s.schema_id = t.schema_id
                    JOIN sys.periods p ON p.object_id = t.object_id
                    WHERE s.name = N'Certificazione'

                      AND t.name = N'CertificazioneSG'
                )
                BEGIN
                    BEGIN TRY
                        SET @sql=N'ALTER TABLE Certificazione.CertificazioneSG ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql;
                    END TRY
                    BEGIN CATCH
                        IF ERROR_NUMBER() <> 13597

                        BEGIN

                            THROW;

                        END;
                    END CATCH;
                END;
                SET @sql=N'ALTER TABLE Certificazione.CertificazioneSG SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_SG+N',DATA_CONSISTENCY_CHECK=OFF))'; EXEC sp_executesql @sql;
            END;
        END TRY BEGIN CATCH SET @RecoveryErr=@RecoveryErr+N' | REC_CertificazioneSG: '+LEFT(ERROR_MESSAGE(),200); END CATCH;

        BEGIN TRY
            IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazionePRD') AND temporal_type=0) BEGIN
                IF NOT EXISTS (
                    SELECT 1
                    FROM sys.tables t
                    JOIN sys.schemas s ON s.schema_id = t.schema_id
                    JOIN sys.periods p ON p.object_id = t.object_id
                    WHERE s.name = N'Certificazione'
                      AND t.name = N'CertificazionePRD'
                )
                BEGIN
                    BEGIN TRY
                        SET @sql=N'ALTER TABLE Certificazione.CertificazionePRD ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql;
                    END TRY
                    BEGIN CATCH
                        IF ERROR_NUMBER() <> 13597

                        BEGIN

                            THROW;

                        END;
                    END CATCH;
                END;
                SET @sql=N'ALTER TABLE Certificazione.CertificazionePRD SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_PRD+N',DATA_CONSISTENCY_CHECK=OFF))'; EXEC sp_executesql @sql;
            END;
        END TRY BEGIN CATCH SET @RecoveryErr=@RecoveryErr+N' | REC_CertificazionePRD: '+LEFT(ERROR_MESSAGE(),200); END CATCH;

        BEGIN TRY
            IF EXISTS (SELECT 1 FROM sys.tables WHERE object_id=OBJECT_ID('Certificazione.CertificazioneFPC') AND temporal_type=0) BEGIN
                IF NOT EXISTS (
                    SELECT 1
                    FROM sys.tables t
                    JOIN sys.schemas s ON s.schema_id = t.schema_id
                    JOIN sys.periods p ON p.object_id = t.object_id
                    WHERE s.name = N'Certificazione'
                      AND t.name = N'CertificazioneFPC'
                )
                BEGIN
                    BEGIN TRY
                        SET @sql=N'ALTER TABLE Certificazione.CertificazioneFPC ADD PERIOD FOR SYSTEM_TIME (DataInizioValidita, DataFineValidita)'; EXEC sp_executesql @sql;
                    END TRY
                    BEGIN CATCH
                        IF ERROR_NUMBER() <> 13597

                        BEGIN

                            THROW;

                        END;
                    END CATCH;
                END;
                SET @sql=N'ALTER TABLE Certificazione.CertificazioneFPC SET (SYSTEM_VERSIONING=ON(HISTORY_TABLE='+@HT_FPC+N',DATA_CONSISTENCY_CHECK=OFF))'; EXEC sp_executesql @sql;
            END;
        END TRY BEGIN CATCH SET @RecoveryErr=@RecoveryErr+N' | REC_CertificazioneFPC: '+LEFT(ERROR_MESSAGE(),200); END CATCH;

        -- FK recovery
        DECLARE fk_rec CURSOR LOCAL FAST_FORWARD FOR
            SELECT fk.name, SCHEMA_NAME(pt.schema_id)+'.'+pt.name FROM sys.foreign_keys fk
            JOIN sys.tables pt ON pt.object_id=fk.parent_object_id
            WHERE fk.referenced_object_id=OBJECT_ID('Certificazione.Certificazione') AND fk.is_disabled=1;
        OPEN fk_rec; FETCH NEXT FROM fk_rec INTO @fk_name, @fk_parent;


        WHILE @@FETCH_STATUS=0 BEGIN
            BEGIN TRY SET @sql=N'ALTER TABLE '+@fk_parent+N' WITH CHECK CHECK CONSTRAINT ['+@fk_name+N']'; EXEC sp_executesql @sql;
            END TRY BEGIN CATCH SET @RecoveryErr=@RecoveryErr+N' | REC_FK_'+@fk_name+N': '+LEFT(ERROR_MESSAGE(),200); END CATCH;
            FETCH NEXT FROM fk_rec INTO @fk_name, @fk_parent;
        END; CLOSE fk_rec; DEALLOCATE fk_rec;

        INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,ErrorMessage)
        VALUES (@LogId,99,N'99_FAIL',N'Run interrotta',SYSUTCDATETIME(),SYSUTCDATETIME(),0,N'FAILED',@ErrMsg+@RecoveryErr);
        UPDATE ImportSIAC.BuildHistory_Log SET FinishedAt=SYSUTCDATETIME(), DurationMs=DATEDIFF_BIG(MILLISECOND,@tStart,SYSUTCDATETIME()),
            Status=N'FAILED', ErrorMessage=@ErrMsg+@RecoveryErr WHERE BuildHistoryLogId=@LogId;
        THROW;
    END CATCH;
END;

GO

