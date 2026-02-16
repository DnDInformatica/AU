using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Components;
using MudBlazor;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Services;

namespace Accredia.SIGAD.Web.Components.Pages.Dettagli.Organizzazioni;

public partial class Dettaglio : ComponentBase
{
    [Inject] private GatewayClient GatewayClient { get; set; } = null!;
    [Inject] private IDialogService DialogService { get; set; } = null!;
    [Inject] private NavigationManager Navigation { get; set; } = null!;

    [Parameter] public int Id { get; set; }

    [SupplyParameterFromQuery(Name = "returnUrl")]
    public string? ReturnUrl { get; set; }

    private OrganizzazioneDetail? _detail;
    private IReadOnlyList<OrganizzazioneTipoItem>? _tipologie;
    private bool _isLoading = true;
    private string? _errorMessage;

    private int _activeTabIndex;
    private bool _verticalTabs;
    private IReadOnlyList<SedeItem> _sedi = Array.Empty<SedeItem>();
    private bool _sediLoading;
    private bool _sediLoaded;
    private string? _sediError;
    private IReadOnlyList<UnitaOrganizzativaItem> _unita = Array.Empty<UnitaOrganizzativaItem>();
    private bool _unitaLoading;
    private bool _unitaLoaded;
    private string? _unitaError;
    private bool _unitaLookupsLoaded;
    private IReadOnlyDictionary<int, string> _tipiUnitaById = new Dictionary<int, string>();
    private IReadOnlyDictionary<int, string> _tipiSedeById = new Dictionary<int, string>();
    private IReadOnlyDictionary<int, string> _unitaById = new Dictionary<int, string>();
    private IReadOnlyList<IncaricoItem> _incarichi = Array.Empty<IncaricoItem>();
    private bool _incarichiLoading;
    private bool _incarichiLoaded;
    private string? _incarichiError;
    private bool _incarichiIncludeDeleted;
    private const int DefaultRowsPerPage = 10;
    private readonly int[] _rowsPerPageOptions = [10, 20, 50];
    private int _sediTableVersion;
    private int _unitaTableVersion;
    private int _incarichiTableVersion;
    private int _sediCurrentPage;
    private int _unitaCurrentPage;
    private int _incarichiCurrentPage;
    private int _sediRowsPerPage = DefaultRowsPerPage;
    private int _unitaRowsPerPage = DefaultRowsPerPage;
    private int _incarichiRowsPerPage = DefaultRowsPerPage;
    private string? _sediSearch;
    private string? _unitaSearch;
    private string? _incarichiSearch;

    // ── Breadcrumbs ──
    private List<Models.Common.BreadcrumbItem> _breadcrumbs = new()
    {
        new("Home", "/"),
        new("Anagrafiche"),
        new("Organizzazioni", "/organizzazioni"),
        new("Caricamento…")
    };

    private string _backLabel = "Torna a Organizzazioni";
    private string _backHref = "/organizzazioni";

    protected override async Task OnInitializedAsync()
    {
        // Resolve back navigation: prefer returnUrl if available
        if (!string.IsNullOrWhiteSpace(ReturnUrl))
            _backHref = ReturnUrl;

        await LoadDetail();
    }

    private void UpdateBreadcrumbs()
    {
        var label = _detail?.Denominazione ?? $"#{Id}";
        _breadcrumbs = new List<Models.Common.BreadcrumbItem>
        {
            new("Home", "/"),
            new("Anagrafiche"),
            new("Organizzazioni", "/organizzazioni"),
            new(label)
        };
    }

    private async Task LoadDetail()
    {
        _isLoading = true;
        _errorMessage = null;

        try
        {
            var result = await GatewayClient.GetOrganizzazioneDetailAsync(Id, CancellationToken.None);
            if (result.IsSuccess)
            {
                _detail = result.Data;
                UpdateBreadcrumbs();

                var tipoResult = await GatewayClient.GetOrganizzazioneTipiAsync(Id, CancellationToken.None);
                if (tipoResult.IsSuccess)
                    _tipologie = tipoResult.Data;

                await PreloadTabCountsAsync();
            }
            else
            {
                _errorMessage = result.Error ?? "Errore nel caricamento dei dati.";
            }
        }
        catch (Exception ex)
        {
            _errorMessage = $"Errore imprevisto: {ex.Message}";
        }
        finally
        {
            _isLoading = false;
        }
    }

    private void ToggleTabPosition()
    {
        _verticalTabs = !_verticalTabs;
    }

    private async Task ActivateTabAsync(int index)
    {
        await OnTabChanged(index);
    }

