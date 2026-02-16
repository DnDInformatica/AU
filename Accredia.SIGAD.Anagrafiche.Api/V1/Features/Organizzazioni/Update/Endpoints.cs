using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Update;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        // Legacy scaffold (Guid-based) update endpoint.
        ApiVersioning.MapVersionedPut(app, "/anagrafiche/organizzazioni/{id:guid}", "OrganizzazioniUpdateLegacy", async (
                Guid id,
                UpdateOrganizzazioneRequest request,
                IDbConnectionFactory connectionFactory,
                IHostEnvironment environment,
                CancellationToken cancellationToken) =>
            {
                if (!environment.IsDevelopment())
                {
                    return Results.NotFound();
                }

                var command = new Command(id, request);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<OrganizzazioneDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}
