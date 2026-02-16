namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Indirizzi;

internal sealed record PersonaIndirizzoDto(
    int PersonaIndirizzoId,
    int PersonaId,
    int IndirizzoId,
    int TipoIndirizzoId,
    bool Principale,
    bool Attivo,
    DateTime? DataCancellazione);

internal sealed record TipoIndirizzoLookupItem(
    int Id,
    string Code,
    string Description);

