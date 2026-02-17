using Accredia.SIGAD.RisorseUmane.Api.Database;
using Accredia.SIGAD.RisorseUmane.Api.Services;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Dipendenti;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/dipendenti/{id:int}", "GetDipendenteById",
            async (int id, bool? includeDeleted, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.GetByIdAsync(id, includeDeleted == true, connectionFactory, cancellationToken),
            builder => builder
                .Produces<DipendenteDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound));

        ApiVersioning.MapVersionedGet(app, "/dipendenti", "ListDipendenti",
            async (int? personaId, string? matricola, string? q, int? statoDipendenteId, bool? includeDeleted, int? page, int? pageSize,
                    ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.ListAsync(personaId, matricola, q, statoDipendenteId, includeDeleted == true, page ?? 1, pageSize ?? 20, connectionFactory, cancellationToken),
            builder => builder
                .Produces<PagedResponse<DipendenteDto>>(StatusCodes.Status200OK));

        ApiVersioning.MapVersionedPost(app, "/dipendenti", "CreateDipendente",
            async (DipendenteCreateRequest request,
                    IPersonaClient personaClient,
                    ISqlConnectionFactory connectionFactory,
                    CancellationToken cancellationToken) =>
            {
                var errors = Validator.Validate(request);
                if (errors.Count > 0)
                {
                    return Results.ValidationProblem(errors);
                }

                try
                {
                    var exists = await personaClient.ExistsAsync(request.PersonaId, cancellationToken);
                    if (!exists)
                    {
                        return Results.ValidationProblem(new Dictionary<string, string[]>
                        {
                            ["personaId"] = ["PersonaId non trovato in Anagrafiche."]
                        });
                    }
                }
                catch (HttpRequestException)
                {
                    return Results.Problem("Servizio Anagrafiche non disponibile.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                return await Handler.CreateAsync(request, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces<DipendenteCreateResponse>(StatusCodes.Status201Created)
                .Produces<ErrorResponse>(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/dipendenti/{id:int}", "UpdateDipendente",
            async (int id,
                    DipendenteUpdateRequest request,
                    IPersonaClient personaClient,
                    ISqlConnectionFactory connectionFactory,
                    CancellationToken cancellationToken) =>
            {
                var errors = Validator.Validate(request);
                if (errors.Count > 0)
                {
                    return Results.ValidationProblem(errors);
                }

                try
                {
                    var exists = await personaClient.ExistsAsync(request.PersonaId, cancellationToken);
                    if (!exists)
                    {
                        return Results.ValidationProblem(new Dictionary<string, string[]>
                        {
                            ["personaId"] = ["PersonaId non trovato in Anagrafiche."]
                        });
                    }
                }
                catch (HttpRequestException)
                {
                    return Results.Problem("Servizio Anagrafiche non disponibile.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                return await Handler.UpdateAsync(id, request, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound)
                .Produces<ErrorResponse>(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/dipendenti/{id:int}", "DeleteDipendente",
            async (int id, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.SoftDeleteAsync(id, connectionFactory, cancellationToken),
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound));

        ApiVersioning.MapVersionedGet(app, "/dipendenti/{id:int}/storico", "GetDipendenteStorico",
            async (int id, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.StoricoAsync(id, connectionFactory, cancellationToken),
            builder => builder
                .Produces<IReadOnlyCollection<DipendenteStoricoDto>>(StatusCodes.Status200OK));
    }
}
