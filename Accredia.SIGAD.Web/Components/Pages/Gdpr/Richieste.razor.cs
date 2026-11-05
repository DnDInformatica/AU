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

public partial class Richieste : ComponentBase
{
private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs = new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("GDPR"),
        new BreadcrumbItem("Richieste")
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
    private int? _filterTipoDirittoId;
    private string? _filterStato;
    private DateTime? _filterFrom;
    private DateTime? _filterTo;

    private IReadOnlyList<TipoDirittoInteressatoLookupItem> _lookups = Array.Empty<TipoDirittoInteressatoLookupItem>();
    private IReadOnlyList<RichiestaGdprItem> _items = Array.Empty<RichiestaGdprItem>();
    private RichiestaGdprFormModel _form = RichiestaGdprFormModel.CreateDefault();
    private bool CanRead => UserContext.HasPermission("SIDAC.PERS.LIST") || UserContext.HasPermission("SIDAC.PERS.READ");
    private bool CanCreate => UserContext.HasPermission("SIDAC.PERS.CREATE");
    private bool CanUpdate => UserContext.HasPermission("SIDAC.PERS.UPDATE");
    private bool CanDelete => UserContext.HasPermission("SIDAC.PERS.DELETE");
    private bool CanSave => _editId.HasValue ? CanUpdate : CanCreate;

