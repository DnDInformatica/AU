CREATE TABLE [Organizzazioni].[OrganizzazioneIdentificativoFiscaleStorico] (
    [OrganizzazioneIdentificativoFiscaleId] INT              NOT NULL,
    [OrganizzazioneId]                      INT              NOT NULL,
    [PaeseISO2]                             NCHAR (2)        NOT NULL,
    [TipoIdentificativo]                    NVARCHAR (30)    NOT NULL,
    [Valore]                                NVARCHAR (50)    NOT NULL,
    [Principale]                            BIT              NOT NULL,
    [Note]                                  NVARCHAR (500)   NULL,
    [CreatoDa]                              INT              NULL,
    [ModificatoDa]                          INT              NULL,
    [DataCreazione]                         DATETIME2 (7)    NOT NULL,
    [DataModifica]                          DATETIME2 (7)    NULL,
    [UniqueRowId]                           UNIQUEIDENTIFIER NOT NULL,
    [DataInizioValidita]                    DATETIME2 (7)    NOT NULL,
    [DataFineValidita]                      DATETIME2 (7)    NOT NULL
);


GO

CREATE CLUSTERED INDEX [ix_OrganizzazioneIdentificativoFiscaleStorico]
    ON [Organizzazioni].[OrganizzazioneIdentificativoFiscaleStorico]([DataFineValidita] ASC, [DataInizioValidita] ASC) WITH (DATA_COMPRESSION = PAGE);


GO

