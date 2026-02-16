using Accredia.SIGAD.Tipologiche.Api;
using Accredia.SIGAD.Tipologiche.Api.Database;
using Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche;
using Microsoft.Extensions.Hosting;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.Update;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        var environment = app.ServiceProvider.GetRequiredService<IWebHostEnvironment>();
        if (!environment.IsDevelopment())
        {
            return;
        }

        ApiVersioning.MapVersionedPut(app, "/tipologiche/{id:int}", "UpdateTipologica",
            async (int id, UpdateRequest request, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var command = new Command(
                    id,
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
                .Produces<UpdateResponse>(StatusCodes.Status200OK)
                .Produces<ErrorResponse>(StatusCodes.Status409Conflict)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}
