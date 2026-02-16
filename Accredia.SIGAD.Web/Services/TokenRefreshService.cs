using System.Net.Http.Json;
using Microsoft.Extensions.Options;
using Accredia.SIGAD.Web.Auth;
using Accredia.SIGAD.Web.Models.Auth;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Gestisce il refresh automatico dei token JWT per prevenire scadenze improvvise.
/// 
/// STRATEGIA REFRESH (PROATTIVA + REATTIVA):
/// ==========================================
/// 1. BACKGROUND TIMER: Refresh ogni N minuti (configurabile, default 14)
/// 2. ON APP STARTUP: Check token all'avvio, refresh se < 5 minuti rimanenti
/// 3. PRE-API CALL: Check nel GatewayAuthorizationHandler prima di ogni chiamata
/// 4. ON 401 RESPONSE: Fallback reattivo se proattivo fallisce
/// 
/// MOTIVAZIONI ARCHITETTURALI:
/// - Timer proattivo: Previene 99% delle scadenze improvvise
/// - Startup check: Gestisce token caricati da LocalStorage (Remember Me)
/// - Pre-API check: Safety net prima di chiamate critiche
/// - 401 fallback: Ultima risorsa se tutto il resto fallisce
/// 
/// TOKEN LIFECYCLE:
/// - Access Token: 15 minuti (da Identity API)
/// - Refresh Interval: 14 minuti (configurabile)
/// - Warning Threshold: 2 minuti (configurabile)
/// 
/// THREAD SAFETY:
/// - Usa SemaphoreSlim per prevenire refresh concorrenti
/// - Singleton service registrato in Program.cs
/// - Safe per uso da HttpInterceptor + Background Timer
/// </summary>
internal sealed class TokenRefreshService : IDisposable
{
    private readonly TokenService _tokenService;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly GatewayAuthenticationStateProvider _authProvider;
    private readonly ILogger<TokenRefreshService> _logger;
    private readonly TokenManagementOptions _options;
    
    // Background timer per refresh periodico
    private Timer? _refreshTimer;
    
    // Lock per prevenire refresh concorrenti
    private readonly SemaphoreSlim _refreshLock = new(1, 1);
    
    // Flag per sapere se il servizio è in esecuzione
    private bool _isRunning;
    
    // Task di refresh in corso (null se nessun refresh attivo)
    private Task<bool>? _currentRefreshTask;

    public TokenRefreshService(
        TokenService tokenService,
        IHttpClientFactory httpClientFactory,
        GatewayAuthenticationStateProvider authProvider,
        ILogger<TokenRefreshService> logger,
        IOptions<TokenManagementOptions> options)
    {
        _tokenService = tokenService;
        _httpClientFactory = httpClientFactory;
        _authProvider = authProvider;
        _logger = logger;
        _options = options.Value;
    }

    /// <summary>
    /// Avvia il timer di background refresh.
    /// Chiamare in OnAfterRenderAsync del MainLayout.
    /// </summary>
    public void Start()
    {
        if (_isRunning)
        {
            _logger.LogWarning("TokenRefreshService già in esecuzione.");
            return;
        }

        _isRunning = true;
        _tokenService.MarkJsAvailable();

        // Esegue un check immediato all'avvio (caso LocalStorage con token salvato)
        _ = Task.Run(async () =>
        {
            await Task.Delay(TimeSpan.FromSeconds(2)); // Aspetta che l'app si stabilizzi
            await RefreshIfNeededAsync();
        });

        // Avvia il timer per refresh periodico
        var interval = TimeSpan.FromMinutes(_options.RefreshIntervalMinutes);
        _refreshTimer = new Timer(
            callback: async _ => await RefreshIfNeededAsync(),
            state: null,
            dueTime: interval,
            period: interval);

        _logger.LogInformation(
            "TokenRefreshService avviato. Interval={IntervalMinutes}min, Warning={WarningMinutes}min",
            _options.RefreshIntervalMinutes,
            _options.ExpiryWarningMinutes);
    }

    /// <summary>
    /// Ferma il timer di background refresh.
    /// Chiamare quando l'utente fa logout.
    /// </summary>
    public void Stop()
    {
        if (!_isRunning)
        {
            return;
        }

        _isRunning = false;
        _refreshTimer?.Dispose();
        _refreshTimer = null;

        _logger.LogInformation("TokenRefreshService fermato.");
    }

    /// <summary>
    /// Effettua il refresh del token se necessario (chiamata thread-safe).
    /// Può essere invocato da:
    /// - Background Timer
    /// - GatewayAuthorizationHandler (prima di ogni API call)
    /// - Manualmente da UI (es. pulsante "Estendi sessione")
    /// </summary>
    /// <param name="forceRefresh">Se true, forza il refresh anche se il token non è scaduto</param>
    /// <returns>True se il token è stato refreshato con successo o non era necessario, False se il refresh è fallito</returns>
    public async Task<bool> RefreshIfNeededAsync(bool forceRefresh = false)
    {
        // Se c'è già un refresh in corso, aspetta il suo completamento
        if (_currentRefreshTask is not null)
        {
            _logger.LogDebug("Refresh già in corso, in attesa del completamento...");
            return await _currentRefreshTask;
        }

        await _refreshLock.WaitAsync();
        try
        {
            // Double-check: potrebbe essere completato mentre aspettavamo il lock
            if (_currentRefreshTask is not null)
            {
                return await _currentRefreshTask;
            }

            // Crea e avvia il task di refresh
            _currentRefreshTask = ExecuteRefreshAsync(forceRefresh);
            return await _currentRefreshTask;
        }
        finally
        {
            _currentRefreshTask = null;
            _refreshLock.Release();
        }
    }

