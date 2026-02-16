namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Telefono;

internal sealed record PersonaTelefonoDto(
    int PersonaTelefonoId,
    int PersonaId,
    int TipoTelefonoId,
    string? PrefissoInternazionale,
    string Numero,
    string? Estensione,
    bool Principale,
    bool Verificato,
    DateTime? DataVerifica,
    DateTime? DataCancellazione);

internal sealed record TipoTelefonoLookupItem(
    int Id,
    string Code,
    string Description);

