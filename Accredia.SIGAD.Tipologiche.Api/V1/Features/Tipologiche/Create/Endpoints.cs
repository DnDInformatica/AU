using Accredia.SIGAD.Tipologiche.Api;
using Accredia.SIGAD.Tipologiche.Api.Database;
using Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche;
using Microsoft.Extensions.Hosting;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.Create;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        var environment = app.ServiceProvider.GetRequiredService<IWebHostEnvironment>();
        if (!environment.IsDevelopment())
        {
            return;
        }

        ApiVersioning.MapVersionedPost(app, "/tipologiche", "CreateTipologica",
            async (CreateRequest request, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var command = new Command(
                    request.Code?.Trim() ?? string.Empty,
                    request.Description?.Trim() ?? string.Empty,
                    request.IsActive ?? true,
                    request.Ordine ?? 0);

                var errors = Validator.Validate(command);
                if (errors.Count > 0)
                {
                    return Results.ValidationProblem(errors);
                }

                return await Handler.Handle(command, connectionFactory, cancellationToken);
            },
            builder => builder
                .Produces<CreateResponse>(StatusCodes.Status201Created)
                .Produces<ErrorResponse>(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());
    }
}
