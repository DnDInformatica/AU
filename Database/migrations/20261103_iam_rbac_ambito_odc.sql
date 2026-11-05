/*
    20261103_iam_rbac_ambito_odc.sql
    Database di destinazione: **Accredia_SIDAC**

    RBAC con ambito per gli utenti degli organismi (Portale OdC).

    PERCHE'. IAM.UtenteOdC portava il ruolo come testo libero (RuoloOdC:
    ADMIN_ODC, OPERATORE, READONLY) senza legame con IAM.RuoloSistema: dal ruolo
    assegnato su un organismo non si arrivava ai permessi, se non con una
    traduzione scritta nel codice di ogni applicazione. Due verita' sullo stesso
    utente. Ora UtenteOdC punta a RuoloSistema e i permessi restano dove sono gia',
    in IAM.RuoloPermesso.

    COSA FA
    1. RuoloSistema.AmbitoRuolo (GLOBALE | ODC). GLOBALE si assegna in
       UtenteRuolo, ODC si assegna per organismo in UtenteOdC. I tre ruoli
       ODC_* passano ad ambito ODC.
    2. UtenteOdC: RuoloSistemaId al posto di RuoloOdC, con chiave esterna,
       unicita' dell'assegnazione attiva e indice ricostruito.
    3. Trigger di coerenza tra ambito del ruolo e tabella di assegnazione
       (stesso schema di TR_SedeIdentificativoEsterno_Ambito).
    4. Catalogo: permessi CERT.PUBLISH e ORG.REFERENTI.MANAGE e matrice dei
       ruoli ODC concordata il 2026-11-03.

    PRECONDIZIONE. UtenteOdC e UtenteOdCStorico vuote (verificato il
    2026-11-03: 0 righe). Se non lo sono lo script si ferma: servirebbe una
    migrazione dei dati da RuoloOdC, qui non prevista.

    COMPATIBILITA'. Nessun codice SIGAD legge RuoloOdC (IamUserScopeResolver
    legge solo OrganizzazioneOdCId). Le definizioni allineate sono in
    Database/src/IAM/Tables.

    Da eseguire in SSMS, non tramite MCP. Rieseguibile.
*/

SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

IF DB_NAME() <> N'Accredia_SIDAC'
BEGIN
    DECLARE @dbCorrente SYSNAME = DB_NAME();
    RAISERROR (N'Script destinato ad Accredia_SIDAC, eseguito su %s. Interrotto.', 16, 1, @dbCorrente);
    RETURN;
END
GO

/* ---------------------------------------------------------------------------
   1. RuoloSistema.AmbitoRuolo
--------------------------------------------------------------------------- */
IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF COL_LENGTH(N'IAM.RuoloSistema', N'AmbitoRuolo') IS NULL
BEGIN
    ALTER TABLE [IAM].[RuoloSistema]
        ADD [AmbitoRuolo] NVARCHAR (20) NOT NULL
            CONSTRAINT [DF_RuoloSistema_AmbitoRuolo] DEFAULT (N'GLOBALE');
END
GO

IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF OBJECT_ID(N'IAM.CK_RuoloSistema_AmbitoRuolo', N'C') IS NULL
    ALTER TABLE [IAM].[RuoloSistema]
        ADD CONSTRAINT [CK_RuoloSistema_AmbitoRuolo] CHECK ([AmbitoRuolo]=N'GLOBALE' OR [AmbitoRuolo]=N'ODC');

UPDATE [IAM].[RuoloSistema]
SET    AmbitoRuolo  = N'ODC',
       DataModifica = SYSUTCDATETIME()
WHERE  CodiceRuolo IN (N'ODC_AMMINISTRATORE', N'ODC_OPERATORE', N'ODC_LETTURA')
  AND  AmbitoRuolo <> N'ODC';
GO

