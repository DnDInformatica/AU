#if DEBUG
using System.Security.Claims;
using Microsoft.AspNetCore.Components.Authorization;
using Accredia.SIGAD.Shared.Auth;

namespace Accredia.SIGAD.Web.Auth;

/// <summary>
/// PROFILO DI SVILUPPO PER IL WEB - RF-064.
/// NON PRESENTE NELLE COMPILAZIONI DI RILASCIO.
///
/// Sostituisce il flusso OpenID Connect verso Entra, che richiede una
/// registrazione applicativa nel tenant. L'identita' prodotta e' la stessa
/// che il gateway propaga alle API (intestazione X-Dev-Oid), quindi la
/// risoluzione su IAM e i permessi seguono il percorso di esercizio.
///
/// Si attiva solo con ASPNETCORE_ENVIRONMENT=Development e SIGAD_DEV_AUTH=1.
/// </summary>
internal sealed class DevAuthenticationStateProvider : AuthenticationStateProvider
{
    private static readonly AuthenticationState Anonimo =
        new(new ClaimsPrincipal(new ClaimsIdentity()));

    private readonly ILogger<DevAuthenticationStateProvider> _logger;
    private readonly AuthenticationState _stato;

    public DevAuthenticationStateProvider(ILogger<DevAuthenticationStateProvider> logger)
    {
        _logger = logger;

        var oid = DevAuth.OidPredefinito;
        if (string.IsNullOrWhiteSpace(oid))
        {
            _logger.LogError(
                "Profilo di sviluppo attivo ma SIGAD_DEV_OID non impostata: "
                + "l'interfaccia restera' anonima.");
            _stato = Anonimo;
            return;
        }

        _logger.LogWarning(
            "PROFILO DI SVILUPPO ATTIVO nel Web: identita' simulata per oid {Oid}. "
            + "Non ammesso fuori dall'ambiente di sviluppo.", oid);

        var identity = new ClaimsIdentity(
        [
            new Claim("oid", oid),
            new Claim(ClaimTypes.Name, "Utenza di sviluppo"),
            new Claim("idp", "dev")
        ], authenticationType: DevAuth.Schema);

        _stato = new AuthenticationState(new ClaimsPrincipal(identity));
    }

    public override Task<AuthenticationState> GetAuthenticationStateAsync()
        => Task.FromResult(_stato);
}
#endif
