namespace Accredia.SIGAD.Web.Models.Tipologiche;

public sealed record TipologicaListItem(
    string Code,
    string Description,
    bool IsActive,
    int Ordine);
