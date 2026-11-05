CREATE   FUNCTION ImportSIAC.fn_BH_Checkpoint_IsValid(@StepCode nvarchar(50))
RETURNS bit
AS
BEGIN
    DECLARE @Result bit=0;
    IF EXISTS(SELECT 1 FROM ImportSIAC.BuildHistory_Checkpoint WHERE StepCode=@StepCode AND Status=N'VALID')
    BEGIN
        IF EXISTS(SELECT 1 FROM ImportSIAC.BuildHistory_CheckpointOutput WHERE StepCode=@StepCode AND IsRequired=1)
        BEGIN
            IF NOT EXISTS
            (
                SELECT 1 FROM ImportSIAC.BuildHistory_CheckpointOutput
                WHERE StepCode=@StepCode AND IsRequired=1
                  AND OBJECT_ID(OutputTable,N'U') IS NULL
            ) SET @Result=1;
        END
        ELSE IF EXISTS
        (
            SELECT 1 FROM ImportSIAC.BuildHistory_Checkpoint
            WHERE StepCode=@StepCode AND Status=N'VALID'
              AND OBJECT_ID(OutputTable,N'U') IS NOT NULL
        ) SET @Result=1;
    END;
    RETURN @Result;
END;

GO

