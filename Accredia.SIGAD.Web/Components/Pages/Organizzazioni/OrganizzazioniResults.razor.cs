using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Microsoft.AspNetCore.Components;
using MudBlazor;

namespace Accredia.SIGAD.Web.Components.Pages.AnagraficheIndex;

public partial class OrganizzazioniResults : ComponentBase
{
    [Parameter] public IEnumerable<OrganizzazioneListItem> Items { get; set; } = Array.Empty<OrganizzazioneListItem>();

    [Parameter]
    public Func<TableState, CancellationToken, Task<TableData<OrganizzazioneListItem>>> ServerData { get; set; } = default!;

    [Parameter] public string ResultsHint { get; set; } = string.Empty;
    [Parameter] public bool IsLoading { get; set; }

    [Parameter] public string? Query { get; set; }
    [Parameter] public bool HasActiveFilters { get; set; }

    [Parameter] public EventCallback<TableRowClickEventArgs<OrganizzazioneListItem>> OnRowClick { get; set; }
    [Parameter] public EventCallback<OrganizzazioneListItem> OnQuickPreview { get; set; }

    [Parameter] public Func<byte?, Color> GetStatoColor { get; set; } = default!;
    [Parameter] public Func<byte?, string> GetStatoLabel { get; set; } = default!;

    [Parameter] public EventCallback<MudTable<OrganizzazioneListItem>?> TableRefChanged { get; set; }
    [Parameter] public EventCallback<ElementReference> ResultsFocusRefChanged { get; set; }
    [Parameter] public IReadOnlyList<LookupItem> StatiAttivita { get; set; } = Array.Empty<LookupItem>();

    [Parameter] public EventCallback OnExportSelected { get; set; }
    [Parameter] public EventCallback OnDeleteSelected { get; set; }
    [Parameter] public EventCallback<LookupItem> OnChangeStatusSelected { get; set; }

    [Parameter] public RenderFragment? MoreActions { get; set; }

    [Parameter] public bool BulkInProgress { get; set; }
    [Parameter] public int BulkCurrent { get; set; }
    [Parameter] public int BulkTotal { get; set; }

    [Parameter] public string? ListReturnUrl { get; set; }

    [Parameter] public IReadOnlyCollection<OrganizzazioneListItem> SelectedItems { get; set; } = Array.Empty<OrganizzazioneListItem>();
    [Parameter] public EventCallback<IReadOnlyCollection<OrganizzazioneListItem>> SelectedItemsChanged { get; set; }

    private MudTable<OrganizzazioneListItem>? _table;
    private ElementReference _resultsFocus;
    private HashSet<int> _selectedIds = new();
    private bool _hasLocalSelectionChange;

    protected int SelectedCount => _selectedIds.Count;

    protected int BulkProgressPercent =>
        BulkTotal <= 0 ? 0 : (int)Math.Round(BulkCurrent * 100.0 / BulkTotal);

    protected bool IsAllSelected =>
        Items.Any() && _selectedIds.Count == Items.Count();

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        await TableRefChanged.InvokeAsync(_table);
        await ResultsFocusRefChanged.InvokeAsync(_resultsFocus);
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
            _selectedIds = new HashSet<int>(SelectedItems.Select(x => x.OrganizzazioneId));
        }
    }

    protected string BuildDetailHref(int organizzazioneId)
    {
        var baseUrl = $"/organizzazioni/{organizzazioneId}";
        return string.IsNullOrEmpty(ListReturnUrl)
            ? baseUrl
            : $"{baseUrl}?returnUrl={Uri.EscapeDataString(ListReturnUrl)}";
    }

    protected async Task RefreshAsync()
    {
        if (_table is null)
            return;

        await _table.ReloadServerData();
    }

    protected void ToggleRowSelectionClick(OrganizzazioneListItem item)
        => OnRowSelectionChanged(item, !_selectedIds.Contains(item.OrganizzazioneId));

    protected void ToggleSelectAllClick()
        => ToggleSelectAll(!IsAllSelected);

    protected void ToggleSelectAll(bool isSelected)
    {
        _selectedIds = isSelected
            ? new HashSet<int>(Items.Select(x => x.OrganizzazioneId))
            : new HashSet<int>();

        _hasLocalSelectionChange = true;
        _ = NotifySelectedItemsChanged();
        _ = InvokeAsync(StateHasChanged);
    }

    protected void OnRowSelectionChanged(OrganizzazioneListItem item, bool isSelected)
    {
        if (isSelected)
            _selectedIds.Add(item.OrganizzazioneId);
        else
            _selectedIds.Remove(item.OrganizzazioneId);

        _hasLocalSelectionChange = true;
        _ = NotifySelectedItemsChanged();
        _ = InvokeAsync(StateHasChanged);
    }

    private Task NotifySelectedItemsChanged()
    {
        if (SelectedItemsChanged.HasDelegate)
        {
            var selected = Items.Where(x => _selectedIds.Contains(x.OrganizzazioneId)).ToList();
            return SelectedItemsChanged.InvokeAsync(selected);
        }

        return Task.CompletedTask;
    }
}

