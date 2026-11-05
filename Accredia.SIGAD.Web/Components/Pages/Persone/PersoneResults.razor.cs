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

namespace Accredia.SIGAD.Web.Components.Pages.Persone;

public partial class PersoneResults : ComponentBase
{
[Parameter] public IEnumerable<PersonaListItem> Items { get; set; } = Array.Empty<PersonaListItem>();

    [Parameter]
    public Func<TableState, CancellationToken, Task<TableData<PersonaListItem>>> ServerData { get; set; }
        = default!;

    [Parameter] public string ResultsHint { get; set; } = string.Empty;
    [Parameter] public bool IsLoading { get; set; }
    [Parameter] public string? Query { get; set; }
    [Parameter] public string EmptyMessage { get; set; } = string.Empty;

    [Parameter] public EventCallback<TableRowClickEventArgs<PersonaListItem>> OnRowClick { get; set; }
    [Parameter] public EventCallback<PersonaListItem> OnQuickPreview { get; set; }
    [Parameter] public EventCallback OnCreateNew { get; set; }
    [Parameter] public EventCallback OnExportSelected { get; set; }
    [Parameter] public EventCallback OnDeleteSelected { get; set; }
    [Parameter] public RenderFragment? MoreActions { get; set; }

    [Parameter] public bool BulkInProgress { get; set; }
    [Parameter] public int BulkCurrent { get; set; }
    [Parameter] public int BulkTotal { get; set; }

    private int BulkProgressPercent => BulkTotal <= 0 ? 0 : (int)Math.Round(BulkCurrent * 100.0 / BulkTotal);

    [Parameter] public EventCallback<MudTable<PersonaListItem>?> TableRefChanged { get; set; }

    private MudTable<PersonaListItem>? _table;
    private HashSet<int> _selectedIds = new();
    private bool _hasLocalSelectionChange;

    [Parameter] public IReadOnlyCollection<PersonaListItem> SelectedItems { get; set; } = Array.Empty<PersonaListItem>();
    [Parameter] public EventCallback<IReadOnlyCollection<PersonaListItem>> SelectedItemsChanged { get; set; }

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
            var selected = Items.Where(x => _selectedIds.Contains(x.PersonaId)).ToList();
            return SelectedItemsChanged.InvokeAsync(selected);
        }

        return Task.CompletedTask;
    }

    private void OnRowSelectionChanged(PersonaListItem item, bool isSelected)
    {
        if (isSelected)
        {
            _selectedIds.Add(item.PersonaId);
        }
        else
        {
            _selectedIds.Remove(item.PersonaId);
        }

        _hasLocalSelectionChange = true;
        _ = NotifySelectedItemsChanged();
        _ = InvokeAsync(StateHasChanged);
    }

    private void ToggleRowSelectionClick(PersonaListItem item)
        => OnRowSelectionChanged(item, !_selectedIds.Contains(item.PersonaId));

    private void ToggleSelectAllClick()
        => ToggleSelectAll(!IsAllSelected);

    private bool IsAllSelected => Items.Any() && _selectedIds.Count == Items.Count();

    private void ToggleSelectAll(bool isSelected)
    {
        _selectedIds = isSelected
            ? new HashSet<int>(Items.Select(x => x.PersonaId))
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
            _selectedIds = new HashSet<int>(SelectedItems.Select(x => x.PersonaId));
        }
    }
}