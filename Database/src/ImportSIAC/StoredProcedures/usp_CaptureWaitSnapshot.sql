CREATE   PROCEDURE ImportSIAC.usp_CaptureWaitSnapshot
    @BuildHistoryLogId INT,
    @Fase VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM ImportSIAC.PipelineWaitSnapshot WHERE BuildHistoryLogId=@BuildHistoryLogId AND Fase=@Fase;

    INSERT INTO ImportSIAC.PipelineWaitSnapshot (BuildHistoryLogId, Fase, wait_type, waiting_tasks, wait_time_ms, signal_wait_ms)
    SELECT @BuildHistoryLogId, @Fase, wait_type, waiting_tasks_count, wait_time_ms, signal_wait_time_ms
    FROM sys.dm_db_wait_stats
    WHERE wait_type NOT IN (
        'BROKER_TASK_STOP','BROKER_TO_FLUSH','CHECKPOINT_QUEUE','CHKPT','LAZYWRITER_SLEEP',
        'REQUEST_FOR_DEADLOCK_SEARCH','SLEEP_TASK','SLEEP_SYSTEMTASK','SQLTRACE_BUFFER_FLUSH',
        'WAITFOR','XE_DISPATCHER_WAIT','XE_TIMER_EVENT','DIRTY_PAGE_POLL','HADR_FILESTREAM_IOMGR_IOCOMPLETION',
        'SP_SERVER_DIAGNOSTICS_SLEEP','QDS_PERSIST_TASK_MAIN_LOOP_SLEEP','QDS_ASYNC_QUEUE',
        'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP','QDS_SHUTDOWN_QUEUE','RESOURCE_GOVERNOR_IDLE',
        'DISPATCHER_QUEUE_SEMAPHORE','FT_IFTS_SCHEDULER_IDLE_WAIT')
    AND wait_time_ms > 0;
END;

GO

