CREATE   PROCEDURE ImportSIAC.usp_BH_Checkpoint_Mark
 @StepCode nvarchar(50),@OutputTable nvarchar(200),@RowCountAtSave bigint,@SourceSignature nvarchar(200)=NULL,@Notes nvarchar(500)=NULL
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 -- MIG_119: resume 05 da metriche checkpoint
 IF @StepCode=N'05B_SEDE_MAP' AND (OBJECT_ID(N'ImportSIAC.wrk_SedeMap',N'U') IS NULL OR OBJECT_ID(N'ImportSIAC.wrk_PP_Sedi_Raw',N'U') IS NULL)
  THROW 61721,'Checkpoint 05B non registrabile: output incompleti.',1;
 IF @StepCode=N'08_SCD2_CHILDREN' AND (OBJECT_ID(N'ImportSIAC.wrk_SG_Final',N'U') IS NULL OR OBJECT_ID(N'ImportSIAC.wrk_PRD_Final',N'U') IS NULL OR OBJECT_ID(N'ImportSIAC.wrk_FPC_Final',N'U') IS NULL OR OBJECT_ID(N'ImportSIAC.wrk_Sede_Final',N'U') IS NULL)
  THROW 61722,'Checkpoint 08 non registrabile: output incompleti.',1;
 DECLARE @OwnTransaction bit=0;
 IF @@TRANCOUNT=0 BEGIN BEGIN TRANSACTION; SET @OwnTransaction=1; END;
 BEGIN TRY
  MERGE ImportSIAC.BuildHistory_Checkpoint tgt USING(SELECT @StepCode StepCode) src ON tgt.StepCode=src.StepCode
  WHEN MATCHED THEN UPDATE SET Status=N'VALID',OutputTable=@OutputTable,RowCountAtSave=@RowCountAtSave,SourceSignature=@SourceSignature,CompletedAt=SYSUTCDATETIME(),Notes=@Notes,MetricsJson=NULL
  WHEN NOT MATCHED THEN INSERT(StepCode,Status,OutputTable,RowCountAtSave,SourceSignature,CompletedAt,Notes) VALUES(@StepCode,N'VALID',@OutputTable,@RowCountAtSave,@SourceSignature,SYSUTCDATETIME(),@Notes);
  DELETE ImportSIAC.BuildHistory_CheckpointOutput WHERE StepCode=@StepCode;
  IF @StepCode=N'05B_SEDE_MAP'
  BEGIN
   -- MIG_127: checkpoint 05B con conteggi metadata
   DECLARE @SedeMapRows BIGINT, @SediRawRows BIGINT;
   SELECT @SedeMapRows=SUM(CONVERT(BIGINT,p.rows))
   FROM sys.partitions p
   WHERE p.object_id=OBJECT_ID(N'ImportSIAC.wrk_SedeMap',N'U')
     AND p.index_id IN(0,1);
   SELECT @SediRawRows=SUM(CONVERT(BIGINT,p.rows))
   FROM sys.partitions p
   WHERE p.object_id=OBJECT_ID(N'ImportSIAC.wrk_PP_Sedi_Raw',N'U')
     AND p.index_id IN(0,1);
   IF @SedeMapRows IS NULL OR @SediRawRows IS NULL
    THROW 62722,'Conteggi metadata checkpoint 05B non disponibili.',1;
   INSERT ImportSIAC.BuildHistory_CheckpointOutput(StepCode,OutputTable,RowCountAtSave,Ordinal,IsRequired,CompletedAt,ValidationMode)
   VALUES
    (@StepCode,N'ImportSIAC.wrk_SedeMap',@SedeMapRows,1,1,SYSUTCDATETIME(),'METADATA'),
    (@StepCode,N'ImportSIAC.wrk_PP_Sedi_Raw',@SediRawRows,2,1,SYSUTCDATETIME(),'METADATA');
  END
  ELSE IF @StepCode=N'08_SCD2_CHILDREN'
   INSERT ImportSIAC.BuildHistory_CheckpointOutput(StepCode,OutputTable,RowCountAtSave,Ordinal,IsRequired,CompletedAt)
   SELECT @StepCode,N'ImportSIAC.wrk_SG_Final',COUNT_BIG(*),1,1,SYSUTCDATETIME() FROM ImportSIAC.wrk_SG_Final
   UNION ALL SELECT @StepCode,N'ImportSIAC.wrk_PRD_Final',COUNT_BIG(*),2,1,SYSUTCDATETIME() FROM ImportSIAC.wrk_PRD_Final
   UNION ALL SELECT @StepCode,N'ImportSIAC.wrk_FPC_Final',COUNT_BIG(*),3,1,SYSUTCDATETIME() FROM ImportSIAC.wrk_FPC_Final
   UNION ALL SELECT @StepCode,N'ImportSIAC.wrk_Sede_Final',COUNT_BIG(*),4,1,SYSUTCDATETIME() FROM ImportSIAC.wrk_Sede_Final;
  ELSE
   INSERT ImportSIAC.BuildHistory_CheckpointOutput(StepCode,OutputTable,RowCountAtSave,Ordinal,IsRequired,CompletedAt) VALUES(@StepCode,@OutputTable,@RowCountAtSave,1,1,SYSUTCDATETIME());
  IF @OwnTransaction=1 COMMIT TRANSACTION;
 END TRY
 BEGIN CATCH
  IF @OwnTransaction=1 AND XACT_STATE()<>0 ROLLBACK TRANSACTION;
  THROW;
 END CATCH;
END;

GO

