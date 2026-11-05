using Accredia.SIGAD.Web.Models.Search;
using Microsoft.AspNetCore.Components;

namespace Accredia.SIGAD.Web.Components.Layout;

public partial class GlobalSearchGroup
{
    [Parameter] public string Title { get; set; } = string.Empty;
    [Parameter] public string RouteBase { get; set; } = string.Empty;
    [Parameter] public SearchGroup<SearchItem> Group { get; set; } = default!;
    [Parameter] public EventCallback<(string RouteBase, SearchItem Item)> OnNavigate { get; set; }

    private Task OnItemClick(SearchItem item)
        => OnNavigate.InvokeAsync((RouteBase, item));
}

