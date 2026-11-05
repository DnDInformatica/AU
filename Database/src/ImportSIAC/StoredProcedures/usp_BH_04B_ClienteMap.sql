-- ================================================================================
-- ImportSIAC.usp_BH_04B_ClienteMap
-- Estratto dal monolite (step 04B_CLIENTE_MAP). Risolve l'OrganizzazioneClienteId
-- per fiscal_code/vat_number distinti, con parsing paese estero e fallback multipli.
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_04B_ClienteMap
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;

    DECLARE @CkValid BIT=0, @CkReason NVARCHAR(200);
    EXEC ImportSIAC.usp_BH_Checkpoint_Check @StepCode=N'04B_CLIENTE_MAP', @IsValid=@CkValid OUTPUT, @Reason=@CkReason OUTPUT;
    IF @CkValid = 1
    BEGIN
        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_ClienteMap);
        SET @RowsAffected = @Rows;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
            (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,FinishedAt,DurationMs,Status,RowsAffected,ExtraInfo)
        VALUES (@BuildHistoryLogId,4,N'04B_CLIENTE_MAP',N'Mappa clienti (RESUMED)',SYSUTCDATETIME(),SYSUTCDATETIME(),0,
                N'SUCCESS',@Rows,N'RESUMED da checkpoint: wrk_ClienteMap gia valida.');
        PRINT CONCAT('STEP 04B_CLIENTE_MAP: RESUMED, ', @Rows);
        RETURN;
    END;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,4,N'04B_CLIENTE_MAP',N'Mappa clienti',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteKeyDistinct;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ClienteMap;

        SELECT DISTINCT
            NULLIF(LTRIM(RTRIM(src.fiscal_code)), '') AS fiscal_code,
            NULLIF(LTRIM(RTRIM(src.vat_number)),  '') AS vat_number,
            CASE
                WHEN LTRIM(RTRIM(src.vat_number)) LIKE '[A-Z][A-Z]%'
                     AND LEN(LTRIM(RTRIM(src.vat_number))) >= 4
                     AND UPPER(LEFT(LTRIM(RTRIM(src.vat_number)), 2)) NOT IN ('IT')
                    THEN UPPER(LEFT(LTRIM(RTRIM(src.vat_number)), 2))
                WHEN LTRIM(RTRIM(src.fiscal_code)) LIKE '[A-Z][A-Z]%'
                     AND LEN(LTRIM(RTRIM(src.fiscal_code))) >= 4
                     AND UPPER(LEFT(LTRIM(RTRIM(src.fiscal_code)), 2)) NOT IN ('IT')
                     AND NOT (LEN(LTRIM(RTRIM(src.fiscal_code))) = 16
                              AND UPPER(LTRIM(RTRIM(src.fiscal_code))) LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][A-Z][0-9][0-9][A-Z][0-9][0-9][0-9][A-Z]')
                    THEN UPPER(LEFT(LTRIM(RTRIM(src.fiscal_code)), 2))
                WHEN LTRIM(RTRIM(src.fiscal_code)) LIKE '00000000000[A-Z][A-Z]%'
                     AND LEN(LTRIM(RTRIM(src.fiscal_code))) > 13
                    THEN UPPER(SUBSTRING(LTRIM(RTRIM(src.fiscal_code)), 12, 2))
                WHEN LTRIM(RTRIM(src.fiscal_code)) LIKE '''00000000000[A-Z][A-Z]%'
                     AND LEN(LTRIM(RTRIM(src.fiscal_code))) > 14
                    THEN UPPER(SUBSTRING(LTRIM(RTRIM(src.fiscal_code)), 13, 2))
                ELSE NULL
            END AS parsed_paese_iso2,
            CASE
                WHEN LTRIM(RTRIM(src.vat_number)) LIKE '[A-Z][A-Z]%'
                     AND LEN(LTRIM(RTRIM(src.vat_number))) >= 4
                     AND UPPER(LEFT(LTRIM(RTRIM(src.vat_number)), 2)) NOT IN ('IT')
                    THEN LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(src.vat_number)), 3, 50)))
                WHEN LTRIM(RTRIM(src.fiscal_code)) LIKE '[A-Z][A-Z]%'
                     AND LEN(LTRIM(RTRIM(src.fiscal_code))) >= 4
                     AND UPPER(LEFT(LTRIM(RTRIM(src.fiscal_code)), 2)) NOT IN ('IT')
                     AND NOT (LEN(LTRIM(RTRIM(src.fiscal_code))) = 16
                              AND UPPER(LTRIM(RTRIM(src.fiscal_code))) LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][A-Z][0-9][0-9][A-Z][0-9][0-9][0-9][A-Z]')
                    THEN LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(src.fiscal_code)), 3, 50)))
                WHEN LTRIM(RTRIM(src.fiscal_code)) LIKE '00000000000[A-Z][A-Z]%'
                     AND LEN(LTRIM(RTRIM(src.fiscal_code))) > 13
                    THEN LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(src.fiscal_code)), 14, 50)))
                WHEN LTRIM(RTRIM(src.fiscal_code)) LIKE '''00000000000[A-Z][A-Z]%'
                     AND LEN(LTRIM(RTRIM(src.fiscal_code))) > 14
                    THEN LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(src.fiscal_code)), 15, 50)))
                ELSE NULL
            END AS parsed_valore_estero
        INTO ImportSIAC.wrk_ClienteKeyDistinct
        FROM ImportSIAC.wrk_All_Src src
        WHERE src.Dominio IN ('PP', 'PRD')
          AND ISNULL(src.fiscal_code, '') <> '00000000000'
          AND ISNULL(src.vat_number,  '') <> '00000000000'
          AND (  NULLIF(LTRIM(RTRIM(src.fiscal_code)), '') IS NOT NULL
              OR NULLIF(LTRIM(RTRIM(src.vat_number)),  '') IS NOT NULL);

        CREATE CLUSTERED INDEX CX_ClienteKeyDistinct
            ON ImportSIAC.wrk_ClienteKeyDistinct (fiscal_code, vat_number);

        UPDATE ImportSIAC.wrk_ClienteKeyDistinct SET parsed_paese_iso2 = 'GR' WHERE parsed_paese_iso2 = 'EL';

        SELECT
            ck.fiscal_code,
            ck.vat_number,
            ck.parsed_paese_iso2,
            ck.parsed_valore_estero,
            COALESCE(
                (SELECT TOP 1 oc.OrganizzazioneId
                 FROM Organizzazioni.Organizzazione oc
                 WHERE oc.DataCancellazione IS NULL
                   AND ck.fiscal_code IS NOT NULL
                   AND oc.CodiceFiscale = ck.fiscal_code
                 ORDER BY oc.OrganizzazioneId),
                (SELECT TOP 1 oc.OrganizzazioneId
                 FROM Organizzazioni.Organizzazione oc
                 WHERE oc.DataCancellazione IS NULL
                   AND ck.vat_number IS NOT NULL
                   AND oc.PartitaIVA = ck.vat_number
                 ORDER BY oc.OrganizzazioneId),
                (SELECT TOP 1 oif.OrganizzazioneId
                 FROM Organizzazioni.OrganizzazioneIdentificativoFiscale oif
                 WHERE oif.DataFineValidita = '9999-12-31 23:59:59.9999999'
                   AND ck.parsed_paese_iso2    IS NOT NULL
                   AND ck.parsed_valore_estero IS NOT NULL
                   AND RTRIM(oif.PaeseISO2) = ck.parsed_paese_iso2
                   AND oif.Valore           = ck.parsed_valore_estero
                 ORDER BY oif.OrganizzazioneId),
                (SELECT TOP 1 oc.OrganizzazioneId
                 FROM Organizzazioni.Organizzazione oc
                 WHERE oc.DataCancellazione IS NULL
                   AND oc.CodOrganizzazione = COALESCE(ck.fiscal_code, ck.vat_number)
                 ORDER BY oc.OrganizzazioneId)
            ) AS OrganizzazioneClienteId
        INTO ImportSIAC.wrk_ClienteMap
        FROM ImportSIAC.wrk_ClienteKeyDistinct ck
        OPTION (MAXDOP 8);

        CREATE CLUSTERED INDEX CX_ClienteMap
            ON ImportSIAC.wrk_ClienteMap (fiscal_code, vat_number);

        DROP TABLE ImportSIAC.wrk_ClienteKeyDistinct;
        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_ClienteMap);
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 04B_CLIENTE_MAP: ', @Rows);

        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode=N'04B_CLIENTE_MAP', @OutputTable=N'ImportSIAC.wrk_ClienteMap',
            @RowCountAtSave=@Rows, @Notes=N'Mappa cliente: fiscal_code/vat_number -> OrganizzazioneClienteId.';
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

