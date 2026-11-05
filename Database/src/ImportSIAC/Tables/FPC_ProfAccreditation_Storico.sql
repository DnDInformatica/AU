CREATE TABLE [ImportSIAC].[FPC_ProfAccreditation_Storico] (
    [FPCStoricoId]                   INT            IDENTITY (1, 1) NOT NULL,
    [EnteCode]                       NVARCHAR (200) NOT NULL,
    [ProfessionalCode]               NVARCHAR (400) NOT NULL,
    [ValidoDal]                      DATE           NOT NULL,
    [ValidoAl]                       DATE           NULL,
    [IsCorrente]                     BIT            NOT NULL,
    [NormaOrdinale]                  SMALLINT       NOT NULL,
    [NormaTesto]                     NVARCHAR (800) NULL,
    [NormaBaseCanonica]              NVARCHAR (400) NULL,
    [AnnoNorma]                      SMALLINT       NULL,
    [RegolamentazioneODC]            NVARCHAR (MAX) NULL,
    [IsSpecificaCAB]                 BIT            NOT NULL,
    [HasNormaPubblica]               BIT            NOT NULL,
    [SchemaTipo]                     NVARCHAR (60)  NULL,
    [LawRegulationIt]                NVARCHAR (MAX) NULL,
    [LawRegHash]                     BINARY (32)    NULL,
    [LoadDts]                        DATETIME2 (7)  NOT NULL,
    [NormaEdizioneId]                INT            NULL,
    [SchemaCertificazioneVersioneId] INT            NULL,
    [MatchSchemaMetodo]              VARCHAR (40)   NULL,
    [DataElaborazione]               DATETIME2 (7)  CONSTRAINT [DF_FPCStorico_DataElab] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_FPC_ProfAccreditation_Storico] PRIMARY KEY CLUSTERED ([FPCStoricoId] ASC),
    CONSTRAINT [FK_FPCStorico_NormaEdizione] FOREIGN KEY ([NormaEdizioneId]) REFERENCES [Standard].[NormaEdizione] ([NormaEdizioneId]),
    CONSTRAINT [FK_FPCStorico_SchemaCertVersione] FOREIGN KEY ([SchemaCertificazioneVersioneId]) REFERENCES [Standard].[SchemaCertificazioneVersione] ([SchemaCertificazioneVersioneId])
);


GO

CREATE NONCLUSTERED INDEX [IX_FPCStorico_Chiave]
    ON [ImportSIAC].[FPC_ProfAccreditation_Storico]([EnteCode] ASC, [ProfessionalCode] ASC, [NormaOrdinale] ASC, [ValidoDal] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_FPCStorico_SchemaCertVersione]
    ON [ImportSIAC].[FPC_ProfAccreditation_Storico]([SchemaCertificazioneVersioneId] ASC) WHERE ([SchemaCertificazioneVersioneId] IS NOT NULL);


GO

CREATE NONCLUSTERED INDEX [IX_FPCStorico_NormaEdizione]
    ON [ImportSIAC].[FPC_ProfAccreditation_Storico]([NormaEdizioneId] ASC) WHERE ([NormaEdizioneId] IS NOT NULL);


GO

