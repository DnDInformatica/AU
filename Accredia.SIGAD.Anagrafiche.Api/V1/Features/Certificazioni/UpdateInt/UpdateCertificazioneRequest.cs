namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.UpdateInt;

internal sealed record UpdateCertificazioneRequest(
    string Denominazione,
    string? Sigla,
    string? Note,
    DateTime? DataFondazione);
