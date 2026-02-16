namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIncarichi;

// Keep aligned with Accredia.SIGAD.Web.Models.Anagrafiche.IncaricoItem (int-based model).
internal sealed record IncaricoDto(
    int IncaricoId,
    int PersonaId,
    string? PersonaCognome,
    string? PersonaNome,
    string? PersonaCodiceFiscale,
    string Ruolo,
    DateTime DataInizio,
    DateTime? DataFine,
    string StatoIncarico,
    int? UnitaOrganizzativaId,
    DateTime? DataCancellazione);
