using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Database.EnsureTables;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/db/ensure-tables", "EnsureTables", async (
                IDbConnectionFactory connectionFactory,
                IHostEnvironment environment,
                CancellationToken cancellationToken) =>
            {
                if (!environment.IsDevelopment())
                {
                    return Results.NotFound();
                }

                var command = new Command();
                Validator.Validate(command);
                await Handler.Handle(command, connectionFactory, cancellationToken);
                return Results.NoContent();
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound));
    }
}
