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

namespace Accredia.SIGAD.Web.Components.Pages.Organizzazioni.Sedi;

public partial class Nuova : ComponentBase
{
[Parameter] public int Id { get; set; }

    private IReadOnlyList<BreadcrumbItem> _breadcrumbs => new BreadcrumbItem[]
    {
        new("Home", "/"),
        new("Organizzazioni", "/organizzazioni"),
        new($"#{Id}", $"/organizzazioni/{Id}"),
        new("Sedi"),
        new("Nuova")
    };

    private sealed class FormModel
    {
        public string? Denominazione { get; set; }
        public string? Indirizzo { get; set; }
        public string? NumeroCivico { get; set; }
        public string? CAP { get; set; }
        public string? Localita { get; set; }
        public string? Provincia { get; set; }
        public string? Nazione { get; set; }
        public string? StatoSede { get; set; }
        public bool IsSedePrincipale { get; set; }
        public bool IsSedeOperativa { get; set; }
        public DateTime? DataApertura { get; set; }
        public DateTime? DataCessazione { get; set; }
        public LookupItem? TipoSede { get; set; }
    }

    private readonly FormModel _model = new();
    private MudForm? _form;
    private bool _isSubmitting;
    private string? _errorMessage;
    private bool _lookupsLoading = true;
    private string? _lookupsError;
    private IReadOnlyList<LookupItem> _tipiSede = Array.Empty<LookupItem>();

    protected override async Task OnInitializedAsync()
        => await LoadLookupsAsync();

    private void Cancel()
        => Navigation.NavigateTo($"/organizzazioni/{Id}");

    private Task OnAperturaChanged(DateTime? d) { _model.DataApertura = d; return Task.CompletedTask; }
    private Task OnCessazioneChanged(DateTime? d) { _model.DataCessazione = d; return Task.CompletedTask; }

    private async Task LoadLookupsAsync()
    {
        _lookupsLoading = true;
        _lookupsError = null;

        try
        {
            var result = await GatewayClient.GetSediLookupsAsync(CancellationToken.None);
            if (!result.IsSuccess || result.Data is null)
            {
                _lookupsError = result.Error ?? "Impossibile caricare le tipologiche per le sedi.";
                _tipiSede = Array.Empty<LookupItem>();
                return;
            }

            _tipiSede = result.Data;
        }
        catch (Exception ex)
        {
            _lookupsError = MessaggioErroreApi.Da(ex);
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

        _isSubmitting = true;
        try
        {
            var payload = new CreateSedeRequest(
                _model.Denominazione,
                _model.Indirizzo,
                _model.NumeroCivico,
                _model.CAP,
                _model.Localita,
                _model.Provincia,
                _model.Nazione,
                _model.StatoSede,
                _model.IsSedePrincipale,
                _model.IsSedeOperativa,
                _model.DataApertura,
                _model.DataCessazione,
                _model.TipoSede?.Id);

            var result = await GatewayClient.CreateSedeAsync(Id, payload, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                Snackbar.Add("Sede creata.", Severity.Success);
                Navigation.NavigateTo($"/organizzazioni/{Id}");
                return;
            }

            _errorMessage = result.Error ?? "Creazione sede non riuscita.";
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