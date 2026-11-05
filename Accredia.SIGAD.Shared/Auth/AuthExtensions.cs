using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Accredia.SIGAD.Shared.Auth;

public static class AuthExtensions
{
    /// <summary>
    /// Registra la validazione del token su TUTTI i servizi (RF-059).
    /// Nessun servizio si fida del perimetro: il gateway instrada, non autentica.
    /// </summary>
    /// <param name="risolveIdentitaSuIam">
    /// Vero per i servizi che dispongono di una connessione al modello dati e
    /// possono quindi risolvere l'identita' su IAM. Falso per i servizi di sola
    /// composizione (BFF), che non sono titolari di dati e non devono aprire una
    /// connessione al database solo per autorizzare: propagano il token ai
    /// servizi a valle, dove la risoluzione avviene una volta sola e nel punto
    /// in cui il dato risiede.
    /// </param>
    public static IServiceCollection AddSigadAuthentication(
        this IServiceCollection services,
        IConfiguration configuration,
        IHostEnvironment environment,
        bool risolveIdentitaSuIam = true)
    {
        services.AddHttpContextAccessor();

        // Disponibile sempre: consente ai client HTTP di propagare l'identita'
        // del chiamante con .AddHttpMessageHandler<PropagazioneIdentitaHandler>().
        services.AddTransient<PropagazioneIdentitaHandler>();

        if (risolveIdentitaSuIam)
        {
            services.AddScoped<CurrentUser>();
            services.AddScoped<ICurrentUser>(sp => sp.GetRequiredService<CurrentUser>());
        }

        // Schema selettore: sceglie tra il tenant istituzionale e, solo in
        // sviluppo, l'identita' di prova.
        var auth = services.AddAuthentication(AuthSchemes.Selector);

        auth.AddPolicyScheme(AuthSchemes.Selector, AuthSchemes.Selector, opt =>
        {
            opt.ForwardDefaultSelector = context =>
            {
#if DEBUG
                if (context.Request.Headers.ContainsKey(DevAuth.HeaderOid)
                    || !string.IsNullOrWhiteSpace(DevAuth.OidPredefinito))
                {
                    var env = context.RequestServices.GetRequiredService<IHostEnvironment>();
                    if (DevAuth.IsEnabled(env)) return DevAuth.Schema;
                }
#endif
                // SIDAC e' solo per uso interno: nessuno schema per External ID.
                return AuthSchemes.Workforce;
            };
        });

        ConfiguraEmittente(auth, configuration, AuthSchemes.Workforce, "Entra:Workforce");

        var schemi = new List<string> { AuthSchemes.Selector };

#if DEBUG
        if (DevAuth.IsEnabled(environment))
        {
            auth.AddScheme<Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions, DevAuthHandler>(
                DevAuth.Schema, _ => { });
            schemi.Add(DevAuth.Schema);
        }
#endif

        services.AddAuthorization(opt =>
        {
            opt.DefaultPolicy = new AuthorizationPolicyBuilder(schemi.ToArray())
                .RequireAuthenticatedUser()
                .Build();
            // Ogni endpoint richiede un utente autenticato anche se non dichiara
            // nulla (RF-059: il gateway instrada, non autentica). Le eccezioni
            // vanno dichiarate con AllowAnonymous, come per /health.
            opt.FallbackPolicy = opt.DefaultPolicy;
        });

        return services;
    }

    private static void ConfiguraEmittente(
        AuthenticationBuilder auth, IConfiguration cfg, string schema, string sezione)
    {
        var authority = cfg[$"{sezione}:Authority"];
        var audience  = cfg[$"{sezione}:Audience"];

        auth.AddJwtBearer(schema, o =>
        {
            o.Authority = authority;
            o.Audience  = audience;
            o.TokenValidationParameters.ValidateIssuer = true;
            o.TokenValidationParameters.ValidateAudience = !string.IsNullOrWhiteSpace(audience);
            o.TokenValidationParameters.ClockSkew = TimeSpan.FromSeconds(30);
        });
    }

    /// <summary>
    /// Risolve l'identita' su IAM dopo l'autenticazione. Un token valido di
    /// un soggetto non censito NON produce accesso (RF-060).
    /// Va inserito DOPO UseAuthentication e PRIMA di UseAuthorization.
    /// </summary>
    public static IApplicationBuilder UseSigadUserResolution(this IApplicationBuilder app)
    {
        return app.Use(async (context, next) =>
        {
            if (context.User?.Identity?.IsAuthenticated == true)
            {
                var current = context.RequestServices.GetRequiredService<CurrentUser>();
                var risolto = await current.RisolviAsync(context.RequestAborted);

                if (!risolto)
                {
                    var logger = context.RequestServices
                        .GetRequiredService<ILoggerFactory>().CreateLogger("Sigad.Auth");
                    logger.LogWarning(
                        "Identita' autenticata ma non censita in IAM.Utente: accesso negato. oid={Oid}",
                        current.EntraObjectId);

                    context.Response.StatusCode = StatusCodes.Status403Forbidden;
                    await context.Response.WriteAsJsonAsync(new
                    {
                        error = "Utenza non abilitata al sistema.",
                        detail = "L'identita' e' valida ma non risulta censita. Contattare l'amministratore."
                    });
                    return;
                }
            }

            await next();
        });
    }
}
