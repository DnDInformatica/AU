CREATE TABLE [ImportSIAC].[wrk_FPC_MappaProgramma] (
    [OrganizzazioneId]          INT NOT NULL,
    [ProgrammaCertificazioneId] INT NULL
);


GO

CREATE UNIQUE CLUSTERED INDEX [CX_FPC_MappaProgramma]
    ON [ImportSIAC].[wrk_FPC_MappaProgramma]([OrganizzazioneId] ASC);


GO

