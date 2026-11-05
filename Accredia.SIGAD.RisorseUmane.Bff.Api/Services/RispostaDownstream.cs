using System.Net;

namespace Accredia.SIGAD.RisorseUmane.Bff.Api.Services;

/// <summary>
/// Traduce l'esito di una chiamata a un servizio a valle nella risposta del BFF.
///
/// Il livello di composizione non risolve l'identita' su IAM (AF-31 cap. 5.6):
/// il rifiuto per mancata autenticazione o autorizzazione arriva quindi dai
/// servizi a valle. Va ripropagato come tale e non tradotto in indisponibilita'
/// del servizio: chi non e' abilitato deve leggere che non e' abilitato, e chi
/// diagnostica un guasto non deve inseguire un servizio che funziona.
/// </summary>
internal static class RispostaDownstream
{
    /// <summary>Codice HTTP da restituire al chiamante, dato l'esito a valle.</summary>
    public static int Codice(HttpStatusCode statoAValle) => statoAValle switch
    {
        HttpStatusCode.Unauthorized => StatusCodes.Status401Unauthorized,
        HttpStatusCode.Forbidden    => StatusCodes.Status403Forbidden,
        _                           => StatusCodes.Status503ServiceUnavailable,
    };

    public static IResult Problema(HttpStatusCode statoAValle, string servizio)
        => ProblemaDaCodice(Codice(statoAValle), servizio);

    public static IResult ProblemaDaCodice(int codice, string servizio) => codice switch
    {
        StatusCodes.Status401Unauthorized => Results.Problem(
            $"Autenticazione richiesta dal servizio {servizio}.",
            statusCode: StatusCodes.Status401Unauthorized),

        StatusCodes.Status403Forbidden => Results.Problem(
            $"Accesso negato dal servizio {servizio}: l'utenza non e' abilitata.",
            statusCode: StatusCodes.Status403Forbidden),

        StatusCodes.Status502BadGateway => Results.Problem(
            $"Persona non trovata in {servizio}.",
            statusCode: StatusCodes.Status502BadGateway),

        _ => Results.Problem(
            $"Downstream {servizio} error.",
            statusCode: StatusCodes.Status503ServiceUnavailable),
    };
}
