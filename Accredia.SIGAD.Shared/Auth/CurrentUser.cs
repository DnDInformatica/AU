using System.Security.Claims;
using Microsoft.AspNetCore.Http;

namespace Accredia.SIGAD.Shared.Auth;

/// <summary>
/// Risolve l'identita' del chiamante su IAM una sola volta per richiesta.
/// Un'identita' autenticata ma non censita in IAM.Utente NON accede: RF-060.
/// </summary>
public sealed class CurrentUser : ICurrentUser
{
    private readonly IHttpContextAccessor _accessor;
    private readonly IUserScopeResolver _resolver;
    private UserScope? _scope;

    public CurrentUser(IHttpContextAccessor accessor, IUserScopeResolver resolver)
    {
        _accessor = accessor;
        _resolver = resolver;
    }

    private ClaimsPrincipal? Principal => _accessor.HttpContext?.User;

    public string EntraObjectId =>
        Principal?.FindFirst("oid")?.Value
        ?? Principal?.FindFirst("http://schemas.microsoft.com/identity/claims/objectidentifier")?.Value
        ?? string.Empty;

    public bool IsInterno =>
        Principal?.Identity?.AuthenticationType == AuthSchemes.Workforce;

    // I valori corrispondono a IAM.Utente.EntraProvider gia' in uso nel modello.
    private string Provider => Principal?.Identity?.AuthenticationType switch
    {
        AuthSchemes.Workforce => "ENTRA_AZIENDALE",
        AuthSchemes.External  => "ENTRA_ESTERNO",
        DevAuth.Schema        => "ENTRA_AZIENDALE",
        _ => "SCONOSCIUTO"
    };

    private UserScope Scope => _scope ?? UserScope.NonRisolto;

    public int UtenteId => Scope.UtenteId;
    public IReadOnlySet<string> Permessi => Scope.Permessi;
    public IReadOnlyList<int> OrganizzazioniOdC => Scope.OrganizzazioniOdC;
    public int? IspettoreId => Scope.IspettoreId;

    public bool HaPermesso(string codice) => Scope.Permessi.Contains(codice);

    /// <summary>
    /// Invocata dal middleware dopo l'autenticazione. Separata dal costruttore
    /// perche' la risoluzione richiede accesso al database e non deve avvenire
    /// nella costruzione del servizio.
    /// </summary>
    public async Task<bool> RisolviAsync(CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(EntraObjectId)) return false;
        _scope = await _resolver.ResolveAsync(EntraObjectId, Provider, cancellationToken);
        return _scope.Risolto;
    }
}
