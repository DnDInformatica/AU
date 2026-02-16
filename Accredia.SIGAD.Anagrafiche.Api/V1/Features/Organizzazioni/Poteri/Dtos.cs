namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Poteri;

internal sealed record PotereDto(
    int PotereId,
    int IncaricoId,
    int TipoPotereId,
    DateTime DataInizio,
    DateTime? DataFine,
    decimal? LimiteImportoSingolo,
    decimal? LimiteImportoGiornaliero,
    decimal? LimiteImportoMensile,
    decimal? LimiteImportoAnnuo,
    string? Valuta,
    string? ModalitaFirma,
    string? AmbitoTerritoriale,
    string? AmbitoMateriale,
    bool PuoDelegare,
    int? DelegatoDa,
    string StatoPotere,
    DateTime? DataRevoca,
    string? MotivoRevoca,
    string? Note);
