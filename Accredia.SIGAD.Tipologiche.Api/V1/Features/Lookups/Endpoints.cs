using System.Data;
using System.Text.RegularExpressions;
using Dapper;
using Accredia.SIGAD.Tipologiche.Api;
using Accredia.SIGAD.Tipologiche.Api.Database;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Lookups;

internal static class Endpoints
{
    private static readonly Regex SafeName = new(@"^[A-Za-z0-9_]+$", RegexOptions.Compiled);

    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/lookups", "ListLookupTypes", async (
                ILookupMetadataProvider metadata,
                CancellationToken cancellationToken) =>
            {
                var types = await metadata.ListTypesAsync(cancellationToken);
                return Results.Ok(types);
            },
            builder => builder.Produces<IReadOnlyCollection<LookupTypeDto>>(StatusCodes.Status200OK));

        ApiVersioning.MapVersionedGet(app, "/lookups/{name}", "ListLookupItems", async (
                string name,
                string? q,
                bool? includeInactive,
                bool? includeDeleted,
                int? page,
                int? pageSize,
                ILookupMetadataProvider metadata,
                ISqlConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                if (!SafeName.IsMatch(name))
                {
                    return Results.ValidationProblem(new Dictionary<string, string[]>
                    {
                        ["name"] = ["Nome tipologica non valido."]
                    });
                }

                var table = await metadata.GetTableAsync(name, cancellationToken);
                if (table is null)
                {
                    return Results.NotFound();
                }

                var normalizedPage = Math.Max(1, page ?? 1);
                var normalizedPageSize = Math.Clamp(pageSize ?? 50, 1, 200);
                var offset = (normalizedPage - 1) * normalizedPageSize;
                var query = string.IsNullOrWhiteSpace(q) ? null : q.Trim();

                var where = new List<string>();
                var p = new DynamicParameters();

                if (!string.IsNullOrWhiteSpace(query))
                {
                    // Best-effort text search over description and code (if present).
                    where.Add($"([{table.DescriptionColumn}] LIKE '%' + @Q + '%'");
                    if (table.CodeColumn is not null)
                    {
                        where[^1] += $" OR [{table.CodeColumn}] LIKE '%' + @Q + '%'";
                    }
                    where[^1] += ")";
                    p.Add("Q", query);
                }

                if (includeInactive != true && table.IsActiveColumn is not null)
                {
                    where.Add($"[{table.IsActiveColumn}] = 1");
                }

                if (includeDeleted != true && table.DataCancellazioneColumn is not null)
                {
                    where.Add($"[{table.DataCancellazioneColumn}] IS NULL");
                }

                var whereSql = where.Count == 0 ? string.Empty : $"WHERE {string.Join(" AND ", where)}";
                var orderBy = table.OrdineColumn is not null
                    ? $"ORDER BY [{table.OrdineColumn}], [{table.DescriptionColumn}]"
                    : $"ORDER BY [{table.DescriptionColumn}]";

                var selectCols = new List<string>
                {
                    $"[{table.PrimaryKeyColumn}] AS [Id]",
                    $"[{table.DescriptionColumn}] AS [Description]"
                };

                if (table.CodeColumn is not null)
                {
                    selectCols.Insert(1, $"[{table.CodeColumn}] AS [Code]");
                }

                if (table.IsActiveColumn is not null)
                {
                    selectCols.Add($"[{table.IsActiveColumn}] AS [IsActive]");
                }

                if (table.OrdineColumn is not null)
                {
                    selectCols.Add($"[{table.OrdineColumn}] AS [Ordine]");
                }

                var selectSql = $"""
SELECT {string.Join(", ", selectCols)}
FROM [{table.Schema}].[{table.Table}]
{whereSql}
{orderBy}
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
;

SELECT COUNT(1)
FROM [{table.Schema}].[{table.Table}]
{whereSql}
""";

                p.Add("Offset", offset);
                p.Add("PageSize", normalizedPageSize);

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                using var multi = await connection.QueryMultipleAsync(
                    new CommandDefinition(selectSql, p, cancellationToken: cancellationToken));

                var items = (await multi.ReadAsync<LookupItemDto>()).ToArray();
                var total = await multi.ReadSingleAsync<int>();

                return Results.Ok(new PagedResponse<LookupItemDto>(items, normalizedPage, normalizedPageSize, total));
            },
            builder => builder
                .Produces<PagedResponse<LookupItemDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}

