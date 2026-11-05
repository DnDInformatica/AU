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
        "SIDAC.MODULE.ORG.ACCESS", "SIDAC.MODULE.PERS.ACCESS", "SIDAC.MODULE.INC.ACCESS",
        "SIDAC.MODULE.CERT.ACCESS", "SIDAC.MODULE.TIPO.ACCESS", "IAM.CONSOLE.ACCESS",
        "SIDAC.PERS.LIST", "SIDAC.PERS.READ", "SIDAC.PERS.CREATE", "SIDAC.PERS.UPDATE", "SIDAC.PERS.DELETE",
        "SIDAC.PERS.DOC.READ", "SIDAC.PERS.DOC.CREATE", "SIDAC.PERS.DOC.DELETE",
        "SIDAC.INC.LIST", "SIDAC.INC.READ", "SIDAC.INC.CREATE", "SIDAC.INC.UPDATE", "SIDAC.INC.DELETE",
        "SIDAC.CERT.LIST", "SIDAC.CERT.READ", "SIDAC.CERT.CREATE", "SIDAC.CERT.UPDATE", "SIDAC.CERT.DELETE",
        "SIDAC.HR.DIP.LIST", "SIDAC.HR.DIP.READ", "SIDAC.HR.DIP.CREATE", "SIDAC.HR.DIP.UPDATE", "SIDAC.HR.DIP.DELETE",
        "SIDAC.HR.CONTRATTI.LIST", "SIDAC.HR.CONTRATTI.READ", "SIDAC.HR.CONTRATTI.CREATE", "SIDAC.HR.CONTRATTI.UPDATE", "SIDAC.HR.CONTRATTI.DELETE",
        "SIDAC.HR.DOTAZIONI.LIST", "SIDAC.HR.DOTAZIONI.READ", "SIDAC.HR.DOTAZIONI.CREATE", "SIDAC.HR.DOTAZIONI.UPDATE", "SIDAC.HR.DOTAZIONI.DELETE",
        "SIDAC.HR.FORM.LIST", "SIDAC.HR.FORM.READ", "SIDAC.HR.FORM.CREATE", "SIDAC.HR.FORM.UPDATE", "SIDAC.HR.FORM.DELETE",
        "SIDAC.HR.PERSONA.READ",
        "IAM.USERS.MANAGE", "IAM.ROLES.MANAGE", "IAM.PERMISSIONS.MANAGE"
    ];

    private static readonly string[] PermessiOrganismo =
    [
        "SIDAC.MODULE.ORG.ACCESS", "SIDAC.MODULE.PERS.ACCESS", "SIDAC.MODULE.INC.ACCESS",
        "SIDAC.MODULE.CERT.ACCESS",
        "SIDAC.PERS.LIST", "SIDAC.PERS.READ", "SIDAC.PERS.CREATE", "SIDAC.PERS.UPDATE",
        "SIDAC.PERS.DOC.READ", "SIDAC.PERS.DOC.CREATE",
        "SIDAC.INC.LIST", "SIDAC.INC.READ", "SIDAC.INC.UPDATE",
        "SIDAC.CERT.LIST", "SIDAC.CERT.READ", "SIDAC.CERT.CREATE", "SIDAC.CERT.UPDATE"
    ];

    private static readonly string[] PermessiOperatore =
    [
        "SIDAC.MODULE.ORG.ACCESS", "SIDAC.MODULE.PERS.ACCESS",
        "SIDAC.PERS.LIST", "SIDAC.PERS.READ", "SIDAC.INC.LIST", "SIDAC.INC.READ", "SIDAC.CERT.LIST", "SIDAC.CERT.READ"
    ];

    private static readonly string[] PermessiIspettore =
    [
        "SIDAC.MODULE.CERT.ACCESS", "SIDAC.CERT.LIST", "SIDAC.CERT.READ", "SIDAC.INC.LIST", "SIDAC.INC.READ"
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
