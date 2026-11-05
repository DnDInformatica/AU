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

public partial class RichiesteEsercizioDiritti : ComponentBase
{
private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs = new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("GDPR"),
        new BreadcrumbItem("Esercizio Diritti")
    };

    [SupplyParameterFromQuery(Name = "personaId")]
    public int? PersonaIdQuery { get; set; }

    private bool _initialized;
    private bool _loading;
    private string? _errorMessage;
    private string? _formMessage;
    private bool _formSuccess;
    private int? _editId;
    private bool _includeDeleted;
    private int? _filterPersonaId;
    private int? _filterTipoId;
    private string? _filterStato;

    private IReadOnlyList<TipoDirittoInteressatoLookupItem> _lookups = Array.Empty<TipoDirittoInteressatoLookupItem>();
    private IReadOnlyList<RichiestaEsercizioDirittiItem> _items = Array.Empty<RichiestaEsercizioDirittiItem>();
    private RichiestaDirittiFormModel _form = RichiestaDirittiFormModel.CreateDefault();
    private bool CanRead => UserContext.HasPermission("SIDAC.PERS.LIST") || UserContext.HasPermission("SIDAC.PERS.READ");
    private bool CanCreate => UserContext.HasPermission("SIDAC.PERS.CREATE");
    private bool CanUpdate => UserContext.HasPermission("SIDAC.PERS.UPDATE");
    private bool CanDelete => UserContext.HasPermission("SIDAC.PERS.DELETE");
    private bool CanSave => _editId.HasValue ? CanUpdate : CanCreate;

    private IReadOnlyList<RichiestaEsercizioDirittiItem> FilteredItems
    {
        get
        {
            IEnumerable<RichiestaEsercizioDirittiItem> query = _items;
            if (_filterTipoId.HasValue) query = query.Where(x => x.TipoDirittoGdprId == _filterTipoId.Value);
            if (!string.IsNullOrWhiteSpace(_filterStato)) query = query.Where(x => x.Stato.Contains(_filterStato.Trim(), StringComparison.OrdinalIgnoreCase));
            return query.OrderByDescending(x => x.DataRichiesta).ToArray();
        }
    }

    protected override async Task OnParametersSetAsync()
    {
        if (!_initialized)
        {
            _initialized = true;
            _filterPersonaId = PersonaIdQuery;
            _form.PersonaId = PersonaIdQuery;
            await LoadAsync();
            return;
        }

        if (_filterPersonaId != PersonaIdQuery)
        {
            _filterPersonaId = PersonaIdQuery;
            _form.PersonaId = PersonaIdQuery;
            await LoadAsync();
        }
    }

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
            var lookupsTask = GatewayClient.GetRichiesteEsercizioDirittiLookupsAsync(CancellationToken.None);
            var listTask = GatewayClient.GetRichiesteEsercizioDirittiAsync(_filterPersonaId, _includeDeleted, CancellationToken.None);
            await Task.WhenAll(lookupsTask, listTask);
            var lookups = await lookupsTask;
            var list = await listTask;
            if (!lookups.IsSuccess || !list.IsSuccess)
            {
                _errorMessage = lookups.Error ?? list.Error ?? "Impossibile caricare richieste esercizio diritti.";
                return;
            }

            _lookups = lookups.Data ?? Array.Empty<TipoDirittoInteressatoLookupItem>();
            _items = list.Data ?? Array.Empty<RichiestaEsercizioDirittiItem>();
            if (_form.TipoDirittoGdprId == 0 && _lookups.Count > 0) _form.TipoDirittoGdprId = _lookups[0].Id;
        }
        finally
        {
            _loading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private async Task ResetFiltersAsync()
    {
        _filterPersonaId = PersonaIdQuery;
        _filterTipoId = null;
        _filterStato = null;
        await LoadAsync();
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
        _form = RichiestaDirittiFormModel.CreateDefault();
        _form.PersonaId = _filterPersonaId ?? PersonaIdQuery;
        if (_lookups.Count > 0) _form.TipoDirittoGdprId = _lookups[0].Id;
    }

    private void BeginEdit(RichiestaEsercizioDirittiItem item)
    {
        if (!CanUpdate)
        {
            _formMessage = "Accesso negato: permesso di modifica mancante.";
            _formSuccess = false;
            return;
        }

        _editId = item.RichiestaEsercizioDirittiId;
        _formMessage = null;
        _formSuccess = false;
        _form = RichiestaDirittiFormModel.FromItem(item);
    }

    private async Task LoadByIdAsync(int id)
    {
        if (!CanRead)
        {
            _formMessage = "Accesso negato: permesso di lettura mancante.";
            _formSuccess = false;
            return;
        }

        var result = await GatewayClient.GetRichiestaEsercizioDirittiByIdAsync(id, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _formMessage = result.Error ?? "Impossibile caricare dettaglio.";
            _formSuccess = false;
            return;
        }

        _editId = id;
        _form = RichiestaDirittiFormModel.FromItem(result.Data);
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

        if (string.IsNullOrWhiteSpace(_form.Codice) || string.IsNullOrWhiteSpace(_form.NomeRichiedente) || string.IsNullOrWhiteSpace(_form.EmailRichiedente) || _form.TipoDirittoGdprId <= 0 || _form.DataRichiesta is null || _form.DataScadenza is null)
        {
            _formMessage = "Compila i campi obbligatori.";
            _formSuccess = false;
            return;
        }

        var result = _editId.HasValue
            ? await GatewayClient.UpdateRichiestaEsercizioDirittiAsync(_editId.Value, _form.ToUpdateRequest(), CancellationToken.None)
            : await GatewayClient.CreateRichiestaEsercizioDirittiAsync(_form.ToCreateRequest(), CancellationToken.None);

        if (!result.IsSuccess)
        {
            _formMessage = result.Error ?? "Operazione non riuscita.";
            _formSuccess = false;
            return;
        }

        _formMessage = _editId.HasValue ? "Richiesta aggiornata." : "Richiesta creata.";
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

        var result = await GatewayClient.DeleteRichiestaEsercizioDirittiAsync(id, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _errorMessage = result.Error ?? "Eliminazione non riuscita.";
            return;
        }

        if (_editId == id) BeginCreate();
        await LoadAsync();
    }

    private string GetTipoLabel(int id) => _lookups.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();

    private sealed class RichiestaDirittiFormModel
    {
        public int? PersonaId { get; set; }
        public string NomeRichiedente { get; set; } = string.Empty;
        public string EmailRichiedente { get; set; } = string.Empty;
        public string? TelefonoRichiedente { get; set; }
        public string Codice { get; set; } = string.Empty;
        public int TipoDirittoGdprId { get; set; }
        public DateTime? DataRichiesta { get; set; } = DateTime.Today;
        public string ModalitaRichiesta { get; set; } = "Portale";
        public string? TestoRichiesta { get; set; }
        public string? DocumentoRichiesta { get; set; }
        public bool IdentitaVerificata { get; set; } = true;
        public DateTime? DataVerificaIdentita { get; set; } = DateTime.Today;
        public string? ModalitaVerifica { get; set; } = "Documento";
        public DateTime? DataScadenza { get; set; } = DateTime.Today.AddDays(30);
        public DateTime? DataProrogaRichiesta { get; set; }
        public string? MotivoProrogaRichiesta { get; set; }
        public string Stato { get; set; } = "Aperta";
        public int? ResponsabileGestioneId { get; set; }
        public string? Note { get; set; }
        public DateTime? DataRisposta { get; set; }
        public string? EsitoRisposta { get; set; }
        public string? MotivoRifiuto { get; set; }
        public string? TestoRisposta { get; set; }
        public string? DocumentoRisposta { get; set; }
        public DateTime? DataEsecuzione { get; set; }
        public string? DatiCancellati { get; set; }

        public static RichiestaDirittiFormModel CreateDefault() => new();

        public static RichiestaDirittiFormModel FromItem(RichiestaEsercizioDirittiItem item)
            => new()
            {
                PersonaId = item.PersonaId,
                NomeRichiedente = item.NomeRichiedente,
                EmailRichiedente = item.EmailRichiedente,
                TelefonoRichiedente = item.TelefonoRichiedente,
                Codice = item.Codice,
                TipoDirittoGdprId = item.TipoDirittoGdprId,
                DataRichiesta = item.DataRichiesta,
                ModalitaRichiesta = item.ModalitaRichiesta,
                TestoRichiesta = item.TestoRichiesta,
                DocumentoRichiesta = item.DocumentoRichiesta,
                IdentitaVerificata = item.IdentitaVerificata,
                DataVerificaIdentita = item.DataVerificaIdentita,
                ModalitaVerifica = item.ModalitaVerifica,
                DataScadenza = item.DataScadenza,
                DataProrogaRichiesta = item.DataProrogaRichiesta,
                MotivoProrogaRichiesta = item.MotivoProrogaRichiesta,
                Stato = item.Stato,
                ResponsabileGestioneId = item.ResponsabileGestioneId,
                Note = item.Note,
                DataRisposta = item.DataRisposta,
                EsitoRisposta = item.EsitoRisposta,
                MotivoRifiuto = item.MotivoRifiuto,
                TestoRisposta = item.TestoRisposta,
                DocumentoRisposta = item.DocumentoRisposta,
                DataEsecuzione = item.DataEsecuzione,
                DatiCancellati = item.DatiCancellati
            };

        public CreateRichiestaEsercizioDirittiRequest ToCreateRequest()
            => new(
                PersonaId,
                NomeRichiedente.Trim(),
                EmailRichiedente.Trim(),
                NullIfWhiteSpace(TelefonoRichiedente),
                Codice.Trim(),
                TipoDirittoGdprId,
                DataRichiesta!.Value,
                ModalitaRichiesta.Trim(),
                NullIfWhiteSpace(TestoRichiesta),
                NullIfWhiteSpace(DocumentoRichiesta),
                IdentitaVerificata,
                DataVerificaIdentita,
                NullIfWhiteSpace(ModalitaVerifica),
                DataScadenza!.Value,
                DataProrogaRichiesta,
                NullIfWhiteSpace(MotivoProrogaRichiesta),
                Stato.Trim(),
                ResponsabileGestioneId,
                NullIfWhiteSpace(Note),
                DataRisposta,
                NullIfWhiteSpace(EsitoRisposta),
                NullIfWhiteSpace(MotivoRifiuto),
                NullIfWhiteSpace(TestoRisposta),
                NullIfWhiteSpace(DocumentoRisposta),
                DataEsecuzione,
                NullIfWhiteSpace(DatiCancellati));

        public UpdateRichiestaEsercizioDirittiRequest ToUpdateRequest()
            => new(
                PersonaId,
                NomeRichiedente.Trim(),
                EmailRichiedente.Trim(),
                NullIfWhiteSpace(TelefonoRichiedente),
                Codice.Trim(),
                TipoDirittoGdprId,
                DataRichiesta!.Value,
                ModalitaRichiesta.Trim(),
                NullIfWhiteSpace(TestoRichiesta),
                NullIfWhiteSpace(DocumentoRichiesta),
                IdentitaVerificata,
                DataVerificaIdentita,
                NullIfWhiteSpace(ModalitaVerifica),
                DataScadenza!.Value,
                DataProrogaRichiesta,
                NullIfWhiteSpace(MotivoProrogaRichiesta),
                Stato.Trim(),
                ResponsabileGestioneId,
                NullIfWhiteSpace(Note),
                DataRisposta,
                NullIfWhiteSpace(EsitoRisposta),
                NullIfWhiteSpace(MotivoRifiuto),
                NullIfWhiteSpace(TestoRisposta),
                NullIfWhiteSpace(DocumentoRisposta),
                DataEsecuzione,
                NullIfWhiteSpace(DatiCancellati));

        private static string? NullIfWhiteSpace(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }
}