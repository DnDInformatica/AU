namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaRelazioni;

internal sealed record CreateRequest(
    int UnitaPadreId,
    int UnitaFigliaId,
    int TipoRelazioneId);

internal sealed record UpdateRequest(
    int UnitaPadreId,
    int UnitaFigliaId,
    int TipoRelazioneId);

