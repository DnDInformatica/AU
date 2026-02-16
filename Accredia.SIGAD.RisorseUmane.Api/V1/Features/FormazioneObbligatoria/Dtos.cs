namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.FormazioneObbligatoria;

internal sealed record FormazioneObbligatoriaDto(
    int FormazioneObbligatoriaId,
    int DipendenteId,
    int TipoFormazioneObbligatoriaId,
    DateOnly DataCompletamento,
    DateOnly? DataScadenza,
    string? EstremiAttestato,
    string? EnteFormatore,
    int? DurataOreCorso,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

internal sealed record FormazioneObbligatoriaCreateRequest(
    int TipoFormazioneObbligatoriaId,
    DateOnly DataCompletamento,
    DateOnly? DataScadenza,
    string? EstremiAttestato,
    string? EnteFormatore,
    int? DurataOreCorso,
    string? Note);

internal sealed record FormazioneObbligatoriaUpdateRequest(
    int TipoFormazioneObbligatoriaId,
    DateOnly DataCompletamento,
    DateOnly? DataScadenza,
    string? EstremiAttestato,
    string? EnteFormatore,
    int? DurataOreCorso,
    string? Note);

internal sealed record FormazioneObbligatoriaCreateResponse(int FormazioneObbligatoriaId);

