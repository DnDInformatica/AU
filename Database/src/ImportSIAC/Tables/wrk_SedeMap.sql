CREATE TABLE [ImportSIAC].[wrk_SedeMap] (
    [OrganizzazioneClienteId] INT             NULL,
    [address]                 NVARCHAR (1000) NULL,
    [city]                    NVARCHAR (400)  NULL,
    [zip]                     NVARCHAR (100)  NULL,
    [SedeId]                  INT             NULL
);


GO

CREATE NONCLUSTERED INDEX [CX_SedeMap]
    ON [ImportSIAC].[wrk_SedeMap]([OrganizzazioneClienteId] ASC)
    INCLUDE([address], [city], [zip], [SedeId]);


GO

