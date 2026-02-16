using System.Text.RegularExpressions;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.CreateInt;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (string.IsNullOrWhiteSpace(command.Request.Cognome))
        {
            errors["cognome"] = ["Cognome obbligatorio."];
        }
        else if (command.Request.Cognome.Length > 200)
        {
            errors["cognome"] = ["Cognome troppo lungo (max 200)."];
        }

        if (string.IsNullOrWhiteSpace(command.Request.Nome))
        {
            errors["nome"] = ["Nome obbligatorio."];
        }
        else if (command.Request.Nome.Length > 200)
        {
            errors["nome"] = ["Nome troppo lungo (max 200)."];
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
        else if (command.Request.DataNascita > DateTime.UtcNow.Date)
        {
            errors["dataNascita"] = ["Data nascita non puo essere nel futuro."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

