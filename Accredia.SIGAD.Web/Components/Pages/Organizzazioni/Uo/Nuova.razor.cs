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

public partial class Nuova : ComponentBase
{
[Parameter] public int Id { get; set; }

    private IReadOnlyList<BreadcrumbItem> _breadcrumbs => new BreadcrumbItem[]
    {
        new("Home", "/"),
        new("Organizzazioni", "/organizzazioni"),
        new($"#{Id}", $"/organizzazioni/{Id}"),
        new("Unita organizzative"),
        new("Nuova")
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
    private bool _isSubmitting;
    private string? _errorMessage;
    private bool _lookupsLoading = true;
    private string? _lookupsError;
    private IReadOnlyList<LookupItem> _tipiUnita = Array.Empty<LookupItem>();
    private IReadOnlyList<LookupItem> _tipiSede = Array.Empty<LookupItem>();

    protected override async Task OnInitializedAsync()
        => await LoadLookupsAsync();

    private void Cancel()
        => Navigation.NavigateTo($"/organizzazioni/{Id}");

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

            if (_model.TipoUnitaOrganizzativa is null && _tipiUnita.Count > 0)
            {
                _model.TipoUnitaOrganizzativa = _tipiUnita[0];
            }
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
            var payload = new CreateUnitaOrganizzativaRequest(
                _model.Nome,
                _model.Codice,
                _model.Principale,
                _model.TipoUnitaOrganizzativa?.Id ?? 0,
                _model.TipoSede?.Id);

            var result = await GatewayClient.CreateUnitaAsync(Id, payload, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                Snackbar.Add("Unita organizzativa creata.", Severity.Success);
                Navigation.NavigateTo($"/organizzazioni/{Id}");
                return;
            }

            _errorMessage = result.Error ?? "Creazione unita organizzativa non riuscita.";
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