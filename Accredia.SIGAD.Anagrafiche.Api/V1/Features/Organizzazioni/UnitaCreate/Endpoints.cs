using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetUnita;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaCreate;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/organizzazioni/{orgId:int}/unita-organizzative", "OrganizzazioniCreateUnita", async (
                int orgId,
                CreateUnitaOrganizzativaRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(orgId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                if (response is null)
                {
                    return Results.NotFound();
                }

                var location = $"/{ApiVersioning.DefaultVersion}/organizzazioni/{orgId}/unita-organizzative/{response.UnitaOrganizzativaId}";
                return Results.Created(location, response);
            },
            builder => builder
                .Produces<UnitaOrganizzativaDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}

