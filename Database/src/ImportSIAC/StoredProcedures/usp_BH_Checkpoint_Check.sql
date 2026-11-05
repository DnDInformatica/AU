CREATE   PROCEDURE ImportSIAC.usp_BH_Checkpoint_Check
    @StepCode nvarchar(50),
    @IsValid bit=0 OUTPUT,
    @Reason nvarchar(200)=NULL OUTPUT
AS
BEGIN
 SET NOCOUNT ON;
 -- MIG_119: resume 05 da metriche checkpoint
 SET @IsValid=0;
 DECLARE @OutputTable nvarchar(200),@ExpectedRows bigint,@ActualRows bigint,@Sql nvarchar(max),@SchemaName sysname,@TableName sysname,@FailureReason nvarchar(500),@ValidationMode varchar(10);
 IF NOT EXISTS(SELECT 1 FROM ImportSIAC.BuildHistory_Checkpoint WHERE StepCode=@StepCode AND Status=N'VALID')
 BEGIN
  SET @Reason=N'Nessun checkpoint VALID registrato';
  INSERT ImportSIAC.BuildHistory_CheckpointAudit(StepCode,IsValid,Reason) VALUES(@StepCode,0,@Reason);
  RETURN;
 END;
 DECLARE @Outputs table(Ordinal smallint NOT NULL,OutputTable nvarchar(200) NOT NULL,ExpectedRows bigint NOT NULL,ValidationMode varchar(10) NOT NULL);
 INSERT @Outputs SELECT Ordinal,OutputTable,RowCountAtSave,ValidationMode FROM ImportSIAC.BuildHistory_CheckpointOutput WHERE StepCode=@StepCode AND IsRequired=1;
 IF NOT EXISTS(SELECT 1 FROM @Outputs)
  INSERT @Outputs SELECT 1,OutputTable,RowCountAtSave,'FULL' FROM ImportSIAC.BuildHistory_Checkpoint WHERE StepCode=@StepCode AND Status=N'VALID';
 DECLARE output_cursor CURSOR LOCAL FAST_FORWARD FOR SELECT OutputTable,ExpectedRows,ValidationMode FROM @Outputs ORDER BY Ordinal;
 OPEN output_cursor; FETCH NEXT FROM output_cursor INTO @OutputTable,@ExpectedRows,@ValidationMode;
 WHILE @@FETCH_STATUS=0
 BEGIN
  SET @ActualRows=NULL; SET @SchemaName=PARSENAME(@OutputTable,2); SET @TableName=PARSENAME(@OutputTable,1);
  IF @SchemaName IS NULL OR @TableName IS NULL OR PARSENAME(@OutputTable,3) IS NOT NULL
  BEGIN SET @FailureReason=CONCAT(N'Nome output non valido: ',@OutputTable); BREAK; END;
  IF OBJECT_ID(@OutputTable,N'U') IS NULL
  BEGIN SET @FailureReason=CONCAT(N'Output assente: ',@OutputTable); BREAK; END;
  IF @ValidationMode='METADATA'
   SELECT @ActualRows=SUM(CONVERT(bigint,p.rows))
   FROM sys.partitions p
   WHERE p.object_id=OBJECT_ID(@OutputTable,N'U')
     AND p.index_id IN(0,1);
  ELSE
  BEGIN
   SET @Sql=N'SELECT @cnt=COUNT_BIG(*) FROM '+QUOTENAME(@SchemaName)+N'.'+QUOTENAME(@TableName)+N';';
   EXEC sys.sp_executesql @Sql,N'@cnt bigint OUTPUT',@cnt=@ActualRows OUTPUT;
  END;
  IF @ActualRows<>@ExpectedRows
  BEGIN SET @FailureReason=CONCAT(N'Conteggio diverso per ',@OutputTable,N': atteso=',@ExpectedRows,N' attuale=',@ActualRows); BREAK; END;
  FETCH NEXT FROM output_cursor INTO @OutputTable,@ExpectedRows,@ValidationMode;
 END;
 CLOSE output_cursor; DEALLOCATE output_cursor;
 IF @FailureReason IS NOT NULL
 BEGIN
  SET @Reason=LEFT(@FailureReason,200);
  UPDATE ImportSIAC.BuildHistory_Checkpoint SET Status=N'STALE',Notes=LEFT(CONCAT(N'Checkpoint invalidato: ',@FailureReason,N'. ',COALESCE(Notes,N'')),500) WHERE StepCode=@StepCode AND Status=N'VALID';
  INSERT ImportSIAC.BuildHistory_CheckpointAudit(StepCode,OutputTable,ExpectedRows,ActualRows,IsValid,Reason) VALUES(@StepCode,@OutputTable,@ExpectedRows,@ActualRows,0,@FailureReason);
  RETURN;
 END;
 SET @IsValid=1; SET @Reason=N'OK: tutti gli output obbligatori sono integri';
END;

GO

