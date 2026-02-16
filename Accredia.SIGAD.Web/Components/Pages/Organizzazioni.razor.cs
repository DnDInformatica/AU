using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using MudBlazor;
using Accredia.SIGAD.Web.Components.Shared;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Services;
using System.Globalization;
using System.Text;
using Microsoft.JSInterop;

namespace Accredia.SIGAD.Web.Components.Pages.AnagraficheIndex;

public partial class Organizzazioni : ComponentBase
{
    [Inject] private GatewayClient GatewayClient { get; set; } = null!;
    [Inject] private QuickDrawerService QuickDrawer { get; set; } = null!;
    [Inject] private NavigationManager Navigation { get; set; } = null!;
    [Inject] private ISnackbar Snackbar { get; set; } = null!;
    [Inject] private IDialogService DialogService { get; set; } = null!;
    [Inject] private IJSRuntime JS { get; set; } = null!;

    private readonly List<Models.Common.BreadcrumbItem> _breadcrumbs = new()
    {
        new("Home", "/"),
        new("Anagrafiche"),
        new("Organizzazioni")
    };

    private MudTable<OrganizzazioneListItem>? _table;
    private ElementReference _resultsFocus;
    private MudTextField<string>? _queryField;

    private IEnumerable<OrganizzazioneListItem> _items = Array.Empty<OrganizzazioneListItem>();
    private IReadOnlyCollection<OrganizzazioneListItem> _selectedItems = Array.Empty<OrganizzazioneListItem>();
    private bool _bulkInProgress;
    private int _bulkCurrent;
    private int _bulkTotal;
    private DateTimeOffset? _bulkStartedAt;
    private string? _errorMessage;
    private string? _query;
    private LookupItem? _statoAttivita;
    private LookupItem? _tipoOrganizzazione;

    private int _totalCount;
    private bool _filtersExpanded = true;
    private int _activeFiltersCount;

    private void OnTableRefChanged(MudTable<OrganizzazioneListItem>? table) => _table = table;
    private void OnResultsFocusRefChanged(ElementReference r) => _resultsFocus = r;
    private void OnQueryFieldRefChanged(MudTextField<string>? field) => _queryField = field;

    private bool HasActiveFilters =>
        (_query is not null && _query.Trim().Length >= 2) ||
        _statoAttivita is not null ||
        _tipoOrganizzazione is not null;

    private string _resultsHint =>
        !HasActiveFilters
            ? string.Empty
            : $"{_totalCount} {(_totalCount == 1 ? "risultato" : "risultati")}";

    private readonly List<LookupItem> _statiAttivita = new();
    private readonly List<LookupItem> _tipiOrganizzazione = new();

    protected override async Task OnInitializedAsync()
    {
        UpdateFiltersTitleAndCount();

        var stati = await GatewayClient.GetOrganizzazioneStatiAttivitaLookupsAsync(CancellationToken.None);
        if (stati.IsSuccess && stati.Data is not null)
        {
            _statiAttivita.Clear();
            _statiAttivita.AddRange(stati.Data);
        }

        if (_statiAttivita.Count == 0)
        {
            _statiAttivita.AddRange(new[]
            {
                new LookupItem(1, "Attiva"),
                new LookupItem(2, "Sospesa"),
                new LookupItem(3, "Cessata")
            });
        }

        var tipi = await GatewayClient.GetOrganizzazioneTipologieLookupsAsync(CancellationToken.None);
        if (tipi.IsSuccess && tipi.Data is not null)
        {
            _tipiOrganizzazione.Clear();
            _tipiOrganizzazione.AddRange(tipi.Data);
        }
    }

    private async Task<TableData<OrganizzazioneListItem>> LoadOrganizzazioni(TableState state, CancellationToken cancellationToken)
    {
        var page = state.Page + 1;
        var pageSize = state.PageSize;

        if (!HasActiveFilters)
        {
            ResetTableState();
            return new TableData<OrganizzazioneListItem>
            {
                Items = Array.Empty<OrganizzazioneListItem>(),
                TotalItems = 0
            };
        }

        var result = await GatewayClient.SearchOrganizzazioniAsync(
            _query,
            page,
            pageSize,
            _statoAttivita?.Id,
            _tipoOrganizzazione?.Id,
            cancellationToken);

        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare le organizzazioni.";
            ResetTableState();
            return new TableData<OrganizzazioneListItem>
            {
                Items = Array.Empty<OrganizzazioneListItem>(),
                TotalItems = 0
            };
        }

