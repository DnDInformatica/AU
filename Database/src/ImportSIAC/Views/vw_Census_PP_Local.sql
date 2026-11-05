CREATE   VIEW ImportSIAC.vw_Census_PP_Local
AS
-- MIG_132: sostituto locale di Ext_PP_Flat per il censimento 04C_SG.
-- Espone wrk_All_Src (Dominio PP) con i nomi colonna del CTE RawByCF.
-- NB: fiscal_code/vat_number qui sono NORMALIZZATI dalla Populate
-- (strip apici, padding a 11 cifre, placeholder->NULL): match >= versione raw.
SELECT fiscal_code, vat_number,
       raw_company_name AS json_companyname,
       raw_site_address AS json_address,
       raw_site_city    AS json_city,
       raw_site_zip     AS json_zipcode,
       raw_site_country AS json_country,
       SnapshotYear, SnapshotMonth
FROM ImportSIAC.wrk_All_Src
WHERE Dominio = N'PP';

GO

