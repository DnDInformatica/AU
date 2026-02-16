using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.DataBreach;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/persone/data-breach", "PersoneDataBreachList", async (
                bool? includeDeleted,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new ListCommand(includeDeleted ?? false);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.ListAsync(command, connectionFactory, cancellationToken);
                return Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<DataBreachDto>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/data-breach/{dataBreachId:int}", "PersoneDataBreachGetById", async (
                int dataBreachId,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new GetByIdCommand(dataBreachId);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetByIdAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<DataBreachDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/persone/data-breach", "PersoneDataBreachCreate", async (
                CreateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new CreateCommand(request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var (result, item) = await Handler.CreateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.InvalidResponsabileGestione => Results.Conflict("ResponsabileGestioneId non valido."),
                    Handler.WriteResult.DuplicateCodice => Results.Conflict("Codice gia presente."),
                    Handler.WriteResult.Success when item is not null => Results.Created(
                        $"/{ApiVersioning.DefaultVersion}/persone/data-breach/{item.DataBreachId}",
                        item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<DataBreachDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/persone/data-breach/{dataBreachId:int}", "PersoneDataBreachUpdate", async (
                int dataBreachId,
                UpdateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new UpdateCommand(dataBreachId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var (result, item) = await Handler.UpdateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.InvalidResponsabileGestione => Results.Conflict("ResponsabileGestioneId non valido."),
                    Handler.WriteResult.DuplicateCodice => Results.Conflict("Codice gia presente."),
                    Handler.WriteResult.Success when item is not null => Results.Ok(item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<DataBreachDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/persone/data-breach/{dataBreachId:int}", "PersoneDataBreachDelete", async (
                int dataBreachId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DeleteCommand(dataBreachId, actor);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var result = await Handler.DeleteAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    _ => Results.NoContent()
                };
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}

