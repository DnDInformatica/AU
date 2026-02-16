namespace Accredia.SIGAD.Identity.Api.V1.Features.Database.EnsureSchema;

internal static class Validator
{
    public static void Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);
    }
}