    private async Task PreloadTabCountsAsync()
    {
        await Task.WhenAll(
            EnsureSediLoadedAsync(),
            EnsureUnitaLoadedAsync(),
            EnsureIncarichiLoadedAsync());
    }

    private string GetSideTabStyle(int tabIndex)
    {
        var isActive = _activeTabIndex == tabIndex;
        var border = isActive ? "#d4a574" : "transparent";
        var background = isActive ? "rgba(212, 165, 116, 0.08)" : "transparent";
        var color = isActive ? "#d4a574" : "#1a1a2e";
        var weight = isActive ? "600" : "500";

        return $"border-radius:0;justify-content:flex-end;text-align:right;border-right:3px solid {border};background:{background};color:{color};font-weight:{weight};";
    }

    private string GetSediTabText() => $"Sedi ({_sedi.Count})";
    private string GetUnitaTabText() => $"Unità organizzative ({_unita.Count})";
    private string GetIncarichiTabText() => $"Incarichi ({_incarichi.Count})";

    private async Task OnTabChanged(int index)
    {
        _activeTabIndex = index;
        if (index == 1)
        {
            await EnsureSediLoadedAsync();
        }
        else if (index == 2)
        {
            await EnsureUnitaLoadedAsync();
        }
        else if (index == 3)
        {
            await EnsureIncarichiLoadedAsync();
        }
    }

    private Task ReloadSediAsync() => EnsureSediLoadedAsync(force: true);

    private void ResetSediView()
    {
        _sediSearch = null;
        _sediCurrentPage = 0;
        _sediRowsPerPage = DefaultRowsPerPage;
        _sediTableVersion++;
    }

