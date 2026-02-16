namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.List;

internal static class Validator
{
    private const int MaxPageSize = 200;

    public static Dictionary<string, string[]> Validate(Query query)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (query.Page < 1)
        {
            errors["page"] = ["Page must be greater than or equal to 1."];
        }

        if (query.PageSize < 1 || query.PageSize > MaxPageSize)
        {
            errors["pageSize"] = [$"PageSize must be between 1 and {MaxPageSize}."];
        }

        if (!string.IsNullOrWhiteSpace(query.Q) && query.Q.Length > 100)
        {
            errors["q"] = ["Filter length must be 100 characters or less."];
        }

        return errors;
    }
}
