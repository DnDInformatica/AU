namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.GetById;

internal static class Validator
{
    public static Dictionary<string, string[]> Validate(Query query)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (query.Id <= 0)
        {
            errors["id"] = ["Id must be greater than zero."];
        }

        return errors;
    }
}
