using System.Globalization;
using System.Text;
using Accredia.SIGAD.Web.Components.Shared;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;
using MudBlazor;
using BreadcrumbItem = Accredia.SIGAD.Web.Models.Common.BreadcrumbItem;

namespace Accredia.SIGAD.Web.Components.Pages.Incarichi;

public partial class Incarichi
{
    private bool CanRead => UserContext.HasPermission("INC.LIST") || UserContext.HasPermission("INC.READ");
    private bool CanCreate => UserContext.HasPermission("INC.CREATE");
    private bool CanDelete => UserContext.HasPermission("INC.DELETE");

    [Parameter, SupplyParameterFromQuery(Name = "q")]
    public string? Q { get; set; }

    private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs =
    [
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("Incarichi")
    ];

    private MudTable<IncaricoListItem>? _table;
    private IEnumerable<IncaricoListItem> _items = Array.Empty<IncaricoListItem>();
    private string? _errorMessage;
    private string? _query;
    private string _emptyMessage = "Inserisci un criterio di ricerca.";
    private int _totalCount;
    private bool _queryFromUrlApplied;
    private bool _filtersExpanded = true;
    private int _activeFiltersCount;
    private MudTextField<string>? _queryField;
    private IReadOnlyCollection<IncaricoListItem> _selectedItems = Array.Empty<IncaricoListItem>();
    private bool _bulkInProgress;
    private int _bulkCurrent;
    private int _bulkTotal;
    private DateTimeOffset? _bulkStartedAt;

    private string _resultsHint
        => string.IsNullOrWhiteSpace(_query) || _query.Trim().Length < 2
            ? "Inserisci almeno 2 caratteri per la ricerca."
            : $"Totale: {_totalCount}";

    protected override void OnParametersSet()
    {
        if (!_queryFromUrlApplied && !string.IsNullOrWhiteSpace(Q))
        {
            _queryFromUrlApplied = true;
            _query = Q;
            UpdateFiltersCount();
        }
    }

    private Task ApplyFilters()
    {
        _errorMessage = null;
        _filtersExpanded = false;
        UpdateFiltersCount();
        _table?.ReloadServerData();
        return Task.CompletedTask;
    }

    private Task ResetFilters()
    {
        _query = null;
        _totalCount = 0;
        _filtersExpanded = true;
        UpdateFiltersCount();
        _table?.ReloadServerData();
        _ = FocusQueryAsync();
        return Task.CompletedTask;
    }

    private Task OnQueryChanged(string? value)
    {
        _query = value;
        UpdateFiltersCount();
        return Task.CompletedTask;
    }

    private void UpdateFiltersCount()
        => _activeFiltersCount = string.IsNullOrWhiteSpace(_query) ? 0 : 1;

    private void OnQueryFieldRefChanged(MudTextField<string>? field)
        => _queryField = field;

    private Task OnFiltersExpandedChanged(bool value)
    {
        _filtersExpanded = value;
        return Task.CompletedTask;
    }

    private async Task FocusQueryAsync()
    {
        try
        {
            if (_queryField is not null)
            {
                await _queryField.FocusAsync();
            }
        }
        catch
        {
            // best effort
        }
    }

    private async Task<TableData<IncaricoListItem>> LoadIncarichi(TableState state, CancellationToken cancellationToken)
    {
        if (!CanRead)
        {
            _errorMessage = "Accesso negato: permesso INC.LIST/READ mancante.";
            return new TableData<IncaricoListItem>
            {
                Items = Array.Empty<IncaricoListItem>(),
                TotalItems = 0
            };
        }

        var page = state.Page + 1;
        var pageSize = state.PageSize;

        if (string.IsNullOrWhiteSpace(_query) || _query.Trim().Length < 2)
        {
            _emptyMessage = "Inserisci almeno 2 caratteri per la ricerca.";
            return new TableData<IncaricoListItem>
            {
                Items = Array.Empty<IncaricoListItem>(),
                TotalItems = 0
            };
        }

        var result = await GatewayClient.SearchIncarichiAsync(_query, page, pageSize, cancellationToken);
        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare gli incarichi.";
            return new TableData<IncaricoListItem>
            {
                Items = Array.Empty<IncaricoListItem>(),
                TotalItems = 0
            };
        }

        _errorMessage = null;
        _items = result.Data.Items;
        _totalCount = result.Data.TotalCount;

