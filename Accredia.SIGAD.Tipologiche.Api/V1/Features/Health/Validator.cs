namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Health;

internal static class Validator
{
    public static void Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);
    }
}
