using Accredia.SIGAD.Tipologiche.Api;
using Accredia.SIGAD.Tipologiche.Api.Database;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.GetById;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/tipologiche/{id:int}", "GetTipologicaById",
            async (int id, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var query = new Query(id);
                var errors = Validator.Validate(query);
                if (errors.Count > 0)
                {
                    return Results.ValidationProblem(errors);
                }

                return await Handler.Handle(query, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces<DetailResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}
