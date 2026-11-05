
CREATE   PROCEDURE Utilita.usp_ResetImportSIAC
    @FullReset  BIT           = 0,
    @Conferma   NVARCHAR(50)  = NULL
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRY

    /* ── Guardia full reset ──────────────────────────────────── */
    IF @FullReset = 1 AND ISNULL(@Conferma, N'') <> N'CONFERMO'
    BEGIN
        RAISERROR(N'[usp_ResetImportSIAC] Full reset richiede @Conferma = N''CONFERMO''.', 16, 1);
        RETURN 1;
    END;

    DECLARE @t0  DATETIME2 = SYSUTCDATETIME();
    DECLARE @msg NVARCHAR(500);
    PRINT CONCAT(N'=== usp_ResetImportSIAC avviata ', CONVERT(NVARCHAR(26), @t0, 121),
                 N' | FullReset=', @FullReset, N' ===');

    /* ── 1. ImportSIAC: wrk_ e log ───────────────────────────── */
    TRUNCATE TABLE ImportSIAC.wrk_All_Src;
    PRINT N'  TRUNCATE wrk_All_Src';

    TRUNCATE TABLE ImportSIAC.BuildHistory_ScartaOrganizzazione;
    PRINT N'  TRUNCATE BuildHistory_ScartaOrganizzazione';

    TRUNCATE TABLE ImportSIAC.BuildHistory_SkippedRow;
    PRINT N'  TRUNCATE BuildHistory_SkippedRow';

    DELETE FROM ImportSIAC.BuildHistory_StepLog;
    PRINT CONCAT(N'  DELETE BuildHistory_StepLog: ', @@ROWCOUNT, N' righe');

    DELETE FROM ImportSIAC.BuildHistory_Log;
    PRINT CONCAT(N'  DELETE BuildHistory_Log: ', @@ROWCOUNT, N' righe');

    /* ── 2. Full reset SIDAC (opzionale) ─────────────────────── */
    IF @FullReset = 1
    BEGIN
        PRINT N'[FullReset] Inizio pulizia entita SIDAC...';

        /* Disabilita versioning per TRUNCATE pulito */

        /* OrganizzazioneIdentificativoFiscale (dipende da Organizzazione) */
        ALTER TABLE Organizzazioni.OrganizzazioneIdentificativoFiscale
            SET (SYSTEM_VERSIONING = OFF);
        TRUNCATE TABLE Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico;
        TRUNCATE TABLE Organizzazioni.OrganizzazioneIdentificativoFiscale;
        ALTER TABLE Organizzazioni.OrganizzazioneIdentificativoFiscale
            SET (SYSTEM_VERSIONING = ON (
                HISTORY_TABLE = Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico,
                DATA_CONSISTENCY_CHECK = OFF));
        PRINT N'  TRUNCATE OrganizzazioneIdentificativoFiscale + Storico';

        /* Organizzazione */
        ALTER TABLE Organizzazioni.Organizzazione
            SET (SYSTEM_VERSIONING = OFF);
        TRUNCATE TABLE Organizzazioni.OrganizzazioneStorico;
        TRUNCATE TABLE Organizzazioni.Organizzazione;
        ALTER TABLE Organizzazioni.Organizzazione
            SET (SYSTEM_VERSIONING = ON (
                HISTORY_TABLE = Organizzazioni.OrganizzazioneStorico,
                DATA_CONSISTENCY_CHECK = OFF));
        PRINT N'  TRUNCATE Organizzazione + Storico';

        /* Persona */
        ALTER TABLE Persone.Persona
            SET (SYSTEM_VERSIONING = OFF);
        TRUNCATE TABLE Persone.PersonaStorico;
        TRUNCATE TABLE Persone.Persona;
        ALTER TABLE Persone.Persona
            SET (SYSTEM_VERSIONING = ON (
                HISTORY_TABLE = Persone.PersonaStorico,
                DATA_CONSISTENCY_CHECK = OFF));
        PRINT N'  TRUNCATE Persona + Storico';

        PRINT N'[FullReset] Completato.';
    END;

    PRINT CONCAT(N'=== usp_ResetImportSIAC COMPLETATA in ',
                 DATEDIFF(SECOND, @t0, SYSUTCDATETIME()), N's ===');
    RETURN 0;

END TRY
BEGIN CATCH
    DECLARE @err NVARCHAR(2048) = ERROR_MESSAGE();
    DECLARE @ln  INT            = ERROR_LINE();
    RAISERROR(N'[usp_ResetImportSIAC] Errore riga %d: %s', 16, 1, @ln, @err);
    RETURN 1;
END CATCH;

GO

