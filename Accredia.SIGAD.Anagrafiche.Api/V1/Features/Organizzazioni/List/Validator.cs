namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.List;

internal static class Validator
{
    private const int MaxPageSize = 200;

    public static Dictionary<string, string[]>? Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);

        var errors = new Dictionary<string, string[]>();

        if (command.Page < 1)
        {
            errors["page"] = new[] { "Page must be greater than or equal to 1." };
        }

        if (command.PageSize < 1 || command.PageSize > MaxPageSize)
        {
            errors["pageSize"] = new[] { $"PageSize must be between 1 and {MaxPageSize}." };
        }

        return errors.Count > 0 ? errors : null;
    }
}
