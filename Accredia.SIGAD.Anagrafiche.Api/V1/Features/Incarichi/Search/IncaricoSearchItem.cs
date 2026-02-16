namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.Search;

internal sealed record IncaricoSearchItem(
    int IncaricoId,
    int PersonaId,
    string PersonaCognome,
    string PersonaNome,
    int? OrganizzazioneId,
    string? OrganizzazioneDenominazione,
    string Ruolo,
    string StatoIncarico,
    DateTime DataInizio,
    DateTime? DataFine);
