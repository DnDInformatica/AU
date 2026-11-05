
CREATE   VIEW
    Certificazione.vw_CertificazionePRDProfiloTecnicoCorrente
AS
SELECT
    a.CertificazionePRDProfiloTecnicoId,
    a.CertificazionePRDId,
    prd.CertificazioneId,
    a.ProfiloTecnicoProgrammaId,
    p.ProgrammaCertificazioneVersioneId,
    pc.Codice AS CodiceProgramma,
    pcv.CodiceVersione AS VersioneProgramma,
    p.CodiceSpecificaTecnica,
    p.Codice AS CodiceProfilo,
    p.DescrizioneIta,
    p.DescrizioneEng,
    p.StatoQualificazione,
    a.Ordinale,
    a.ValoreOrigine,
    a.DataInizioApplicabilita
FROM Certificazione.CertificazionePRDProfiloTecnico AS a
JOIN Certificazione.CertificazionePRD AS prd
  ON prd.CertificazionePRDId = a.CertificazionePRDId
JOIN Standard.ProfiloTecnicoProgramma AS p
  ON p.ProfiloTecnicoProgrammaId = a.ProfiloTecnicoProgrammaId
JOIN Certificazione.ProgrammaCertificazioneVersione AS pcv
  ON pcv.ProgrammaCertificazioneVersioneId =
     p.ProgrammaCertificazioneVersioneId
JOIN Certificazione.ProgrammaCertificazione AS pc
  ON pc.ProgrammaCertificazioneId = pcv.ProgrammaCertificazioneId
WHERE a.DataFineApplicabilita IS NULL
  AND a.Attivo = 1
  AND a.DataCancellazione IS NULL
  AND p.Attivo = 1
  AND p.DataCancellazione IS NULL;

GO

