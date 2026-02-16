namespace Accredia.SIGAD.Web.Models.Search;

public sealed record GlobalSearchResponse(
    string Query,
    SearchGroup<SearchItem> Organizzazioni,
    SearchGroup<SearchItem> Persone,
    SearchGroup<SearchItem> Incarichi);

public sealed record SearchGroup<T>(IReadOnlyList<T> Items, int TotalCount);

public sealed record SearchItem(
    string Id,
    string Title,
    string? Subtitle,
    string? CodiceFiscale,
    string? PartitaIVA,
    string? Status);
