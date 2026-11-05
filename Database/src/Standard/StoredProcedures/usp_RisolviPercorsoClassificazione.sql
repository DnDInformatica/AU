
CREATE   PROCEDURE Standard.usp_RisolviPercorsoClassificazione
    @CodicePercorso nvarchar(150),
    @VoceOrigineId int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @PercorsoId int,
        @VersioneOrigineId int,
        @VersioneDestinazioneId int,
        @NumeroPassi int;

    SELECT
        @PercorsoId = p.ClassificazionePercorsoCorrispondenzaId,
        @VersioneOrigineId = p.ClassificazioneVersioneOrigineId,
        @VersioneDestinazioneId =
            p.ClassificazioneVersioneDestinazioneId
    FROM Standard.ClassificazionePercorsoCorrispondenza p
    WHERE p.Codice = @CodicePercorso
      AND p.Attivo = 1
      AND p.DataCancellazione IS NULL;

    IF @PercorsoId IS NULL
        THROW 60250, 'Percorso inesistente, inattivo o cancellato.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM Standard.vw_ControlloConformitaPercorsiClassificazione v
        WHERE v.PercorsoId = @PercorsoId
    )
        THROW 60251, 'Percorso non conforme.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM Standard.VoceClassificazione v
        WHERE v.VoceClassificazioneId = @VoceOrigineId
          AND v.ClassificazioneVersioneId = @VersioneOrigineId
          AND v.Attivo = 1
          AND v.DataCancellazione IS NULL
    )
        THROW 60252, 'Voce origine non attiva o non appartenente alla versione iniziale.', 1;

    SELECT @NumeroPassi = COUNT(*)
    FROM Standard.ClassificazionePercorsoCorrispondenzaPasso s
    WHERE s.ClassificazionePercorsoCorrispondenzaId = @PercorsoId
      AND s.Attivo = 1
      AND s.DataCancellazione IS NULL;

    DECLARE
        @PassoCorrente int = 1,
        @CorrispondenzaId int,
        @Direzione nvarchar(20);

    DECLARE @VociCorrenti table
    (
        VoceClassificazioneId int NOT NULL PRIMARY KEY
    );

    DECLARE @VociSuccessive table
    (
        VoceClassificazioneId int NOT NULL PRIMARY KEY
    );

    INSERT INTO @VociCorrenti (VoceClassificazioneId)
    VALUES (@VoceOrigineId);

    WHILE @PassoCorrente <= @NumeroPassi
    BEGIN
        SELECT
            @CorrispondenzaId =
                s.ClassificazioneVersioneCorrispondenzaId,
            @Direzione = s.Direzione
        FROM Standard.ClassificazionePercorsoCorrispondenzaPasso s
        WHERE s.ClassificazionePercorsoCorrispondenzaId = @PercorsoId
          AND s.OrdinePasso = @PassoCorrente
          AND s.Attivo = 1
          AND s.DataCancellazione IS NULL;

        DELETE FROM @VociSuccessive;

        IF @Direzione = N'DIRETTA'
        BEGIN
            INSERT INTO @VociSuccessive (VoceClassificazioneId)
            SELECT DISTINCT e.VoceDestinazioneId
            FROM @VociCorrenti c
            JOIN Standard.vw_VoceClassificazioneCorrispondenzaEspansa e
              ON e.VoceOrigineId = c.VoceClassificazioneId
             AND e.ClassificazioneVersioneCorrispondenzaId =
                 @CorrispondenzaId;
        END
        ELSE
        BEGIN
            INSERT INTO @VociSuccessive (VoceClassificazioneId)
            SELECT DISTINCT e.VoceOrigineId
            FROM @VociCorrenti c
            JOIN Standard.vw_VoceClassificazioneCorrispondenzaEspansa e
              ON e.VoceDestinazioneId = c.VoceClassificazioneId
             AND e.ClassificazioneVersioneCorrispondenzaId =
                 @CorrispondenzaId;
        END;

        DELETE FROM @VociCorrenti;

        INSERT INTO @VociCorrenti (VoceClassificazioneId)
        SELECT VoceClassificazioneId
        FROM @VociSuccessive;

        SET @PassoCorrente += 1;
    END;

    SELECT DISTINCT
        @CodicePercorso AS CodicePercorso,
        @VoceOrigineId AS VoceOrigineId,
        v.VoceClassificazioneId AS VoceDestinazioneId,
        cl.Codice AS ClassificazioneDestinazione,
        cv.Codice AS VersioneDestinazione,
        v.Codice AS CodiceDestinazione,
        v.Denominazione AS DenominazioneDestinazione
    FROM @VociCorrenti c
    JOIN Standard.VoceClassificazione v
      ON v.VoceClassificazioneId = c.VoceClassificazioneId
     AND v.ClassificazioneVersioneId = @VersioneDestinazioneId
     AND v.Attivo = 1
     AND v.DataCancellazione IS NULL
    JOIN Standard.ClassificazioneVersione cv
      ON cv.ClassificazioneVersioneId = v.ClassificazioneVersioneId
     AND cv.DataCancellazione IS NULL
    JOIN Standard.Classificazione cl
      ON cl.ClassificazioneId = v.ClassificazioneId
     AND cl.DataCancellazione IS NULL
    ORDER BY v.Codice;
END;

GO

