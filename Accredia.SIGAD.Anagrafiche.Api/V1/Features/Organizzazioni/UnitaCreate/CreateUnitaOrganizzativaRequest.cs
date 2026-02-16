namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaCreate;

internal sealed record CreateUnitaOrganizzativaRequest(
    string Nome,
    string? Codice,
    bool Principale,
    int TipoUnitaOrganizzativaId,
    int? TipoSedeId);

