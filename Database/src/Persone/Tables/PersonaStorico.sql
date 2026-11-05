CREATE TABLE [Persone].[PersonaStorico] (
    [PersonaId]           INT              NOT NULL,
    [CodiceFiscale]       NVARCHAR (16)    NULL,
    [TitoloOnorificoId]   INT              NULL,
    [Cognome]             NVARCHAR (100)   NOT NULL,
    [Nome]                NVARCHAR (100)   NOT NULL,
    [Genere]              CHAR (1)         NULL,
    [DataNascita]         DATE             NOT NULL,
    [ComuneNascitaId]     INT              NULL,
    [LuogoNascita]        NVARCHAR (100)   NULL,
    [ProvinciaNascita]    NVARCHAR (2)     NULL,
    [StatoNascitaId]      INT              NULL,
    [ConsensoPrivacy]     BIT              NOT NULL,
    [DataConsensoPrivacy] DATETIME2 (7)    NULL,
    [Note]                NVARCHAR (500)   NULL,
    [DataCreazione]       DATETIME2 (7)    NOT NULL,
    [CreatoDa]            INT              NULL,
    [DataModifica]        DATETIME2 (7)    NULL,
    [ModificatoDa]        INT              NULL,
    [DataCancellazione]   DATETIME2 (7)    NULL,
    [CancellatoDa]        INT              NULL,
    [UniqueRowId]         UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]  DATETIME2 (7)    NOT NULL,
    [DataFineValidita]    DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_PersonaStorico]
    ON [Persone].[PersonaStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

