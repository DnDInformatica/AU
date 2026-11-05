CREATE TABLE [Organi].[ComposizioneOrganoStorico] (
    [ComposizioneOrganoId]            INT              NOT NULL,
    [OrganoCollegialeId]              INT              NOT NULL,
    [PersonaId]                       INT              NOT NULL,
    [TipoRuoloPartecipazioneEventoId] INT              NOT NULL,
    [DataInizioIncarico]              DATE             NOT NULL,
    [DataFineIncarico]                DATE             NULL,
    [AttoNomina]                      NVARCHAR (500)   NULL,
    [Cooptato]                        BIT              NOT NULL,
    [CooptatoPerPuntoOdGId]           INT              NULL,
    [CodiceEticoSottoscritto]         BIT              NOT NULL,
    [DataSottoscrizioneCodiceEtico]   DATE             NULL,
    [Note]                            NVARCHAR (2000)  NULL,
    [DataCreazione]                   DATETIME2 (7)    NOT NULL,
    [CreatoDa]                        INT              NULL,
    [DataModifica]                    DATETIME2 (7)    NULL,
    [ModificatoDa]                    INT              NULL,
    [DataCancellazione]               DATETIME2 (7)    NULL,
    [CancellatoDa]                    INT              NULL,
    [UniqueRowId]                     UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]              DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_ComposizioneOrganoStorico]
    ON [Organi].[ComposizioneOrganoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

