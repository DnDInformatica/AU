using Accredia.SIGAD.Anagrafiche.Api;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Dapper;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Health;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        // Health check lightweight
        ApiVersioning.MapVersionedGet(app, "/health", "Health", () =>
            {
                var command = new Command();
                Validator.Validate(command);
                return Handler.Handle(command);
            },
            builder => builder.Produces<HealthResponse>(StatusCodes.Status200OK));

        // Health check con verifica DB (SELECT 1)
        ApiVersioning.MapVersionedGet(app, "/health/db", "HealthDb", async (
            IDbConnectionFactory connectionFactory,
            CancellationToken cancellationToken) =>
            {
                try
                {
                    await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                    var result = await connection.QuerySingleAsync<int>(new CommandDefinition("SELECT 1", cancellationToken: cancellationToken));
                    return Results.Ok(new HealthDbResponse("ok", true));
                }
                catch (Exception ex)
                {
                    return Results.Ok(new HealthDbResponse("degraded", false, ex.Message));
                }
            },
            builder => builder.Produces<HealthDbResponse>(StatusCodes.Status200OK));
    }
}

internal sealed record HealthDbResponse(string Status, bool DatabaseConnected, string? Error = null);
