using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetSedi;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediGetById;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{orgId:int}/sedi/{sedeId:int}", "OrganizzazioniGetSedeById", async (
                int orgId,
                int sedeId,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(orgId, sedeId);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<SedeDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}

