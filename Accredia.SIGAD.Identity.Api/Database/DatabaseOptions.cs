namespace Accredia.SIGAD.Identity.Api.Database;

internal sealed class DatabaseOptions
{
    public const string SectionName = "Database";

    public string Schema { get; set; } = "Identity";
}
