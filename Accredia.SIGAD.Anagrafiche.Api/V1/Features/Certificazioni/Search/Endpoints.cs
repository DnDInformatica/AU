using Accredia.SIGAD.Shared.Auth;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Shared.Permessi;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.Search;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/certificazioni/search", "CertificazioniSearch", async (
                string q,
                int? page,
                int? pageSize,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var query = new Query(q, page ?? 1, pageSize ?? 10);
                var errors = Validator.Validate(query);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(query, connectionFactory, cancellationToken);
                return Results.Ok(response);
            },
            builder => builder.RichiedePermesso(PermessiSigad.Certificazioni.Elenco, PermessiSigad.Certificazioni.Lettura, PermessiSigad.Incarichi.Elenco, PermessiSigad.Incarichi.Lettura)
                .Produces<PagedResponse<CertificazioneSearchItem>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());
    }
}
