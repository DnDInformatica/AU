namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.Search;

internal sealed record PagedResponse<T>(
    IReadOnlyCollection<T> Items,
    int Page,
    int PageSize,
    int TotalCount);
