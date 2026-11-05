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

namespace Accredia.SIGAD.Web.Components.Pages;

public partial class Login : ComponentBase
{
private readonly LoginFormModel _model = new();
    private MudForm? _form;
    private bool _isSubmitting;
    private string? _errorMessage;
    private bool _jsAvailable;

    private string _submitLabel => _isSubmitting ? "Accesso in corso..." : "Login";

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (firstRender && !_jsAvailable)
        {
            _jsAvailable = true;
            TokenService.MarkJsAvailable();
            // State changes in OnAfterRender require an explicit re-render.
            await InvokeAsync(StateHasChanged);
        }
    }

    private async Task OnPasswordKeyDown(KeyboardEventArgs args)
    {
        if (args.Key == "Enter")
        {
            await HandleLoginClicked(default);
        }
    }

    private async Task HandleLoginClicked(MouseEventArgs _)
    {
        await HandleLogin();
    }

    private async Task HandleLogin()
    {
        if (_isSubmitting)
        {
            return;
        }

        try
        {
            if (_form is null)
            {
                _errorMessage = "Form non inizializzata. Ricarica la pagina e riprova.";
                return;
            }

            await _form.Validate();
            if (!_form.IsValid)
            {
                _errorMessage = "Verifica i campi evidenziati e riprova.";
                return;
            }

            _isSubmitting = true;
            _errorMessage = null;
            await InvokeAsync(StateHasChanged); // mostra subito "Accesso in corso..."

            var result = await GatewayClient.LoginAsync(new LoginRequest(_model.Username, _model.Password), CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                // Salva i token usando TokenService con supporto RememberMe
                await TokenService.SaveTokensAsync(
                    result.Data.AccessToken,
                    result.Data.RefreshToken,
                    result.Data.ExpiresInSeconds,
                    _model.RememberMe);

                // Notifica AuthProvider (per compatibilità)
                await AuthProvider.SignInAsync(result.Data.AccessToken, result.Data.RefreshToken, result.Data.ExpiresInSeconds);

                // Keep the same circuit so the AuthenticationStateProvider update takes effect immediately.
                Navigation.NavigateTo("/");
                return;
            }

            _errorMessage = result.Error ?? "Login non riuscito.";
        }
        catch (Exception ex)
        {
            // Non loggare mai password/token: qui logghiamo solo il tipo errore + contesto.
            Logger.LogError(ex, "Errore non gestito durante il login.");
            _errorMessage = "Errore durante il login. Verifica lo stato dei servizi e riprova.";
        }
        finally
        {
            _isSubmitting = false;
        }
    }

    private sealed class LoginFormModel
    {
        public string Username { get; set; } = string.Empty;

        public string Password { get; set; } = string.Empty;

        /// <summary>
        /// OPZIONE C - HYBRID STORAGE:
        /// - true: Token salvati in LocalStorage (persistono tra sessioni)
        /// - false: Token salvati in SessionStorage (cleared on tab close)
        /// </summary>
        public bool RememberMe { get; set; }
    }
}