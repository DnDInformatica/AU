using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaLookups;

internal static class Handler
{
    public static async Task<UnitaLookupsResponse?> Handle(
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var tipiUo = await LoadLookupAsync(connectionFactory, "TipoUnitaOrganizzativaId", cancellationToken);
        var tipiSede = await LoadLookupAsync(connectionFactory, "TipoSedeId", cancellationToken);

        if (tipiUo is null || tipiSede is null)
        {
            return null;
        }

        return new UnitaLookupsResponse(tipiUo, tipiSede);
    }

    private static async Task<IReadOnlyList<LookupItem>?> LoadLookupAsync(
        IDbConnectionFactory connectionFactory,
        string parentColumn,
        CancellationToken cancellationToken)
    {
        var target = await DbIntrospection.GetReferenceTargetAsync(
            connectionFactory,
            parentSchema: "Organizzazioni",
            parentTable: "UnitaOrganizzativa",
            parentColumn: parentColumn,
            cancellationToken: cancellationToken);

        if (target is null)
        {
            return null;
        }

        var columns = await DbIntrospection.GetColumnNamesAsync(connectionFactory, target.RefSchema, target.RefTable, cancellationToken);
        var columnsSet = new HashSet<string>(columns, StringComparer.OrdinalIgnoreCase);

        // Prefer "Codice + Descrizione" when both exist (per UX spec).
        var codeCandidates = new[] { "Codice", "Code" };
        var descCandidates = new[] { "Descrizione", "Description", "Nome", "Name", "Titolo" };

        var codeCol = codeCandidates.FirstOrDefault(columnsSet.Contains);
        var descCol = descCandidates.FirstOrDefault(columnsSet.Contains);
        descCol ??= target.RefColumn; // last resort

        var hasDataCancellazione = columnsSet.Contains("DataCancellazione");
        var hasIsActive = columnsSet.Contains("IsActive");

        var where = new List<string>();
        if (hasDataCancellazione)
        {
            where.Add("[DataCancellazione] IS NULL");
        }

        if (hasIsActive)
        {
            where.Add("[IsActive] = 1");
        }

        var whereSql = where.Count > 0 ? $"WHERE {string.Join(" AND ", where)}" : string.Empty;

        var labelExpr = BuildLabelExpression(codeCol, descCol);

        var sql = $"""
            SELECT
                CAST([{target.RefColumn}] AS int) AS [Id],
                {labelExpr} AS [Label]
            FROM [{target.RefSchema}].[{target.RefTable}]
            {whereSql}
            ORDER BY [Label];
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var items = (await connection.QueryAsync<LookupItem>(new CommandDefinition(sql, cancellationToken: cancellationToken))).ToList();

        return items;
    }

    private static string BuildLabelExpression(string? codeCol, string descCol)
    {
        // Note: columns come from sys catalogs; still quote with [].
        var desc = $"[{descCol}]";

        if (string.IsNullOrWhiteSpace(codeCol))
        {
            return $"CAST({desc} AS nvarchar(400))";
        }

        var code = $"[{codeCol}]";

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
