using Dapper;
using Accredia.SIGAD.Tipologiche.Api.Database;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Lookups;

internal interface ILookupMetadataProvider
{
    Task<IReadOnlyCollection<LookupTypeDto>> ListTypesAsync(CancellationToken cancellationToken);
    Task<LookupTableMetadata?> GetTableAsync(string name, CancellationToken cancellationToken);
}

internal sealed class LookupMetadataProvider : ILookupMetadataProvider
{
    private const string LookupSchema = "Tipologica";
    private readonly ISqlConnectionFactory _connectionFactory;
    private readonly SemaphoreSlim _gate = new(1, 1);
    private Dictionary<string, LookupTableMetadata>? _cache;

    public LookupMetadataProvider(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IReadOnlyCollection<LookupTypeDto>> ListTypesAsync(CancellationToken cancellationToken)
    {
        var cache = await EnsureLoadedAsync(cancellationToken);
        return cache.Keys
            .OrderBy(x => x, StringComparer.OrdinalIgnoreCase)
            .Select(x => new LookupTypeDto(x))
            .ToArray();
    }

    public async Task<LookupTableMetadata?> GetTableAsync(string name, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            return null;
        }

        var normalized = name.Trim();
        var cache = await EnsureLoadedAsync(cancellationToken);
        return cache.GetValueOrDefault(normalized);
    }

    private async Task<Dictionary<string, LookupTableMetadata>> EnsureLoadedAsync(CancellationToken cancellationToken)
    {
        if (_cache is not null)
        {
            return _cache;
        }

        await _gate.WaitAsync(cancellationToken);
        try
        {
            if (_cache is not null)
            {
                return _cache;
            }

            await using var connection = await _connectionFactory.CreateOpenConnectionAsync(cancellationToken);

            // Tables list
            const string tablesSql = """
SELECT t.name
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name = @Schema;
""";

            var tableNames = (await connection.QueryAsync<string>(
                    new CommandDefinition(tablesSql, new { Schema = LookupSchema }, cancellationToken: cancellationToken)))
                .ToArray();

            var cache = new Dictionary<string, LookupTableMetadata>(StringComparer.OrdinalIgnoreCase);
            foreach (var table in tableNames)
            {
                var meta = await LoadMetadataAsync(connection, table, cancellationToken);
                if (meta is not null)
                {
                    cache[table] = meta;
                }
            }

            _cache = cache;
            return cache;
        }
        finally
        {
            _gate.Release();
        }
    }

    private static async Task<LookupTableMetadata?> LoadMetadataAsync(
        System.Data.Common.DbConnection connection,
        string table,
        CancellationToken cancellationToken)
    {
        // Detect PK (single-column only)
        const string pkSql = """
SELECT TOP 2 c.name
FROM sys.key_constraints kc
JOIN sys.schemas s ON s.schema_id = kc.schema_id
JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id
JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
WHERE kc.type = 'PK'
  AND s.name = @Schema
  AND OBJECT_NAME(kc.parent_object_id) = @Table
ORDER BY ic.key_ordinal;
""";

        var pkColumns = (await connection.QueryAsync<string>(
                new CommandDefinition(pkSql, new { Schema = LookupSchema, Table = table }, cancellationToken: cancellationToken)))
            .ToArray();

        if (pkColumns.Length != 1)
        {
            // Composite PK or missing PK: skip for now to avoid ambiguous reads.
            return null;
        }

        var pk = pkColumns[0];

        // Columns list
        const string colsSql = """
SELECT c.name
FROM sys.columns c
JOIN sys.tables t ON t.object_id = c.object_id
JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name = @Schema AND t.name = @Table;
""";

        var columns = (await connection.QueryAsync<string>(
                new CommandDefinition(colsSql, new { Schema = LookupSchema, Table = table }, cancellationToken: cancellationToken)))
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        string? Pick(params string[] candidates)
            => candidates.FirstOrDefault(c => columns.Contains(c));

        var code = Pick("Codice", "Code");
        var description = Pick("Descrizione", "Description", "Nome", "Name");
        if (description is null)
        {
            return null;
        }

        var isActive = Pick("IsActive", "Attivo", "IsEnabled");
        var ordine = Pick("Ordine", "Ordinamento");
        var dataCancellazione = Pick("DataCancellazione");

        return new LookupTableMetadata(
            Schema: LookupSchema,
            Table: table,
            PrimaryKeyColumn: pk,
            CodeColumn: code,
            DescriptionColumn: description,
            IsActiveColumn: isActive,
            OrdineColumn: ordine,
            DataCancellazioneColumn: dataCancellazione);
    }
}