    private IReadOnlyList<RichiestaGdprItem> FilteredItems
    {
        get
        {
            IEnumerable<RichiestaGdprItem> query = _items;

            if (_filterTipoDirittoId.HasValue)
            {
                query = query.Where(x => x.TipoDirittoInteressatoId == _filterTipoDirittoId.Value);
            }

            if (!string.IsNullOrWhiteSpace(_filterStato))
            {
                var stato = _filterStato.Trim();
                query = query.Where(x => x.Stato.Contains(stato, StringComparison.OrdinalIgnoreCase));
            }

            if (_filterFrom.HasValue)
            {
                query = query.Where(x => x.DataRichiesta.Date >= _filterFrom.Value.Date);
            }

            if (_filterTo.HasValue)
            {
                query = query.Where(x => x.DataRichiesta.Date <= _filterTo.Value.Date);
            }

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
            var lookupsTask = GatewayClient.GetRichiesteGdprLookupsAsync(CancellationToken.None);
            var listTask = GatewayClient.GetRichiesteGdprAsync(_filterPersonaId, _includeDeleted, CancellationToken.None);
            await Task.WhenAll(lookupsTask, listTask);

            var lookups = await lookupsTask;
            var list = await listTask;
            if (!lookups.IsSuccess || !list.IsSuccess)
            {
                _errorMessage = lookups.Error ?? list.Error ?? "Impossibile caricare richieste GDPR.";
                return;
            }

            _lookups = lookups.Data ?? Array.Empty<TipoDirittoInteressatoLookupItem>();
            _items = list.Data ?? Array.Empty<RichiestaGdprItem>();
            if (_form.TipoDirittoInteressatoId == 0 && _lookups.Count > 0)
            {
                _form.TipoDirittoInteressatoId = _lookups[0].Id;
            }
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
        _filterTipoDirittoId = null;
        _filterStato = null;
        _filterFrom = null;
        _filterTo = null;
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
        _form = RichiestaGdprFormModel.CreateDefault();
        _form.PersonaId = _filterPersonaId ?? PersonaIdQuery;
        if (_lookups.Count > 0)
        {
            _form.TipoDirittoInteressatoId = _lookups[0].Id;
        }
    }

    private void BeginEdit(RichiestaGdprItem item)
    {
        if (!CanUpdate)
        {
            _formMessage = "Accesso negato: permesso di modifica mancante.";
            _formSuccess = false;
            return;
        }

        _editId = item.RichiestaGdprId;
        _formMessage = null;
        _formSuccess = false;
        _form = RichiestaGdprFormModel.FromItem(item);
    }

    private async Task LoadByIdAsync(int id)
    {
        if (!CanRead)
        {
            _formMessage = "Accesso negato: permesso di lettura mancante.";
            _formSuccess = false;
            return;
        }

        var result = await GatewayClient.GetRichiestaGdprByIdAsync(id, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _formMessage = result.Error ?? "Impossibile caricare il dettaglio richiesta.";
            _formSuccess = false;
            return;
        }

        _editId = id;
        _form = RichiestaGdprFormModel.FromItem(result.Data);
        _formMessage = $"Dettaglio richiesta #{id} caricato.";
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

        _formMessage = null;
        _formSuccess = false;

        var validationError = ValidateForm();
        if (validationError is not null)
        {
            _formMessage = validationError;
            return;
        }

        var createRequest = _form.ToCreateRequest();
        var result = _editId.HasValue
            ? await GatewayClient.UpdateRichiestaGdprAsync(_editId.Value, _form.ToUpdateRequest(), CancellationToken.None)
            : await GatewayClient.CreateRichiestaGdprAsync(createRequest, CancellationToken.None);

        if (!result.IsSuccess)
        {
            _formMessage = result.Error ?? "Operazione non riuscita.";
            return;
        }

        _formMessage = _editId.HasValue ? "Richiesta aggiornata." : "Richiesta creata.";
        _formSuccess = true;
        await LoadAsync();
        if (!_editId.HasValue)
        {
            BeginCreate();
        }
    }

    private async Task DeleteAsync(int id)
    {
        if (!CanDelete)
        {
            _errorMessage = "Accesso negato: permesso di eliminazione mancante.";
            return;
        }

        var result = await GatewayClient.DeleteRichiestaGdprAsync(id, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _errorMessage = result.Error ?? "Eliminazione non riuscita.";
            return;
        }

        if (_editId == id)
        {
            BeginCreate();
        }

        await LoadAsync();
    }

    private string GetTipoDirittoLabel(int id)
        => _lookups.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();

    private string? ValidateForm()
    {
        if (string.IsNullOrWhiteSpace(_form.Codice)) return "Il codice e obbligatorio.";
        if (string.IsNullOrWhiteSpace(_form.NomeRichiedente)) return "Il nome e obbligatorio.";
        if (string.IsNullOrWhiteSpace(_form.CognomeRichiedente)) return "Il cognome e obbligatorio.";
        if (_form.TipoDirittoInteressatoId <= 0) return "Il tipo diritto e obbligatorio.";
        if (_form.DataRichiesta is null) return "La data richiesta e obbligatoria.";
        if (_form.DataScadenzaRisposta is null) return "La scadenza risposta e obbligatoria.";
        if (string.IsNullOrWhiteSpace(_form.CanaleRichiesta)) return "Il canale richiesta e obbligatorio.";
        if (string.IsNullOrWhiteSpace(_form.Stato)) return "Lo stato e obbligatorio.";
        return null;
    }

    private sealed class RichiestaGdprFormModel
    {
        public int? PersonaId { get; set; }
        public string NomeRichiedente { get; set; } = string.Empty;
        public string CognomeRichiedente { get; set; } = string.Empty;
        public string? EmailRichiedente { get; set; }
        public string? TelefonoRichiedente { get; set; }
        public int TipoDirittoInteressatoId { get; set; }
        public string Codice { get; set; } = string.Empty;
        public DateTime? DataRichiesta { get; set; }
        public string CanaleRichiesta { get; set; } = "Portale";
        public string? DescrizioneRichiesta { get; set; }
        public string? DocumentoIdentita { get; set; }
        public DateTime? DataScadenzaRisposta { get; set; }
        public string Stato { get; set; } = "Aperta";
        public int? ResponsabileGestioneId { get; set; }
        public DateTime? DataPresaInCarico { get; set; }
        public DateTime? DataRisposta { get; set; }
        public string? EsitoRichiesta { get; set; }
        public string? MotivoRifiuto { get; set; }
        public string? DescrizioneRisposta { get; set; }
        public string? ModalitaRisposta { get; set; }
        public string? RiferimentoDocumentoRisposta { get; set; }
        public string? Note { get; set; }

        public static RichiestaGdprFormModel CreateDefault()
            => new()
            {
                DataRichiesta = DateTime.Today,
                DataScadenzaRisposta = DateTime.Today.AddDays(30)
            };

        public static RichiestaGdprFormModel FromItem(RichiestaGdprItem item)
            => new()
            {
                PersonaId = item.PersonaId,
                NomeRichiedente = item.NomeRichiedente,
                CognomeRichiedente = item.CognomeRichiedente,
                EmailRichiedente = item.EmailRichiedente,
                TelefonoRichiedente = item.TelefonoRichiedente,
                TipoDirittoInteressatoId = item.TipoDirittoInteressatoId,
                Codice = item.Codice,
                DataRichiesta = item.DataRichiesta,
                CanaleRichiesta = item.CanaleRichiesta,
                DescrizioneRichiesta = item.DescrizioneRichiesta,
                DocumentoIdentita = item.DocumentoIdentita,
                DataScadenzaRisposta = item.DataScadenzaRisposta,
                Stato = item.Stato,
                ResponsabileGestioneId = item.ResponsabileGestioneId,
                DataPresaInCarico = item.DataPresaInCarico,
                DataRisposta = item.DataRisposta,
                EsitoRichiesta = item.EsitoRichiesta,
                MotivoRifiuto = item.MotivoRifiuto,
                DescrizioneRisposta = item.DescrizioneRisposta,
                ModalitaRisposta = item.ModalitaRisposta,
                RiferimentoDocumentoRisposta = item.RiferimentoDocumentoRisposta,
                Note = item.Note
            };

        public CreateRichiestaGdprRequest ToCreateRequest()
            => new(
                PersonaId,
                NomeRichiedente.Trim(),
                CognomeRichiedente.Trim(),
                NullIfWhiteSpace(EmailRichiedente),
                NullIfWhiteSpace(TelefonoRichiedente),
                TipoDirittoInteressatoId,
                Codice.Trim(),
                DataRichiesta!.Value,
                CanaleRichiesta.Trim(),
                NullIfWhiteSpace(DescrizioneRichiesta),
                NullIfWhiteSpace(DocumentoIdentita),
                DataScadenzaRisposta!.Value,
                Stato.Trim(),
                ResponsabileGestioneId,
                DataPresaInCarico,
                DataRisposta,
                NullIfWhiteSpace(EsitoRichiesta),
                NullIfWhiteSpace(MotivoRifiuto),
                NullIfWhiteSpace(DescrizioneRisposta),
                NullIfWhiteSpace(ModalitaRisposta),
                NullIfWhiteSpace(RiferimentoDocumentoRisposta),
                NullIfWhiteSpace(Note));

        public UpdateRichiestaGdprRequest ToUpdateRequest()
            => new(
                PersonaId,
                NomeRichiedente.Trim(),
                CognomeRichiedente.Trim(),
                NullIfWhiteSpace(EmailRichiedente),
                NullIfWhiteSpace(TelefonoRichiedente),
                TipoDirittoInteressatoId,
                Codice.Trim(),
                DataRichiesta!.Value,
                CanaleRichiesta.Trim(),
                NullIfWhiteSpace(DescrizioneRichiesta),
                NullIfWhiteSpace(DocumentoIdentita),
                DataScadenzaRisposta!.Value,
                Stato.Trim(),
                ResponsabileGestioneId,
                DataPresaInCarico,
                DataRisposta,
                NullIfWhiteSpace(EsitoRichiesta),
                NullIfWhiteSpace(MotivoRifiuto),
                NullIfWhiteSpace(DescrizioneRisposta),
                NullIfWhiteSpace(ModalitaRisposta),
                NullIfWhiteSpace(RiferimentoDocumentoRisposta),
                NullIfWhiteSpace(Note));

        private static string? NullIfWhiteSpace(string? value)
            => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    }
}