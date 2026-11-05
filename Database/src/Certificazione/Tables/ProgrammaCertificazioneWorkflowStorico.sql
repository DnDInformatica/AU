CREATE TABLE [Certificazione].[ProgrammaCertificazioneWorkflowStorico] (
    [ProgrammaCertificazioneWorkflowId] INT              NOT NULL,
    [ProgrammaCertificazioneId]         INT              NOT NULL,
    [WorkflowDefinizioneId]             INT              NOT NULL,
    [TipoProcessoCertificativoId]       INT              NOT NULL,
    [Obbligatorio]                      BIT              NOT NULL,
    [Ordine]                            SMALLINT         NOT NULL,
    [SLA_Giorni]                        INT              NULL,
    [RichiedeDelibera]                  BIT              NOT NULL,
    [Note]                              NVARCHAR (1000)  NULL,
    [Attivo]                            BIT              NOT NULL,
    [DataCreazione]                     DATETIME2 (7)    NOT NULL,
    [CreatoDa]                          INT              NULL,
    [DataModifica]                      DATETIME2 (7)    NULL,
    [ModificatoDa]                      INT              NULL,
    [DataCancellazione]                 DATETIME2 (7)    NULL,
    [CancellatoDa]                      INT              NULL,
    [UniqueRowId]                       UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                  DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ProgrammaCertificazioneWorkflowStorico]
    ON [Certificazione].[ProgrammaCertificazioneWorkflowStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'HISTORY', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflowStorico';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tabella storica (HISTORY TABLE) per SYSTEM_VERSIONING di Certificazione.ProgrammaCertificazioneWorkflow. Contiene le versioni precedenti di ogni associazione programma-workflow con i periodi di validità. Non modificare direttamente.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflowStorico';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Certificazione;HistoryTable;ReadOnly', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneWorkflowStorico';


GO

