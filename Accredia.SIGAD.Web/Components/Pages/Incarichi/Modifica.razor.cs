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

namespace Accredia.SIGAD.Web.Components.Pages.Incarichi;

public partial class Modifica : ComponentBase
{
    private bool CanUpdate => UserContext.HasPermission("SIDAC.INC.UPDATE");

    [Parameter] public int Id { get; set; }

    private IReadOnlyList<BreadcrumbItem> _breadcrumbs => new BreadcrumbItem[]
    {
        new("Home", "/"),
        new("Incarichi", "/incarichi"),
        new($"#{Id}", $"/incarichi/{Id}"),
        new("Modifica")
    };

    private sealed record PersonOption(int Id, string Display, string? CodiceFiscale);
    private sealed record OrgOption(int Id, string Display);

    private sealed class FormModel
    {
        public PersonOption? Persona { get; set; }
        public OrgOption? Organizzazione { get; set; }
        public LookupItem? Ruolo { get; set; }
        public string StatoIncarico { get; set; } = string.Empty;
        public LookupItem? UnitaOrganizzativa { get; set; }
        public DateTime? DataInizio { get; set; }
        public DateTime? DataFine { get; set; }
    }

    private readonly FormModel _model = new();
    private MudForm? _form;
    private bool _isLoading = true;
    private bool _isSubmitting;
    private string? _errorMessage;
    private IncaricoDetail? _detail;

    private bool _lookupsLoading = true;
    private string? _lookupsError;
    private IReadOnlyList<LookupItem> _ruoli = Array.Empty<LookupItem>();

    private bool _uoLoading;
    private IReadOnlyList<LookupItem> _uoLookups = Array.Empty<LookupItem>();

    protected override async Task OnParametersSetAsync()
    {
        if (!CanUpdate)
        {
            _isLoading = false;
            _errorMessage = null;
            return;
        }

        _isLoading = true;
        _errorMessage = null;
        _detail = null;

        await LoadLookupsAsync();

        var detail = await GatewayClient.GetIncaricoDetailAsync(Id, CancellationToken.None);
        if (!detail.IsSuccess || detail.Data is null)
        {
            _errorMessage = detail.Error ?? "Impossibile caricare il dettaglio incarico.";
            _isLoading = false;
            return;
        }

        _detail = detail.Data;

        var personaName = $"{_detail.PersonaCognome} {_detail.PersonaNome}".Trim();
        var personaDisplay = !string.IsNullOrWhiteSpace(_detail.PersonaCodiceFiscale) ? $"{personaName} ({_detail.PersonaCodiceFiscale})" : personaName;
        _model.Persona = new PersonOption(_detail.PersonaId, personaDisplay, _detail.PersonaCodiceFiscale);
        _model.Organizzazione = new OrgOption(_detail.OrganizzazioneId, _detail.OrganizzazioneDenominazione ?? $"#{_detail.OrganizzazioneId}");
        _model.StatoIncarico = _detail.StatoIncarico;
        _model.DataInizio = _detail.DataInizio.Date;
        _model.DataFine = _detail.DataFine?.Date;

        if (_detail.TipoRuoloId.HasValue)
        {
            _model.Ruolo = _ruoli.FirstOrDefault(r => r.Id == _detail.TipoRuoloId.Value);
        }

        if (_detail.UnitaOrganizzativaId.HasValue)
        {
            await LoadUoAsync(_detail.OrganizzazioneId);
            _model.UnitaOrganizzativa = _uoLookups.FirstOrDefault(x => x.Id == _detail.UnitaOrganizzativaId.Value);
        }
        else
        {
            await LoadUoAsync(_detail.OrganizzazioneId);
        }

        _isLoading = false;
    }

    private async Task LoadLookupsAsync()
    {
        _lookupsLoading = true;
        _lookupsError = null;

        try
        {
            var result = await GatewayClient.GetIncarichiLookupsAsync(CancellationToken.None);
            if (!result.IsSuccess || result.Data is null)
            {
                _lookupsError = result.Error ?? "Impossibile caricare le tipologiche incarichi.";
                _ruoli = Array.Empty<LookupItem>();
                return;
            }

            _ruoli = result.Data;
        }
        catch (Exception ex)
        {
            _lookupsError = ex.Message;
            _ruoli = Array.Empty<LookupItem>();
        }
        finally
        {
            _lookupsLoading = false;
        }
    }

    private void Cancel()
        => Navigation.NavigateTo($"/incarichi/{Id}");

    private Task OnPersonaChanged(PersonOption? value)
    {
        _model.Persona = value;
        return Task.CompletedTask;
    }

