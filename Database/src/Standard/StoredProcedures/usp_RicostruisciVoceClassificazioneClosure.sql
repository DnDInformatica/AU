
CREATE   PROCEDURE Standard.usp_RicostruisciVoceClassificazioneClosure
    @ClassificazioneVersioneId int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @OwnTransaction bit = 0,
        @ClassificazioneId int,
        @Inserted int = 1,
        @Iteration int = 0,
        @NumeroVoci int,
        @DataCalcolo datetime2 = SYSUTCDATETIME();

    IF @@TRANCOUNT = 0
    BEGIN
        BEGIN TRAN;
        SET @OwnTransaction = 1;
    END
    ELSE
        SAVE TRAN ClosureClassificazioneSave;

    BEGIN TRY
        SELECT @ClassificazioneId = v.ClassificazioneId
        FROM Standard.ClassificazioneVersione v WITH (UPDLOCK, HOLDLOCK)
        WHERE v.ClassificazioneVersioneId = @ClassificazioneVersioneId
          AND v.DataCancellazione IS NULL;

        IF @ClassificazioneId IS NULL
            THROW 59640, 'Versione di classificazione non trovata o cancellata.', 1;

        IF NOT EXISTS
        (
            SELECT 1
            FROM Standard.ClassificazioneGovernance g WITH (UPDLOCK, HOLDLOCK)
            WHERE g.ClassificazioneId = @ClassificazioneId
              AND g.ConsenteGerarchia = 1
              AND g.ConsentePiuPadri IS NOT NULL
              AND g.Attivo = 1
              AND g.DataCancellazione IS NULL
        )
            THROW 59641, 'Governance gerarchica attiva non trovata.', 1;

        IF EXISTS
        (
            SELECT 1
            FROM Standard.VoceClassificazioneGerarchia e
            LEFT JOIN Standard.VoceClassificazione p
              ON p.VoceClassificazioneId = e.VocePadreId
             AND p.ClassificazioneVersioneId = e.ClassificazioneVersioneId
             AND p.ClassificazioneId = e.ClassificazioneId
             AND p.Attivo = 1
             AND p.DataCancellazione IS NULL
            LEFT JOIN Standard.VoceClassificazione f
              ON f.VoceClassificazioneId = e.VoceFiglioId
             AND f.ClassificazioneVersioneId = e.ClassificazioneVersioneId
             AND f.ClassificazioneId = e.ClassificazioneId
             AND f.Attivo = 1
             AND f.DataCancellazione IS NULL
            WHERE e.ClassificazioneVersioneId = @ClassificazioneVersioneId
              AND e.Attivo = 1
              AND e.DataCancellazione IS NULL
              AND (p.VoceClassificazioneId IS NULL OR f.VoceClassificazioneId IS NULL)
        )
            THROW 59642, 'La gerarchia contiene un estremo non attivo.', 1;

        SELECT @NumeroVoci = COUNT(*)
        FROM Standard.VoceClassificazione WITH (UPDLOCK, HOLDLOCK)
        WHERE ClassificazioneVersioneId = @ClassificazioneVersioneId
          AND ClassificazioneId = @ClassificazioneId
          AND Attivo = 1
          AND DataCancellazione IS NULL;

        CREATE TABLE #Reach
        (
            VoceAntenatoId int NOT NULL,
            VoceDiscendenteId int NOT NULL,
            Profondita int NOT NULL,
            PRIMARY KEY (VoceAntenatoId, VoceDiscendenteId)
        );

        INSERT INTO #Reach
        (
            VoceAntenatoId,
            VoceDiscendenteId,
            Profondita
        )
        SELECT
            e.VocePadreId,
            e.VoceFiglioId,
            1
        FROM Standard.VoceClassificazioneGerarchia e WITH (UPDLOCK, HOLDLOCK)
        WHERE e.ClassificazioneVersioneId = @ClassificazioneVersioneId
          AND e.ClassificazioneId = @ClassificazioneId
          AND e.Attivo = 1
          AND e.DataCancellazione IS NULL;

        WHILE @Inserted > 0
        BEGIN
            SET @Iteration += 1;

            IF @Iteration > @NumeroVoci
                THROW 59643, 'Espansione della closure oltre il numero di voci: possibile ciclo.', 1;

            IF EXISTS
            (
                SELECT 1
                FROM #Reach r
                JOIN Standard.VoceClassificazioneGerarchia e
                  ON e.ClassificazioneVersioneId = @ClassificazioneVersioneId
                 AND e.ClassificazioneId = @ClassificazioneId
                 AND e.VocePadreId = r.VoceDiscendenteId
                 AND e.VoceFiglioId = r.VoceAntenatoId
                 AND e.Attivo = 1
                 AND e.DataCancellazione IS NULL
            )
                THROW 59644, 'Ciclo rilevato nella gerarchia della classificazione.', 1;

            ;WITH Candidate AS
            (
                SELECT
                    r.VoceAntenatoId,
                    e.VoceFiglioId AS VoceDiscendenteId,
                    MIN(r.Profondita + 1) AS Profondita
                FROM #Reach r
                JOIN Standard.VoceClassificazioneGerarchia e
                  ON e.ClassificazioneVersioneId = @ClassificazioneVersioneId
                 AND e.ClassificazioneId = @ClassificazioneId
                 AND e.VocePadreId = r.VoceDiscendenteId
                 AND e.Attivo = 1
                 AND e.DataCancellazione IS NULL
                WHERE r.VoceAntenatoId <> e.VoceFiglioId
                GROUP BY
                    r.VoceAntenatoId,
                    e.VoceFiglioId
            )
            INSERT INTO #Reach
            (
                VoceAntenatoId,
                VoceDiscendenteId,
                Profondita
            )
            SELECT
                c.VoceAntenatoId,
                c.VoceDiscendenteId,
                c.Profondita
            FROM Candidate c
            WHERE NOT EXISTS
            (
                SELECT 1
                FROM #Reach x
                WHERE x.VoceAntenatoId = c.VoceAntenatoId
                  AND x.VoceDiscendenteId = c.VoceDiscendenteId
            );

            SET @Inserted = @@ROWCOUNT;
        END;

        DELETE FROM Standard.VoceClassificazioneClosure
        WHERE ClassificazioneVersioneId = @ClassificazioneVersioneId;

        INSERT INTO Standard.VoceClassificazioneClosure
        (
            ClassificazioneVersioneId,
            ClassificazioneId,
            VoceAntenatoId,
            VoceDiscendenteId,
            Profondita,
            DataCalcolo
        )
        SELECT
            @ClassificazioneVersioneId,
            @ClassificazioneId,
            v.VoceClassificazioneId,
            v.VoceClassificazioneId,
            0,
            @DataCalcolo
        FROM Standard.VoceClassificazione v
        WHERE v.ClassificazioneVersioneId = @ClassificazioneVersioneId
          AND v.ClassificazioneId = @ClassificazioneId
          AND v.Attivo = 1
          AND v.DataCancellazione IS NULL;

        INSERT INTO Standard.VoceClassificazioneClosure
        (
            ClassificazioneVersioneId,
            ClassificazioneId,
            VoceAntenatoId,
            VoceDiscendenteId,
            Profondita,
            DataCalcolo
        )
        SELECT
            @ClassificazioneVersioneId,
            @ClassificazioneId,
            r.VoceAntenatoId,
            r.VoceDiscendenteId,
            r.Profondita,
            @DataCalcolo
        FROM #Reach r;

        IF @OwnTransaction = 1
            COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = 1
        BEGIN
            IF @OwnTransaction = 1
                ROLLBACK;
            ELSE
                ROLLBACK TRAN ClosureClassificazioneSave;
        END
        ELSE IF XACT_STATE() = -1 AND @OwnTransaction = 1
            ROLLBACK;

        THROW;
    END CATCH;
END;

GO

