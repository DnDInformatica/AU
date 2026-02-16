namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Register;

internal static class Validator
{
    public static void Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);

        if (string.IsNullOrWhiteSpace(command.UserName))
            throw new ArgumentException("UserName is required.", nameof(command));

        if (command.UserName.Length < 3 || command.UserName.Length > 100)
            throw new ArgumentException("UserName must be between 3 and 100 characters.", nameof(command));

        if (string.IsNullOrWhiteSpace(command.Email))
            throw new ArgumentException("Email is required.", nameof(command));

        if (string.IsNullOrWhiteSpace(command.Password))
            throw new ArgumentException("Password is required.", nameof(command));

        if (command.Password.Length < 6)
            throw new ArgumentException("Password must be at least 6 characters.", nameof(command));
    }
}
