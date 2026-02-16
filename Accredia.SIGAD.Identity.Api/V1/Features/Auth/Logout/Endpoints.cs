using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Logout;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/auth/logout", "Logout", async (
                RefreshRequest request,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "Logout");
                var command = new Command(request.RefreshToken);

                try
                {
                    Validator.Validate(command);
                }
                catch (ArgumentException ex)
                {
                    logger.LogWarning(AuthAudit.Events.LogoutValidationFailed, "AuthLogoutValidationFailed");
                    return Results.BadRequest(new { error = ex.Message });
                }

                var revoked = await Handler.Handle(command, connectionFactory, cancellationToken);

                if (!revoked)
                {
                    logger.LogInformation(AuthAudit.Events.LogoutFailed, "AuthLogoutFailed");
                    return Results.Unauthorized();
                }

                logger.LogInformation(AuthAudit.Events.LogoutSucceeded, "AuthLogoutSucceeded");
                return Results.NoContent();
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .AllowAnonymous());
    }
}
