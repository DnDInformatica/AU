using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;
using MudBlazor;
using Accredia.SIGAD.Web.Auth;
using Accredia.SIGAD.Web.Models.Admin;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Auth;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Models.RisorseUmane;
using Accredia.SIGAD.Web.Models.Search;
using Accredia.SIGAD.Web.Models.Tipologiche;
using Accredia.SIGAD.Web.Services;
using BreadcrumbItem = Accredia.SIGAD.Web.Models.Common.BreadcrumbItem;

namespace Accredia.SIGAD.Web.Components.Pages.Incarichi;

public partial class IncarichiResults : ComponentBase
{
[Parameter] public IEnumerable<IncaricoListItem> Items { get; set; } = Array.Empty<IncaricoListItem>();

    [Parameter]
    public Func<TableState, CancellationToken, Task<TableData<IncaricoListItem>>> ServerData { get; set; }
        = default!;

    [Parameter] public string ResultsHint { get; set; } = string.Empty;
    [Parameter] public bool IsLoading { get; set; }
    [Parameter] public string? Query { get; set; }
    [Parameter] public string EmptyMessage { get; set; } = string.Empty;
    [Parameter] public bool CanCreate { get; set; } = true;
    [Parameter] public bool CanDelete { get; set; } = true;
    [Parameter] public bool CanExport { get; set; } = true;

    [Parameter] public EventCallback<TableRowClickEventArgs<IncaricoListItem>> OnRowClick { get; set; }
    [Parameter] public EventCallback<IncaricoListItem> OnQuickPreview { get; set; }
    [Parameter] public EventCallback OnCreateNew { get; set; }
    [Parameter] public EventCallback OnExportSelected { get; set; }
    [Parameter] public EventCallback OnDeleteSelected { get; set; }
    [Parameter] public RenderFragment? MoreActions { get; set; }

    [Parameter] public bool BulkInProgress { get; set; }
    [Parameter] public int BulkCurrent { get; set; }
    [Parameter] public int BulkTotal { get; set; }

    private int BulkProgressPercent => BulkTotal <= 0 ? 0 : (int)Math.Round(BulkCurrent * 100.0 / BulkTotal);

    [Parameter] public EventCallback<MudTable<IncaricoListItem>?> TableRefChanged { get; set; }

    private MudTable<IncaricoListItem>? _table;
    private HashSet<int> _selectedIds = new();
    private bool _hasLocalSelectionChange;

    [Parameter] public IReadOnlyCollection<IncaricoListItem> SelectedItems { get; set; } = Array.Empty<IncaricoListItem>();
    [Parameter] public EventCallback<IReadOnlyCollection<IncaricoListItem>> SelectedItemsChanged { get; set; }

    protected override async Task OnAfterRenderAsync(bool firstRender)
        => await TableRefChanged.InvokeAsync(_table);

    private async Task RefreshAsync()
    {
        if (_table is null)
        {
            return;
        }

        await _table.ReloadServerData();
    }

    private Task NotifySelectedItemsChanged()
    {
        if (SelectedItemsChanged.HasDelegate)
        {
            var selected = Items.Where(x => _selectedIds.Contains(x.IncaricoId)).ToList();
            return SelectedItemsChanged.InvokeAsync(selected);
        }

        return Task.CompletedTask;
    }

    private void OnRowSelectionChanged(IncaricoListItem item, bool isSelected)
    {
        if (isSelected)
        {
            _selectedIds.Add(item.IncaricoId);
        }
        else
        {
            _selectedIds.Remove(item.IncaricoId);
        }

        _hasLocalSelectionChange = true;
        _ = NotifySelectedItemsChanged();
        _ = InvokeAsync(StateHasChanged);
    }

    private void ToggleRowSelectionClick(IncaricoListItem item)
        => OnRowSelectionChanged(item, !_selectedIds.Contains(item.IncaricoId));

    private void ToggleSelectAllClick()
        => ToggleSelectAll(!IsAllSelected);

    private bool IsAllSelected => Items.Any() && _selectedIds.Count == Items.Count();

    private void ToggleSelectAll(bool isSelected)
    {
        _selectedIds = isSelected
            ? new HashSet<int>(Items.Select(x => x.IncaricoId))
            : new HashSet<int>();

        _hasLocalSelectionChange = true;
        _ = NotifySelectedItemsChanged();
        _ = InvokeAsync(StateHasChanged);
    }

    protected override void OnParametersSet()
    {
        if (_hasLocalSelectionChange)
        {
            _hasLocalSelectionChange = false;
            return;
        }

        if (SelectedItems.Count == 0 && _selectedIds.Count > 0)
        {
            _selectedIds.Clear();
            return;
        }

        if (SelectedItems.Count > 0)
        {
            _selectedIds = new HashSet<int>(SelectedItems.Select(x => x.IncaricoId));
        }
    }

    private static string FormatDate(DateTime? value)
        => value is null ? "—" : value.Value.ToString("dd/MM/yyyy");
}
