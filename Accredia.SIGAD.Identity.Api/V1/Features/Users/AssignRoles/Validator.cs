namespace Accredia.SIGAD.Identity.Api.V1.Features.Users.AssignRoles;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>();

        if (string.IsNullOrWhiteSpace(command.UserId))
        {
            errors["userId"] = ["UserId obbligatorio."];
        }

        if (command.Roles is null || command.Roles.Count == 0)
        {
            errors["roles"] = ["Specificare almeno un ruolo."];
        }
        else
        {
            var invalid = command.Roles
                .Where(role => string.IsNullOrWhiteSpace(role) || role.Length > 256)
                .ToArray();
            if (invalid.Length > 0)
            {
                errors["roles"] = ["Ruoli non validi."];
            }
        }

        return errors.Count > 0 ? errors : null;
    }
}