/* ---------------------------------------------------------------------------
   2. UtenteOdC: RuoloSistemaId al posto di RuoloOdC
--------------------------------------------------------------------------- */
IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF COL_LENGTH(N'IAM.UtenteOdC', N'RuoloOdC') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM [IAM].[UtenteOdC]) OR EXISTS (SELECT 1 FROM [IAM].[UtenteOdCStorico])
        THROW 52310, N'IAM.UtenteOdC o il suo storico contengono righe: serve una migrazione dei dati da RuoloOdC. Interrotto.', 1;

    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'IAM.UtenteOdC') AND name = N'IX_UtenteOdC_OdC')
        DROP INDEX [IX_UtenteOdC_OdC] ON [IAM].[UtenteOdC];

    IF OBJECT_ID(N'IAM.CK_UtenteOdC_RuoloOdC', N'C') IS NOT NULL
        ALTER TABLE [IAM].[UtenteOdC] DROP CONSTRAINT [CK_UtenteOdC_RuoloOdC];

    -- Con SYSTEM_VERSIONING attivo DROP e ADD si propagano allo storico.
    ALTER TABLE [IAM].[UtenteOdC] DROP COLUMN [RuoloOdC];

    -- Default provvisorio: la tabella e' vuota, serve solo a rendere l'ADD
    -- NOT NULL accettabile anche sullo storico. Rimosso subito dopo.
    ALTER TABLE [IAM].[UtenteOdC]
        ADD [RuoloSistemaId] INT NOT NULL
            CONSTRAINT [DF_UtenteOdC_RuoloSistemaId_Migrazione] DEFAULT (0);

    ALTER TABLE [IAM].[UtenteOdC] DROP CONSTRAINT [DF_UtenteOdC_RuoloSistemaId_Migrazione];

    COMMIT TRANSACTION;
END
GO

IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

IF OBJECT_ID(N'IAM.FK_UtenteOdC_RuoloSistema', N'F') IS NULL
    ALTER TABLE [IAM].[UtenteOdC]
        ADD CONSTRAINT [FK_UtenteOdC_RuoloSistema] FOREIGN KEY ([RuoloSistemaId])
            REFERENCES [IAM].[RuoloSistema] ([RuoloSistemaId]);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'IAM.UtenteOdC') AND name = N'IX_UtenteOdC_OdC')
    CREATE NONCLUSTERED INDEX [IX_UtenteOdC_OdC]
        ON [IAM].[UtenteOdC]([OrganizzazioneOdCId] ASC, [RuoloSistemaId] ASC)
        WHERE ([DataCancellazione] IS NULL AND [Attivo]=(1));

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'IAM.UtenteOdC') AND name = N'UX_UtenteOdC_Assegnazione')
    CREATE UNIQUE NONCLUSTERED INDEX [UX_UtenteOdC_Assegnazione]
        ON [IAM].[UtenteOdC]([UtenteId] ASC, [OrganizzazioneOdCId] ASC, [RuoloSistemaId] ASC, [ScopoSchemaId] ASC)
        WHERE ([DataCancellazione] IS NULL);
GO

/* ---------------------------------------------------------------------------
   3. Coerenza tra ambito del ruolo e tabella di assegnazione
--------------------------------------------------------------------------- */
CREATE OR ALTER TRIGGER IAM.TR_UtenteOdC_Ambito ON IAM.UtenteOdC AFTER INSERT,UPDATE AS
BEGIN SET NOCOUNT ON; IF EXISTS(SELECT 1 FROM inserted i JOIN IAM.RuoloSistema r ON r.RuoloSistemaId=i.RuoloSistemaId WHERE r.AmbitoRuolo<>N'ODC') THROW 52301,N'Ruolo non assegnabile su un organismo: AmbitoRuolo deve essere ODC.',1; END;
GO

CREATE OR ALTER TRIGGER IAM.TR_UtenteRuolo_Ambito ON IAM.UtenteRuolo AFTER INSERT,UPDATE AS
BEGIN SET NOCOUNT ON; IF EXISTS(SELECT 1 FROM inserted i JOIN IAM.RuoloSistema r ON r.RuoloSistemaId=i.RuoloSistemaId WHERE r.AmbitoRuolo<>N'GLOBALE') THROW 52302,N'Ruolo con ambito ODC: va assegnato per organismo in IAM.UtenteOdC.',1; END;
GO