    /// <summary>
    /// Esegue effettivamente il refresh del token
    /// </summary>
    private async Task<bool> ExecuteRefreshAsync(bool forceRefresh)
    {
        var tokens = await _tokenService.GetTokensAsync();
        if (tokens is null)
        {
            _logger.LogDebug("Nessun token trovato, skip refresh.");
            return true; // Non è un errore, semplicemente l'utente non è loggato
        }

        // Check se il token è scaduto o sta per scadere
        var bufferMinutes = _options.CheckBeforeApiCallMinutes;
        var isExpiring = tokens.Value.ExpiresAt <= DateTimeOffset.UtcNow.AddMinutes(bufferMinutes);

        if (!forceRefresh && !isExpiring)
        {
            _logger.LogDebug(
                "Token ancora valido (scade: {ExpiresAt:u}, buffer: {BufferMinutes}min), skip refresh.",
                tokens.Value.ExpiresAt,
                bufferMinutes);
            return true;
        }

        // Esegue il refresh
        _logger.LogInformation(
            "Refresh token in corso... (Scadenza: {ExpiresAt:u}, ForceRefresh: {ForceRefresh})",
            tokens.Value.ExpiresAt,
            forceRefresh);

        try
        {
            var client = _httpClientFactory.CreateClient("GatewayRefresh");
            var response = await client.PostAsJsonAsync(
                "identity/v1/auth/refresh",
                new RefreshRequest(tokens.Value.RefreshToken),
                CancellationToken.None);
            if (response.IsSuccessStatusCode)
            {
                var token = await response.Content.ReadFromJsonAsync<TokenResponse>(CancellationToken.None);
                if (token is null)
                {
                    _logger.LogError("Refresh fallito: risposta non valida.");
                    return false;
                }

                // Salva i nuovi token mantenendo la preferenza RememberMe
                await _tokenService.SaveTokensAsync(
                    token.AccessToken,
                    token.RefreshToken,
                    token.ExpiresInSeconds,
                    tokens.Value.RememberMe);

                // Notifica AuthenticationStateProvider del cambio token
                await _authProvider.SignInAsync(
                    token.AccessToken,
                    token.RefreshToken,
                    token.ExpiresInSeconds);

                _logger.LogInformation(
                    "Token refreshato con successo. Nuova scadenza: {ExpiresAt:u}",
                    DateTimeOffset.UtcNow.AddSeconds(token.ExpiresInSeconds));

                return true;
            }

            // Refresh fallito (es. 401, 403, refresh token scaduto)
            var error = await response.Content.ReadAsStringAsync(CancellationToken.None);
            _logger.LogError(
                "Refresh fallito: {Error} (StatusCode: {StatusCode})",
                string.IsNullOrWhiteSpace(error) ? "Unknown" : error,
                response.StatusCode);

            // Logout automatico se refresh token non valido
            if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized ||
                response.StatusCode == System.Net.HttpStatusCode.Forbidden)
            {
                _logger.LogWarning("Refresh token non valido o scaduto. Logout automatico.");
                await LogoutAsync();
            }

            return false;
        }
        catch (HttpRequestException ex)
        {
            _logger.LogWarning(ex, "Gateway non disponibile durante il refresh token.");
            return false;
        }
        catch (TaskCanceledException ex)
        {
            _logger.LogWarning(ex, "Timeout durante il refresh token.");
            return false;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Eccezione durante il refresh del token.");
            return false;
        }
    }

    /// <summary>
    /// Esegue il logout automatico (chiamato quando il refresh fallisce)
    /// </summary>
    private async Task LogoutAsync()
    {
        try
        {
            Stop(); // Ferma il timer
            await _tokenService.ClearAllAsync();
            await _authProvider.SignOutAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Errore durante il logout automatico.");
        }
    }

    public void Dispose()
    {
        _refreshTimer?.Dispose();
        _refreshLock.Dispose();
    }
}

/// <summary>
/// Opzioni configurabili per il token management (da appsettings.json)
/// </summary>
internal sealed class TokenManagementOptions
{
    public const string SectionName = "TokenManagement";

    /// <summary>
    /// Intervallo in minuti per il refresh automatico (default: 14)
    /// </summary>
    public int RefreshIntervalMinutes { get; set; } = 14;

    /// <summary>
    /// Minuti prima della scadenza per mostrare warning all'utente (default: 2)
    /// </summary>
    public int ExpiryWarningMinutes { get; set; } = 2;

    /// <summary>
    /// Minuti di buffer prima di ogni chiamata API per decidere se refreshare (default: 2)
    /// </summary>
    public int CheckBeforeApiCallMinutes { get; set; } = 2;
}
