using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.List;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        // Legacy scaffold (Guid-based) list endpoint.
        ApiVersioning.MapVersionedGet(app, "/anagrafiche/organizzazioni", "OrganizzazioniListLegacy", async (
                int? page,
                int? pageSize,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(page ?? 1, pageSize ?? 20);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                return Results.Ok(response);
            },
            builder => builder
                .Produces<PagedResponse<OrganizzazioneDto>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());
    }
}
