CREATE PROCEDURE ImportSIAC.usp_BH_02B_FPCMap_Validate
AS
BEGIN
    SET NOCOUNT ON;

    -- ultima versione per Code dal log storico
    ;WITH log_latest AS (
        SELECT Code, DescriptionIt,
               ROW_NUMBER() OVER (PARTITION BY Code ORDER BY DateLog DESC) AS rn
        FROM ImportSIAC.Ext_FPC_NormLookupLogRaw
        WHERE Code IS NOT NULL
    ),
    src AS (
        SELECT m.NormCodeSiac AS Code,
               COALESCE(cur.DescriptionIt, ll.DescriptionIt) AS DescrizioneSorgente,
               CASE WHEN cur.Code IS NOT NULL THEN 'CORRENTE'
                    WHEN ll.Code  IS NOT NULL THEN 'STORICO'
                    ELSE 'ASSENTE' END AS FonteSorgente
        FROM ImportSIAC.NormaFPCMap m
        LEFT JOIN ImportSIAC.Ext_FPC_NormLookupRaw cur ON cur.Code = m.NormCodeSiac
        LEFT JOIN log_latest ll ON ll.Code = m.NormCodeSiac AND ll.rn = 1
    )
    INSERT INTO ImportSIAC.FPCMapValidation
        (NormCodeSiac, NormaAccreditamentoId, Riferimento, TitoloSidac,
         DescrizioneSorgente, FonteSorgente, Esito)
    SELECT
        m.NormCodeSiac, n.NormaAccreditamentoId, n.Riferimento, n.TitoloIta,
        s.DescrizioneSorgente, s.FonteSorgente,
        CASE
            WHEN n.NormaAccreditamentoId IS NULL THEN 'NO_TARGET'
            WHEN s.DescrizioneSorgente   IS NULL THEN 'NO_SOURCE'
            WHEN CHARINDEX(ImportSIAC.fn_NormText(s.DescrizioneSorgente),
                           ImportSIAC.fn_NormText(n.TitoloIta)) > 0 THEN 'OK'
            ELSE 'DRIFT'
        END AS Esito
    FROM ImportSIAC.NormaFPCMap m
    JOIN src s ON s.Code = m.NormCodeSiac
    LEFT JOIN Standard.NormaAccreditamento n
           ON n.NormaAccreditamentoId = m.NormaAccreditamentoId
          AND n.DataCancellazione IS NULL;

    -- ritorna solo le anomalie dell'ultima esecuzione
    SELECT NormCodeSiac, Riferimento, Esito, FonteSorgente,
           DescrizioneSorgente, TitoloSidac
    FROM ImportSIAC.FPCMapValidation
    WHERE CheckedAtUtc >= DATEADD(SECOND,-5,SYSUTCDATETIME())
      AND Esito <> 'OK'
    ORDER BY Esito, NormCodeSiac;
END;

GO

