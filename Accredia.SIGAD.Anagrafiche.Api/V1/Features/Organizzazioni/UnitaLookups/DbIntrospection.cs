using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaLookups;

internal static class DbIntrospection
{
    internal sealed record ReferenceTarget(string RefSchema, string RefTable, string RefColumn);

    internal sealed record ColumnInfo(string Name);

    public static async Task<ReferenceTarget?> GetReferenceTargetAsync(
        IDbConnectionFactory connectionFactory,
        string parentSchema,
        string parentTable,
        string parentColumn,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT TOP (1)
                sch_ref.name AS [RefSchema],
                tab_ref.name AS [RefTable],
                col_ref.name AS [RefColumn]
            FROM sys.foreign_key_columns fkc
            INNER JOIN sys.tables tab_parent ON tab_parent.object_id = fkc.parent_object_id
            INNER JOIN sys.schemas sch_parent ON sch_parent.schema_id = tab_parent.schema_id
            INNER JOIN sys.columns col_parent
                ON col_parent.object_id = fkc.parent_object_id
               AND col_parent.column_id = fkc.parent_column_id
            INNER JOIN sys.tables tab_ref ON tab_ref.object_id = fkc.referenced_object_id
            INNER JOIN sys.schemas sch_ref ON sch_ref.schema_id = tab_ref.schema_id
            INNER JOIN sys.columns col_ref
                ON col_ref.object_id = fkc.referenced_object_id
               AND col_ref.column_id = fkc.referenced_column_id
            WHERE sch_parent.name = @ParentSchema
              AND tab_parent.name = @ParentTable
              AND col_parent.name = @ParentColumn;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<ReferenceTarget>(
            new CommandDefinition(
                sql,
                new { ParentSchema = parentSchema, ParentTable = parentTable, ParentColumn = parentColumn },
                cancellationToken: cancellationToken));
    }

    public static async Task<IReadOnlyList<string>> GetColumnNamesAsync(
        IDbConnectionFactory connectionFactory,
        string schema,
        string table,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT c.name AS [Name]
            FROM sys.columns c
            INNER JOIN sys.objects o ON o.object_id = c.object_id
            INNER JOIN sys.schemas s ON s.schema_id = o.schema_id
            WHERE s.name = @SchemaName
              AND o.name = @TableName
            ORDER BY c.column_id;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var cols = (await connection.QueryAsync<ColumnInfo>(
            new CommandDefinition(sql, new { SchemaName = schema, TableName = table }, cancellationToken: cancellationToken))).ToList();
        return cols.Select(c => c.Name).ToList();
    }
}

