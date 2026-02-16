using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIdentificativi;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiCreate;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPost(app, "/organizzazioni/{id:int}/identificativi", "OrganizzazioniCreateIdentificativo", async (
                int id,
                CreateIdentificativoRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var (result, item) = await Handler.Handle(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.Result.NotFound => Results.NotFound(),
                    Handler.Result.Duplicate => Results.Conflict("Identificativo gia presente."),
                    Handler.Result.Created when item is not null => Results.Created($"/{ApiVersioning.DefaultVersion}/organizzazioni/{id}/identificativi/{item.Id}", item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<IdentificativoDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());
    }
}

