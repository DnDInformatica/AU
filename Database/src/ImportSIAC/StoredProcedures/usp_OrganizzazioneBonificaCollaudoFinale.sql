CREATE   PROCEDURE ImportSIAC.usp_OrganizzazioneBonificaCollaudoFinale
AS
BEGIN
  SET NOCOUNT ON;

  SELECT ClasseOperativa,Sistema,COUNT_BIG(*) AS Numero
  FROM ImportSIAC.vw_OrganizzazioneBonificaCodaConclusiva
  GROUP BY ClasseOperativa,Sistema
  ORDER BY MIN(PrioritaOperativa),Sistema;

  SELECT N'Identificativi organizzazione duplicati non condivisibili' AS Controllo,COUNT_BIG(*) AS Anomalie
  FROM (
    SELECT i.TipoIdentificativoEsternoId,i.Valore
    FROM Organizzazioni.OrganizzazioneIdentificativoEsterno i
    JOIN Tipologica.TipoIdentificativoEsterno t ON t.TipoIdentificativoEsternoId=i.TipoIdentificativoEsternoId
    WHERE i.DataCancellazione IS NULL AND ISNULL(t.Condivisibile,0)=0
    GROUP BY i.TipoIdentificativoEsternoId,i.Valore HAVING COUNT_BIG(*)>1
  ) d
  UNION ALL
  SELECT N'Identificativi UO duplicati',COUNT_BIG(*)
  FROM (
    SELECT TipoIdentificativoEsternoId,Valore
    FROM Organizzazioni.UnitaOrganizzativaIdentificativoEsterno
    WHERE DataCancellazione IS NULL
    GROUP BY TipoIdentificativoEsternoId,Valore HAVING COUNT_BIG(*)>1
  ) d
  UNION ALL
  SELECT N'UO senza organizzazione attiva',COUNT_BIG(*)
  FROM Organizzazioni.UnitaOrganizzativa u
  LEFT JOIN Organizzazioni.Organizzazione o ON o.OrganizzazioneId=u.OrganizzazioneId AND o.DataCancellazione IS NULL
  WHERE u.DataCancellazione IS NULL AND o.OrganizzazioneId IS NULL
  UNION ALL
  SELECT N'Anomalie aperte complessive',COUNT_BIG(*)
  FROM ImportSIAC.vw_OrganizzazioneBonificaAnomaliaAperta;
END;

GO

