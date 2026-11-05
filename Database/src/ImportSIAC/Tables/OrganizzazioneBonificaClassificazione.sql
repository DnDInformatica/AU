CREATE TABLE [ImportSIAC].[OrganizzazioneBonificaClassificazione] (
    [OrganizzazioneBonificaClassificazioneId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [OrganizzazioneBonificaAnomaliaId]        BIGINT          NOT NULL,
    [Classe]                                  NVARCHAR (80)   NOT NULL,
    [Esito]                                   NVARCHAR (40)   NOT NULL,
    [Motivazione]                             NVARCHAR (2000) NOT NULL,
    [Fonte]                                   NVARCHAR (800)  NULL,
    [DataClassificazione]                     DATETIME2 (7)   CONSTRAINT [DF_OrganizzazioneBonificaClassificazione_Data] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_OrganizzazioneBonificaClassificazione] PRIMARY KEY CLUSTERED ([OrganizzazioneBonificaClassificazioneId] ASC),
    CONSTRAINT [FK_OrganizzazioneBonificaClassificazione_Anomalia] FOREIGN KEY ([OrganizzazioneBonificaAnomaliaId]) REFERENCES [ImportSIAC].[OrganizzazioneBonificaAnomalia] ([OrganizzazioneBonificaAnomaliaId]),
    CONSTRAINT [UQ_OrganizzazioneBonificaClassificazione_Anomalia] UNIQUE NONCLUSTERED ([OrganizzazioneBonificaAnomaliaId] ASC)
);


GO

