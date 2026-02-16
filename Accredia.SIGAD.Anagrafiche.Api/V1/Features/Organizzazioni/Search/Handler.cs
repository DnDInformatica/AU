using System.Text.RegularExpressions;
using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Search;

internal static class Handler
{
    public static async Task<PagedResponse<OrganizzazioneSearchItem>> Handle(
        Query query,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(query);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var trimmed = query.Q.Trim();
        var isPiva = Regex.IsMatch(trimmed, @"^\d{11}$");
        var isCf = Regex.IsMatch(trimmed, @"^[A-Za-z0-9]{16}$");
        var offset = (query.Page - 1) * query.PageSize;

        const string baseWhere = @"
o.DataCancellazione IS NULL
AND o.DataInizioValidita <= SYSUTCDATETIME()
AND o.DataFineValidita >= SYSUTCDATETIME()";

        string filterSql;
        var parameters = new DynamicParameters();
        parameters.Add("Offset", offset);
        parameters.Add("PageSize", query.PageSize);
        parameters.Add("StatoAttivitaId", query.StatoAttivitaId);
        parameters.Add("TipoOrganizzazioneId", query.TipoOrganizzazioneId);

        if (isPiva)
        {
            filterSql = "o.PartitaIVA = @Query";
            parameters.Add("Query", trimmed);
        }
        else if (isCf)
        {
            filterSql = "o.CodiceFiscale = @Query";
            parameters.Add("Query", trimmed);
        }
        else
        {
            filterSql = @"
o.Denominazione LIKE @Like
OR o.RagioneSociale LIKE @Like
OR o.PartitaIVA LIKE @Like
OR o.CodiceFiscale LIKE @Like";
            parameters.Add("Like", $"%{trimmed}%");
        }

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        // Best-effort: the DEV schema might not include the column yet.
        var hasTipoColumn = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(
                "SELECT CASE WHEN COL_LENGTH('[Organizzazioni].[Organizzazione]', 'TipoOrganizzazioneId') IS NULL THEN 0 ELSE 1 END;",
                cancellationToken: cancellationToken));

        var tipoWhere = hasTipoColumn == 1
            ? " AND (@TipoOrganizzazioneId IS NULL OR o.TipoOrganizzazioneId = @TipoOrganizzazioneId)"
            : string.Empty;

        var whereSql = $"{baseWhere} AND ({filterSql}) AND (@StatoAttivitaId IS NULL OR o.StatoAttivitaId = @StatoAttivitaId){tipoWhere}";

        var countSql = $@"
SELECT COUNT(1)
FROM [Organizzazioni].[Organizzazione] o
WHERE {whereSql};";

        var listSql = $@"
SELECT
    o.OrganizzazioneId,
    o.Denominazione,
    o.RagioneSociale,
    o.CodiceFiscale,
    o.PartitaIVA,
    o.StatoAttivitaId
FROM [Organizzazioni].[Organizzazione] o
WHERE {whereSql}
ORDER BY o.Denominazione
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";

        var totalCount = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(countSql, parameters, cancellationToken: cancellationToken));

        var items = (await connection.QueryAsync<OrganizzazioneSearchItem>(
            new CommandDefinition(listSql, parameters, cancellationToken: cancellationToken)))
            .ToList();

        return new PagedResponse<OrganizzazioneSearchItem>(items, query.Page, query.PageSize, totalCount);
    }
}
