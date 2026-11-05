-- ================================================================================
-- ImportSIAC.usp_BH_09_Persone
-- Estratto dal monolite (step 09_PERSONE). Deduplica e fa upsert delle persone
-- FPC in Persone.Persona (match su CF, poi natural key), produce wrk_FPC_PersonaMap
-- (NumeroCertificato -> PersonaId) usato dal rebuild FPC (step 13).
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_09_Persone
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT,
    @PersoneInserite INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;
    SET @PersoneInserite = 0;

    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'09_PERSONE', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_FPC_PersonaMap);
        SET @RowsAffected = @Rows;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,9,N'09_PERSONE',N'Upsert Persone (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: wrk_FPC_PersonaMap gia valida.');
        PRINT CONCAT('STEP 09_PERSONE: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,9,N'09_PERSONE',N'Upsert Persone',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaMap;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaByFiscalCode;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaByNaturalKey;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaUnresolved;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_RawUltimo;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaDistinct;

        -- MIG_124: recupero persone deterministiche e partizione CF/NK
        ;WITH DataNascitaUnivocaPerCF AS
        (
            SELECT fpc_fiscal_code,
                   MIN(birth_date) AS DataNascitaUnica
            FROM ImportSIAC.wrk_FPC_Final
            WHERE LEN(fpc_fiscal_code) = 16
              AND birth_date IS NOT NULL
            GROUP BY fpc_fiscal_code
            HAVING COUNT_BIG(DISTINCT birth_date) = 1
        )
        SELECT DISTINCT
            CASE WHEN LEN(fpc.fpc_fiscal_code) = 16 THEN fpc.fpc_fiscal_code ELSE NULL END AS fpc_fiscal_code,
            fpc.last_name AS Cognome, fpc.first_name AS Nome,
            COALESCE(fpc.birth_date, dob.DataNascitaUnica) AS DataNascita,
            fpc.birth_place AS LuogoNascita,
            CONVERT(BINARY(32), HASHBYTES('SHA2_256', CONCAT(
                ISNULL(fpc.last_name, N''), N'|',
                ISNULL(fpc.first_name, N''), N'|',
                ISNULL(CONVERT(NVARCHAR(30), COALESCE(fpc.birth_date, dob.DataNascitaUnica), 126), N'')
            ))) AS PersonaNaturalKey,
            CAST(NULL AS INT) AS PersonaId
        INTO ImportSIAC.wrk_FPC_PersonaDistinct
        FROM ImportSIAC.wrk_FPC_Final AS fpc
        LEFT JOIN DataNascitaUnivocaPerCF AS dob
          ON dob.fpc_fiscal_code = fpc.fpc_fiscal_code
        WHERE fpc.IsCorrente = 1;

        CREATE NONCLUSTERED INDEX IX_FPC_PersonaDistinct_CF
            ON ImportSIAC.wrk_FPC_PersonaDistinct (fpc_fiscal_code)
            WHERE fpc_fiscal_code IS NOT NULL;

        CREATE NONCLUSTERED INDEX IX_FPC_PersonaDistinct_NaturalKey
            ON ImportSIAC.wrk_FPC_PersonaDistinct (PersonaNaturalKey, DataNascita)
            WHERE fpc_fiscal_code IS NULL;

        UPDATE pd SET pd.PersonaId = p.PersonaId
        FROM ImportSIAC.wrk_FPC_PersonaDistinct pd
        JOIN Persone.Persona p ON p.CodiceFiscale = pd.fpc_fiscal_code
        WHERE pd.fpc_fiscal_code IS NOT NULL;

        UPDATE pd SET pd.PersonaId = (
            SELECT TOP 1 p.PersonaId FROM Persone.Persona p
            WHERE p.Cognome = pd.Cognome AND p.Nome = pd.Nome AND p.DataNascita = pd.DataNascita
              AND p.DataCancellazione IS NULL ORDER BY p.PersonaId)
        FROM ImportSIAC.wrk_FPC_PersonaDistinct pd WHERE pd.PersonaId IS NULL;

        ;WITH PersoneDaInserire AS (
            SELECT pd.Cognome, pd.Nome, pd.DataNascita, pd.LuogoNascita, pd.fpc_fiscal_code,
                ROW_NUMBER() OVER (
                    PARTITION BY
                        CASE
                            WHEN pd.fpc_fiscal_code IS NOT NULL
                            THEN CONVERT
                                 (
                                     BINARY(32),
                                     HASHBYTES
                                     (
                                         'SHA2_256',
                                         CONCAT(N'CF|', pd.fpc_fiscal_code)
                                     )
                                 )
                            ELSE pd.PersonaNaturalKey
                        END
                    ORDER BY CASE WHEN pd.DataNascita IS NOT NULL THEN 0 ELSE 1 END,
                             pd.Cognome, pd.Nome
                ) AS Rn
            FROM ImportSIAC.wrk_FPC_PersonaDistinct pd
            WHERE pd.PersonaId IS NULL
              AND pd.Cognome IS NOT NULL AND pd.Nome IS NOT NULL AND pd.DataNascita IS NOT NULL
              AND (pd.fpc_fiscal_code IS NULL
                   OR NOT EXISTS (
                       SELECT 1 FROM Persone.Persona pe WHERE pe.CodiceFiscale = pd.fpc_fiscal_code
                   ))
        )
        INSERT INTO Persone.Persona (Cognome, Nome, DataNascita, LuogoNascita, CodiceFiscale, ConsensoPrivacy)
        SELECT Cognome, Nome, DataNascita, LuogoNascita, fpc_fiscal_code, 0
        FROM PersoneDaInserire
        WHERE Rn = 1;
        SET @PersoneInserite = @@ROWCOUNT;

        UPDATE pd SET pd.PersonaId = p.PersonaId
        FROM ImportSIAC.wrk_FPC_PersonaDistinct pd
        JOIN Persone.Persona p ON p.Cognome = pd.Cognome AND p.Nome = pd.Nome
            AND p.DataNascita = pd.DataNascita AND p.DataCancellazione IS NULL
        WHERE pd.PersonaId IS NULL;

        SELECT pd.fpc_fiscal_code, MIN(pd.PersonaId) AS PersonaId
        INTO ImportSIAC.wrk_FPC_PersonaByFiscalCode
        FROM ImportSIAC.wrk_FPC_PersonaDistinct pd
        WHERE pd.fpc_fiscal_code IS NOT NULL
          AND pd.PersonaId IS NOT NULL
        GROUP BY pd.fpc_fiscal_code;

        CREATE UNIQUE CLUSTERED INDEX CX_FPC_PersonaByFiscalCode
            ON ImportSIAC.wrk_FPC_PersonaByFiscalCode (fpc_fiscal_code);

        SELECT
            pd.PersonaNaturalKey,
            pd.DataNascita,
            pd.Cognome,
            pd.Nome,
            MIN(pd.PersonaId) AS PersonaId
        INTO ImportSIAC.wrk_FPC_PersonaByNaturalKey
        FROM ImportSIAC.wrk_FPC_PersonaDistinct pd
        WHERE pd.fpc_fiscal_code IS NULL
          AND pd.PersonaId IS NOT NULL
          AND pd.Cognome IS NOT NULL
          AND pd.Nome IS NOT NULL
          AND pd.DataNascita IS NOT NULL
        GROUP BY pd.PersonaNaturalKey, pd.DataNascita, pd.Cognome, pd.Nome;

        CREATE CLUSTERED INDEX CX_FPC_PersonaByNaturalKey
            ON ImportSIAC.wrk_FPC_PersonaByNaturalKey (PersonaNaturalKey, DataNascita);

        -- MIG_108: chiave business canonica
        SELECT TOP (0)
            fpc.ChiaveBusinessHash,
            fpc.NumeroCertificato,
            fpc.OrganizzazioneODCId,
            fpc.DataPrimoRilascio,
            CAST(NULL AS INT) AS PersonaId
        INTO ImportSIAC.wrk_FPC_PersonaMap
        FROM ImportSIAC.wrk_FPC_Final fpc;

        INSERT INTO ImportSIAC.wrk_FPC_PersonaMap
            (ChiaveBusinessHash, NumeroCertificato, OrganizzazioneODCId, DataPrimoRilascio, PersonaId)
        SELECT DISTINCT
            fpc.ChiaveBusinessHash,
            fpc.NumeroCertificato,
            fpc.OrganizzazioneODCId,
            fpc.DataPrimoRilascio,
            cf.PersonaId
        FROM ImportSIAC.wrk_FPC_Final fpc
        JOIN ImportSIAC.wrk_FPC_PersonaByFiscalCode cf
            ON cf.fpc_fiscal_code = fpc.fpc_fiscal_code
        -- MIG_113: PersonaMap dalla versione corrente della business key FPC
        WHERE fpc.IsCorrente = 1
          AND LEN(fpc.fpc_fiscal_code) = 16
        OPTION (HASH JOIN, MAXDOP 4);

        INSERT INTO ImportSIAC.wrk_FPC_PersonaMap
            (ChiaveBusinessHash, NumeroCertificato, OrganizzazioneODCId, DataPrimoRilascio, PersonaId)
        SELECT DISTINCT
            fpc.ChiaveBusinessHash,
            fpc.NumeroCertificato,
            fpc.OrganizzazioneODCId,
            fpc.DataPrimoRilascio,
            nk.PersonaId
        FROM ImportSIAC.wrk_FPC_Final fpc
        JOIN ImportSIAC.wrk_FPC_PersonaByNaturalKey nk
            ON nk.PersonaNaturalKey = CONVERT(BINARY(32), HASHBYTES('SHA2_256', CONCAT(
                    ISNULL(fpc.last_name, N''), N'|',
                    ISNULL(fpc.first_name, N''), N'|',
                    ISNULL(CONVERT(NVARCHAR(30), fpc.birth_date, 126), N'')
                )))
           AND nk.DataNascita = fpc.birth_date
           AND nk.Cognome = fpc.last_name
           AND nk.Nome = fpc.first_name
        WHERE fpc.IsCorrente = 1
          AND
          (
              fpc.fpc_fiscal_code IS NULL
              OR LEN(fpc.fpc_fiscal_code) <> 16
          )
        OPTION (HASH JOIN, MAXDOP 4);

        DROP TABLE ImportSIAC.wrk_FPC_PersonaDistinct;
        DROP TABLE ImportSIAC.wrk_FPC_PersonaByFiscalCode;
        DROP TABLE ImportSIAC.wrk_FPC_PersonaByNaturalKey;
        -- MIG_113: gate di granularita PersonaMap
        IF EXISTS
        (
            SELECT 1
            FROM ImportSIAC.wrk_FPC_PersonaMap
            WHERE ChiaveBusinessHash IS NULL
               OR PersonaId IS NULL
        )
            THROW 51309, 'PersonaMap FPC contiene hash o PersonaId null.', 1;

        IF EXISTS
        (
            SELECT 1
            FROM ImportSIAC.wrk_FPC_PersonaMap
            GROUP BY ChiaveBusinessHash
            HAVING COUNT_BIG(*) > 1
        )
            THROW 51310, 'PersonaMap FPC non univoca per business key corrente.', 1;

        CREATE UNIQUE CLUSTERED INDEX CX_FPC_PersonaMap ON ImportSIAC.wrk_FPC_PersonaMap (ChiaveBusinessHash);

        SELECT DISTINCT
            fpc.ChiaveBusinessHash,
            fpc.NumeroCertificato,
            fpc.OrganizzazioneODCId,
            fpc.DataPrimoRilascio
        INTO ImportSIAC.wrk_FPC_PersonaUnresolved
        FROM ImportSIAC.wrk_FPC_Final fpc
        LEFT JOIN ImportSIAC.wrk_FPC_PersonaMap pm
            ON pm.ChiaveBusinessHash = fpc.ChiaveBusinessHash
        WHERE fpc.IsCorrente = 1
          AND (pm.PersonaId IS NULL OR pm.NumeroCertificato IS NULL);

        CREATE UNIQUE CLUSTERED INDEX CX_FPC_PersonaUnresolved
            ON ImportSIAC.wrk_FPC_PersonaUnresolved (ChiaveBusinessHash);

        CREATE NONCLUSTERED INDEX IX_FPC_PersonaUnresolved_Numero
            ON ImportSIAC.wrk_FPC_PersonaUnresolved (NumeroCertificato);

        ;WITH NumeriNonRisolti AS (
            SELECT DISTINCT NumeroCertificato
            FROM ImportSIAC.wrk_FPC_PersonaUnresolved
            WHERE NumeroCertificato IS NOT NULL
        ),
        RawRanked AS (
            SELECT
                src.NumeroCertificato,
                src.RawId,
                src.SnapshotYear,
                src.SnapshotMonth,
                src.codente,
                ROW_NUMBER() OVER (
                    PARTITION BY src.NumeroCertificato
                    ORDER BY src.SnapshotYear DESC, src.SnapshotMonth DESC, src.RawId DESC
                ) AS Rn
            FROM ImportSIAC.wrk_All_Src src
            JOIN NumeriNonRisolti nr
                ON nr.NumeroCertificato = src.NumeroCertificato
            WHERE src.Dominio = 'FPC'
        )
        SELECT
            NumeroCertificato,
            RawId,
            SnapshotYear,
            SnapshotMonth,
            codente
        INTO ImportSIAC.wrk_FPC_RawUltimo
        FROM RawRanked
        WHERE Rn = 1
        OPTION (HASH JOIN, MAXDOP 4);

        CREATE UNIQUE CLUSTERED INDEX CX_FPC_RawUltimo
            ON ImportSIAC.wrk_FPC_RawUltimo (NumeroCertificato);

        INSERT INTO ImportSIAC.BuildHistory_SkippedRow
            (BuildHistoryLogId, Dominio, RawId, SnapshotYear, SnapshotMonth, Codente, NumeroCertificato, MotivoScarto)
        SELECT
            @BuildHistoryLogId,
            'FPC',
            ru.RawId,
            ru.SnapshotYear,
            ru.SnapshotMonth,
            ru.codente,
            u.NumeroCertificato,
            'PERSONA_NON_RISOLVIBILE'
        FROM ImportSIAC.wrk_FPC_PersonaUnresolved u
        JOIN ImportSIAC.wrk_FPC_RawUltimo ru
            ON ru.NumeroCertificato = u.NumeroCertificato
        OPTION (HASH JOIN, MAXDOP 4);

        DROP TABLE ImportSIAC.wrk_FPC_PersonaUnresolved;
        DROP TABLE ImportSIAC.wrk_FPC_RawUltimo;

        SET @Rows = @PersoneInserite;
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 09_PERSONE: ', @Rows);

        DECLARE @MapRows BIGINT = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_FPC_PersonaMap);
        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'09_PERSONE', @OutputTable=N'ImportSIAC.wrk_FPC_PersonaMap',
            @RowCountAtSave=@MapRows, @Notes=N'Upsert persone + mappa NumeroCertificato->PersonaId.';
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

