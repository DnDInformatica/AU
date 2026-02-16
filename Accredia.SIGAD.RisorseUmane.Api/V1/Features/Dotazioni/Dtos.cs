namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Dotazioni;

internal sealed record DotazioneDto(
    int DotazioneId,
    int DipendenteId,
    int TipoDotazioneId,
    string Descrizione,
    string? NumeroInventario,
    string? NumeroSerie,
    DateOnly DataAssegnazione,
    DateOnly? DataRestituzione,
    bool IsRestituito,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

internal sealed record DotazioneCreateRequest(
    int TipoDotazioneId,
    string Descrizione,
    string? NumeroInventario,
    string? NumeroSerie,
    DateOnly DataAssegnazione,
    DateOnly? DataRestituzione,
    bool? IsRestituito,
    string? Note);

internal sealed record DotazioneUpdateRequest(
    int TipoDotazioneId,
    string Descrizione,
    string? NumeroInventario,
    string? NumeroSerie,
    DateOnly DataAssegnazione,
    DateOnly? DataRestituzione,
    bool? IsRestituito,
    string? Note);

internal sealed record DotazioneCreateResponse(int DotazioneId);

