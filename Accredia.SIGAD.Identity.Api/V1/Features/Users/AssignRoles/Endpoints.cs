using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Users.AssignRoles;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/users/{userId}/roles", "AssignUserRoles", async (
                string userId,
                AssignRolesRequest request,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "AssignUserRoles", userId: userId, userCount: request.Roles.Count);
                var command = new Command(userId, request.Roles);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    logger.LogWarning(AuthAudit.Events.AssignRolesValidationFailed, "AssignUserRolesValidationFailed");
                    return Results.ValidationProblem(errors);
                }

                try
                {
                    var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                    if (response is null)
                    {
                        return Results.NotFound();
                    }

                    logger.LogInformation(AuthAudit.Events.AssignRolesSucceeded, "AssignUserRolesSucceeded");
                    return Results.Ok(response);
                }
                catch (ArgumentException ex)
                {
                    return Results.BadRequest(new { error = ex.Message });
                }
            },
            builder => builder
                .Produces<AssignRolesResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status400BadRequest)
                .RequireAuthorization("Admin"));
    }
}