    private async Task EnsureSediLoadedAsync(bool force = false)
    {
        if (_sediLoading) return;
        if (_sediLoaded && !force) return;

        _sediLoading = true;
        _sediError = null;
        await InvokeAsync(StateHasChanged);

        try
        {
            var result = await GatewayClient.GetOrganizzazioneSediAsync(Id, CancellationToken.None);
            if (result.IsSuccess)
            {
                _sedi = (result.Data ?? Array.Empty<SedeItem>())
                    .OrderByDescending(static x => x.IsSedePrincipale)
                    .ThenByDescending(static x => x.IsSedeOperativa)
                    .ThenBy(static x => x.Denominazione ?? string.Empty, StringComparer.OrdinalIgnoreCase)
                    .ThenBy(static x => x.SedeId)
                    .ToList();
                _sediLoaded = true;
            }
            else
            {
                _sedi = Array.Empty<SedeItem>();
                _sediError = result.Error ?? "Errore nel caricamento sedi.";
                _sediLoaded = false;
            }
        }
        catch (Exception ex)
        {
            _sedi = Array.Empty<SedeItem>();
            _sediError = $"Errore imprevisto: {ex.Message}";
            _sediLoaded = false;
        }
        finally
        {
            _sediLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private Task ReloadUnitaAsync() => EnsureUnitaLoadedAsync(force: true);

    private void ResetUnitaView()
    {
        _unitaSearch = null;
        _unitaCurrentPage = 0;
        _unitaRowsPerPage = DefaultRowsPerPage;
        _unitaTableVersion++;
    }

    private async Task EnsureUnitaLoadedAsync(bool force = false)
    {
        if (_unitaLoading) return;
        if (_unitaLoaded && !force) return;

        _unitaLoading = true;
        _unitaError = null;
        await InvokeAsync(StateHasChanged);

        try
        {
            var result = await GatewayClient.GetOrganizzazioneUnitaAsync(Id, CancellationToken.None);
            if (result.IsSuccess)
            {
                _unita = (result.Data ?? Array.Empty<UnitaOrganizzativaItem>())
                    .OrderByDescending(static x => x.Principale)
                    .ThenBy(static x => x.Nome, StringComparer.OrdinalIgnoreCase)
                    .ThenBy(static x => x.Codice ?? string.Empty, StringComparer.OrdinalIgnoreCase)
                    .ToList();
                _unitaById = _unita
                    .GroupBy(static x => x.UnitaOrganizzativaId)
                    .ToDictionary(static g => g.Key, static g => g.First().Nome);
                await EnsureUnitaLookupsLoadedAsync();
                _unitaLoaded = true;
            }
            else
            {
                _unita = Array.Empty<UnitaOrganizzativaItem>();
                _unitaError = result.Error ?? "Errore nel caricamento unità organizzative.";
                _unitaLoaded = false;
            }
        }
        catch (Exception ex)
        {
            _unita = Array.Empty<UnitaOrganizzativaItem>();
            _unitaError = $"Errore imprevisto: {ex.Message}";
            _unitaLoaded = false;
        }
        finally
        {
            _unitaLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private Task ReloadIncarichiAsync() => EnsureIncarichiLoadedAsync(force: true);

    private void ResetIncarichiView()
    {
        _incarichiSearch = null;
        _incarichiCurrentPage = 0;
        _incarichiRowsPerPage = DefaultRowsPerPage;
        _incarichiTableVersion++;
    }

    private async Task OnIncarichiIncludeDeletedChanged(bool value)
    {
        _incarichiIncludeDeleted = value;
        _incarichiLoaded = false;
        if (_activeTabIndex == 3)
        {
            await EnsureIncarichiLoadedAsync(force: true);
        }
    }

    private async Task EnsureIncarichiLoadedAsync(bool force = false)
    {
        if (_incarichiLoading) return;
        if (_incarichiLoaded && !force) return;

        _incarichiLoading = true;
        _incarichiError = null;
        await InvokeAsync(StateHasChanged);

        try
        {
            var result = await GatewayClient.GetOrganizzazioneIncarichiAsync(Id, _incarichiIncludeDeleted, CancellationToken.None);
            if (result.IsSuccess)
            {
                _incarichi = (result.Data ?? Array.Empty<IncaricoItem>())
                    .OrderByDescending(static x => x.DataInizio)
                    .ThenBy(static x => x.PersonaCognome ?? string.Empty, StringComparer.OrdinalIgnoreCase)
                    .ThenBy(static x => x.PersonaNome ?? string.Empty, StringComparer.OrdinalIgnoreCase)
                    .ToList();
                if (_incarichi.Any(static x => x.UnitaOrganizzativaId.HasValue))
                {
                    await EnsureUnitaNameIndexLoadedAsync();
                }
                _incarichiLoaded = true;
            }
            else
            {
                _incarichi = Array.Empty<IncaricoItem>();
                _incarichiError = result.Error ?? "Errore nel caricamento incarichi.";
                _incarichiLoaded = false;
            }
        }
        catch (Exception ex)
        {
            _incarichi = Array.Empty<IncaricoItem>();
            _incarichiError = $"Errore imprevisto: {ex.Message}";
            _incarichiLoaded = false;
        }
        finally
        {
            _incarichiLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private async Task EnsureUnitaLookupsLoadedAsync(bool force = false)
    {
        if (_unitaLookupsLoaded && !force) return;

        var lookupsResult = await GatewayClient.GetUnitaLookupsAsync(CancellationToken.None);
        if (!lookupsResult.IsSuccess || lookupsResult.Data is null)
        {
            _tipiUnitaById = new Dictionary<int, string>();
            _tipiSedeById = new Dictionary<int, string>();
            _unitaLookupsLoaded = false;
            return;
        }

        _tipiUnitaById = (lookupsResult.Data.TipiUnitaOrganizzativa ?? Array.Empty<LookupItem>())
            .GroupBy(static x => x.Id)
            .ToDictionary(static g => g.Key, static g => string.IsNullOrWhiteSpace(g.First().Label) ? g.Key.ToString() : g.First().Label);
        _tipiSedeById = (lookupsResult.Data.TipiSede ?? Array.Empty<LookupItem>())
            .GroupBy(static x => x.Id)
            .ToDictionary(static g => g.Key, static g => string.IsNullOrWhiteSpace(g.First().Label) ? g.Key.ToString() : g.First().Label);
        _unitaLookupsLoaded = true;
    }

    private async Task EnsureUnitaNameIndexLoadedAsync()
    {
        if (_unitaById.Count > 0) return;

        var result = await GatewayClient.GetOrganizzazioneUnitaAsync(Id, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null) return;

        _unitaById = result.Data
            .GroupBy(static x => x.UnitaOrganizzativaId)
            .ToDictionary(static g => g.Key, static g => string.IsNullOrWhiteSpace(g.First().Nome) ? $"UO #{g.Key}" : g.First().Nome);
    }

    private static string FormatDate(DateTime? date) =>
        date.HasValue ? date.Value.ToString("dd/MM/yyyy") : "—";

    private bool FilterSede(SedeItem item)
    {
        if (string.IsNullOrWhiteSpace(_sediSearch)) return true;

        var term = _sediSearch.Trim();
        return Contains(item.Denominazione, term)
            || Contains(item.Indirizzo, term)
            || Contains(item.CAP, term)
            || Contains(item.Localita, term)
            || Contains(item.Provincia, term)
            || Contains(item.Nazione, term)
            || Contains(item.StatoSede, term);
    }

    private bool FilterUnita(UnitaOrganizzativaItem item)
    {
        if (string.IsNullOrWhiteSpace(_unitaSearch)) return true;

        var term = _unitaSearch.Trim();
        return Contains(item.Nome, term)
            || Contains(item.Codice, term)
            || Contains(GetTipoUnitaLabel(item.TipoUnitaOrganizzativaId), term)
            || Contains(GetTipoSedeLabel(item.TipoSedeId), term);
    }

    private bool FilterIncarichi(IncaricoItem item)
    {
        if (string.IsNullOrWhiteSpace(_incarichiSearch)) return true;

        var term = _incarichiSearch.Trim();
        return Contains(FormatPersona(item), term)
            || Contains(item.Ruolo, term)
            || Contains(item.StatoIncarico, term)
            || Contains(GetUnitaLabel(item.UnitaOrganizzativaId), term)
            || Contains(FormatDate(item.DataInizio), term)
            || Contains(FormatDate(item.DataFine), term);
    }

    private static bool Contains(string? source, string term)
        => !string.IsNullOrWhiteSpace(source)
           && source.Contains(term, StringComparison.OrdinalIgnoreCase);

    private static string DisplayOrDash(string? value)
        => string.IsNullOrWhiteSpace(value) ? "—" : value;

    private static string FormatSedeAddress(SedeItem sede)
    {
        var left = string.Join(" ", new[] { sede.Indirizzo, sede.NumeroCivico }.Where(static x => !string.IsNullOrWhiteSpace(x)));
        var right = string.Join(" ", new[] { sede.CAP, sede.Localita, sede.Provincia }.Where(static x => !string.IsNullOrWhiteSpace(x)));
        var nation = sede.Nazione;

        var parts = new[] { left, right, nation }.Where(static x => !string.IsNullOrWhiteSpace(x)).ToArray();
        return parts.Length == 0 ? "—" : string.Join(" · ", parts);
    }

    private static string FormatPersona(IncaricoItem incarico)
    {
        var fullName = string.Join(" ", new[] { incarico.PersonaCognome, incarico.PersonaNome }.Where(static x => !string.IsNullOrWhiteSpace(x)));
        if (string.IsNullOrWhiteSpace(fullName))
            return $"Persona #{incarico.PersonaId}";

        if (string.IsNullOrWhiteSpace(incarico.PersonaCodiceFiscale))
            return fullName;

        return $"{fullName} ({incarico.PersonaCodiceFiscale})";
    }

    private string GetTipoUnitaLabel(int tipoUnitaId)
        => _tipiUnitaById.TryGetValue(tipoUnitaId, out var label) ? label : tipoUnitaId.ToString();

    private string GetTipoSedeLabel(int? tipoSedeId)
    {
        if (!tipoSedeId.HasValue) return "—";
        return _tipiSedeById.TryGetValue(tipoSedeId.Value, out var label) ? label : tipoSedeId.Value.ToString();
    }

    private string GetUnitaLabel(int? unitaOrganizzativaId)
    {
        if (!unitaOrganizzativaId.HasValue) return "—";
        return _unitaById.TryGetValue(unitaOrganizzativaId.Value, out var label)
            ? label
            : $"UO #{unitaOrganizzativaId.Value}";
    }

    private static Color GetSedeStatoColor(string? statoSede)
    {
        if (string.IsNullOrWhiteSpace(statoSede)) return Color.Default;

        var norm = statoSede.Trim().ToUpperInvariant();
        return norm switch
        {
            "ATTIVA" => Color.Success,
            "ATTIVO" => Color.Success,
            "CESSATA" => Color.Error,
            "CESSATO" => Color.Error,
            "SOSPESA" => Color.Warning,
            "SOSPESO" => Color.Warning,
            _ => Color.Default
        };
    }

    private static Color GetIncaricoStatoColor(string? statoIncarico)
    {
        if (string.IsNullOrWhiteSpace(statoIncarico)) return Color.Default;

        var norm = statoIncarico.Trim().ToUpperInvariant();
        return norm switch
        {
            "ATTIVO" => Color.Success,
            "SOSPESO" => Color.Warning,
            "CESSATO" => Color.Error,
            _ => Color.Default
        };
    }

    private static string DisplayStatoIncarico(string? statoIncarico)
        => string.IsNullOrWhiteSpace(statoIncarico) ? "N/D" : statoIncarico;

    private static Color GetStatoColor(byte? statoId) => statoId switch
    {
        1 => Color.Success,
        2 => Color.Warning,
        3 => Color.Error,
        _ => Color.Default,
    };

    private static string GetStatoLabel(byte? statoId) => statoId switch
    {
        1 => "Attiva",
        2 => "Sospesa",
        3 => "Cessata",
        _ => "N/D",
    };
}
