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

public partial class Modifica : ComponentBase
{
[Parameter] public int Id { get; set; }

    private IReadOnlyList<BreadcrumbItem> _breadcrumbs => new BreadcrumbItem[]
    {
        new("Home", "/"),
        new("Persone", "/persone"),
        new($"#{Id}", $"/persone/{Id}"),
        new("Modifica")
    };

    private sealed class FormModel
    {
        public string Cognome { get; set; } = string.Empty;
        public string Nome { get; set; } = string.Empty;
        public string? CodiceFiscale { get; set; }
        public DateTime? DataNascita { get; set; }
    }

    private PersonaDetail? _detail;
    private bool CanUpdate => UserContext.HasPermission("SIDAC.PERS.UPDATE");
    private bool CanDelete => UserContext.HasPermission("SIDAC.PERS.DELETE");
    private bool _isLoading = true;
    private string? _errorMessage;
    private readonly FormModel _model = new();
    private MudForm? _form;
    private bool _isSubmitting;

    protected override async Task OnParametersSetAsync()
        => await ReloadAsync();

    private async Task ReloadAsync()
    {
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
        _model.Cognome = _detail.Cognome;
        _model.Nome = _detail.Nome;
        _model.CodiceFiscale = _detail.CodiceFiscale;
        _model.DataNascita = _detail.DataNascita;

        _isLoading = false;
    }

    private Task OnDateChanged(DateTime? date)
    {
        _model.DataNascita = date;
        return Task.CompletedTask;
    }

    private void Cancel()
        => Navigation.NavigateTo($"/persone/{Id}");

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

        if (_model.DataNascita is null)
        {
            _errorMessage = "Data nascita obbligatoria.";
            return;
        }

        _isSubmitting = true;
        try
        {
            var payload = new UpdatePersonaRequest(
                _model.Cognome,
                _model.Nome,
                _model.CodiceFiscale,
                _model.DataNascita.Value);

            var result = await GatewayClient.UpdatePersonaAsync(Id, payload, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                Snackbar.Add("Persona aggiornata.", Severity.Success);
                Navigation.NavigateTo($"/persone/{result.Data.PersonaId}");
                return;
            }

            _errorMessage = result.Error ?? "Aggiornamento non riuscito.";
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

    private async Task SoftDeleteAsync()
    {
        if (!CanDelete)
        {
            Snackbar.Add("Accesso negato: permesso di eliminazione mancante.", Severity.Error);
            return;
        }

        if (_isSubmitting)
        {
            return;
        }

        var confirm = await DialogService.ShowMessageBox(
            "Conferma eliminazione",
            "Vuoi eliminare (soft delete) questa persona?",
            yesText: "Elimina",
            cancelText: "Annulla");

        if (confirm != true)
        {
            return;
        }

        _isSubmitting = true;
        try
        {
            var result = await GatewayClient.SoftDeletePersonaAsync(Id, CancellationToken.None);
            if (result.IsSuccess)
            {
                Snackbar.Add("Persona eliminata (soft).", Severity.Success);
                Navigation.NavigateTo("/persone");
                return;
            }

            _errorMessage = result.Error ?? "Eliminazione non riuscita.";
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