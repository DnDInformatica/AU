namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.CreateInt;

internal sealed record CreateIncaricoRequest(
    int PersonaId,
    int OrganizzazioneId,
    int? TipoRuoloId,
    string StatoIncarico,
    DateTime DataInizio,
    DateTime? DataFine,
    int? UnitaOrganizzativaId);

