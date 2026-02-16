namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Lookups;

internal sealed record LookupTypeDto(
    string Name);

internal sealed record LookupItemDto(
    int Id,
    string? Code,
    string Description,
    bool? IsActive,
    int? Ordine);

internal sealed record PagedResponse<T>(
    IReadOnlyCollection<T> Items,
    int Page,
    int PageSize,
    int TotalCount);

