namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaFunzioni;

internal sealed record UnitaFunzioneDto(
    int UnitaOrganizzativaFunzioneId,
    int UnitaOrganizzativaId,
    int TipoFunzioneUnitaLocaleId,
    string? TipoFunzioneDescrizione,
    bool Principale,
    string? Note);