        _errorMessage = null;
        _items = result.Data.Items;
        _totalCount = result.Data.TotalCount;

        await InvokeAsync(StateHasChanged);

        return new TableData<OrganizzazioneListItem>
        {
            Items = result.Data.Items,
            TotalItems = result.Data.TotalCount
        };
    }

    private async Task ApplyFilters()
    {
        _errorMessage = null;
        _filtersExpanded = false;

        UpdateFiltersTitleAndCount();

        _table?.ReloadServerData();
        await FocusResultsAsync();
    }

    private async Task ResetFilters()
    {
        _query = null;
        _statoAttivita = null;
        _tipoOrganizzazione = null;
        _totalCount = 0;
        _filtersExpanded = true;

        UpdateFiltersTitleAndCount();

        _table?.ReloadServerData();
        await InvokeAsync(StateHasChanged);

        try
        {
            if (_queryField is not null)
                await _queryField.FocusAsync();
        }
        catch
        {
            // best effort
        }
    }

    private async Task FocusResultsAsync()
    {
        await InvokeAsync(StateHasChanged);
        try
        {
            await _resultsFocus.FocusAsync();
        }
        catch
        {
            // best effort
        }
    }

    private static string BuildShortQueryLabel(string? value)
    {
        var v = (value ?? string.Empty).Trim();
        return v.Length <= 24 ? v : v[..21] + "...";
    }

    private void UpdateFiltersTitleAndCount()
    {
        var count = 0;
        if (!string.IsNullOrWhiteSpace(_query)) count++;
        if (_statoAttivita is not null) count++;
        if (_tipoOrganizzazione is not null) count++;

        _activeFiltersCount = count;
    }

    private async Task ClearQueryAsync()
    {
        _query = null;
        UpdateFiltersTitleAndCount();
        await ApplyFilters();
    }

    private async Task ClearStatoAttivitaAsync()
    {
        _statoAttivita = null;
        UpdateFiltersTitleAndCount();
        await ApplyFilters();
    }

    private async Task ClearTipoOrganizzazioneAsync()
    {
        _tipoOrganizzazione = null;
        UpdateFiltersTitleAndCount();
        await ApplyFilters();
    }

    private Task OnQueryChipClosed(MudChip<string> _) => ClearQueryAsync();
    private Task OnStatoChipClosed(MudChip<string> _) => ClearStatoAttivitaAsync();
    private Task OnTipoChipClosed(MudChip<string> _) => ClearTipoOrganizzazioneAsync();

    private void ResetTableState()
    {
        _items = Array.Empty<OrganizzazioneListItem>();
        _totalCount = 0;
    }

    private string GetStatoLabel(byte? statoId)
    {
        if (statoId is not null)
        {
            var found = _statiAttivita.FirstOrDefault(x => x.Id == statoId.Value);
            if (found is not null && !string.IsNullOrWhiteSpace(found.Label))
                return found.Label;
        }

        return statoId switch
        {
            1 => "Attiva",
            2 => "Sospesa",
            3 => "Cessata",
            null => "N/D",
            _ => $"Stato {statoId}"
        };
    }

    private Color GetStatoColor(byte? statoId)
    {
        var label = GetStatoLabel(statoId).Trim().ToLowerInvariant();

        if (label.Contains("attiv")) return Color.Success;
        if (label.Contains("sosp")) return Color.Warning;
        if (label.Contains("cess") || label.Contains("canc")) return Color.Error;

        return Color.Info;
    }

    private void OpenQuickPreview(OrganizzazioneListItem item)
    {
        QuickDrawer.Open(new QuickDrawerRequest(
            Title: item.Denominazione,
            Subtitle: BuildQuickSubtitle(item),
            Body: builder =>
            {
                builder.OpenComponent<OrganizzazioneQuickPreview>(0);
                builder.AddAttribute(1, "Item", item);
                builder.CloseComponent();
            },
            Actions: builder =>
            {
                builder.OpenComponent<MudStack>(0);
                builder.AddAttribute(1, "Direction", "Row");
                builder.AddAttribute(2, "Justify", Justify.FlexEnd);
                builder.AddAttribute(3, "Spacing", 1);
                builder.AddAttribute(4, "ChildContent", (RenderFragment)(builder2 =>
                {
                    builder2.OpenComponent<MudButton>(0);
                    builder2.AddAttribute(1, "Variant", Variant.Text);
                    builder2.AddAttribute(2, "Color", Color.Inherit);
                    builder2.AddAttribute(3, "OnClick", EventCallback.Factory.Create<MouseEventArgs>(this, QuickDrawer.Close));
                    builder2.AddAttribute(4, "ChildContent", (RenderFragment)(b => b.AddContent(0, "Chiudi")));
                    builder2.CloseComponent();

                    builder2.OpenComponent<MudButton>(1);
                    builder2.AddAttribute(1, "Variant", Variant.Filled);
                    builder2.AddAttribute(2, "Color", Color.Primary);
                    builder2.AddAttribute(3, "OnClick", EventCallback.Factory.Create<MouseEventArgs>(this, () => NavigateToDetail(item.OrganizzazioneId)));
                    builder2.AddAttribute(4, "ChildContent", (RenderFragment)(b => b.AddContent(0, "Apri scheda")));
                    builder2.CloseComponent();
                }));
                builder.CloseComponent();
            }
        ));
    }

    private void NavigateToDetail(int organizzazioneId)
    {
        QuickDrawer.Close();
        var returnUrl = BuildReturnUrl();
        var url = string.IsNullOrEmpty(returnUrl)
            ? $"/organizzazioni/{organizzazioneId}"
            : $"/organizzazioni/{organizzazioneId}?returnUrl={Uri.EscapeDataString(returnUrl)}";
        Navigation.NavigateTo(url);
    }

    private string BuildReturnUrl()
    {
        var sb = new StringBuilder("/organizzazioni");
        var sep = '?';

        if (!string.IsNullOrWhiteSpace(_query))
        {
            sb.Append(sep).Append("q=").Append(Uri.EscapeDataString(_query.Trim()));
            sep = '&';
        }

        if (_statoAttivita is not null)
        {
            sb.Append(sep).Append("statoId=").Append(_statoAttivita.Id.ToString(CultureInfo.InvariantCulture));
            sep = '&';
        }

        if (_tipoOrganizzazione is not null)
        {
            sb.Append(sep).Append("tipoId=").Append(_tipoOrganizzazione.Id.ToString(CultureInfo.InvariantCulture));
        }

        return sb.Length > "/organizzazioni".Length ? sb.ToString() : string.Empty;
    }

    private static string BuildQuickSubtitle(OrganizzazioneListItem item)
    {
        var parts = new List<string>(2);

        if (!string.IsNullOrWhiteSpace(item.PartitaIVA))
            parts.Add($"P.IVA {item.PartitaIVA}");

        if (!string.IsNullOrWhiteSpace(item.CodiceFiscale))
            parts.Add($"CF {item.CodiceFiscale}");

        return parts.Count == 0 ? "Anteprima organizzazione" : string.Join(" - ", parts);
    }

    private void OnRowClick(TableRowClickEventArgs<OrganizzazioneListItem> args)
        => OpenQuickPreview(args.Item);

    private void CreateNew()
        => Navigation.NavigateTo("/organizzazioni/nuova");

    private Task OnSelectedItemsChanged(IReadOnlyCollection<OrganizzazioneListItem> items)
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
            $"Vuoi esportare {_selectedItems.Count} organizzazioni selezionate?\n\n" +
            "L'operazione potrebbe richiedere qualche secondo.",
            yesText: "Esporta",
            cancelText: "Annulla");

        if (confirm != true)
        {
            return;
        }

        await StartBulkProgressAsync();

        var csv = await BuildCsvWithProgressAsync(_selectedItems, AdvanceBulkProgressAsync);
        var filename = $"organizzazioni-{DateTime.Now:yyyyMMdd-HHmm}.csv";
        await JS.InvokeVoidAsync("sigadDownloadFile", filename, csv, "text/csv;charset=utf-8");

        await EndBulkProgressAsync();
    }

    private async Task OnDeleteSelected()
    {
        if (_selectedItems.Count == 0)
        {
            return;
        }

        var confirm = await DialogService.ShowMessageBox(
            "Conferma eliminazione",
            $"Vuoi eliminare {_selectedItems.Count} organizzazioni selezionate?\n\n" +
            "Attenzione: l'operazione è irreversibile.",
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
            var result = await GatewayClient.SoftDeleteOrganizzazioneAsync(item.OrganizzazioneId, CancellationToken.None);
            if (!result.IsSuccess)
            {
                errors.Add(result.Error ?? $"Errore eliminando #{item.OrganizzazioneId}");
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
            Snackbar.Add("Organizzazioni eliminate.", Severity.Success);
        }

        _selectedItems = Array.Empty<OrganizzazioneListItem>();
        _table?.ReloadServerData();
    }

    private async Task OnChangeStatusSelected(LookupItem stato)
    {
        if (_selectedItems.Count == 0)
        {
            return;
        }

        var confirm = await DialogService.ShowMessageBox(
            "Conferma cambio stato",
            $"Vuoi impostare lo stato '{stato.Label}' per {_selectedItems.Count} organizzazioni selezionate?\n\n" +
            "Attenzione: verifica la selezione prima di confermare.",
            yesText: "Conferma",
            cancelText: "Annulla");

        if (confirm != true)
        {
            return;
        }

        var errors = new List<string>();
        await StartBulkProgressAsync();
        foreach (var item in _selectedItems)
        {
            var detailResult = await GatewayClient.GetOrganizzazioneDetailAsync(item.OrganizzazioneId, CancellationToken.None);
            if (!detailResult.IsSuccess || detailResult.Data is null)
            {
                errors.Add(detailResult.Error ?? $"Dettaglio non disponibile per #{item.OrganizzazioneId}");
                await AdvanceBulkProgressAsync();
                continue;
            }

            var detail = detailResult.Data;
            var update = new UpdateOrganizzazioneRequest(
                detail.Denominazione,
                detail.RagioneSociale,
                detail.PartitaIVA,
                detail.CodiceFiscale,
                stato.Id > 0 ? (byte)stato.Id : detail.StatoAttivitaId,
                detail.NRegistroImprese,
                detail.TipoCodiceNaturaGiuridicaId,
                detail.OggettoSociale,
                detail.DataIscrizioneIscrizioneRI,
                detail.DataCostituzione);

            var updateResult = await GatewayClient.UpdateOrganizzazioneAsync(item.OrganizzazioneId, update, CancellationToken.None);
            if (!updateResult.IsSuccess)
            {
                errors.Add(updateResult.Error ?? $"Errore aggiornando #{item.OrganizzazioneId}");
            }
            await AdvanceBulkProgressAsync();
        }

        await EndBulkProgressAsync();
        if (errors.Count > 0)
        {
            Snackbar.Add($"Aggiornamento parziale: {errors.Count} errori.", Severity.Warning);
        }
        else
        {
            Snackbar.Add("Stato aggiornato.", Severity.Success);
        }

        _selectedItems = Array.Empty<OrganizzazioneListItem>();
        _table?.ReloadServerData();
    }

    private static async Task<string> BuildCsvWithProgressAsync(
        IReadOnlyCollection<OrganizzazioneListItem> items,
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
        sb.AppendLine("OrganizzazioneId;Denominazione;RagioneSociale;PartitaIVA;CodiceFiscale;StatoAttivitaId");

        var index = 0;
        var yieldEvery = items.Count <= 50 ? 1 : 25;
        foreach (var item in items)
        {
            sb.Append(item.OrganizzazioneId.ToString(CultureInfo.InvariantCulture)).Append(';')
              .Append(Esc(item.Denominazione)).Append(';')
              .Append(Esc(item.RagioneSociale)).Append(';')
              .Append(Esc(item.PartitaIVA)).Append(';')
              .Append(Esc(item.CodiceFiscale)).Append(';')
              .Append(item.StatoAttivitaId?.ToString(CultureInfo.InvariantCulture) ?? string.Empty);
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

    private Task OnQueryChanged(string? value)
    {
        _query = value;
        UpdateFiltersTitleAndCount();
        return Task.CompletedTask;
    }

    private Task OnStatoChanged(LookupItem? value)
    {
        _statoAttivita = value;
        UpdateFiltersTitleAndCount();
        return Task.CompletedTask;
    }

    private Task OnTipoChanged(LookupItem? value)
    {
        _tipoOrganizzazione = value;
        UpdateFiltersTitleAndCount();
        return Task.CompletedTask;
    }

    private Task OnFiltersExpandedChanged(bool value)
    {
        _filtersExpanded = value;
        return Task.CompletedTask;
    }
}
