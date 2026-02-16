using Accredia.SIGAD.Tipologiche.Api;
using Accredia.SIGAD.Tipologiche.Api.Database;
using Microsoft.Extensions.Hosting;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Database.EnsureTables;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        var environment = app.ServiceProvider.GetRequiredService<IWebHostEnvironment>();
        if (!environment.IsDevelopment())
        {
            return;
        }

        ApiVersioning.MapVersionedPost(app, "/database/ensure-tables", "EnsureTipologicheTables",
            async (ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var command = new Command();
                Validator.Validate(command);
                return await Handler.Handle(command, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces<EnsureTablesResponse>(StatusCodes.Status200OK));
    }
}
