using Dapper;
using Accredia.SIGAD.Identity.Api.Database;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Database.EnsureSchema;

internal static class Handler
{
    public static async Task<EnsureSchemaResponse> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = @"
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Identity')
BEGIN
    EXEC('CREATE SCHEMA [Identity]');
END

IF OBJECT_ID('[Identity].[__SchemaVersion]', 'U') IS NULL
BEGIN
    CREATE TABLE [Identity].[__SchemaVersion] (
        [Version] INT NOT NULL,
        [AppliedUtc] DATETIME2 NOT NULL CONSTRAINT [DF_SchemaVersion_AppliedUtc] DEFAULT (SYSUTCDATETIME()),
        [Description] NVARCHAR(500) NULL,
        CONSTRAINT [PK_SchemaVersion] PRIMARY KEY ([Version])
    );

    INSERT INTO [Identity].[__SchemaVersion] ([Version], [Description])
    VALUES (1, 'Initial schema creation');
END

SELECT MAX([Version]) AS CurrentVersion FROM [Identity].[__SchemaVersion];
";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var version = await connection.QuerySingleAsync<int>(new CommandDefinition(sql, cancellationToken: cancellationToken));

        return new EnsureSchemaResponse("Identity", version);
    }
}
