namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Documenti;

internal sealed record PersonaDocumentoDto(
    int DocumentoId,
    int PersonaId,
    string NomeFile,
    string? ContentType,
    long DimensioneBytes,
    string? HashSha256,
    string? Note,
    DateTime CreatedAtUtc,
    DateTime? DeletedAtUtc);

internal sealed record DocumentoDownloadDto(
    string NomeFile,
    string ContentType,
    byte[] Content);
