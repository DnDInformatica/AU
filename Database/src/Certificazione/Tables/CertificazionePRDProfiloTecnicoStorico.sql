CREATE TABLE [Certificazione].[CertificazionePRDProfiloTecnicoStorico] (
    [CertificazionePRDProfiloTecnicoId] BIGINT           NOT NULL,
    [CertificazionePRDId]               INT              NOT NULL,
    [ProfiloTecnicoProgrammaId]         INT              NOT NULL,
    [Ordinale]                          SMALLINT         NOT NULL,
    [ValoreOrigine]                     NVARCHAR (100)   NOT NULL,
    [DataInizioApplicabilita]           DATETIME2 (7)    NOT NULL,
    [DataFineApplicabilita]             DATETIME2 (7)    NULL,
    [OrigineSistema]                    NVARCHAR (200)   NOT NULL,
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

CREATE CLUSTERED INDEX [ix_CertificazionePRDProfiloTecnicoStorico]
    ON [Certificazione].[CertificazionePRDProfiloTecnicoStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

