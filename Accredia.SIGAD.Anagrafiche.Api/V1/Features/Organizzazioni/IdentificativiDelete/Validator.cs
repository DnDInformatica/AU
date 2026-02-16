namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiDelete;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (command.IdentificativoId <= 0)
        {
            errors["identificativoId"] = ["IdentificativoId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

