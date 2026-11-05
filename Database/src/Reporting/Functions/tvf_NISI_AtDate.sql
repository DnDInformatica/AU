
CREATE   FUNCTION Reporting.tvf_NISI_AtDate
(
    @AsOf date,
    @Periodo nvarchar(7)
)
RETURNS TABLE
AS
RETURN
(
    -- MIG_144_NISI_CLIENTE_DA_SG_V1
    WITH SettoriRanked AS
    (
        SELECT
            cse.CertificazioneId,
            sea.Codice AS SectorCode,
            ROW_NUMBER() OVER
            (
                PARTITION BY cse.CertificazioneId
                ORDER BY cse.CertificazioneSettoreEAId
            ) AS rn
        FROM Certificazione.CertificazioneSettoreEA AS cse
        INNER JOIN Standard.SettoreEA AS sea
          ON sea.SettoreEAId = cse.SettoreEAId
        WHERE cse.DataInizioValidita <= CAST(@AsOf AS datetime2(7))
          AND cse.DataFineValidita > CAST(@AsOf AS datetime2(7))
          AND cse.DataCancellazione IS NULL
    )
    SELECT
        @Periodo AS periodo,
        CAST(c.CertificazioneId AS nvarchar(20)) AS id_cert,
        LTRIM(RTRIM(odc.RagioneSociale)) AS ragsoc,
        LTRIM(RTRIM(odc.CodiceFiscale)) AS codfisc,
        CASE
            WHEN LEFT(LTRIM(cli.CodiceFiscale), 2) = N'IT'
                THEN LTRIM(RTRIM(SUBSTRING(LTRIM(cli.CodiceFiscale), 3, 4000)))
            ELSE LTRIM(RTRIM(cli.CodiceFiscale))
        END AS fiscalcode,
        LTRIM(RTRIM(cli.RagioneSociale)) AS companyname,
        LTRIM(RTRIM(s.Indirizzo + N' ' + ISNULL(s.NumeroCivico, N''))) AS [address],
        LTRIM(RTRIM(s.Localita)) AS city,
        LTRIM(RTRIM(s.CAP)) AS zipcode,
        c.DataEmissione AS issuedate,
        LEFT
        (
            REPLACE(REPLACE(ISNULL(cs.AmbitoIta, N''), CHAR(13), N' '), CHAR(10), N' '),
            3500
        ) AS scope_ita,
        LTRIM(RTRIM(n.Codice)) AS regulation,
        LTRIM(RTRIM(ts.Codice)) AS id_companysitetype,
        LTRIM(RTRIM(cli.PartitaIVA)) AS piva,
        CAST(NULL AS nvarchar(100)) AS region,
        CAST(NULL AS nvarchar(10)) AS istat_province_prcode,
        CASE
            WHEN LEN(LTRIM(RTRIM(s.Nazione))) = 2
                THEN UPPER(LTRIM(RTRIM(s.Nazione)))
            ELSE NULL
        END AS iso_country_alpha2,
        pri.SectorCode AS sector_code,
        sec.SectorCode AS sector_code_secondary_accredited,
        LTRIM(RTRIM(odc.CodOrganizzazione)) AS codente,
        LEFT(LTRIM(RTRIM(c.NumeroCertificato)), 50) AS ncertificate
    FROM Certificazione.Certificazione AS c
    INNER JOIN Certificazione.CertificazioneSede AS cs
      ON cs.CertificazioneId = c.CertificazioneId
     AND cs.DataInizioValidita <= CAST(@AsOf AS datetime2(7))
     AND cs.DataFineValidita > CAST(@AsOf AS datetime2(7))
     AND cs.DataCancellazione IS NULL
    LEFT JOIN Certificazione.CertificazioneSG AS sg
      ON sg.CertificazioneId = c.CertificazioneId
     AND sg.DataInizioValidita <= CAST(@AsOf AS datetime2(7))
     AND sg.DataFineValidita > CAST(@AsOf AS datetime2(7))
     AND sg.DataCancellazione IS NULL
    LEFT JOIN Organizzazioni.Sede AS s
      ON s.SedeId = cs.SedeId
     AND s.DataInizioValidita <= CAST(@AsOf AS datetime2(7))
     AND s.DataFineValidita > CAST(@AsOf AS datetime2(7))
     AND s.DataCancellazione IS NULL
    LEFT JOIN Tipologica.TipoSede AS ts
      ON ts.TipoSedeId = s.TipoSedeId
    INNER JOIN Organizzazioni.Organizzazione AS odc
      ON odc.OrganizzazioneId = c.OrganizzazioneODCId
     AND odc.DataInizioValidita <= CAST(@AsOf AS datetime2(7))
     AND odc.DataFineValidita > CAST(@AsOf AS datetime2(7))
     AND odc.DataCancellazione IS NULL
    LEFT JOIN Organizzazioni.Organizzazione AS cli
      ON cli.OrganizzazioneId = sg.OrganizzazioneClienteId
     AND cli.DataInizioValidita <= CAST(@AsOf AS datetime2(7))
     AND cli.DataFineValidita > CAST(@AsOf AS datetime2(7))
     AND cli.DataCancellazione IS NULL
    INNER JOIN Standard.NormaAccreditamento AS n
      ON n.NormaAccreditamentoId = c.NormaAccreditamentoId
     AND n.DataInizioValidita <= CAST(@AsOf AS datetime2(7))
     AND n.DataFineValidita > CAST(@AsOf AS datetime2(7))
    LEFT JOIN SettoriRanked AS pri
      ON pri.CertificazioneId = c.CertificazioneId
     AND pri.rn = 1
    LEFT JOIN SettoriRanked AS sec
      ON sec.CertificazioneId = c.CertificazioneId
     AND sec.rn = 2
    WHERE c.DataCancellazione IS NULL
      AND c.DataInizioValidita <= CAST(@AsOf AS datetime2(7))
      AND c.DataFineValidita > CAST(@AsOf AS datetime2(7))
      AND c.DataEmissione <= @AsOf
      AND (c.DataScadenza IS NULL OR c.DataScadenza > @AsOf)
      AND (c.DataRevoca IS NULL OR c.DataRevoca > @AsOf)
);

GO

