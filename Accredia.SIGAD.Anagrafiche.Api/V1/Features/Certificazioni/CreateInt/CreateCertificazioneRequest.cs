namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.CreateInt;

internal sealed record CreateCertificazioneRequest(
    string Denominazione,
    string? Sigla,
    string? Note,
    DateTime? DataFondazione);
