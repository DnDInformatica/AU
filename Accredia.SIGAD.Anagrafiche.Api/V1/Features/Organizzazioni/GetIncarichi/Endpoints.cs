using Accredia.SIGAD.Shared.Auth;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Shared.Permessi;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIncarichi;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{id:int}/incarichi", "OrganizzazioniGetIncarichi", async (
                int id,
                bool? includeDeleted,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id, includeDeleted == true);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder.RichiedePermesso(PermessiSigad.Incarichi.Elenco, PermessiSigad.Incarichi.Lettura)
                .Produces<IReadOnlyList<IncaricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}
