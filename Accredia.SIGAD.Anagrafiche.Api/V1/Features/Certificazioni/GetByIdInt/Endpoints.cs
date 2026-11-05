using Accredia.SIGAD.Shared.Auth;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Shared.Permessi;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.GetByIdInt;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/certificazioni/{id:int}", "CertificazioniGetByIdInt", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder.RichiedePermesso(PermessiSigad.Certificazioni.Elenco, PermessiSigad.Certificazioni.Lettura, PermessiSigad.Incarichi.Elenco, PermessiSigad.Incarichi.Lettura)
                .Produces<CertificazioneDetailDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}
