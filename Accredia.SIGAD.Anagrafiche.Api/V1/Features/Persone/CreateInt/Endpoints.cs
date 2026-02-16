using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.CreateInt;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/persone", "PersoneCreateInt", async (
                CreatePersonaRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                if (response is null)
                {
                    // Duplicate CF or creation failed.
                    return Results.Conflict("Persona gia presente (CF duplicato) o creazione non riuscita.");
                }

                var location = $"/{ApiVersioning.DefaultVersion}/persone/{response.PersonaId}";
                return Results.Created(location, response);
            },
            builder => builder
                .Produces<V1.Features.Persone.GetByIdInt.PersonaDetailDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());
    }
}

