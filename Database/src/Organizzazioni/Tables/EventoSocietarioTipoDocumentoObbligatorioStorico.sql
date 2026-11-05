CREATE TABLE [Organizzazioni].[EventoSocietarioTipoDocumentoObbligatorioStorico] (
    [EventoSocietarioTipoDocumentoObbligatorioId] INT              NOT NULL,
    [TipoEventoSocietarioId]                      INT              NOT NULL,
    [TipoDocumentoEvento]                         NVARCHAR (80)    NOT NULL,
    [ObbligatorioPerEfficace]                     BIT              NOT NULL,
    [ObbligatorioPerChiuso]                       BIT              NOT NULL,
    [Attivo]                                      BIT              NOT NULL,
    [DataCreazione]                               DATETIME2 (7)    NOT NULL,
    [CreatoDa]                                    INT              NULL,
    [DataModifica]                                DATETIME2 (7)    NULL,
    [ModificatoDa]                                INT              NULL,
    [DataCancellazione]                           DATETIME2 (7)    NULL,
    [CancellatoDa]                                INT              NULL,
    [UniqueRowId]                                 UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                          DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                            DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_EventoSocietarioTipoDocumentoObbligatorioStorico]
    ON [Organizzazioni].[EventoSocietarioTipoDocumentoObbligatorioStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

