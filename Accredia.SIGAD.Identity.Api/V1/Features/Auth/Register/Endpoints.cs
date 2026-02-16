using Accredia.SIGAD.Identity.Api.Database;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Register;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/auth/register", "Register", async (
                RegisterRequest request,
                ISqlConnectionFactory connectionFactory,
                IHostEnvironment environment,
                CancellationToken cancellationToken) =>
            {
                // DEV-only endpoint
                if (!environment.IsDevelopment())
                {
                    return Results.NotFound();
                }

                var command = new Command(request.UserName, request.Email, request.Password);

                try
                {
                    Validator.Validate(command);
                }
                catch (ArgumentException ex)
                {
                    return Results.BadRequest(new { error = ex.Message });
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);

                if (response is null)
                {
                    return Results.Conflict(new { error = "User already exists with this username or email." });
                }

                return Results.Created($"/v1/users/{response.UserId}", response);
            },
            builder => builder
                .Produces<RegisterResponse>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict));
    }
}
