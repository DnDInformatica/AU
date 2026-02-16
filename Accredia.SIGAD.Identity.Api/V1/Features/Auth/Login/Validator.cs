namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Login;

internal static class Validator
{
    public static void Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);

        if (string.IsNullOrWhiteSpace(command.UserName))
            throw new ArgumentException("UserName is required.", nameof(command));

        if (string.IsNullOrWhiteSpace(command.Password))
            throw new ArgumentException("Password is required.", nameof(command));
    }
}
