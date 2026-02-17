namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Reports;

internal sealed record FormazioneInScadenzaDto(
    int FormazioneObbligatoriaId,
    int DipendenteId,
    int TipoFormazioneObbligatoriaId,
    DateOnly DataCompletamento,
    DateOnly DataScadenza,
    int GiorniAllaScadenza);

internal sealed record DotazioneNonRestituitaCessatoDto(
    int DipendenteId,
    DateOnly DataCessazione,
    int DotazioneId,
    int TipoDotazioneId,
    string Descrizione,
    DateOnly DataAssegnazione,
    DateOnly? DataRestituzione,
    bool IsRestituito);
