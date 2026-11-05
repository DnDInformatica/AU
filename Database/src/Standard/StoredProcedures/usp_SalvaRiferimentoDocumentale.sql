
CREATE   PROCEDURE Standard.usp_SalvaRiferimentoDocumentale
    @RiferimentoDocumentaleId int = NULL OUTPUT,
    @SoggettoFonteId          int,
    @TipoRiferimento          nvarchar(80),
    @CodiceDocumento          nvarchar(200),
    @Edizione                 nvarchar(100) = NULL,
    @Titolo                   nvarchar(2000) = NULL,
    @DataPubblicazione        date = NULL,
    @UrlUfficiale             nvarchar(2000) = NULL,
    @RepositoryFonte          nvarchar(200) = NULL,
    @Attivo                   bit = 1,
    @OperatoreId              int = NULL
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @TranCountIniziale int = @@TRANCOUNT,
        @LockResult int,
        @Esito nvarchar(20) = N'INVARIATO',
        @Adesso datetime2 = SYSUTCDATETIME();

    SET @TipoRiferimento = LTRIM(RTRIM(@TipoRiferimento));
    SET @CodiceDocumento = LTRIM(RTRIM(@CodiceDocumento));
    SET @Edizione = NULLIF(LTRIM(RTRIM(@Edizione)), N'');
    SET @Titolo = NULLIF(LTRIM(RTRIM(@Titolo)), N'');
    SET @UrlUfficiale = NULLIF(LTRIM(RTRIM(@UrlUfficiale)), N'');
    SET @RepositoryFonte = NULLIF(LTRIM(RTRIM(@RepositoryFonte)), N'');

    IF @TipoRiferimento NOT IN
       (N'Regolamento', N'Direttiva', N'Decisione', N'Norma',
        N'DocumentoAccreditamento', N'DocumentoSchema', N'Delibera',
        N'ElencoOperativo', N'LineaGuida', N'Altro')
        THROW 59150, 'TipoRiferimento non ammesso.', 1;

    IF NULLIF(@CodiceDocumento, N'') IS NULL
        THROW 59151, 'CodiceDocumento obbligatorio.', 1;

    IF @TranCountIniziale = 0
        BEGIN TRAN;
    ELSE
        SAVE TRANSACTION MIG91_SalvaDoc;

    BEGIN TRY
        EXEC @LockResult = sys.sp_getapplock
            @Resource = N'SIDAC:Standard:RiferimentoDocumentaleWorkflow',
            @LockMode = N'Exclusive',
            @LockOwner = N'Transaction',
            @LockTimeout = 10000;

        IF @LockResult < 0
            THROW 59152, 'Impossibile acquisire il lock del catalogo documentale.', 1;

        IF NOT EXISTS
        (
            SELECT 1
            FROM Standard.SoggettoFonte s WITH (UPDLOCK, HOLDLOCK)
            WHERE s.SoggettoFonteId = @SoggettoFonteId
              AND s.DataCancellazione IS NULL
              AND s.Attivo = 1
        )
            THROW 59153, 'SoggettoFonte inesistente, inattivo o cancellato.', 1;

        IF @RiferimentoDocumentaleId IS NULL
        BEGIN
            SELECT
                @RiferimentoDocumentaleId = d.RiferimentoDocumentaleId
            FROM Standard.RiferimentoDocumentale d WITH (UPDLOCK, HOLDLOCK)
            WHERE d.SoggettoFonteId = @SoggettoFonteId
              AND d.CodiceDocumento = @CodiceDocumento
              AND
              (
                    d.Edizione = @Edizione
                 OR (d.Edizione IS NULL AND @Edizione IS NULL)
              )
              AND d.DataCancellazione IS NULL;
        END;

        IF @RiferimentoDocumentaleId IS NULL
        BEGIN
            INSERT INTO Standard.RiferimentoDocumentale
                (SoggettoFonteId, TipoRiferimento, CodiceDocumento, Edizione,
                 Titolo, Stato, DataPubblicazione, DataCessazione,
                 UrlUfficiale, RepositoryFonte, Attivo, CreatoDa)
            VALUES
                (@SoggettoFonteId, @TipoRiferimento, @CodiceDocumento, @Edizione,
                 @Titolo, N'Corrente', @DataPubblicazione, NULL,
                 @UrlUfficiale, @RepositoryFonte, @Attivo, @OperatoreId);

            SET @RiferimentoDocumentaleId = CONVERT(int, SCOPE_IDENTITY());
            SET @Esito = N'INSERITO';
        END
        ELSE
        BEGIN
            IF NOT EXISTS
            (
                SELECT 1
                FROM Standard.RiferimentoDocumentale d WITH (UPDLOCK, HOLDLOCK)
                WHERE d.RiferimentoDocumentaleId = @RiferimentoDocumentaleId
                  AND d.DataCancellazione IS NULL
            )
                THROW 59154, 'RiferimentoDocumentale inesistente o cancellato logicamente.', 1;

            IF EXISTS
            (
                SELECT 1
                FROM Standard.RiferimentoDocumentale d WITH (UPDLOCK, HOLDLOCK)
                WHERE d.SoggettoFonteId = @SoggettoFonteId
                  AND d.CodiceDocumento = @CodiceDocumento
                  AND
                  (
                        d.Edizione = @Edizione
                     OR (d.Edizione IS NULL AND @Edizione IS NULL)
                  )
                  AND d.DataCancellazione IS NULL
                  AND d.RiferimentoDocumentaleId <> @RiferimentoDocumentaleId
            )
                THROW 59155, 'Business key documentale gia utilizzata da un altro record.', 1;

            UPDATE d
               SET d.SoggettoFonteId = @SoggettoFonteId,
                   d.TipoRiferimento = @TipoRiferimento,
                   d.CodiceDocumento = @CodiceDocumento,
                   d.Edizione = @Edizione,
                   d.Titolo = @Titolo,
                   d.DataPubblicazione = @DataPubblicazione,
                   d.UrlUfficiale = @UrlUfficiale,
                   d.RepositoryFonte = @RepositoryFonte,
                   d.Attivo = @Attivo,
                   d.DataModifica = @Adesso,
                   d.ModificatoDa = @OperatoreId
            FROM Standard.RiferimentoDocumentale d
            WHERE d.RiferimentoDocumentaleId = @RiferimentoDocumentaleId
              AND
              (
                  d.SoggettoFonteId <> @SoggettoFonteId
               OR d.TipoRiferimento <> @TipoRiferimento
               OR d.CodiceDocumento <> @CodiceDocumento
               OR ISNULL(d.Edizione, N'') <> ISNULL(@Edizione, N'')
               OR ISNULL(d.Titolo, N'') <> ISNULL(@Titolo, N'')
               OR ISNULL(d.DataPubblicazione, CONVERT(date, '00010101')) <>
                  ISNULL(@DataPubblicazione, CONVERT(date, '00010101'))
               OR ISNULL(d.UrlUfficiale, N'') <> ISNULL(@UrlUfficiale, N'')
               OR ISNULL(d.RepositoryFonte, N'') <> ISNULL(@RepositoryFonte, N'')
               OR d.Attivo <> @Attivo
              );

            IF @@ROWCOUNT > 0
                SET @Esito = N'AGGIORNATO';
        END;

        IF EXISTS (SELECT 1 FROM Standard.vw_ControlloCoerenzaDocumentale)
            THROW 59156, 'La manutenzione produrrebbe incoerenze documentali.', 1;

        IF @TranCountIniziale = 0
            COMMIT;

        SELECT
            @Esito AS Esito,
            d.RiferimentoDocumentaleId,
            d.SoggettoFonteId,
            d.TipoRiferimento,
            d.CodiceDocumento,
            d.Edizione,
            d.Stato,
            d.DataCessazione,
            d.Attivo
        FROM Standard.RiferimentoDocumentale d
        WHERE d.RiferimentoDocumentaleId = @RiferimentoDocumentaleId;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1
            ROLLBACK;
        ELSE IF XACT_STATE() = 1
        BEGIN
            IF @TranCountIniziale = 0
                ROLLBACK;
            ELSE
                ROLLBACK TRANSACTION MIG91_SalvaDoc;
        END;

        THROW;
    END CATCH;
END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Workflow canonico per inserire documenti Correnti e aggiornare i metadati senza modificare Stato e DataCessazione.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'PROCEDURE', @level1name = N'usp_SalvaRiferimentoDocumentale';


GO

