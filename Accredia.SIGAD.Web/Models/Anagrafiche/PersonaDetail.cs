namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record PersonaDetail(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita,
    DateTime? DataCancellazione);

public sealed record PersonaIncaricoItem(
    int IncaricoId,
    int OrganizzazioneId,
    string? OrganizzazioneDenominazione,
    string Ruolo,
    string StatoIncarico,
    DateTime DataInizio,
    DateTime? DataFine,
    int? UnitaOrganizzativaId,
    DateTime? DataCancellazione);

