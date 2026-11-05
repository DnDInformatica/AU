namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record CertificazioneListItem(
    int CertificazioneId,
    string Denominazione,
    string? Sigla,
    DateTime? DataFondazione,
    bool IsDeleted);

public sealed record CertificazioneDetail(
    int CertificazioneId,
    string Denominazione,
    string? Sigla,
    string? Note,
    DateTime? DataFondazione,
    DateTime? DataCancellazione);

public sealed record CreateCertificazioneRequest(
    string Denominazione,
    string? Sigla,
    string? Note,
    DateTime? DataFondazione);

public sealed record UpdateCertificazioneRequest(
    string Denominazione,
    string? Sigla,
    string? Note,
    DateTime? DataFondazione);
