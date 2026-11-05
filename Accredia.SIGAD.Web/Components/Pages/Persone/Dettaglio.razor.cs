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

namespace Accredia.SIGAD.Web.Components.Pages.Persone;

public partial class Dettaglio : ComponentBase
{
[Parameter] public int Id { get; set; }

    private IReadOnlyList<BreadcrumbItem> _breadcrumbs => new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("Persone", "/persone"),
        new BreadcrumbItem(_detail is not null ? $"{_detail.Cognome} {_detail.Nome}" : $"#{Id}")
    };

    private string GetInitials()
    {
        if (_detail is null) return "?";
        var c = string.IsNullOrWhiteSpace(_detail.Cognome) ? "" : _detail.Cognome[..1];
        var n = string.IsNullOrWhiteSpace(_detail.Nome) ? "" : _detail.Nome[..1];
        return $"{c}{n}".ToUpperInvariant();
    }

    private const int TabOverview = 0;
    private const int TabIncarichi = 1;
    private const int TabIndirizzi = 2;
    private const int TabQualifiche = 3;
    private const int TabRelazioni = 4;
    private const int TabTitoli = 5;
    private const int TabConsensi = 6;
    private const int TabUtente = 7;
    private const int TabStorico = 8;

    private PersonaDetail? _detail;
    private bool CanRead => UserContext.HasPermission("PERS.LIST") || UserContext.HasPermission("PERS.READ");
    private bool CanUpdate => UserContext.HasPermission("PERS.UPDATE");
    private bool _isLoading = true;
    private string? _errorMessage;
    private int _activeTabIndex;

    private bool _incarichiLoaded;
    private bool _incarichiLoading;
    private string? _incarichiError;
    private bool _incarichiUnavailable;
    private IReadOnlyList<PersonaIncaricoItem> _incarichi = Array.Empty<PersonaIncaricoItem>();
    private bool _incarichiIncludeDeleted;

    private bool _contattiLoaded;
    private bool _contattiLoading;
    private string? _contattiError;
    private bool _contattiIncludeDeleted;
    private IReadOnlyList<PersonaEmailItem> _emailItems = Array.Empty<PersonaEmailItem>();
    private IReadOnlyList<PersonaTelefonoItem> _telefonoItems = Array.Empty<PersonaTelefonoItem>();
    private IReadOnlyList<ContactLookupItem> _emailLookups = Array.Empty<ContactLookupItem>();
    private IReadOnlyList<ContactLookupItem> _telefonoLookups = Array.Empty<ContactLookupItem>();

    private EmailFormModel _emailForm = new();
    private int? _emailEditId;
    private TelefonoFormModel _telefonoForm = new();
    private int? _telefonoEditId;

    private bool _indirizziLoaded;
    private bool _indirizziLoading;
    private string? _indirizziError;
    private bool _indirizziIncludeDeleted;
    private IReadOnlyList<ContactLookupItem> _indirizziLookups = Array.Empty<ContactLookupItem>();
    private IReadOnlyList<PersonaIndirizzoItem> _indirizziItems = Array.Empty<PersonaIndirizzoItem>();
    private IndirizzoFormModel _indirizzoForm = new();
    private int? _indirizzoEditId;

    private bool _qualificheLoaded;
    private bool _qualificheLoading;
    private string? _qualificheError;
    private bool _qualificheIncludeDeleted;
    private QualificheLookupsResponse _qualificheLookups = new(Array.Empty<TipoQualificaLookupItem>(), Array.Empty<EnteRilascioQualificaLookupItem>());
    private IReadOnlyList<PersonaQualificaItem> _qualificheItems = Array.Empty<PersonaQualificaItem>();
    private QualificaFormModel _qualificaForm = new();
    private int? _qualificaEditId;

    private bool _relazioniLoaded;
    private bool _relazioniLoading;
    private string? _relazioniError;
    private bool _relazioniIncludeDeleted;
    private IReadOnlyList<TipoRelazionePersonaleLookupItem> _relazioniLookups = Array.Empty<TipoRelazionePersonaleLookupItem>();
    private IReadOnlyList<PersonaRelazionePersonaleItem> _relazioniItems = Array.Empty<PersonaRelazionePersonaleItem>();
    private RelazioneFormModel _relazioneForm = new();
    private int? _relazioneEditId;

    private bool _titoliLoaded;
    private bool _titoliLoading;
    private string? _titoliError;
    private bool _titoliIncludeDeleted;
    private TitoliStudioLookupsResponse _titoliLookups = new(Array.Empty<TipoTitoloStudioLookupItem>());
    private IReadOnlyList<PersonaTitoloStudioItem> _titoliItems = Array.Empty<PersonaTitoloStudioItem>();
    private TitoloFormModel _titoloForm = new();
    private int? _titoloEditId;

    private bool _consensiLoaded;
    private bool _consensiLoading;
    private string? _consensiError;
    private bool _consensiIncludeDeleted;
    private IReadOnlyList<TipoFinalitaTrattamentoLookupItem> _consensiLookups = Array.Empty<TipoFinalitaTrattamentoLookupItem>();
    private IReadOnlyList<ConsensoPersonaItem> _consensiItems = Array.Empty<ConsensoPersonaItem>();
    private ConsensoFormModel _consensoForm = new();
    private int? _consensoEditId;

    private bool _utenteLoaded;
    private bool _utenteLoading;
    private string? _utenteError;
    private PersonaUtenteItem? _utenteItem;
    private UtenteFormModel _utenteForm = new();

    private bool _documentiCountLoaded;
    private int _documentiCount;

    private bool _storicoLoaded;
    private bool _storicoLoading;
    private string? _storicoError;
    private IReadOnlyList<PersonaStoricoEvent> _storicoPersona = Array.Empty<PersonaStoricoEvent>();
    private IReadOnlyList<PersonaEmailStoricoEvent> _storicoEmail = Array.Empty<PersonaEmailStoricoEvent>();
    private IReadOnlyList<PersonaTelefonoStoricoEvent> _storicoTelefoni = Array.Empty<PersonaTelefonoStoricoEvent>();
    private IReadOnlyList<PersonaIndirizzoStoricoEvent> _storicoIndirizzi = Array.Empty<PersonaIndirizzoStoricoEvent>();
    private IReadOnlyList<PersonaQualificaStoricoEvent> _storicoQualifiche = Array.Empty<PersonaQualificaStoricoEvent>();
    private IReadOnlyList<PersonaRelazionePersonaleStoricoEvent> _storicoRelazioni = Array.Empty<PersonaRelazionePersonaleStoricoEvent>();
    private IReadOnlyList<PersonaTitoloStudioStoricoEvent> _storicoTitoli = Array.Empty<PersonaTitoloStudioStoricoEvent>();
    private IReadOnlyList<ConsensoPersonaStoricoEvent> _storicoConsensi = Array.Empty<ConsensoPersonaStoricoEvent>();
    private IReadOnlyList<PersonaUtenteStoricoEvent> _storicoUtente = Array.Empty<PersonaUtenteStoricoEvent>();
    private int _richiesteGdprCorrelateCount;

    protected override async Task OnParametersSetAsync()
    {
        _activeTabIndex = TabOverview;
        _incarichiLoaded = false;
        _contattiLoaded = false;
        _indirizziLoaded = false;
        _qualificheLoaded = false;
        _relazioniLoaded = false;
        _titoliLoaded = false;
        _consensiLoaded = false;
        _utenteLoaded = false;
        _storicoLoaded = false;
        _documentiCountLoaded = false;
        _documentiCount = 0;
        _emailEditId = null;
        _telefonoEditId = null;
        _indirizzoEditId = null;
        _qualificaEditId = null;
        _relazioneEditId = null;
        _titoloEditId = null;
        _consensoEditId = null;
        _emailForm = new EmailFormModel();
        _telefonoForm = new TelefonoFormModel();
        _indirizzoForm = new IndirizzoFormModel();
        _qualificaForm = new QualificaFormModel();
        _relazioneForm = new RelazioneFormModel();
        _titoloForm = new TitoloFormModel();
        _consensoForm = new ConsensoFormModel();
        _utenteForm = new UtenteFormModel();
        await ReloadAsync();
    }

    private async Task ReloadAsync()
    {
        if (!CanRead)
        {
            _errorMessage = "Accesso negato: permesso di lettura mancante.";
            _detail = null;
            _isLoading = false;
            return;
        }

        _isLoading = true;
        _errorMessage = null;
        var result = await GatewayClient.GetPersonaDetailAsync(Id, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare il dettaglio persona.";
            _detail = null;
            _isLoading = false;
            return;
        }

        _detail = result.Data;
        await EnsureIncarichiAsync();
        await EnsureContattiAsync();
        _isLoading = false;
        await InvokeAsync(StateHasChanged);
    }

    private async Task OnTabChanged(int index)
    {
        _activeTabIndex = index;
        if (index == TabIncarichi) await EnsureIncarichiAsync();
        if (index == TabIndirizzi) await EnsureIndirizziAsync();
        if (index == TabQualifiche) await EnsureQualificheAsync();
        if (index == TabRelazioni) await EnsureRelazioniAsync();
        if (index == TabTitoli) await EnsureTitoliAsync();
        if (index == TabConsensi) await EnsureConsensiAsync();
        if (index == TabUtente) await EnsureUtenteAsync();
        if (index == TabStorico) await EnsureStoricoAsync();
    }

    private async Task EnsureIncarichiAsync(bool force = false)
    {
        if (_incarichiLoaded && !force) return;
        _incarichiLoading = true;
        _incarichiError = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var result = await GatewayClient.GetPersonaIncarichiAsync(Id, _incarichiIncludeDeleted, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                _incarichi = result.Data;
                _incarichiLoaded = true;
                return;
            }

            if (result.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                _incarichi = Array.Empty<PersonaIncaricoItem>();
                _incarichiUnavailable = true;
                _incarichiLoaded = true;
                return;
            }

            _incarichiError = result.Error ?? "Impossibile caricare gli incarichi.";
        }
        finally
        {
            _incarichiLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private Task OnContattiIncludeDeletedChanged()
    {
        _contattiLoaded = false;
        return EnsureContattiAsync(force: true);
    }

    private Task ReloadContattiAsync()
    {
        _contattiLoaded = false;
        return EnsureContattiAsync(force: true);
    }

    private async Task EnsureContattiAsync(bool force = false)
    {
        if (_contattiLoaded && !force) return;
        _contattiLoading = true;
        _contattiError = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var emailLookupsTask = GatewayClient.GetPersonaEmailLookupsAsync(CancellationToken.None);
            var telLookupsTask = GatewayClient.GetPersonaTelefonoLookupsAsync(CancellationToken.None);
            var emailTask = GatewayClient.GetPersonaEmailAsync(Id, _contattiIncludeDeleted, CancellationToken.None);
            var telTask = GatewayClient.GetPersonaTelefoniAsync(Id, _contattiIncludeDeleted, CancellationToken.None);
            await Task.WhenAll(emailLookupsTask, telLookupsTask, emailTask, telTask);

            var emailLookups = await emailLookupsTask;
            var telLookups = await telLookupsTask;
            var email = await emailTask;
            var tel = await telTask;

            if (!emailLookups.IsSuccess || !telLookups.IsSuccess || !email.IsSuccess || !tel.IsSuccess)
            {
                _contattiError = emailLookups.Error ?? telLookups.Error ?? email.Error ?? tel.Error ?? "Impossibile caricare contatti.";
                _contattiLoaded = false;
                return;
            }

            _emailLookups = emailLookups.Data ?? Array.Empty<ContactLookupItem>();
            _telefonoLookups = telLookups.Data ?? Array.Empty<ContactLookupItem>();
            _emailItems = email.Data ?? Array.Empty<PersonaEmailItem>();
            _telefonoItems = tel.Data ?? Array.Empty<PersonaTelefonoItem>();

            if (_emailForm.TipoEmailId == 0 && _emailLookups.Count > 0) _emailForm.TipoEmailId = _emailLookups[0].Id;
            if (_telefonoForm.TipoTelefonoId == 0 && _telefonoLookups.Count > 0) _telefonoForm.TipoTelefonoId = _telefonoLookups[0].Id;

            _contattiLoaded = true;
        }
        finally
        {
            _contattiLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private async Task SaveEmailAsync()
    {
        if (_emailForm.TipoEmailId <= 0 || string.IsNullOrWhiteSpace(_emailForm.Email))
        {
            _contattiError = "Compila tipo email e indirizzo email.";
            return;
        }

        var result = _emailEditId.HasValue
            ? await GatewayClient.UpdatePersonaEmailAsync(Id, _emailEditId.Value, new UpdatePersonaEmailRequest(_emailForm.TipoEmailId, _emailForm.Email.Trim(), false, false, null), CancellationToken.None)
            : await GatewayClient.CreatePersonaEmailAsync(Id, new CreatePersonaEmailRequest(_emailForm.TipoEmailId, _emailForm.Email.Trim(), false, false, null), CancellationToken.None);

        if (!result.IsSuccess)
        {
            _contattiError = result.Error ?? "Operazione email non riuscita.";
            return;
        }

        _emailEditId = null;
        _emailForm = new EmailFormModel();
        _contattiLoaded = false;
        await EnsureContattiAsync(force: true);
    }

    private void BeginEditEmail(PersonaEmailItem item)
    {
        _emailEditId = item.PersonaEmailId;
        _emailForm = new EmailFormModel { TipoEmailId = item.TipoEmailId, Email = item.Email };
    }

    private async Task DeleteEmailAsync(int personaEmailId)
    {
        var result = await GatewayClient.DeletePersonaEmailAsync(Id, personaEmailId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _contattiError = result.Error ?? "Eliminazione email non riuscita.";
            return;
        }

        _contattiLoaded = false;
        await EnsureContattiAsync(force: true);
    }

    private async Task SaveTelefonoAsync()
    {
        if (_telefonoForm.TipoTelefonoId <= 0 || string.IsNullOrWhiteSpace(_telefonoForm.Numero))
        {
            _contattiError = "Compila tipo telefono e numero.";
            return;
        }

        var numero = new string(_telefonoForm.Numero.Where(char.IsDigit).ToArray());
        if (string.IsNullOrWhiteSpace(numero))
        {
            _contattiError = "Il numero deve contenere cifre.";
            return;
        }

        var result = _telefonoEditId.HasValue
            ? await GatewayClient.UpdatePersonaTelefonoAsync(Id, _telefonoEditId.Value, new UpdatePersonaTelefonoRequest(_telefonoForm.TipoTelefonoId, NormalizePrefix(_telefonoForm.PrefissoInternazionale), numero, null, false, false, null), CancellationToken.None)
            : await GatewayClient.CreatePersonaTelefonoAsync(Id, new CreatePersonaTelefonoRequest(_telefonoForm.TipoTelefonoId, NormalizePrefix(_telefonoForm.PrefissoInternazionale), numero, null, false, false, null), CancellationToken.None);

        if (!result.IsSuccess)
        {
            _contattiError = result.Error ?? "Operazione telefono non riuscita.";
            return;
        }

        _telefonoEditId = null;
        _telefonoForm = new TelefonoFormModel();
        _contattiLoaded = false;
        await EnsureContattiAsync(force: true);
    }

    private void BeginEditTelefono(PersonaTelefonoItem item)
    {
        _telefonoEditId = item.PersonaTelefonoId;
        _telefonoForm = new TelefonoFormModel { TipoTelefonoId = item.TipoTelefonoId, PrefissoInternazionale = item.PrefissoInternazionale, Numero = item.Numero };
    }

    private async Task DeleteTelefonoAsync(int personaTelefonoId)
    {
        var result = await GatewayClient.DeletePersonaTelefonoAsync(Id, personaTelefonoId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _contattiError = result.Error ?? "Eliminazione telefono non riuscita.";
            return;
        }

        _contattiLoaded = false;
        await EnsureContattiAsync(force: true);
    }

    private Task OnIndirizziIncludeDeletedChanged()
    {
        _indirizziLoaded = false;
        return EnsureIndirizziAsync(force: true);
    }

    private Task ReloadIndirizziAsync()
    {
        _indirizziLoaded = false;
        return EnsureIndirizziAsync(force: true);
    }

    private async Task EnsureIndirizziAsync(bool force = false)
    {
        if (_indirizziLoaded && !force) return;
        _indirizziLoading = true;
        _indirizziError = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var lookupsTask = GatewayClient.GetPersonaIndirizziLookupsAsync(CancellationToken.None);
            var listTask = GatewayClient.GetPersonaIndirizziAsync(Id, _indirizziIncludeDeleted, CancellationToken.None);
            await Task.WhenAll(lookupsTask, listTask);
            var lookups = await lookupsTask;
            var list = await listTask;

            if (!lookups.IsSuccess || !list.IsSuccess)
            {
                _indirizziError = lookups.Error ?? list.Error ?? "Impossibile caricare indirizzi.";
                _indirizziLoaded = false;
                return;
            }

            _indirizziLookups = lookups.Data ?? Array.Empty<ContactLookupItem>();
            _indirizziItems = list.Data ?? Array.Empty<PersonaIndirizzoItem>();
            if (_indirizzoForm.TipoIndirizzoId == 0 && _indirizziLookups.Count > 0) _indirizzoForm.TipoIndirizzoId = _indirizziLookups[0].Id;
            _indirizziLoaded = true;
        }
        finally
        {
            _indirizziLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private void BeginEditIndirizzo(PersonaIndirizzoItem item)
    {
        _indirizzoEditId = item.PersonaIndirizzoId;
        _indirizzoForm = new IndirizzoFormModel
        {
            IndirizzoId = item.IndirizzoId,
            TipoIndirizzoId = item.TipoIndirizzoId,
            Principale = item.Principale,
            Attivo = item.Attivo
        };
    }

    private async Task SaveIndirizzoAsync()
    {
        if (_indirizzoForm.IndirizzoId <= 0 || _indirizzoForm.TipoIndirizzoId <= 0)
        {
            _indirizziError = "Compila IndirizzoId e tipo indirizzo.";
            return;
        }

        var result = _indirizzoEditId.HasValue
            ? await GatewayClient.UpdatePersonaIndirizzoAsync(Id, _indirizzoEditId.Value, new UpdatePersonaIndirizzoRequest(_indirizzoForm.IndirizzoId, _indirizzoForm.TipoIndirizzoId, _indirizzoForm.Principale, _indirizzoForm.Attivo), CancellationToken.None)
            : await GatewayClient.CreatePersonaIndirizzoAsync(Id, new CreatePersonaIndirizzoRequest(_indirizzoForm.IndirizzoId, _indirizzoForm.TipoIndirizzoId, _indirizzoForm.Principale, _indirizzoForm.Attivo), CancellationToken.None);

        if (!result.IsSuccess)
        {
            _indirizziError = result.Error ?? "Operazione indirizzo non riuscita.";
            return;
        }

        _indirizzoEditId = null;
        _indirizzoForm = new IndirizzoFormModel();
        _indirizziLoaded = false;
        await EnsureIndirizziAsync(force: true);
    }

    private async Task DeleteIndirizzoAsync(int personaIndirizzoId)
    {
        var result = await GatewayClient.DeletePersonaIndirizzoAsync(Id, personaIndirizzoId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _indirizziError = result.Error ?? "Eliminazione indirizzo non riuscita.";
            return;
        }

        _indirizziLoaded = false;
        await EnsureIndirizziAsync(force: true);
    }

    private Task OnQualificheIncludeDeletedChanged()
    {
        _qualificheLoaded = false;
        return EnsureQualificheAsync(force: true);
    }

    private Task ReloadQualificheAsync()
    {
        _qualificheLoaded = false;
        return EnsureQualificheAsync(force: true);
    }

    private async Task EnsureQualificheAsync(bool force = false)
    {
        if (_qualificheLoaded && !force) return;
        _qualificheLoading = true;
        _qualificheError = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var lookupsTask = GatewayClient.GetPersonaQualificheLookupsAsync(CancellationToken.None);
            var listTask = GatewayClient.GetPersonaQualificheAsync(Id, _qualificheIncludeDeleted, CancellationToken.None);
            await Task.WhenAll(lookupsTask, listTask);
            var lookups = await lookupsTask;
            var list = await listTask;

            if (!lookups.IsSuccess || !list.IsSuccess)
            {
                _qualificheError = lookups.Error ?? list.Error ?? "Impossibile caricare qualifiche.";
                _qualificheLoaded = false;
                return;
            }

            _qualificheLookups = lookups.Data ?? new QualificheLookupsResponse(Array.Empty<TipoQualificaLookupItem>(), Array.Empty<EnteRilascioQualificaLookupItem>());
            _qualificheItems = list.Data ?? Array.Empty<PersonaQualificaItem>();
            if (_qualificaForm.TipoQualificaId == 0 && _qualificheLookups.Tipi.Count > 0) _qualificaForm.TipoQualificaId = _qualificheLookups.Tipi[0].Id;
            _qualificheLoaded = true;
        }
        finally
        {
            _qualificheLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private void BeginEditQualifica(PersonaQualificaItem item)
    {
        _qualificaEditId = item.PersonaQualificaId;
        _qualificaForm = new QualificaFormModel
        {
            TipoQualificaId = item.TipoQualificaId,
            EnteRilascioQualificaId = item.EnteRilascioQualificaId,
            CodiceAttestato = item.CodiceAttestato,
            DataRilascio = item.DataRilascio,
            DataScadenza = item.DataScadenza,
            Valida = item.Valida,
            Note = item.Note
        };
    }

    private async Task SaveQualificaAsync()
    {
        if (_qualificaForm.TipoQualificaId <= 0)
        {
            _qualificheError = "Seleziona il tipo qualifica.";
            return;
        }

        var request = new CreatePersonaQualificaRequest(
            _qualificaForm.TipoQualificaId,
            _qualificaForm.EnteRilascioQualificaId,
            NullIfWhiteSpace(_qualificaForm.CodiceAttestato),
            _qualificaForm.DataRilascio,
            _qualificaForm.DataScadenza,
            _qualificaForm.Valida,
            NullIfWhiteSpace(_qualificaForm.Note));

        var result = _qualificaEditId.HasValue
            ? await GatewayClient.UpdatePersonaQualificaAsync(
                Id,
                _qualificaEditId.Value,
                new UpdatePersonaQualificaRequest(
                    request.TipoQualificaId,
                    request.EnteRilascioQualificaId,
                    request.CodiceAttestato,
                    request.DataRilascio,
                    request.DataScadenza,
                    request.Valida,
                    request.Note),
                CancellationToken.None)
            : await GatewayClient.CreatePersonaQualificaAsync(Id, request, CancellationToken.None);

        if (!result.IsSuccess)
        {
            _qualificheError = result.Error ?? "Operazione qualifica non riuscita.";
            return;
        }

        _qualificaEditId = null;
        _qualificaForm = new QualificaFormModel { Valida = true };
        _qualificheLoaded = false;
        await EnsureQualificheAsync(force: true);
    }

    private async Task DeleteQualificaAsync(int personaQualificaId)
    {
        var result = await GatewayClient.DeletePersonaQualificaAsync(Id, personaQualificaId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _qualificheError = result.Error ?? "Eliminazione qualifica non riuscita.";
            return;
        }

        _qualificheLoaded = false;
        await EnsureQualificheAsync(force: true);
    }

    private Task OnRelazioniIncludeDeletedChanged()
    {
        _relazioniLoaded = false;
        return EnsureRelazioniAsync(force: true);
    }

    private Task ReloadRelazioniAsync()
    {
        _relazioniLoaded = false;
        return EnsureRelazioniAsync(force: true);
    }

    private async Task EnsureRelazioniAsync(bool force = false)
    {
        if (_relazioniLoaded && !force) return;
        _relazioniLoading = true;
        _relazioniError = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var lookupsTask = GatewayClient.GetPersonaRelazioniPersonaliLookupsAsync(CancellationToken.None);
            var listTask = GatewayClient.GetPersonaRelazioniPersonaliAsync(Id, _relazioniIncludeDeleted, CancellationToken.None);
            await Task.WhenAll(lookupsTask, listTask);
            var lookups = await lookupsTask;
            var list = await listTask;

            if (!lookups.IsSuccess || !list.IsSuccess)
            {
                _relazioniError = lookups.Error ?? list.Error ?? "Impossibile caricare relazioni personali.";
                _relazioniLoaded = false;
                return;
            }

            _relazioniLookups = lookups.Data ?? Array.Empty<TipoRelazionePersonaleLookupItem>();
            _relazioniItems = list.Data ?? Array.Empty<PersonaRelazionePersonaleItem>();
            if (_relazioneForm.TipoRelazionePersonaleId == 0 && _relazioniLookups.Count > 0) _relazioneForm.TipoRelazionePersonaleId = _relazioniLookups[0].Id;
            _relazioniLoaded = true;
        }
        finally
        {
            _relazioniLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private void BeginEditRelazione(PersonaRelazionePersonaleItem item)
    {
        _relazioneEditId = item.PersonaRelazionePersonaleId;
        _relazioneForm = new RelazioneFormModel
        {
            PersonaCollegataId = item.PersonaCollegataId,
            TipoRelazionePersonaleId = item.TipoRelazionePersonaleId,
            Note = item.Note
        };
    }

    private async Task SaveRelazioneAsync()
    {
        if (_relazioneForm.PersonaCollegataId <= 0 || _relazioneForm.TipoRelazionePersonaleId <= 0)
        {
            _relazioniError = "Compila Persona collegata e tipo relazione.";
            return;
        }

        var request = new CreatePersonaRelazionePersonaleRequest(
            _relazioneForm.PersonaCollegataId,
            _relazioneForm.TipoRelazionePersonaleId,
            NullIfWhiteSpace(_relazioneForm.Note));

        var result = _relazioneEditId.HasValue
            ? await GatewayClient.UpdatePersonaRelazionePersonaleAsync(
                Id,
                _relazioneEditId.Value,
                new UpdatePersonaRelazionePersonaleRequest(
                    request.PersonaCollegataId,
                    request.TipoRelazionePersonaleId,
                    request.Note),
                CancellationToken.None)
            : await GatewayClient.CreatePersonaRelazionePersonaleAsync(Id, request, CancellationToken.None);

        if (!result.IsSuccess)
        {
            _relazioniError = result.Error ?? "Operazione relazione non riuscita.";
            return;
        }

        _relazioneEditId = null;
        _relazioneForm = new RelazioneFormModel();
        _relazioniLoaded = false;
        await EnsureRelazioniAsync(force: true);
    }

    private async Task DeleteRelazioneAsync(int personaRelazionePersonaleId)
    {
        var result = await GatewayClient.DeletePersonaRelazionePersonaleAsync(Id, personaRelazionePersonaleId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _relazioniError = result.Error ?? "Eliminazione relazione non riuscita.";
            return;
        }

        _relazioniLoaded = false;
        await EnsureRelazioniAsync(force: true);
    }

    private Task OnTitoliIncludeDeletedChanged()
    {
        _titoliLoaded = false;
        return EnsureTitoliAsync(force: true);
    }

    private Task ReloadTitoliAsync()
    {
        _titoliLoaded = false;
        return EnsureTitoliAsync(force: true);
    }

    private async Task EnsureTitoliAsync(bool force = false)
    {
        if (_titoliLoaded && !force) return;
        _titoliLoading = true;
        _titoliError = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var lookupsTask = GatewayClient.GetPersonaTitoliStudioLookupsAsync(CancellationToken.None);
            var listTask = GatewayClient.GetPersonaTitoliStudioAsync(Id, _titoliIncludeDeleted, CancellationToken.None);
            await Task.WhenAll(lookupsTask, listTask);
            var lookups = await lookupsTask;
            var list = await listTask;

            if (!lookups.IsSuccess || !list.IsSuccess)
            {
                _titoliError = lookups.Error ?? list.Error ?? "Impossibile caricare titoli di studio.";
                _titoliLoaded = false;
                return;
            }

            _titoliLookups = lookups.Data ?? new TitoliStudioLookupsResponse(Array.Empty<TipoTitoloStudioLookupItem>());
            _titoliItems = list.Data ?? Array.Empty<PersonaTitoloStudioItem>();
            if (_titoloForm.TipoTitoloStudioId == 0 && _titoliLookups.Tipi.Count > 0) _titoloForm.TipoTitoloStudioId = _titoliLookups.Tipi[0].Id;
            _titoliLoaded = true;
        }
        finally
        {
            _titoliLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private void BeginEditTitolo(PersonaTitoloStudioItem item)
    {
        _titoloEditId = item.PersonaTitoloStudioId;
        _titoloForm = new TitoloFormModel
        {
            TipoTitoloStudioId = item.TipoTitoloStudioId,
            Istituzione = item.Istituzione,
            Corso = item.Corso,
            DataConseguimento = item.DataConseguimento,
            Voto = item.Voto,
            Lode = item.Lode,
            Paese = item.Paese,
            Note = item.Note,
            Principale = item.Principale
        };
    }

    private async Task SaveTitoloAsync()
    {
        if (_titoloForm.TipoTitoloStudioId <= 0)
        {
            _titoliError = "Seleziona il tipo titolo di studio.";
            return;
        }

        var request = new CreatePersonaTitoloStudioRequest(
            _titoloForm.TipoTitoloStudioId,
            NullIfWhiteSpace(_titoloForm.Istituzione),
            NullIfWhiteSpace(_titoloForm.Corso),
            _titoloForm.DataConseguimento,
            NullIfWhiteSpace(_titoloForm.Voto),
            _titoloForm.Lode,
            NullIfWhiteSpace(_titoloForm.Paese),
            NullIfWhiteSpace(_titoloForm.Note),
            _titoloForm.Principale);

        var result = _titoloEditId.HasValue
            ? await GatewayClient.UpdatePersonaTitoloStudioAsync(
                Id,
                _titoloEditId.Value,
                new UpdatePersonaTitoloStudioRequest(
                    request.TipoTitoloStudioId,
                    request.Istituzione,
                    request.Corso,
                    request.DataConseguimento,
                    request.Voto,
                    request.Lode,
                    request.Paese,
                    request.Note,
                    request.Principale),
                CancellationToken.None)
            : await GatewayClient.CreatePersonaTitoloStudioAsync(Id, request, CancellationToken.None);

        if (!result.IsSuccess)
        {
            _titoliError = result.Error ?? "Operazione titolo non riuscita.";
            return;
        }

        _titoloEditId = null;
        _titoloForm = new TitoloFormModel();
        _titoliLoaded = false;
        await EnsureTitoliAsync(force: true);
    }

    private async Task DeleteTitoloAsync(int personaTitoloStudioId)
    {
        var result = await GatewayClient.DeletePersonaTitoloStudioAsync(Id, personaTitoloStudioId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _titoliError = result.Error ?? "Eliminazione titolo non riuscita.";
            return;
        }

        _titoliLoaded = false;
        await EnsureTitoliAsync(force: true);
    }

    private Task OnConsensiIncludeDeletedChanged()
    {
        _consensiLoaded = false;
        return EnsureConsensiAsync(force: true);
    }

    private Task ReloadConsensiAsync()
    {
        _consensiLoaded = false;
        return EnsureConsensiAsync(force: true);
    }

    private async Task EnsureConsensiAsync(bool force = false)
    {
        if (_consensiLoaded && !force) return;
        _consensiLoading = true;
        _consensiError = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var lookupsTask = GatewayClient.GetPersonaConsensiLookupsAsync(CancellationToken.None);
            var listTask = GatewayClient.GetPersonaConsensiAsync(Id, _consensiIncludeDeleted, CancellationToken.None);
            await Task.WhenAll(lookupsTask, listTask);
            var lookups = await lookupsTask;
            var list = await listTask;

            if (!lookups.IsSuccess || !list.IsSuccess)
            {
                _consensiError = lookups.Error ?? list.Error ?? "Impossibile caricare consensi.";
                _consensiLoaded = false;
                return;
            }

            _consensiLookups = lookups.Data ?? Array.Empty<TipoFinalitaTrattamentoLookupItem>();
            _consensiItems = list.Data ?? Array.Empty<ConsensoPersonaItem>();
            if (_consensoForm.TipoFinalitaTrattamentoId == 0 && _consensiLookups.Count > 0) _consensoForm.TipoFinalitaTrattamentoId = _consensiLookups[0].Id;
            _consensiLoaded = true;
        }
        finally
        {
            _consensiLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private void BeginEditConsenso(ConsensoPersonaItem item)
    {
        _consensoEditId = item.ConsensoPersonaId;
        _consensoForm = new ConsensoFormModel
        {
            TipoFinalitaTrattamentoId = item.TipoFinalitaTrattamentoId,
            Consenso = item.Consenso,
            DataConsenso = item.DataConsenso,
            DataScadenza = item.DataScadenza,
            DataRevoca = item.DataRevoca,
            ModalitaAcquisizione = item.ModalitaAcquisizione,
            ModalitaRevoca = item.ModalitaRevoca,
            RiferimentoDocumento = item.RiferimentoDocumento,
            IPAddress = item.IPAddress,
            UserAgent = item.UserAgent,
            MotivoRevoca = item.MotivoRevoca,
            VersioneInformativa = item.VersioneInformativa,
            DataInformativa = item.DataInformativa,
            Note = item.Note
        };
    }

    private async Task SaveConsensoAsync()
    {
        if (_consensoForm.TipoFinalitaTrattamentoId <= 0 || string.IsNullOrWhiteSpace(_consensoForm.ModalitaAcquisizione))
        {
            _consensiError = "Compila finalita e modalita acquisizione.";
            return;
        }

        var request = new CreateConsensoPersonaRequest(
            _consensoForm.TipoFinalitaTrattamentoId,
            _consensoForm.Consenso,
            _consensoForm.DataConsenso ?? DateTime.UtcNow,
            _consensoForm.DataScadenza,
            _consensoForm.DataRevoca,
            _consensoForm.ModalitaAcquisizione.Trim(),
            NullIfWhiteSpace(_consensoForm.ModalitaRevoca),
            NullIfWhiteSpace(_consensoForm.RiferimentoDocumento),
            NullIfWhiteSpace(_consensoForm.IPAddress),
            NullIfWhiteSpace(_consensoForm.UserAgent),
            NullIfWhiteSpace(_consensoForm.MotivoRevoca),
            NullIfWhiteSpace(_consensoForm.VersioneInformativa),
            _consensoForm.DataInformativa,
            NullIfWhiteSpace(_consensoForm.Note));

        var result = _consensoEditId.HasValue
            ? await GatewayClient.UpdatePersonaConsensoAsync(
                Id,
                _consensoEditId.Value,
                new UpdateConsensoPersonaRequest(
                    request.TipoFinalitaTrattamentoId,
                    request.Consenso,
                    request.DataConsenso,
                    request.DataScadenza,
                    request.DataRevoca,
                    request.ModalitaAcquisizione,
                    request.ModalitaRevoca,
                    request.RiferimentoDocumento,
                    request.IPAddress,
                    request.UserAgent,
                    request.MotivoRevoca,
                    request.VersioneInformativa,
                    request.DataInformativa,
                    request.Note),
                CancellationToken.None)
            : await GatewayClient.CreatePersonaConsensoAsync(Id, request, CancellationToken.None);

        if (!result.IsSuccess)
        {
            _consensiError = result.Error ?? "Operazione consenso non riuscita.";
            return;
        }

        _consensoEditId = null;
        _consensoForm = new ConsensoFormModel();
        _consensiLoaded = false;
        await EnsureConsensiAsync(force: true);
    }

    private async Task DeleteConsensoAsync(int consensoPersonaId)
    {
        var result = await GatewayClient.DeletePersonaConsensoAsync(Id, consensoPersonaId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _consensiError = result.Error ?? "Eliminazione consenso non riuscita.";
            return;
        }

        _consensiLoaded = false;
        await EnsureConsensiAsync(force: true);
    }

    private Task ReloadUtenteAsync()
    {
        _utenteLoaded = false;
        return EnsureUtenteAsync(force: true);
    }

    private async Task EnsureUtenteAsync(bool force = false)
    {
        if (_utenteLoaded && !force) return;
        _utenteLoading = true;
        _utenteError = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var result = await GatewayClient.GetPersonaUtenteAsync(Id, true, CancellationToken.None);
            if (!result.IsSuccess)
            {
                if (result.StatusCode == System.Net.HttpStatusCode.NotFound)
                {
                    _utenteItem = null;
                    _utenteLoaded = true;
                    return;
                }

                _utenteError = result.Error ?? "Impossibile caricare utente associato.";
                _utenteLoaded = false;
                return;
            }

            _utenteItem = result.Data;
            _utenteForm.UserId = _utenteItem?.UserId ?? string.Empty;
            _utenteLoaded = true;
        }
        finally
        {
            _utenteLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private async Task SaveUtenteAsync()
    {
        if (string.IsNullOrWhiteSpace(_utenteForm.UserId))
        {
            _utenteError = "Compila UserId.";
            return;
        }

        var request = new CreatePersonaUtenteRequest(_utenteForm.UserId.Trim());
        var result = _utenteItem is null
            ? await GatewayClient.CreatePersonaUtenteAsync(Id, request, CancellationToken.None)
            : await GatewayClient.UpdatePersonaUtenteAsync(Id, _utenteItem.PersonaUtenteId, new UpdatePersonaUtenteRequest(request.UserId), CancellationToken.None);

        if (!result.IsSuccess)
        {
            _utenteError = result.Error ?? "Operazione utente non riuscita.";
            return;
        }

        _utenteLoaded = false;
        await EnsureUtenteAsync(force: true);
    }

    private async Task DeleteUtenteAsync(int personaUtenteId)
    {
        var result = await GatewayClient.DeletePersonaUtenteAsync(Id, personaUtenteId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _utenteError = result.Error ?? "Eliminazione utente non riuscita.";
            return;
        }

        _utenteLoaded = false;
        await EnsureUtenteAsync(force: true);
    }

    private async Task EnsureStoricoAsync(bool force = false)
    {
        if (_storicoLoaded && !force) return;
        _storicoLoading = true;
        _storicoError = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var pTask = GatewayClient.GetPersonaStoricoAsync(Id, CancellationToken.None);
            var eTask = GatewayClient.GetPersonaStoricoEmailAsync(Id, CancellationToken.None);
            var tTask = GatewayClient.GetPersonaStoricoTelefoniAsync(Id, CancellationToken.None);
            var iTask = GatewayClient.GetPersonaStoricoIndirizziAsync(Id, CancellationToken.None);
            var qTask = GatewayClient.GetPersonaStoricoQualificheAsync(Id, CancellationToken.None);
            var rTask = GatewayClient.GetPersonaStoricoRelazioniPersonaliAsync(Id, CancellationToken.None);
            var tsTask = GatewayClient.GetPersonaStoricoTitoliStudioAsync(Id, CancellationToken.None);
            var cTask = GatewayClient.GetPersonaStoricoConsensiAsync(Id, CancellationToken.None);
            var uTask = GatewayClient.GetPersonaStoricoUtenteAsync(Id, CancellationToken.None);
            var rgTask = GatewayClient.GetRichiesteGdprAsync(Id, includeDeleted: true, CancellationToken.None);

            await Task.WhenAll(pTask, eTask, tTask, iTask, qTask, rTask, tsTask, cTask, uTask, rgTask);
            var p = await pTask;
            var e = await eTask;
            var t = await tTask;
            var i = await iTask;
            var q = await qTask;
            var r = await rTask;
            var ts = await tsTask;
            var c = await cTask;
            var u = await uTask;
            var rg = await rgTask;

            if (!p.IsSuccess || !e.IsSuccess || !t.IsSuccess || !i.IsSuccess || !q.IsSuccess || !r.IsSuccess || !ts.IsSuccess || !c.IsSuccess || !u.IsSuccess || !rg.IsSuccess)
            {
                _storicoError = p.Error ?? e.Error ?? t.Error ?? i.Error ?? q.Error ?? r.Error ?? ts.Error ?? c.Error ?? u.Error ?? rg.Error ?? "Impossibile caricare storico.";
                _storicoLoaded = false;
                return;
            }

            _storicoPersona = p.Data ?? Array.Empty<PersonaStoricoEvent>();
            _storicoEmail = e.Data ?? Array.Empty<PersonaEmailStoricoEvent>();
            _storicoTelefoni = t.Data ?? Array.Empty<PersonaTelefonoStoricoEvent>();
            _storicoIndirizzi = i.Data ?? Array.Empty<PersonaIndirizzoStoricoEvent>();
            _storicoQualifiche = q.Data ?? Array.Empty<PersonaQualificaStoricoEvent>();
            _storicoRelazioni = r.Data ?? Array.Empty<PersonaRelazionePersonaleStoricoEvent>();
            _storicoTitoli = ts.Data ?? Array.Empty<PersonaTitoloStudioStoricoEvent>();
            _storicoConsensi = c.Data ?? Array.Empty<ConsensoPersonaStoricoEvent>();
            _storicoUtente = u.Data ?? Array.Empty<PersonaUtenteStoricoEvent>();
            _richiesteGdprCorrelateCount = rg.Data?.Count ?? 0;
            _storicoLoaded = true;
        }
        finally
        {
            _storicoLoading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private string GetIncarichiTabText() => _incarichiLoaded ? $"Incarichi ({_incarichi.Count})" : "Incarichi (...)";
    private string GetIndirizziTabText() => _indirizziLoaded ? $"Indirizzi ({_indirizziItems.Count})" : "Indirizzi (...)";
    private string GetQualificheTabText() => _qualificheLoaded ? $"Qualifiche ({_qualificheItems.Count})" : "Qualifiche (...)";
    private string GetRelazioniPersonaliTabText() => _relazioniLoaded ? $"Relazioni personali ({_relazioniItems.Count})" : "Relazioni personali (...)";
    private string GetTitoliStudioTabText() => _titoliLoaded ? $"Titoli studio ({_titoliItems.Count})" : "Titoli studio (...)";
    private string GetConsensiTabText() => _consensiLoaded ? $"Consensi ({_consensiItems.Count})" : "Consensi (...)";
    private string GetUtenteTabText() => _utenteLoaded ? (_utenteItem is null ? "Utente (0)" : "Utente (1)") : "Utente (...)";
    private string GetDocumentiTabText() => _documentiCountLoaded ? $"Documenti ({_documentiCount})" : "Documenti (...)";

    private void OnDocumentiCountChanged(int count)
    {
        _documentiCount = count;
        _documentiCountLoaded = true;
    }
    private string GetEmailTipoLabel(int id) => _emailLookups.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();
    private string GetTelefonoTipoLabel(int id) => _telefonoLookups.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();
    private string GetIndirizzoTipoLabel(int id) => _indirizziLookups.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();
    private string GetTipoQualificaLabel(int id) => _qualificheLookups.Tipi.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();
    private string GetTipoRelazioneLabel(int id) => _relazioniLookups.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();
    private string GetTipoTitoloStudioLabel(int id) => _titoliLookups.Tipi.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();
    private string GetTipoFinalitaLabel(int id) => _consensiLookups.FirstOrDefault(x => x.Id == id)?.Description ?? id.ToString();

    private static string FormatTelefono(PersonaTelefonoItem item) => FormatTelefono(item.PrefissoInternazionale, item.Numero, item.Estensione);
    private static string FormatTelefono(string? prefisso, string numero, string? estensione)
        => string.Join(" ", new[] { string.IsNullOrWhiteSpace(prefisso) ? null : prefisso.Trim(), numero, string.IsNullOrWhiteSpace(estensione) ? null : $"int. {estensione.Trim()}" }.Where(static x => !string.IsNullOrWhiteSpace(x)));

    private static string? NormalizePrefix(string? prefisso)
    {
        if (string.IsNullOrWhiteSpace(prefisso)) return null;
        var clean = new string(prefisso.Trim().Where(ch => char.IsDigit(ch) || ch == '+').ToArray());
        return string.IsNullOrWhiteSpace(clean) ? null : clean;
    }

    private static string? NullIfWhiteSpace(string? value)
        => string.IsNullOrWhiteSpace(value) ? null : value.Trim();

    private static string GetInitials(PersonaDetail detail)
    {
        var c = string.IsNullOrWhiteSpace(detail.Cognome) ? "?" : detail.Cognome.Trim();
        var n = string.IsNullOrWhiteSpace(detail.Nome) ? string.Empty : detail.Nome.Trim();
        return string.Concat(c[0], n.Length > 0 ? n[0] : '?').ToUpperInvariant();
    }

    private sealed class EmailFormModel
    {
        public int TipoEmailId { get; set; }
        public string Email { get; set; } = string.Empty;
    }

    private sealed class TelefonoFormModel
    {
        public int TipoTelefonoId { get; set; }
        public string? PrefissoInternazionale { get; set; }
        public string Numero { get; set; } = string.Empty;
    }

    private sealed class IndirizzoFormModel
    {
        public int IndirizzoId { get; set; }
        public int TipoIndirizzoId { get; set; }
        public bool Principale { get; set; }
        public bool Attivo { get; set; } = true;
    }

    private sealed class QualificaFormModel
    {
        public int TipoQualificaId { get; set; }
        public int? EnteRilascioQualificaId { get; set; }
        public string? CodiceAttestato { get; set; }
        public DateTime? DataRilascio { get; set; }
        public DateTime? DataScadenza { get; set; }
        public bool Valida { get; set; } = true;
        public string? Note { get; set; }
    }

    private sealed class RelazioneFormModel
    {
        public int PersonaCollegataId { get; set; }
        public int TipoRelazionePersonaleId { get; set; }
        public string? Note { get; set; }
    }

    private sealed class TitoloFormModel
    {
        public int TipoTitoloStudioId { get; set; }
        public string? Istituzione { get; set; }
        public string? Corso { get; set; }
        public DateTime? DataConseguimento { get; set; }
        public string? Voto { get; set; }
        public bool Lode { get; set; }
        public string? Paese { get; set; }
        public string? Note { get; set; }
        public bool Principale { get; set; }
    }

    private sealed class ConsensoFormModel
    {
        public int TipoFinalitaTrattamentoId { get; set; }
        public bool Consenso { get; set; } = true;
        public DateTime? DataConsenso { get; set; }
        public DateTime? DataScadenza { get; set; }
        public DateTime? DataRevoca { get; set; }
        public string ModalitaAcquisizione { get; set; } = "Portale";
        public string? ModalitaRevoca { get; set; }
        public string? RiferimentoDocumento { get; set; }
        public string? IPAddress { get; set; }
        public string? UserAgent { get; set; }
        public string? MotivoRevoca { get; set; }
        public string? VersioneInformativa { get; set; }
        public DateTime? DataInformativa { get; set; }
        public string? Note { get; set; }
    }

    private sealed class UtenteFormModel
    {
        public string UserId { get; set; } = string.Empty;
    }
}
