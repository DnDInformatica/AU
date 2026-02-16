namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.Update;

internal static class Validator
{
    public static Dictionary<string, string[]> Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.Id <= 0)
        {
            errors["id"] = ["Id must be greater than zero."];
        }

        if (string.IsNullOrWhiteSpace(command.Code))
        {
            errors["code"] = ["Code is required."];
        }
        else if (command.Code.Length > 50)
        {
            errors["code"] = ["Code must be 50 characters or less."];
        }

        if (string.IsNullOrWhiteSpace(command.Description))
        {
            errors["description"] = ["Description is required."];
        }
        else if (command.Description.Length > 250)
        {
            errors["description"] = ["Description must be 250 characters or less."];
        }

        if (command.Ordine < 0)
        {
            errors["ordine"] = ["Ordine must be greater than or equal to 0."];
        }

        return errors;
    }
}
