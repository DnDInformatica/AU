using Dapper;
using Accredia.SIGAD.Tipologiche.Api.Database;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Database.EnsureTables;

internal static class Handler
{
    private const string EnsureSql = """
        IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Tipologiche')
        BEGIN
            EXEC(N'CREATE SCHEMA [Tipologiche]');
        END

        IF OBJECT_ID(N'Tipologiche.TipoVoceTipologica', N'U') IS NULL
        BEGIN
            CREATE TABLE [Tipologiche].[TipoVoceTipologica] (
                [Id] INT IDENTITY(1,1) NOT NULL CONSTRAINT [PK_TipoVoceTipologica] PRIMARY KEY,
                [Code] NVARCHAR(50) NOT NULL,
                [Description] NVARCHAR(250) NOT NULL,
                [IsActive] BIT NOT NULL CONSTRAINT [DF_TipoVoceTipologica_IsActive] DEFAULT (1),
                [Ordine] INT NOT NULL CONSTRAINT [DF_TipoVoceTipologica_Ordine] DEFAULT (0)
            );

            CREATE UNIQUE INDEX [UX_TipoVoceTipologica_Code]
                ON [Tipologiche].[TipoVoceTipologica] ([Code]);
        END
        """;

    public static async Task<IResult> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        await connection.ExecuteAsync(new CommandDefinition(EnsureSql, cancellationToken: cancellationToken));

        return Results.Ok(new EnsureTablesResponse("ok"));
    }
}
