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

public partial class Nuova : ComponentBase
{
private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs = new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("Organizzazioni", "/organizzazioni"),
        new BreadcrumbItem("Nuova")
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

    private readonly FormModel _model = new();
    private readonly List<LookupItem> _statiAttivita = new();
    private MudForm? _form;
    private bool _isSubmitting;
    private string? _errorMessage;

    protected override async Task OnInitializedAsync()
    {
        var result = await GatewayClient.GetOrganizzazioneStatiAttivitaLookupsAsync(CancellationToken.None);
        if (result.IsSuccess && result.Data is not null)
        {
            _statiAttivita.Clear();
            _statiAttivita.AddRange(result.Data);
        }

        // Best-effort fallback. If DB has an FK, lookups must exist to avoid runtime SQL errors.
        if (_statiAttivita.Count == 0)
        {
            _statiAttivita.AddRange(new[]
            {
                new LookupItem(1, "Attiva"),
                new LookupItem(2, "Sospesa"),
                new LookupItem(3, "Cessata"),
            });
        }

        _model.StatoAttivita = _statiAttivita[0];
    }

    private void Cancel()
        => Navigation.NavigateTo("/organizzazioni");

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
            var payload = new CreateOrganizzazioneRequest(
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

            var result = await GatewayClient.CreateOrganizzazioneAsync(payload, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                Snackbar.Add("Organizzazione creata.", Severity.Success);
                Navigation.NavigateTo($"/organizzazioni/{result.Data.OrganizzazioneId}");
                return;
            }

            _errorMessage = result.Error ?? "Creazione organizzazione non riuscita.";
        }
        catch (Exception ex)
        {
            _errorMessage = ex.Message;
        }
        finally
        {
            _isSubmitting = false;
        }
    }
}