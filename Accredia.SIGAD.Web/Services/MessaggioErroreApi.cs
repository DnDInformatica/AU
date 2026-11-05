using System.Net;
using System.Net.Sockets;
using System.Text.Json;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Traduce un'eccezione di chiamata alle API in un messaggio comprensibile per
/// l'utente, al posto di <c>ex.Message</c> ("Response status code does not
/// indicate success: 500 (Internal Server Error)"). Il codice HTTP resta nel
/// messaggio, tra parentesi, perche' e' l'informazione che serve all'assistenza.
/// Copia del Portale Accredia (Accredia.Portal.Web/Services/MessaggioErroreApi.cs):
/// stesse regole per i messaggi d'errore nelle due interfacce.
/// </summary>
public static class MessaggioErroreApi
{
    public static string Da(Exception ex) => ex switch
    {
        HttpRequestException { StatusCode: { } stato } => DaStato(stato),
        HttpRequestException { InnerException: SocketException } or HttpRequestException { StatusCode: null }
            => "Il servizio non è raggiungibile in questo momento. Riprova tra qualche istante.",
        TaskCanceledException or TimeoutException
            => "Il servizio non ha risposto in tempo. Riprova tra qualche istante.",
        JsonException or NotSupportedException
            => "La risposta del servizio non è leggibile. Se il problema persiste, segnalalo all'assistenza.",
        _ => "Si è verificato un errore imprevisto. Se il problema persiste, segnalalo all'assistenza."
    };

    private static string DaStato(HttpStatusCode stato)
    {
        var codice = (int)stato;
        var testo = stato switch
        {
            HttpStatusCode.Unauthorized => "La sessione non è più valida. Accedi di nuovo.",
            HttpStatusCode.Forbidden => "Il tuo profilo non ha i permessi per questa operazione.",
            HttpStatusCode.NotFound => "La risorsa richiesta non è stata trovata.",
            HttpStatusCode.Conflict => "L'operazione è in conflitto con lo stato attuale dei dati. Aggiorna la pagina e riprova.",
            HttpStatusCode.RequestEntityTooLarge => "Il file supera la dimensione massima consentita.",
            HttpStatusCode.TooManyRequests => "Troppe richieste in poco tempo. Attendi qualche istante e riprova.",
            >= HttpStatusCode.BadRequest and < HttpStatusCode.InternalServerError
                => "La richiesta non è stata accettata dal servizio. Controlla i dati inseriti.",
            _ => "Il servizio ha restituito un errore. Riprova; se il problema persiste, segnalalo all'assistenza."
        };

        return $"{testo} (codice {codice})";
    }
}
