using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaRelazioni;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{id:int}/unita-relazioni", "OrganizzazioniListUnitaRelazioni", async (
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
                .Produces<IReadOnlyList<UnitaRelazioneDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/organizzazioni/{id:int}/unita-relazioni", "OrganizzazioniCreateUnitaRelazione", async (
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
                    Handler.WriteResult.Duplicate => Results.Conflict("Relazione gia presente."),
                    Handler.WriteResult.Success when item is not null => Results.Created($"/{ApiVersioning.DefaultVersion}/organizzazioni/{id}/unita-relazioni/{item.UnitaRelazioneId}", item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<UnitaRelazioneDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/organizzazioni/{id:int}/unita-relazioni/{unitaRelazioneId:int}", "OrganizzazioniUpdateUnitaRelazione", async (
                int id,
                int unitaRelazioneId,
                UpdateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new UpdateCommand(id, unitaRelazioneId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var (result, item) = await Handler.UpdateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.Duplicate => Results.Conflict("Relazione gia presente."),
                    Handler.WriteResult.Success when item is not null => Results.Ok(item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<UnitaRelazioneDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/organizzazioni/{id:int}/unita-relazioni/{unitaRelazioneId:int}", "OrganizzazioniDeleteUnitaRelazione", async (
                int id,
                int unitaRelazioneId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DeleteCommand(id, unitaRelazioneId, actor);
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

