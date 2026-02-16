using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetSedi;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediCreate;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/organizzazioni/{orgId:int}/sedi", "OrganizzazioniCreateSede", async (
                int orgId,
                CreateSedeRequest request,
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

                var location = $"/{ApiVersioning.DefaultVersion}/organizzazioni/{orgId}/sedi/{response.SedeId}";
                return Results.Created(location, response);
            },
            builder => builder
                .Produces<SedeDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}

