namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.List;

internal sealed record TipologicaListItem(int Id, string Code, string Description, bool IsActive, int Ordine);

internal sealed record ListResponse(
    IReadOnlyList<TipologicaListItem> Items,
    int Page,
    int PageSize,
    int TotalCount);
