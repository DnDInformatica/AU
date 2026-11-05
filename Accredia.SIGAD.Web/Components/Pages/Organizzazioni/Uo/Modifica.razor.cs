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

namespace Accredia.SIGAD.Web.Components.Pages.Organizzazioni.Uo;

public partial class Modifica : ComponentBase
{
[Parameter] public int Id { get; set; }
    [Parameter] public int UoId { get; set; }

    private IReadOnlyList<BreadcrumbItem> _breadcrumbs => new BreadcrumbItem[]
    {
        new("Home", "/"),
        new("Organizzazioni", "/organizzazioni"),
        new($"#{Id}", $"/organizzazioni/{Id}"),
        new("Unita organizzative"),
        new($"#{UoId}"),
        new("Modifica")
    };

    private sealed class FormModel
    {
        public string Nome { get; set; } = string.Empty;
        public string? Codice { get; set; }
        public bool Principale { get; set; }
        public LookupItem? TipoUnitaOrganizzativa { get; set; }
        public LookupItem? TipoSede { get; set; }
    }

    private readonly FormModel _model = new();
    private MudForm? _form;
    private bool _isLoading = true;
    private bool _isSubmitting;
    private string? _errorMessage;
    private bool _lookupsLoading = true;
    private string? _lookupsError;
    private IReadOnlyList<LookupItem> _tipiUnita = Array.Empty<LookupItem>();
    private IReadOnlyList<LookupItem> _tipiSede = Array.Empty<LookupItem>();

    protected override async Task OnParametersSetAsync()
    {
        await LoadLookupsAsync();
        await ReloadAsync();
    }

    private async Task LoadLookupsAsync()
    {
        _lookupsLoading = true;
        _lookupsError = null;

        try
        {
            var result = await GatewayClient.GetUnitaLookupsAsync(CancellationToken.None);
            if (!result.IsSuccess || result.Data is null)
            {
                _lookupsError = result.Error ?? "Impossibile caricare le tipologiche per le unita organizzative.";
                _tipiUnita = Array.Empty<LookupItem>();
                _tipiSede = Array.Empty<LookupItem>();
                return;
            }

            _tipiUnita = result.Data.TipiUnitaOrganizzativa ?? Array.Empty<LookupItem>();
            _tipiSede = result.Data.TipiSede ?? Array.Empty<LookupItem>();
        }
        catch (Exception ex)
        {
            _lookupsError = MessaggioErroreApi.Da(ex);
            _tipiUnita = Array.Empty<LookupItem>();
            _tipiSede = Array.Empty<LookupItem>();
        }
        finally
        {
            _lookupsLoading = false;
        }
    }

    private async Task ReloadAsync()
    {
        _isLoading = true;
        _errorMessage = null;

        var result = await GatewayClient.GetOrganizzazioneUnitaByIdAsync(Id, UoId, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare l'unita organizzativa.";
            _isLoading = false;
            return;
        }

        var uo = result.Data;
        _model.Nome = uo.Nome;
        _model.Codice = uo.Codice;
        _model.Principale = uo.Principale;
        _model.TipoUnitaOrganizzativa = _tipiUnita.FirstOrDefault(x => x.Id == uo.TipoUnitaOrganizzativaId);
        _model.TipoSede = uo.TipoSedeId.HasValue ? _tipiSede.FirstOrDefault(x => x.Id == uo.TipoSedeId.Value) : null;

        _isLoading = false;
    }

    private void Cancel()
        => Navigation.NavigateTo($"/organizzazioni/{Id}");

    private async Task SubmitAsync()
    {
        if (_isSubmitting) return;
        _errorMessage = null;

        if (_form is not null)
        {
            await _form.Validate();
            if (!_form.IsValid) return;
        }

        _isSubmitting = true;
        try
        {
            var payload = new UpdateUnitaOrganizzativaRequest(
                _model.Nome,
                _model.Codice,
                _model.Principale,
                _model.TipoUnitaOrganizzativa?.Id ?? 0,
                _model.TipoSede?.Id);

            var result = await GatewayClient.UpdateUnitaAsync(Id, UoId, payload, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                Snackbar.Add("Unita organizzativa aggiornata.", Severity.Success);
                Navigation.NavigateTo($"/organizzazioni/{Id}");
                return;
            }

            _errorMessage = result.Error ?? "Aggiornamento unita organizzativa non riuscito.";
        }
        catch (Exception ex)
        {
            _errorMessage = MessaggioErroreApi.Da(ex);
        }
        finally
        {
            _isSubmitting = false;
        }
    }

    private async Task SoftDeleteAsync()
    {
        if (_isSubmitting) return;

        var confirm = await DialogService.ShowMessageBox(
            "Conferma eliminazione",
            "Vuoi eliminare (soft delete) questa unita organizzativa?",
            yesText: "Elimina",
            cancelText: "Annulla");

        if (confirm != true) return;

        _isSubmitting = true;
        try
        {
            var result = await GatewayClient.SoftDeleteUnitaAsync(Id, UoId, CancellationToken.None);
            if (result.IsSuccess)
            {
                Snackbar.Add("Unita organizzativa eliminata (soft).", Severity.Success);
                Navigation.NavigateTo($"/organizzazioni/{Id}");
                return;
            }

            _errorMessage = result.Error ?? "Eliminazione unita organizzativa non riuscita.";
        }
        catch (Exception ex)
        {
            _errorMessage = MessaggioErroreApi.Da(ex);
        }
        finally
        {
            _isSubmitting = false;
        }
    }
}