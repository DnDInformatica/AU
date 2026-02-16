namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Logout;

internal static class Validator
{
    public static void Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);

        if (string.IsNullOrWhiteSpace(command.RefreshToken))
            throw new ArgumentException("RefreshToken is required.", nameof(command));
    }
}
