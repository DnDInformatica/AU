using System.Text.RegularExpressions;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UpdateInt;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.OrganizzazioneId <= 0)
        {
            errors["id"] = ["Id non valido."];
        }

        if (string.IsNullOrWhiteSpace(command.Request.Denominazione))
        {
            errors["denominazione"] = ["Denominazione obbligatoria."];
        }
        else if (command.Request.Denominazione.Length > 200)
        {
            errors["denominazione"] = ["Denominazione troppo lunga (max 200)."];
        }

        if (!string.IsNullOrWhiteSpace(command.Request.PartitaIVA)
            && !Regex.IsMatch(command.Request.PartitaIVA.Trim(), @"^\d{11}$"))
        {
            errors["partitaIVA"] = ["Partita IVA non valida (attesi 11 numeri)."];
        }

        if (!string.IsNullOrWhiteSpace(command.Request.CodiceFiscale)
            && !IsCodiceFiscaleValido(command.Request.CodiceFiscale))
        {
            errors["codiceFiscale"] = ["Codice fiscale non valido (attesi 11 numeri oppure 16 caratteri alfanumerici)."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static bool IsCodiceFiscaleValido(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return true;
        }

        var cf = value.Trim();

        if (Regex.IsMatch(cf, @"^\d{11}$"))
        {
            return true;
        }

        return Regex.IsMatch(cf, @"^[A-Za-z0-9]{16}$");
    }
}
