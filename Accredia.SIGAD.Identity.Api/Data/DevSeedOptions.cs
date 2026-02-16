namespace Accredia.SIGAD.Identity.Api.Data;

internal sealed class DevSeedOptions
{
    public const string SectionName = "DevSeed";

    public string AdminUserName { get; set; } = "admin";

    public string AdminEmail { get; set; } = "admin@accredia.local";

    /// <summary>
    /// Password per l'utente admin in Development.
    /// Se vuota, viene usata una password di default solo in DEV.
    /// </summary>
    public string? AdminPassword { get; set; }

    public string AdminRole { get; set; } = "SIGAD_SUPERADMIN";
}
