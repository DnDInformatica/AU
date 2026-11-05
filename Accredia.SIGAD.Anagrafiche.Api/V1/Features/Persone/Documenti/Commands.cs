using Microsoft.AspNetCore.Http;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Documenti;

internal sealed record ListCommand(int PersonaId, bool IncludeDeleted);

internal sealed record UploadCommand(int PersonaId, IFormFile File, string? Note, string? Actor);

internal sealed record DownloadCommand(int PersonaId, int DocumentoId);

internal sealed record DeleteCommand(int PersonaId, int DocumentoId, string? Actor);
