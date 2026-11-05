-- ================================================================================
-- ImportSIAC.usp_BH_05B_SedeMap
-- Estratto dal monolite (step 05B_SEDE_MAP). Census sedi mancanti (L3) +
-- mappatura sede->SedeId (L1/L2). Costo storico ~65 min.
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_05B_SedeMap
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;

    -- CHECKPOINT: skip se wrk_SedeMap e' ancora valida
    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'05B_SEDE_MAP', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        -- MIG_127: resume 05B da metriche checkpoint
        SELECT @Rows = RowCountAtSave
        FROM ImportSIAC.BuildHistory_CheckpointOutput
        WHERE StepCode = N'05B_SEDE_MAP'
          AND OutputTable = N'ImportSIAC.wrk_PP_Sedi_Raw'
          AND IsRequired = 1;
        IF @Rows IS NULL
            THROW 62720, 'Metrica wrk_PP_Sedi_Raw assente dal checkpoint 05B.', 1;
        SET @RowsAffected = @Rows;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,5,N'05B_SEDE_MAP',N'SedeMap (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: wrk_SedeMap/wrk_PP_Sedi_Raw gia validi.');
        PRINT CONCAT('STEP 05B_SEDE_MAP: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,5,N'05B_SEDE_MAP',N'SedeMap',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        DROP TABLE IF EXISTS ImportSIAC.wrk_PP_Sedi_Raw;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SedeCensus;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SedeKeyDistinct;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SedeL1Map;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SedeL2Map;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SedeMap;

        ;WITH RankedSedi AS (
            SELECT
                NumeroCertificato, OrganizzazioneODCId, DataPrimoRilascio,
                SnapshotYear, SnapshotMonth, SnapshotDate, SnapshotBusinessTs,
                OrganizzazioneClienteId,
                sede_address AS address, sede_city AS city, sede_zip AS zip,
                raw_site_type, raw_site_province, raw_site_country,
                AmbitoIta, AmbitoEng,
                DataScadenza AS DataScadenzaSede,
                publication_date, insertdate, RawId,
                ROW_NUMBER() OVER (
                    PARTITION BY NumeroCertificato, OrganizzazioneODCId, DataPrimoRilascio,
                                 SnapshotYear, SnapshotMonth, sede_address, sede_city, sede_zip
                    ORDER BY publication_date DESC, insertdate DESC, RawId DESC
                ) AS Rn
            FROM ImportSIAC.wrk_All_Resolved
            WHERE Dominio = 'PP'
              AND sede_address IS NOT NULL AND sede_address <> ''
        )
        SELECT NumeroCertificato, OrganizzazioneODCId, DataPrimoRilascio,
               SnapshotYear, SnapshotMonth, SnapshotDate, SnapshotBusinessTs,
               OrganizzazioneClienteId, address, city, zip,
               raw_site_type, raw_site_province, raw_site_country,
               AmbitoIta, AmbitoEng, DataScadenzaSede
        INTO ImportSIAC.wrk_PP_Sedi_Raw
        FROM RankedSedi WHERE Rn = 1
        OPTION (MAXDOP 8, MIN_GRANT_PERCENT = 25);

        CREATE NONCLUSTERED INDEX CX_PP_Sedi_Raw
            ON ImportSIAC.wrk_PP_Sedi_Raw (NumeroCertificato, OrganizzazioneODCId, DataPrimoRilascio, SnapshotDate)
            INCLUDE (OrganizzazioneClienteId, address, city, zip, AmbitoIta, AmbitoEng, DataScadenzaSede);

        -- FASE 05B.1 - CENSUS SEDI (L3)
        ;WITH SediNorm AS (
            SELECT
                r.OrganizzazioneClienteId,
                LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(
                    UPPER(r.address), ',,,',''), ', , ,',''), '  ',' '))) AS Ind_norm,
                UPPER(LTRIM(RTRIM(r.city)))  AS Localita,
                ISNULL(r.zip,'')             AS CAP,
                r.raw_site_type, r.raw_site_province, r.raw_site_country,
                ROW_NUMBER() OVER (
                    PARTITION BY r.OrganizzazioneClienteId,
                        LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(UPPER(r.address),',,,',''),', , ,',''),'  ',' '))),
                        UPPER(LTRIM(RTRIM(r.city))), ISNULL(r.zip,'')
                    ORDER BY CASE r.raw_site_type WHEN '01' THEN 1 WHEN '03' THEN 2 WHEN '02' THEN 3
                        WHEN '04' THEN 4 WHEN '05' THEN 5 WHEN '06' THEN 6 WHEN '999' THEN 7 ELSE 8 END
                ) AS Rn
            FROM ImportSIAC.wrk_PP_Sedi_Raw r
            WHERE r.OrganizzazioneClienteId IS NOT NULL
        )
        SELECT OrganizzazioneClienteId, Ind_norm, Localita, CAP,
               raw_site_type, raw_site_province, raw_site_country
        INTO ImportSIAC.wrk_SedeCensus
        FROM SediNorm
        WHERE Rn = 1 AND LEN(Ind_norm) >= 3 AND Localita <> '';

        INSERT INTO Organizzazioni.Sede (
            OrganizzazioneId, TipoSedeId, Indirizzo, Localita, CAP, Provincia, Nazione,
            StatoSede, IsSedePrincipale, IsSedeOperativa, DataCreazione, UniqueRowId
        )
        SELECT DISTINCT
            c.OrganizzazioneClienteId,
            CASE c.raw_site_type
                WHEN '01' THEN 1 WHEN '02' THEN 3 WHEN '03' THEN 4
                WHEN '04' THEN 5 WHEN '05' THEN 6 WHEN '06' THEN 7
                ELSE 8 END AS TipoSedeId,
            LEFT(c.Ind_norm, 250),
            LEFT(c.Localita, 150),
            CASE WHEN LEN(c.CAP) BETWEEN 1 AND 10 THEN c.CAP ELSE NULL END,
            LEFT(c.raw_site_province, 50),
            LEFT(c.raw_site_country, 100),
            N'Active',
            CASE WHEN c.raw_site_type = '01' THEN 1 ELSE 0 END,
            CASE WHEN c.raw_site_type IN ('02','03','05','06') THEN 1 ELSE 0 END,
            SYSUTCDATETIME(), NEWID()
        FROM ImportSIAC.wrk_SedeCensus c
        WHERE NOT EXISTS (
            SELECT 1 FROM Organizzazioni.Sede o
            WHERE o.OrganizzazioneId = c.OrganizzazioneClienteId
              AND LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(UPPER(o.Indirizzo),',,,',''),', , ,',''),'  ',' '))) = c.Ind_norm
              AND UPPER(LTRIM(RTRIM(o.Localita))) = c.Localita
              AND ISNULL(o.CAP,'') = c.CAP
              AND o.DataCancellazione IS NULL
        )
        OPTION (MAXDOP 8);
        PRINT CONCAT('  Census Sedi: create ', @@ROWCOUNT, ' nuove sedi');

        DROP TABLE ImportSIAC.wrk_SedeCensus;

        -- FASE 05B.2 - SEDEMAP (L1/L2)
        SELECT DISTINCT
            OrganizzazioneClienteId,
            LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(UPPER(address),',,,',''),', , ,',''),'  ',' '))) AS address_norm,
            UPPER(LTRIM(RTRIM(city))) AS city_norm,
            ISNULL(zip,'') AS zip_norm,
            address, city, zip
        INTO ImportSIAC.wrk_SedeKeyDistinct
        FROM ImportSIAC.wrk_PP_Sedi_Raw WHERE OrganizzazioneClienteId IS NOT NULL;

        ALTER TABLE ImportSIAC.wrk_SedeKeyDistinct ADD IndHash AS
            HASHBYTES('SHA2_256', CONCAT(address_norm, '|', city_norm, '|', zip_norm)) PERSISTED;
        CREATE NONCLUSTERED INDEX CX_SedeKeyDistinct
            ON ImportSIAC.wrk_SedeKeyDistinct (OrganizzazioneClienteId, IndHash);

        SELECT s.OrganizzazioneId,
               LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(UPPER(s.Indirizzo),',,,',''),', , ,',''),'  ',' '))) AS Ind_norm,
               UPPER(LTRIM(RTRIM(s.Localita))) AS Localita_norm,
               ISNULL(s.CAP, '') AS CAP_norm,
               MIN(s.SedeId) AS SedeId
        INTO ImportSIAC.wrk_SedeL1Map
        FROM Organizzazioni.Sede s WHERE s.DataCancellazione IS NULL
        GROUP BY s.OrganizzazioneId,
               LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(UPPER(s.Indirizzo),',,,',''),', , ,',''),'  ',' '))),
               UPPER(LTRIM(RTRIM(s.Localita))), ISNULL(s.CAP,'');
        ALTER TABLE ImportSIAC.wrk_SedeL1Map ADD IndHash AS
            HASHBYTES('SHA2_256', CONCAT(Ind_norm, '|', Localita_norm, '|', CAP_norm)) PERSISTED;
        CREATE NONCLUSTERED INDEX CX_SedeL1Map ON ImportSIAC.wrk_SedeL1Map (OrganizzazioneId, IndHash) INCLUDE (SedeId);

        SELECT s.OrganizzazioneId,
               UPPER(LTRIM(RTRIM(s.Localita))) AS Localita_norm,
               ISNULL(s.CAP, '') AS CAP_norm,
               COUNT(*) AS CntSedi, MIN(s.SedeId) AS SedeId
        INTO ImportSIAC.wrk_SedeL2Map
        FROM Organizzazioni.Sede s WHERE s.DataCancellazione IS NULL
        GROUP BY s.OrganizzazioneId, UPPER(LTRIM(RTRIM(s.Localita))), ISNULL(s.CAP,'');
        CREATE NONCLUSTERED INDEX CX_SedeL2Map ON ImportSIAC.wrk_SedeL2Map (OrganizzazioneId, Localita_norm, CAP_norm) INCLUDE (CntSedi, SedeId);

        SELECT sk.OrganizzazioneClienteId, sk.address, sk.city, sk.zip,
               COALESCE(
                   l1.SedeId,
                   CASE WHEN l2.CntSedi = 1 THEN l2.SedeId ELSE NULL END
               ) AS SedeId
        INTO ImportSIAC.wrk_SedeMap
        FROM ImportSIAC.wrk_SedeKeyDistinct sk
        LEFT JOIN ImportSIAC.wrk_SedeL1Map l1
            ON  l1.OrganizzazioneId = sk.OrganizzazioneClienteId
            AND l1.IndHash = sk.IndHash
        LEFT JOIN ImportSIAC.wrk_SedeL2Map l2
            ON  l2.OrganizzazioneId = sk.OrganizzazioneClienteId
            AND l2.Localita_norm    = sk.city_norm
            AND l2.CAP_norm         = sk.zip_norm
        OPTION (MAXDOP 8);

        CREATE NONCLUSTERED INDEX CX_SedeMap ON ImportSIAC.wrk_SedeMap (OrganizzazioneClienteId)
            INCLUDE (address, city, zip, SedeId);
        DROP TABLE ImportSIAC.wrk_SedeKeyDistinct;
        DROP TABLE ImportSIAC.wrk_SedeL1Map;
        DROP TABLE ImportSIAC.wrk_SedeL2Map;

        SELECT @Rows = SUM(CONVERT(BIGINT, p.rows))
        FROM sys.partitions AS p
        WHERE p.object_id = OBJECT_ID(N'ImportSIAC.wrk_PP_Sedi_Raw', N'U')
          AND p.index_id IN (0, 1);
        IF @Rows IS NULL
            THROW 62721, 'Conteggio metadata wrk_PP_Sedi_Raw non disponibile.', 1;
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 05B_SEDE_MAP: ', @Rows);

        DECLARE @SedeMapRows BIGINT = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_SedeMap);
        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'05B_SEDE_MAP', @OutputTable=N'ImportSIAC.wrk_SedeMap',
            @RowCountAtSave=@SedeMapRows, @Notes=N'Census sedi + SedeMap L1/L2.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'FAILED', ErrorMessage=@ErrMsg
        WHERE BuildHistoryStepLogId=@StepLogId;
        THROW;
    END CATCH;
END;

GO

