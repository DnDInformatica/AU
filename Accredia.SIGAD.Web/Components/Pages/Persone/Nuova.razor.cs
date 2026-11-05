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

public partial class Nuova : ComponentBase
{
private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs = new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("Persone", "/persone"),
        new BreadcrumbItem("Nuova")
    };

    private sealed class FormModel
    {
        public string Cognome { get; set; } = string.Empty;
        public string Nome { get; set; } = string.Empty;
        public string? CodiceFiscale { get; set; }
        public DateTime? DataNascita { get; set; }
    }

    private readonly FormModel _model = new();
    private bool CanCreate => UserContext.HasPermission("SIDAC.PERS.CREATE");
    private MudForm? _form;
    private bool _isSubmitting;
    private string? _errorMessage;

    private void Cancel()
        => Navigation.NavigateTo("/persone");

    private Task OnDateChanged(DateTime? date)
    {
        _model.DataNascita = date;
        return Task.CompletedTask;
    }

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
            var payload = new CreatePersonaRequest(
                _model.Cognome,
                _model.Nome,
                _model.CodiceFiscale,
                _model.DataNascita.Value);

            var result = await GatewayClient.CreatePersonaAsync(payload, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                Snackbar.Add("Persona creata.", Severity.Success);
                Navigation.NavigateTo($"/persone/{result.Data.PersonaId}");
                return;
            }

            _errorMessage = result.Error ?? "Creazione persona non riuscita.";
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