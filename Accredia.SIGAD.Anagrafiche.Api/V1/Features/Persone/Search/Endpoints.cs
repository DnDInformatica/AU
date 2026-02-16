using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Search;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/persone/search", "PersoneSearch", async (
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
            builder => builder
                .Produces<PagedResponse<PersonaSearchItem>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());
    }
}
