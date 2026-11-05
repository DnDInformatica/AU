-- IGNORE_DUP_KEY = ON e' richiesto da Hangfire 1.8: dallo schema 9 il client
-- scrive su questa tabella con INSERT semplici al posto di MERGE e conta sul
-- database per scartare i duplicati in silenzio. Con l'opzione spenta il
-- RecurringJobScheduler falliva con violazione di PK a ogni ciclo.
-- Non rimuovere: l'installer di Hangfire non la ripristina se Schema.Version
-- e' gia' 9, quindi un Publish che la togliesse riaprirebbe il guasto.
CREATE TABLE [HangFire].[Hash] (
    [Key]      NVARCHAR (100) NOT NULL,
    [Field]    NVARCHAR (100) NOT NULL,
    [Value]    NVARCHAR (MAX) NULL,
    [ExpireAt] DATETIME2 (7)  NULL,
    CONSTRAINT [PK_HangFire_Hash] PRIMARY KEY CLUSTERED ([Key] ASC, [Field] ASC) WITH (IGNORE_DUP_KEY = ON)
);


GO

CREATE NONCLUSTERED INDEX [IX_HangFire_Hash_ExpireAt]
    ON [HangFire].[Hash]([ExpireAt] ASC) WHERE ([ExpireAt] IS NOT NULL);


GO

