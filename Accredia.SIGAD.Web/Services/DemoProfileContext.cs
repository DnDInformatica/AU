using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using Accredia.SIGAD.Shared.Permessi;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Contesto profilo di sviluppo, stesso funzionamento del Portale
/// (DemoPortalRoleContext): profilo corrente da cookie o configurazione,
/// nessuna pagina di login, cambio ruolo al volo per il collaudo.
/// </summary>
public interface IDemoProfileContext
{
    bool IsEnabled { get; }
    event Action? Changed;
    IReadOnlyList<SigadDemoProfile> GetAvailableProfiles();
    SigadDemoProfile GetCurrentProfile();
    bool TrySetRole(string role);
}

public sealed class DemoProfileContext(
    IOptions<SigadDemoOptions> options,
    IHttpContextAccessor httpContextAccessor) : IDemoProfileContext
{
    public const string DemoRoleCookieName = "SigadDemoRole";
    private readonly SigadDemoOptions _options = options.Value;
    private SigadDemoProfile? _currentProfile;

    public bool IsEnabled => _options.Enabled;
    public event Action? Changed;

    public IReadOnlyList<SigadDemoProfile> GetAvailableProfiles() => SigadDemoProfiles.Build();

    public SigadDemoProfile GetCurrentProfile()
    {
        _currentProfile ??= ResolveProfile(ReadRequestedRole() ?? _options.Role);
        return _currentProfile;
    }

    public bool TrySetRole(string role)
    {
        if (!_options.Enabled)
            return false;

        var next = SigadDemoProfiles.Build()
            .FirstOrDefault(x => x.Role.Equals(role, StringComparison.OrdinalIgnoreCase));

        if (next is null)
            return false;

        _currentProfile = next;
        Changed?.Invoke();
        return true;
    }

    private string? ReadRequestedRole()
        => httpContextAccessor.HttpContext?.Request.Cookies[DemoRoleCookieName];

    private SigadDemoProfile ResolveProfile(string role)
        => SigadDemoProfiles.Build().FirstOrDefault(x => x.Role.Equals(role, StringComparison.OrdinalIgnoreCase))
           ?? SigadDemoProfiles.Build().First();
}

public sealed class SigadDemoOptions
{
    public const string SectionName = "SigadContext:DemoUser";
    public bool Enabled { get; set; }
    public string DisplayName { get; set; } = "Utente Demo";
    public string Role { get; set; } = "SIGAD_ADMIN";
    public string? OrganizationName { get; set; }
    public string Language { get; set; } = "ITA";
}

public sealed record SigadDemoProfile(
    string Role,
    string Figure,
    string DisplayName,
    string? OrganizationName,
    string Language,
    IReadOnlyList<string> Roles,
    IReadOnlyList<string> Permissions);

/// <summary>
/// Profili di collaudo, solo interni: SIGAD è per il personale Accredia
/// (decisione 12 del 2026-11-05), quindi nessuna figura di organismo o
/// ispettore. I permessi si leggono dalle costanti condivise: un permesso
/// nuovo arriva da solo all'amministratore.
/// </summary>
public static class SigadDemoProfiles
{
    private static readonly string[] TuttiIPermessi =
        Costanti(typeof(PermessiSidac)).Concat(Costanti(typeof(PermessiIam))).ToArray();

    // Sola consultazione: elenchi, letture e accesso ai moduli, senza dati del
    // personale né documenti della persona (dati personali).
    private static readonly string[] PermessiConsultazione = Costanti(typeof(PermessiSidac))
        .Where(c => c.EndsWith(".LIST") || c.EndsWith(".READ") || c.StartsWith("SIDAC.MODULE."))
        .Where(c => !c.StartsWith("SIDAC.HR.") && !c.StartsWith("SIDAC.PERS.DOC."))
        .ToArray();

    // Personale interno, più la consultazione delle organizzazioni (script IAM 20261105_05).
    private static readonly string[] PermessiRisorseUmane =
        Costanti(typeof(PermessiSidac.RisorseUmane))
            .Concat([PermessiSidac.DocumentiPersona.Lettura, PermessiSidac.Organizzazioni.Accesso,
                     PermessiSidac.Organizzazioni.Elenco, PermessiSidac.Organizzazioni.Lettura])
            .ToArray();

    public static IReadOnlyList<SigadDemoProfile> Build()
        =>
        [
            new("SIGAD_ADMIN", "Amministratore SIGAD", "Admin SIGAD", "Accredia", "ITA",
                ["SIGAD_ADMIN"], TuttiIPermessi),
            new("SIGAD_LETTURA", "Consultazione", "Consultazione Demo", "Accredia", "ITA",
                ["SIGAD_LETTURA"], PermessiConsultazione),
            new("GESTORE_RISORSE_UMANE", "Gestore risorse umane", "Risorse umane Demo", "Accredia", "ITA",
                ["GESTORE_RISORSE_UMANE"], PermessiRisorseUmane)
        ];

    /// <summary>Valori delle costanti stringa di una classe e delle sue classi annidate.</summary>
    private static IEnumerable<string> Costanti(Type tipo)
        => tipo.GetFields(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Static)
               .Where(f => f.IsLiteral && f.FieldType == typeof(string))
               .Select(f => (string)f.GetRawConstantValue()!)
               .Concat(tipo.GetNestedTypes().SelectMany(Costanti));
}
