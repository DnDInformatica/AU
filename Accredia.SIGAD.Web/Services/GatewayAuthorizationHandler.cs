using System.Net.Http.Headers;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using Accredia.SIGAD.Web.Auth;
using Microsoft.AspNetCore.Http;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// HTTP Message Handler che implementa una strategia completa di gestione token:
/// 
/// STRATEGIA PROATTIVA (PRE-REQUEST):
/// ===================================
/// 1. Inject Bearer token in tutte le chiamate HTTP al Gateway
/// 2. Inject X-Correlation-Id header per distributed tracing
/// 3. CHECK PROATTIVO: Controlla se token sta per scadere (< 2 min) prima della richiesta
/// 4. Trigghera refresh proattivo se necessario
/// 
/// STRATEGIA REATTIVA (POST-RESPONSE):
/// ====================================
/// 5. INTERCETTA 401 UNAUTHORIZED: Se la richiesta riceve 401
/// 6. Trigghera refresh reattivo del token
/// 7. RETRY AUTOMATICO: Riprova la richiesta originale con nuovo token
/// 8. Max 1 retry per evitare loop infiniti
/// 
/// MOTIVAZIONI:
/// - Proattivo: Previene 99% dei 401 (background timer + pre-check)
/// - Reattivo: Safety net finale per edge cases (race conditions, timer mancato)
/// - Retry: UX fluida, l'utente non vede mai il 401
/// 
/// THREAD SAFETY:
/// - TokenRefreshService gestisce il lock per refresh concorrenti
/// - Multipli handler possono chiamare RefreshIfNeededAsync() simultaneamente
/// - Solo un refresh verrà eseguito, gli altri aspetteranno
/// </summary>
internal sealed class GatewayAuthorizationHandler : DelegatingHandler
{
    private const string CorrelationIdHeader = "X-Correlation-Id";
    private readonly ProtectedSessionStorage _sessionStorage;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly TokenService _tokenService;
    private readonly TokenRefreshService _tokenRefreshService;
    private readonly ILogger<GatewayAuthorizationHandler> _logger;

    public GatewayAuthorizationHandler(
        ProtectedSessionStorage sessionStorage,
        IHttpContextAccessor httpContextAccessor,
        TokenService tokenService,
        TokenRefreshService tokenRefreshService,
        ILogger<GatewayAuthorizationHandler> logger)
    {
        _sessionStorage = sessionStorage;
        _httpContextAccessor = httpContextAccessor;
        _tokenService = tokenService;
        _tokenRefreshService = tokenRefreshService;
        _logger = logger;
    }

    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        // 1. Inject Correlation-Id per distributed tracing
        if (!request.Headers.Contains(CorrelationIdHeader))
        {
            var correlationId = _httpContextAccessor.HttpContext?.Request.Headers[CorrelationIdHeader].FirstOrDefault();
            if (string.IsNullOrWhiteSpace(correlationId))
            {
                correlationId = Guid.NewGuid().ToString("N");
            }

            request.Headers.TryAddWithoutValidation(CorrelationIdHeader, correlationId);
        }

        // 2. PROACTIVE CHECK: Controlla se il token sta per scadere
        // (Solo se non stiamo chiamando /auth/login o /auth/refresh per evitare loop)
        var isAuthEndpoint = request.RequestUri?.AbsolutePath.Contains("/auth/") == true;
        if (!isAuthEndpoint)
        {
            var isExpiring = await _tokenService.IsTokenExpiredOrExpiringAsync(bufferMinutes: 2);
            if (isExpiring)
            {
                _logger.LogDebug("Token in scadenza rilevato prima di chiamata API. Triggering proactive refresh...");
                
                var refreshSuccess = await _tokenRefreshService.RefreshIfNeededAsync();
                if (!refreshSuccess)
                {
                    _logger.LogWarning("Proactive refresh fallito. La chiamata API potrebbe ricevere 401.");
                }
            }
        }

        // 3. Inject Bearer token (ora aggiornato se c'è stato un refresh)
        var accessToken = await _tokenService.GetAccessTokenAsync();
        if (!string.IsNullOrWhiteSpace(accessToken))
        {
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        }

        // 4. Invia la richiesta
        var response = await base.SendAsync(request, cancellationToken);

        // 5. REACTIVE 401 HANDLING: Se riceviamo 401, prova a refreshare e retry
        // (Solo se non stiamo già chiamando /auth per evitare loop infiniti)
        if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized && !isAuthEndpoint)
        {
            _logger.LogWarning(
                "Ricevuto 401 Unauthorized per {Method} {Path}. Tentativo refresh + retry...",
                request.Method,
                request.RequestUri?.PathAndQuery);

            // Tenta il refresh (forza refresh anche se token sembra valido)
            var refreshSuccess = await _tokenRefreshService.RefreshIfNeededAsync(forceRefresh: true);
            
            if (refreshSuccess)
            {
                // Refresh riuscito, retry della richiesta originale con nuovo token
                _logger.LogInformation("Refresh completato. Retry della richiesta originale...");
                
                // Clona la richiesta (HttpRequestMessage non sono riusabili dopo SendAsync)
                var retryRequest = await CloneRequestAsync(request);
                
                // Aggiungi nuovo token
                var newAccessToken = await _tokenService.GetAccessTokenAsync();
                if (!string.IsNullOrWhiteSpace(newAccessToken))
                {
                    retryRequest.Headers.Authorization = new AuthenticationHeaderValue("Bearer", newAccessToken);
                }

                // Retry (seconda chiamata, max 1 retry per evitare loop)
                var retryResponse = await base.SendAsync(retryRequest, cancellationToken);
                
                if (retryResponse.IsSuccessStatusCode)
                {
                    _logger.LogInformation(
                        "Retry riuscito per {Method} {Path} dopo refresh token.",
                        request.Method,
                        request.RequestUri?.PathAndQuery);
                }
                else
                {
                    _logger.LogWarning(
                        "Retry fallito anche dopo refresh: {StatusCode} per {Method} {Path}",
                        retryResponse.StatusCode,
                        request.Method,
                        request.RequestUri?.PathAndQuery);
                }
                
                return retryResponse;
            }
            else
            {
                // Refresh fallito, ritorna il 401 originale
                _logger.LogError(
                    "Refresh fallito dopo 401. L'utente verrà reindirizzato al login.");
                return response;
            }
        }

        // 6. Ritorna la risposta originale (non 401 oppure auth endpoint)
        return response;
    }

    /// <summary>
    /// Clona una HttpRequestMessage per il retry.
    /// Le HttpRequestMessage non sono riusabili dopo SendAsync().
    /// </summary>
    private async Task<HttpRequestMessage> CloneRequestAsync(HttpRequestMessage original)
    {
        var clone = new HttpRequestMessage(original.Method, original.RequestUri)
        {
            Version = original.Version
        };

        // Copia headers (escluso Authorization che sarà aggiornato)
        foreach (var header in original.Headers)
        {
            if (header.Key != "Authorization")
            {
                clone.Headers.TryAddWithoutValidation(header.Key, header.Value);
            }
        }

        // Copia content se presente (per POST/PUT/PATCH)
        if (original.Content is not null)
        {
            var contentBytes = await original.Content.ReadAsByteArrayAsync();
            clone.Content = new ByteArrayContent(contentBytes);

            // Copia content headers
            foreach (var header in original.Content.Headers)
            {
                clone.Content.Headers.TryAddWithoutValidation(header.Key, header.Value);
            }
        }

        return clone;
    }
}
