namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Email;

internal sealed record CreateRequest(
    int TipoEmailId,
    string Email,
    bool Principale,
    bool Verificata,
    DateTime? DataVerifica);

internal sealed record UpdateRequest(
    int TipoEmailId,
    string Email,
    bool Principale,
    bool Verificata,
    DateTime? DataVerifica);

