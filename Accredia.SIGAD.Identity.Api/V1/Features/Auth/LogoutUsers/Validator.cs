namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutUsers;

internal static class Validator
{
    public static void Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);

        if (command.UserIds is null || command.UserIds.Count == 0)
            throw new ArgumentException("UserIds is required.", nameof(command));

        if (command.UserIds.Any(id => string.IsNullOrWhiteSpace(id)))
            throw new ArgumentException("UserIds contains empty values.", nameof(command));
    }
}
