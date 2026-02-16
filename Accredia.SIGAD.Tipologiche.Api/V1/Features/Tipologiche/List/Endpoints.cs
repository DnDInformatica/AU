using Accredia.SIGAD.Tipologiche.Api;
using Accredia.SIGAD.Tipologiche.Api.Database;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.List;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/tipologiche", "ListTipologiche",
            async (string? q, int? page, int? pageSize, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var query = new Query(q, page ?? 1, pageSize ?? 50);
                var errors = Validator.Validate(query);
                if (errors.Count > 0)
                {
                    return Results.ValidationProblem(errors);
                }

                return await Handler.Handle(query, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces<ListResponse>(StatusCodes.Status200OK)
                .ProducesValidationProblem());
    }
}
