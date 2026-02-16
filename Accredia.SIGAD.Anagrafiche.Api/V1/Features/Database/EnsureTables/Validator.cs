namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Database.EnsureTables;

internal static class Validator
{
    public static void Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);
    }
}
