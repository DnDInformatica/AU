namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaRelazioni;

internal sealed record UnitaRelazioneDto(
    int UnitaRelazioneId,
    int UnitaPadreId,
    int UnitaFigliaId,
    int TipoRelazioneId);

