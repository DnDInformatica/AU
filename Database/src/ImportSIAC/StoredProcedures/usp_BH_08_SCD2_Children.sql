-- ================================================================================
-- ImportSIAC.usp_BH_08_SCD2_Children
-- Estratto dal monolite (step 08_SCD2_CHILDREN). Calcola le versioni SCD2 dei
-- 4 domini figli (SG/PRD/FPC/Sede) via firma hash + LAG/LEAD, con il fix
-- PARTITION BY su SedeId (non indirizzo grezzo) per evitare overlap temporali.
-- Consuma (droppa) wrk_MonthlyBest, wrk_PP_Sedi_Raw, wrk_SedeMap.
-- Costo storico ~80 min (il piu' lungo della pipeline).
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_08_SCD2_Children
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;

    -- CHECKPOINT: skip se i 4 output finali sono ancora validi (verifico Sede_Final come rappresentante)
    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'08_SCD2_CHILDREN', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
       AND OBJECT_ID('ImportSIAC.wrk_SG_Final') IS NOT NULL
       AND OBJECT_ID('ImportSIAC.wrk_PRD_Final') IS NOT NULL
       AND OBJECT_ID('ImportSIAC.wrk_FPC_Final') IS NOT NULL
    BEGIN
        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_SG_Final) + (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_PRD_Final)
                  + (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_FPC_Final) + (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_Sede_Final);
        SET @RowsAffected = @Rows;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,8,N'08_SCD2_CHILDREN',N'SCD2 figli (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: SG/PRD/FPC/Sede_Final gia validi.');
        PRINT CONCAT('STEP 08_SCD2_CHILDREN: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,8,N'08_SCD2_CHILDREN',N'SCD2 figli SG/PRD/FPC/Sede',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        DROP TABLE IF EXISTS ImportSIAC.wrk_SG_SigBase;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SG_Changes;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SG_Final;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PRD_SigBase;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PRD_Changes;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PRD_Final;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_SigBase;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_Changes;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_Final;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Sede_SigBase;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Sede_Changes;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Sede_Final;

        -- ===== SG =====
        SELECT mb.ChiaveBusinessHash, mb.NumeroCertificato, mb.OrganizzazioneODCId, mb.DataPrimoRilascio,
            mb.SnapshotDate, mb.SnapshotBusinessTs,
            mb.OrganizzazioneClienteId, mb.AmbitoIta, mb.AmbitoEng, mb.DataUltimoRinnovo,
            HASHBYTES('SHA2_256', CONCAT(
                ISNULL(CONVERT(VARCHAR(20), mb.OrganizzazioneClienteId), 'NULL'), '|',
                ISNULL(mb.AmbitoIta, 'NULL'), '|', ISNULL(mb.AmbitoEng, 'NULL'), '|',
                ISNULL(CONVERT(VARCHAR(10), mb.DataUltimoRinnovo, 23), 'NULL')
            )) AS RowSig
        INTO ImportSIAC.wrk_SG_SigBase FROM ImportSIAC.wrk_MonthlyBest mb WHERE mb.Dominio = 'PP' OPTION (MAXDOP 8);
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_SG_SigBase ON ImportSIAC.wrk_SG_SigBase;

        SELECT sg.*,
            LAG(sg.RowSig)  OVER (PARTITION BY sg.ChiaveBusinessHash ORDER BY sg.SnapshotDate) AS PrevRowSig,
            LEAD(sg.SnapshotBusinessTs) OVER (PARTITION BY sg.ChiaveBusinessHash ORDER BY sg.SnapshotDate) AS NextBusinessTs,
            MAX(sg.SnapshotDate) OVER (PARTITION BY sg.ChiaveBusinessHash) AS MaxSnapshotDate
        INTO ImportSIAC.wrk_SG_Changes FROM ImportSIAC.wrk_SG_SigBase sg OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_SG_SigBase;

        SELECT sc.ChiaveBusinessHash, sc.NumeroCertificato, sc.OrganizzazioneODCId, sc.DataPrimoRilascio,
            sc.OrganizzazioneClienteId, sc.AmbitoIta, sc.AmbitoEng, sc.DataUltimoRinnovo,
            sc.SnapshotBusinessTs AS DataInizioValiditaSG,
            COALESCE(DATEADD(NANOSECOND,-100, LEAD(sc.SnapshotBusinessTs) OVER (PARTITION BY sc.ChiaveBusinessHash ORDER BY sc.SnapshotDate)), CAST('9999-12-31 23:59:59.9999999' AS DATETIME2(7))) AS DataFineValiditaSG, /* MIG_150: chiusura sulla variazione successiva */
            CASE WHEN LEAD(sc.SnapshotBusinessTs) OVER (PARTITION BY sc.ChiaveBusinessHash ORDER BY sc.SnapshotDate) IS NULL THEN 1 ELSE 0 END AS IsCorrente /* MIG_150 */
        INTO ImportSIAC.wrk_SG_Final FROM ImportSIAC.wrk_SG_Changes sc
        WHERE sc.PrevRowSig IS NULL OR sc.PrevRowSig <> sc.RowSig
           -- MIG_150: rimossa la forzatura dell'ultima osservazione (ora la ricava il LEAD sulle variazioni)
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_SG_Changes;
        CREATE CLUSTERED INDEX CX_SG_Final ON ImportSIAC.wrk_SG_Final (ChiaveBusinessHash, DataInizioValiditaSG);

        -- ===== PRD =====
        SELECT mb.ChiaveBusinessHash, mb.NumeroCertificato, mb.OrganizzazioneODCId, mb.DataPrimoRilascio,
            mb.SnapshotDate, mb.SnapshotBusinessTs,
            mb.OrganizzazioneClienteId, mb.ScopoCertificato, mb.NomeProdotto,
            mb.SpecificaTecnica, /* MIG_111A: PRD usa profilo tecnico */ mb.DataUltimoRinnovo,
            HASHBYTES('SHA2_256', CONCAT(
                ISNULL(CONVERT(VARCHAR(20), mb.OrganizzazioneClienteId), 'NULL'), '|',
                ISNULL(mb.ScopoCertificato, 'NULL'), '|', ISNULL(mb.NomeProdotto, 'NULL'), '|',
                ISNULL(mb.SpecificaTecnica, 'NULL'), '|',
                
                ISNULL(CONVERT(VARCHAR(10), mb.DataUltimoRinnovo, 23), 'NULL')
            )) AS RowSig
        INTO ImportSIAC.wrk_PRD_SigBase FROM ImportSIAC.wrk_MonthlyBest mb WHERE mb.Dominio = 'PRD' OPTION (MAXDOP 8);
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_PRD_SigBase ON ImportSIAC.wrk_PRD_SigBase;

        SELECT prd.*,
            LAG(prd.RowSig)  OVER (PARTITION BY prd.ChiaveBusinessHash ORDER BY prd.SnapshotDate) AS PrevRowSig,
            LEAD(prd.SnapshotBusinessTs) OVER (PARTITION BY prd.ChiaveBusinessHash ORDER BY prd.SnapshotDate) AS NextBusinessTs,
            MAX(prd.SnapshotDate) OVER (PARTITION BY prd.ChiaveBusinessHash) AS MaxSnapshotDate
        INTO ImportSIAC.wrk_PRD_Changes FROM ImportSIAC.wrk_PRD_SigBase prd OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_PRD_SigBase;

        SELECT pc.ChiaveBusinessHash, pc.NumeroCertificato, pc.OrganizzazioneODCId, pc.DataPrimoRilascio,
            pc.OrganizzazioneClienteId, pc.ScopoCertificato, pc.NomeProdotto,
            pc.SpecificaTecnica, pc.DataUltimoRinnovo,
            pc.SnapshotBusinessTs AS DataInizioValiditaPRD,
            COALESCE(DATEADD(NANOSECOND,-100, LEAD(pc.SnapshotBusinessTs) OVER (PARTITION BY pc.ChiaveBusinessHash ORDER BY pc.SnapshotDate)), CAST('9999-12-31 23:59:59.9999999' AS DATETIME2(7))) AS DataFineValiditaPRD, /* MIG_150: chiusura sulla variazione successiva */
            CASE WHEN LEAD(pc.SnapshotBusinessTs) OVER (PARTITION BY pc.ChiaveBusinessHash ORDER BY pc.SnapshotDate) IS NULL THEN 1 ELSE 0 END AS IsCorrente /* MIG_150 */
        INTO ImportSIAC.wrk_PRD_Final FROM ImportSIAC.wrk_PRD_Changes pc
        WHERE pc.PrevRowSig IS NULL OR pc.PrevRowSig <> pc.RowSig
           -- MIG_150: rimossa la forzatura dell'ultima osservazione
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_PRD_Changes;
        CREATE CLUSTERED INDEX CX_PRD_Final ON ImportSIAC.wrk_PRD_Final (ChiaveBusinessHash, DataInizioValiditaPRD);

        -- ===== FPC =====
        -- MIG_162: mappe precalcolate al posto delle interrogazioni per riga.
        -- Il livello e' associato alla COPPIA (codice profilo, valore atteso):
        -- solo i due schemi di competenze digitali possono ottenerlo, cosi' le
        -- sigle A1..C2 usate dai profili del settore gas restano escluse.
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_MappaLivello;
        SELECT p.ProfiloCodice,
               UPPER(LTRIM(RTRIM(v.value))) AS ValoreAtteso,
               MIN(l.LivelloDigCompId)      AS LivelloDigCompId
        INTO ImportSIAC.wrk_FPC_MappaLivello
        FROM Tipologica.LivelloDigComp l
        JOIN Tipologica.ScalaLivelloDigComp s
             ON s.ScalaLivelloDigCompId = l.ScalaLivelloDigCompId
        CROSS APPLY STRING_SPLIT(l.ValoriSiacAttesi, '|') v
        JOIN (VALUES (N'04.012.240', N'DIGCOMP_1_8'),
                     (N'04.012.252', N'DIGCOMPEDU_CEFR')) p (ProfiloCodice, ScalaCodice)
             ON p.ScalaCodice = s.Codice
        WHERE l.Attivo = 1 AND l.DataCancellazione IS NULL
          AND NULLIF(LTRIM(RTRIM(v.value)), N'') IS NOT NULL
        GROUP BY p.ProfiloCodice, UPPER(LTRIM(RTRIM(v.value)));
        CREATE UNIQUE CLUSTERED INDEX CX_FPC_MappaLivello
            ON ImportSIAC.wrk_FPC_MappaLivello (ProfiloCodice, ValoreAtteso);

        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_MappaProgramma;
        SELECT o.OrganizzazioneId,
               MIN(pc.ProgrammaCertificazioneId) AS ProgrammaCertificazioneId
        INTO ImportSIAC.wrk_FPC_MappaProgramma
        FROM Organizzazioni.Organizzazione o
        JOIN Certificazione.ProgrammaCertificazione pc
             ON pc.DataCancellazione IS NULL
            AND pc.Attivo = 1
            AND pc.NormaAccreditamentoSchemaId = 93
            AND (pc.ProprietarioSchema LIKE '%' + o.RagioneSociale + '%'
                 OR o.RagioneSociale LIKE '%' + pc.ProprietarioSchema + '%')
        WHERE o.DataCancellazione IS NULL
        GROUP BY o.OrganizzazioneId;
        CREATE UNIQUE CLUSTERED INDEX CX_FPC_MappaProgramma
            ON ImportSIAC.wrk_FPC_MappaProgramma (OrganizzazioneId);

        SELECT mb.ChiaveBusinessHash, mb.NumeroCertificato, mb.OrganizzazioneODCId, mb.DataPrimoRilascio,
            mb.SnapshotDate, mb.SnapshotBusinessTs,
            mb.TipoQualificaId, mb.competence_level AS Settore,
            mb.fpc_release_date AS DataEmissioneCorrente,
            mb.Straniero, mb.person_code AS CodicePersonaODC, mb.SiacId,
            mb.fpc_fiscal_code, mb.first_name, mb.last_name, mb.birth_date, mb.birth_place,
            -- MIG_107: profilo professionale FPC canonico
            NULLIF(LTRIM(RTRIM(mb.professional_code_json)), N'') AS ProfiloProfessionaleCodice,
            ppv.ProfiloProfessionaleVersioneId,
            mlv.LivelloDigCompId, /* MIG_162 */
            mpg.ProgrammaCertificazioneId, /* MIG_162 */
            HASHBYTES('SHA2_256', CONCAT(
                ISNULL(CONVERT(VARCHAR(20), mb.TipoQualificaId), 'NULL'), '|',
                ISNULL(mb.competence_level, 'NULL'), '|',
                ISNULL(CONVERT(VARCHAR(10), mb.fpc_release_date, 23), 'NULL'), '|',
                ISNULL(CONVERT(VARCHAR(1), mb.Straniero), 'NULL'), '|',
                ISNULL(mb.person_code, 'NULL'), '|',
                ISNULL(NULLIF(LTRIM(RTRIM(mb.professional_code_json)), N''), 'NULL')
            )) AS RowSig
        INTO ImportSIAC.wrk_FPC_SigBase
        FROM ImportSIAC.wrk_MonthlyBest mb
        LEFT JOIN ImportSIAC.wrk_FPC_MappaLivello mlv
               ON mlv.ProfiloCodice = LTRIM(RTRIM(mb.professional_code_json))
              AND mlv.ValoreAtteso  = UPPER(LTRIM(RTRIM(mb.competence_level)))
        LEFT JOIN ImportSIAC.wrk_FPC_MappaProgramma mpg
               ON mpg.OrganizzazioneId = mb.OrganizzazioneODCId /* MIG_162 */
        LEFT JOIN Standard.ProfiloProfessionale pp
          ON pp.Codice = NULLIF(LTRIM(RTRIM(mb.professional_code_json)), N'')
         AND pp.DataCancellazione IS NULL
        LEFT JOIN Standard.ProfiloProfessionaleVersione ppv
          ON ppv.ProfiloProfessionaleId = pp.ProfiloProfessionaleId
         AND ppv.VersioneCorrente = 1
         AND ppv.DataCancellazione IS NULL
        WHERE mb.Dominio = 'FPC' OPTION (MAXDOP 8);
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_FPC_SigBase ON ImportSIAC.wrk_FPC_SigBase;

        SELECT fpc.*,
            LAG(fpc.RowSig)  OVER (PARTITION BY fpc.ChiaveBusinessHash ORDER BY fpc.SnapshotDate) AS PrevRowSig,
            LEAD(fpc.SnapshotBusinessTs) OVER (PARTITION BY fpc.ChiaveBusinessHash ORDER BY fpc.SnapshotDate) AS NextBusinessTs,
            MAX(fpc.SnapshotDate) OVER (PARTITION BY fpc.ChiaveBusinessHash) AS MaxSnapshotDate
        INTO ImportSIAC.wrk_FPC_Changes FROM ImportSIAC.wrk_FPC_SigBase fpc OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_FPC_SigBase;

        -- MIG_108: chiave business canonica
        SELECT fc.ChiaveBusinessHash, fc.NumeroCertificato, fc.OrganizzazioneODCId, fc.DataPrimoRilascio,
            fc.TipoQualificaId, fc.Settore, fc.DataEmissioneCorrente,
            fc.Straniero, fc.CodicePersonaODC, fc.SiacId,
            fc.fpc_fiscal_code, fc.first_name, fc.last_name, fc.birth_date, fc.birth_place,
            fc.ProfiloProfessionaleCodice,
            fc.ProfiloProfessionaleVersioneId,
            fc.LivelloDigCompId,
            fc.ProgrammaCertificazioneId,
            fc.SnapshotBusinessTs AS DataInizioValiditaFPC,
            COALESCE(DATEADD(NANOSECOND,-100, LEAD(fc.SnapshotBusinessTs) OVER (PARTITION BY fc.ChiaveBusinessHash ORDER BY fc.SnapshotDate)), CAST('9999-12-31 23:59:59.9999999' AS DATETIME2(7))) AS DataFineValiditaFPC, /* MIG_150: chiusura sulla variazione successiva */
            CASE WHEN LEAD(fc.SnapshotBusinessTs) OVER (PARTITION BY fc.ChiaveBusinessHash ORDER BY fc.SnapshotDate) IS NULL THEN 1 ELSE 0 END AS IsCorrente /* MIG_150 */
        INTO ImportSIAC.wrk_FPC_Final FROM ImportSIAC.wrk_FPC_Changes fc
        WHERE fc.PrevRowSig IS NULL OR fc.PrevRowSig <> fc.RowSig
           -- MIG_150: rimossa la forzatura dell'ultima osservazione
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_FPC_Changes;
        IF EXISTS
        (
            SELECT 1
            FROM ImportSIAC.wrk_FPC_Final
            WHERE ProfiloProfessionaleCodice IS NOT NULL
              AND ProfiloProfessionaleVersioneId IS NULL
        )
            THROW 60747, 'Profilo FPC non mappato nel catalogo Standard.', 1;

        CREATE CLUSTERED INDEX CX_FPC_Final ON ImportSIAC.wrk_FPC_Final (ChiaveBusinessHash, DataInizioValiditaFPC);

        -- ===== Sede (MIG_146a: variazioni effettive + chiusura identita scomparse) =====
        SELECT
            kb.ChiaveBusinessHash,
            pr.NumeroCertificato, pr.OrganizzazioneODCId, pr.DataPrimoRilascio,
            pr.SnapshotDate, pr.SnapshotBusinessTs,
            pr.address, pr.city, pr.zip,
            sm.SedeId,
            pr.AmbitoIta, pr.AmbitoEng, pr.DataScadenzaSede,
            HASHBYTES('SHA2_256', CONCAT(
                ISNULL(CONVERT(VARCHAR(20), sm.SedeId),              'NULL'), '|',
                ISNULL(pr.AmbitoIta,                                 'NULL'), '|',
                ISNULL(pr.AmbitoEng,                                 'NULL'), '|',
                ISNULL(CONVERT(VARCHAR(10), pr.DataScadenzaSede, 23),'NULL')
            )) AS RowSig,
            CASE WHEN sm.SedeId IS NULL THEN CONCAT(pr.address,'|',pr.city,'|',pr.zip) ELSE '' END AS SedeKeyNull,
            /* MIG_163b: impronta della chiave indirizzo. La stringa puo' superare
               i 900 byte ammessi per una chiave clustered (caso peggiore 2057);
               l'impronta ne occupa 32. Raggruppa in modo identico salvo collisioni. */
            HASHBYTES('SHA2_256', CASE WHEN sm.SedeId IS NULL THEN CONCAT(pr.address,'|',pr.city,'|',pr.zip) ELSE '' END) AS SedeKeyNullHash
        INTO ImportSIAC.wrk_Sede_SigBase
        FROM ImportSIAC.wrk_PP_Sedi_Raw pr
        LEFT JOIN ImportSIAC.wrk_SedeMap sm
            ON  sm.OrganizzazioneClienteId = pr.OrganizzazioneClienteId
            AND sm.address = pr.address AND sm.city = pr.city AND sm.zip = pr.zip
        CROSS APPLY ImportSIAC.tvf_ChiaveBusinessCertificazione
        (
            N'PP', pr.NumeroCertificato,
            pr.OrganizzazioneODCId, pr.DataPrimoRilascio,
            NULL, NULL, NULL, NULL, NULL, NULL, NULL
        ) AS kb
        OPTION (MAXDOP 8);

        CREATE CLUSTERED COLUMNSTORE INDEX CCI_Sede_SigBase ON ImportSIAC.wrk_Sede_SigBase;

        -- MIG_163: tre istruzioni al posto di una. Il CCI di wrk_Sede_SigBase
        -- comprime ma non ordina, quindi le quattro finestre con tre schemi di
        -- partizionamento pagavano ciascuna il proprio ordinamento: 48,5 min,
        -- 758 M letture logiche, 215 GB di tempdb (Query Store, run 102).
        -- ISNULL(CONVERT(VARCHAR(20), SedeId), 'NULL') diventa SedeId: in
        -- PARTITION BY i NULL formano una sola partizione, quindi il risultato
        -- e' identico, ma l'espressione calcolata impediva a un indice di
        -- servire il raggruppamento.

        -- A. una sola riga per identita-mese (era il ROW_NUMBER interno)
        DROP TABLE IF EXISTS ImportSIAC.wrk_Sede_MB;
        SELECT s.*
        INTO ImportSIAC.wrk_Sede_MB
        FROM (SELECT s0.*, ROW_NUMBER() OVER (
                  PARTITION BY s0.ChiaveBusinessHash, s0.SedeId, s0.SedeKeyNullHash, s0.SnapshotDate /* MIG_163b */
                  ORDER BY s0.DataScadenzaSede DESC, s0.AmbitoIta DESC, s0.AmbitoEng DESC, s0.address DESC, s0.city DESC, s0.zip DESC) AS rnMB
              FROM ImportSIAC.wrk_Sede_SigBase s0) s
        WHERE s.rnMB = 1 /* MIG_146g: ordinamento deterministico */
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_Sede_SigBase;

        -- B. l'ordine che le finestre chiedono, materializzato una volta sola
        CREATE CLUSTERED INDEX CX_Sede_MB
            ON ImportSIAC.wrk_Sede_MB (ChiaveBusinessHash, SedeId, SedeKeyNullHash, SnapshotDate) /* MIG_163b */
            WITH (SORT_IN_TEMPDB = ON, MAXDOP = 8);

        -- C. il terzo schema di partizionamento: da finestra su 33 milioni di
        -- righe a aggregazione su una riga per certificato
        DROP TABLE IF EXISTS ImportSIAC.wrk_Sede_MaxCert;
        SELECT ChiaveBusinessHash, MAX(SnapshotDate) AS MaxSnapshotDateCert
        INTO ImportSIAC.wrk_Sede_MaxCert
        FROM ImportSIAC.wrk_Sede_MB
        GROUP BY ChiaveBusinessHash
        OPTION (MAXDOP 8);
        CREATE CLUSTERED INDEX CX_Sede_MaxCert
            ON ImportSIAC.wrk_Sede_MaxCert (ChiaveBusinessHash);

        -- D. le finestre, servite dall'ordine dell'indice
        SELECT sg.*,
            LAG(sg.RowSig) OVER (
                PARTITION BY sg.ChiaveBusinessHash, sg.SedeId, sg.SedeKeyNullHash
                ORDER BY sg.SnapshotDate) AS PrevRowSig,
            MAX(sg.SnapshotDate) OVER (
                PARTITION BY sg.ChiaveBusinessHash, sg.SedeId, sg.SedeKeyNullHash
            ) AS MaxSnapshotDate,
            MAX(sg.SnapshotBusinessTs) OVER (
                PARTITION BY sg.ChiaveBusinessHash, sg.SedeId, sg.SedeKeyNullHash
            ) AS LastObsBusinessTs,
            mc.MaxSnapshotDateCert
        INTO ImportSIAC.wrk_Sede_Changes
        FROM ImportSIAC.wrk_Sede_MB sg
        JOIN ImportSIAC.wrk_Sede_MaxCert mc
             ON mc.ChiaveBusinessHash = sg.ChiaveBusinessHash
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_Sede_MB;
        DROP TABLE ImportSIAC.wrk_Sede_MaxCert;

        -- MIG_146a: filtro variazioni PRIMA della chiusura; LEAD sulla variazione
        -- successiva (zero buchi); identita scomparse chiuse a fine ultima
        -- osservazione (mai correnti); chiave indirizzo conservata per 12B.
        SELECT
            f.ChiaveBusinessHash, f.NumeroCertificato, f.OrganizzazioneODCId, f.DataPrimoRilascio,
            f.SedeId, f.address, f.city, f.zip, f.SedeKeyNull,
            f.AmbitoIta, f.AmbitoEng, f.DataScadenzaSede,
            f.SnapshotBusinessTs AS DataInizioValiditaSede,
            COALESCE(
                DATEADD(NANOSECOND,-100,
                    LEAD(f.SnapshotBusinessTs) OVER (
                        PARTITION BY f.ChiaveBusinessHash, ISNULL(CONVERT(VARCHAR(20), f.SedeId), 'NULL'), f.SedeKeyNull
                        ORDER BY f.SnapshotDate)),
                CASE WHEN f.MaxSnapshotDate < f.MaxSnapshotDateCert
                     THEN CASE WHEN f.LastObsBusinessTs > f.SnapshotBusinessTs THEN f.LastObsBusinessTs ELSE DATEADD(NANOSECOND, 100, f.SnapshotBusinessTs) END /* MIG_146f: mai intervalli degeneri */
                     ELSE CAST('9999-12-31 23:59:59.9999999' AS DATETIME2(7)) END
            ) AS DataFineValiditaSede,
            CASE WHEN LEAD(f.SnapshotBusinessTs) OVER (
                        PARTITION BY f.ChiaveBusinessHash, ISNULL(CONVERT(VARCHAR(20), f.SedeId), 'NULL'), f.SedeKeyNull
                        ORDER BY f.SnapshotDate) IS NULL
                 THEN 1 ELSE 0 END AS IsUltimaVersione,
            CASE WHEN LEAD(f.SnapshotBusinessTs) OVER (
                        PARTITION BY f.ChiaveBusinessHash, ISNULL(CONVERT(VARCHAR(20), f.SedeId), 'NULL'), f.SedeKeyNull
                        ORDER BY f.SnapshotDate) IS NULL
                      AND f.MaxSnapshotDate = f.MaxSnapshotDateCert
                 THEN 1 ELSE 0 END AS IsCorrente
        INTO ImportSIAC.wrk_Sede_Final
        FROM ImportSIAC.wrk_Sede_Changes f
        WHERE f.PrevRowSig IS NULL OR f.PrevRowSig <> f.RowSig
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_Sede_Changes;
        CREATE CLUSTERED INDEX CX_Sede_Final
            ON ImportSIAC.wrk_Sede_Final (ChiaveBusinessHash, SedeId, DataInizioValiditaSede);

        -- MIG_117: conserva output 06_DEDUP
        -- MIG_117: conserva input PP sedi
        -- MIG_117: conserva output 05B_SEDE_MAP

        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_SG_Final) + (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_PRD_Final)
                  + (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_FPC_Final) + (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_Sede_Final);
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 08_SCD2_CHILDREN: ', @Rows);

        DECLARE @SedeFinalRows BIGINT = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_Sede_Final);
        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'08_SCD2_CHILDREN', @OutputTable=N'ImportSIAC.wrk_Sede_Final',
            @RowCountAtSave=@SedeFinalRows, @Notes=N'SCD2 figli SG/PRD/FPC/Sede (fix PARTITION BY SedeId).';
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

