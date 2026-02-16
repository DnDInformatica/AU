using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutUser;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/auth/logout/user/{userId}", "LogoutUser", async (
                string userId,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "LogoutUser", userId: userId);
                var command = new Command(userId);

                try
                {
                    Validator.Validate(command);
                }
                catch (ArgumentException ex)
                {
                    logger.LogWarning(AuthAudit.Events.LogoutUserValidationFailed, "AuthLogoutUserValidationFailed for {UserId}", userId);
                    return Results.BadRequest(new { error = ex.Message });
                }

                await Handler.Handle(command, connectionFactory, cancellationToken);

                logger.LogInformation(AuthAudit.Events.LogoutUserSucceeded, "AuthLogoutUserSucceeded for {UserId}", userId);
                return Results.NoContent();
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status403Forbidden)
                .RequireAuthorization("Admin"));
    }
}
