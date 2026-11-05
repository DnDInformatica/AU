
CREATE   PROCEDURE ImportSIAC.usp_BH_VerificaIntegritaFinale
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF DB_NAME() <> N'Accredia_SIDAC'
        THROW 60530, 'Il gate ImportSIAC deve essere eseguito su Accredia_SIDAC.', 1;

    DECLARE @ProblemiFK nvarchar(2048);

    SELECT @ProblemiFK =
        STRING_AGG
        (
            CONVERT
            (
                nvarchar(max),
                CONCAT
                (
                    QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)),
                    N'.',
                    QUOTENAME(OBJECT_NAME(fk.parent_object_id)),
                    N'/',
                    QUOTENAME(fk.name),
                    N' disabled=',
                    fk.is_disabled,
                    N' not_trusted=',
                    fk.is_not_trusted
                )
            ),
            N'; '
        )
    FROM sys.foreign_keys AS fk
    WHERE fk.referenced_object_id =
          OBJECT_ID(N'Certificazione.Certificazione')
      AND
      (
          fk.is_disabled = 1
          OR fk.is_not_trusted = 1
      );

    IF @ProblemiFK IS NOT NULL
    BEGIN
        SET @ProblemiFK =
            LEFT(N'Gate ImportSIAC: FK non conformi: ' + @ProblemiFK, 2048);
        THROW 60531, @ProblemiFK, 1;
    END;

    DECLARE @TabelleTemporal TABLE
    (
        TableName sysname NOT NULL PRIMARY KEY
    );

    INSERT @TabelleTemporal (TableName)
    VALUES
        (N'Certificazione'),
        (N'CertificazioneSG'),
        (N'CertificazionePRD'),
        (N'CertificazioneFPC'),
        (N'CertificazioneSede');

    DECLARE @ProblemiTemporal nvarchar(2048);

    SELECT @ProblemiTemporal =
        STRING_AGG
        (
            CONVERT(nvarchar(max), QUOTENAME(e.TableName)),
            N'; '
        )
    FROM @TabelleTemporal AS e
    LEFT JOIN sys.tables AS t
      ON t.schema_id = SCHEMA_ID(N'Certificazione')
     AND t.name = e.TableName
     AND t.temporal_type = 2
    WHERE t.object_id IS NULL;

    IF @ProblemiTemporal IS NOT NULL
    BEGIN
        SET @ProblemiTemporal =
            LEFT
            (
                N'Gate ImportSIAC: tabelle assenti o non system-versioned: '
                + @ProblemiTemporal,
                2048
            );
        THROW 60532, @ProblemiTemporal, 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.CertificazionePRD AS d
        LEFT JOIN Certificazione.Certificazione AS c
          ON c.CertificazioneId = d.CertificazioneId
        WHERE c.CertificazioneId IS NULL
    )
        THROW 60533, 'Gate ImportSIAC: orfani in CertificazionePRD.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.CertificazioneFPC AS d
        LEFT JOIN Certificazione.Certificazione AS c
          ON c.CertificazioneId = d.CertificazioneId
        WHERE c.CertificazioneId IS NULL
    )
        THROW 60534, 'Gate ImportSIAC: orfani in CertificazioneFPC.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.CertificazioneSede AS d
        LEFT JOIN Certificazione.Certificazione AS c
          ON c.CertificazioneId = d.CertificazioneId
        WHERE c.CertificazioneId IS NULL
    )
        THROW 60535, 'Gate ImportSIAC: orfani in CertificazioneSede.', 1;


    -- MIG_107: gate profili PRD/FPC
    IF OBJECTPROPERTYEX
       (
           OBJECT_ID
           (
               N'Certificazione.CertificazionePRDProfiloTecnico'
           ),
           N'TableTemporalType'
       ) <> 2
        THROW 60760, 'Gate ImportSIAC: bridge profili PRD non temporal.', 1;

    IF OBJECTPROPERTYEX
       (
           OBJECT_ID(N'Standard.ProfiloTecnicoProgramma'),
           N'TableTemporalType'
       ) <> 2
        THROW 60761, 'Gate ImportSIAC: catalogo profili PRD non temporal.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id IN
              (
                  OBJECT_ID
                  (
                      N'Certificazione.CertificazionePRDProfiloTecnico'
                  ),
                  OBJECT_ID(N'Standard.ProfiloTecnicoProgramma')
              )
          AND
              (
                  fk.is_disabled = 1
                  OR fk.is_not_trusted = 1
              )
    )
        THROW 60762, 'Gate ImportSIAC: FK profili PRD disabilitate o non trusted.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.CertificazioneFPC AS f
        WHERE f.ProfiloProfessionaleVersioneId IS NULL
    )
        THROW 60763, 'Gate ImportSIAC: certificati FPC senza profilo canonico.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.CertificazionePRD AS prd
        JOIN Certificazione.Certificazione AS c
          ON c.CertificazioneId = prd.CertificazioneId
        JOIN Standard.NormaAccreditamento AS na
          ON na.NormaAccreditamentoId = c.NormaAccreditamentoId
         AND na.Riferimento IN (N'SP11', N'SP12', N'SP13')
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM Certificazione.CertificazionePRDProfiloTecnico AS a
            WHERE a.CertificazionePRDId =
                  prd.CertificazionePRDId
              AND a.DataFineApplicabilita IS NULL
              AND a.DataCancellazione IS NULL
        )
    )
        THROW 60765, 'Gate ImportSIAC: certificato PRD speciale senza profilo corrente.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.CertificazionePRDProfiloTecnico AS a
        JOIN Certificazione.CertificazionePRD AS prd
          ON prd.CertificazionePRDId = a.CertificazionePRDId
        JOIN Certificazione.Certificazione AS c
          ON c.CertificazioneId = prd.CertificazioneId
        JOIN Standard.NormaAccreditamento AS na
          ON na.NormaAccreditamentoId = c.NormaAccreditamentoId
        JOIN Standard.ProfiloTecnicoProgramma AS pt
          ON pt.ProfiloTecnicoProgrammaId =
             a.ProfiloTecnicoProgrammaId
        JOIN Certificazione.ProgrammaCertificazioneVersione AS pv
          ON pv.ProgrammaCertificazioneVersioneId =
             pt.ProgrammaCertificazioneVersioneId
        JOIN Certificazione.ProgrammaCertificazione AS p
          ON p.ProgrammaCertificazioneId =
             pv.ProgrammaCertificazioneId
        -- MIG_120: gate PRD solo intervalli applicativi correnti
        WHERE a.DataFineApplicabilita IS NULL
          AND p.Codice <> na.Riferimento
    )
        THROW 60766, 'Gate ImportSIAC: profilo PRD associato al programma errato.', 1;



    -- MIG_110: hash obbligatorio
    IF EXISTS
    (
        SELECT 1
        FROM sys.columns
        WHERE object_id =
              OBJECT_ID(N'Certificazione.Certificazione')
          AND name = N'ChiaveBusinessHash'
          AND is_nullable = 1
    )
        THROW 61070, 'Gate ImportSIAC: business key nullable.', 1;

    -- MIG_109: profili legacy rimossi
    -- MIG_108: chiave business canonica
    IF COL_LENGTH
       (
           N'Certificazione.Certificazione',
           N'ChiaveBusinessHash'
       ) IS NULL
        THROW 60870, 'Gate ImportSIAC: ChiaveBusinessHash assente.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.Certificazione
        WHERE ChiaveBusinessHash IS NULL
    )
        THROW 60871, 'Gate ImportSIAC: certificazioni senza business key.', 1;

    IF EXISTS
    (
        SELECT ChiaveBusinessHash
        FROM Certificazione.Certificazione
        GROUP BY ChiaveBusinessHash
        HAVING COUNT_BIG(*) > 1
    )
        THROW 60872, 'Gate ImportSIAC: business key duplicate.', 1;

    -- MIG_124: nessuna testata per scarti FPC senza persona
    IF OBJECT_ID(N'ImportSIAC.wrk_FPC_PersonaMap', N'U') IS NULL
        THROW 62420, 'Gate ImportSIAC: PersonaMap FPC assente.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM ImportSIAC.wrk_All_Final AS src
        JOIN Certificazione.Certificazione AS c
          ON c.ChiaveBusinessHash = src.ChiaveBusinessHash
        LEFT JOIN ImportSIAC.wrk_FPC_PersonaMap AS pm
          ON pm.ChiaveBusinessHash = src.ChiaveBusinessHash
        WHERE src.IsCorrente = 1
          AND src.Dominio = N'FPC'
          AND pm.ChiaveBusinessHash IS NULL
    )
        THROW 62421, 'Gate ImportSIAC: testata materializzata per scarto FPC senza persona.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.Certificazione AS c
        JOIN Certificazione.TipoCertificazione AS tc
          ON tc.TipoCertificazioneId = c.TipoCertificazioneId
         AND tc.Codice = N'FPC'
        LEFT JOIN Certificazione.CertificazioneFPC AS f
          ON f.CertificazioneId = c.CertificazioneId
        WHERE f.CertificazioneFPCId IS NULL
    )
        THROW 60873, 'Gate ImportSIAC: testata FPC senza dettaglio.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.CertificazioneFPC AS f
        JOIN Certificazione.Certificazione AS c
          ON c.CertificazioneId = f.CertificazioneId
        JOIN Certificazione.TipoCertificazione AS tc
          ON tc.TipoCertificazioneId = c.TipoCertificazioneId
        WHERE tc.Codice <> N'FPC'
    )
        THROW 60874, 'Gate ImportSIAC: dettaglio FPC su testata non FPC.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Certificazione.Certificazione AS c
        JOIN Certificazione.TipoCertificazione AS tc
          ON tc.TipoCertificazioneId = c.TipoCertificazioneId
         AND tc.Codice = N'PRD'
        LEFT JOIN Certificazione.CertificazionePRD AS p
          ON p.CertificazioneId = c.CertificazioneId
        WHERE p.CertificazionePRDId IS NULL
    )
        THROW 60875, 'Gate ImportSIAC: testata PRD senza dettaglio.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys
        WHERE parent_object_id =
              OBJECT_ID(N'Certificazione.CertificazioneFPC')
          AND name =
              N'FK_CertificazioneFPC_ProfiloProfessionaleVersione'
          AND is_disabled = 0
          AND is_not_trusted = 0
    )
        THROW 60876, 'Gate ImportSIAC: FK profilo FPC assente o non trusted.', 1;

END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gate conclusivo del processo ImportSIAC: verifica che le FK verso Certificazione.Certificazione siano abilitate e trusted, che le cinque tabelle certificative restino temporal e che PRD, FPC e Sede non contengano orfani.', @level0type = N'SCHEMA', @level0name = N'ImportSIAC', @level1type = N'PROCEDURE', @level1name = N'usp_BH_VerificaIntegritaFinale';


GO

