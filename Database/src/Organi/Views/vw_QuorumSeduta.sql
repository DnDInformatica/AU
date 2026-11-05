CREATE VIEW Organi.vw_QuorumSeduta AS
SELECT
    e.EventoId,
    e.OrganoCollegialeId,
    o.Codice                              AS OrganoCodice,
    tp.Codice                             AS TipoOrgano,
    tp.BaseCalcoloDeliberativo,
    ic.ComponentiInCarica,
    pr.ComponentiPresenti,
    pr.AventiDirittoVotoPresenti,
    CAST(CEILING(ic.ComponentiInCarica * CAST(tp.QuorumCostitutivoNum AS DECIMAL(18,6)) / tp.QuorumCostitutivoDen) AS INT) AS SogliaCostitutiva,
    CASE WHEN pr.ComponentiPresenti >= CEILING(ic.ComponentiInCarica * CAST(tp.QuorumCostitutivoNum AS DECIMAL(18,6)) / tp.QuorumCostitutivoDen)
         THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS RiunioneValidamenteCostituita,
    CAST(CEILING(CASE tp.BaseCalcoloDeliberativo WHEN 'PRESENTI' THEN pr.AventiDirittoVotoPresenti ELSE ic.ComponentiInCarica END
         * CAST(tp.QuorumDeliberativoNum AS DECIMAL(18,6)) / tp.QuorumDeliberativoDen) AS INT) AS VotiFavorevoliNecessari,
    tp.AstensioneEquivaleVotoContrario,
    tp.AmmetteDelega,
    tp.AmmetteCooptazione
FROM Eventi.Evento e
JOIN Organi.OrganoCollegiale o           ON o.OrganoCollegialeId = e.OrganoCollegialeId
JOIN Tipologica.TipoOrganoCollegiale tp  ON tp.TipoOrganoCollegialeId = o.TipoOrganoCollegialeId
CROSS APPLY (
    SELECT COUNT(*) AS ComponentiInCarica
    FROM Organi.ComposizioneOrgano co
    JOIN Tipologica.TipoRuoloPartecipazioneEvento r ON r.TipoRuoloPartecipazioneEventoId = co.TipoRuoloPartecipazioneEventoId
    WHERE co.OrganoCollegialeId = o.OrganoCollegialeId
      AND co.DataCancellazione IS NULL
      AND r.ConteggiatoNumeroLegale = 1
      AND co.DataInizioIncarico <= CAST(e.DataInizio AS DATE)
      AND (co.DataFineIncarico IS NULL OR co.DataFineIncarico >= CAST(e.DataInizio AS DATE))
) ic
CROSS APPLY (
    SELECT COUNT(CASE WHEN r.ConteggiatoNumeroLegale = 1 AND ep.Presente = 1 THEN 1 END) AS ComponentiPresenti,
           COUNT(CASE WHEN r.HaDirittoVoto = 1 AND ep.Presente = 1 THEN 1 END)           AS AventiDirittoVotoPresenti
    FROM Eventi.EventoPartecipante ep
    JOIN Tipologica.TipoRuoloPartecipazioneEvento r ON r.TipoRuoloPartecipazioneEventoId = ep.TipoRuoloPartecipazioneEventoId
    WHERE ep.EventoId = e.EventoId AND ep.DataCancellazione IS NULL
) pr
WHERE e.DataCancellazione IS NULL AND e.OrganoCollegialeId IS NOT NULL AND tp.Deliberante = 1;

GO

