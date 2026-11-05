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

namespace Accredia.SIGAD.Web.Components.Pages.Gdpr;

public partial class DataBreach : ComponentBase
{
private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs = new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("GDPR"),
        new BreadcrumbItem("Data Breach")
    };

    private bool _loading;
    private string? _errorMessage;
    private string? _formMessage;
    private bool _formSuccess;
    private bool _includeDeleted;
    private string? _filterStato;
    private string? _filterTipo;
    private int? _editId;

    private IReadOnlyList<DataBreachItem> _items = Array.Empty<DataBreachItem>();
    private DataBreachFormModel _form = DataBreachFormModel.CreateDefault();
    private bool CanRead => UserContext.HasPermission("PERS.LIST") || UserContext.HasPermission("PERS.READ");
    private bool CanCreate => UserContext.HasPermission("PERS.CREATE");
    private bool CanUpdate => UserContext.HasPermission("PERS.UPDATE");
    private bool CanDelete => UserContext.HasPermission("PERS.DELETE");
    private bool CanSave => _editId.HasValue ? CanUpdate : CanCreate;

    private IReadOnlyList<DataBreachItem> FilteredItems
    {
        get
        {
            IEnumerable<DataBreachItem> query = _items;
            if (!string.IsNullOrWhiteSpace(_filterStato)) query = query.Where(x => x.Stato.Contains(_filterStato.Trim(), StringComparison.OrdinalIgnoreCase));
            if (!string.IsNullOrWhiteSpace(_filterTipo)) query = query.Where(x => x.TipoViolazione.Contains(_filterTipo.Trim(), StringComparison.OrdinalIgnoreCase));
            return query.OrderByDescending(x => x.DataScoperta).ToArray();
        }
    }

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
            var result = await GatewayClient.GetDataBreachAsync(_includeDeleted, CancellationToken.None);
            if (!result.IsSuccess)
            {
                _errorMessage = result.Error ?? "Impossibile caricare data breach.";
                return;
            }

            _items = result.Data ?? Array.Empty<DataBreachItem>();
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
        _form = DataBreachFormModel.CreateDefault();
    }

    private void BeginEdit(DataBreachItem item)
    {
        if (!CanUpdate)
        {
            _formMessage = "Accesso negato: permesso di modifica mancante.";
            _formSuccess = false;
            return;
        }

        _editId = item.DataBreachId;
        _formMessage = null;
        _formSuccess = false;
        _form = DataBreachFormModel.FromItem(item);
    }

    private async Task LoadByIdAsync(int id)
    {
        if (!CanRead)
        {
            _formMessage = "Accesso negato: permesso di lettura mancante.";
            _formSuccess = false;
            return;
        }

        var result = await GatewayClient.GetDataBreachByIdAsync(id, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _formMessage = result.Error ?? "Impossibile caricare dettaglio.";
            _formSuccess = false;
            return;
        }

        _editId = id;
        _form = DataBreachFormModel.FromItem(result.Data);
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

        if (string.IsNullOrWhiteSpace(_form.Codice) || string.IsNullOrWhiteSpace(_form.Titolo) || string.IsNullOrWhiteSpace(_form.Descrizione) || _form.DataScoperta is null)
        {
            _formMessage = "Compila i campi obbligatori.";
            _formSuccess = false;
            return;
        }

        var result = _editId.HasValue
            ? await GatewayClient.UpdateDataBreachAsync(_editId.Value, _form.ToUpdateRequest(), CancellationToken.None)
            : await GatewayClient.CreateDataBreachAsync(_form.ToCreateRequest(), CancellationToken.None);

        if (!result.IsSuccess)
        {
            _formMessage = result.Error ?? "Operazione non riuscita.";
            _formSuccess = false;
            return;
        }

        _formMessage = _editId.HasValue ? "Data breach aggiornato." : "Data breach creato.";
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

        var result = await GatewayClient.DeleteDataBreachAsync(id, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _errorMessage = result.Error ?? "Eliminazione non riuscita.";
            return;
        }

        if (_editId == id) BeginCreate();
        await LoadAsync();
    }

    private sealed class DataBreachFormModel
    {
        public string Codice { get; set; } = string.Empty;
        public string Titolo { get; set; } = string.Empty;
        public string Descrizione { get; set; } = string.Empty;
        public DateTime? DataScoperta { get; set; } = DateTime.Today;
        public DateTime? DataInizioViolazione { get; set; }
        public DateTime? DataFineViolazione { get; set; }
        public string TipoViolazione { get; set; } = "Accesso non autorizzato";
        public string CausaViolazione { get; set; } = "Errore umano";
        public string CategorieDatiCoinvolti { get; set; } = "Dati identificativi";
        public bool DatiParticolariCoinvolti { get; set; }
        public int? NumeroInteressatiStimato { get; set; }
        public string CategorieInteressati { get; set; } = "Clienti";
        public string RischioPerInteressati { get; set; } = "Medio";
        public string? DescrizioneRischio { get; set; }
        public bool NotificaGaranteRichiesta { get; set; }
        public DateTime? DataNotificaGarante { get; set; }
        public string? ProtocolloGarante { get; set; }
        public DateTime? TermineNotificaGarante { get; set; }
        public bool ComunicazioneInteressatiRichiesta { get; set; }
        public DateTime? DataComunicazioneInteressati { get; set; }
        public string? ModalitaComunicazione { get; set; }
        public string? MisureContenimento { get; set; } = "Contenimento standard";
        public string? MisurePrevenzione { get; set; } = "Prevenzione standard";
        public int? ResponsabileGestioneId { get; set; }
        public bool DPOCoinvolto { get; set; }
        public string Stato { get; set; } = "Aperto";
        public DateTime? DataChiusura { get; set; }

        public static DataBreachFormModel CreateDefault() => new();

        public static DataBreachFormModel FromItem(DataBreachItem item)
            => new()
            {
                Codice = item.Codice,
                Titolo = item.Titolo,
                Descrizione = item.Descrizione,
                DataScoperta = item.DataScoperta,
                DataInizioViolazione = item.DataInizioViolazione,
                DataFineViolazione = item.DataFineViolazione,
                TipoViolazione = item.TipoViolazione,
                CausaViolazione = item.CausaViolazione,
                CategorieDatiCoinvolti = item.CategorieDatiCoinvolti,
                DatiParticolariCoinvolti = item.DatiParticolariCoinvolti,
                NumeroInteressatiStimato = item.NumeroInteressatiStimato,
                CategorieInteressati = item.CategorieInteressati,
                RischioPerInteressati = item.RischioPerInteressati,
                DescrizioneRischio = item.DescrizioneRischio,
                NotificaGaranteRichiesta = item.NotificaGaranteRichiesta,
                DataNotificaGarante = item.DataNotificaGarante,
                ProtocolloGarante = item.ProtocolloGarante,
                TermineNotificaGarante = item.TermineNotificaGarante,
                ComunicazioneInteressatiRichiesta = item.ComunicazioneInteressatiRichiesta,
                DataComunicazioneInteressati = item.DataComunicazioneInteressati,
                ModalitaComunicazione = item.ModalitaComunicazione,
                MisureContenimento = item.MisureContenimento,
                MisurePrevenzione = item.MisurePrevenzione,
                ResponsabileGestioneId = item.ResponsabileGestioneId,
                DPOCoinvolto = item.DPOCoinvolto,
                Stato = item.Stato,
                DataChiusura = item.DataChiusura
            };

        public CreateDataBreachRequest ToCreateRequest()
            => new(
                Codice.Trim(),
                Titolo.Trim(),
                Descrizione.Trim(),
                DataScoperta!.Value,
                DataInizioViolazione,
                DataFineViolazione,
                TipoViolazione.Trim(),
                CausaViolazione.Trim(),
                CategorieDatiCoinvolti.Trim(),
                DatiParticolariCoinvolti,
                NumeroInteressatiStimato,
                CategorieInteressati.Trim(),
                RischioPerInteressati.Trim(),
                NullIfWhiteSpace(DescrizioneRischio),
                NotificaGaranteRichiesta,
                DataNotificaGarante,
                NullIfWhiteSpace(ProtocolloGarante),
                TermineNotificaGarante,
                ComunicazioneInteressatiRichiesta,
                DataComunicazioneInteressati,
                NullIfWhiteSpace(ModalitaComunicazione),
                NullIfWhiteSpace(MisureContenimento),
                NullIfWhiteSpace(MisurePrevenzione),
                ResponsabileGestioneId,
                DPOCoinvolto,
                Stato.Trim(),
                DataChiusura);

        public UpdateDataBreachRequest ToUpdateRequest()
            => new(
                Codice.Trim(),
                Titolo.Trim(),
                Descrizione.Trim(),
                DataScoperta!.Value,
                DataInizioViolazione,
                DataFineViolazione,
                TipoViolazione.Trim(),
                CausaViolazione.Trim(),
                CategorieDatiCoinvolti.Trim(),
                DatiParticolariCoinvolti,
                NumeroInteressatiStimato,
                CategorieInteressati.Trim(),
                RischioPerInteressati.Trim(),
                NullIfWhiteSpace(DescrizioneRischio),
                NotificaGaranteRichiesta,
                DataNotificaGarante,
                NullIfWhiteSpace(ProtocolloGarante),
                TermineNotificaGarante,
                ComunicazioneInteressatiRichiesta,
                DataComunicazioneInteressati,
                NullIfWhiteSpace(ModalitaComunicazione),
                NullIfWhiteSpace(MisureContenimento),
                NullIfWhiteSpace(MisurePrevenzione),
                ResponsabileGestioneId,
                DPOCoinvolto,
                Stato.Trim(),
                DataChiusura);

        private static string? NullIfWhiteSpace(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }
}