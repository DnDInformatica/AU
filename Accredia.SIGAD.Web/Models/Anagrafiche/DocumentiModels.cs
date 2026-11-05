namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record DocumentoItem(
    int DocumentoId,
    int PersonaId,
    string NomeFile,
    string? ContentType,
    long DimensioneBytes,
    string? HashSha256,
    string? Note,
    DateTime CreatedAtUtc,
    DateTime? DeletedAtUtc);

public sealed record CreatePersonaDocumentoRequest(
    string FileName,
    string? ContentType,
    byte[] Content,
    string? Note);

public sealed record DownloadedFileResult(
    string FileName,
    string ContentType,
    byte[] Content);
