CREATE PROCEDURE ImportSIAC.usp_BH_02B_FPCMap_RefreshNote
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRAN;
    ;WITH log_latest AS (
        SELECT Code, DescriptionIt,
               ROW_NUMBER() OVER (PARTITION BY Code ORDER BY DateLog DESC) AS rn
        FROM ImportSIAC.Ext_FPC_NormLookupLogRaw WHERE Code IS NOT NULL
    )
    UPDATE m
    SET m.Note = COALESCE(cur.DescriptionIt, ll.DescriptionIt, m.Note)
    FROM ImportSIAC.NormaFPCMap m
    LEFT JOIN ImportSIAC.Ext_FPC_NormLookupRaw cur ON cur.Code = m.NormCodeSiac
    LEFT JOIN log_latest ll ON ll.Code = m.NormCodeSiac AND ll.rn = 1
    WHERE COALESCE(cur.DescriptionIt, ll.DescriptionIt) IS NOT NULL;
    -- verifica prima del COMMIT
    SELECT NormCodeSiac, Note FROM ImportSIAC.NormaFPCMap ORDER BY NormCodeSiac;
    ROLLBACK TRAN;   -- sostituire con COMMIT dopo revisione
END;

GO

