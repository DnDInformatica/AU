using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaLookups;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.Lookups;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/incarichi/lookups", "IncarichiGetLookups", async (
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var response = await Handler.Handle(connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<LookupItem>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound));
    }
}

