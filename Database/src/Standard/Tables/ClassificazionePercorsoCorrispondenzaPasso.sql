CREATE TABLE [Standard].[ClassificazionePercorsoCorrispondenzaPasso] (
    [ClassificazionePercorsoCorrispondenzaPassoId] INT                                         IDENTITY (1, 1) NOT NULL,
    [ClassificazionePercorsoCorrispondenzaId]      INT                                         NOT NULL,
    [OrdinePasso]                                  SMALLINT                                    NOT NULL,
    [ClassificazioneVersioneCorrispondenzaId]      INT                                         NOT NULL,
    [Direzione]                                    NVARCHAR (20)                               NOT NULL,
    [Note]                                         NVARCHAR (2000)                             NULL,
    [Attivo]                                       BIT                                         CONSTRAINT [DF_ClassPercorsoCorrPasso_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                                DATETIME2 (7)                               CONSTRAINT [DF_ClassPercorsoCorrPasso_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                     INT                                         NULL,
    [DataModifica]                                 DATETIME2 (7)                               NULL,
    [ModificatoDa]                                 INT                                         NULL,
    [DataCancellazione]                            DATETIME2 (7)                               NULL,
    [CancellatoDa]                                 INT                                         NULL,
    [UniqueRowId]                                  UNIQUEIDENTIFIER                            CONSTRAINT [DF_ClassPercorsoCorrPasso_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                           DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]                             DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_ClassificazionePercorsoCorrispondenzaPasso] PRIMARY KEY CLUSTERED ([ClassificazionePercorsoCorrispondenzaPassoId] ASC),
    CONSTRAINT [CK_ClassPercorsoCorrPasso_Direzione] CHECK ([Direzione]=N'INVERSA' OR [Direzione]=N'DIRETTA'),
    CONSTRAINT [CK_ClassPercorsoCorrPasso_Ordine] CHECK ([OrdinePasso]>(0)),
    CONSTRAINT [FK_ClassPercorsoCorrPasso_Corrispondenza] FOREIGN KEY ([ClassificazioneVersioneCorrispondenzaId]) REFERENCES [Standard].[ClassificazioneVersioneCorrispondenza] ([ClassificazioneVersioneCorrispondenzaId]),
    CONSTRAINT [FK_ClassPercorsoCorrPasso_Percorso] FOREIGN KEY ([ClassificazionePercorsoCorrispondenzaId]) REFERENCES [Standard].[ClassificazionePercorsoCorrispondenza] ([ClassificazionePercorsoCorrispondenzaId]),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[ClassificazionePercorsoCorrispondenzaPassoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_ClassPercorsoCorrPasso_Ordine]
    ON [Standard].[ClassificazionePercorsoCorrispondenzaPasso]([ClassificazionePercorsoCorrispondenzaId] ASC, [OrdinePasso] ASC) WHERE ([DataCancellazione] IS NULL);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Passo ordinato di un percorso di corrispondenza, eseguito nella direzione ufficiale o inversa.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'ClassificazionePercorsoCorrispondenzaPasso';


GO

