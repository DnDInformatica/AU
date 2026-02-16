using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Database.EnsureTables;

internal static class Handler
{
    public static async Task Handle(Command command, IDbConnectionFactory connectionFactory, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = @"
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Anagrafiche')
BEGIN
    EXEC('CREATE SCHEMA [Anagrafiche]');
END

IF OBJECT_ID('[Anagrafiche].[Organizzazioni]', 'U') IS NULL
BEGIN
    CREATE TABLE [Anagrafiche].[Organizzazioni] (
        [OrganizzazioneId] UNIQUEIDENTIFIER NOT NULL,
        [Codice] NVARCHAR(50) NOT NULL,
        [Denominazione] NVARCHAR(200) NOT NULL,
        [IsActive] BIT NOT NULL CONSTRAINT [DF_Organizzazioni_IsActive] DEFAULT (1),
        [CreatedUtc] DATETIME2 NOT NULL CONSTRAINT [DF_Organizzazioni_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Organizzazioni] PRIMARY KEY ([OrganizzazioneId])
    );

    CREATE UNIQUE INDEX [UX_Organizzazioni_Codice]
        ON [Anagrafiche].[Organizzazioni] ([Codice]);
END
";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        await connection.ExecuteAsync(new CommandDefinition(sql, cancellationToken: cancellationToken));
    }
}
