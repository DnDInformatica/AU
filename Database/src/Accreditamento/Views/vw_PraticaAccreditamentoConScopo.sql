

/*================================================================================
  SEZIONE 5 - VISTA DI SUPPORTO

  Espone i dati della pratica con la tipologia di scopo e il numero di
  elementi attivi nell'Elenco. Le query temporali (AS OF, BETWEEN, etc.)
  sui dati storici sono disponibili gratuitamente tramite SYSTEM_VERSIONING.
================================================================================*/

CREATE   VIEW Accreditamento.vw_PraticaAccreditamentoConScopo
AS
SELECT
    p.PraticaAccreditamentoId,
    p.OrganizzazioneId,
    p.SchemaAccreditamentoId,
    p.NormaAccreditamentoId,
    p.CodicePPA,
    p.NumeroRegistrazione,
    p.DataAccreditamento,
    p.DataScadenza,
    p.TipoScopoAccreditamentoId,
    t.Codice            AS TipoScopoCodice,
    t.Descrizione       AS TipoScopoDescrizione,
    p.PerimetroFlessibilita,
    p.DataConcessioneScopoFlex,
    p.RiferimentoDeliberaCSA,
    p.AnalisiRischiRiferimento,
    (
        SELECT COUNT_BIG(*)
        FROM Accreditamento.ElencoDettaglioFlessibile e
        WHERE e.PraticaAccreditamentoId = p.PraticaAccreditamentoId
          AND e.StatoElementoFlessibileId = 1
          AND e.DataCancellazione IS NULL
    ) AS NumeroElementiAttiviElenco
FROM Accreditamento.PraticaAccreditamento p
LEFT JOIN Tipologica.TipoScopoAccreditamento t
    ON t.TipoScopoAccreditamentoId = p.TipoScopoAccreditamentoId;

GO

