CREATE   PROCEDURE ImportSIAC.usp_BH_00_WakeStaging
    @BuildHistoryLogId INT,
    @MaxTentativi INT = 5,
    @RowsAffected BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT;
    DECLARE @Tentativo INT = 1;
    DECLARE @Riuscito BIT = 0;
    DECLARE @UltimoErrore NVARCHAR(4000);
    DECLARE @Test INT;
    DECLARE @AttesaSec INT;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,0,N'00_WAKE_STAGING',N'Risveglio staging serverless',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    WHILE @Tentativo <= @MaxTentativi AND @Riuscito = 0
    BEGIN
        BEGIN TRY
            SELECT TOP 1 @Test = 1 FROM ImportSIAC.Ext_PP_Flat;
            SET @Riuscito = 1;
        END TRY
        BEGIN CATCH
            SET @UltimoErrore = LEFT(CONCAT(N'Tentativo ',@Tentativo,'/',@MaxTentativi,' fallito: ERR ',ERROR_NUMBER(),': ',ERROR_MESSAGE()),4000);
            PRINT @UltimoErrore;

            IF @Tentativo < @MaxTentativi
            BEGIN
                SET @AttesaSec = 10 * @Tentativo;
                WAITFOR DELAY '00:00:10';
                IF @AttesaSec > 10
                BEGIN
                    DECLARE @DelayStr VARCHAR(8) = CONCAT('00:00:', RIGHT('0'+CAST((@AttesaSec-10) AS VARCHAR(2)),2));
                    WAITFOR DELAY @DelayStr;
                END;
            END;
        END CATCH
        SET @Tentativo = @Tentativo + 1;
    END;

    IF @Riuscito = 0
    BEGIN
        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'FAILED', ErrorMessage=@UltimoErrore
        WHERE BuildHistoryStepLogId=@StepLogId;
        THROW 51400, 'Staging non risponde dopo tutti i tentativi di risveglio. Vedi log per dettagli.', 1;
    END;

    SET @RowsAffected = @Tentativo - 1;
    UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
        DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
        Status=N'SUCCESS', RowsAffected=@RowsAffected,
        ExtraInfo=CONCAT('Staging svegliato al tentativo ', @RowsAffected)
    WHERE BuildHistoryStepLogId=@StepLogId;
    PRINT CONCAT('STEP 00_WAKE_STAGING: riuscito al tentativo ', @RowsAffected);
END;

GO

