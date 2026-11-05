-- ================================================================================
-- ImportSIAC.usp_BH_04D_Scarti
-- Estratto dal monolite (step 04D_SCARTI). Logga in BuildHistory_ScartaOrganizzazione
-- le organizzazioni non risolte (OrganizzazioneClienteId NULL), con motivo classificato.
-- NON ha skip-by-checkpoint: e' un log di audit legato al BuildHistoryLogId corrente,
-- ogni run deve produrre il proprio audit trail. Costo contenuto (~4 min).
-- ================================================================================
CREATE   PROCEDURE ImportSIAC.usp_BH_04D_Scarti
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart DATETIME2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId INT, @Rows BIGINT = 0;

    INSERT INTO ImportSIAC.BuildHistory_StepLog (BuildHistoryLogId,StepNo,StepCode,StepName,StartedAt,Status)
    VALUES (@BuildHistoryLogId,4,N'04D_SCARTI',N'Log scarti org',@StepStart,N'RUNNING');
    SET @StepLogId = SCOPE_IDENTITY();

    BEGIN TRY
        INSERT INTO ImportSIAC.BuildHistory_ScartaOrganizzazione
            (BuildHistoryLogId, Dominio, Codente, ODCRagioneSociale,
             FiscalCodeRaw, VatNumberRaw, MotivoScarto, NCertificatiImpattati)
        SELECT
            @BuildHistoryLogId,
            src.Dominio,
            src.codente,
            odc.RagioneSociale,
            cm.fiscal_code  AS FiscalCodeRaw,
            cm.vat_number   AS VatNumberRaw,
            CASE
                WHEN ISNULL(cm.fiscal_code,'') = '' AND ISNULL(cm.vat_number,'') = ''
                    THEN 'CF_PIVA_VUOTI'
                WHEN ISNULL(cm.fiscal_code,'') = '00000000000'
                    THEN 'PLACEHOLDER_00000000000'
                WHEN ISNULL(cm.fiscal_code,'') LIKE '%[^0-9,. ]%'
                     AND LEN(ISNULL(cm.fiscal_code,'')) BETWEEN 11 AND 16
                    THEN 'CF_ALFANUMERICO_NON_CENSITO'
                WHEN cm.parsed_paese_iso2 IS NOT NULL
                    THEN 'ESTERO_NON_CENSITO_IN_OIF'
                WHEN ISNULL(cm.fiscal_code,'') LIKE '%[^0-9]%'
                     AND LEN(ISNULL(cm.fiscal_code,'')) > 16
                    THEN 'IDENTIFICATIVO_ESTERO_LUNGO'
                WHEN ISNULL(cm.fiscal_code,'') NOT LIKE '%[^0-9]%'
                     AND LEN(ISNULL(cm.fiscal_code,'')) NOT IN (11)
                    THEN 'NUMERICO_LUNGHEZZA_ANOMALA'
                WHEN ISNULL(cm.fiscal_code, ISNULL(cm.vat_number,'')) LIKE '%E+%'
                    THEN 'NOTAZIONE_SCIENTIFICA_EXCEL'
                ELSE 'ALTRO'
            END AS MotivoScarto,
            COUNT(*) AS NCertificatiImpattati
        FROM ImportSIAC.wrk_ClienteMap cm
        JOIN ImportSIAC.wrk_All_Src src
            ON src.Dominio IN ('PP','PRD')
            AND ISNULL(src.fiscal_code,'') = ISNULL(cm.fiscal_code,'')
            AND ISNULL(src.vat_number,'')  = ISNULL(cm.vat_number,'')
        LEFT JOIN Organizzazioni.Organizzazione odc
            ON odc.CodOrganizzazione = src.codente AND odc.DataCancellazione IS NULL
        WHERE cm.OrganizzazioneClienteId IS NULL
        GROUP BY
            src.Dominio, src.codente, odc.RagioneSociale,
            cm.fiscal_code, cm.vat_number, cm.parsed_paese_iso2,
            CASE
                WHEN ISNULL(cm.fiscal_code,'') = '' AND ISNULL(cm.vat_number,'') = ''
                    THEN 'CF_PIVA_VUOTI'
                WHEN ISNULL(cm.fiscal_code,'') = '00000000000'
                    THEN 'PLACEHOLDER_00000000000'
                WHEN ISNULL(cm.fiscal_code,'') LIKE '%[^0-9,. ]%'
                     AND LEN(ISNULL(cm.fiscal_code,'')) BETWEEN 11 AND 16
                    THEN 'CF_ALFANUMERICO_NON_CENSITO'
                WHEN cm.parsed_paese_iso2 IS NOT NULL
                    THEN 'ESTERO_NON_CENSITO_IN_OIF'
                WHEN ISNULL(cm.fiscal_code,'') LIKE '%[^0-9]%'
                     AND LEN(ISNULL(cm.fiscal_code,'')) > 16
                    THEN 'IDENTIFICATIVO_ESTERO_LUNGO'
                WHEN ISNULL(cm.fiscal_code,'') NOT LIKE '%[^0-9]%'
                     AND LEN(ISNULL(cm.fiscal_code,'')) NOT IN (11)
                    THEN 'NUMERICO_LUNGHEZZA_ANOMALA'
                WHEN ISNULL(cm.fiscal_code, ISNULL(cm.vat_number,'')) LIKE '%E+%'
                    THEN 'NOTAZIONE_SCIENTIFICA_EXCEL'
                ELSE 'ALTRO'
            END
        OPTION (MAXDOP 8);
        -- MIG_126: conteggio 04D indipendente dal connection rowcount
        SELECT @Rows = COUNT_BIG(*)
        FROM ImportSIAC.BuildHistory_ScartaOrganizzazione
        WHERE BuildHistoryLogId = @BuildHistoryLogId;
        SET @RowsAffected = @Rows;

        UPDATE ImportSIAC.BuildHistory_StepLog SET FinishedAt=SYSUTCDATETIME(),
            DurationMs=DATEDIFF_BIG(MILLISECOND,StartedAt,SYSUTCDATETIME()),
            Status=N'SUCCESS', RowsAffected=@Rows
        WHERE BuildHistoryStepLogId=@StepLogId;
        PRINT CONCAT('STEP 04D_SCARTI: ', @Rows);
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

