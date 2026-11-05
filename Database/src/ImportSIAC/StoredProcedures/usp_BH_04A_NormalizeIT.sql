-- ================================================================================
-- ImportSIAC.usp_BH_04A_NormalizeIT
-- Estratto dal monolite (step 04A_NORMALIZE_IT). Normalizza fiscal_code/vat_number
-- che hanno prefisso 'IT' + 11 cifre (13 char totali) rimuovendo il prefisso.
-- Modifica wrk_All_Src IN PLACE (idempotente per natura: pattern gia' sistemati
-- non fanno piu' match). Checkpoint basato sul conteggio di wrk_All_Src stesso.
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_04A_NormalizeIT
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;

    -- CHECKPOINT: skip se gia' eseguito su questa stessa wrk_All_Src (stesso conteggio)
    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'04A_NORMALIZE_IT', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        SET @RowsAffected = 0;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,4,N'04A_NORMALIZE_IT',N'Strip prefisso IT (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',0,N'RESUMED da checkpoint: wrk_All_Src invariata, normalizzazione gia eseguita.');
        PRINT CONCAT('STEP 04A_NORMALIZE_IT: RESUMED, ', 0);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,4,N'04A_NORMALIZE_IT',N'Strip prefisso IT',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        DECLARE @NormIT_FC INT = 0, @NormIT_VN INT = 0;
        DECLARE @NormIT_Changes TABLE (ChangedFC BIT NOT NULL, ChangedVN BIT NOT NULL);

        ;WITH Candidates AS (
            SELECT
                fiscal_code,
                vat_number,
                REPLACE(UPPER(LTRIM(RTRIM(fiscal_code))), ' ', '') AS fiscal_code_norm,
                REPLACE(UPPER(LTRIM(RTRIM(vat_number))),  ' ', '') AS vat_number_norm
            FROM ImportSIAC.wrk_All_Src
            WHERE Dominio IN ('PP','PRD')
              AND (
                  fiscal_code LIKE '%[iI][tT]%'
                  OR vat_number LIKE '%[iI][tT]%'
              )
        ),
        ToNormalize AS (
            SELECT
                fiscal_code,
                vat_number,
                CASE
                    WHEN fiscal_code_norm LIKE 'IT[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
                     AND LEN(fiscal_code_norm) = 13
                        THEN SUBSTRING(fiscal_code_norm, 3, 11)
                    ELSE fiscal_code
                END AS fiscal_code_new,
                CASE
                    WHEN vat_number_norm LIKE 'IT[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
                     AND LEN(vat_number_norm) = 13
                        THEN SUBSTRING(vat_number_norm, 3, 11)
                    ELSE vat_number
                END AS vat_number_new
            FROM Candidates
            WHERE (fiscal_code_norm LIKE 'IT[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND LEN(fiscal_code_norm) = 13)
               OR (vat_number_norm  LIKE 'IT[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND LEN(vat_number_norm) = 13)
        )
        UPDATE ToNormalize
            SET fiscal_code = fiscal_code_new,
                vat_number  = vat_number_new
        OUTPUT
            CASE WHEN ISNULL(deleted.fiscal_code, N'') <> ISNULL(inserted.fiscal_code, N'') THEN 1 ELSE 0 END,
            CASE WHEN ISNULL(deleted.vat_number,  N'') <> ISNULL(inserted.vat_number,  N'') THEN 1 ELSE 0 END
        INTO @NormIT_Changes (ChangedFC, ChangedVN);

        SELECT
            @NormIT_FC = COALESCE(SUM(CASE WHEN ChangedFC = 1 THEN 1 ELSE 0 END), 0),
            @NormIT_VN = COALESCE(SUM(CASE WHEN ChangedVN = 1 THEN 1 ELSE 0 END), 0)
        FROM @NormIT_Changes;

        SET @Rows = @NormIT_FC + @NormIT_VN;
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 04A_NORMALIZE_IT: ', @Rows);

        DECLARE @SrcRows BIGINT = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_All_Src);
        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'04A_NORMALIZE_IT', @OutputTable=N'ImportSIAC.wrk_All_Src',
            @RowCountAtSave=@SrcRows, @Notes=N'Normalizzazione prefisso IT su fiscal_code/vat_number (in place).';
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

