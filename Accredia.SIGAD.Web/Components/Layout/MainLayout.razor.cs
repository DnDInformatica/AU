using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.JSInterop;
using MudBlazor;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Models.Search;
using Accredia.SIGAD.Web.Models.Tipologiche;
using Accredia.SIGAD.Web.Services;
using BreadcrumbItem = Accredia.SIGAD.Web.Models.Common.BreadcrumbItem;

namespace Accredia.SIGAD.Web.Components.Layout;

public partial class MainLayout : LayoutComponentBase
{
private bool _drawerOpen = true;
    private bool _authInitialized;
    private bool _disposed;

    private void ToggleDrawer()
    {
        _drawerOpen = !_drawerOpen;
        Logger.LogInformation("Sidebar toggle clicked. Open={Open}", _drawerOpen);
    }

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (firstRender && !_authInitialized)
        {
            _authInitialized = true;

            // NOTE: auth initialization is performed in Routes.razor so it runs even when MainLayout is not rendered.
            await UserContext.EnsureLoadedAsync();
            // UserContext is loaded asynchronously after the first paint; trigger a re-render so NavMenu updates immediately.
            await InvokeAsync(StateHasChanged);

            // AVVIA TokenRefreshService per auto-refresh token
            // Questo previene logout improvvisi ogni 15 minuti
            var authState = await AuthStateProvider.GetAuthenticationStateAsync();
            if (authState.User.Identity?.IsAuthenticated == true)
            {
                TokenRefreshService.Start();
            }
        }
    }

    private async Task Logout()
    {
        // Ferma il TokenRefreshService
        TokenRefreshService.Stop();

        // Esegue logout via API
        var refreshToken = await TokenService.GetRefreshTokenAsync();
        if (!string.IsNullOrWhiteSpace(refreshToken))
        {
            _ = await GatewayClient.LogoutAsync(refreshToken, CancellationToken.None);
        }

        // Pulisce token e stato
        await TokenService.ClearAllAsync();
        UserContext.Reset();
        await AuthProvider.SignOutAsync();
        Navigation.NavigateTo("/login", forceLoad: true);
    }

    protected override void OnInitialized()
    {
        AuthStateProvider.AuthenticationStateChanged += OnAuthenticationStateChanged;
    }

    private async void OnAuthenticationStateChanged(Task<AuthenticationState> task)
    {
        if (_disposed)
        {
            return;
        }

        UserContext.Reset();
        try
        {
            await InvokeAsync(async () =>
            {
                if (_disposed)
                {
                    return;
                }

                await UserContext.EnsureLoadedAsync();

                // Avvia/Ferma TokenRefreshService basato sullo stato auth
                var authState = await task;
                if (authState.User.Identity?.IsAuthenticated == true)
                {
                    TokenRefreshService.Start();
                }
                else
                {
                    TokenRefreshService.Stop();
                }

                StateHasChanged();
            });
        }
        catch (Exception ex)
        {
            // Avoid tearing down the circuit for a late auth change after disconnect.
            Logger.LogDebug(ex, "AuthenticationStateChanged ignored (layout disposing/disconnected).");
        }
    }

    private string GetUsername()
        => UserContext.Current?.Username ?? "Utente";

    private string GetUserInitials()
    {
        var username = GetUsername();
        if (string.IsNullOrWhiteSpace(username))
        {
            return "U";
        }

        var parts = username.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length == 1)
        {
            return parts[0][..1].ToUpperInvariant();
        }

        return string.Concat(parts[0][..1], parts[^1][..1]).ToUpperInvariant();
    }

    private string GetUserProfileImageUrl()
    {
        // TODO: Implementare recupero URL immagine profilo da UserContext
        // Esempio: return UserContext.Current?.ProfileImageUrl ?? string.Empty;
        return string.Empty;
    }

    private string GetUserRoleSummary()
    {
        if (UserContext.Current?.Roles is not { Count: > 0 })
        {
            return "Nessun ruolo";
        }

        return string.Join(", ", UserContext.Current.Roles);
    }

    public void Dispose()
    {
        _disposed = true;
        AuthStateProvider.AuthenticationStateChanged -= OnAuthenticationStateChanged;
        TokenRefreshService.Stop();
    }
}