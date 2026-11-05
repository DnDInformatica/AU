CREATE TABLE [Organi].[OrganoCollegiale] (
    [OrganoCollegialeId]      INT                                         IDENTITY (1, 1) NOT NULL,
    [TipoOrganoCollegialeId]  INT                                         NOT NULL,
    [Codice]                  NVARCHAR (50)                               NOT NULL,
    [Denominazione]           NVARCHAR (500)                              NOT NULL,
    [OrganoCollegialePadreId] INT                                         NULL,
    [DipartimentoAccrediaId]  INT                                         NULL,
    [AttoCostitutivo]         NVARCHAR (500)                              NULL,
    [DataCostituzione]        DATE                                        NULL,
    [DataCessazione]          DATE                                        NULL,
    [Note]                    NVARCHAR (2000)                             NULL,
    [Attivo]                  BIT                                         CONSTRAINT [DF_OrganoCollegiale_Attivo] DEFAULT ((1)) NOT NULL,
    [DataCreazione]           DATETIME2 (7)                               CONSTRAINT [DF_OrganoCollegiale_DataCreazione] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatoDa]                INT                                         NULL,
    [DataModifica]            DATETIME2 (7)                               NULL,
    [ModificatoDa]            INT                                         NULL,
    [DataCancellazione]       DATETIME2 (7)                               NULL,
    [CancellatoDa]            INT                                         NULL,
    [UniqueRowId]             UNIQUEIDENTIFIER                            CONSTRAINT [DF_OrganoCollegiale_UniqueRowId] DEFAULT (newid()) NOT NULL,
    [DataInizioValidita]      DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [DataFineValidita]        DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [PK_OrganoCollegiale] PRIMARY KEY CLUSTERED ([OrganoCollegialeId] ASC),
    CONSTRAINT [CK_OrganoCollegiale_Cessazione] CHECK ([DataCessazione] IS NULL OR [DataCostituzione] IS NULL OR [DataCessazione]>=[DataCostituzione]),
    CONSTRAINT [CK_OrganoCollegiale_PadreNonAutoreferenziale] CHECK ([OrganoCollegialePadreId] IS NULL OR [OrganoCollegialePadreId]<>[OrganoCollegialeId]),
    CONSTRAINT [FK_OrganoCollegiale_DipartimentoAccredia] FOREIGN KEY ([DipartimentoAccrediaId]) REFERENCES [Tipologica].[DipartimentoAccredia] ([DipartimentoAccrediaId]),
    CONSTRAINT [FK_OrganoCollegiale_Padre] FOREIGN KEY ([OrganoCollegialePadreId]) REFERENCES [Organi].[OrganoCollegiale] ([OrganoCollegialeId]),
    CONSTRAINT [FK_OrganoCollegiale_TipoOrganoCollegiale] FOREIGN KEY ([TipoOrganoCollegialeId]) REFERENCES [Tipologica].[TipoOrganoCollegiale] ([TipoOrganoCollegialeId]),
    CONSTRAINT [UQ_OrganoCollegiale_Codice] UNIQUE NONCLUSTERED ([Codice] ASC),
    PERIOD FOR SYSTEM_TIME ([DataInizioValidita], [DataFineValidita])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Organi].[OrganoCollegialeStorico], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_OrganoCollegiale_DataCancellazione]
    ON [Organi].[OrganoCollegiale]([OrganoCollegialeId] ASC) WHERE ([DataCancellazione] IS NULL);


GO

