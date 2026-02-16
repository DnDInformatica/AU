using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.CreateInt;

internal static class DbIntrospection
{
    internal sealed record ColumnInfo(string Name, bool IsNullable, bool HasDefault);

    public static async Task<IReadOnlyDictionary<string, ColumnInfo>> GetColumnsAsync(
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                c.name AS [Name],
                CAST(c.is_nullable AS bit) AS [IsNullable],
                CAST(CASE WHEN dc.object_id IS NULL THEN 0 ELSE 1 END AS bit) AS [HasDefault]
            FROM sys.columns c
            INNER JOIN sys.objects o ON o.object_id = c.object_id
            LEFT JOIN sys.default_constraints dc
                ON dc.parent_object_id = c.object_id
               AND dc.parent_column_id = c.column_id
            WHERE o.object_id = OBJECT_ID('[Persone].[Persona]')
            ORDER BY c.column_id;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var cols = (await connection.QueryAsync<ColumnInfo>(new CommandDefinition(sql, cancellationToken: cancellationToken)))
            .ToList();

        return cols.ToDictionary(c => c.Name, c => c, StringComparer.OrdinalIgnoreCase);
    }
}

