namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record LookupItem(int Id, string Label)
{
    public override string ToString() => Label;
}

public sealed record UnitaLookupsResponse(
    IReadOnlyList<LookupItem> TipiUnitaOrganizzativa,
    IReadOnlyList<LookupItem> TipiSede);
