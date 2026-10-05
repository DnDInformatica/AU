using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Claims;
using Accredia.SIGAD.Web.Services;

namespace Accredia.SIGAD.Web.Auth;

/// <summary>
/// Stato di autenticazione derivato dal profilo demo (funzionamento Portale):
/// sempre autenticato quando il profilo e' abilitato, senza pagina di login.
/// </summary>
internal sealed class DemoAuthenticationStateProvider(IDemoProfileContext demoContext) : AuthenticationStateProvider
{
    public override Task<AuthenticationState> GetAuthenticationStateAsync()
    {
        if (!demoContext.IsEnabled)
        {
            return Task.FromResult(new AuthenticationState(
                new ClaimsPrincipal(new ClaimsIdentity())));
        }

        var profile = demoContext.GetCurrentProfile();
        var identity = new ClaimsIdentity(
        [
            new Claim(ClaimTypes.Name, profile.DisplayName),
            new Claim(ClaimTypes.Role, profile.Role)
        ], authenticationType: "DemoProfile");

        demoContext.Changed += OnProfileChanged;
        return Task.FromResult(new AuthenticationState(new ClaimsPrincipal(identity)));
    }

    private void OnProfileChanged()
        => NotifyAuthenticationStateChanged(GetAuthenticationStateAsync());
}
