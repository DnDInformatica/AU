#if DEBUG
using System.Security.Claims;
using System.Text.Encodings.Web;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Accredia.SIGAD.Shared.Auth;

/// <summary>
/// PROFILO DI SVILUPPO - NON PRESENTE NELLE COMPILAZIONI DI RILASCIO (RF-064).
///
/// Salta ESCLUSIVAMENTE la verifica dell'emittente. L'identita' prodotta deve
/// comunque corrispondere a una riga di IAM.Utente: permessi e ambito seguono
/// il percorso di esercizio. Se saltasse anche la risoluzione, si collauderebbe
/// un percorso che in esercizio non esiste (AF-31 cap. 4.5).
/// </summary>
public sealed class DevAuthHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    private readonly IHostEnvironment _env;

    public DevAuthHandler(
        IOptionsMonitor<AuthenticationSchemeOptions> options,
        ILoggerFactory logger,
        UrlEncoder encoder,
        IHostEnvironment env)
        : base(options, logger, encoder)
    {
        _env = env;
    }

    protected override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        // Protezioni 2 e 3, riverificate a ogni richiesta e non solo all'avvio.
        if (!DevAuth.IsEnabled(_env))
        {
            return Task.FromResult(AuthenticateResult.NoResult());
        }

        var oid = Request.Headers[DevAuth.HeaderOid].FirstOrDefault()
                  ?? DevAuth.OidPredefinito;

        if (string.IsNullOrWhiteSpace(oid))
        {
            return Task.FromResult(AuthenticateResult.Fail(
                $"Profilo di sviluppo attivo ma identita' non indicata: "
                + $"impostare l'intestazione {DevAuth.HeaderOid} o la variabile SIGAD_DEV_OID."));
        }

        // Protezione 4: se il profilo e' attivo dove non deve, e' visibile nei log.
        Logger.LogWarning(
            "PROFILO DI SVILUPPO ATTIVO: autenticazione simulata per oid {Oid} su {Path}. "
            + "Non ammesso fuori dall'ambiente di sviluppo.",
            oid, Request.Path);

        var identity = new ClaimsIdentity(
        [
            new Claim("oid", oid),
            new Claim("idp", "dev")
        ], DevAuth.Schema);

        var ticket = new AuthenticationTicket(
            new ClaimsPrincipal(identity), DevAuth.Schema);

        return Task.FromResult(AuthenticateResult.Success(ticket));
    }
}
#endif
