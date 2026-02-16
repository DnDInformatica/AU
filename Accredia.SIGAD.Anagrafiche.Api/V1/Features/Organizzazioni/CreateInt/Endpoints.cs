using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.CreateInt;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/organizzazioni", "OrganizzazioniCreateInt", async (
                CreateOrganizzazioneIntRequest request,
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
                    return Results.Problem("Creazione non riuscita.");
                }

                var location = $"/{ApiVersioning.DefaultVersion}/organizzazioni/{response.OrganizzazioneId}";
                return Results.Created(location, response);
            },
            builder => builder
                .Produces<V1.Features.Organizzazioni.GetByIdInt.OrganizzazioneDetailDto>(StatusCodes.Status201Created)
                .ProducesValidationProblem());
    }
}

