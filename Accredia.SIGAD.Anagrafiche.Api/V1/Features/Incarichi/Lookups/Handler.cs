using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaLookups;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.Lookups;

internal static class Handler
{
    public static async Task<IReadOnlyList<LookupItem>?> Handle(
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(connectionFactory);

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var hasTable = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            "SELECT CASE WHEN OBJECT_ID('[Tipologica].[TipoRuolo]') IS NULL THEN 0 ELSE 1 END;",
            cancellationToken: cancellationToken));
        if (hasTable == 0)
        {
            return null;
        }

        var columns = await DbIntrospection.GetColumnNamesAsync(connectionFactory, "Tipologica", "TipoRuolo", cancellationToken);
        var set = new HashSet<string>(columns, StringComparer.OrdinalIgnoreCase);

        var idCandidates = new[] { "TipoRuoloId", "Id" };
        var codeCandidates = new[] { "Codice", "Code" };
        var descCandidates = new[] { "Descrizione", "Description", "Nome", "Name", "Titolo" };

        var idCol = idCandidates.FirstOrDefault(set.Contains);
        if (string.IsNullOrWhiteSpace(idCol))
        {
            return null;
        }

        var codeCol = codeCandidates.FirstOrDefault(set.Contains);
        var descCol = descCandidates.FirstOrDefault(set.Contains) ?? idCol;

        var hasDataCancellazione = set.Contains("DataCancellazione");
        var hasIsActive = set.Contains("IsActive");

        var where = new List<string>();
        if (hasDataCancellazione) where.Add("[DataCancellazione] IS NULL");
        if (hasIsActive) where.Add("[IsActive] = 1");
        var whereSql = where.Count > 0 ? $"WHERE {string.Join(" AND ", where)}" : string.Empty;

        var sql = $"""
            SELECT
                CAST([{idCol}] AS int) AS [Id],
                {BuildLabelExpression(codeCol, descCol)} AS [Label]
            FROM [Tipologica].[TipoRuolo]
            {whereSql}
            ORDER BY [Label];
            """;

        var items = (await connection.QueryAsync<LookupItem>(new CommandDefinition(sql, cancellationToken: cancellationToken))).ToList();
        return items;
    }

    private static string BuildLabelExpression(string? codeColumn, string descriptionColumn)
    {
        var desc = $"[{descriptionColumn}]";
        if (string.IsNullOrWhiteSpace(codeColumn))
        {
            return $"CAST({desc} AS nvarchar(400))";
        }

        var code = $"[{codeColumn}]";
        return $"""
            CASE
                WHEN NULLIF(LTRIM(RTRIM(CAST({code} AS nvarchar(100)))), '') IS NOT NULL
                 AND NULLIF(LTRIM(RTRIM(CAST({desc} AS nvarchar(300)))), '') IS NOT NULL
                    THEN CONCAT(CAST({code} AS nvarchar(100)), N' - ', CAST({desc} AS nvarchar(300)))
                WHEN NULLIF(LTRIM(RTRIM(CAST({code} AS nvarchar(100)))), '') IS NOT NULL
                    THEN CAST({code} AS nvarchar(400))
                ELSE CAST({desc} AS nvarchar(400))
            END
            """;
    }
}

