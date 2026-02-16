namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaUpdate;

internal sealed record UpdateUnitaOrganizzativaRequest(
    string Nome,
    string? Codice,
    bool Principale,
    int TipoUnitaOrganizzativaId,
    int? TipoSedeId);

