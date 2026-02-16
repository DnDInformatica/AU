namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutUser;

internal static class Validator
{
    public static void Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);

        if (string.IsNullOrWhiteSpace(command.UserId))
            throw new ArgumentException("UserId is required.", nameof(command));
    }
}
