using Accredia.SIGAD.Identity.Api.Database;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Database.EnsureSchema;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/db/ensure-schema", "EnsureSchema", async (
                ISqlConnectionFactory connectionFactory,
                IHostEnvironment environment,
                CancellationToken cancellationToken) =>
            {
                if (!environment.IsDevelopment())
                {
                    return Results.NotFound();
                }

                var command = new Command();
                Validator.Validate(command);
                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                return Results.Ok(response);
            },
            builder => builder
                .Produces<EnsureSchemaResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound));
    }
}
