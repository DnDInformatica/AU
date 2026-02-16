using System.Security.Claims;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutAll;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/auth/logout/all", "LogoutAll", async (
                ClaimsPrincipal user,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                var userId = user.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                using var scope = AuthAudit.BeginScope(logger, "LogoutAll", userId: userId);

                if (string.IsNullOrWhiteSpace(userId))
                {
                    logger.LogInformation(AuthAudit.Events.LogoutAllFailedMissingUser, "AuthLogoutAllFailedMissingUser");
                    return Results.Unauthorized();
                }

                var command = new Command(userId);
                Validator.Validate(command);

                await Handler.Handle(command, connectionFactory, cancellationToken);

                logger.LogInformation(AuthAudit.Events.LogoutAllSucceeded, "AuthLogoutAllSucceeded for {UserId}", userId);
                return Results.NoContent();
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status401Unauthorized)
                .RequireAuthorization());
    }
}
