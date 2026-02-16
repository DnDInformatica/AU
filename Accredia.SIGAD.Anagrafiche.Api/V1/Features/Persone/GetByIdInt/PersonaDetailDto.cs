namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.GetByIdInt;

// Keep aligned with Accredia.SIGAD.Web.Models.Anagrafiche.PersonaDetail.
internal sealed record PersonaDetailDto(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita,
    DateTime? DataCancellazione);

