using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;
using Microsoft.Extensions.Options;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.RefreshToken;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/auth/refresh", "RefreshToken", async (
                RefreshRequest request,
                ISqlConnectionFactory connectionFactory,
                IOptions<JwtOptions> jwtOptions,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "Refresh");
                var command = new Command(request.RefreshToken);

                try
                {
                    Validator.Validate(command);
                }
                catch (ArgumentException ex)
                {
                    logger.LogWarning(AuthAudit.Events.RefreshValidationFailed, "AuthRefreshValidationFailed");
                    return Results.BadRequest(new { error = ex.Message });
                }

                var response = await Handler.Handle(command, connectionFactory, jwtOptions, cancellationToken);

                if (response is null)
                {
                    logger.LogInformation(AuthAudit.Events.RefreshFailed, "AuthRefreshFailed");
                    return Results.Unauthorized();
                }

                logger.LogInformation(AuthAudit.Events.RefreshSucceeded, "AuthRefreshSucceeded");
                return Results.Ok(response);
            },
            builder => builder
                .Produces<TokenResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status429TooManyRequests)
                .RequireRateLimiting("AuthRefresh")
                .AllowAnonymous());
    }
}
