namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record UpdateIncaricoRequest(
    int PersonaId,
    int OrganizzazioneId,
    int? TipoRuoloId,
    string StatoIncarico,
    DateTime DataInizio,
    DateTime? DataFine,
    int? UnitaOrganizzativaId);

