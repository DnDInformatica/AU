using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using Accredia.SIGAD.Web.Auth;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Gestisce lo storage sicuro dei token JWT con supporto ibrido SessionStorage/LocalStorage.
/// 
/// STRATEGIA STORAGE (OPZIONE C - HYBRID):
/// ===========================================
/// - DEFAULT: ProtectedSessionStorage (più sicuro, cleared on tab close)
/// - "REMEMBER ME": ProtectedLocalStorage (persiste tra sessioni browser)
/// 
/// MOTIVAZIONI ARCHITETTURALI:
/// - SessionStorage: Massima sicurezza per utenti su PC condivisi
/// - LocalStorage: Migliore UX per utenti su PC personali
/// - Utente sceglie esplicitamente il trade-off sicurezza/convenienza
/// 
/// ENCRYPTION:
/// - Entrambi gli storage usano ASP.NET Core Data Protection
/// - Token sono encrypted at rest
/// - Validi solo per questa applicazione specifica
/// </summary>
internal sealed class TokenService
{
    private readonly ProtectedSessionStorage _sessionStorage;
    private readonly ProtectedLocalStorage _localStorage;
    private readonly ILogger<TokenService> _logger;

    // Flag per sapere se JS è disponibile (dopo OnAfterRender)
    private bool _isJsAvailable;
    
    // Cache in-memory per evitare troppi round-trip a JS interop
    private TokenCache? _cache;
    
    public TokenService(
        ProtectedSessionStorage sessionStorage,
        ProtectedLocalStorage localStorage,
        ILogger<TokenService> logger)
    {
        _sessionStorage = sessionStorage;
        _localStorage = localStorage;
        _logger = logger;
    }

    /// <summary>
    /// Marca il servizio come inizializzato (chiamare in OnAfterRenderAsync)
    /// </summary>
    public void MarkJsAvailable()
    {
        _isJsAvailable = true;
    }

    /// <summary>
    /// Salva i token usando lo storage appropriato basato su "rememberMe"
    /// </summary>
    /// <param name="accessToken">JWT access token</param>
    /// <param name="refreshToken">JWT refresh token</param>
    /// <param name="expiresInSeconds">Secondi alla scadenza dell'access token</param>
    /// <param name="rememberMe">Se true, usa LocalStorage (persiste); se false, usa SessionStorage (cleared on close)</param>
    public async Task SaveTokensAsync(string accessToken, string refreshToken, int expiresInSeconds, bool rememberMe)
    {
        if (!_isJsAvailable)
        {
            _logger.LogWarning("Tentativo di salvare token prima che JS sia disponibile.");
            return;
        }

        var expiresAt = DateTimeOffset.UtcNow.AddSeconds(expiresInSeconds);

        try
        {
            // Salva in ENTRAMBI gli storage per semplicità
            // Solo quello "preferito" verrà letto al retrieval
            await _sessionStorage.SetAsync(AuthSessionKeys.AccessToken, accessToken);
            await _sessionStorage.SetAsync(AuthSessionKeys.RefreshToken, refreshToken);
            await _sessionStorage.SetAsync(AuthSessionKeys.ExpiresAtUtc, expiresAt);
            await _sessionStorage.SetAsync(AuthSessionKeys.RememberMe, rememberMe);

            if (rememberMe)
            {
                await _localStorage.SetAsync(AuthSessionKeys.AccessToken, accessToken);
                await _localStorage.SetAsync(AuthSessionKeys.RefreshToken, refreshToken);
                await _localStorage.SetAsync(AuthSessionKeys.ExpiresAtUtc, expiresAt);
                await _localStorage.SetAsync(AuthSessionKeys.RememberMe, rememberMe);
            }
            else
            {
                // Clear LocalStorage se l'utente ha deselezionato "Remember Me"
                await ClearLocalStorageAsync();
            }

            // Update cache
            _cache = new TokenCache(accessToken, refreshToken, expiresAt, rememberMe);

            _logger.LogInformation("Token salvati con successo. RememberMe={RememberMe}, ExpiresAt={ExpiresAt:u}", 
                rememberMe, expiresAt);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Errore durante il salvataggio dei token.");
            throw;
        }
    }

    /// <summary>
    /// Recupera i token dallo storage appropriato
    /// </summary>
    /// <returns>Tuple con (AccessToken, RefreshToken, ExpiresAtUtc, RememberMe) o null se non trovati</returns>
    public async Task<(string AccessToken, string RefreshToken, DateTimeOffset ExpiresAt, bool RememberMe)?> GetTokensAsync()
    {
        if (!_isJsAvailable)
        {
            return null;
        }

        // Usa cache se disponibile e valida
        if (_cache is not null && _cache.ExpiresAt > DateTimeOffset.UtcNow)
        {
            return (_cache.AccessToken, _cache.RefreshToken, _cache.ExpiresAt, _cache.RememberMe);
        }

        try
        {
            // Controlla prima SessionStorage (sempre prioritario se presente)
            var sessionRememberMe = await _sessionStorage.GetAsync<bool>(AuthSessionKeys.RememberMe);
            var useLocalStorage = sessionRememberMe.Success && sessionRememberMe.Value;

            // ✅ ADAPTER PATTERN: usa l'interfaccia comune per eliminare duplicazione
            IProtectedStorage storage = useLocalStorage
                ? new ProtectedLocalStorageAdapter(_localStorage)
                : new ProtectedSessionStorageAdapter(_sessionStorage);

            return await ReadTokensFromStorageAsync(storage, useLocalStorage);
        }
        catch (InvalidOperationException)
        {
            // JS interop non disponibile durante prerendering
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Errore durante il recupero dei token.");
            return null;
        }
    }

