namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record CreateIncaricoRequest(
    int PersonaId,
    int OrganizzazioneId,
    int? TipoRuoloId,
    string StatoIncarico,
    DateTime DataInizio,
    DateTime? DataFine,
    int? UnitaOrganizzativaId);