CREATE OR ALTER TRIGGER IAM.TR_RuoloSistema_Ambito ON IAM.RuoloSistema AFTER UPDATE AS
BEGIN SET NOCOUNT ON; IF UPDATE(AmbitoRuolo) AND (EXISTS(SELECT 1 FROM inserted i JOIN IAM.UtenteOdC uo ON uo.RuoloSistemaId=i.RuoloSistemaId AND uo.DataCancellazione IS NULL WHERE i.AmbitoRuolo<>N'ODC') OR EXISTS(SELECT 1 FROM inserted i JOIN IAM.UtenteRuolo ur ON ur.RuoloSistemaId=i.RuoloSistemaId AND ur.DataCancellazione IS NULL WHERE i.AmbitoRuolo<>N'GLOBALE')) THROW 52303,N'AmbitoRuolo incompatibile con le assegnazioni esistenti del ruolo.',1; END;
GO

/* ---------------------------------------------------------------------------
   Proprieta' estese allineate al progetto database
--------------------------------------------------------------------------- */
IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

EXECUTE sp_updateextendedproperty @name = N'Accredia.Policy', @value = N'{"schema":"IAM","table":"UtenteOdC","temporal":true,"temporal_type":2,"history_table":"IAM.UtenteOdCStorico","soft_delete":true,"audit":true,"ruoli":"IAM.RuoloSistema con AmbitoRuolo=ODC","scope_fk_logica":"Standard.SchemaAccreditamento.SchemaAccreditamentoId"}', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteOdC';

EXECUTE sp_updateextendedproperty @name = N'MS_Description', @value = N'Associazione utente esterno con OdC e ruolo di accesso. RuoloSistemaId punta a un ruolo con AmbitoRuolo=ODC: i permessi validi sull organismo sono quelli del ruolo in IAM.RuoloPermesso. ScopoSchemaId restringe la delega a uno schema di accreditamento specifico (NULL = tutti gli schemi).', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'UtenteOdC';

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
               WHERE major_id = OBJECT_ID(N'IAM.RuoloSistema') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'IAM.RuoloSistema'), N'AmbitoRuolo', 'ColumnId') AND name = N'MS_Description')
    EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'AmbitoRuolo: GLOBALE si assegna in IAM.UtenteRuolo, ODC si assegna per organismo in IAM.UtenteOdC.', @level0type = N'SCHEMA', @level0name = N'IAM', @level1type = N'TABLE', @level1name = N'RuoloSistema', @level2type = N'COLUMN', @level2name = N'AmbitoRuolo';
GO

/* ---------------------------------------------------------------------------
   4. Catalogo: permessi del Portale e matrice dei ruoli ODC (2026-11-03)

   | Azione                                  | AMMINISTRATORE | OPERATORE | LETTURA |
   | Consultare certificati e accreditamento |       x        |     x     |    x    |
   | Caricare file ODS            CERT.CREATE |       x        |     x     |         |
   | Correggere righe scartate    CERT.UPDATE |       x        |     x     |         |
   | Confermare e pubblicare     CERT.PUBLISH |       x        |     x     |         |
   | Gestire i referenti ORG.REFERENTI.MANAGE |       x        |           |         |

   SIGAD_SUPERADMIN riceve i nuovi permessi: per convenzione ha l'intero
   catalogo (IdentitySeeder).
--------------------------------------------------------------------------- */
IF DB_NAME() <> N'Accredia_SIDAC' RETURN;

BEGIN TRANSACTION;

