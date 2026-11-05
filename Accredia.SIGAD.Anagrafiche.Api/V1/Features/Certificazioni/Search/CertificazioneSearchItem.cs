namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.Search;

internal sealed record CertificazioneSearchItem(
    int CertificazioneId,
    string Denominazione,
    string? Sigla,
    DateTime? DataFondazione,
    bool IsDeleted);
