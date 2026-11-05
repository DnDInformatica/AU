CREATE   VIEW Reporting.vw_NISI_SnapshotCsv AS SELECT Periodo AS periodo, id_cert, ragsoc, codfisc, fiscalcode, companyname, [address], city, zipcode, issuedate, scope_ita, regulation, id_companysitetype, piva, region, istat_province_prcode, iso_country_alpha2, sector_code, sector_code_secondary_accredited, codente, ncertificate FROM Reporting.NISI_Snapshot;

GO

