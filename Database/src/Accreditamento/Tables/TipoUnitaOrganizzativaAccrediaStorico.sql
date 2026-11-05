CREATE TABLE [Accreditamento].[TipoUnitaOrganizzativaAccrediaStorico] (
    [TipoUnitaOrganizzativaAccrediaId] INT            NOT NULL,
    [Codice]                           NVARCHAR (50)  NOT NULL,
    [Descrizione]                      NVARCHAR (500) NULL,
    [EsplicazioneMasNormativa]         NVARCHAR (MAX) NULL,
    [PuoAvereResponsabilita]           BIT            NOT NULL,
    [PuoSvolgerAttivitaAccreditate]    BIT            NOT NULL,
    [PuoAvereFunzioniTecniche]         BIT            NOT NULL,
    [EsempreSottoAudit]                BIT            NOT NULL,
    [DataCreazione]                    DATETIME2 (7)  NOT NULL,
    [DataModifica]                     DATETIME2 (7)  NOT NULL,
    [CreatoDa]                         INT            NULL,
    [ModificatoDa]                     INT            NULL,
    [DataCancellazione]                DATETIME2 (7)  NULL,
    [CancellatoDa]                     INT            NULL,
    [DataInizioValidita]               DATETIME2 (7)  NOT NULL,
    [DataFineValidita]                 DATETIME2 (7)  NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoUnitaOrganizzativaAccrediaStorico]
    ON [Accreditamento].[TipoUnitaOrganizzativaAccrediaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

