CREATE EXTERNAL DATA SOURCE [StagingSIACDataSource]
    WITH (
    TYPE = RDBMS,
    LOCATION = N'accsqlmigration-sql-itn-dev.database.windows.net',
    DATABASE_NAME = N'Accredia_StagingSIAC',
    CREDENTIAL = [StagingSIACCredential]
    );


GO

