CREATE TABLE [Tipologica].[TipoSedeStorico] (
    [TipoSedeId]          INT              NOT NULL,
    [Codice]              NVARCHAR (20)    NOT NULL,
    [Descrizione]         NVARCHAR (200)   NOT NULL,
    [DescrizioneBreve]    NVARCHAR (50)    NULL,
    [NormaRiferimento]    NVARCHAR (100)   NULL,
    [AutonomiaGestionale] BIT              NOT NULL,
    [Accreditabile]       BIT              NOT NULL,
    [IsSedeUnica]         BIT              NOT NULL,
    [Ordine]              INT              NULL,
    [Attivo]              BIT              NOT NULL,
    [DataCreazione]       DATETIME2 (7)    NOT NULL,
    [CreatoDa]            INT              NULL,
    [DataModifica]        DATETIME2 (7)    NULL,
    [ModificatoDa]        INT              NULL,
    [DataCancellazione]   DATETIME2 (7)    NULL,
    [CancellatoDa]        INT              NULL,
    [rowguid]             UNIQUEIDENTIFIER NOT NULL,
    [NoteAccreditabilita] NVARCHAR (1000)  NULL,
    [DataInizioValidita]  DATETIME2 (7)    NOT NULL,
    [DataFineValidita]    DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_TipoSedeStorico]
    ON [Tipologica].[TipoSedeStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

