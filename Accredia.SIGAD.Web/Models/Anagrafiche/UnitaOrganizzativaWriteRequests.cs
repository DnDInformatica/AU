namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record CreateUnitaOrganizzativaRequest(
    string Nome,
    string? Codice,
    bool Principale,
    int TipoUnitaOrganizzativaId,
    int? TipoSedeId);

public sealed record UpdateUnitaOrganizzativaRequest(
    string Nome,
    string? Codice,
    bool Principale,
    int TipoUnitaOrganizzativaId,
    int? TipoSedeId);

