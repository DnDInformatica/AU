using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.Services.DocumentStorage;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Documenti;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/persone/{personaId:int}/documenti", "PersoneDocumentiList", async (
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

                var items = await Handler.ListAsync(command, connectionFactory, cancellationToken);
                return items is null ? Results.NotFound() : Results.Ok(items);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaDocumentoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/persone/{personaId:int}/documenti", "PersoneDocumentiUpload", async (
                int personaId,
                [FromForm] UploadRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                IPersonaDocumentStorage documentStorage,
                ILoggerFactory loggerFactory,
                CancellationToken cancellationToken) =>
            {
                var logger = loggerFactory.CreateLogger("PersoneDocumentiUpload");

                if (request.File is null)
                {
                    return Results.ValidationProblem(new Dictionary<string, string[]>
                    {
                        ["file"] = ["File obbligatorio."]
                    });
                }

                var command = new UploadCommand(personaId, request.File, request.Note, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                try
                {
                    var (result, item) = await Handler.UploadAsync(command, connectionFactory, documentStorage, cancellationToken);
                    return result switch
                    {
                        Handler.WriteResult.NotFoundPersona => Results.NotFound(),
                        Handler.WriteResult.Success when item is not null => Results.Created(
                            $"/{ApiVersioning.DefaultVersion}/persone/{personaId}/documenti/{item.DocumentoId}",
                            item),
                        _ => Results.Problem("Upload documento non riuscito.")
                    };
                }
                catch (DocumentStorageUnavailableException ex)
                {
                    logger.LogError(
                        ex,
                        "Storage documentale non disponibile durante upload. PersonaId={PersonaId} StatusCode={StorageStatusCode}",
                        personaId,
                        ex.StatusCode);
                    return Results.Problem(
                        title: "Storage documentale non disponibile",
                        detail: "Riprovare più tardi o verificare la configurazione WebDav.",
                        statusCode: StatusCodes.Status503ServiceUnavailable);
                }
            },
            builder => builder
                .DisableAntiforgery()
                .Accepts<UploadRequest>("multipart/form-data")
                .Produces<PersonaDocumentoDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status503ServiceUnavailable)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{personaId:int}/documenti/{documentoId:int}/download", "PersoneDocumentiDownload", async (
                int personaId,
                int documentoId,
                IDbConnectionFactory connectionFactory,
                IPersonaDocumentStorage documentStorage,
                ILoggerFactory loggerFactory,
                CancellationToken cancellationToken) =>
            {
                var logger = loggerFactory.CreateLogger("PersoneDocumentiDownload");

                var command = new DownloadCommand(personaId, documentoId);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                try
                {
                    var (result, item) = await Handler.DownloadAsync(command, connectionFactory, documentStorage, cancellationToken);
                    return result switch
                    {
                        Handler.WriteResult.NotFoundPersona => Results.NotFound(),
                        Handler.WriteResult.NotFoundDocumento => Results.NotFound(),
                        Handler.WriteResult.Success when item is not null => Results.File(
                            item.Content,
                            item.ContentType,
                            item.NomeFile),
                        _ => Results.Problem("Download documento non riuscito.")
                    };
                }
                catch (DocumentStorageUnavailableException ex)
                {
                    logger.LogError(
                        ex,
                        "Storage documentale non disponibile durante download. PersonaId={PersonaId} DocumentoId={DocumentoId} StatusCode={StorageStatusCode}",
                        personaId,
                        documentoId,
                        ex.StatusCode);
                    return Results.Problem(
                        title: "Storage documentale non disponibile",
                        detail: "Riprovare più tardi o verificare la configurazione WebDav.",
                        statusCode: StatusCodes.Status503ServiceUnavailable);
                }
            },
            builder => builder
                .Produces(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status503ServiceUnavailable)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/persone/{personaId:int}/documenti/{documentoId:int}", "PersoneDocumentiDelete", async (
                int personaId,
                int documentoId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DeleteCommand(personaId, documentoId, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var result = await Handler.DeleteAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.WriteResult.NotFoundPersona => Results.NotFound(),
                    Handler.WriteResult.NotFoundDocumento => Results.NotFound(),
                    _ => Results.NoContent()
                };
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}
