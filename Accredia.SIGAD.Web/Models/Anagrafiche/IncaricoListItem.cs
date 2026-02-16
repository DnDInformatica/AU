namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record IncaricoListItem(
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

