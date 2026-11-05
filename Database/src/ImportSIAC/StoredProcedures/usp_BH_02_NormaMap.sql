CREATE   PROCEDURE ImportSIAC.usp_BH_02_NormaMap
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;

    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check
        @StepCode=N'02_NORMA_MAP', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;

    IF @CkValid = 1
    BEGIN
        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_NormaMap);
        SET @RowsAffected = @Rows;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,
             DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES
            (@BuildHistoryLogId,2,N'02_NORMA_MAP',N'Mappa norme (RESUMED)',
             SYSUTCDATETIME(),SYSUTCDATETIME(),0,N'SUCCESS',@Rows,
             N'RESUMED da checkpoint: wrk_NormaMap gia valida.');
        PRINT CONCAT('STEP 02_NORMA_MAP: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog
        (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES
        (@BuildHistoryLogId,2,N'02_NORMA_MAP',N'Mappa norme',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        DROP TABLE IF EXISTS ImportSIAC.wrk_NormaRawDistinct;
        DROP TABLE IF EXISTS ImportSIAC.wrk_NormaMap;

        SELECT DISTINCT norma_raw
        INTO ImportSIAC.wrk_NormaRawDistinct
        FROM ImportSIAC.wrk_All_Src
        WHERE norma_raw IS NOT NULL
          AND LTRIM(RTRIM(norma_raw)) <> N'';

        CREATE UNIQUE CLUSTERED INDEX CX_NormaRawDistinct
            ON ImportSIAC.wrk_NormaRawDistinct (norma_raw);

        SELECT
            d.norma_raw,
            COALESCE(
                MIN(na.NormaAccreditamentoId),
                MIN(fpc.NormaAccreditamentoId),
                MIN(map.TargetNormaAccreditamentoId)
            ) AS NormaAccreditamentoId
        INTO ImportSIAC.wrk_NormaMap
        FROM ImportSIAC.wrk_NormaRawDistinct d
        LEFT JOIN Standard.NormaAccreditamento na
            ON na.DataCancellazione IS NULL
           AND na.Attivo = 1
           AND (na.Codice = d.norma_raw OR na.Riferimento = d.norma_raw)
        LEFT JOIN ImportSIAC.NormaFPCMap fpc
            ON fpc.NormCodeSiac = d.norma_raw
        LEFT JOIN ImportSIAC.MapNormaAccreditamento map
            ON map.IsApproved = 1
           AND map.SourceValue = d.norma_raw COLLATE Latin1_General_CS_AS
           AND map.TargetNormaAccreditamentoId IS NOT NULL
        GROUP BY d.norma_raw;

        CREATE UNIQUE CLUSTERED INDEX CX_NormaMap
            ON ImportSIAC.wrk_NormaMap (norma_raw);

        DROP TABLE ImportSIAC.wrk_NormaRawDistinct;
        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_NormaMap);
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog
        SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;

        PRINT CONCAT('STEP 02_NORMA_MAP: ', @Rows);

        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'02_NORMA_MAP',
            @OutputTable=N'ImportSIAC.wrk_NormaMap',
            @RowCountAtSave=@Rows,
            @Notes=N'Mappa norme: diretta + FPC + tutti i mapping con IsApproved=1.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) =
            LEFT(CONCAT(N'ERR ',ERROR_NUMBER(),N': ',ERROR_MESSAGE()),4000);
        UPDATE ImportSIAC.BuildHistory_StepLog
        SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'FAILED', ErrorMessage=@ErrMsg
        WHERE BuildHistoryStepLogId=@StepLogId;
        THROW;
    END CATCH;
END;

GO

