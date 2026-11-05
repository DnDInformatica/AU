namespace Accredia.SIGAD.Shared.Auth;

/// <summary>
/// Identita' applicativa risolta su IAM. RF-060, RF-061, RF-062.
/// Non deriva dai claim dell'emittente: i claim dicono chi e' il soggetto,
/// non che cosa puo' fare ne' su quali righe.
/// </summary>
public interface ICurrentUser
{
    /// <summary>Identificativo dell'oggetto nel tenant Entra (claim oid).</summary>
    string EntraObjectId { get; }

    /// <summary>IAM.Utente.UtenteId. Zero se l'identita' non e' risolta.</summary>
    int UtenteId { get; }

    /// <summary>True se l'identita' proviene dal tenant istituzionale.</summary>
    bool IsInterno { get; }

    /// <summary>Codici da IAM.Permesso tramite IAM.UtenteRuolo/RuoloPermesso.</summary>
    IReadOnlySet<string> Permessi { get; }

    /// <summary>Ambito: organismi di appartenenza, da IAM.UtenteOdC non scaduti.</summary>
    IReadOnlyList<int> OrganizzazioniOdC { get; }

    /// <summary>Ambito: ispettore, da IAM.UtenteIspettore.</summary>
    int? IspettoreId { get; }

    bool HaPermesso(string codice);
}

/// <summary>
/// Esito della risoluzione di un'identita' esterna su IAM.
/// </summary>
public sealed record UserScope(
    int UtenteId,
    IReadOnlySet<string> Permessi,
    IReadOnlyList<int> OrganizzazioniOdC,
    int? IspettoreId)
{
    public static readonly UserScope NonRisolto =
        new(0, new HashSet<string>(), Array.Empty<int>(), null);

    public bool Risolto => UtenteId > 0;
}

/// <summary>
/// Implementato da ciascun servizio con la propria connessione dati.
/// L'interfaccia sta in Shared, l'implementazione no: la connection factory
/// e' propria del servizio e non va esposta trasversalmente.
/// </summary>
public interface IUserScopeResolver
{
    Task<UserScope> ResolveAsync(string entraObjectId, string entraProvider,
        CancellationToken cancellationToken);
}
