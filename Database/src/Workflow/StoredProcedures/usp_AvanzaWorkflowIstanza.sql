CREATE PROCEDURE Workflow.usp_AvanzaWorkflowIstanza
    @WorkflowIstanzaId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- ================================================================
    -- SCAFFOLD MINIMO — NON COMPLETO. Vedi TODO inline.
    -- Pensata per essere invocata da un job HangFire (recurring/fire-and-forget)
    -- al completamento di un Task o al verificarsi di un evento esterno
    -- (es. accettazione offerta, delibera CSA registrata).
    -- TODO generali non ancora affrontati in questo scaffold:
    --   1) Idempotenza/lock: nessuna protezione da doppia esecuzione concorrente
    --      (due worker HangFire sulla stessa istanza).
    --   2) Notifiche automatiche (Workflow.Notifica) al cambio di step — non generate qui.
    --   3) SLA/scadenza per step: DataScadenza del Task è NULL, andrebbe calcolata
    --      da una durata standard per CodiceStep (non ancora modellata).
    --   4) Gestione step condizionali/eccezione (RILIEVI_APERTI, DOMANDA_INCOMPLETA)
    --      come branch, non solo come stati StatoPratica paralleli.
    --   5) TipoTask assegnato in modo generico ('GENERICO') — andrebbe derivato
    --      dal CodiceStep con una mappatura dedicata.
    -- ================================================================

    -- 14/08/2026: allineato alle tipologiche temporali (lotti 2 e 3).
    -- StatoIstanza -> StatoIstanzaWorkflowId, OggettoTipo -> TipoOggettoDominioId,
    -- TipoTask/StatoTask/Priorita -> TipoTaskId/StatoTaskId/PrioritaLavorazioneId.
    DECLARE @WorkflowDefinizioneId INT, @OrdineCorrente INT, @StatoIstanzaId INT,
            @StatoIstanzaCodice NVARCHAR(50), @TipoOggettoDominioId INT, @OggettoId INT;

    SELECT @WorkflowDefinizioneId = wi.WorkflowDefinizioneId,
           @OrdineCorrente = wsd.OrdineStep,
           @StatoIstanzaId = wi.StatoIstanzaWorkflowId,
           @TipoOggettoDominioId = wi.TipoOggettoDominioId,
           @OggettoId = wi.OggettoId
    FROM Workflow.WorkflowIstanza wi
    LEFT JOIN Workflow.WorkflowStepDefinizione wsd ON wsd.WorkflowStepDefinizioneId = wi.WorkflowStepDefinizioneCorrenteId
    WHERE wi.WorkflowIstanzaId = @WorkflowIstanzaId;

    IF @WorkflowDefinizioneId IS NULL
    BEGIN
        RAISERROR('WorkflowIstanza %d non trovata', 16, 1, @WorkflowIstanzaId);
        RETURN;
    END

    SELECT @StatoIstanzaCodice = Codice
    FROM Tipologica.StatoIstanzaWorkflow
    WHERE StatoIstanzaWorkflowId = @StatoIstanzaId;

    IF @StatoIstanzaCodice NOT IN (N'APERTA', N'IN_CORSO')
    BEGIN
        RAISERROR('WorkflowIstanza %d non avanzabile: stato corrente = %s', 16, 1, @WorkflowIstanzaId, @StatoIstanzaCodice);
        RETURN;
    END

    DECLARE @ProssimoStepId INT, @IsFinale BIT, @TipoRuoloAccrediaId INT, @CodiceStep NVARCHAR(50), @NomeStep NVARCHAR(200);

    SELECT TOP 1
        @ProssimoStepId = WorkflowStepDefinizioneId,
        @IsFinale = IsFinale,
        @TipoRuoloAccrediaId = TipoRuoloAccrediaId,
        @CodiceStep = CodiceStep,
        @NomeStep = NomeStep
    FROM Workflow.WorkflowStepDefinizione
    WHERE WorkflowDefinizioneId = @WorkflowDefinizioneId
      AND OrdineStep > ISNULL(@OrdineCorrente, 0)
    ORDER BY OrdineStep ASC;

    IF @ProssimoStepId IS NULL
    BEGIN
        RAISERROR('Nessuno step successivo per WorkflowIstanza %d: workflow già concluso o WorkflowStepDefinizione incompleta', 16, 1, @WorkflowIstanzaId);
        RETURN;
    END

    UPDATE Workflow.WorkflowIstanza
    SET WorkflowStepDefinizioneCorrenteId = @ProssimoStepId,
        StatoIstanzaWorkflowId = (SELECT StatoIstanzaWorkflowId FROM Tipologica.StatoIstanzaWorkflow
                                  WHERE Codice = CASE WHEN @IsFinale = 1 THEN N'COMPLETATA' ELSE N'IN_CORSO' END),
        DataChiusura = CASE WHEN @IsFinale = 1 THEN SYSUTCDATETIME() ELSE NULL END,
        DataModifica = SYSUTCDATETIME()
    WHERE WorkflowIstanzaId = @WorkflowIstanzaId;

    -- TODO: TipoTask='GENERICO' è un placeholder, vedi punto 5) sopra.
    INSERT INTO Workflow.Task (WorkflowIstanzaId, TipoTaskId, Titolo, StatoTaskId, PrioritaLavorazioneId, TipoRuoloAccrediaId, DataCreazione)
    VALUES (@WorkflowIstanzaId,
            (SELECT TipoTaskId FROM Tipologica.TipoTask WHERE Codice = N'GENERICO'),
            @NomeStep,
            (SELECT StatoTaskId FROM Tipologica.StatoTask WHERE Codice = N'APERTO'),
            (SELECT PrioritaLavorazioneId FROM Tipologica.PrioritaLavorazione WHERE Codice = N'MEDIA'),
            @TipoRuoloAccrediaId, SYSUTCDATETIME());

    -- Registra l'evento sull'oggetto di dominio reale (es. la Pratica), non sull'istanza di workflow.
    INSERT INTO Workflow.AuditEvento (TipoOggettoDominioId, OggettoId, Azione, Descrizione, DataEvento, DataCreazione)
    VALUES (@TipoOggettoDominioId, @OggettoId, N'CAMBIO_STATO',
            CONCAT(N'Avanzamento a step ', @CodiceStep, N' (', @NomeStep, N')'),
            SYSUTCDATETIME(), SYSUTCDATETIME());
END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Scaffold minimo del motore di avanzamento workflow: porta WorkflowIstanza al WorkflowStepDefinizione successivo (per OrdineStep), genera un Task e un AuditEvento sull''oggetto di dominio reale (WorkflowIstanza.OggettoTipo/OggettoId). Testata manualmente (avanzamento 2 step su ACCREDITAMENTO_INIZIALE, dati di test rimossi). NON COMPLETA: mancano idempotenza/lock concorrente, generazione automatica di Notifica, calcolo SLA/DataScadenza per step, gestione step condizionali (RILIEVI_APERTI/DOMANDA_INCOMPLETA), mappatura CodiceStep→TipoTask (oggi fissato a GENERICO). Da richiamare da un job HangFire.', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'PROCEDURE', @level1name = N'usp_AvanzaWorkflowIstanza';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'InSviluppo', @level0type = N'SCHEMA', @level0name = N'Workflow', @level1type = N'PROCEDURE', @level1name = N'usp_AvanzaWorkflowIstanza';


GO

