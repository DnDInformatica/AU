using Microsoft.AspNetCore.Http;

namespace Accredia.SIGAD.Shared.Auth;

/// <summary>
/// Propaga l'identita' del chiamante nelle chiamate fra servizi.
///
/// Necessario perche' ogni servizio valida il token autonomamente (RF-059):
/// se un servizio di composizione chiamasse quelli a valle senza credenziali,
/// le chiamate risulterebbero anonime e verrebbero respinte non appena le
/// rotte richiedono autenticazione. Propagando il token, l'identita' resta
/// quella dell'utente lungo l'intera catena e la risoluzione su IAM avviene
/// dove risiede il dato (RF-060, RF-061).
///
/// Non introduce un'identita' di servizio: se il chiamante non e' autenticato,
/// non viene aggiunta alcuna credenziale.
/// </summary>
public sealed class PropagazioneIdentitaHandler : DelegatingHandler
{
    private const string IntestazioneAutorizzazione = "Authorization";

    private readonly IHttpContextAccessor _accessor;

    public PropagazioneIdentitaHandler(IHttpContextAccessor accessor)
        => _accessor = accessor;

    protected override Task<HttpResponseMessage> SendAsync(
        HttpRequestMessage request, CancellationToken cancellationToken)
    {
        var contesto = _accessor.HttpContext;

        if (contesto is not null)
        {
            Propaga(contesto, request, IntestazioneAutorizzazione);
#if DEBUG
            // Solo in sviluppo: l'impersonazione per richiesta deve valere
            // anche a valle, altrimenti il servizio chiamato ricadrebbe
            // sulla propria SIGAD_DEV_OID e si collauderebbe un'altra utenza.
            Propaga(contesto, request, DevAuth.HeaderOid);
#endif
        }

        return base.SendAsync(request, cancellationToken);
    }

    private static void Propaga(HttpContext contesto, HttpRequestMessage request, string intestazione)
    {
        if (request.Headers.Contains(intestazione)) return;

        var valore = contesto.Request.Headers[intestazione].FirstOrDefault();
        if (string.IsNullOrWhiteSpace(valore)) return;

        request.Headers.TryAddWithoutValidation(intestazione, valore);
    }
}
