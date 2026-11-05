-- ================================================================================
-- ImportSIAC.usp_BH_01_Cleanup
-- Estratto dal monolite usp_BuildHistory_All (step 01_CLEANUP).
-- Droppa le work table di lavoro PRIMA di ogni run, TRANNE quelle protette
-- da un checkpoint valido (cosi' i passi successivi possono skippare in sicurezza).
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_01_Cleanup
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,1,N'01_CLEANUP',N'Cleanup temp',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        -- Tabelle sempre droppate (nessun checkpoint le protegge: sono intermedie/rigenerate ogni volta)
        DROP TABLE IF EXISTS ImportSIAC.wrk_NormaRawDistinct;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteKeyDistinct;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SedeKeyDistinct;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SedeL2Map;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Sede_SigBase;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Sede_Changes;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Skipped;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SigBase;
        DROP TABLE IF EXISTS ImportSIAC.wrk_Changes;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SG_SigBase;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SG_Changes;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PRD_SigBase;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PRD_Changes;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_SigBase;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_Changes;
        -- MIG_117: cleanup non elimina PersonaMap senza valutare checkpoint
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaByFiscalCode;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaByNaturalKey;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaUnresolved;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_RawUltimo;
        DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaDistinct;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PRD_OrgDaCensire;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PP_OrgDaCensire;
        DROP TABLE IF EXISTS ImportSIAC.wrk_SG_OrgDaCensire;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ESTERO_OrgDaCensire;
        DROP TABLE IF EXISTS ImportSIAC.wrk_PivaNullResidua;

        -- Tabelle protette da checkpoint: droppate SOLO se il checkpoint non e' valido
        IF ImportSIAC.fn_BH_Checkpoint_IsValid(N'02_NORMA_MAP') = 0
            DROP TABLE IF EXISTS ImportSIAC.wrk_NormaMap;
        IF ImportSIAC.fn_BH_Checkpoint_IsValid(N'04B_CLIENTE_MAP') = 0
            DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteMap;
        IF ImportSIAC.fn_BH_Checkpoint_IsValid(N'05_RESOLVE') = 0
            DROP TABLE IF EXISTS ImportSIAC.wrk_All_Resolved;
        IF ImportSIAC.fn_BH_Checkpoint_IsValid(N'05B_SEDE_MAP') = 0
        BEGIN
            DROP TABLE IF EXISTS ImportSIAC.wrk_SedeMap;
            DROP TABLE IF EXISTS ImportSIAC.wrk_PP_Sedi_Raw;
        END;
        IF ImportSIAC.fn_BH_Checkpoint_IsValid(N'06_DEDUP') = 0
            DROP TABLE IF EXISTS ImportSIAC.wrk_MonthlyBest;
        IF ImportSIAC.fn_BH_Checkpoint_IsValid(N'07_SCD2_PARENT') = 0
            DROP TABLE IF EXISTS ImportSIAC.wrk_All_Final;
        IF ImportSIAC.fn_BH_Checkpoint_IsValid(N'08_SCD2_CHILDREN') = 0
        BEGIN
            DROP TABLE IF EXISTS ImportSIAC.wrk_SG_Final;
            DROP TABLE IF EXISTS ImportSIAC.wrk_PRD_Final;
            DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_Final;
            DROP TABLE IF EXISTS ImportSIAC.wrk_Sede_Final;
        END;

        -- MIG_117: protezione checkpoint 09 PersonaMap
        IF ImportSIAC.fn_BH_Checkpoint_IsValid(N'09_PERSONE') = 0
            DROP TABLE IF EXISTS ImportSIAC.wrk_FPC_PersonaMap;

        SET @RowsAffected = 0;
        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=0
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 01_CLEANUP: ', 0);
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'FAILED', ErrorMessage=@ErrMsg
        WHERE BuildHistoryStepLogId=@StepLogId;
        THROW;
    END CATCH;
END;

GO

