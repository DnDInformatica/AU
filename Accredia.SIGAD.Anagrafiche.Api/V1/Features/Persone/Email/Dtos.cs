namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Email;

internal sealed record PersonaEmailDto(
    int PersonaEmailId,
    int PersonaId,
    int TipoEmailId,
    string Email,
    bool Principale,
    bool Verificata,
    DateTime? DataVerifica,
    DateTime? DataCancellazione);

internal sealed record TipoEmailLookupItem(
    int Id,
    string Code,
    string Description);