    /// <summary>
    /// Helper method: legge i token dallo storage tramite interfaccia comune.
    /// ✅ Elimina completamente duplicazione di codice tra SessionStorage e LocalStorage.
    /// 
    /// ARCHITETTURA:
    /// - Riceve IProtectedStorage (polymorphism via Adapter Pattern)
    /// - Codice eseguito UNA SOLA VOLTA indipendentemente dallo storage
    /// - Aggiorna cache in-memory per performance
    /// </summary>
    private async Task<(string AccessToken, string RefreshToken, DateTimeOffset ExpiresAt, bool RememberMe)?> ReadTokensFromStorageAsync(
        IProtectedStorage storage,
        bool rememberMe)
    {
        var accessTokenResult = await storage.GetAsync<string>(AuthSessionKeys.AccessToken);
        if (!accessTokenResult.Success || string.IsNullOrWhiteSpace(accessTokenResult.Value))
        {
            return null;
        }

        var refreshTokenResult = await storage.GetAsync<string>(AuthSessionKeys.RefreshToken);
        if (!refreshTokenResult.Success || string.IsNullOrWhiteSpace(refreshTokenResult.Value))
        {
            return null;
        }

        var expiresResult = await storage.GetAsync<DateTimeOffset>(AuthSessionKeys.ExpiresAtUtc);
        if (!expiresResult.Success)
        {
            return null;
        }

        // Update cache
        _cache = new TokenCache(accessTokenResult.Value, refreshTokenResult.Value, expiresResult.Value, rememberMe);
        return (accessTokenResult.Value, refreshTokenResult.Value, expiresResult.Value, rememberMe);
    }

    /// <summary>
    /// Controlla se il token è scaduto o sta per scadere
    /// </summary>
    /// <param name="bufferMinutes">Minuti di buffer prima della scadenza effettiva (default: 2)</param>
    /// <returns>True se il token è scaduto o scadrà entro bufferMinutes</returns>
    public async Task<bool> IsTokenExpiredOrExpiringAsync(int bufferMinutes = 2)
    {
        var tokens = await GetTokensAsync();
        if (tokens is null)
        {
            return true; // Nessun token = considerato scaduto
        }

        var expiryThreshold = DateTimeOffset.UtcNow.AddMinutes(bufferMinutes);
        return tokens.Value.ExpiresAt <= expiryThreshold;
    }

    /// <summary>
    /// Ottiene il refresh token corrente
    /// </summary>
    public async Task<string?> GetRefreshTokenAsync()
    {
        var tokens = await GetTokensAsync();
        return tokens?.RefreshToken;
    }

    /// <summary>
    /// Ottiene l'access token corrente
    /// </summary>
    public async Task<string?> GetAccessTokenAsync()
    {
        var tokens = await GetTokensAsync();
        return tokens?.AccessToken;
    }

    /// <summary>
    /// Pulisce tutti i token da SessionStorage e LocalStorage
    /// </summary>
    public async Task ClearAllAsync()
    {
        if (!_isJsAvailable)
        {
            return;
        }

        try
        {
            await ClearSessionStorageAsync();
            await ClearLocalStorageAsync();
            _cache = null;
            
            _logger.LogInformation("Tutti i token sono stati rimossi.");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Errore durante la cancellazione dei token.");
        }
    }

    private async Task ClearSessionStorageAsync()
    {
        try
        {
            await _sessionStorage.DeleteAsync(AuthSessionKeys.AccessToken);
            await _sessionStorage.DeleteAsync(AuthSessionKeys.RefreshToken);
            await _sessionStorage.DeleteAsync(AuthSessionKeys.ExpiresAtUtc);
            await _sessionStorage.DeleteAsync(AuthSessionKeys.RememberMe);
        }
        catch (InvalidOperationException)
        {
            // JS non disponibile
        }
    }

    private async Task ClearLocalStorageAsync()
    {
        try
        {
            await _localStorage.DeleteAsync(AuthSessionKeys.AccessToken);
            await _localStorage.DeleteAsync(AuthSessionKeys.RefreshToken);
            await _localStorage.DeleteAsync(AuthSessionKeys.ExpiresAtUtc);
            await _localStorage.DeleteAsync(AuthSessionKeys.RememberMe);
        }
        catch (InvalidOperationException)
        {
            // JS non disponibile
        }
    }

    /// <summary>
    /// Cache in-memory per evitare troppi round-trip a JS interop
    /// </summary>
    private sealed record TokenCache(
        string AccessToken,
        string RefreshToken,
        DateTimeOffset ExpiresAt,
        bool RememberMe);
}
