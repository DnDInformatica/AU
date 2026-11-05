namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.GetByIdInt;

internal sealed record CertificazioneDetailDto(
    int CertificazioneId,
    string Denominazione,
    string? Sigla,
    string? Note,
    DateTime? DataFondazione,
    DateTime? DataCancellazione);
