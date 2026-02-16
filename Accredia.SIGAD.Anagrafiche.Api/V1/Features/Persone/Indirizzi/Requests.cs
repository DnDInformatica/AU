namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Indirizzi;

internal sealed record CreateRequest(
    int IndirizzoId,
    int TipoIndirizzoId,
    bool Principale,
    bool Attivo);

internal sealed record UpdateRequest(
    int IndirizzoId,
    int TipoIndirizzoId,
    bool Principale,
    bool Attivo);

