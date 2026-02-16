using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediCreate;

internal static class DbIntrospection
{
    internal sealed record ColumnInfo(
        string Name,
        bool IsNullable,
        bool HasDefault,
        string TypeName,
        byte GeneratedAlwaysType,
        bool IsIdentity,
        bool IsComputed,
        bool IsHidden)
    {
        public bool IsGeneratedAlways => GeneratedAlwaysType != 0;
        public bool IsInsertable => !IsIdentity && !IsComputed && !IsHidden && !IsGeneratedAlways;
    }

    public static async Task<IReadOnlyDictionary<string, ColumnInfo>> GetColumnsAsync(
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                c.name AS [Name],
                CAST(c.is_nullable AS bit) AS [IsNullable],
                CAST(CASE WHEN dc.object_id IS NULL THEN 0 ELSE 1 END AS bit) AS [HasDefault],
                t.name AS [TypeName],
                CAST(c.generated_always_type AS tinyint) AS [GeneratedAlwaysType],
                CAST(c.is_identity AS bit) AS [IsIdentity],
                CAST(c.is_computed AS bit) AS [IsComputed],
                CAST(c.is_hidden AS bit) AS [IsHidden]
            FROM sys.columns c
            INNER JOIN sys.objects o ON o.object_id = c.object_id
            INNER JOIN sys.types t ON t.user_type_id = c.user_type_id
            LEFT JOIN sys.default_constraints dc
                ON dc.parent_object_id = c.object_id
               AND dc.parent_column_id = c.column_id
            WHERE o.object_id = OBJECT_ID('[Organizzazioni].[Sede]')
            ORDER BY c.column_id;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var cols = (await connection.QueryAsync<ColumnInfo>(new CommandDefinition(sql, cancellationToken: cancellationToken))).ToList();
        return cols.ToDictionary(c => c.Name, c => c, StringComparer.OrdinalIgnoreCase);
    }

    public static object GetActorDbValue(IReadOnlyDictionary<string, ColumnInfo> columns, string columnName, string actor)
    {
        if (!columns.TryGetValue(columnName, out var col))
        {
            return actor;
        }

        if (col.TypeName.Equals("int", StringComparison.OrdinalIgnoreCase))
        {
            return int.TryParse(actor, out var v) ? v : 0;
        }

        if (col.TypeName.Equals("smallint", StringComparison.OrdinalIgnoreCase))
        {
            return short.TryParse(actor, out var v) ? v : (short)0;
        }

        if (col.TypeName.Equals("tinyint", StringComparison.OrdinalIgnoreCase))
        {
            return byte.TryParse(actor, out var v) ? v : (byte)0;
        }

        if (col.TypeName.Equals("bigint", StringComparison.OrdinalIgnoreCase))
        {
            return long.TryParse(actor, out var v) ? v : 0L;
        }

        return actor;
    }
}

