namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Utente;

internal sealed record PersonaUtenteDto(
    int PersonaUtenteId,
    int PersonaId,
    string UserId,
    DateTime? DataCancellazione);

