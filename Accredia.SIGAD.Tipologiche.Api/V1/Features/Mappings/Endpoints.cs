using Dapper;
using Accredia.SIGAD.Tipologiche.Api;
using Accredia.SIGAD.Tipologiche.Api.Database;
using Accredia.SIGAD.Tipologiche.Api.V1.Features.Lookups;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Mappings;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/mappings/categoria-sede", "ListMappingCategoriaSede", async (
                string? categoriaOrigine,
                int? tipoUnitaOrganizzativaId,
                int? tipoSedeId,
                bool? principale,
                bool? escludere,
                int? page,
                int? pageSize,
                ISqlConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var normalizedPage = Math.Max(1, page ?? 1);
                var normalizedPageSize = Math.Clamp(pageSize ?? 100, 1, 500);
                var offset = (normalizedPage - 1) * normalizedPageSize;

                var where = new List<string>();
                var p = new DynamicParameters();

                if (!string.IsNullOrWhiteSpace(categoriaOrigine))
                {
                    where.Add("[CategoriaOrigine] = @CategoriaOrigine");
                    p.Add("CategoriaOrigine", categoriaOrigine.Trim());
                }

                if (tipoUnitaOrganizzativaId is not null)
                {
                    where.Add("[TipoUnitaOrganizzativaId] = @TipoUnitaOrganizzativaId");
                    p.Add("TipoUnitaOrganizzativaId", tipoUnitaOrganizzativaId);
                }

                if (tipoSedeId is not null)
                {
                    where.Add("[TipoSedeId] = @TipoSedeId");
                    p.Add("TipoSedeId", tipoSedeId);
                }

                if (principale is not null)
                {
                    where.Add("[Principale] = @Principale");
                    p.Add("Principale", principale);
                }

                if (escludere is not null)
                {
                    where.Add("[Escludere] = @Escludere");
                    p.Add("Escludere", escludere);
                }

                var whereSql = where.Count == 0 ? string.Empty : $"WHERE {string.Join(" AND ", where)}";

                var sql = $"""
SELECT
    [MappingId],
    [CategoriaOrigine],
    [TipoUnitaOrganizzativaId],
    [TipoSedeId],
    [Principale],
    [Escludere],
    [Note]
FROM [Tipologica].[MappingCategoriaSede]
{whereSql}
ORDER BY [MappingId]
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
;

SELECT COUNT(1)
FROM [Tipologica].[MappingCategoriaSede]
{whereSql}
""";

                p.Add("Offset", offset);
                p.Add("PageSize", normalizedPageSize);

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                using var multi = await connection.QueryMultipleAsync(new CommandDefinition(sql, p, cancellationToken: cancellationToken));
                var items = (await multi.ReadAsync<MappingCategoriaSedeDto>()).ToArray();
                var total = await multi.ReadSingleAsync<int>();

                return Results.Ok(new PagedResponse<MappingCategoriaSedeDto>(items, normalizedPage, normalizedPageSize, total));
            },
            builder => builder
                .Produces<PagedResponse<MappingCategoriaSedeDto>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/mappings/tipo-sede-indirizzo", "ListMappingTipoSedeIndirizzo", async (
                string? tipoSedeOrigine,
                int? tipoIndirizzoId,
                bool? principale,
                int? page,
                int? pageSize,
                ISqlConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var normalizedPage = Math.Max(1, page ?? 1);
                var normalizedPageSize = Math.Clamp(pageSize ?? 100, 1, 500);
                var offset = (normalizedPage - 1) * normalizedPageSize;

                var where = new List<string>();
                var p = new DynamicParameters();

                if (!string.IsNullOrWhiteSpace(tipoSedeOrigine))
                {
                    where.Add("[TipoSedeOrigine] = @TipoSedeOrigine");
                    p.Add("TipoSedeOrigine", tipoSedeOrigine.Trim());
                }

                if (tipoIndirizzoId is not null)
                {
                    where.Add("[TipoIndirizzoId] = @TipoIndirizzoId");
                    p.Add("TipoIndirizzoId", tipoIndirizzoId);
                }

                if (principale is not null)
                {
                    where.Add("[Principale] = @Principale");
                    p.Add("Principale", principale);
                }

                var whereSql = where.Count == 0 ? string.Empty : $"WHERE {string.Join(" AND ", where)}";

                var sql = $"""
SELECT
    [MappingId],
    [TipoSedeOrigine],
    [TipoIndirizzoId],
    [Principale],
    [Note]
FROM [Tipologica].[MappingTipoSedeIndirizzo]
{whereSql}
ORDER BY [MappingId]
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
;

SELECT COUNT(1)
FROM [Tipologica].[MappingTipoSedeIndirizzo]
{whereSql}
""";

                p.Add("Offset", offset);
                p.Add("PageSize", normalizedPageSize);

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                using var multi = await connection.QueryMultipleAsync(new CommandDefinition(sql, p, cancellationToken: cancellationToken));
                var items = (await multi.ReadAsync<MappingTipoSedeIndirizzoDto>()).ToArray();
                var total = await multi.ReadSingleAsync<int>();

                return Results.Ok(new PagedResponse<MappingTipoSedeIndirizzoDto>(items, normalizedPage, normalizedPageSize, total));
            },
            builder => builder
                .Produces<PagedResponse<MappingTipoSedeIndirizzoDto>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());
    }
}

