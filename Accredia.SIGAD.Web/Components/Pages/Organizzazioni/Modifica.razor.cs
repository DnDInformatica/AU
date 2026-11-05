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

namespace Accredia.SIGAD.Web.Components.Pages.Organizzazioni;

public partial class Modifica : ComponentBase
{
[Parameter] public int Id { get; set; }

    private IReadOnlyList<BreadcrumbItem> _breadcrumbs => new BreadcrumbItem[]
    {
        new("Home", "/"),
        new("Organizzazioni", "/organizzazioni"),
        new($"#{Id}", $"/organizzazioni/{Id}"),
        new("Modifica")
    };

    private sealed class FormModel
    {
        public string Denominazione { get; set; } = string.Empty;
        public string? RagioneSociale { get; set; }
        public string? PartitaIVA { get; set; }
        public string? CodiceFiscale { get; set; }
        public string? NRegistroImprese { get; set; }
        public string? OggettoSociale { get; set; }
        public DateTime? DataIscrizioneIscrizioneRI { get; set; }
        public DateTime? DataCostituzione { get; set; }
        public LookupItem? StatoAttivita { get; set; }
    }

    private OrganizzazioneDetail? _detail;
    private bool _isLoading = true;
    private string? _errorMessage;
    private readonly FormModel _model = new();
    private readonly List<LookupItem> _statiAttivita = new();
    private MudForm? _form;
    private bool _isSubmitting;

    protected override async Task OnParametersSetAsync()
        => await ReloadAsync();

    private async Task ReloadAsync()
    {
        _isLoading = true;
        _errorMessage = null;

        if (_statiAttivita.Count == 0)
        {
            var lookups = await GatewayClient.GetOrganizzazioneStatiAttivitaLookupsAsync(CancellationToken.None);
            if (lookups.IsSuccess && lookups.Data is not null)
            {
                _statiAttivita.Clear();
                _statiAttivita.AddRange(lookups.Data);
            }

            if (_statiAttivita.Count == 0)
            {
                _statiAttivita.AddRange(new[]
                {
                    new LookupItem(1, "Attiva"),
                    new LookupItem(2, "Sospesa"),
                    new LookupItem(3, "Cessata"),
                });
            }
        }

        var result = await GatewayClient.GetOrganizzazioneDetailAsync(Id, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare il dettaglio organizzazione.";
            _detail = null;
            _isLoading = false;
            return;
        }

        _detail = result.Data;
        _model.Denominazione = _detail.Denominazione;
        _model.RagioneSociale = _detail.RagioneSociale;
        _model.PartitaIVA = _detail.PartitaIVA;
        _model.CodiceFiscale = _detail.CodiceFiscale;
        _model.NRegistroImprese = _detail.NRegistroImprese;
        _model.OggettoSociale = _detail.OggettoSociale;
        _model.DataIscrizioneIscrizioneRI = _detail.DataIscrizioneIscrizioneRI;
        _model.DataCostituzione = _detail.DataCostituzione;
        _model.StatoAttivita = _statiAttivita.FirstOrDefault(x => x.Id == _detail.StatoAttivitaId) ?? _statiAttivita.FirstOrDefault();

        _isLoading = false;
    }

    private void Cancel()
        => Navigation.NavigateTo($"/organizzazioni/{Id}");

    private async Task SubmitAsync()
    {
        if (_isSubmitting)
        {
            return;
        }

        _errorMessage = null;
        if (_form is null)
        {
            _errorMessage = "Form non inizializzata.";
            return;
        }

        await _form.Validate();
        if (!_form.IsValid)
        {
            return;
        }

        _isSubmitting = true;
        try
        {
            var payload = new UpdateOrganizzazioneRequest(
                _model.Denominazione,
                _model.RagioneSociale,
                _model.PartitaIVA,
                _model.CodiceFiscale,
                (byte?)_model.StatoAttivita?.Id,
                _model.NRegistroImprese,
                TipoCodiceNaturaGiuridicaId: null,
                _model.OggettoSociale,
                _model.DataIscrizioneIscrizioneRI,
                _model.DataCostituzione);

            var result = await GatewayClient.UpdateOrganizzazioneAsync(Id, payload, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                Snackbar.Add("Organizzazione aggiornata.", Severity.Success);
                Navigation.NavigateTo($"/organizzazioni/{result.Data.OrganizzazioneId}");
                return;
            }

            _errorMessage = result.Error ?? "Aggiornamento non riuscito.";
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
        if (_isSubmitting)
        {
            return;
        }

        var confirm = await DialogService.ShowMessageBox(
            "Conferma eliminazione",
            "Vuoi eliminare (soft delete) questa organizzazione?",
            yesText: "Elimina",
            cancelText: "Annulla");

        if (confirm != true)
        {
            return;
        }

        _isSubmitting = true;
        try
        {
            var result = await GatewayClient.SoftDeleteOrganizzazioneAsync(Id, CancellationToken.None);
            if (result.IsSuccess)
            {
                Snackbar.Add("Organizzazione eliminata (soft).", Severity.Success);
                Navigation.NavigateTo("/organizzazioni");
                return;
            }

            _errorMessage = result.Error ?? "Eliminazione non riuscita.";
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