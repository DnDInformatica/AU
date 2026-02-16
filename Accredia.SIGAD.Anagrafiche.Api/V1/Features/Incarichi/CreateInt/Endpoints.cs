using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.GetByIdInt;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.CreateInt;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/incarichi", "IncarichiCreateInt", async (
                CreateIncaricoRequest request,
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
                    return Results.Conflict("Creazione incarico non riuscita (verifica dati).");
                }

                var location = $"/{ApiVersioning.DefaultVersion}/incarichi/{response.IncaricoId}";
                return Results.Created(location, response);
            },
            builder => builder
                .Produces<IncaricoDetailDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());
    }
}

