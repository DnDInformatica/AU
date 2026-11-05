CREATE   VIEW Reporting.vw_GOV_ConsumerAdHocLegacy
AS
-- GOV_EXEMPT (la definizione stessa non deve auto-rilevarsi)
SELECT
    q.query_id,
    q.last_execution_time,
    MotivoMatch =
        CASE WHEN qt.query_sql_text LIKE N'%OrganizzazioneClienteId%'
             THEN N'riferimento diretto colonna'
             ELSE N'select star' END,
    EstrattoQuery = LEFT(qt.query_sql_text, 400)
FROM sys.query_store_query_text AS qt
INNER JOIN sys.query_store_query AS q
  ON q.query_text_id = qt.query_text_id
WHERE q.object_id = 0
  AND
  (
      REPLACE(REPLACE(qt.query_sql_text, N'[', N''), N']', N'')
          LIKE N'%FROM Certificazione.Certificazione%'
      OR REPLACE(REPLACE(qt.query_sql_text, N'[', N''), N']', N'')
          LIKE N'%JOIN Certificazione.Certificazione%'
  )
  AND
  (
      qt.query_sql_text LIKE N'%OrganizzazioneClienteId%'
      OR qt.query_sql_text LIKE N'%SELECT *%'
      OR qt.query_sql_text LIKE N'%SELECT DISTINCT *%'
      OR qt.query_sql_text LIKE N'%.*%'
  )
  AND qt.query_sql_text NOT LIKE N'%GOV\_EXEMPT%' ESCAPE N'\'
  AND qt.query_sql_text NOT LIKE N'%vw\_GOV\_ConsumerAdHocLegacy%' ESCAPE N'\'
  AND qt.query_sql_text NOT LIKE N'%sys.query\_store\_query\_text%' ESCAPE N'\'
  AND qt.query_sql_text NOT LIKE N'%MIG\_144%' ESCAPE N'\'
  AND qt.query_sql_text NOT LIKE N'%MIG\_145%' ESCAPE N'\';

GO

