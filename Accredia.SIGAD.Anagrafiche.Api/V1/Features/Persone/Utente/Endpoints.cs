using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Utente;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/persone/{personaId:int}/utente", "PersoneUtenteGet", async (
                int personaId,
                bool? includeDeleted,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new GetCommand(personaId, includeDeleted ?? false);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<PersonaUtenteDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/persone/{personaId:int}/utente", "PersoneUtenteCreate", async (
                int personaId,
                CreateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new CreateCommand(personaId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var (result, item) = await Handler.CreateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFoundPersona => Results.NotFound(),
                    Handler.WriteResult.DuplicatePersona => Results.Conflict("Utente gia associato alla persona."),
                    Handler.WriteResult.DuplicateUser => Results.Conflict("UserId gia associato ad un'altra persona."),
                    Handler.WriteResult.Success when item is not null => Results.Created(
                        $"/{ApiVersioning.DefaultVersion}/persone/{personaId}/utente/{item.PersonaUtenteId}",
                        item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<PersonaUtenteDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/persone/{personaId:int}/utente/{personaUtenteId:int}", "PersoneUtenteUpdate", async (
                int personaId,
                int personaUtenteId,
                UpdateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new UpdateCommand(personaId, personaUtenteId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var (result, item) = await Handler.UpdateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFoundPersona => Results.NotFound(),
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.DuplicateUser => Results.Conflict("UserId gia associato ad un'altra persona."),
                    Handler.WriteResult.Success when item is not null => Results.Ok(item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<PersonaUtenteDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/persone/{personaId:int}/utente/{personaUtenteId:int}", "PersoneUtenteDelete", async (
                int personaId,
                int personaUtenteId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DeleteCommand(personaId, personaUtenteId, actor);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

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

