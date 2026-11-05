using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;

namespace Accredia.SIGAD.Shared.Auth;

/// <summary>
/// Estensioni per dichiarare il permesso richiesto da una rotta.
/// </summary>
public static class PermessoEndpointExtensions
{
    /// <summary>
    /// Richiede che l'utente disponga di almeno uno dei permessi indicati.
    /// Dichiara anche i codici 401 e 403 fra le risposte possibili, cosi' che
    /// la documentazione dell'interfaccia resti allineata al comportamento.
    /// </summary>
    public static TBuilder RichiedePermesso<TBuilder>(
        this TBuilder builder, params string[] permessiAmmessi)
        where TBuilder : IEndpointConventionBuilder
    {
        if (permessiAmmessi is null || permessiAmmessi.Length == 0)
        {
            throw new ArgumentException(
                "Indicare almeno un permesso: una rotta senza permesso dichiarato " +
                "va lasciata esplicitamente aperta, non protetta a vuoto.",
                nameof(permessiAmmessi));
        }

        builder.AddEndpointFilter(new PermessoEndpointFilter(permessiAmmessi));
        builder.Add(endpoint =>
        {
            endpoint.Metadata.Add(new ProducesResponseTypeMetadata(
                StatusCodes.Status401Unauthorized));
            endpoint.Metadata.Add(new ProducesResponseTypeMetadata(
                StatusCodes.Status403Forbidden));
        });
        return builder;
    }
}

internal sealed class ProducesResponseTypeMetadata : Microsoft.AspNetCore.Http.Metadata.IProducesResponseTypeMetadata
{
    public ProducesResponseTypeMetadata(int statusCode) => StatusCode = statusCode;

    public int StatusCode { get; }
    public Type? Type => typeof(Microsoft.AspNetCore.Mvc.ProblemDetails);
    public IEnumerable<string> ContentTypes => ["application/problem+json"];
}
