using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Create;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        // Legacy dev-only endpoint (Guid-based) kept for backward compatibility with early scaffolding.
        // NOTE: real UX/API uses int-based [Organizzazioni].[Organizzazione] endpoints.
        ApiVersioning.MapVersionedPost(app, "/anagrafiche/organizzazioni", "OrganizzazioniCreateLegacy", async (
                CreateOrganizzazioneRequest request,
                IDbConnectionFactory connectionFactory,
                IHostEnvironment environment,
                CancellationToken cancellationToken) =>
            {
                if (!environment.IsDevelopment())
                {
                    return Results.NotFound();
                }

                var command = new Command(request);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                var location = $"/{ApiVersioning.DefaultVersion}/anagrafiche/organizzazioni/{response.OrganizzazioneId}";
                return Results.Created(location, response);
            },
            builder => builder
                .Produces<OrganizzazioneDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}
