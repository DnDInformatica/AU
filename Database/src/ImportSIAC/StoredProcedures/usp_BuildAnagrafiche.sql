
CREATE   PROCEDURE ImportSIAC.usp_BuildAnagrafiche
    @SoloOrganizzazioni BIT = 0,
    @SoloPersone        BIT = 0,
    @OrgInsertite       INT = NULL OUTPUT,
    @OrgAggiornate      INT = NULL OUTPUT,
    @PersoneInsertite   INT = NULL OUTPUT,
    @PersoneAggiornate  INT = NULL OUTPUT
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY

    DECLARE @t0         DATETIME2 = SYSUTCDATETIME();
    DECLARE @tFase      DATETIME2;
    DECLARE @n          INT;

    SET @OrgInsertite   = 0;
    SET @OrgAggiornate  = 0;
    SET @PersoneInsertite = 0;
    SET @PersoneAggiornate = 0;

    PRINT CONCAT(N'=== usp_BuildAnagrafiche avviata ',
                 CONVERT(NVARCHAR(26), @t0, 121), N' ===');

    /* ==============================================================
       COSTANTI TIPOLOGICHE
       ============================================================== */
    DECLARE @TipoOrgLabProva INT = 6;   -- LAB_PROVA
    DECLARE @TipoOrgLabTar   INT = 9;   -- LAB_TAR
    DECLARE @TipoOrgAltro    INT = 24;  -- ALTRO (default DC/SIA)
    DECLARE @StatoAttivo     TINYINT = 4;   -- CodiceStatoAttivitaId 'Attiva'
    DECLARE @StatoCessato    TINYINT = 3;   -- CodiceStatoAttivitaId 'Cessata'

    /* ==============================================================
       SEZIONE 1 - ORGANIZZAZIONI
       ============================================================== */
    IF @SoloPersone = 0
    BEGIN
        SET @tFase = SYSUTCDATETIME();
        PRINT N'[Org] Fase 1: materializzazione sorgenti...';

        /* 1a - wrk_Org: tutte le organizzazioni da tutte le fonti */
        CREATE TABLE #wrk_Org (
            Fonte               NVARCHAR(20)  NOT NULL,  -- GIDAS_DL / SIA_DC / SIAT_DT
            CodiceEnte          NVARCHAR(100) NULL,
            Denominazione       NVARCHAR(550) NOT NULL,
            CodiceFiscale_Raw   NVARCHAR(50)  NULL,
            PartitaIva_Raw      NVARCHAR(50)  NULL,
            CodiceGamma         NVARCHAR(100) NULL,
            CodOrganizzazione   NVARCHAR(20)  NULL,  -- CodiceUnivoco o CodiceGamma (max 20 chars)
            StatoAttivo         NVARCHAR(5)   NULL,
            TipoOrganizzazioneId INT          NOT NULL,
            /* Normalizzati */
            CF                  NVARCHAR(50)  NULL,
            PIVA                NVARCHAR(50)  NULL,
            BusinessKey         NVARCHAR(500) NOT NULL,
            FonzePriority       TINYINT       NOT NULL  -- 1=SIA(piu completo) 2=SIAT 3=GIDAS
        );

        /* GIDAS DL */
        INSERT INTO #wrk_Org
            (Fonte, CodiceEnte, Denominazione, CodiceFiscale_Raw, PartitaIva_Raw,
             CodiceGamma, CodOrganizzazione, StatoAttivo, TipoOrganizzazioneId,
             CF, PIVA, BusinessKey, FonzePriority)
        SELECT
            N'GIDAS_DL',
            CodiceEnte,
            COALESCE(NULLIF(LTRIM(RTRIM(Denominazione)), N''),
                     NULLIF(LTRIM(RTRIM(CodiceEnte)), N''),
                     N'SCONOSCIUTO'),
            CodiceFiscale,
            PartitaIva,
            CodiceGamma,
            LEFT(COALESCE(NULLIF(CodiceUnivoco, N''), NULLIF(CodiceGamma, N'')), 20),
            Attivo,
            @TipoOrgLabProva,
            NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')), N''),
            NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(PartitaIva,N''),N'-',N''),N' ',N''),N'.',N'')), N''),
            COALESCE(
                NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
                NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(PartitaIva,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
                NULLIF(UPPER(LTRIM(RTRIM(ISNULL(CodiceGamma,N'')))),N''),
                UPPER(CONCAT(N'GIDAS_DL|', COALESCE(NULLIF(CodiceEnte,N''), CAST(StgOrganizzazioneId AS NVARCHAR(20)))))
            ),
            3
        FROM ExtGIDAS.StgOrganizzazione
        WHERE NormalizationStatus IN (N'NORMALIZED', N'NEW')
          AND DataCancellazione IS NULL;

        SET @n = @@ROWCOUNT;
        PRINT CONCAT(N'  GIDAS_DL: ', @n, N' righe');

        /* SIA DC */
        INSERT INTO #wrk_Org
            (Fonte, CodiceEnte, Denominazione, CodiceFiscale_Raw, PartitaIva_Raw,
             CodiceGamma, CodOrganizzazione, StatoAttivo, TipoOrganizzazioneId,
             CF, PIVA, BusinessKey, FonzePriority)
        SELECT
            N'SIA_DC',
            CodiceEnte,
            COALESCE(NULLIF(LTRIM(RTRIM(Denominazione)), N''),
                     NULLIF(LTRIM(RTRIM(CodiceEnte)), N''),
                     N'SCONOSCIUTO'),
            CodiceFiscale,
            PartitaIva,
            CodiceGamma,
            LEFT(COALESCE(NULLIF(CodiceUnivoco, N''), NULLIF(CodiceGamma, N'')), 20),
            Attivo,
            @TipoOrgAltro,
            NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
            NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(PartitaIva,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
            COALESCE(
                NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
                NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(PartitaIva,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
                NULLIF(UPPER(LTRIM(RTRIM(ISNULL(CodiceGamma,N'')))),N''),
                UPPER(CONCAT(N'SIA_DC|', COALESCE(NULLIF(CodiceEnte,N''), CAST(StgOrganizzazioneId AS NVARCHAR(20)))))
            ),
            1
        FROM ExtSIA.SIA_StgOrganizzazione
        WHERE NormalizationStatus IN (N'NORMALIZED', N'NEW')
          AND DataCancellazione IS NULL;

        SET @n = @@ROWCOUNT;
        PRINT CONCAT(N'  SIA_DC:   ', @n, N' righe');

        /* SIAT DT */
        INSERT INTO #wrk_Org
            (Fonte, CodiceEnte, Denominazione, CodiceFiscale_Raw, PartitaIva_Raw,
             CodiceGamma, CodOrganizzazione, StatoAttivo, TipoOrganizzazioneId,
             CF, PIVA, BusinessKey, FonzePriority)
        SELECT
            N'SIAT_DT',
            CodiceEnte,
            COALESCE(NULLIF(LTRIM(RTRIM(Denominazione)), N''),
                     NULLIF(LTRIM(RTRIM(CodiceEnte)), N''),
                     N'SCONOSCIUTO'),
            CodiceFiscale,
            PartitaIva,
            CodiceGamma,
            LEFT(COALESCE(NULLIF(CodiceUnivoco, N''), NULLIF(CodiceGamma, N'')), 20),
            Attivo,
            @TipoOrgLabTar,
            NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
            NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(PartitaIva,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
            COALESCE(
                NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
                NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(PartitaIva,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
                NULLIF(UPPER(LTRIM(RTRIM(ISNULL(CodiceGamma,N'')))),N''),
                UPPER(CONCAT(N'SIAT_DT|', COALESCE(NULLIF(CodiceEnte,N''), CAST(StgOrganizzazioneId AS NVARCHAR(20)))))
            ),
            2
        FROM ExtSIA.SIAT_StgOrganizzazione
        WHERE NormalizationStatus IN (N'NORMALIZED', N'NEW')
          AND DataCancellazione IS NULL;

        SET @n = @@ROWCOUNT;
        PRINT CONCAT(N'  SIAT_DT:  ', @n, N' righe');

        /* 1b - Deduplicazione: per ogni BusinessKey teniamo il record con priorita piu alta */
        CREATE TABLE #wrk_OrgDedup (
            BusinessKey         NVARCHAR(500) NOT NULL PRIMARY KEY,
            Fonte               NVARCHAR(20)  NOT NULL,
            CodiceEnte          NVARCHAR(100) NULL,
            Denominazione       NVARCHAR(550) NOT NULL,
            CF                  NVARCHAR(50)  NULL,
            PIVA                NVARCHAR(50)  NULL,
            CodiceGamma         NVARCHAR(100) NULL,
            CodOrganizzazione   NVARCHAR(20)  NULL,
            StatoAttivo         NVARCHAR(5)   NULL,
            TipoOrganizzazioneId INT          NOT NULL
        );

        INSERT INTO #wrk_OrgDedup
        SELECT
            BusinessKey, Fonte, CodiceEnte, Denominazione,
            CF, PIVA, CodiceGamma, CodOrganizzazione, StatoAttivo, TipoOrganizzazioneId
        FROM (
            SELECT *,
                ROW_NUMBER() OVER (
                    PARTITION BY BusinessKey
                    ORDER BY FonzePriority ASC,
                             CASE WHEN CF IS NOT NULL THEN 0 ELSE 1 END,
                             CASE WHEN PIVA IS NOT NULL THEN 0 ELSE 1 END
                ) AS rn
            FROM #wrk_Org
        ) dedup WHERE rn = 1;

        SET @n = @@ROWCOUNT;
        PRINT CONCAT(N'[Org] Fase 1 completata: ', @n, N' organizzazioni uniche - ',
                     DATEDIFF(SECOND, @tFase, SYSUTCDATETIME()), N's');

        /* 1c - INSERT nuove organizzazioni */
        SET @tFase = SYSUTCDATETIME();
        PRINT N'[Org] Fase 2: INSERT Organizzazioni.Organizzazione...';

        INSERT INTO Organizzazioni.Organizzazione (
            RagioneSociale, Denominazione, PartitaIVA, CodiceFiscale,
            StatoAttivitaId, TipoOrganizzazioneId, CodOrganizzazione,
            DataCreazione, UniqueRowId
        )
        SELECT
            LEFT(w.Denominazione, 550),
            LEFT(w.Denominazione, 550),
            LEFT(w.PIVA, 11),
            LEFT(w.CF,   16),
            CASE
                WHEN UPPER(w.StatoAttivo) IN (N'Y',N'1',N'SI',N'S') THEN @StatoAttivo
                WHEN UPPER(w.StatoAttivo) IN (N'N',N'0')             THEN @StatoCessato
                ELSE NULL
            END,
            w.TipoOrganizzazioneId,
            w.CodOrganizzazione,
            SYSUTCDATETIME(),
            NEWID()
        FROM #wrk_OrgDedup w
        WHERE NOT EXISTS (
            SELECT 1 FROM Organizzazioni.Organizzazione o
            WHERE o.DataCancellazione IS NULL
              AND (
                  (w.CF   IS NOT NULL AND o.CodiceFiscale = w.CF)
               OR (w.PIVA IS NOT NULL AND o.PartitaIVA    = w.PIVA)
               OR (w.CodOrganizzazione IS NOT NULL
                   AND o.CodOrganizzazione = w.CodOrganizzazione)
              )
        );

        SET @OrgInsertite = @@ROWCOUNT;
        PRINT CONCAT(N'[Org]   Inserite: ', @OrgInsertite);

        /* 1d - UPDATE organizzazioni gia presenti se Denominazione e cambiata */
        UPDATE o
        SET o.RagioneSociale  = LEFT(w.Denominazione, 550),
            o.Denominazione   = LEFT(w.Denominazione, 550),
            o.DataModifica    = SYSUTCDATETIME()
        FROM Organizzazioni.Organizzazione o
        INNER JOIN #wrk_OrgDedup w ON (
            (w.CF   IS NOT NULL AND o.CodiceFiscale = w.CF)
         OR (w.PIVA IS NOT NULL AND o.PartitaIVA    = w.PIVA)
         OR (w.CodOrganizzazione IS NOT NULL
             AND o.CodOrganizzazione = w.CodOrganizzazione)
        )
        WHERE o.DataCancellazione IS NULL
          AND (o.RagioneSociale <> LEFT(w.Denominazione, 550)
            OR o.Denominazione  <> LEFT(w.Denominazione, 550));

        SET @OrgAggiornate = @@ROWCOUNT;
        PRINT CONCAT(N'[Org]   Aggiornate: ', @OrgAggiornate);

        /* 1e - INSERT OrganizzazioneIdentificativoFiscale (CF e PIVA) */
        PRINT N'[Org] Fase 3: INSERT OrganizzazioneIdentificativoFiscale...';

        /* CF */
        INSERT INTO Organizzazioni.OrganizzazioneIdentificativoFiscale (
            OrganizzazioneId, PaeseISO2, TipoIdentificativo, Valore,
            Principale, DataCreazione, UniqueRowId
        )
        SELECT
            o.OrganizzazioneId, N'IT', N'CF', w.CF, 1,
            SYSUTCDATETIME(), NEWID()
        FROM #wrk_OrgDedup w
        INNER JOIN Organizzazioni.Organizzazione o
            ON o.CodiceFiscale = w.CF AND o.DataCancellazione IS NULL
        WHERE w.CF IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM Organizzazioni.OrganizzazioneIdentificativoFiscale f
              WHERE f.OrganizzazioneId = o.OrganizzazioneId
                AND f.TipoIdentificativo = N'CF'
                AND f.Valore = w.CF
          );

        /* PIVA */
        INSERT INTO Organizzazioni.OrganizzazioneIdentificativoFiscale (
            OrganizzazioneId, PaeseISO2, TipoIdentificativo, Valore,
            Principale, DataCreazione, UniqueRowId
        )
        SELECT
            o.OrganizzazioneId, N'IT', N'PIVA', w.PIVA, 0,
            SYSUTCDATETIME(), NEWID()
        FROM #wrk_OrgDedup w
        INNER JOIN Organizzazioni.Organizzazione o
            ON (o.CodiceFiscale = w.CF OR o.PartitaIVA = w.PIVA)
            AND o.DataCancellazione IS NULL
        WHERE w.PIVA IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM Organizzazioni.OrganizzazioneIdentificativoFiscale f
              WHERE f.OrganizzazioneId = o.OrganizzazioneId
                AND f.TipoIdentificativo = N'PIVA'
                AND f.Valore = w.PIVA
          );

        SET @n = @@ROWCOUNT;
        PRINT CONCAT(N'[Org] Fase 3 completata: ', @n, N' identificativi fiscali - ',
                     DATEDIFF(SECOND, @tFase, SYSUTCDATETIME()), N's');

        /* 1f - UPDATE CrossRef.OrganizzazioneMap con OrganizzazioneId */
        PRINT N'[Org] Fase 4: UPDATE CrossRef.OrganizzazioneMap...';

        -- Nota: CrossRef vive su StagingSIA (ExtSIA) - read-only via Elastic Query.
        -- L'aggiornamento avviene localmente sui wrk_ come nota di stato.
        -- Per aggiornare CrossRef su StagingSIA serve uno script separato (sia_crossref_update.py).
        PRINT N'[Org]   CrossRef update: da completare via script Python (StagingSIA non scrivibile via Elastic Query)';

        DROP TABLE IF EXISTS #wrk_OrgDedup;
        DROP TABLE IF EXISTS #wrk_Org;

        PRINT CONCAT(N'[Org] COMPLETATO - Inserite=', @OrgInsertite,
                     N' Aggiornate=', @OrgAggiornate);
    END; -- SoloPersone = 0

    /* ==============================================================
       SEZIONE 2 - PERSONE
       ============================================================== */
    IF @SoloOrganizzazioni = 0
    BEGIN
        SET @tFase = SYSUTCDATETIME();
        PRINT N'[Per] Fase 1: materializzazione sorgenti...';

        CREATE TABLE #wrk_Per (
            Fonte               NVARCHAR(20)  NOT NULL,
            CodicePersona       NVARCHAR(100) NULL,
            Nome                NVARCHAR(200) NOT NULL,
            Cognome             NVARCHAR(200) NOT NULL,
            CodiceFiscale_Raw   NVARCHAR(50)  NULL,
            DataNascita_Raw     NVARCHAR(30)  NULL,
            LuogoNascita        NVARCHAR(200) NULL,
            ProvinciaNascita    NVARCHAR(10)  NULL,
            CF                  NVARCHAR(50)  NULL,
            DataNascita         DATE          NULL,
            BusinessKey         NVARCHAR(500) NOT NULL,
            FontePriority       TINYINT       NOT NULL
        );

        /* GIDAS DL */
        INSERT INTO #wrk_Per
            (Fonte, CodicePersona, Nome, Cognome, CodiceFiscale_Raw,
             DataNascita_Raw, LuogoNascita, ProvinciaNascita,
             CF, DataNascita, BusinessKey, FontePriority)
        SELECT
            N'GIDAS_DL',
            CodicePersona,
            COALESCE(NULLIF(LTRIM(RTRIM(Nome)), N''), N'SCONOSCIUTO'),
            COALESCE(NULLIF(LTRIM(RTRIM(Cognome)), N''), N'SCONOSCIUTO'),
            CodiceFiscale, NULL, NULL, NULL,
            NULLIF(UPPER(REPLACE(REPLACE(REPLACE(
                ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
            NULLIF(COALESCE(
                TRY_CONVERT(date, DataNascita, 103),
                TRY_CONVERT(date, DataNascita, 101),
                TRY_CONVERT(date, DataNascita, 120)
            ), CAST('19000101' AS date)),
            COALESCE(
                NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
                NULLIF(UPPER(CONCAT(
                    LTRIM(RTRIM(ISNULL(Nome,N''))), N'|',
                    LTRIM(RTRIM(ISNULL(Cognome,N''))), N'|',
                    ISNULL(CONVERT(NVARCHAR(10), NULLIF(COALESCE(
                        TRY_CONVERT(date, DataNascita, 103),
                        TRY_CONVERT(date, DataNascita, 101)
                    ), CAST('19000101' AS date)), 23), N'')
                )), N'')
            ),
            3
        FROM ExtGIDAS.StgPersona
        WHERE NormalizationStatus IN (N'NORMALIZED', N'NEW')
          AND DataCancellazione IS NULL
          AND (NULLIF(LTRIM(RTRIM(ISNULL(Nome,N''))),N'') IS NOT NULL
            OR NULLIF(LTRIM(RTRIM(ISNULL(Cognome,N''))),N'') IS NOT NULL);

        SET @n = @@ROWCOUNT;
        PRINT CONCAT(N'  GIDAS_DL: ', @n, N' righe');

        /* SIA DC */
        INSERT INTO #wrk_Per
            (Fonte, CodicePersona, Nome, Cognome, CodiceFiscale_Raw,
             DataNascita_Raw, LuogoNascita, ProvinciaNascita,
             CF, DataNascita, BusinessKey, FontePriority)
        SELECT
            N'SIA_DC',
            PersonaSIA,
            COALESCE(NULLIF(LTRIM(RTRIM(Nome)), N''), N'SCONOSCIUTO'),
            COALESCE(NULLIF(LTRIM(RTRIM(Cognome)), N''), N'SCONOSCIUTO'),
            CodiceFiscale, DataNascita, LuogoNascita, LEFT(ProvinciaNascita,2),
            NULLIF(UPPER(REPLACE(REPLACE(REPLACE(
                ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
            NULLIF(COALESCE(
                TRY_CONVERT(date, DataNascita, 103),
                TRY_CONVERT(date, DataNascita, 101),
                TRY_CONVERT(date, DataNascita, 120)
            ), CAST('19000101' AS date)),
            COALESCE(
                NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
                NULLIF(UPPER(CONCAT(
                    LTRIM(RTRIM(ISNULL(Nome,N''))), N'|',
                    LTRIM(RTRIM(ISNULL(Cognome,N''))), N'|',
                    ISNULL(CONVERT(NVARCHAR(10), NULLIF(COALESCE(
                        TRY_CONVERT(date, DataNascita, 103),
                        TRY_CONVERT(date, DataNascita, 101)
                    ), CAST('19000101' AS date)), 23), N'')
                )), N'')
            ),
            1
        FROM ExtSIA.SIA_StgPersona
        WHERE NormalizationStatus IN (N'NORMALIZED', N'NEW')
          AND DataCancellazione IS NULL
          AND (NULLIF(LTRIM(RTRIM(ISNULL(Nome,N''))),N'') IS NOT NULL
            OR NULLIF(LTRIM(RTRIM(ISNULL(Cognome,N''))),N'') IS NOT NULL);

        SET @n = @@ROWCOUNT;
        PRINT CONCAT(N'  SIA_DC:   ', @n, N' righe');

        /* SIAT DT */
        INSERT INTO #wrk_Per
            (Fonte, CodicePersona, Nome, Cognome, CodiceFiscale_Raw,
             DataNascita_Raw, LuogoNascita, ProvinciaNascita,
             CF, DataNascita, BusinessKey, FontePriority)
        SELECT
            N'SIAT_DT',
            PersonaSIAT,
            COALESCE(NULLIF(LTRIM(RTRIM(Nome)), N''), N'SCONOSCIUTO'),
            COALESCE(NULLIF(LTRIM(RTRIM(Cognome)), N''), N'SCONOSCIUTO'),
            CodiceFiscale, NULL, NULL, NULL,
            NULLIF(UPPER(REPLACE(REPLACE(REPLACE(
                ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
            NULL,
            COALESCE(
                NULLIF(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(CodiceFiscale,N''),N'-',N''),N' ',N''),N'.',N'')),N''),
                NULLIF(UPPER(CONCAT(
                    LTRIM(RTRIM(ISNULL(Nome,N''))), N'|',
                    LTRIM(RTRIM(ISNULL(Cognome,N'')))
                )), N'')
            ),
            2
        FROM ExtSIA.SIAT_StgPersona
        WHERE NormalizationStatus IN (N'NORMALIZED', N'NEW')
          AND DataCancellazione IS NULL
          AND (NULLIF(LTRIM(RTRIM(ISNULL(Nome,N''))),N'') IS NOT NULL
            OR NULLIF(LTRIM(RTRIM(ISNULL(Cognome,N''))),N'') IS NOT NULL);

        SET @n = @@ROWCOUNT;
        PRINT CONCAT(N'  SIAT_DT:  ', @n, N' righe');

        /* 2b - Deduplicazione */
        CREATE TABLE #wrk_PerDedup (
            BusinessKey     NVARCHAR(500) NOT NULL PRIMARY KEY,
            Fonte           NVARCHAR(20)  NOT NULL,
            Nome            NVARCHAR(200) NOT NULL,
            Cognome         NVARCHAR(200) NOT NULL,
            CF              NVARCHAR(50)  NULL,
            DataNascita     DATE          NULL,
            LuogoNascita    NVARCHAR(200) NULL,
            ProvinciaNascita NVARCHAR(10) NULL
        );

        INSERT INTO #wrk_PerDedup
        SELECT BusinessKey, Fonte, Nome, Cognome, CF, DataNascita,
               LuogoNascita, ProvinciaNascita
        FROM (
            SELECT *,
                ROW_NUMBER() OVER (
                    PARTITION BY BusinessKey
                    ORDER BY FontePriority ASC,
                             CASE WHEN CF IS NOT NULL THEN 0 ELSE 1 END,
                             CASE WHEN DataNascita IS NOT NULL THEN 0 ELSE 1 END
                ) AS rn
            FROM #wrk_Per
        ) d WHERE rn = 1;

        SET @n = @@ROWCOUNT;
        PRINT CONCAT(N'[Per] Fase 1 completata: ', @n, N' persone uniche - ',
                     DATEDIFF(SECOND, @tFase, SYSUTCDATETIME()), N's');

        /* 2c - INSERT nuove persone */
        SET @tFase = SYSUTCDATETIME();
        PRINT N'[Per] Fase 2: INSERT Persone.Persona...';

        INSERT INTO Persone.Persona (
            CodiceFiscale, Cognome, Nome, DataNascita,
            LuogoNascita, ProvinciaNascita,
            ConsensoPrivacy, DataCreazione, UniqueRowId
        )
        SELECT
            CASE WHEN w.CF IS NOT NULL AND LEN(w.CF) = 16 THEN w.CF ELSE NULL END,
            LEFT(w.Cognome, 100),
            LEFT(w.Nome, 100),
            COALESCE(w.DataNascita, CAST('1900-01-01' AS date)),
            LEFT(w.LuogoNascita, 100),
            LEFT(w.ProvinciaNascita, 2),
            0,   -- ConsensoPrivacy = false (da raccogliere)
            SYSUTCDATETIME(),
            NEWID()
        FROM #wrk_PerDedup w
        WHERE NOT EXISTS (
            SELECT 1 FROM Persone.Persona p
            WHERE p.DataCancellazione IS NULL
              AND (
                  (w.CF IS NOT NULL AND p.CodiceFiscale = w.CF)
               OR (p.Cognome = LEFT(w.Cognome, 100)
                   AND p.Nome = LEFT(w.Nome, 100)
                   AND p.DataNascita = COALESCE(w.DataNascita, CAST('1900-01-01' AS date)))
              )
        );

        SET @PersoneInsertite = @@ROWCOUNT;

        /* 2d - UPDATE persone esistenti se DataNascita ora disponibile */
        UPDATE p
        SET p.DataNascita    = w.DataNascita,
            p.LuogoNascita   = COALESCE(LEFT(w.LuogoNascita, 100), p.LuogoNascita),
            p.ProvinciaNascita = COALESCE(LEFT(w.ProvinciaNascita, 2), p.ProvinciaNascita),
            p.DataModifica   = SYSUTCDATETIME()
        FROM Persone.Persona p
        INNER JOIN #wrk_PerDedup w ON p.CodiceFiscale = w.CF
        WHERE p.DataCancellazione IS NULL
          AND w.CF IS NOT NULL AND LEN(w.CF) = 16
          AND w.DataNascita IS NOT NULL
          AND p.DataNascita = CAST('1900-01-01' AS date);

        SET @PersoneAggiornate = @@ROWCOUNT;

        PRINT CONCAT(N'[Per] Fase 2 completata - Inserite=', @PersoneInsertite,
                     N' Aggiornate=', @PersoneAggiornate, N' - ',
                     DATEDIFF(SECOND, @tFase, SYSUTCDATETIME()), N's');

        DROP TABLE IF EXISTS #wrk_PerDedup;
        DROP TABLE IF EXISTS #wrk_Per;
    END; -- SoloOrganizzazioni = 0

    /* ==============================================================
       RIEPILOGO FINALE
       ============================================================== */
    DECLARE @totOrg  INT = (SELECT COUNT(*) FROM Organizzazioni.Organizzazione
                             WHERE DataCancellazione IS NULL);
    DECLARE @totPer  INT = (SELECT COUNT(*) FROM Persone.Persona
                             WHERE DataCancellazione IS NULL);

    PRINT CONCAT(N'=== usp_BuildAnagrafiche COMPLETATA in ',
                 DATEDIFF(SECOND, @t0, SYSUTCDATETIME()), N's ===');
    PRINT CONCAT(N'  Organizzazioni - inserite: ', @OrgInsertite,
                 N'  aggiornate: ', @OrgAggiornate,
                 N'  totale in tabella: ', @totOrg);
    PRINT CONCAT(N'  Persone         - inserite: ', @PersoneInsertite,
                 N'  aggiornate: ', @PersoneAggiornate,
                 N'  totale in tabella: ', @totPer);

    RETURN 0;

END TRY
BEGIN CATCH
    DROP TABLE IF EXISTS #wrk_OrgDedup;
    DROP TABLE IF EXISTS #wrk_Org;
    DROP TABLE IF EXISTS #wrk_PerDedup;
    DROP TABLE IF EXISTS #wrk_Per;

    DECLARE @ErrMsg   NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrLine  INT            = ERROR_LINE();
    DECLARE @ErrProc  NVARCHAR(200)  = ERROR_PROCEDURE();
    RAISERROR(N'[usp_BuildAnagrafiche] Errore riga %d in %s: %s',
              16, 1, @ErrLine, @ErrProc, @ErrMsg);
    RETURN 1;
END CATCH;

GO

