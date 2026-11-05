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

namespace Accredia.SIGAD.Web.Components.Pages.RisorseUmane;

public partial class DettaglioDipendente : ComponentBase
{
[Parameter] public int Id { get; set; }

    private IReadOnlyList<BreadcrumbItem> _breadcrumbs => new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("Risorse Umane"),
        new BreadcrumbItem("Dipendenti", "/risorse-umane/dipendenti"),
        new BreadcrumbItem(_detail is not null ? $"{_detail.Persona.Dettaglio.Cognome} {_detail.Persona.Dettaglio.Nome}" : $"#{Id}")
    };

    private string GetDipendenteInitials()
    {
        if (_detail is null) return "?";
        var c = string.IsNullOrWhiteSpace(_detail.Persona.Dettaglio.Cognome) ? "" : _detail.Persona.Dettaglio.Cognome[..1];
        var n = string.IsNullOrWhiteSpace(_detail.Persona.Dettaglio.Nome) ? "" : _detail.Persona.Dettaglio.Nome[..1];
        return $"{c}{n}".ToUpperInvariant();
    }

    private bool CanReadDipendente =>
        (UserContext.HasPermission("SIDAC.HR.DIP.LIST") || UserContext.HasPermission("SIDAC.HR.DIP.READ"))
        && UserContext.HasPermission("SIDAC.HR.PERSONA.READ");
    private bool CanUpdateDipendente => UserContext.HasPermission("SIDAC.HR.DIP.UPDATE");
    private bool CanDeleteDipendente => UserContext.HasPermission("SIDAC.HR.DIP.DELETE");

    private bool CanCreateContratti => UserContext.HasPermission("SIDAC.HR.CONTRATTI.CREATE");
    private bool CanReadContratti => UserContext.HasPermission("SIDAC.HR.CONTRATTI.LIST") || UserContext.HasPermission("SIDAC.HR.CONTRATTI.READ");
    private bool CanUpdateContratti => UserContext.HasPermission("SIDAC.HR.CONTRATTI.UPDATE");
    private bool CanDeleteContratti => UserContext.HasPermission("SIDAC.HR.CONTRATTI.DELETE");

    private bool CanCreateDotazioni => UserContext.HasPermission("SIDAC.HR.DOTAZIONI.CREATE");
    private bool CanReadDotazioni => UserContext.HasPermission("SIDAC.HR.DOTAZIONI.LIST") || UserContext.HasPermission("SIDAC.HR.DOTAZIONI.READ");
    private bool CanUpdateDotazioni => UserContext.HasPermission("SIDAC.HR.DOTAZIONI.UPDATE");
    private bool CanDeleteDotazioni => UserContext.HasPermission("SIDAC.HR.DOTAZIONI.DELETE");

    private bool CanCreateFormazione => UserContext.HasPermission("SIDAC.HR.FORM.CREATE");
    private bool CanReadFormazione => UserContext.HasPermission("SIDAC.HR.FORM.LIST") || UserContext.HasPermission("SIDAC.HR.FORM.READ");
    private bool CanUpdateFormazione => UserContext.HasPermission("SIDAC.HR.FORM.UPDATE");
    private bool CanDeleteFormazione => UserContext.HasPermission("SIDAC.HR.FORM.DELETE");

    private bool _isLoading = true;
    private bool _isSaving;
    private bool _isDeleting;
    private bool _isEditMode;
    private bool _confirmDelete;
    private bool _isLoadingContratti;
    private bool _isSavingContratto;
    private bool _showContrattoForm;
    private bool _isEditingContratto;
    private bool _showStoricoContratto;
    private int? _editingContrattoId;
    private int? _confirmDeleteContrattoId;
    private int? _storicoContrattoId;
    private bool _isLoadingDotazioni;
    private bool _isSavingDotazione;
    private bool _showDotazioneForm;
    private bool _isEditingDotazione;
    private int? _editingDotazioneId;
    private int? _confirmDeleteDotazioneId;
    private bool _isLoadingFormazione;
    private bool _isSavingFormazione;
    private bool _showFormazioneForm;
    private bool _isEditingFormazione;
    private int? _editingFormazioneId;
    private int? _confirmDeleteFormazioneId;
    private string? _errorMessage;
    private DipendenteDettaglioCompletoDto? _detail;
    private IReadOnlyList<ContrattoDto> _contratti = Array.Empty<ContrattoDto>();
    private IReadOnlyList<ContrattoStoricoDto> _contrattoStorico = Array.Empty<ContrattoStoricoDto>();
    private IReadOnlyList<DotazioneDto> _dotazioni = Array.Empty<DotazioneDto>();
    private IReadOnlyList<FormazioneObbligatoriaDto> _formazioni = Array.Empty<FormazioneObbligatoriaDto>();
    private EditModel _editModel = new();
    private ContrattoFormModel _contrattoForm = new();
    private DotazioneFormModel _dotazioneForm = new();
    private FormazioneFormModel _formazioneForm = new();

    private sealed class EditModel
    {
        public string Matricola { get; set; } = string.Empty;
        public string? EmailAziendale { get; set; }
        public string? TelefonoInterno { get; set; }
        public DateTime? DataAssunzione { get; set; }
        public DateTime? DataCessazione { get; set; }
        public int StatoDipendenteId { get; set; }
        public bool AbilitatoAttivitaIspettiva { get; set; }
        public string? Note { get; set; }
    }

    private sealed class ContrattoFormModel
    {
        public int TipoContrattoId { get; set; } = 1;
        public DateTime? DataInizio { get; set; } = DateTime.Today;
        public DateTime? DataFine { get; set; }
        public string? LivelloInquadramento { get; set; }
        public string? CcnlApplicato { get; set; }
        public decimal? Ral { get; set; }
        public decimal? PercentualePartTime { get; set; }
        public decimal? OreLavoroSettimanali { get; set; }
        public bool IsContrattoCorrente { get; set; }
        public string? Note { get; set; }
    }

    private sealed class DotazioneFormModel
    {
        public int TipoDotazioneId { get; set; } = 1;
        public string Descrizione { get; set; } = string.Empty;
        public string? NumeroInventario { get; set; }
        public string? NumeroSerie { get; set; }
        public DateTime? DataAssegnazione { get; set; } = DateTime.Today;
        public DateTime? DataRestituzione { get; set; }
        public bool IsRestituito { get; set; }
        public string? Note { get; set; }
    }

    private sealed class FormazioneFormModel
    {
        public int TipoFormazioneObbligatoriaId { get; set; } = 1;
        public DateTime? DataCompletamento { get; set; } = DateTime.Today;
        public DateTime? DataScadenza { get; set; }
        public string? EstremiAttestato { get; set; }
        public string? EnteFormatore { get; set; }
        public int? DurataOreCorso { get; set; }
        public string? Note { get; set; }
    }

    protected override async Task OnParametersSetAsync()
    {
        if (!CanReadDipendente)
        {
            _isLoading = false;
            return;
        }

        _isLoading = true;
        _errorMessage = null;
        _detail = null;
        _isEditMode = false;
        _confirmDelete = false;
        _confirmDeleteContrattoId = null;
        _showStoricoContratto = false;

        var result = await GatewayClient.GetDipendenteDettaglioCompletoAsync(Id, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare il dettaglio dipendente.";
        }
        else
        {
            _detail = result.Data;
            _editModel = new EditModel
            {
                Matricola = _detail.Dipendente.Matricola,
                EmailAziendale = _detail.Dipendente.EmailAziendale,
                TelefonoInterno = _detail.Dipendente.TelefonoInterno,
                DataAssunzione = _detail.Dipendente.DataAssunzione.ToDateTime(TimeOnly.MinValue),
                DataCessazione = _detail.Dipendente.DataCessazione?.ToDateTime(TimeOnly.MinValue),
                StatoDipendenteId = _detail.Dipendente.StatoDipendenteId,
                AbilitatoAttivitaIspettiva = _detail.Dipendente.AbilitatoAttivitaIspettiva,
                Note = _detail.Dipendente.Note
            };

            await LoadContrattiAsync();
            await LoadDotazioniAsync();
            await LoadFormazioneAsync();
        }

        _isLoading = false;
    }

    private void ToggleEdit()
    {
        if (!CanUpdateDipendente)
        {
            _errorMessage = "Accesso negato: permesso HR.DIP.UPDATE mancante.";
            return;
        }

        _confirmDelete = false;
        _isEditMode = !_isEditMode;
    }

    private void CancelEdit()
    {
        if (_detail is null)
        {
            _isEditMode = false;
            return;
        }

        _editModel.Matricola = _detail.Dipendente.Matricola;
        _editModel.EmailAziendale = _detail.Dipendente.EmailAziendale;
        _editModel.TelefonoInterno = _detail.Dipendente.TelefonoInterno;
        _editModel.DataAssunzione = _detail.Dipendente.DataAssunzione.ToDateTime(TimeOnly.MinValue);
        _editModel.DataCessazione = _detail.Dipendente.DataCessazione?.ToDateTime(TimeOnly.MinValue);
        _editModel.StatoDipendenteId = _detail.Dipendente.StatoDipendenteId;
        _editModel.AbilitatoAttivitaIspettiva = _detail.Dipendente.AbilitatoAttivitaIspettiva;
        _editModel.Note = _detail.Dipendente.Note;
        _isEditMode = false;
    }

    private Task OnDataAssunzioneChanged(DateTime? value)
    {
        _editModel.DataAssunzione = value;
        return Task.CompletedTask;
    }

    private Task OnDataCessazioneChanged(DateTime? value)
    {
        _editModel.DataCessazione = value;
        return Task.CompletedTask;
    }

    private async Task SaveDipendenteAsync()
    {
        if (!CanUpdateDipendente)
        {
            _errorMessage = "Accesso negato: permesso HR.DIP.UPDATE mancante.";
            return;
        }

        if (_detail is null || _isSaving)
        {
            return;
        }

        if (string.IsNullOrWhiteSpace(_editModel.Matricola))
        {
            _errorMessage = "Matricola obbligatoria.";
            return;
        }

        if (_editModel.DataAssunzione is null)
        {
            _errorMessage = "Data assunzione obbligatoria.";
            return;
        }

        _isSaving = true;
        _errorMessage = null;
        try
        {
            var request = new UpdateDipendenteRequest(
                _detail.Dipendente.PersonaId,
                _editModel.Matricola.Trim(),
                _editModel.EmailAziendale,
                _editModel.TelefonoInterno,
                _detail.Dipendente.UnitaOrganizzativaId,
                _detail.Dipendente.ResponsabileDirettoId,
                DateOnly.FromDateTime(_editModel.DataAssunzione.Value.Date),
                _editModel.DataCessazione.HasValue ? DateOnly.FromDateTime(_editModel.DataCessazione.Value.Date) : null,
                _editModel.StatoDipendenteId,
                _editModel.AbilitatoAttivitaIspettiva,
                _editModel.Note);

            var result = await GatewayClient.UpdateDipendenteAsync(Id, request, CancellationToken.None);
            if (!result.IsSuccess)
            {
                _errorMessage = result.Error ?? "Aggiornamento dipendente non riuscito.";
                return;
            }

            Snackbar.Add("Dipendente aggiornato.", Severity.Success);
            _isEditMode = false;
            await OnParametersSetAsync();
            await InvokeAsync(StateHasChanged);
        }
        finally
        {
            _isSaving = false;
        }
    }

    private async Task DeleteDipendenteAsync()
    {
        if (!CanDeleteDipendente)
        {
            _errorMessage = "Accesso negato: permesso HR.DIP.DELETE mancante.";
            return;
        }

        if (_detail is null || _isDeleting)
        {
            return;
        }

        if (!_confirmDelete)
        {
            _confirmDelete = true;
            return;
        }

        _isDeleting = true;
        _errorMessage = null;
        try
        {
            var result = await GatewayClient.DeleteDipendenteAsync(Id, CancellationToken.None);
            if (!result.IsSuccess)
            {
                _errorMessage = result.Error ?? "Eliminazione dipendente non riuscita.";
                return;
            }

            Snackbar.Add("Dipendente eliminato.", Severity.Success);
            Navigation.NavigateTo("/risorse-umane/dipendenti");
        }
        finally
        {
            _isDeleting = false;
        }
    }

    private async Task LoadContrattiAsync()
    {
        if (!CanReadContratti)
        {
            _contratti = Array.Empty<ContrattoDto>();
            _contrattoStorico = Array.Empty<ContrattoStoricoDto>();
            _showStoricoContratto = false;
            _storicoContrattoId = null;
            return;
        }

        _isLoadingContratti = true;
        try
        {
            var result = await GatewayClient.GetContrattiByDipendenteAsync(Id, includeDeleted: false, CancellationToken.None);
            if (!result.IsSuccess || result.Data is null)
            {
                _errorMessage = result.Error ?? "Impossibile caricare i contratti.";
                _contratti = Array.Empty<ContrattoDto>();
            }
            else
            {
                _contratti = result.Data;
            }
        }
        finally
        {
            _isLoadingContratti = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private void OpenNewContratto()
    {
        if (!CanCreateContratti)
        {
            _errorMessage = "Accesso negato: permesso HR.CONTRATTI.CREATE mancante.";
            return;
        }

        _isEditingContratto = false;
        _editingContrattoId = null;
        _confirmDeleteContrattoId = null;
        _showStoricoContratto = false;
        _contrattoForm = new ContrattoFormModel();
        _showContrattoForm = true;
    }

    private void OpenEditContratto(ContrattoDto contratto)
    {
        if (!CanUpdateContratti)
        {
            _errorMessage = "Accesso negato: permesso HR.CONTRATTI.UPDATE mancante.";
            return;
        }

        _isEditingContratto = true;
        _editingContrattoId = contratto.ContrattoId;
        _confirmDeleteContrattoId = null;
        _showStoricoContratto = false;
        _contrattoForm = new ContrattoFormModel
        {
            TipoContrattoId = contratto.TipoContrattoId,
            DataInizio = contratto.DataInizio.ToDateTime(TimeOnly.MinValue),
            DataFine = contratto.DataFine?.ToDateTime(TimeOnly.MinValue),
            LivelloInquadramento = contratto.LivelloInquadramento,
            CcnlApplicato = contratto.CCNLApplicato,
            Ral = contratto.RAL,
            PercentualePartTime = contratto.PercentualePartTime,
            OreLavoroSettimanali = contratto.OreLavoroSettimanali,
            IsContrattoCorrente = contratto.IsContrattoCorrente,
            Note = contratto.Note
        };
        _showContrattoForm = true;
    }

    private void CancelContrattoEdit()
    {
        _showContrattoForm = false;
        _isEditingContratto = false;
        _editingContrattoId = null;
        _contrattoForm = new ContrattoFormModel();
    }

    private Task OnContrattoDataInizioChanged(DateTime? value)
    {
        _contrattoForm.DataInizio = value;
        return Task.CompletedTask;
    }

    private Task OnContrattoDataFineChanged(DateTime? value)
    {
        _contrattoForm.DataFine = value;
        return Task.CompletedTask;
    }

    private async Task SaveContrattoAsync()
    {
        if ((!_isEditingContratto && !CanCreateContratti) || (_isEditingContratto && !CanUpdateContratti))
        {
            _errorMessage = _isEditingContratto
                ? "Accesso negato: permesso HR.CONTRATTI.UPDATE mancante."
                : "Accesso negato: permesso HR.CONTRATTI.CREATE mancante.";
            return;
        }

        if (_isSavingContratto)
        {
            return;
        }

        if (_contrattoForm.TipoContrattoId <= 0)
        {
            _errorMessage = "Tipo contratto non valido.";
            return;
        }

        if (_contrattoForm.DataInizio is null)
        {
            _errorMessage = "Data inizio contratto obbligatoria.";
            return;
        }

        if (_contrattoForm.DataFine.HasValue && _contrattoForm.DataFine.Value.Date < _contrattoForm.DataInizio.Value.Date)
        {
            _errorMessage = "Data fine non puo essere precedente a data inizio.";
            return;
        }

        _isSavingContratto = true;
        _errorMessage = null;
        try
        {
            if (_isEditingContratto && _editingContrattoId.HasValue)
            {
                var updateRequest = new UpdateContrattoRequest(
                    _contrattoForm.TipoContrattoId,
                    DateOnly.FromDateTime(_contrattoForm.DataInizio.Value.Date),
                    _contrattoForm.DataFine.HasValue ? DateOnly.FromDateTime(_contrattoForm.DataFine.Value.Date) : null,
                    _contrattoForm.LivelloInquadramento,
                    _contrattoForm.CcnlApplicato,
                    _contrattoForm.Ral,
                    _contrattoForm.PercentualePartTime,
                    _contrattoForm.OreLavoroSettimanali,
                    _contrattoForm.IsContrattoCorrente,
                    _contrattoForm.Note);

                var updateResult = await GatewayClient.UpdateContrattoAsync(Id, _editingContrattoId.Value, updateRequest, CancellationToken.None);
                if (!updateResult.IsSuccess)
                {
                    _errorMessage = updateResult.Error ?? "Aggiornamento contratto non riuscito.";
                    return;
                }

                Snackbar.Add("Contratto aggiornato.", Severity.Success);
            }
            else
            {
                var createRequest = new CreateContrattoRequest(
                    _contrattoForm.TipoContrattoId,
                    DateOnly.FromDateTime(_contrattoForm.DataInizio.Value.Date),
                    _contrattoForm.DataFine.HasValue ? DateOnly.FromDateTime(_contrattoForm.DataFine.Value.Date) : null,
                    _contrattoForm.LivelloInquadramento,
                    _contrattoForm.CcnlApplicato,
                    _contrattoForm.Ral,
                    _contrattoForm.PercentualePartTime,
                    _contrattoForm.OreLavoroSettimanali,
                    _contrattoForm.IsContrattoCorrente,
                    _contrattoForm.Note);

                var createResult = await GatewayClient.CreateContrattoAsync(Id, createRequest, CancellationToken.None);
                if (!createResult.IsSuccess)
                {
                    _errorMessage = createResult.Error ?? "Creazione contratto non riuscita.";
                    return;
                }

                Snackbar.Add("Contratto creato.", Severity.Success);
            }

            CancelContrattoEdit();
            await LoadContrattiAsync();
        }
        finally
        {
            _isSavingContratto = false;
        }
    }

    private async Task DeleteContrattoAsync(int contrattoId)
    {
        if (!CanDeleteContratti)
        {
            _errorMessage = "Accesso negato: permesso HR.CONTRATTI.DELETE mancante.";
            return;
        }

        if (_confirmDeleteContrattoId != contrattoId)
        {
            _confirmDeleteContrattoId = contrattoId;
            return;
        }

        _errorMessage = null;
        var result = await GatewayClient.DeleteContrattoAsync(Id, contrattoId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _errorMessage = result.Error ?? "Eliminazione contratto non riuscita.";
            return;
        }

        _confirmDeleteContrattoId = null;
        _showStoricoContratto = false;
        _storicoContrattoId = null;
        Snackbar.Add("Contratto eliminato.", Severity.Success);
        await LoadContrattiAsync();
    }

    private async Task ToggleStoricoContrattoAsync(int contrattoId)
    {
        if (!CanReadContratti)
        {
            _errorMessage = "Accesso negato: permesso HR.CONTRATTI.LIST/READ mancante.";
            return;
        }

        if (_showStoricoContratto && _storicoContrattoId == contrattoId)
        {
            _showStoricoContratto = false;
            _storicoContrattoId = null;
            _contrattoStorico = Array.Empty<ContrattoStoricoDto>();
            await InvokeAsync(StateHasChanged);
            return;
        }

        _errorMessage = null;
        var result = await GatewayClient.GetContrattoStoricoAsync(contrattoId, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare storico contratto.";
            return;
        }

        _storicoContrattoId = contrattoId;
        _contrattoStorico = result.Data;
        _showStoricoContratto = true;
        await InvokeAsync(StateHasChanged);
    }

    private async Task LoadDotazioniAsync()
    {
        if (!CanReadDotazioni)
        {
            _dotazioni = Array.Empty<DotazioneDto>();
            return;
        }

        _isLoadingDotazioni = true;
        try
        {
            var result = await GatewayClient.GetDotazioniByDipendenteAsync(Id, includeDeleted: false, CancellationToken.None);
            if (!result.IsSuccess || result.Data is null)
            {
                _errorMessage = result.Error ?? "Impossibile caricare le dotazioni.";
                _dotazioni = Array.Empty<DotazioneDto>();
            }
            else
            {
                _dotazioni = result.Data;
            }
        }
        finally
        {
            _isLoadingDotazioni = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private void OpenNewDotazione()
    {
        if (!CanCreateDotazioni)
        {
            _errorMessage = "Accesso negato: permesso HR.DOTAZIONI.CREATE mancante.";
            return;
        }

        _isEditingDotazione = false;
        _editingDotazioneId = null;
        _confirmDeleteDotazioneId = null;
        _dotazioneForm = new DotazioneFormModel();
        _showDotazioneForm = true;
    }

    private void OpenEditDotazione(DotazioneDto dotazione)
    {
        if (!CanUpdateDotazioni)
        {
            _errorMessage = "Accesso negato: permesso HR.DOTAZIONI.UPDATE mancante.";
            return;
        }

        _isEditingDotazione = true;
        _editingDotazioneId = dotazione.DotazioneId;
        _confirmDeleteDotazioneId = null;
        _dotazioneForm = new DotazioneFormModel
        {
            TipoDotazioneId = dotazione.TipoDotazioneId,
            Descrizione = dotazione.Descrizione,
            NumeroInventario = dotazione.NumeroInventario,
            NumeroSerie = dotazione.NumeroSerie,
            DataAssegnazione = dotazione.DataAssegnazione.ToDateTime(TimeOnly.MinValue),
            DataRestituzione = dotazione.DataRestituzione?.ToDateTime(TimeOnly.MinValue),
            IsRestituito = dotazione.IsRestituito,
            Note = dotazione.Note
        };
        _showDotazioneForm = true;
    }

    private void CancelDotazioneEdit()
    {
        _showDotazioneForm = false;
        _isEditingDotazione = false;
        _editingDotazioneId = null;
        _dotazioneForm = new DotazioneFormModel();
    }

    private Task OnDotazioneDataAssegnazioneChanged(DateTime? value)
    {
        _dotazioneForm.DataAssegnazione = value;
        return Task.CompletedTask;
    }

    private Task OnDotazioneDataRestituzioneChanged(DateTime? value)
    {
        _dotazioneForm.DataRestituzione = value;
        return Task.CompletedTask;
    }

    private async Task SaveDotazioneAsync()
    {
        if ((!_isEditingDotazione && !CanCreateDotazioni) || (_isEditingDotazione && !CanUpdateDotazioni))
        {
            _errorMessage = _isEditingDotazione
                ? "Accesso negato: permesso HR.DOTAZIONI.UPDATE mancante."
                : "Accesso negato: permesso HR.DOTAZIONI.CREATE mancante.";
            return;
        }

        if (_isSavingDotazione)
        {
            return;
        }

        if (_dotazioneForm.TipoDotazioneId <= 0 || string.IsNullOrWhiteSpace(_dotazioneForm.Descrizione))
        {
            _errorMessage = "Tipo dotazione e descrizione sono obbligatori.";
            return;
        }

        if (_dotazioneForm.DataAssegnazione is null)
        {
            _errorMessage = "Data assegnazione obbligatoria.";
            return;
        }

        if (_dotazioneForm.DataRestituzione.HasValue &&
            _dotazioneForm.DataRestituzione.Value.Date < _dotazioneForm.DataAssegnazione.Value.Date)
        {
            _errorMessage = "Data restituzione non puo essere precedente a data assegnazione.";
            return;
        }

        _isSavingDotazione = true;
        _errorMessage = null;
        try
        {
            if (_isEditingDotazione && _editingDotazioneId.HasValue)
            {
                var updateRequest = new UpdateDotazioneRequest(
                    _dotazioneForm.TipoDotazioneId,
                    _dotazioneForm.Descrizione.Trim(),
                    _dotazioneForm.NumeroInventario,
                    _dotazioneForm.NumeroSerie,
                    DateOnly.FromDateTime(_dotazioneForm.DataAssegnazione.Value.Date),
                    _dotazioneForm.DataRestituzione.HasValue ? DateOnly.FromDateTime(_dotazioneForm.DataRestituzione.Value.Date) : null,
                    _dotazioneForm.IsRestituito,
                    _dotazioneForm.Note);

                var updateResult = await GatewayClient.UpdateDotazioneAsync(Id, _editingDotazioneId.Value, updateRequest, CancellationToken.None);
                if (!updateResult.IsSuccess)
                {
                    _errorMessage = updateResult.Error ?? "Aggiornamento dotazione non riuscito.";
                    return;
                }

                Snackbar.Add("Dotazione aggiornata.", Severity.Success);
            }
            else
            {
                var createRequest = new CreateDotazioneRequest(
                    _dotazioneForm.TipoDotazioneId,
                    _dotazioneForm.Descrizione.Trim(),
                    _dotazioneForm.NumeroInventario,
                    _dotazioneForm.NumeroSerie,
                    DateOnly.FromDateTime(_dotazioneForm.DataAssegnazione.Value.Date),
                    _dotazioneForm.DataRestituzione.HasValue ? DateOnly.FromDateTime(_dotazioneForm.DataRestituzione.Value.Date) : null,
                    _dotazioneForm.IsRestituito,
                    _dotazioneForm.Note);

                var createResult = await GatewayClient.CreateDotazioneAsync(Id, createRequest, CancellationToken.None);
                if (!createResult.IsSuccess)
                {
                    _errorMessage = createResult.Error ?? "Creazione dotazione non riuscita.";
                    return;
                }

                Snackbar.Add("Dotazione creata.", Severity.Success);
            }

            CancelDotazioneEdit();
            await LoadDotazioniAsync();
        }
        finally
        {
            _isSavingDotazione = false;
        }
    }

    private async Task DeleteDotazioneAsync(int dotazioneId)
    {
        if (!CanDeleteDotazioni)
        {
            _errorMessage = "Accesso negato: permesso HR.DOTAZIONI.DELETE mancante.";
            return;
        }

        if (_confirmDeleteDotazioneId != dotazioneId)
        {
            _confirmDeleteDotazioneId = dotazioneId;
            return;
        }

        _errorMessage = null;
        var result = await GatewayClient.DeleteDotazioneAsync(Id, dotazioneId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _errorMessage = result.Error ?? "Eliminazione dotazione non riuscita.";
            return;
        }

        _confirmDeleteDotazioneId = null;
        Snackbar.Add("Dotazione eliminata.", Severity.Success);
        await LoadDotazioniAsync();
    }

    private async Task LoadFormazioneAsync()
    {
        if (!CanReadFormazione)
        {
            _formazioni = Array.Empty<FormazioneObbligatoriaDto>();
            return;
        }

        _isLoadingFormazione = true;
        try
        {
            var result = await GatewayClient.GetFormazioneByDipendenteAsync(Id, includeDeleted: false, CancellationToken.None);
            if (!result.IsSuccess || result.Data is null)
            {
                _errorMessage = result.Error ?? "Impossibile caricare la formazione obbligatoria.";
                _formazioni = Array.Empty<FormazioneObbligatoriaDto>();
            }
            else
            {
                _formazioni = result.Data;
            }
        }
        finally
        {
            _isLoadingFormazione = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private void OpenNewFormazione()
    {
        if (!CanCreateFormazione)
        {
            _errorMessage = "Accesso negato: permesso HR.FORM.CREATE mancante.";
            return;
        }

        _isEditingFormazione = false;
        _editingFormazioneId = null;
        _confirmDeleteFormazioneId = null;
        _formazioneForm = new FormazioneFormModel();
        _showFormazioneForm = true;
    }

    private void OpenEditFormazione(FormazioneObbligatoriaDto formazione)
    {
        if (!CanUpdateFormazione)
        {
            _errorMessage = "Accesso negato: permesso HR.FORM.UPDATE mancante.";
            return;
        }

        _isEditingFormazione = true;
        _editingFormazioneId = formazione.FormazioneObbligatoriaId;
        _confirmDeleteFormazioneId = null;
        _formazioneForm = new FormazioneFormModel
        {
            TipoFormazioneObbligatoriaId = formazione.TipoFormazioneObbligatoriaId,
            DataCompletamento = formazione.DataCompletamento.ToDateTime(TimeOnly.MinValue),
            DataScadenza = formazione.DataScadenza?.ToDateTime(TimeOnly.MinValue),
            EstremiAttestato = formazione.EstremiAttestato,
            EnteFormatore = formazione.EnteFormatore,
            DurataOreCorso = formazione.DurataOreCorso,
            Note = formazione.Note
        };
        _showFormazioneForm = true;
    }

    private void CancelFormazioneEdit()
    {
        _showFormazioneForm = false;
        _isEditingFormazione = false;
        _editingFormazioneId = null;
        _formazioneForm = new FormazioneFormModel();
    }

    private Task OnFormazioneDataCompletamentoChanged(DateTime? value)
    {
        _formazioneForm.DataCompletamento = value;
        return Task.CompletedTask;
    }

    private Task OnFormazioneDataScadenzaChanged(DateTime? value)
    {
        _formazioneForm.DataScadenza = value;
        return Task.CompletedTask;
    }

    private async Task SaveFormazioneAsync()
    {
        if ((!_isEditingFormazione && !CanCreateFormazione) || (_isEditingFormazione && !CanUpdateFormazione))
        {
            _errorMessage = _isEditingFormazione
                ? "Accesso negato: permesso HR.FORM.UPDATE mancante."
                : "Accesso negato: permesso HR.FORM.CREATE mancante.";
            return;
        }

        if (_isSavingFormazione)
        {
            return;
        }

        if (_formazioneForm.TipoFormazioneObbligatoriaId <= 0 || _formazioneForm.DataCompletamento is null)
        {
            _errorMessage = "Tipo formazione e data completamento sono obbligatori.";
            return;
        }

        if (_formazioneForm.DataScadenza.HasValue &&
            _formazioneForm.DataScadenza.Value.Date < _formazioneForm.DataCompletamento.Value.Date)
        {
            _errorMessage = "Data scadenza non puo essere precedente a data completamento.";
            return;
        }

        _isSavingFormazione = true;
        _errorMessage = null;
        try
        {
            if (_isEditingFormazione && _editingFormazioneId.HasValue)
            {
                var updateRequest = new UpdateFormazioneObbligatoriaRequest(
                    _formazioneForm.TipoFormazioneObbligatoriaId,
                    DateOnly.FromDateTime(_formazioneForm.DataCompletamento.Value.Date),
                    _formazioneForm.DataScadenza.HasValue ? DateOnly.FromDateTime(_formazioneForm.DataScadenza.Value.Date) : null,
                    _formazioneForm.EstremiAttestato,
                    _formazioneForm.EnteFormatore,
                    _formazioneForm.DurataOreCorso,
                    _formazioneForm.Note);

                var updateResult = await GatewayClient.UpdateFormazioneAsync(Id, _editingFormazioneId.Value, updateRequest, CancellationToken.None);
                if (!updateResult.IsSuccess)
                {
                    _errorMessage = updateResult.Error ?? "Aggiornamento formazione non riuscito.";
                    return;
                }

                Snackbar.Add("Formazione aggiornata.", Severity.Success);
            }
            else
            {
                var createRequest = new CreateFormazioneObbligatoriaRequest(
                    _formazioneForm.TipoFormazioneObbligatoriaId,
                    DateOnly.FromDateTime(_formazioneForm.DataCompletamento.Value.Date),
                    _formazioneForm.DataScadenza.HasValue ? DateOnly.FromDateTime(_formazioneForm.DataScadenza.Value.Date) : null,
                    _formazioneForm.EstremiAttestato,
                    _formazioneForm.EnteFormatore,
                    _formazioneForm.DurataOreCorso,
                    _formazioneForm.Note);

                var createResult = await GatewayClient.CreateFormazioneAsync(Id, createRequest, CancellationToken.None);
                if (!createResult.IsSuccess)
                {
                    _errorMessage = createResult.Error ?? "Creazione formazione non riuscita.";
                    return;
                }

                Snackbar.Add("Formazione creata.", Severity.Success);
            }

            CancelFormazioneEdit();
            await LoadFormazioneAsync();
        }
        finally
        {
            _isSavingFormazione = false;
        }
    }

    private async Task DeleteFormazioneAsync(int formazioneObbligatoriaId)
    {
        if (!CanDeleteFormazione)
        {
            _errorMessage = "Accesso negato: permesso HR.FORM.DELETE mancante.";
            return;
        }

        if (_confirmDeleteFormazioneId != formazioneObbligatoriaId)
        {
            _confirmDeleteFormazioneId = formazioneObbligatoriaId;
            return;
        }

        _errorMessage = null;
        var result = await GatewayClient.DeleteFormazioneAsync(Id, formazioneObbligatoriaId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _errorMessage = result.Error ?? "Eliminazione formazione non riuscita.";
            return;
        }

        _confirmDeleteFormazioneId = null;
        Snackbar.Add("Formazione eliminata.", Severity.Success);
        await LoadFormazioneAsync();
    }
}