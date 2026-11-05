CREATE TABLE [Certificazione].[ProgrammaCertificazioneIdentificativo] (
    [ProgrammaCertificazioneIdentificativoId] INT                                                IDENTITY (1, 1) NOT NULL,
    [ProgrammaCertificazioneId]               INT                                                NOT NULL,
    [TipoIdentificativo]                      NVARCHAR (200)                                     NOT NULL,
    [ValoreIdentificativo]                    NVARCHAR (1200)                                    NOT NULL,
    [OrigineSistema]                          NVARCHAR (400)                                     NOT NULL,
    [NormaFamigliaIdOrigine]                  INT                                                NULL,
    [NormaEdizioneIdOrigine]                  INT                                                NULL,
    [NormaAccreditamentoIdOrigine]            INT                                                NULL,
    [NormaAccreditamentoSchemaIdOrigine]      INT                                                NULL,
    [CodiceSPOrigine]                         NVARCHAR (100)                                     NULL,
    [NomeProgrammaOrigine]                    NVARCHAR (510)                                     NULL,
    [RiferimentoEdizioneOrigine]              NVARCHAR (600)                                     NULL,
    [RiferimentoDesignazioneOrigine]          NVARCHAR (600)                                     NULL,
    [Note]                                    NVARCHAR (4000)                                    NULL,
    [Attivo]                                  BIT                                                CONSTRAINT [DF_ProgrammaCertificazioneIdentificativo_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]                           DATETIME2 (7)                                      CONSTRAINT [DF_ProgrammaCertificazioneIdentificativo_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                                INT                                                NULL,
    [DataModifica]                            DATETIME2 (7)                                      NULL,
    [ModificatoDa]                            INT                                                NULL,
    [DataCancellazione]                       DATETIME2 (7)                                      NULL,
    [CancellatoDa]                            INT                                                NULL,
    [UniqueRowId]                             UNIQUEIDENTIFIER                                   CONSTRAINT [DF_ProgrammaCertificazioneIdentificativo_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]                      DATETIME2 (7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    [DataFineValidita]                        DATETIME2 (7) GENERATED ALWAYS AS ROW END HIDDEN   NOT NULL,
    CONSTRAINT [PK_ProgrammaCertificazioneIdentificativo] PRIMARY KEY CLUSTERED ([ProgrammaCertificazioneIdentificativoId] ASC),
    CONSTRAINT [CK_ProgrammaCertificazioneIdentificativo_Origine] CHECK (len(ltrim(rtrim([OrigineSistema])))>(0)),
    CONSTRAINT [CK_ProgrammaCertificazioneIdentificativo_Tipo] CHECK (len(ltrim(rtrim([TipoIdentificativo])))>(0)),
    CONSTRAINT [CK_ProgrammaCertificazioneIdentificativo_Valore] CHECK (len(ltrim(rtrim([ValoreIdentificativo])))>(0)),
    CONSTRAINT [FK_ProgrammaCertificazioneIdentificativo_ProgrammaCertificazione] FOREIGN KEY ([ProgrammaCertificazioneId]) REFERENCES [Certificazione].[ProgrammaCertificazione] ([ProgrammaCertificazioneId]),
    CONSTRAINT [UQ_ProgrammaCertificazioneIdentificativo_TargetTipoValoreOrigine] UNIQUE NONCLUSTERED ([ProgrammaCertificazioneId] ASC, [TipoIdentificativo] ASC, [ValoreIdentificativo] ASC, [OrigineSistema] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Certificazione].[ProgrammaCertificazioneIdentificativoStorico], DATA_CONSISTENCY_CHECK=ON));


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificativi legacy, import o alternativi associati a un programma di certificazione.', @level0type = N'SCHEMA', @level0name = N'Certificazione', @level1type = N'TABLE', @level1name = N'ProgrammaCertificazioneIdentificativo';


GO

