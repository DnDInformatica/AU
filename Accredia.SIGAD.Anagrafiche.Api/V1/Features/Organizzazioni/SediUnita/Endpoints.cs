using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediUnita;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{id:int}/sedi-unita", "OrganizzazioniListSediUnita", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new ListCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.ListAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<SedeUnitaDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/organizzazioni/{id:int}/sedi-unita", "OrganizzazioniCreateSedeUnita", async (
                int id,
                CreateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new CreateCommand(id, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var (result, item) = await Handler.CreateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.Duplicate => Results.Conflict("Collegamento sede-unita gia presente."),
                    Handler.WriteResult.Success when item is not null => Results.Created($"/{ApiVersioning.DefaultVersion}/organizzazioni/{id}/sedi-unita/{item.SedeUnitaOrganizzativaId}", item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<SedeUnitaDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/organizzazioni/{id:int}/sedi-unita/{sedeUnitaOrganizzativaId:int}", "OrganizzazioniUpdateSedeUnita", async (
                int id,
                int sedeUnitaOrganizzativaId,
                UpdateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new UpdateCommand(id, sedeUnitaOrganizzativaId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var (result, item) = await Handler.UpdateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.Duplicate => Results.Conflict("Collegamento sede-unita gia presente."),
                    Handler.WriteResult.Success when item is not null => Results.Ok(item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<SedeUnitaDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/organizzazioni/{id:int}/sedi-unita/{sedeUnitaOrganizzativaId:int}", "OrganizzazioniDeleteSedeUnita", async (
                int id,
                int sedeUnitaOrganizzativaId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DeleteCommand(id, sedeUnitaOrganizzativaId, actor);
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