CREATE NONCLUSTERED INDEX [IX_OrganoCollegiale_CreatoDa]
    ON [Organi].[OrganoCollegiale]([CreatoDa] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_OrganoCollegiale_TipoOrganoCollegialeId]
    ON [Organi].[OrganoCollegiale]([TipoOrganoCollegialeId] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.TableType', @value = N'ANAGRAFICA', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;FK;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di costituzione dell''organo.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Denominazione estesa dell''organo come riportata negli atti e nei verbali.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento all''atto con cui l''organo e stato costituito. Il numero e le competenze dei Comitati e SottoComitati Settoriali sono deliberati dal Consiglio Direttivo (RG-04 rev.06 art. 4).', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AttoCostitutivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dipartimento di competenza dell''organo, per i Comitati Settoriali articolati per Dipartimento. NULL per gli organi trasversali quali il Consiglio Direttivo e il Comitato di Indirizzo e Garanzia.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organo di livello superiore, valorizzato per i SottoComitati Settoriali che sono articolazioni di un Comitato Settoriale. Autoreferenza vincolata da CK_OrganoCollegiale_PadreNonAutoreferenziale.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialePadreId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato la cancellazione logica.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AttoCostitutivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialePadreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;FK;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di cancellazione logica (soft-delete).', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"ModificatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica se l''organo e selezionabile per nuove convocazioni. Gli organi disattivati restano referenziabili dagli eventi e dalle composizioni storiche.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"CancellatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialePadreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificatore univoco globale del record, per riconciliazione tra sistemi distribuiti.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AttoCostitutivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Istanze concrete degli organi collegiali di ACCREDIA: il Comitato per l''Attivita di Accreditamento, i singoli Comitati e SottoComitati Settoriali, la Commissione d''Appello, il Consiglio Direttivo, il Comitato di Indirizzo e Garanzia. Distingue l''organo come entita istituzionale, dotata di identita e continuita nel tempo, dalla singola seduta registrata in Eventi.Evento. E la tabella che consente di identificare le parti partecipanti ai comitati coinvolti nel processo di accreditamento, come richiesto da ISO/IEC 17011 par. 4.2.7.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo dell''organo, da cui discendono quorum, base di calcolo delle maggioranze, regime di delega e cooptazione. FK verso Tipologica.TipoOrganoCollegiale.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;TemporalCurrent;SoftDelete;Audit', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di cessazione dell''organo. NULL se l''organo e tuttora operante. Vincolata a non precedere DataCostituzione.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"DataCancellazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice stabile dell''organo, usato come business key e nelle integrazioni. Immutabile una volta pubblicato.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Chiave primaria surrogata dell''organo. Identity, senza significato di business.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Annotazioni libere sull''organo, ad esempio variazioni di perimetro di competenza non desumibili dagli altri campi.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"TipoOrganoCollegialeId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.TipoOrganoCollegiale.TipoOrganoCollegialeId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"Note","data_type":"nvarchar","max_length":4000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC dell''ultima modifica del record.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialePadreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AttoCostitutivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"Attivo","data_type":"bit","max_length":1,"precision":1,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"DataCostituzione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"OrganoCollegialePadreId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Organi.OrganoCollegiale.OrganoCollegialeId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialePadreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"AttoCostitutivo","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AttoCostitutivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"DipartimentoAccrediaId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":true,"fk_ref":"Tipologica.DipartimentoAccredia.DipartimentoAccrediaId","audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp UTC di creazione del record.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"Codice","data_type":"nvarchar","max_length":100,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha creato il record.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"DataCessazione","data_type":"date","max_length":3,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"UniqueRowId","data_type":"uniqueidentifier","max_length":16,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;NotNull', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"Denominazione","data_type":"nvarchar","max_length":1000,"precision":0,"scale":0,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inizio del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCostituzione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Denominazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Attivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'AttoCostitutivo';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialePadreId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"CreatoDa","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CreatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID utente che ha effettuato l''ultima modifica.', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'ModificatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Note';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"DataModifica","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":true,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"DataFineValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataModifica';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'CancellatoDa';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fine del periodo di validita della versione di riga (colonna di periodo SYSTEM_TIME, generata dal motore).', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"DataCreazione","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":true,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCreazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Codice';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'UniqueRowId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataFineValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"DataInizioValidita","data_type":"datetime2","max_length":8,"precision":27,"scale":7,"nullable":false,"identity":false,"is_pk":false,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":true,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataInizioValidita';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCessazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"Organi","table":"OrganoCollegiale","column":"OrganoCollegialeId","data_type":"int","max_length":4,"precision":10,"scale":0,"nullable":false,"identity":true,"is_pk":true,"is_fk":false,"fk_ref":null,"audit_column":false,"temporal_period_column":false,"pii_class":"NonPII"}', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'OrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DipartimentoAccrediaId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'TipoOrganoCollegialeId';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Tags', @value = N'Schema:Organi;Table:OrganoCollegiale;Nullable', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'DataCancellazione';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.08', @level0type = N'SCHEMA', @level0name = N'Organi', @level1type = N'TABLE', @level1name = N'OrganoCollegiale', @level2type = N'COLUMN', @level2name = N'Note';


GO