        return new TableData<IncaricoListItem>
        {
            Items = result.Data.Items,
            TotalItems = result.Data.TotalCount
        };
    }

    private void OpenQuickPreview(IncaricoListItem item)
    {
        QuickDrawer.Open(new QuickDrawerRequest(
            Title: $"{item.PersonaCognome} {item.PersonaNome}",
            Subtitle: item.OrganizzazioneDenominazione,
            Body: BuildQuickPreviewBody(item),
            Actions: BuildQuickPreviewActions(item)));
    }

    private RenderFragment BuildQuickPreviewBody(IncaricoListItem item) => builder =>
    {
        builder.OpenComponent<IncaricoQuickPreview>(0);
        builder.AddAttribute(1, "Item", item);
        builder.CloseComponent();
    };

    private RenderFragment BuildQuickPreviewActions(IncaricoListItem item) => builder =>
    {
        builder.OpenComponent<QuickPreviewActions>(0);
        builder.AddAttribute(1, "OnClose", EventCallback.Factory.Create(this, () => QuickDrawer.Close()));
        builder.AddAttribute(2, "OnOpenDetail", EventCallback.Factory.Create(this, () => NavigateToDetail(item.IncaricoId)));
        builder.CloseComponent();
    };

    private void NavigateToDetail(int incaricoId)
    {
        QuickDrawer.Close();
        Navigation.NavigateTo($"/incarichi/{incaricoId}");
    }

    private void OnRowClick(TableRowClickEventArgs<IncaricoListItem> args)
    {
        if (args.Item is null)
        {
            return;
        }

        OpenQuickPreview(args.Item);
    }

    private void CreateNew()
    {
        if (!CanCreate)
        {
            Snackbar.Add("Accesso negato: permesso INC.CREATE mancante.", Severity.Error);
            return;
        }

        Navigation.NavigateTo("/incarichi/nuovo");
    }

    private void OnTableRefChanged(MudTable<IncaricoListItem>? table)
        => _table = table;

    private Task OnSelectedItemsChanged(IReadOnlyCollection<IncaricoListItem> items)
    {
        _selectedItems = items;
        return Task.CompletedTask;
    }

    private async Task StartBulkProgressAsync()
    {
        _bulkInProgress = true;
        _bulkCurrent = 0;
        _bulkTotal = _selectedItems.Count;
        _bulkStartedAt = DateTimeOffset.UtcNow;
        await InvokeAsync(StateHasChanged);
        await Task.Delay(50);
    }

    private async Task AdvanceBulkProgressAsync()
    {
        _bulkCurrent++;
        await InvokeAsync(StateHasChanged);
    }

    private async Task EndBulkProgressAsync()
    {
        if (_bulkStartedAt is not null)
        {
            var elapsed = DateTimeOffset.UtcNow - _bulkStartedAt.Value;
            if (elapsed < TimeSpan.FromMilliseconds(500))
            {
                await Task.Delay(TimeSpan.FromMilliseconds(500) - elapsed);
            }
        }

        _bulkInProgress = false;
        _bulkCurrent = 0;
        _bulkTotal = 0;
        _bulkStartedAt = null;
        await InvokeAsync(StateHasChanged);
    }

    private async Task OnExportSelected()
    {
        if (_selectedItems.Count == 0)
        {
            return;
        }

        var confirm = await DialogService.ShowMessageBox(
            "Conferma esportazione",
            $"Vuoi esportare {_selectedItems.Count} incarichi selezionati?\n\n" +
            "L'operazione potrebbe richiedere qualche secondo.",
            yesText: "Esporta",
            cancelText: "Annulla");

        if (confirm != true)
        {
            return;
        }

        await StartBulkProgressAsync();

        var csv = await BuildCsvWithProgressAsync(_selectedItems, AdvanceBulkProgressAsync);
        var filename = $"incarichi-{DateTime.Now:yyyyMMdd-HHmm}.csv";
        await JS.InvokeVoidAsync("sigadDownloadFile", filename, csv, "text/csv;charset=utf-8");

        await EndBulkProgressAsync();
    }

    private async Task OnDeleteSelected()
    {
        if (!CanDelete)
        {
            Snackbar.Add("Accesso negato: permesso INC.DELETE mancante.", Severity.Error);
            return;
        }

        if (_selectedItems.Count == 0)
        {
            return;
        }

        var confirm = await DialogService.ShowMessageBox(
            "Conferma eliminazione",
            $"Vuoi eliminare {_selectedItems.Count} incarichi selezionati?\n\n" +
            "Attenzione: l'operazione e irreversibile.",
            yesText: "Elimina",
            cancelText: "Annulla");

        if (confirm != true)
        {
            return;
        }

        var errors = new List<string>();
        await StartBulkProgressAsync();
        foreach (var item in _selectedItems)
        {
            var result = await GatewayClient.SoftDeleteIncaricoAsync(item.IncaricoId, CancellationToken.None);
            if (!result.IsSuccess)
            {
                errors.Add(result.Error ?? $"Errore eliminando #{item.IncaricoId}");
            }

            await AdvanceBulkProgressAsync();
        }

        await EndBulkProgressAsync();
        if (errors.Count > 0)
        {
            Snackbar.Add($"Eliminazione parziale: {errors.Count} errori.", Severity.Warning);
        }
        else
        {
            Snackbar.Add("Incarichi eliminati.", Severity.Success);
        }

        _selectedItems = Array.Empty<IncaricoListItem>();
        _table?.ReloadServerData();
    }

    private static async Task<string> BuildCsvWithProgressAsync(
        IReadOnlyCollection<IncaricoListItem> items,
        Func<Task> onRowAsync)
    {
        static string Esc(string? value)
        {
            if (string.IsNullOrEmpty(value))
            {
                return "\"\"";
            }

            return "\"" + value.Replace("\"", "\"\"") + "\"";
        }

        var sb = new StringBuilder();
        sb.AppendLine("IncaricoId;Persona;Organizzazione;Ruolo;DataInizio;DataFine;Stato");

        var index = 0;
        var yieldEvery = items.Count <= 50 ? 1 : 25;
        foreach (var item in items)
        {
            sb.Append(item.IncaricoId.ToString(CultureInfo.InvariantCulture)).Append(';')
              .Append(Esc($"{item.PersonaCognome} {item.PersonaNome}")).Append(';')
              .Append(Esc(item.OrganizzazioneDenominazione)).Append(';')
              .Append(Esc(item.Ruolo)).Append(';')
              .Append(item.DataInizio.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)).Append(';')
              .Append(item.DataFine?.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) ?? string.Empty).Append(';')
              .Append(Esc(item.StatoIncarico));
            sb.AppendLine();
            index++;
            await onRowAsync();
            if (index % yieldEvery == 0)
            {
                await Task.Yield();
            }
        }

        return sb.ToString();
    }
}
