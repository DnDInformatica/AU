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

namespace Accredia.SIGAD.Web.Components.Pages.RisorseUmane;

public partial class NuovoDipendente : ComponentBase
{
private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs = new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("Risorse Umane"),
        new BreadcrumbItem("Dipendenti", "/risorse-umane/dipendenti"),
        new BreadcrumbItem("Nuovo")
    };

    private bool CanCreateDipendente => UserContext.HasPermission(PermessiSigad.RisorseUmane.Dipendenti.Creazione);

    private sealed class FormModel
    {
        public PersonaLookupItem? Persona { get; set; }
        public string Matricola { get; set; } = string.Empty;
        public int StatoDipendenteId { get; set; } = 1;
        public string? EmailAziendale { get; set; }
        public string? TelefonoInterno { get; set; }
    }

    private sealed class InlinePersonaModel
    {
        public string Cognome { get; set; } = string.Empty;
        public string Nome { get; set; } = string.Empty;
        public string? CodiceFiscale { get; set; }
        public DateTime? DataNascita { get; set; }
    }

    private readonly FormModel _model = new();
    private readonly InlinePersonaModel _inlinePersona = new();
    private MudForm? _form;
    private bool _isSubmitting;
    private string? _errorMessage;
    private DateTime? _dataAssunzione = DateTime.Today;
    private DateTime? _dataCessazione;
    private bool _createPersonaInline;

    private Task OnPersonaChanged(PersonaLookupItem? value)
    {
        _model.Persona = value;
        return Task.CompletedTask;
    }

    private Task OnCreatePersonaInlineChanged(bool value)
    {
        _createPersonaInline = value;
        _errorMessage = null;
        if (_createPersonaInline)
        {
            _model.Persona = null;
        }

        return Task.CompletedTask;
    }

    private Task OnDataAssunzioneChanged(DateTime? value)
    {
        _dataAssunzione = value;
        return Task.CompletedTask;
    }

    private Task OnDataCessazioneChanged(DateTime? value)
    {
        _dataCessazione = value;
        return Task.CompletedTask;
    }

    private Task OnInlineDataNascitaChanged(DateTime? value)
    {
        _inlinePersona.DataNascita = value;
        return Task.CompletedTask;
    }

    private async Task<IEnumerable<PersonaLookupItem>> SearchPersoneAsync(string text, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(text) || text.Trim().Length < 2)
        {
            _errorMessage = null;
            return Array.Empty<PersonaLookupItem>();
        }

        var query = text.Trim();
        var result = await GatewayClient.SearchPersoneRuLookupAsync(query, 1, 10, cancellationToken);
        if (result.IsSuccess && result.Data is not null)
        {
            _errorMessage = null;
            return result.Data.Items;
        }

        // Fallback: in caso di indisponibilita lookup RU, usa la ricerca Anagrafiche diretta.
        var fallback = await GatewayClient.SearchPersoneAsync(query, 1, 10, cancellationToken);
        if (fallback.IsSuccess && fallback.Data is not null)
        {
            _errorMessage = null;
            return fallback.Data.Items.Select(p => new PersonaLookupItem(
                p.PersonaId,
                p.Cognome,
                p.Nome,
                p.CodiceFiscale,
                p.DataNascita));
        }

        _errorMessage = "Ricerca persona temporaneamente non disponibile. Verifica Gateway/BFF/Anagrafiche.";
        return Array.Empty<PersonaLookupItem>();
    }

    private void Cancel()
        => Navigation.NavigateTo("/risorse-umane/dipendenti");

    private async Task SubmitAsync()
    {
        if (!CanCreateDipendente)
        {
            _errorMessage = "Il tuo profilo non consente di creare i dipendenti.";
            return;
        }

        if (_isSubmitting)
        {
            return;
        }

        _errorMessage = null;
        if (_form is not null)
        {
            await _form.Validate();
            if (!_form.IsValid)
            {
                return;
            }
        }

        var personaId = _model.Persona?.PersonaId;
        if (_createPersonaInline)
        {
            if (string.IsNullOrWhiteSpace(_inlinePersona.Cognome) || string.IsNullOrWhiteSpace(_inlinePersona.Nome))
            {
                _errorMessage = "Nome e cognome della persona sono obbligatori.";
                return;
            }

            if (_inlinePersona.DataNascita is null)
            {
                _errorMessage = "Data nascita persona obbligatoria.";
                return;
            }
        }
        else if (personaId is null)
        {
            _errorMessage = "Persona obbligatoria.";
            return;
        }

        if (_dataAssunzione is null)
        {
            _errorMessage = "Data assunzione obbligatoria.";
            return;
        }

        _isSubmitting = true;
        try
        {
            if (_createPersonaInline)
            {
                var personaPayload = new CreatePersonaRequest(
                    _inlinePersona.Cognome.Trim(),
                    _inlinePersona.Nome.Trim(),
                    string.IsNullOrWhiteSpace(_inlinePersona.CodiceFiscale) ? null : _inlinePersona.CodiceFiscale.Trim(),
                    _inlinePersona.DataNascita!.Value.Date);

                var personaResult = await GatewayClient.CreatePersonaAsync(personaPayload, CancellationToken.None);
                if (!personaResult.IsSuccess || personaResult.Data is null)
                {
                    _errorMessage = personaResult.Error ?? "Creazione persona inline non riuscita.";
                    return;
                }

                personaId = personaResult.Data.PersonaId;
                _model.Persona = new PersonaLookupItem(
                    personaResult.Data.PersonaId,
                    personaResult.Data.Cognome,
                    personaResult.Data.Nome,
                    personaResult.Data.CodiceFiscale,
                    personaResult.Data.DataNascita);
            }

            var request = new CreateDipendenteRequest(
                personaId!.Value,
                _model.Matricola.Trim(),
                _model.EmailAziendale,
                _model.TelefonoInterno,
                UnitaOrganizzativaId: null,
                ResponsabileDirettoId: null,
                DataAssunzione: DateOnly.FromDateTime(_dataAssunzione.Value.Date),
                DataCessazione: _dataCessazione.HasValue ? DateOnly.FromDateTime(_dataCessazione.Value.Date) : null,
                StatoDipendenteId: _model.StatoDipendenteId,
                AbilitatoAttivitaIspettiva: false,
                Note: null);

            var result = await GatewayClient.CreateDipendenteAsync(request, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                Snackbar.Add("Dipendente creato.", Severity.Success);
                Navigation.NavigateTo($"/risorse-umane/dipendenti/{result.Data.DipendenteId}");
                return;
            }

            _errorMessage = result.Error ?? "Creazione dipendente non riuscita.";
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