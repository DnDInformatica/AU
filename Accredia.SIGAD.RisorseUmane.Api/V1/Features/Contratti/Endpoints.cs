using Accredia.SIGAD.RisorseUmane.Api.Database;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Contratti;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/contratti/{id:int}", "GetContrattoById",
            async (int id, bool? includeDeleted, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.GetByIdAsync(id, includeDeleted == true, connectionFactory, cancellationToken),
            builder => builder
                .Produces<ContrattoDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound));

        ApiVersioning.MapVersionedGet(app, "/dipendenti/{dipendenteId:int}/contratti", "ListContrattiByDipendente",
            async (int dipendenteId, bool? includeDeleted, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.ListByDipendenteAsync(dipendenteId, includeDeleted == true, connectionFactory, cancellationToken),
            builder => builder
                .Produces<IReadOnlyCollection<ContrattoDto>>(StatusCodes.Status200OK));

        ApiVersioning.MapVersionedPost(app, "/dipendenti/{dipendenteId:int}/contratti", "CreateContratto",
            async (int dipendenteId, ContrattoCreateRequest request, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var errors = Validator.Validate(request);
                if (errors.Count > 0)
                {
                    return Results.ValidationProblem(errors);
                }

                return await Handler.CreateAsync(dipendenteId, request, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces<ContrattoCreateResponse>(StatusCodes.Status201Created)
                .Produces<ErrorResponse>(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/dipendenti/{dipendenteId:int}/contratti/{id:int}", "UpdateContratto",
            async (int dipendenteId, int id, ContrattoUpdateRequest request, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var errors = Validator.Validate(request);
                if (errors.Count > 0)
                {
                    return Results.ValidationProblem(errors);
                }

                return await Handler.UpdateAsync(dipendenteId, id, request, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound)
                .Produces<ErrorResponse>(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/dipendenti/{dipendenteId:int}/contratti/{id:int}", "DeleteContratto",
            async (int dipendenteId, int id, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.SoftDeleteAsync(dipendenteId, id, connectionFactory, cancellationToken),
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound));

        ApiVersioning.MapVersionedGet(app, "/contratti/{id:int}/storico", "GetContrattoStorico",
            async (int id, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.StoricoAsync(id, connectionFactory, cancellationToken),
            builder => builder
                .Produces<IReadOnlyCollection<ContrattoStoricoDto>>(StatusCodes.Status200OK));
    }
}

