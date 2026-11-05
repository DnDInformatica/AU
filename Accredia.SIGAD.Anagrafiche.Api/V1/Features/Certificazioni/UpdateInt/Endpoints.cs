using Accredia.SIGAD.Shared.Auth;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.GetByIdInt;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.UpdateInt;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPut(app, "/certificazioni/{id:int}", "CertificazioniUpdateInt", async (
                int id,
                UpdateCertificazioneRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder.RichiedePermesso("SIDAC.CERT.UPDATE", "SIDAC.INC.UPDATE")
                .Produces<CertificazioneDetailDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}
