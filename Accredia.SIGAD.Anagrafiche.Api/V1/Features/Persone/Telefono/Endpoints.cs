using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Telefono;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/persone/telefono/lookups", "PersoneTelefonoLookups", async (
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new LookupsCommand();
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.LookupsAsync(command, connectionFactory, cancellationToken);
                return Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<TipoTelefonoLookupItem>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{personaId:int}/telefoni", "PersoneTelefoniList", async (
                int personaId,
                bool? includeDeleted,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new ListCommand(personaId, includeDeleted ?? false);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.ListAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaTelefonoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/persone/{personaId:int}/telefoni", "PersoneTelefoniCreate", async (
                int personaId,
                CreateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new CreateCommand(personaId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var (result, item) = await Handler.CreateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFoundPersona => Results.NotFound(),
                    Handler.WriteResult.InvalidTipoTelefono => Results.Conflict("TipoTelefonoId non valido."),
                    Handler.WriteResult.Duplicate => Results.Conflict("Telefono gia presente per la persona."),
                    Handler.WriteResult.Success when item is not null => Results.Created(
                        $"/{ApiVersioning.DefaultVersion}/persone/{personaId}/telefoni/{item.PersonaTelefonoId}",
                        item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<PersonaTelefonoDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/persone/{personaId:int}/telefoni/{personaTelefonoId:int}", "PersoneTelefoniUpdate", async (
                int personaId,
                int personaTelefonoId,
                UpdateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new UpdateCommand(personaId, personaTelefonoId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var (result, item) = await Handler.UpdateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFoundPersona => Results.NotFound(),
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.InvalidTipoTelefono => Results.Conflict("TipoTelefonoId non valido."),
                    Handler.WriteResult.Duplicate => Results.Conflict("Telefono gia presente per la persona."),
                    Handler.WriteResult.Success when item is not null => Results.Ok(item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<PersonaTelefonoDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/persone/{personaId:int}/telefoni/{personaTelefonoId:int}", "PersoneTelefoniDelete", async (
                int personaId,
                int personaTelefonoId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DeleteCommand(personaId, personaTelefonoId, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var result = await Handler.DeleteAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFoundPersona => Results.NotFound(),
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

