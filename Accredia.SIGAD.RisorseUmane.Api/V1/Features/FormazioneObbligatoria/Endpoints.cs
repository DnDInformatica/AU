using Accredia.SIGAD.RisorseUmane.Api.Database;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.FormazioneObbligatoria;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/formazione-obbligatoria/{id:int}", "GetFormazioneObbligatoriaById",
            async (int id, bool? includeDeleted, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.GetByIdAsync(id, includeDeleted == true, connectionFactory, cancellationToken),
            builder => builder
                .Produces<FormazioneObbligatoriaDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound));

        ApiVersioning.MapVersionedGet(app, "/dipendenti/{dipendenteId:int}/formazione-obbligatoria", "ListFormazioneObbligatoriaByDipendente",
            async (int dipendenteId, bool? includeDeleted, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.ListByDipendenteAsync(dipendenteId, includeDeleted == true, connectionFactory, cancellationToken),
            builder => builder
                .Produces<IReadOnlyCollection<FormazioneObbligatoriaDto>>(StatusCodes.Status200OK));

        ApiVersioning.MapVersionedPost(app, "/dipendenti/{dipendenteId:int}/formazione-obbligatoria", "CreateFormazioneObbligatoria",
            async (int dipendenteId, FormazioneObbligatoriaCreateRequest request, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var errors = Validator.Validate(request);
                if (errors.Count > 0)
                {
                    return Results.ValidationProblem(errors);
                }

                return await Handler.CreateAsync(dipendenteId, request, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces<FormazioneObbligatoriaCreateResponse>(StatusCodes.Status201Created)
                .Produces<ErrorResponse>(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/dipendenti/{dipendenteId:int}/formazione-obbligatoria/{id:int}", "UpdateFormazioneObbligatoria",
            async (int dipendenteId, int id, FormazioneObbligatoriaUpdateRequest request, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
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

        ApiVersioning.MapVersionedDelete(app, "/dipendenti/{dipendenteId:int}/formazione-obbligatoria/{id:int}", "DeleteFormazioneObbligatoria",
            async (int dipendenteId, int id, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.SoftDeleteAsync(dipendenteId, id, connectionFactory, cancellationToken),
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound));
    }
}

