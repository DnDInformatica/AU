CREATE PROCEDURE Processi.usp_GeneraScadenzeCicloAccreditamento
    @MesiPreavviso INT = 8
AS
BEGIN
    SET NOCOUNT ON;
    -- SCAFFOLD MINIMO — NON COMPLETO (vedi EP per i TODO dettagliati).
    -- 14/08/2026: allineato alle tipologiche temporali introdotte dal lotto 2
    -- (TipoScadenza -> TipoScadenzaPraticaId, StatoScadenza -> StatoScadenzaPraticaId).
    DECLARE @TipoScadenzaCicloId INT =
        (SELECT TipoScadenzaPraticaId FROM Tipologica.TipoScadenzaPratica WHERE Codice = N'SCADENZA_CICLO');
    DECLARE @StatoApertaId INT =
        (SELECT StatoScadenzaPraticaId FROM Tipologica.StatoScadenzaPratica WHERE Codice = N'APERTA');
    DECLARE @StatoAnnullataId INT =
        (SELECT StatoScadenzaPraticaId FROM Tipologica.StatoScadenzaPratica WHERE Codice = N'ANNULLATA');

    IF @TipoScadenzaCicloId IS NULL OR @StatoApertaId IS NULL OR @StatoAnnullataId IS NULL
        THROW 50000, N'Tipologiche TipoScadenzaPratica/StatoScadenzaPratica non popolate: impossibile generare le scadenze.', 1;

    INSERT INTO Processi.PraticaScadenza (PraticaAccreditamentoId, TipoScadenzaPraticaId, DataScadenza, StatoScadenzaPraticaId, IsBloccante, DataCreazione)
    SELECT pa.PraticaAccreditamentoId, @TipoScadenzaCicloId, pa.DataScadenza, @StatoApertaId, 0, SYSUTCDATETIME()
    FROM Accreditamento.PraticaAccreditamento pa
    WHERE pa.DataScadenza <= DATEADD(MONTH, @MesiPreavviso, SYSUTCDATETIME())
      AND NOT EXISTS (
          SELECT 1 FROM Processi.PraticaScadenza ps
          WHERE ps.PraticaAccreditamentoId = pa.PraticaAccreditamentoId
            AND ps.TipoScadenzaPraticaId = @TipoScadenzaCicloId
            AND ps.StatoScadenzaPraticaId <> @StatoAnnullataId
      );
END;

GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'InSviluppo', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'PROCEDURE', @level1name = N'usp_GeneraScadenzeCicloAccreditamento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Scaffold minimo: genera Processi.PraticaScadenza (SCADENZA_CICLO) per PraticaAccreditamento in scadenza entro @MesiPreavviso mesi. NON COMPLETA: parametro di preavviso non differenziato per schema, nessun innesco automatico di un nuovo Processi.Pratica RINNOVO, nessuna chiusura automatica della scadenza all''apertura del rinnovo. Da eseguire da job HangFire schedulato (es. giornaliero).', @level0type = N'SCHEMA', @level0name = N'Processi', @level1type = N'PROCEDURE', @level1name = N'usp_GeneraScadenzeCicloAccreditamento';


GO

