namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RegistroTrattamenti;

internal sealed record TipoFinalitaLookupItem(
    int Id,
    string Code,
    string Description,
    string Category);

internal sealed record RegistroTrattamentiDto(
    int RegistroTrattamentiId,
    string Codice,
    string NomeTrattamento,
    string? Descrizione,
    int TipoFinalitaTrattamentoId,
    string BaseGiuridica,
    string CategorieDati,
    string CategorieInteressati,
    bool DatiParticolari,
    bool DatiGiudiziari,
    string? CategorieDestinatari,
    bool TrasferimentoExtraUE,
    string? PaesiExtraUE,
    string? GaranzieExtraUE,
    string TermineConservazione,
    int? TermineConservazioneGiorni,
    string? MisureSicurezza,
    int? ResponsabileTrattamentoId,
    int? ContitolareId,
    bool DPONotificato,
    string Stato,
    DateTime DataInizioTrattamento,
    DateTime? DataFineTrattamento,
    DateTime? DataCancellazione);

