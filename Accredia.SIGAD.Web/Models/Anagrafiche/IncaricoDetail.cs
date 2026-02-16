namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record IncaricoDetail(
    int IncaricoId,
    int PersonaId,
    string? PersonaCognome,
    string? PersonaNome,
    string? PersonaCodiceFiscale,
    int OrganizzazioneId,
    string? OrganizzazioneDenominazione,
    int? TipoRuoloId,
    string Ruolo,
    string StatoIncarico,
    DateTime DataInizio,
    DateTime? DataFine,
    int? UnitaOrganizzativaId,
    DateTime? DataCancellazione);