    private async Task OnOrganizzazioneChanged(OrgOption? value)
    {
        _model.Organizzazione = value;
        _model.UnitaOrganizzativa = null;
        _uoLookups = Array.Empty<LookupItem>();

        if (value is null)
        {
            return;
        }

        await LoadUoAsync(value.Id);
    }

    private Task OnDataInizioChanged(DateTime? value)
    {
        _model.DataInizio = value;
        return Task.CompletedTask;
    }

    private Task OnDataFineChanged(DateTime? value)
    {
        _model.DataFine = value;
        return Task.CompletedTask;
    }

    private async Task LoadUoAsync(int organizzazioneId)
    {
        _uoLoading = true;
        try
        {
            var result = await GatewayClient.GetOrganizzazioneUnitaAsync(organizzazioneId, CancellationToken.None);
            if (!result.IsSuccess || result.Data is null)
            {
                _uoLookups = Array.Empty<LookupItem>();
                return;
            }

            _uoLookups = result.Data
                .Select(u =>
                {
                    var label = !string.IsNullOrWhiteSpace(u.Codice) ? $"{u.Codice} - {u.Nome}" : u.Nome;
                    return new LookupItem(u.UnitaOrganizzativaId, label);
                })
                .ToList();
        }
        finally
        {
            _uoLoading = false;
        }
    }

    private async Task<IEnumerable<PersonOption>> SearchPersoneAsync(string value, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(value) || value.Trim().Length < 2)
        {
            return Array.Empty<PersonOption>();
        }

        var result = await GatewayClient.SearchPersoneAsync(value.Trim(), page: 1, pageSize: 10, cancellationToken);
        if (!result.IsSuccess || result.Data is null)
        {
            return Array.Empty<PersonOption>();
        }

        return result.Data.Items.Select(p =>
        {
            var name = $"{p.Cognome} {p.Nome}".Trim();
            var display = !string.IsNullOrWhiteSpace(p.CodiceFiscale) ? $"{name} ({p.CodiceFiscale})" : name;
            return new PersonOption(p.PersonaId, display, p.CodiceFiscale);
        });
    }

    private async Task<IEnumerable<OrgOption>> SearchOrganizzazioniAsync(string value, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(value) || value.Trim().Length < 2)
        {
            return Array.Empty<OrgOption>();
        }

        var result = await GatewayClient.SearchOrganizzazioniAsync(value.Trim(), page: 1, pageSize: 10, statoAttivitaId: null, tipoOrganizzazioneId: null, cancellationToken);
        if (!result.IsSuccess || result.Data is null)
        {
            return Array.Empty<OrgOption>();
        }

        return result.Data.Items.Select(o =>
        {
            var display = !string.IsNullOrWhiteSpace(o.PartitaIVA) ? $"{o.Denominazione} (P.IVA {o.PartitaIVA})" : o.Denominazione;
            return new OrgOption(o.OrganizzazioneId, display);
        });
    }

    private async Task SubmitAsync()
    {
        if (_isSubmitting) return;
        _errorMessage = null;

        if (!CanUpdate)
        {
            _errorMessage = "Accesso negato: permesso INC.UPDATE mancante.";
            return;
        }

        if (_detail is null)
        {
            _errorMessage = "Dettaglio non disponibile.";
            return;
        }

        if (_detail.DataCancellazione.HasValue)
        {
            _errorMessage = "Impossibile modificare un incarico cancellato.";
            return;
        }

        if (_form is not null)
        {
            await _form.Validate();
            if (!_form.IsValid) return;
        }

        if (_model.Persona is null || _model.Organizzazione is null)
        {
            _errorMessage = "Seleziona persona e organizzazione.";
            return;
        }

        if (_model.DataInizio is null)
        {
            _errorMessage = "Data inizio obbligatoria.";
            return;
        }

        _isSubmitting = true;
        try
        {
            var payload = new UpdateIncaricoRequest(
                _model.Persona.Id,
                _model.Organizzazione.Id,
                _model.Ruolo?.Id,
                _model.StatoIncarico,
                _model.DataInizio.Value.Date,
                _model.DataFine?.Date,
                _model.UnitaOrganizzativa?.Id);

            var result = await GatewayClient.UpdateIncaricoAsync(Id, payload, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                Snackbar.Add("Incarico aggiornato.", Severity.Success);
                Navigation.NavigateTo($"/incarichi/{Id}");
                return;
            }

            _errorMessage = result.Error ?? "Aggiornamento incarico non riuscito.";
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
