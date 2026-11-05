-- IGNORE_DUP_KEY = ON e' richiesto da Hangfire 1.8: dallo schema 9 il client
-- scrive su questa tabella con INSERT semplici al posto di MERGE e conta sul
-- database per scartare i duplicati in silenzio. Vedi nota in Hash.sql.
CREATE TABLE [HangFire].[Set] (
    [Key]      NVARCHAR (100) NOT NULL,
    [Score]    FLOAT (53)     NOT NULL,
    [Value]    NVARCHAR (256) NOT NULL,
    [ExpireAt] DATETIME       NULL,
    CONSTRAINT [PK_HangFire_Set] PRIMARY KEY CLUSTERED ([Key] ASC, [Value] ASC) WITH (IGNORE_DUP_KEY = ON)
);


GO

CREATE NONCLUSTERED INDEX [IX_HangFire_Set_ExpireAt]
    ON [HangFire].[Set]([ExpireAt] ASC) WHERE ([ExpireAt] IS NOT NULL);


GO

CREATE NONCLUSTERED INDEX [IX_HangFire_Set_Score]
    ON [HangFire].[Set]([Key] ASC, [Score] ASC);


GO

