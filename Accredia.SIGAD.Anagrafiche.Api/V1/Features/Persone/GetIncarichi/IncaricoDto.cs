namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.GetIncarichi;

internal sealed record IncaricoDto(
    int IncaricoId,
    int OrganizzazioneId,
    string? OrganizzazioneDenominazione,
    string Ruolo,
    string StatoIncarico,
    DateTime DataInizio,
    DateTime? DataFine,
    int? UnitaOrganizzativaId,
    DateTime? DataCancellazione);

