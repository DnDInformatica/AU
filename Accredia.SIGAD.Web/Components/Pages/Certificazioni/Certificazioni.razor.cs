using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Services;
using Microsoft.AspNetCore.Components;
using MudBlazor;
using BreadcrumbItem = Accredia.SIGAD.Web.Models.Common.BreadcrumbItem;

namespace Accredia.SIGAD.Web.Components.Pages.Certificazioni;

public partial class Certificazioni : ComponentBase
{
    private bool CanAccess => UserContext.HasPermission("MODULE.CERT.ACCESS");
    private bool CanRead => UserContext.HasPermission("CERT.LIST") || UserContext.HasPermission("CERT.READ");
    private bool CanCreate => UserContext.HasPermission("CERT.CREATE");
    private bool CanUpdate => UserContext.HasPermission("CERT.UPDATE");
    private bool CanDelete => UserContext.HasPermission("CERT.DELETE");

    private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs =
    [
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("Certificazioni")
    ];

    private string? _query;
    private string? _errorMessage;
    private string _emptyMessage = "Inserisci almeno 2 caratteri per la ricerca.";
    private int _totalCount;
    private MudTable<CertificazioneListItem>? _table;
    private int? _editingId;
    private string _formDenominazione = string.Empty;
    private string? _formSigla;
    private string? _formNote;
    private DateTime? _formDataFondazione;
    private string? _formError;
    private bool _formBusy;

    private bool IsEditMode => _editingId.HasValue;

    private async Task<TableData<CertificazioneListItem>> LoadCertificazioni(TableState state, CancellationToken cancellationToken)
    {
        if (!CanRead)
        {
            _errorMessage = "Accesso negato: permesso CERT.LIST/READ mancante.";
            return new TableData<CertificazioneListItem>
            {
                Items = Array.Empty<CertificazioneListItem>(),
                TotalItems = 0
            };
        }

        var page = state.Page + 1;
        var pageSize = state.PageSize;
        if (string.IsNullOrWhiteSpace(_query) || _query.Trim().Length < 2)
        {
            _emptyMessage = "Inserisci almeno 2 caratteri per la ricerca.";
            _errorMessage = null;
            _totalCount = 0;
            return new TableData<CertificazioneListItem>
            {
                Items = Array.Empty<CertificazioneListItem>(),
                TotalItems = 0
            };
        }

        var result = await GatewayClient.SearchCertificazioniAsync(_query, page, pageSize, cancellationToken);
        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare le certificazioni.";
            _totalCount = 0;
            return new TableData<CertificazioneListItem>
            {
                Items = Array.Empty<CertificazioneListItem>(),
                TotalItems = 0
            };
        }

        _errorMessage = null;
        _totalCount = result.Data.TotalCount;
        _emptyMessage = "Nessuna certificazione trovata con i filtri selezionati.";
        return new TableData<CertificazioneListItem>
        {
            Items = result.Data.Items,
            TotalItems = result.Data.TotalCount
        };
    }

    private Task OnSearchClicked()
    {
        _errorMessage = null;
        _table?.ReloadServerData();
        return Task.CompletedTask;
    }

    private Task OnResetClicked()
    {
        _query = null;
        _errorMessage = null;
        _totalCount = 0;
        _table?.ReloadServerData();
        return Task.CompletedTask;
    }

    private Task StartCreate()
    {
        if (!CanCreate)
        {
            Snackbar.Add("Accesso negato: permesso CERT.CREATE mancante.", Severity.Error);
            return Task.CompletedTask;
        }

        _editingId = null;
        _formDenominazione = string.Empty;
        _formSigla = null;
        _formNote = null;
        _formDataFondazione = null;
        _formError = null;
        return Task.CompletedTask;
    }

    private async Task StartEdit(CertificazioneListItem item)
    {
        if (!CanUpdate)
        {
            Snackbar.Add("Accesso negato: permesso CERT.UPDATE mancante.", Severity.Error);
            return;
        }

        var result = await GatewayClient.GetCertificazioneDetailAsync(item.CertificazioneId, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            Snackbar.Add(result.Error ?? "Impossibile caricare il dettaglio certificazione.", Severity.Error);
            return;
        }

        _editingId = result.Data.CertificazioneId;
        _formDenominazione = result.Data.Denominazione;
        _formSigla = result.Data.Sigla;
        _formNote = result.Data.Note;
        _formDataFondazione = result.Data.DataFondazione;
        _formError = null;
    }

    private Task CancelEdit()
    {
        _editingId = null;
        _formError = null;
        return Task.CompletedTask;
    }

    private async Task SaveAsync()
    {
        if (_formBusy)
        {
            return;
        }

        if (string.IsNullOrWhiteSpace(_formDenominazione))
        {
            _formError = "Denominazione obbligatoria.";
            return;
        }

        if (IsEditMode && !CanUpdate)
        {
            Snackbar.Add("Accesso negato: permesso CERT.UPDATE mancante.", Severity.Error);
            return;
        }

        if (!IsEditMode && !CanCreate)
        {
            Snackbar.Add("Accesso negato: permesso CERT.CREATE mancante.", Severity.Error);
            return;
        }

        _formBusy = true;
        _formError = null;

        try
        {
            Accredia.SIGAD.Web.Services.ApiResult<CertificazioneDetail> result;
            if (IsEditMode)
            {
                result = await GatewayClient.UpdateCertificazioneAsync(
                    _editingId!.Value,
                    new UpdateCertificazioneRequest(
                        _formDenominazione.Trim(),
                        string.IsNullOrWhiteSpace(_formSigla) ? null : _formSigla.Trim(),
                        string.IsNullOrWhiteSpace(_formNote) ? null : _formNote.Trim(),
                        _formDataFondazione?.Date),
                    CancellationToken.None);
            }
            else
            {
                result = await GatewayClient.CreateCertificazioneAsync(
                    new CreateCertificazioneRequest(
                        _formDenominazione.Trim(),
                        string.IsNullOrWhiteSpace(_formSigla) ? null : _formSigla.Trim(),
                        string.IsNullOrWhiteSpace(_formNote) ? null : _formNote.Trim(),
                        _formDataFondazione?.Date),
                    CancellationToken.None);
            }

            if (!result.IsSuccess || result.Data is null)
            {
                _formError = result.Error ?? "Salvataggio non riuscito.";
                return;
            }

            Snackbar.Add(IsEditMode ? "Certificazione aggiornata." : "Certificazione creata.", Severity.Success);
            _query = result.Data.Denominazione;
            _editingId = null;
            _table?.ReloadServerData();
        }
        finally
        {
            _formBusy = false;
        }
    }

    private async Task DeleteAsync(CertificazioneListItem item)
    {
        if (!CanDelete)
        {
            Snackbar.Add("Accesso negato: permesso CERT.DELETE mancante.", Severity.Error);
            return;
        }

        var confirm = await DialogService.ShowMessageBox(
            "Conferma eliminazione",
            $"Vuoi eliminare la certificazione '{item.Denominazione}'?\n\nL'operazione esegue una soft-delete.",
            yesText: "Elimina",
            cancelText: "Annulla");

        if (confirm != true)
        {
            return;
        }

        var result = await GatewayClient.SoftDeleteCertificazioneAsync(item.CertificazioneId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            Snackbar.Add(result.Error ?? "Eliminazione non riuscita.", Severity.Error);
            return;
        }

        Snackbar.Add("Certificazione eliminata (soft).", Severity.Success);
        _table?.ReloadServerData();
    }
}
