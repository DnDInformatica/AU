
CREATE   VIEW Standard.vw_ControlloConformitaClassificazioni
AS
    SELECT
        CONVERT(nvarchar(100), N'VERSIONE_SENZA_GOVERNANCE_VERSIONABILE')
            AS Anomalia,
        v.ClassificazioneVersioneId AS Id,
        CONCAT(N'Versione ', v.Codice,
               N' priva di governance attiva con VersionabileFlag=1.')
            AS Dettaglio
    FROM Standard.ClassificazioneVersione v
    LEFT JOIN Standard.ClassificazioneGovernance g
      ON g.ClassificazioneId = v.ClassificazioneId
     AND g.VersionabileFlag = 1
     AND g.Attivo = 1
     AND g.DataCancellazione IS NULL
    WHERE v.DataCancellazione IS NULL
      AND g.ClassificazioneId IS NULL

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'VERSIONE_DECORRENZA_ANTERIORE_NON_GIUSTIFICATA'),
        v.ClassificazioneVersioneId,
        CONCAT
        (
            N'Versione ', v.Codice, N' applicabile dal ',
            CONVERT(nvarchar(10), v.DataInizioApplicazione, 23),
            N' prima del documento primario del ',
            CONVERT(nvarchar(10), dp.DataPubblicazione, 23),
            N' e senza riferimento Istituisce anteriore o contestuale.'
        )
    FROM Standard.ClassificazioneVersione v
    JOIN Standard.ClassificazioneVersioneRiferimento rp
      ON rp.ClassificazioneVersioneId = v.ClassificazioneVersioneId
     AND rp.PrimarioFlag = 1
     AND rp.Attivo = 1
     AND rp.DataCancellazione IS NULL
    JOIN Standard.RiferimentoDocumentale dp
      ON dp.RiferimentoDocumentaleId = rp.RiferimentoDocumentaleId
     AND dp.Attivo = 1
     AND dp.DataCancellazione IS NULL
    WHERE v.DataCancellazione IS NULL
      AND dp.DataPubblicazione > v.DataInizioApplicazione
      AND NOT EXISTS
      (
          SELECT 1
          FROM Standard.ClassificazioneVersioneRiferimento ri
          JOIN Standard.RiferimentoDocumentale di
            ON di.RiferimentoDocumentaleId = ri.RiferimentoDocumentaleId
           AND di.Attivo = 1
           AND di.DataCancellazione IS NULL
          WHERE ri.ClassificazioneVersioneId = v.ClassificazioneVersioneId
            AND ri.RuoloRiferimento = N'Istituisce'
            AND ri.Attivo = 1
            AND ri.DataCancellazione IS NULL
            AND di.DataPubblicazione <= v.DataInizioApplicazione
      )

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'VOCE_ATTIVA_CLASSIFICAZIONE_NON_ATTIVA'),
        vc.VoceClassificazioneId,
        CONCAT(N'Voce ', vc.Codice,
               N' collegata a classificazione assente, inattiva o cancellata.')
    FROM Standard.VoceClassificazione vc
    LEFT JOIN Standard.Classificazione c
      ON c.ClassificazioneId = vc.ClassificazioneId
     AND c.Attivo = 1
     AND c.DataCancellazione IS NULL
    WHERE vc.Attivo = 1
      AND vc.DataCancellazione IS NULL
      AND c.ClassificazioneId IS NULL

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'VOCE_ATTIVA_VERSIONE_CANCELLATA'),
        vc.VoceClassificazioneId,
        CONCAT(N'Voce ', vc.Codice,
               N' collegata a una versione logicamente cancellata.')
    FROM Standard.VoceClassificazione vc
    JOIN Standard.ClassificazioneVersione v
      ON v.ClassificazioneVersioneId = vc.ClassificazioneVersioneId
     AND v.ClassificazioneId = vc.ClassificazioneId
    WHERE vc.Attivo = 1
      AND vc.DataCancellazione IS NULL
      AND v.DataCancellazione IS NOT NULL

    UNION ALL

    SELECT
        CONVERT(nvarchar(100), N'VOCE_ATTIVA_GOVERNANCE_NON_ATTIVA'),
        vc.VoceClassificazioneId,
        CONCAT(N'Voce ', vc.Codice,
               N' collegata a governance assente, inattiva o cancellata.')
    FROM Standard.VoceClassificazione vc
    LEFT JOIN Standard.ClassificazioneGovernance g
      ON g.ClassificazioneId = vc.ClassificazioneId
     AND g.Attivo = 1
     AND g.DataCancellazione IS NULL
    WHERE vc.Attivo = 1
      AND vc.DataCancellazione IS NULL
      AND g.ClassificazioneId IS NULL;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gate operativo per classificazioni, versioni e voci; include la giustificazione documentale delle decorrenze anteriori al riferimento primario.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'VIEW', @level1name = N'vw_ControlloConformitaClassificazioni';


GO