INSERT INTO [IAM].[Permesso] (Codice, Descrizione, Modulo, Ambito)
SELECT v.Codice, v.Descrizione, v.Modulo, v.Ambito
FROM (VALUES
    (N'CERT.PUBLISH',         N'Conferma e pubblicazione dei caricamenti di certificazioni', N'CERT', N'ACTION'),
    (N'ORG.REFERENTI.MANAGE', N'Gestione dei referenti dell organismo',                       N'ORG',  N'ACTION')
) AS v (Codice, Descrizione, Modulo, Ambito)
WHERE NOT EXISTS (SELECT 1 FROM [IAM].[Permesso] p WHERE p.Codice = v.Codice);

DECLARE @Matrice TABLE (CodiceRuolo NVARCHAR (100) NOT NULL, CodicePermesso NVARCHAR (200) NOT NULL);
INSERT INTO @Matrice (CodiceRuolo, CodicePermesso) VALUES
    (N'ODC_AMMINISTRATORE', N'CERT.PUBLISH'),
    (N'ODC_AMMINISTRATORE', N'ORG.REFERENTI.MANAGE'),
    (N'ODC_OPERATORE',      N'CERT.UPDATE'),
    (N'ODC_OPERATORE',      N'CERT.PUBLISH'),
    (N'ODC_OPERATORE',      N'MODULE.ORG.ACCESS'),
    (N'ODC_OPERATORE',      N'ORG.READ'),
    (N'SIGAD_SUPERADMIN',   N'CERT.PUBLISH'),
    (N'SIGAD_SUPERADMIN',   N'ORG.REFERENTI.MANAGE');

IF EXISTS (SELECT 1 FROM @Matrice m
           WHERE NOT EXISTS (SELECT 1 FROM [IAM].[RuoloSistema] r WHERE r.CodiceRuolo = m.CodiceRuolo)
              OR NOT EXISTS (SELECT 1 FROM [IAM].[Permesso] p WHERE p.Codice = m.CodicePermesso))
    THROW 52311, N'Ruolo o permesso della matrice assente dal catalogo. Interrotto.', 1;

-- Assegnazioni annullate in passato: si riattivano, non si duplicano.
UPDATE rp
SET    DataCancellazione = NULL,
       CancellatoDa      = NULL
FROM   [IAM].[RuoloPermesso] rp
JOIN   [IAM].[RuoloSistema] r ON r.RuoloSistemaId = rp.RuoloSistemaId
JOIN   [IAM].[Permesso]     p ON p.PermessoId     = rp.PermessoId
JOIN   @Matrice             m ON m.CodiceRuolo = r.CodiceRuolo AND m.CodicePermesso = p.Codice
WHERE  rp.DataCancellazione IS NOT NULL;

INSERT INTO [IAM].[RuoloPermesso] (RuoloSistemaId, PermessoId)
SELECT r.RuoloSistemaId, p.PermessoId
FROM   @Matrice m
JOIN   [IAM].[RuoloSistema] r ON r.CodiceRuolo = m.CodiceRuolo
JOIN   [IAM].[Permesso]     p ON p.Codice      = m.CodicePermesso
WHERE  NOT EXISTS (SELECT 1 FROM [IAM].[RuoloPermesso] rp
                   WHERE rp.RuoloSistemaId = r.RuoloSistemaId AND rp.PermessoId = p.PermessoId);

COMMIT TRANSACTION;
GO

/* ---------------------------------------------------------------------------
   Verifica: matrice risultante dei ruoli con ambito ODC
--------------------------------------------------------------------------- */
SELECT r.CodiceRuolo, r.AmbitoRuolo, p.Codice AS Permesso
FROM   [IAM].[RuoloSistema] r
JOIN   [IAM].[RuoloPermesso] rp ON rp.RuoloSistemaId = r.RuoloSistemaId AND rp.DataCancellazione IS NULL
JOIN   [IAM].[Permesso]      p  ON p.PermessoId      = rp.PermessoId    AND p.DataCancellazione  IS NULL
WHERE  r.AmbitoRuolo = N'ODC'
ORDER BY r.CodiceRuolo, p.Codice;
GO
