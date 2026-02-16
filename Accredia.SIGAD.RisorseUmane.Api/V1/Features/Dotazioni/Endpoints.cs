using Accredia.SIGAD.RisorseUmane.Api.Database;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Dotazioni;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/dotazioni/{id:int}", "GetDotazioneById",
            async (int id, bool? includeDeleted, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.GetByIdAsync(id, includeDeleted == true, connectionFactory, cancellationToken),
            builder => builder
                .Produces<DotazioneDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound));

        ApiVersioning.MapVersionedGet(app, "/dipendenti/{dipendenteId:int}/dotazioni", "ListDotazioniByDipendente",
            async (int dipendenteId, bool? includeDeleted, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.ListByDipendenteAsync(dipendenteId, includeDeleted == true, connectionFactory, cancellationToken),
            builder => builder
                .Produces<IReadOnlyCollection<DotazioneDto>>(StatusCodes.Status200OK));

        ApiVersioning.MapVersionedPost(app, "/dipendenti/{dipendenteId:int}/dotazioni", "CreateDotazione",
            async (int dipendenteId, DotazioneCreateRequest request, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var errors = Validator.Validate(request);
                if (errors.Count > 0)
                {
                    return Results.ValidationProblem(errors);
                }

                return await Handler.CreateAsync(dipendenteId, request, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces<DotazioneCreateResponse>(StatusCodes.Status201Created)
                .Produces<ErrorResponse>(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/dipendenti/{dipendenteId:int}/dotazioni/{id:int}", "UpdateDotazione",
            async (int dipendenteId, int id, DotazioneUpdateRequest request, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
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

        ApiVersioning.MapVersionedDelete(app, "/dipendenti/{dipendenteId:int}/dotazioni/{id:int}", "DeleteDotazione",
            async (int dipendenteId, int id, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.SoftDeleteAsync(dipendenteId, id, connectionFactory, cancellationToken),
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound));
    }
}

