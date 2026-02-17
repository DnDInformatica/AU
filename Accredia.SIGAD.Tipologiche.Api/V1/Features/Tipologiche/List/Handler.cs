using Accredia.SIGAD.Tipologiche.Api.V1.Features.Lookups;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.List;

internal static class Handler
{
    public static async Task<IResult> Handle(
        Query query,
        ILookupMetadataProvider metadataProvider,
        CancellationToken cancellationToken)
    {
        var filter = query.Q?.Trim();
        var all = await metadataProvider.ListTypesAsync(cancellationToken);
        var filtered = string.IsNullOrWhiteSpace(filter)
            ? all
            : all.Where(x => x.Name.Contains(filter, StringComparison.OrdinalIgnoreCase)).ToArray();

        var totalCount = filtered.Count;
        var offset = (query.Page - 1) * query.PageSize;
        var items = filtered
            .Skip(offset)
            .Take(query.PageSize)
            .Select((x, index) => new TipologicaListItem(offset + index + 1, x.Name, x.Name, true, offset + index + 1))
            .ToList();

        var response = new ListResponse(items, query.Page, query.PageSize, totalCount);
        return Results.Ok(response);
    }
}
