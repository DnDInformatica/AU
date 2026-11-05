CREATE TABLE [Certificazione].[CertificazioneVolturaStorico] (
    [CertificazioneVolturaId]     INT              NOT NULL,
    [CertificazioneId]            INT              NOT NULL,
    [OrganizzazioneCedenteId]     INT              NOT NULL,
    [OrganizzazioneSubentranteId] INT              NOT NULL,
    [EventoSocietarioId]          INT              NULL,
    [WorkflowIstanzaId]           INT              NULL,
    [DeliberaId]                  INT              NULL,
    [TipoProcessoCertificativoId] INT              NOT NULL,
    [DataRichiesta]               DATE             NOT NULL,
    [DataEfficacia]               DATE             NULL,
    [Motivo]                      NVARCHAR (500)   NULL,
    [NuovoNumeroCertificato]      NVARCHAR (100)   NULL,
    [MantieneNumeroCertificato]   BIT              NOT NULL,
    [Approvata]                   BIT              NULL,
    [DataCreazione]               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                    INT              NULL,
    [DataModifica]                DATETIME2 (7)    NULL,
    [ModificatoDa]                INT              NULL,
    [DataCancellazione]           DATETIME2 (7)    NULL,
    [CancellatoDa]                INT              NULL,
    [UniqueRowId]                 UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]            DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_CertificazioneVolturaStorico]
    ON [Certificazione].[CertificazioneVolturaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

