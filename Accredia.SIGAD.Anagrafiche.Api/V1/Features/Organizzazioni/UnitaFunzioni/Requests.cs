namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaFunzioni;

internal sealed record CreateRequest(
    int UnitaOrganizzativaId,
    int TipoFunzioneUnitaLocaleId,
    bool Principale,
    string? Note);

internal sealed record UpdateRequest(
    int UnitaOrganizzativaId,
    int TipoFunzioneUnitaLocaleId,
    bool Principale,
    string? Note);

