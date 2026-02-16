namespace Accredia.SIGAD.Web.Models.Common;

public sealed record PagedResponse<T>(IReadOnlyCollection<T> Items, int Page, int PageSize, int TotalCount);
