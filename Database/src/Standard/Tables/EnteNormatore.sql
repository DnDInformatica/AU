CREATE TABLE [Standard].[EnteNormatore] (
    [EnteNormatoreId]    INT                                                IDENTITY (1, 1) NOT NULL,
    [Codice]             NVARCHAR (30)                                      NOT NULL,
    [Descrizione]        NVARCHAR (200)                                     NOT NULL,
    [PaeseArea]          NVARCHAR (100)                                     NULL,
    [Attivo]             BIT                                                DEFAULT ((1)) NOT NULL,
    [DataCreazione]      DATETIME2 (7)                                      DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]           INT                                                NULL,
    [DataModifica]       DATETIME2 (7)                                      NULL,
    [ModificatoDa]       INT                                                NULL,
    [DataCancellazione]  DATETIME2 (7)                                      NULL,
    [CancellatoDa]       INT                                                NULL,
    [UniqueRowId]        UNIQUEIDENTIFIER                                   DEFAULT (newid()) NOT NULL,
    [DataInizioValidita] DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]   DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_EnteNormatore] PRIMARY KEY CLUSTERED ([EnteNormatoreId] ASC),
    CONSTRAINT [CK_EnteNormatore_Codice] CHECK (len(ltrim(rtrim([Codice])))>(0)),
    CONSTRAINT [CK_EnteNormatore_Descrizione] CHECK (len(ltrim(rtrim([Descrizione])))>(0)),
    CONSTRAINT [UQ_EnteNormatore_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Standard].[EnteNormatoreStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'EnteNormatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.05', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'EnteNormatore';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Lookup degli enti normatori e organismi emittenti standard/norme.', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'EnteNormatore';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'Direzione Centrale Accreditamento', @level0type = N'SCHEMA', @level0name = N'Standard', @level1type = N'TABLE', @level1name = N'EnteNormatore';


GO

