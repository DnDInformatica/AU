CREATE EXTERNAL DATA SOURCE [EDS_StagingSIA]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'accsqlmigration-sql-itn-dev.database.windows.net',
    DATABASE_NAME = N'Accredia_StagingSIA',
    CREDENTIAL = [StagingSIACCredential]
    );


GO

