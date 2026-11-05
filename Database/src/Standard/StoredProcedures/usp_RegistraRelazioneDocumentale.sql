
CREATE   PROCEDURE Standard.usp_RegistraRelazioneDocumentale
    @RiferimentoOrigineId                 int,
    @RiferimentoDestinazioneId            int,
    @TipoRelazione                        nvarchar(80),
    @DataDecorrenza                       date = NULL,
    @DataCessazioneDestinazione            date = NULL,
    @Note                                 nvarchar(2000) = NULL,
    @OperatoreId                          int = NULL,
    @RiferimentoDocumentaleRelazioneId    int = NULL OUTPUT
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @TranCountIniziale int = @@TRANCOUNT,
        @LockResult int,
        @StatoOrigine nvarchar(60),
        @StatoDestinazione nvarchar(60),
        @DataPubblicazioneDestinazione date,
        @StatoDestinazioneAtteso nvarchar(60),
        @RelazioneEsistente bit = 0,
        @Ciclo bit = 0,
        @Esito nvarchar(20) = N'INVARIATO',
        @Adesso datetime2 = SYSUTCDATETIME();

    SET @TipoRelazione = LTRIM(RTRIM(@TipoRelazione));
    SET @Note = NULLIF(LTRIM(RTRIM(@Note)), N'');

    IF @TipoRelazione NOT IN
       (N'Sostituisce', N'Rinomina', N'Adotta', N'Recepisce',
        N'Consolida', N'Separa', N'Archivia')
        THROW 59120, 'TipoRelazione non ammesso.', 1;

    IF @RiferimentoOrigineId = @RiferimentoDestinazioneId
        THROW 59121, 'Una relazione documentale non puo essere riflessiva.', 1;

    IF @DataCessazioneDestinazione IS NOT NULL
       AND @TipoRelazione NOT IN
           (N'Sostituisce', N'Rinomina', N'Consolida', N'Separa', N'Archivia')
        THROW 59122, 'DataCessazioneDestinazione e ammessa solo per relazioni terminali.', 1;

    IF @TranCountIniziale = 0
        BEGIN TRAN;
    ELSE
        SAVE TRANSACTION MIG91_RifDoc;

    BEGIN TRY
        EXEC @LockResult = sys.sp_getapplock
            @Resource = N'SIDAC:Standard:RiferimentoDocumentaleWorkflow',
            @LockMode = N'Exclusive',
            @LockOwner = N'Transaction',
            @LockTimeout = 10000;

        IF @LockResult < 0
            THROW 59123, 'Impossibile acquisire il lock del workflow documentale.', 1;

        SELECT
            @StatoOrigine = MAX
            (
                CASE WHEN d.RiferimentoDocumentaleId = @RiferimentoOrigineId
                     THEN d.Stato END
            ),
            @StatoDestinazione = MAX
            (
                CASE WHEN d.RiferimentoDocumentaleId = @RiferimentoDestinazioneId
                     THEN d.Stato END
            ),
            @DataPubblicazioneDestinazione = MAX
            (
                CASE WHEN d.RiferimentoDocumentaleId = @RiferimentoDestinazioneId
                     THEN d.DataPubblicazione END
            )
        FROM Standard.RiferimentoDocumentale d WITH (UPDLOCK, HOLDLOCK)
        WHERE d.RiferimentoDocumentaleId IN
              (@RiferimentoOrigineId, @RiferimentoDestinazioneId)
          AND d.DataCancellazione IS NULL;

        IF @StatoOrigine IS NULL
            THROW 59124, 'Documento origine inesistente o cancellato logicamente.', 1;

        IF @StatoDestinazione IS NULL
            THROW 59125, 'Documento destinazione inesistente o cancellato logicamente.', 1;

        IF @DataCessazioneDestinazione IS NOT NULL
           AND @DataPubblicazioneDestinazione IS NOT NULL
           AND @DataCessazioneDestinazione < @DataPubblicazioneDestinazione
            THROW 59126, 'La cessazione non puo precedere la pubblicazione della destinazione.', 1;

        SELECT
            @RiferimentoDocumentaleRelazioneId = r.RiferimentoDocumentaleRelazioneId,
            @RelazioneEsistente = 1
        FROM Standard.RiferimentoDocumentaleRelazione r WITH (UPDLOCK, HOLDLOCK)
        WHERE r.RiferimentoOrigineId = @RiferimentoOrigineId
          AND r.RiferimentoDestinazioneId = @RiferimentoDestinazioneId
          AND r.TipoRelazione = @TipoRelazione
          AND r.DataCancellazione IS NULL;

        IF @RelazioneEsistente = 0 AND @StatoOrigine <> N'Corrente'
            THROW 59127, 'Un nuovo legame deve avere come origine un documento Corrente.', 1;

        IF @TipoRelazione IN
           (N'Sostituisce', N'Rinomina', N'Consolida', N'Separa', N'Archivia')
        BEGIN
            SET @StatoDestinazioneAtteso =
                CASE WHEN @TipoRelazione = N'Archivia'
                     THEN N'Archiviato'
                     ELSE N'Sostituito' END;

            IF @RelazioneEsistente = 0
            BEGIN
                IF @TipoRelazione = N'Separa'
                BEGIN
                    IF @StatoDestinazione NOT IN (N'Corrente', N'Sostituito')
                        THROW 59128, 'Separa richiede una destinazione Corrente o gia Sostituita da Separa.', 1;

                    IF EXISTS
                    (
                        SELECT 1
                        FROM Standard.RiferimentoDocumentaleRelazione r WITH (UPDLOCK, HOLDLOCK)
                        WHERE r.RiferimentoDestinazioneId = @RiferimentoDestinazioneId
                          AND r.TipoRelazione IN
                              (N'Sostituisce', N'Rinomina', N'Consolida', N'Archivia')
                          AND r.DataCancellazione IS NULL
                          AND r.Attivo = 1
                    )
                        THROW 59129, 'Separa e incompatibile con altre relazioni terminali sulla destinazione.', 1;
                END
                ELSE
                BEGIN
                    IF @StatoDestinazione <> N'Corrente'
                        THROW 59130, 'La destinazione di una nuova relazione terminale deve essere Corrente.', 1;

                    IF EXISTS
                    (
                        SELECT 1
                        FROM Standard.RiferimentoDocumentaleRelazione r WITH (UPDLOCK, HOLDLOCK)
                        WHERE r.RiferimentoDestinazioneId = @RiferimentoDestinazioneId
                          AND r.TipoRelazione IN
                              (N'Sostituisce', N'Rinomina', N'Consolida', N'Separa', N'Archivia')
                          AND r.DataCancellazione IS NULL
                          AND r.Attivo = 1
                    )
                        THROW 59131, 'La destinazione possiede gia una relazione terminale attiva.', 1;
                END;
            END;

            IF @TipoRelazione <> N'Archivia'
            BEGIN
                ;WITH Cammino AS
                (
                    SELECT
                        @RiferimentoDestinazioneId AS Nodo,
                        CONVERT(nvarchar(max), N'|' + CONVERT(nvarchar(20), @RiferimentoDestinazioneId) + N'|') AS Percorso

                    UNION ALL

                    SELECT
                        r.RiferimentoDestinazioneId,
                        CONVERT
                        (
                            nvarchar(max),
                            c.Percorso + CONVERT(nvarchar(20), r.RiferimentoDestinazioneId) + N'|'
                        )
                    FROM Cammino c
                    JOIN Standard.RiferimentoDocumentaleRelazione r
                      ON r.RiferimentoOrigineId = c.Nodo
                    WHERE r.TipoRelazione IN
                          (N'Sostituisce', N'Rinomina', N'Consolida', N'Separa')
                      AND r.DataCancellazione IS NULL
                      AND r.Attivo = 1
                      AND CHARINDEX
                          (
                              N'|' + CONVERT(nvarchar(20), r.RiferimentoDestinazioneId) + N'|',
                              c.Percorso
                          ) = 0
                )
                SELECT @Ciclo =
                    CASE WHEN EXISTS
                    (
                        SELECT 1
                        FROM Cammino
                        WHERE Nodo = @RiferimentoOrigineId
                    )
                    THEN 1 ELSE 0 END
                OPTION (MAXRECURSION 32767);

                IF @Ciclo = 1
                    THROW 59132, 'La relazione introdurrebbe un ciclo nella successione documentale.', 1;
            END;
        END;

        IF @RelazioneEsistente = 0
        BEGIN
            INSERT INTO Standard.RiferimentoDocumentaleRelazione
                (RiferimentoOrigineId, RiferimentoDestinazioneId, TipoRelazione,
                 DataDecorrenza, Note, Attivo, CreatoDa)
            VALUES
                (@RiferimentoOrigineId, @RiferimentoDestinazioneId, @TipoRelazione,
                 @DataDecorrenza, @Note, 1, @OperatoreId);

            SET @RiferimentoDocumentaleRelazioneId =
                CONVERT(int, SCOPE_IDENTITY());
            SET @Esito = N'INSERITO';
        END
        ELSE
        BEGIN
            UPDATE r
               SET r.DataDecorrenza = @DataDecorrenza,
                   r.Note = @Note,
                   r.Attivo = 1,
                   r.DataModifica = @Adesso,
                   r.ModificatoDa = @OperatoreId
            FROM Standard.RiferimentoDocumentaleRelazione r
            WHERE r.RiferimentoDocumentaleRelazioneId =
                  @RiferimentoDocumentaleRelazioneId
              AND
              (
                  ISNULL(r.DataDecorrenza, CONVERT(date, '00010101')) <>
                      ISNULL(@DataDecorrenza, CONVERT(date, '00010101'))
               OR ISNULL(r.Note, N'') <> ISNULL(@Note, N'')
               OR r.Attivo <> 1
              );

            IF @@ROWCOUNT > 0
                SET @Esito = N'AGGIORNATO';
        END;

        IF @StatoDestinazioneAtteso IS NOT NULL
        BEGIN
            UPDATE d
               SET d.Stato = @StatoDestinazioneAtteso,
                   d.DataCessazione =
                       COALESCE(@DataCessazioneDestinazione, d.DataCessazione),
                   d.DataModifica = @Adesso,
                   d.ModificatoDa = @OperatoreId
            FROM Standard.RiferimentoDocumentale d
            WHERE d.RiferimentoDocumentaleId = @RiferimentoDestinazioneId
              AND
              (
                  d.Stato <> @StatoDestinazioneAtteso
               OR
                  (
                      @DataCessazioneDestinazione IS NOT NULL
                      AND ISNULL(d.DataCessazione, CONVERT(date, '00010101')) <>
                          @DataCessazioneDestinazione
                  )
              );
        END;

        IF EXISTS (SELECT 1 FROM Standard.vw_ControlloCoerenzaDocumentale)
            THROW 59133, 'Il workflow produrrebbe incoerenze documentali.', 1;

        IF @TranCountIniziale = 0
            COMMIT;

        SELECT
            @Esito AS Esito,
            r.RiferimentoDocumentaleRelazioneId,
            r.RiferimentoOrigineId,
            r.RiferimentoDestinazioneId,
            r.TipoRelazione,
            r.DataDecorrenza,
            d.Stato AS StatoDestinazione,
            d.DataCessazione AS DataCessazioneDestinazione
        FROM Standard.RiferimentoDocumentaleRelazione r
        JOIN Standard.RiferimentoDocumentale d
          ON d.RiferimentoDocumentaleId = r.RiferimentoDestinazioneId
        WHERE r.RiferimentoDocumentaleRelazioneId =
              @RiferimentoDocumentaleRelazioneId;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1
            ROLLBACK;
        ELSE IF XACT_STATE() = 1
        BEGIN
            IF @TranCountIniziale = 0
                ROLLBACK;
            ELSE
                ROLLBACK TRANSACTION MIG91_RifDoc;
        END;

        THROW;
    END CATCH;
END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Workflow canonico e atomico per registrare relazioni documentali e aggiornare lo stato della destinazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'PROCEDURE', @level1name = N'usp_RegistraRelazioneDocumentale';


GO

