using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIvaMembri;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/organizzazioni/gruppi-iva/{gruppoIvaId:int}/membri", "OrganizzazioniListGruppoIvaMembri", async (
                int gruppoIvaId,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new ListCommand(gruppoIvaId);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.ListAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<GruppoIvaMembroDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/organizzazioni/gruppi-iva/{gruppoIvaId:int}/membri", "OrganizzazioniCreateGruppoIvaMembro", async (
                int gruppoIvaId,
                CreateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new CreateCommand(gruppoIvaId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var (result, item) = await Handler.CreateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.InvalidOrganizzazione => Results.Conflict("Organizzazione non valida."),
                    Handler.WriteResult.Duplicate => Results.Conflict("Membro gia presente nel gruppo."),
                    Handler.WriteResult.Success when item is not null => Results.Created($"/{ApiVersioning.DefaultVersion}/organizzazioni/gruppi-iva/{gruppoIvaId}/membri/{item.GruppoIvaMembroId}", item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<GruppoIvaMembroDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/organizzazioni/gruppi-iva/{gruppoIvaId:int}/membri/{gruppoIvaMembroId:int}", "OrganizzazioniUpdateGruppoIvaMembro", async (
                int gruppoIvaId,
                int gruppoIvaMembroId,
                UpdateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new UpdateCommand(gruppoIvaId, gruppoIvaMembroId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var (result, item) = await Handler.UpdateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.InvalidOrganizzazione => Results.Conflict("Organizzazione non valida."),
                    Handler.WriteResult.Duplicate => Results.Conflict("Membro gia presente nel gruppo."),
                    Handler.WriteResult.Success when item is not null => Results.Ok(item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<GruppoIvaMembroDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/organizzazioni/gruppi-iva/{gruppoIvaId:int}/membri/{gruppoIvaMembroId:int}", "OrganizzazioniDeleteGruppoIvaMembro", async (
                int gruppoIvaId,
                int gruppoIvaMembroId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DeleteCommand(gruppoIvaId, gruppoIvaMembroId, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var result = await Handler.DeleteAsync(command, connectionFactory, cancellationToken);
                return result == Handler.WriteResult.NotFound ? Results.NotFound() : Results.NoContent();
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}
