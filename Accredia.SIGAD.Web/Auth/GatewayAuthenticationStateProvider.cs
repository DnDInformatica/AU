using System.Security.Claims;
using System.Text.Json;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using Microsoft.JSInterop;

namespace Accredia.SIGAD.Web.Auth;

internal sealed class GatewayAuthenticationStateProvider : AuthenticationStateProvider
{
    private static readonly ClaimsPrincipal Anonymous = new(new ClaimsIdentity());
    private static readonly AuthenticationState AnonymousState = new(Anonymous);
    private readonly ProtectedSessionStorage _sessionStorage;
    
    // Flag per sapere se JS è disponibile (dopo OnAfterRender)
    private bool _isInitialized;
    private AuthenticationState? _cachedState;

    public GatewayAuthenticationStateProvider(ProtectedSessionStorage sessionStorage)
    {
        _sessionStorage = sessionStorage;
    }

    public override async Task<AuthenticationState> GetAuthenticationStateAsync()
    {
        // Durante il prerendering, JS non è disponibile - ritorna anonimo
        if (!_isInitialized)
        {
            return AnonymousState;
        }
        
        // Se abbiamo uno stato cached, restituiscilo
        if (_cachedState != null)
        {
            return _cachedState;
        }

        try
        {
            var tokenResult = await _sessionStorage.GetAsync<string>(AuthSessionKeys.AccessToken);
            if (!tokenResult.Success || string.IsNullOrWhiteSpace(tokenResult.Value))
            {
                _cachedState = AnonymousState;
                return _cachedState;
            }

            var expiresResult = await _sessionStorage.GetAsync<DateTimeOffset>(AuthSessionKeys.ExpiresAtUtc);
            if (expiresResult.Success && expiresResult.Value <= DateTimeOffset.UtcNow)
            {
                await ClearSessionAsync();
                _cachedState = AnonymousState;
                return _cachedState;
            }

            var identity = new ClaimsIdentity(ParseClaimsFromJwt(tokenResult.Value), authenticationType: "jwt");
            _cachedState = new AuthenticationState(new ClaimsPrincipal(identity));
            return _cachedState;
        }
        catch (InvalidOperationException)
        {
            // JS interop non disponibile durante prerendering
            return AnonymousState;
        }
        catch (JSDisconnectedException)
        {
            // Circuit disconnected while trying to reach ProtectedSessionStorage.
            return AnonymousState;
        }
        catch (Exception)
        {
            await ClearSessionAsync();
            _cachedState = AnonymousState;
            return _cachedState;
        }
    }

    /// <summary>
    /// Chiamare questo metodo in OnAfterRenderAsync per inizializzare l'auth state
    /// </summary>
    public async Task InitializeAsync()
    {
        if (_isInitialized) return;
        
        _isInitialized = true;
        _cachedState = null; // Force refresh
        NotifyAuthenticationStateChanged(GetAuthenticationStateAsync());
    }

    public async Task SignInAsync(string accessToken, string refreshToken, int expiresInSeconds)
    {
        var expiresAt = DateTimeOffset.UtcNow.AddSeconds(expiresInSeconds);
        await _sessionStorage.SetAsync(AuthSessionKeys.AccessToken, accessToken);
        await _sessionStorage.SetAsync(AuthSessionKeys.RefreshToken, refreshToken);
        await _sessionStorage.SetAsync(AuthSessionKeys.ExpiresAtUtc, expiresAt);
        _cachedState = null; // Invalida cache
        NotifyAuthenticationStateChanged(GetAuthenticationStateAsync());
    }

    public async Task SignOutAsync()
    {
        await ClearSessionAsync();
        _cachedState = AnonymousState;
        NotifyAuthenticationStateChanged(Task.FromResult(AnonymousState));
    }

    public async Task<string?> GetRefreshTokenAsync()
    {
        try
        {
            var tokenResult = await _sessionStorage.GetAsync<string>(AuthSessionKeys.RefreshToken);
            return tokenResult.Success ? tokenResult.Value : null;
        }
        catch (InvalidOperationException)
        {
            return null;
        }
        catch (JSDisconnectedException)
        {
            return null;
        }
    }

    private async Task ClearSessionAsync()
    {
        try
        {
            await _sessionStorage.DeleteAsync(AuthSessionKeys.AccessToken);
            await _sessionStorage.DeleteAsync(AuthSessionKeys.RefreshToken);
            await _sessionStorage.DeleteAsync(AuthSessionKeys.ExpiresAtUtc);
        }
        catch (InvalidOperationException)
        {
            // JS non disponibile
        }
        catch (JSDisconnectedException)
        {
            // Circuit disconnected, ignore cleanup.
        }
    }

    private static IReadOnlyList<Claim> ParseClaimsFromJwt(string jwt)
    {
        var parts = jwt.Split('.');
        if (parts.Length < 2)
        {
            return Array.Empty<Claim>();
        }

        var jsonBytes = DecodeBase64Url(parts[1]);
        using var document = JsonDocument.Parse(jsonBytes);
        var claims = new List<Claim>();

        foreach (var property in document.RootElement.EnumerateObject())
        {
            if (property.Value.ValueKind == JsonValueKind.Array)
            {
                foreach (var item in property.Value.EnumerateArray())
                {
                    claims.Add(new Claim(property.Name, item.ToString()));
                }
            }
            else
            {
                claims.Add(new Claim(property.Name, property.Value.ToString()));
            }
        }

        return claims;
    }

    private static byte[] DecodeBase64Url(string value)
    {
        var padded = value.Replace('-', '+').Replace('_', '/');
        switch (padded.Length % 4)
        {
            case 2:
                padded += "==";
                break;
            case 3:
                padded += "=";
                break;
        }

        return Convert.FromBase64String(padded);
    }
}
