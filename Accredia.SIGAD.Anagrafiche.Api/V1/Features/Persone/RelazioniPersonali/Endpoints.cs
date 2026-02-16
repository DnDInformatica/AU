using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RelazioniPersonali;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/persone/relazioni-personali/lookups", "PersoneRelazioniPersonaliLookups", async (
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new LookupsCommand();
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.LookupsAsync(command, connectionFactory, cancellationToken);
                return Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<TipoRelazionePersonaleLookupItem>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{personaId:int}/relazioni-personali", "PersoneRelazioniPersonaliList", async (
                int personaId,
                bool? includeDeleted,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new ListCommand(personaId, includeDeleted ?? false);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.ListAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaRelazionePersonaleDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/persone/{personaId:int}/relazioni-personali", "PersoneRelazioniPersonaliCreate", async (
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
                    Handler.WriteResult.NotFoundPersonaCollegata => Results.Conflict("PersonaCollegataId non valido."),
                    Handler.WriteResult.InvalidTipoRelazionePersonale => Results.Conflict("TipoRelazionePersonaleId non valido."),
                    Handler.WriteResult.Duplicate => Results.Conflict("Relazione personale gia presente per la persona."),
                    Handler.WriteResult.Success when item is not null => Results.Created(
                        $"/{ApiVersioning.DefaultVersion}/persone/{personaId}/relazioni-personali/{item.PersonaRelazionePersonaleId}",
                        item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<PersonaRelazionePersonaleDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/persone/{personaId:int}/relazioni-personali/{personaRelazionePersonaleId:int}", "PersoneRelazioniPersonaliUpdate", async (
                int personaId,
                int personaRelazionePersonaleId,
                UpdateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new UpdateCommand(personaId, personaRelazionePersonaleId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var (result, item) = await Handler.UpdateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFoundPersona => Results.NotFound(),
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.NotFoundPersonaCollegata => Results.Conflict("PersonaCollegataId non valido."),
                    Handler.WriteResult.InvalidTipoRelazionePersonale => Results.Conflict("TipoRelazionePersonaleId non valido."),
                    Handler.WriteResult.Duplicate => Results.Conflict("Relazione personale gia presente per la persona."),
                    Handler.WriteResult.Success when item is not null => Results.Ok(item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<PersonaRelazionePersonaleDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/persone/{personaId:int}/relazioni-personali/{personaRelazionePersonaleId:int}", "PersoneRelazioniPersonaliDelete", async (
                int personaId,
                int personaRelazionePersonaleId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DeleteCommand(personaId, personaRelazionePersonaleId, actor);
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

