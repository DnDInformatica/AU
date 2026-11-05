CREATE TABLE [Certificazione].[TipoFonteLegame] (
    [TipoFonteLegameId] INT              IDENTITY (1, 1) NOT NULL,
    [Codice]            NVARCHAR (40)    NOT NULL,
    [Descrizione]       NVARCHAR (400)   NOT NULL,
    [Attivo]            BIT              CONSTRAINT [DF_TipoFonteLegame_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]     DATETIME2 (7)    CONSTRAINT [DF_TipoFonteLegame_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]          INT              NULL,
    [DataModifica]      DATETIME2 (7)    NULL,
    [ModificatoDa]      INT              NULL,
    [DataCancellazione] DATETIME2 (7)    NULL,
    [CancellatoDa]      INT              NULL,
    [UniqueRowId]       UNIQUEIDENTIFIER CONSTRAINT [DF_TipoFonteLegame_UniqueRowId] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_TipoFonteLegame] PRIMARY KEY CLUSTERED ([TipoFonteLegameId] ASC),
    CONSTRAINT [UQ_TipoFonteLegame_Codice] UNIQUE NONCLUSTERED ([Codice] ASC)
);


GO

