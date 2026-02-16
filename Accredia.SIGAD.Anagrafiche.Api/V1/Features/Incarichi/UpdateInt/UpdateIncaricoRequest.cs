namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.UpdateInt;

internal sealed record UpdateIncaricoRequest(
    int PersonaId,
    int OrganizzazioneId,
    int? TipoRuoloId,
    string StatoIncarico,
    DateTime DataInizio,
    DateTime? DataFine,
    int? UnitaOrganizzativaId);

