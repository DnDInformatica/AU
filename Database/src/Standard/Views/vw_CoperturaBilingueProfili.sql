
CREATE   VIEW Standard.vw_CoperturaBilingueProfili
AS
SELECT
    CONVERT(nvarchar(3), N'PRD') AS Dominio,
    CONVERT(nvarchar(50), N'PROFILO_TECNICO_PROGRAMMA')
        AS TipoProfilo,
    p.ProfiloTecnicoProgrammaId AS ProfiloVersioneId,
    CONVERT(nvarchar(100), p.Codice) AS CodiceProfilo,
    CONVERT
    (
        nvarchar(200),
        CONCAT(pc.Codice, N'/', pcv.CodiceVersione)
    ) AS ContestoVersione,
    p.DescrizioneIta,
    p.DescrizioneEng,
    CONVERT(nvarchar(200), p.OrigineSistema) AS OrigineSistema,
    CONVERT(nvarchar(500), p.RiferimentoOrigine)
        AS RiferimentoOrigine,
    p.Attivo,
    CONVERT
    (
        nvarchar(40),
        CASE
            WHEN NULLIF(LTRIM(RTRIM(p.DescrizioneEng)), N'')
                 IS NOT NULL
            THEN N'VALORIZZATA'
            WHEN p.StatoQualificazione = N'LEGACY_DA_QUALIFICARE'
            THEN N'NON_DISPONIBILE_FONTE'
            ELSE N'DA_COMPLETARE'
        END
    ) AS StatoCoperturaEng
FROM Standard.ProfiloTecnicoProgramma AS p
JOIN Certificazione.ProgrammaCertificazioneVersione AS pcv
  ON pcv.ProgrammaCertificazioneVersioneId =
     p.ProgrammaCertificazioneVersioneId
JOIN Certificazione.ProgrammaCertificazione AS pc
  ON pc.ProgrammaCertificazioneId = pcv.ProgrammaCertificazioneId
WHERE p.DataCancellazione IS NULL

UNION ALL

SELECT
    CONVERT(nvarchar(3), N'FPC') AS Dominio,
    CONVERT(nvarchar(50), N'PROFILO_PROFESSIONALE_VERSIONE')
        AS TipoProfilo,
    ppv.ProfiloProfessionaleVersioneId AS ProfiloVersioneId,
    CONVERT(nvarchar(100), pp.Codice) AS CodiceProfilo,
    CONVERT(nvarchar(200), ppv.CodiceVersione) AS ContestoVersione,
    ppv.DescrizioneIta,
    ppv.DescrizioneEng,
    CONVERT(nvarchar(200), ppv.OrigineSistema) AS OrigineSistema,
    CONVERT(nvarchar(500), NULL) AS RiferimentoOrigine,
    CONVERT(bit, CASE WHEN ppv.Attivo = 1 AND pp.Attivo = 1
                      THEN 1 ELSE 0 END) AS Attivo,
    CONVERT
    (
        nvarchar(40),
        CASE
            WHEN NULLIF(LTRIM(RTRIM(ppv.DescrizioneEng)), N'')
                 IS NOT NULL
            THEN N'VALORIZZATA'
            WHEN ppv.CodiceVersione = N'LEGACY-SIAC-1'
            THEN N'NON_DISPONIBILE_FONTE'
            ELSE N'DA_COMPLETARE'
        END
    ) AS StatoCoperturaEng
FROM Standard.ProfiloProfessionaleVersione AS ppv
JOIN Standard.ProfiloProfessionale AS pp
  ON pp.ProfiloProfessionaleId = ppv.ProfiloProfessionaleId
WHERE ppv.DataCancellazione IS NULL
  AND pp.DataCancellazione IS NULL;

GO

