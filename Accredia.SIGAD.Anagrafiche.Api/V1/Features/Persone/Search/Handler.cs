using System.Text.RegularExpressions;
using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Search;

internal static class Handler
{
    public static async Task<PagedResponse<PersonaSearchItem>> Handle(
        Query query,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(query);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var trimmed = query.Q.Trim();
        var isCf = Regex.IsMatch(trimmed, @"^[A-Za-z0-9]{16}$");
        var offset = (query.Page - 1) * query.PageSize;

        const string baseWhere = @"
p.DataCancellazione IS NULL
AND p.DataInizioValidita <= SYSUTCDATETIME()
AND p.DataFineValidita >= SYSUTCDATETIME()";

        string filterSql;
        object parameters;

        if (isCf)
        {
            filterSql = "p.CodiceFiscale = @Query";
            parameters = new { Query = trimmed, Offset = offset, PageSize = query.PageSize };
        }
        else
        {
            filterSql = @"
p.Cognome LIKE @Like
OR p.Nome LIKE @Like
OR CONCAT(p.Cognome, ' ', p.Nome) LIKE @Like";
            parameters = new { Like = $"%{trimmed}%", Offset = offset, PageSize = query.PageSize };
        }

        var whereSql = $"{baseWhere} AND ({filterSql})";

        var countSql = $@"
SELECT COUNT(1)
FROM [Persone].[Persona] p
WHERE {whereSql};";

        var listSql = $@"
SELECT
    p.PersonaId,
    p.Cognome,
    p.Nome,
    p.CodiceFiscale,
    p.DataNascita
FROM [Persone].[Persona] p
WHERE {whereSql}
ORDER BY p.Cognome, p.Nome
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var totalCount = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(countSql, parameters, cancellationToken: cancellationToken));

        var items = (await connection.QueryAsync<PersonaSearchItem>(
            new CommandDefinition(listSql, parameters, cancellationToken: cancellationToken)))
            .ToList();

        return new PagedResponse<PersonaSearchItem>(items, query.Page, query.PageSize, totalCount);
    }
}
