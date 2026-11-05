#if DEBUG
using Accredia.SIGAD.Shared.Auth;
using Yarp.ReverseProxy.Configuration;

namespace Accredia.SIGAD.Gateway.Auth;

/// <summary>
/// PROFILO DI SVILUPPO - NON PRESENTE NELLE COMPILAZIONI DI RILASCIO (RF-064).
///
/// Rimuove le policy di autorizzazione dalle rotte YARP quando il profilo di
/// sviluppo e' attivo.
///
/// MOTIVAZIONE ARCHITETTURALE (non e' un allentamento arbitrario):
/// le policy del Gateway sono costruite sui claim 'perm' emessi dal vecchio
/// Identity.Api. Con l'identita' Entra quei claim non esistono: i permessi
/// provengono da IAM e sono risolti dalle API tramite ICurrentUser. Mantenere
/// le policy anche qui significa duplicare l'autorizzazione.
///
/// Questo filtro anticipa - limitatamente allo sviluppo - il passo 2 della
/// sequenza prevista: il Gateway torna a fare solo reverse proxy. La difesa
/// resta nelle API, che validano il token e risolvono l'utenza su IAM.
///
/// Da rimuovere quando il passo 2 sara' applicato a tutti gli ambienti.
/// </summary>
internal sealed class DevAnonymousProxyConfigFilter : IProxyConfigFilter
{
    private readonly IHostEnvironment _env;
    private readonly ILogger<DevAnonymousProxyConfigFilter> _logger;

    public DevAnonymousProxyConfigFilter(
        IHostEnvironment env,
        ILogger<DevAnonymousProxyConfigFilter> logger)
    {
        _env = env;
        _logger = logger;
    }

    public ValueTask<ClusterConfig> ConfigureClusterAsync(
        ClusterConfig cluster, CancellationToken cancel)
        => new(cluster);

    public ValueTask<RouteConfig> ConfigureRouteAsync(
        RouteConfig route, ClusterConfig? cluster, CancellationToken cancel)
    {
        if (!DevAuth.IsEnabled(_env) || string.IsNullOrWhiteSpace(route.AuthorizationPolicy))
        {
            return new ValueTask<RouteConfig>(route);
        }

        _logger.LogWarning(
            "PROFILO DI SVILUPPO: policy '{Policy}' rimossa dalla rotta '{Route}'. "
            + "L'autorizzazione e' demandata alle API. Non ammesso fuori dallo sviluppo.",
            route.AuthorizationPolicy, route.RouteId);

        return new ValueTask<RouteConfig>(route with { AuthorizationPolicy = "Anonymous" });
    }
}
#endif
