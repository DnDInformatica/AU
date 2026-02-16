using System.Security.Claims;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Me.GetCurrentUser;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/me", "GetCurrentUser", async (
                ClaimsPrincipal user,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                // In ASP.NET Identity, NameIdentifier contiene l'Id (stringa)
                var userId = user.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                using var scope = AuthAudit.BeginScope(logger, "Me", userId: userId);

                if (string.IsNullOrEmpty(userId))
                {
                    logger.LogInformation(AuthAudit.Events.MeAccessFailedMissingUser, "MeAccessFailedMissingUser");
                    return Results.Unauthorized();
                }

                var command = new Command(userId);
                Validator.Validate(command);

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);

                if (response is null)
                {
                    logger.LogInformation(AuthAudit.Events.MeAccessNotFound, "MeAccessNotFound for {UserId}", userId);
                    return Results.NotFound();
                }

                logger.LogInformation(AuthAudit.Events.MeAccessSucceeded, "MeAccessSucceeded for {UserId}", userId);
                return Results.Ok(response);
            },
            builder => builder
                .Produces<MeResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status404NotFound)
                .RequireAuthorization());
    }
}
