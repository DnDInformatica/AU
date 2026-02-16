using Dapper;
using Accredia.SIGAD.Tipologiche.Api.Database;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.GetById;

internal static class Handler
{
    private const string Sql = """
        SELECT [Id], [Code], [Description], [IsActive], [Ordine]
        FROM [Tipologiche].[TipoVoceTipologica]
        WHERE [Id] = @Id;
        """;

    public static async Task<IResult> Handle(
        Query query,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var item = await connection.QuerySingleOrDefaultAsync<DetailResponse>(
            new CommandDefinition(Sql, new { query.Id }, cancellationToken: cancellationToken));

        return item is null ? Results.NotFound() : Results.Ok(item);
    }
}
