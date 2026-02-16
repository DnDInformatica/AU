namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Telefono;

internal sealed record CreateRequest(
    int TipoTelefonoId,
    string? PrefissoInternazionale,
    string Numero,
    string? Estensione,
    bool Principale,
    bool Verificato,
    DateTime? DataVerifica);

internal sealed record UpdateRequest(
    int TipoTelefonoId,
    string? PrefissoInternazionale,
    string Numero,
    string? Estensione,
    bool Principale,
    bool Verificato,
    DateTime? DataVerifica);

