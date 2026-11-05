
CREATE   PROCEDURE ImportSIAC.usp_OrganizzazioneBonificaCruscotto
AS
BEGIN
 SET NOCOUNT ON;
 SELECT Sistema,TipoAnomalia,Stato,COUNT_BIG(*) Numero
 FROM ImportSIAC.OrganizzazioneBonificaAnomalia
 GROUP BY Sistema,TipoAnomalia,Stato
 ORDER BY Sistema,Stato,TipoAnomalia;

 SELECT Sistema,COUNT_BIG(*) AnomalieAperte
 FROM ImportSIAC.vw_OrganizzazioneBonificaAnomaliaAperta
 GROUP BY Sistema ORDER BY Sistema;

 SELECT N'Organizzazioni con identificativo esterno' Indicatore,COUNT_BIG(DISTINCT OrganizzazioneId) Valore
 FROM Organizzazioni.OrganizzazioneIdentificativoEsterno WHERE DataCancellazione IS NULL
 UNION ALL
 SELECT N'UO con identificativo esterno',COUNT_BIG(DISTINCT UnitaOrganizzativaId)
 FROM Organizzazioni.UnitaOrganizzativaIdentificativoEsterno WHERE DataCancellazione IS NULL
 UNION ALL
 SELECT N'Anomalie aperte',COUNT_BIG(*) FROM ImportSIAC.vw_OrganizzazioneBonificaAnomaliaAperta;
END;

GO

