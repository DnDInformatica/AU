using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;

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

public static class SigadDemoProfiles
{
    private static readonly string[] TuttiIPermessi =
    [
        "MODULE.ORG.ACCESS", "MODULE.PERS.ACCESS", "MODULE.INC.ACCESS",
        "MODULE.CERT.ACCESS", "MODULE.TIPO.ACCESS", "MODULE.ADMIN.ACCESS",
        "PERS.LIST", "PERS.READ", "PERS.CREATE", "PERS.UPDATE", "PERS.DELETE",
        "PERS.DOC.READ", "PERS.DOC.CREATE", "PERS.DOC.DELETE",
        "INC.LIST", "INC.READ", "INC.CREATE", "INC.UPDATE", "INC.DELETE",
        "CERT.LIST", "CERT.READ", "CERT.CREATE", "CERT.UPDATE", "CERT.DELETE",
        "HR.DIP.LIST", "HR.DIP.READ", "HR.DIP.CREATE", "HR.DIP.UPDATE", "HR.DIP.DELETE",
        "HR.CONTRATTI.LIST", "HR.CONTRATTI.READ", "HR.CONTRATTI.CREATE", "HR.CONTRATTI.UPDATE", "HR.CONTRATTI.DELETE",
        "HR.DOTAZIONI.LIST", "HR.DOTAZIONI.READ", "HR.DOTAZIONI.CREATE", "HR.DOTAZIONI.UPDATE", "HR.DOTAZIONI.DELETE",
        "HR.FORM.LIST", "HR.FORM.READ", "HR.FORM.CREATE", "HR.FORM.UPDATE", "HR.FORM.DELETE",
        "HR.PERSONA.READ",
        "ADMIN.USERS.MANAGE", "ADMIN.ROLES.MANAGE", "ADMIN.PERMISSIONS.MANAGE"
    ];

    private static readonly string[] PermessiOrganismo =
    [
        "MODULE.ORG.ACCESS", "MODULE.PERS.ACCESS", "MODULE.INC.ACCESS",
        "MODULE.CERT.ACCESS",
        "PERS.LIST", "PERS.READ", "PERS.CREATE", "PERS.UPDATE",
        "PERS.DOC.READ", "PERS.DOC.CREATE",
        "INC.LIST", "INC.READ", "INC.UPDATE",
        "CERT.LIST", "CERT.READ", "CERT.CREATE", "CERT.UPDATE"
    ];

    private static readonly string[] PermessiOperatore =
    [
        "MODULE.ORG.ACCESS", "MODULE.PERS.ACCESS",
        "PERS.LIST", "PERS.READ", "INC.LIST", "INC.READ", "CERT.LIST", "CERT.READ"
    ];

    private static readonly string[] PermessiIspettore =
    [
        "MODULE.CERT.ACCESS", "CERT.LIST", "CERT.READ", "INC.LIST", "INC.READ"
    ];

    public static IReadOnlyList<SigadDemoProfile> Build()
        =>
        [
            new("SIGAD_ADMIN", "Amministratore SIGAD", "Admin SIGAD", "Accredia", "ITA",
                ["SIGAD_ADMIN"], TuttiIPermessi),
            new("REFERENTE_ORGANISMO", "Referente Organismo", "Referente Demo", "Organismo Demo", "ITA",
                ["REFERENTE_ORGANISMO"], PermessiOrganismo),
            new("OPERATORE_ORGANISMO", "Operatore Organismo", "Operatore Demo", "Organismo Demo", "ITA",
                ["OPERATORE_ORGANISMO"], PermessiOperatore),
            new("ISPETTORE", "Ispettore", "Ispettore Demo", "Accredia - Ispettori", "ITA",
                ["ISPETTORE"], PermessiIspettore)
        ];
}
