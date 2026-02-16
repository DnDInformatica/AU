using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RichiesteGdpr;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/persone/richieste-gdpr/lookups", "PersoneRichiesteGdprLookups", async (
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
                .Produces<IReadOnlyList<TipoDirittoInteressatoLookupItem>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/richieste-gdpr", "PersoneRichiesteGdprList", async (
                int? personaId,
                bool? includeDeleted,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new ListCommand(personaId, includeDeleted ?? false);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.ListAsync(command, connectionFactory, cancellationToken);
                return Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<RichiestaGdprDto>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/richieste-gdpr/{richiestaGdprId:int}", "PersoneRichiesteGdprGetById", async (
                int richiestaGdprId,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new GetByIdCommand(richiestaGdprId);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetByIdAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<RichiestaGdprDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/persone/richieste-gdpr", "PersoneRichiesteGdprCreate", async (
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
                    Handler.WriteResult.InvalidTipoDirittoInteressato => Results.Conflict("TipoDirittoInteressatoId non valido."),
                    Handler.WriteResult.InvalidPersona => Results.Conflict("PersonaId non valido."),
                    Handler.WriteResult.InvalidResponsabileGestione => Results.Conflict("ResponsabileGestioneId non valido."),
                    Handler.WriteResult.DuplicateCodice => Results.Conflict("Codice gia presente."),
                    Handler.WriteResult.Success when item is not null => Results.Created(
                        $"/{ApiVersioning.DefaultVersion}/persone/richieste-gdpr/{item.RichiestaGdprId}",
                        item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<RichiestaGdprDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPut(app, "/persone/richieste-gdpr/{richiestaGdprId:int}", "PersoneRichiesteGdprUpdate", async (
                int richiestaGdprId,
                UpdateRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new UpdateCommand(richiestaGdprId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var (result, item) = await Handler.UpdateAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFound => Results.NotFound(),
                    Handler.WriteResult.InvalidTipoDirittoInteressato => Results.Conflict("TipoDirittoInteressatoId non valido."),
                    Handler.WriteResult.InvalidPersona => Results.Conflict("PersonaId non valido."),
                    Handler.WriteResult.InvalidResponsabileGestione => Results.Conflict("ResponsabileGestioneId non valido."),
                    Handler.WriteResult.DuplicateCodice => Results.Conflict("Codice gia presente."),
                    Handler.WriteResult.Success when item is not null => Results.Ok(item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<RichiestaGdprDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/persone/richieste-gdpr/{richiestaGdprId:int}", "PersoneRichiesteGdprDelete", async (
                int richiestaGdprId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DeleteCommand(richiestaGdprId, actor);
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

