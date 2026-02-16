namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetUnita;

// Keep aligned with Accredia.SIGAD.Web.Models.Anagrafiche.UnitaOrganizzativaItem (int-based model).
internal sealed record UnitaOrganizzativaDto(
    int UnitaOrganizzativaId,
    string Nome,
    string? Codice,
    bool Principale,
    int TipoUnitaOrganizzativaId,
    int? TipoSedeId);

