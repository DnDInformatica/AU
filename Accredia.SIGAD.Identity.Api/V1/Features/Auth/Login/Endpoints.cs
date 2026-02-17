using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Login;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/auth/login", "Login", async (
                LoginRequest request,
                ISqlConnectionFactory connectionFactory,
                IOptions<JwtOptions> jwtOptions,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "Login", userName: request.Username);
                var command = new Command(request.Username, request.Password);

                try
                {
                    Validator.Validate(command);
                }
                catch (ArgumentException ex)
                {
                    logger.LogWarning(AuthAudit.Events.LoginValidationFailed, "AuthLoginValidationFailed for {UserName}", request.Username);
                    return Results.BadRequest(new { error = ex.Message });
                }
                try
                {
                    var response = await Handler.Handle(command, connectionFactory, jwtOptions, cancellationToken);

                    if (response is null)
                    {
                        logger.LogInformation(AuthAudit.Events.LoginFailed, "AuthLoginFailed for {UserName}", request.Username);
                        return Results.Unauthorized();
                    }

                    logger.LogInformation(AuthAudit.Events.LoginSucceeded, "AuthLoginSucceeded for {UserName}", request.Username);
                    return Results.Ok(response);
                }
                catch (SqlException ex) when (ex.Number == -2)
                {
                    logger.LogError(ex, "AuthLoginSqlTimeout for {UserName}", request.Username);
                    return Results.Problem(
                        title: "Servizio autenticazione temporaneamente non disponibile.",
                        detail: "Timeout durante la verifica credenziali. Riprova tra pochi secondi.",
                        statusCode: StatusCodes.Status503ServiceUnavailable);
                }
                catch (SqlException ex)
                {
                    logger.LogError(ex, "AuthLoginSqlError for {UserName}", request.Username);
                    return Results.Problem(
                        title: "Errore database in autenticazione.",
                        statusCode: StatusCodes.Status500InternalServerError);
                }
            },
            builder => builder
                .Produces<TokenResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status500InternalServerError)
                .Produces(StatusCodes.Status503ServiceUnavailable)
                .Produces(StatusCodes.Status429TooManyRequests)
                .RequireRateLimiting("AuthLogin")
                .AllowAnonymous());
    }
}
