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
    private const int MetadataCommandTimeoutSeconds = 30;
    private readonly ISqlConnectionFactory _connectionFactory;
    private readonly ILogger<LookupMetadataProvider> _logger;
    private readonly SemaphoreSlim _gate = new(1, 1);
    private Dictionary<string, LookupTableMetadata>? _cache;

    public LookupMetadataProvider(
        ISqlConnectionFactory connectionFactory,
        ILogger<LookupMetadataProvider> logger)
    {
        _connectionFactory = connectionFactory;
        _logger = logger;
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
                    new CommandDefinition(
                        tablesSql,
                        new { Schema = LookupSchema },
                        cancellationToken: cancellationToken,
                        commandTimeout: MetadataCommandTimeoutSeconds)))
                .ToArray();

            // Detect PK (single-column only) for all lookup tables in one round-trip.
            const string pksSql = """
SELECT OBJECT_NAME(kc.parent_object_id) AS TableName, c.name AS ColumnName
FROM sys.key_constraints kc
JOIN sys.schemas s ON s.schema_id = kc.schema_id
JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id
JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
WHERE kc.type = 'PK'
  AND s.name = @Schema
ORDER BY OBJECT_NAME(kc.parent_object_id), ic.key_ordinal;
""";

            var pkRows = await connection.QueryAsync<PkRow>(
                new CommandDefinition(
                    pksSql,
                    new { Schema = LookupSchema },
                    cancellationToken: cancellationToken,
                    commandTimeout: MetadataCommandTimeoutSeconds));

            var pkByTable = pkRows
                .GroupBy(x => x.TableName, StringComparer.OrdinalIgnoreCase)
                .Where(g => g.Count() == 1)
                .ToDictionary(g => g.Key, g => g.First().ColumnName, StringComparer.OrdinalIgnoreCase);

            // Columns list for all lookup tables in one round-trip.
            const string colsSql = """
SELECT t.name AS TableName, c.name AS ColumnName
FROM sys.columns c
JOIN sys.tables t ON t.object_id = c.object_id
JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE s.name = @Schema;
""";

            var columnRows = await connection.QueryAsync<ColumnRow>(
                new CommandDefinition(
                    colsSql,
                    new { Schema = LookupSchema },
                    cancellationToken: cancellationToken,
                    commandTimeout: MetadataCommandTimeoutSeconds));

            var columnsByTable = columnRows
                .GroupBy(x => x.TableName, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(
                    g => g.Key,
                    g => g.Select(x => x.ColumnName).ToHashSet(StringComparer.OrdinalIgnoreCase),
                    StringComparer.OrdinalIgnoreCase);

            var cache = new Dictionary<string, LookupTableMetadata>(StringComparer.OrdinalIgnoreCase);
            foreach (var table in tableNames)
            {
                if (!pkByTable.TryGetValue(table, out var pk))
                {
                    continue;
                }

                if (!columnsByTable.TryGetValue(table, out var columns))
                {
                    continue;
                }

                string? Pick(params string[] candidates)
                    => candidates.FirstOrDefault(c => columns.Contains(c));

                var code = Pick("Codice", "Code");
                var description = Pick("Descrizione", "Description", "Nome", "Name");
                if (description is null)
                {
                    continue;
                }

                var isActive = Pick("IsActive", "Attivo", "IsEnabled");
                var ordine = Pick("Ordine", "Ordinamento");
                var dataCancellazione = Pick("DataCancellazione");

                cache[table] = new LookupTableMetadata(
                    Schema: LookupSchema,
                    Table: table,
                    PrimaryKeyColumn: pk,
                    CodeColumn: code,
                    DescriptionColumn: description,
                    IsActiveColumn: isActive,
                    OrdineColumn: ordine,
                    DataCancellazioneColumn: dataCancellazione);
            }

            _cache = cache;
            return cache;
        }
        catch (OperationCanceledException ex) when (!cancellationToken.IsCancellationRequested)
        {
            _logger.LogWarning(ex,
                "Lookup metadata load canceled by infrastructure timeout; reusing cached metadata if available.");

            _cache ??= new Dictionary<string, LookupTableMetadata>(StringComparer.OrdinalIgnoreCase);
            return _cache;
        }
        finally
        {
            _gate.Release();
        }
    }

    private sealed record PkRow(string TableName, string ColumnName);
    private sealed record ColumnRow(string TableName, string ColumnName);
}
