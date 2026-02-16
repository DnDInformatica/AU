namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record PersonaEmailItem(
    int PersonaEmailId,
    int PersonaId,
    int TipoEmailId,
    string Email,
    bool Principale,
    bool Verificata,
    DateTime? DataVerifica,
    DateTime? DataCancellazione);

public sealed record PersonaTelefonoItem(
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

public sealed record ContactLookupItem(
    int Id,
    string Code,
    string Description);

public sealed record CreatePersonaEmailRequest(
    int TipoEmailId,
    string Email,
    bool Principale,
    bool Verificata,
    DateTime? DataVerifica);

public sealed record UpdatePersonaEmailRequest(
    int TipoEmailId,
    string Email,
    bool Principale,
    bool Verificata,
    DateTime? DataVerifica);

public sealed record CreatePersonaTelefonoRequest(
    int TipoTelefonoId,
    string? PrefissoInternazionale,
    string Numero,
    string? Estensione,
    bool Principale,
    bool Verificato,
    DateTime? DataVerifica);

public sealed record UpdatePersonaTelefonoRequest(
    int TipoTelefonoId,
    string? PrefissoInternazionale,
    string Numero,
    string? Estensione,
    bool Principale,
    bool Verificato,
    DateTime? DataVerifica);
