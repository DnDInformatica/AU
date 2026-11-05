
CREATE   PROCEDURE
    Organizzazioni.usp_RegistraVerificaAttivitaEconomica
    @OrganizzazioneAttivitaEconomicaId int,
    @VisuraSnapshotId int,
    @ModalitaVerifica nvarchar(20),
    @Esito nvarchar(30),
    @CodiceRilevato nvarchar(100) = NULL,
    @VoceClassificazioneRilevataId int = NULL,
    @ClassificazioneVersioneRilevataId int = NULL,
    @ClassificazioneRilevataId int = NULL,
    @Confidenza decimal(5,4) = NULL,
    @VerificatoDaPersonaId int = NULL,
    @DataVerifica datetime2(0) = NULL,
    @Note nvarchar(2000) = NULL,
    @OperatoreId int = NULL,
    @OrganizzazioneAttivitaEconomicaVerificaId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- 14/08/2026: allineato alla tipologica temporale introdotta dal lotto 3.
    -- La colonna Esito e la colonna calcolata persistita RichiedeValutazione sono
    -- state sostituite da EsitoVerificaAttivitaEconomicaId; RichiedeValutazione e'
    -- ora una proprieta' dell'esito sulla tipologica. Il parametro @Esito resta
    -- testuale per non alterare il contratto della procedura verso i chiamanti.
    DECLARE @EsitoVerificaAttivitaEconomicaId int =
        (SELECT EsitoVerificaAttivitaEconomicaId
         FROM Tipologica.EsitoVerificaAttivitaEconomica
         WHERE Codice = @Esito);

    IF @EsitoVerificaAttivitaEconomicaId IS NULL
        THROW 60325, 'Esito verifica non ammesso: codice assente in Tipologica.EsitoVerificaAttivitaEconomica.', 1;

    DECLARE
        @OrganizzazioneId int,
        @VoceAssegnataId int,
        @VersioneAssegnataId int,
        @ClassificazioneAssegnataId int,
        @OrganizzazioneVisuraId int,
        @DataEstrazioneVisura datetime2(0);

    IF @DataVerifica IS NULL
        SET @DataVerifica = SYSUTCDATETIME();

    SELECT
        @OrganizzazioneId = a.OrganizzazioneId,
        @VoceAssegnataId = a.VoceClassificazioneId,
        @VersioneAssegnataId = a.ClassificazioneVersioneId,
        @ClassificazioneAssegnataId = a.ClassificazioneId
    FROM Organizzazioni.OrganizzazioneAttivitaEconomica a
    WHERE a.OrganizzazioneAttivitaEconomicaId =
          @OrganizzazioneAttivitaEconomicaId
      AND a.DataCancellazione IS NULL;

    IF @OrganizzazioneId IS NULL
        THROW 60320, 'Attribuzione ATECO assente o cancellata.', 1;

    SELECT
        @OrganizzazioneVisuraId = s.OrganizzazioneId,
        @DataEstrazioneVisura = s.DataEstrazioneVisura
    FROM Organizzazioni.VisuraSnapshot s
    WHERE s.VisuraSnapshotId = @VisuraSnapshotId
      AND s.DataCancellazione IS NULL;

    IF @OrganizzazioneVisuraId IS NULL
        THROW 60321, 'Visura assente o cancellata.', 1;

    IF @OrganizzazioneVisuraId <> @OrganizzazioneId
        THROW 60322,
              'La visura appartiene a un organizzazione diversa.',
              1;

    IF @DataVerifica < @DataEstrazioneVisura
        THROW 60323,
              'La verifica non puo precedere l estrazione della visura.',
              1;

    IF @Esito = N'DIFFORME'
       AND @VoceClassificazioneRilevataId = @VoceAssegnataId
       AND @ClassificazioneVersioneRilevataId = @VersioneAssegnataId
       AND @ClassificazioneRilevataId = @ClassificazioneAssegnataId
        THROW 60324,
              'Una difformita non puo indicare la stessa voce assegnata.',
              1;

    INSERT INTO
        Organizzazioni.OrganizzazioneAttivitaEconomicaVerifica
    (
        OrganizzazioneId,
        OrganizzazioneAttivitaEconomicaId,
        VisuraSnapshotId,
        DataVerifica,
        ModalitaVerifica,
        EsitoVerificaAttivitaEconomicaId,
        CodiceRilevato,
        VoceClassificazioneRilevataId,
        ClassificazioneVersioneRilevataId,
        ClassificazioneRilevataId,
        Confidenza,
        VerificatoDaPersonaId,
        Note,
        Attivo,
        CreatoDa
    )
    VALUES
    (
        @OrganizzazioneId,
        @OrganizzazioneAttivitaEconomicaId,
        @VisuraSnapshotId,
        @DataVerifica,
        @ModalitaVerifica,
        @EsitoVerificaAttivitaEconomicaId,
        @CodiceRilevato,
        @VoceClassificazioneRilevataId,
        @ClassificazioneVersioneRilevataId,
        @ClassificazioneRilevataId,
        @Confidenza,
        @VerificatoDaPersonaId,
        @Note,
        1,
        @OperatoreId
    );

    SET @OrganizzazioneAttivitaEconomicaVerificaId =
        CONVERT(int, SCOPE_IDENTITY());

    -- Il resultset conserva i nomi di colonna originali (Esito, RichiedeValutazione)
    -- per non alterare il contratto verso i chiamanti: i valori provengono ora
    -- dalla tipologica anziche' da colonne della tabella.
    SELECT
        v.OrganizzazioneAttivitaEconomicaVerificaId,
        e.Codice AS Esito,
        e.RichiedeValutazione
    FROM Organizzazioni.OrganizzazioneAttivitaEconomicaVerifica v
    INNER JOIN Tipologica.EsitoVerificaAttivitaEconomica e
        ON e.EsitoVerificaAttivitaEconomicaId = v.EsitoVerificaAttivitaEconomicaId
    WHERE v.OrganizzazioneAttivitaEconomicaVerificaId =
          @OrganizzazioneAttivitaEconomicaVerificaId;
END;

GO

