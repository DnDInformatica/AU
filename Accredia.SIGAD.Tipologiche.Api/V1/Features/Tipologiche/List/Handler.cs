using Dapper;
using Accredia.SIGAD.Tipologiche.Api.Database;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.List;

internal static class Handler
{
    private const string CountSql = """
        SELECT COUNT(1)
        FROM [Tipologiche].[TipoVoceTipologica]
        WHERE (@Q IS NULL OR [Code] LIKE @Q OR [Description] LIKE @Q);
        """;

    private const string ListSql = """
        SELECT [Id], [Code], [Description], [IsActive], [Ordine]
        FROM [Tipologiche].[TipoVoceTipologica]
        WHERE (@Q IS NULL OR [Code] LIKE @Q OR [Description] LIKE @Q)
        ORDER BY [Ordine], [Code]
        OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
        """;

    public static async Task<IResult> Handle(
        Query query,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        var q = string.IsNullOrWhiteSpace(query.Q) ? null : $"%{query.Q.Trim()}%";
        var offset = (query.Page - 1) * query.PageSize;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var parameters = new
        {
            Q = q,
            Offset = offset,
            PageSize = query.PageSize
        };

        var totalCount = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(CountSql, parameters, cancellationToken: cancellationToken));

        var items = (await connection.QueryAsync<TipologicaListItem>(
            new CommandDefinition(ListSql, parameters, cancellationToken: cancellationToken))).ToList();

        var response = new ListResponse(items, query.Page, query.PageSize, totalCount);
        return Results.Ok(response);
    }
}
