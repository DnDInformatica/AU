using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.Search;

internal static class Handler
{
    public static async Task<PagedResponse<CertificazioneSearchItem>> Handle(
        Query query,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(query);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var trimmed = query.Q.Trim();
        var offset = (query.Page - 1) * query.PageSize;
        var parameters = new DynamicParameters();
        parameters.Add("Offset", offset);
        parameters.Add("PageSize", query.PageSize);
        parameters.Add("Like", $"%{trimmed}%");

        const string whereSql = @"
(e.Denominazione LIKE @Like OR ISNULL(e.Sigla, '') LIKE @Like OR ISNULL(e.Note, '') LIKE @Like)
AND (e.DataInizioValidita IS NULL OR e.DataInizioValidita <= SYSUTCDATETIME())
AND (e.DataFineValidita IS NULL OR e.DataFineValidita >= SYSUTCDATETIME())";

        var countSql = $@"
SELECT COUNT(1)
FROM [Accreditamento].[EnteAccreditamento] e
WHERE {whereSql};";

        var listSql = $@"
SELECT
    e.EnteAccreditamentoId AS CertificazioneId,
    e.Denominazione,
    e.Sigla,
    e.DataFondazione,
    CAST(CASE WHEN e.DataCancellazione IS NULL THEN 0 ELSE 1 END AS bit) AS IsDeleted
FROM [Accreditamento].[EnteAccreditamento] e
WHERE {whereSql}
ORDER BY e.Denominazione
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var totalCount = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(countSql, parameters, cancellationToken: cancellationToken));

        var items = (await connection.QueryAsync<CertificazioneSearchItem>(
            new CommandDefinition(listSql, parameters, cancellationToken: cancellationToken)))
            .ToList();

        return new PagedResponse<CertificazioneSearchItem>(items, query.Page, query.PageSize, totalCount);
    }
}
