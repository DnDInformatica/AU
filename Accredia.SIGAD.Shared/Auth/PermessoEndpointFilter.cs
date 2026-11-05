using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

namespace Accredia.SIGAD.Shared.Auth;

/// <summary>
/// Verifica che l'utente disponga di un permesso, sull'identita' gia' risolta
/// su IAM dal middleware di risoluzione.
///
/// Attua RF-061: i permessi provengono dal modello dati e mai dai claim
/// dell'emittente. Il controllo risiede nel servizio e non nel gateway, perche'
/// e' nel servizio che l'identita' e' stata risolta; il gateway instrada.
///
/// Uso: .RichiedePermesso("SIDAC.HR.DIP.CREATE") oppure, per i casi in cui piu'
/// permessi sono equivalenti, .RichiedePermesso("SIDAC.HR.DIP.LIST", "SIDAC.HR.DIP.READ").
/// </summary>
public sealed class PermessoEndpointFilter : IEndpointFilter
{
    private readonly string[] _permessiAmmessi;

    public PermessoEndpointFilter(params string[] permessiAmmessi)
        => _permessiAmmessi = permessiAmmessi;

    public async ValueTask<object?> InvokeAsync(
        EndpointFilterInvocationContext context, EndpointFilterDelegate next)
    {
        var utente = context.HttpContext.RequestServices.GetService<ICurrentUser>();

        // Nessuna credenziale presentata: il rifiuto compete all'autenticazione,
        // non a questo filtro, che si limita a non concedere.
        if (utente is null || utente.UtenteId == 0)
        {
            return Results.Problem(
                "Autenticazione richiesta.",
                statusCode: StatusCodes.Status401Unauthorized);
        }

        if (_permessiAmmessi.Any(p => utente.Permessi.Contains(p)))
        {
            return await next(context);
        }

        return Results.Problem(
            "L'utenza non dispone del permesso necessario per questa operazione.",
            statusCode: StatusCodes.Status403Forbidden);
    }
}
