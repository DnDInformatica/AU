using Accredia.SIGAD.Shared.Auth;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.GetByIdInt;
using Microsoft.AspNetCore.Mvc;
using Accredia.SIGAD.Shared.Permessi;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.CreateInt;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/certificazioni", "CertificazioniCreateInt", async (
                CreateCertificazioneRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                if (response is null)
                {
                    return Results.Conflict("Creazione certificazione non riuscita.");
                }

                var location = $"/{ApiVersioning.DefaultVersion}/certificazioni/{response.CertificazioneId}";
                return Results.Created(location, response);
            },
            builder => builder.RichiedePermesso(PermessiSigad.Certificazioni.Creazione, PermessiSigad.Incarichi.Creazione)
                .Produces<CertificazioneDetailDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());
    }
}
