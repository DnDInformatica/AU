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
using Accredia.SIGAD.Shared.Permessi;

namespace Accredia.SIGAD.Web.Components.Pages.Gdpr;

public partial class RegistroTrattamenti : ComponentBase
{
private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs = new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("GDPR"),
        new BreadcrumbItem("Registro Trattamenti")
    };

    private bool _loading;
    private string? _errorMessage;
    private string? _formMessage;
    private bool _formSuccess;
    private bool _includeDeleted;
    private string? _filterStato;
    private int? _editId;

    private IReadOnlyList<TipoFinalitaRegistroTrattamentiLookupItem> _lookups = Array.Empty<TipoFinalitaRegistroTrattamentiLookupItem>();
    private IReadOnlyList<RegistroTrattamentiItem> _items = Array.Empty<RegistroTrattamentiItem>();
    private RegistroFormModel _form = RegistroFormModel.CreateDefault();
    private bool CanRead => UserContext.HasPermission(PermessiSigad.Persone.Elenco) || UserContext.HasPermission(PermessiSigad.Persone.Lettura);
    private bool CanCreate => UserContext.HasPermission(PermessiSigad.Persone.Creazione);
    private bool CanUpdate => UserContext.HasPermission(PermessiSigad.Persone.Modifica);
    private bool CanDelete => UserContext.HasPermission(PermessiSigad.Persone.Cancellazione);
    private bool CanSave => _editId.HasValue ? CanUpdate : CanCreate;

    private IReadOnlyList<RegistroTrattamentiItem> FilteredItems
        => string.IsNullOrWhiteSpace(_filterStato)
            ? _items.OrderByDescending(x => x.DataInizioTrattamento).ToArray()
            : _items.Where(x => x.Stato.Contains(_filterStato.Trim(), StringComparison.OrdinalIgnoreCase)).OrderByDescending(x => x.DataInizioTrattamento).ToArray();

    protected override async Task OnInitializedAsync() => await LoadAsync();

    private async Task LoadAsync()
    {
        if (!CanRead)
        {
            _errorMessage = "Accesso negato: permesso di lettura mancante.";
            return;
        }

        _loading = true;
        _errorMessage = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var lookupsTask = GatewayClient.GetRegistroTrattamentiLookupsAsync(CancellationToken.None);
            var listTask = GatewayClient.GetRegistroTrattamentiAsync(_includeDeleted, CancellationToken.None);
            await Task.WhenAll(lookupsTask, listTask);
            var lookups = await lookupsTask;
            var list = await listTask;
            if (!lookups.IsSuccess || !list.IsSuccess)
            {
                _errorMessage = lookups.Error ?? list.Error ?? "Impossibile caricare registro trattamenti.";
                return;
            }

            _lookups = lookups.Data ?? Array.Empty<TipoFinalitaRegistroTrattamentiLookupItem>();
            _items = list.Data ?? Array.Empty<RegistroTrattamentiItem>();
            if (_form.TipoFinalitaTrattamentoId == 0 && _lookups.Count > 0) _form.TipoFinalitaTrattamentoId = _lookups[0].Id;
        }
        finally
        {
            _loading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private void BeginCreate()
    {
        if (!CanCreate)
        {
            _formMessage = "Accesso negato: permesso di creazione mancante.";
            _formSuccess = false;
            return;
        }

        _editId = null;
        _formMessage = null;
        _formSuccess = false;
        _form = RegistroFormModel.CreateDefault();
        if (_lookups.Count > 0) _form.TipoFinalitaTrattamentoId = _lookups[0].Id;
    }

    private void BeginEdit(RegistroTrattamentiItem item)
    {
        if (!CanUpdate)
        {
            _formMessage = "Accesso negato: permesso di modifica mancante.";
            _formSuccess = false;
            return;
        }

        _editId = item.RegistroTrattamentiId;
        _formMessage = null;
        _formSuccess = false;
        _form = RegistroFormModel.FromItem(item);
    }

    private async Task LoadByIdAsync(int id)
    {
        if (!CanRead)
        {
            _formMessage = "Accesso negato: permesso di lettura mancante.";
            _formSuccess = false;
            return;
        }

        var result = await GatewayClient.GetRegistroTrattamentiByIdAsync(id, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _formMessage = result.Error ?? "Impossibile caricare dettaglio.";
            _formSuccess = false;
            return;
        }

        _editId = id;
        _form = RegistroFormModel.FromItem(result.Data);
        _formMessage = $"Dettaglio #{id} caricato.";
        _formSuccess = true;
    }

    private async Task SaveAsync()
    {
        if (!CanSave)
        {
            _formMessage = _editId.HasValue
                ? "Accesso negato: permesso di modifica mancante."
                : "Accesso negato: permesso di creazione mancante.";
            _formSuccess = false;
            return;
        }

        if (string.IsNullOrWhiteSpace(_form.Codice) || string.IsNullOrWhiteSpace(_form.NomeTrattamento) || _form.TipoFinalitaTrattamentoId <= 0 || _form.DataInizioTrattamento is null)
        {
            _formMessage = "Compila i campi obbligatori.";
            _formSuccess = false;
            return;
        }

        var result = _editId.HasValue
            ? await GatewayClient.UpdateRegistroTrattamentiAsync(_editId.Value, _form.ToUpdateRequest(), CancellationToken.None)
            : await GatewayClient.CreateRegistroTrattamentiAsync(_form.ToCreateRequest(), CancellationToken.None);

        if (!result.IsSuccess)
        {
            _formMessage = result.Error ?? "Operazione non riuscita.";
            _formSuccess = false;
            return;
        }

        _formMessage = _editId.HasValue ? "Trattamento aggiornato." : "Trattamento creato.";
        _formSuccess = true;
        await LoadAsync();
    }

    private async Task DeleteAsync(int id)
    {
        if (!CanDelete)
        {
            _errorMessage = "Accesso negato: permesso di eliminazione mancante.";
            return;
        }

        var result = await GatewayClient.DeleteRegistroTrattamentiAsync(id, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _errorMessage = result.Error ?? "Eliminazione non riuscita.";
            return;
        }

        if (_editId == id) BeginCreate();
        await LoadAsync();
    }

    private string GetFinalitaLabel(int id)
        => _lookups.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();

    private sealed class RegistroFormModel
    {
        public string Codice { get; set; } = string.Empty;
        public string NomeTrattamento { get; set; } = string.Empty;
        public string? Descrizione { get; set; }
        public int TipoFinalitaTrattamentoId { get; set; }
        public string BaseGiuridica { get; set; } = "Consenso";
        public string CategorieDati { get; set; } = "Dati identificativi";
        public string CategorieInteressati { get; set; } = "Clienti";
        public bool DatiParticolari { get; set; }
        public bool DatiGiudiziari { get; set; }
        public string? CategorieDestinatari { get; set; }
        public bool TrasferimentoExtraUE { get; set; }
        public string? PaesiExtraUE { get; set; }
        public string? GaranzieExtraUE { get; set; }
        public string TermineConservazione { get; set; } = "10 anni";
        public int? TermineConservazioneGiorni { get; set; }
        public string? MisureSicurezza { get; set; } = "Misure standard";
        public int? ResponsabileTrattamentoId { get; set; }
        public int? ContitolareId { get; set; }
        public bool DPONotificato { get; set; }
        public string Stato { get; set; } = "Attivo";
        public DateTime? DataInizioTrattamento { get; set; } = DateTime.Today;
        public DateTime? DataFineTrattamento { get; set; }

        public static RegistroFormModel CreateDefault() => new();

        public static RegistroFormModel FromItem(RegistroTrattamentiItem item)
            => new()
            {
                Codice = item.Codice,
                NomeTrattamento = item.NomeTrattamento,
                Descrizione = item.Descrizione,
                TipoFinalitaTrattamentoId = item.TipoFinalitaTrattamentoId,
                BaseGiuridica = item.BaseGiuridica,
                CategorieDati = item.CategorieDati,
                CategorieInteressati = item.CategorieInteressati,
                DatiParticolari = item.DatiParticolari,
                DatiGiudiziari = item.DatiGiudiziari,
                CategorieDestinatari = item.CategorieDestinatari,
                TrasferimentoExtraUE = item.TrasferimentoExtraUE,
                PaesiExtraUE = item.PaesiExtraUE,
                GaranzieExtraUE = item.GaranzieExtraUE,
                TermineConservazione = item.TermineConservazione,
                TermineConservazioneGiorni = item.TermineConservazioneGiorni,
                MisureSicurezza = item.MisureSicurezza,
                ResponsabileTrattamentoId = item.ResponsabileTrattamentoId,
                ContitolareId = item.ContitolareId,
                DPONotificato = item.DPONotificato,
                Stato = item.Stato,
                DataInizioTrattamento = item.DataInizioTrattamento,
                DataFineTrattamento = item.DataFineTrattamento
            };

        public CreateRegistroTrattamentiRequest ToCreateRequest()
            => new(
                Codice.Trim(),
                NomeTrattamento.Trim(),
                NullIfWhiteSpace(Descrizione),
                TipoFinalitaTrattamentoId,
                BaseGiuridica.Trim(),
                CategorieDati.Trim(),
                CategorieInteressati.Trim(),
                DatiParticolari,
                DatiGiudiziari,
                NullIfWhiteSpace(CategorieDestinatari),
                TrasferimentoExtraUE,
                NullIfWhiteSpace(PaesiExtraUE),
                NullIfWhiteSpace(GaranzieExtraUE),
                TermineConservazione.Trim(),
                TermineConservazioneGiorni,
                NullIfWhiteSpace(MisureSicurezza),
                ResponsabileTrattamentoId,
                ContitolareId,
                DPONotificato,
                Stato.Trim(),
                DataInizioTrattamento!.Value,
                DataFineTrattamento);

        public UpdateRegistroTrattamentiRequest ToUpdateRequest()
            => new(
                Codice.Trim(),
                NomeTrattamento.Trim(),
                NullIfWhiteSpace(Descrizione),
                TipoFinalitaTrattamentoId,
                BaseGiuridica.Trim(),
                CategorieDati.Trim(),
                CategorieInteressati.Trim(),
                DatiParticolari,
                DatiGiudiziari,
                NullIfWhiteSpace(CategorieDestinatari),
                TrasferimentoExtraUE,
                NullIfWhiteSpace(PaesiExtraUE),
                NullIfWhiteSpace(GaranzieExtraUE),
                TermineConservazione.Trim(),
                TermineConservazioneGiorni,
                NullIfWhiteSpace(MisureSicurezza),
                ResponsabileTrattamentoId,
                ContitolareId,
                DPONotificato,
                Stato.Trim(),
                DataInizioTrattamento!.Value,
                DataFineTrattamento);

        private static string? NullIfWhiteSpace(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }
}