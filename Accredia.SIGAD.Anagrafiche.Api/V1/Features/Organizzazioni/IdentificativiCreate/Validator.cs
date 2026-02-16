namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiCreate;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (string.IsNullOrWhiteSpace(command.Request.PaeseISO2) || command.Request.PaeseISO2.Trim().Length != 2)
        {
            errors["paeseISO2"] = ["PaeseISO2 obbligatorio (2 caratteri)."];
        }

        if (string.IsNullOrWhiteSpace(command.Request.TipoIdentificativo))
        {
            errors["tipoIdentificativo"] = ["TipoIdentificativo obbligatorio."];
        }

        if (string.IsNullOrWhiteSpace(command.Request.Valore))
        {
            errors["valore"] = ["Valore obbligatorio."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

