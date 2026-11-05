CREATE TABLE [Organizzazioni].[EventoSocietarioMatriceImpattoStorico] (
    [EventoSocietarioMatriceImpattoId]             INT              NOT NULL,
    [TipoEventoSocietarioId]                       INT              NOT NULL,
    [ScenarioOperativo]                            NVARCHAR (120)   NOT NULL,
    [EsitoCertificazioneRaccomandato]              NVARCHAR (60)    NOT NULL,
    [StatoPraticaAccreditamentoRaccomandatoCodice] NVARCHAR (20)    NOT NULL,
    [RichiedeValutazioneStraordinaria]             BIT              NOT NULL,
    [SLAValutazioneGiorni]                         SMALLINT         NOT NULL,
    [RiferimentiNormativi]                         NVARCHAR (1000)  NULL,
    [NoteOperative]                                NVARCHAR (2000)  NULL,
    [Attivo]                                       BIT              NOT NULL,
    [DataCreazione]                                DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                     INT              NULL,
    [DataModifica]                                 DATETIME2 (7)    NULL,
    [ModificatoDa]                                 INT              NULL,
    [DataCancellazione]                            DATETIME2 (7)    NULL,
    [CancellatoDa]                                 INT              NULL,
    [UniqueRowId]                                  UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                           DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                             DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_EventoSocietarioMatriceImpattoStorico]
    ON [Organizzazioni].[EventoSocietarioMatriceImpattoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

