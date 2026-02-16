namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.SoftDeleteInt;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>();
        if (command.IncaricoId < 1)
        {
            errors["id"] = ["Id incarico non valido."];
        }

        return errors.Count > 0 ? errors : null;
    }
}

