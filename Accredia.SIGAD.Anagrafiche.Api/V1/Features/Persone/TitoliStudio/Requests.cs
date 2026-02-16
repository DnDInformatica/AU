namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.TitoliStudio;

internal sealed record CreateRequest(
    int TipoTitoloStudioId,
    string? Istituzione,
    string? Corso,
    DateTime? DataConseguimento,
    string? Voto,
    bool Lode,
    string? Paese,
    string? Note,
    bool Principale);

internal sealed record UpdateRequest(
    int TipoTitoloStudioId,
    string? Istituzione,
    string? Corso,
    DateTime? DataConseguimento,
    string? Voto,
    bool Lode,
    string? Paese,
    string? Note,
    bool Principale);

