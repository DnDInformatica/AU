using System.Text.RegularExpressions;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.UpdateInt;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.PersonaId <= 0)
        {
            errors["id"] = ["Id non valido."];
        }

        if (string.IsNullOrWhiteSpace(command.Request.Cognome))
        {
            errors["cognome"] = ["Cognome obbligatorio."];
        }

        if (string.IsNullOrWhiteSpace(command.Request.Nome))
        {
            errors["nome"] = ["Nome obbligatorio."];
        }

        if (!string.IsNullOrWhiteSpace(command.Request.CodiceFiscale)
            && !Regex.IsMatch(command.Request.CodiceFiscale.Trim(), @"^[A-Za-z0-9]{16}$"))
        {
            errors["codiceFiscale"] = ["Codice fiscale non valido (attesi 16 caratteri alfanumerici)."];
        }

        if (command.Request.DataNascita == default)
        {
            errors["dataNascita"] = ["Data nascita obbligatoria."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

