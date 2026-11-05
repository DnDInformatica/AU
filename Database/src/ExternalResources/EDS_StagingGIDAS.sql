CREATE EXTERNAL DATA SOURCE [EDS_StagingGIDAS]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'accsqlmigration-sql-itn-dev.database.windows.net',
    DATABASE_NAME = N'Accredia_StagingGIDAS',
    CREDENTIAL = [StagingSIACCredential]
    );


GO

