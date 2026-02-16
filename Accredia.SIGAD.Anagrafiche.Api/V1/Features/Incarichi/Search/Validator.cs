using System.Text.RegularExpressions;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.Search;

internal static class Validator
{
    private const int MaxPageSize = 50;

    public static Dictionary<string, string[]>? Validate(Query query)
    {
        var errors = new Dictionary<string, string[]>();

        if (string.IsNullOrWhiteSpace(query.Q))
        {
            errors["q"] = ["Il parametro di ricerca è obbligatorio."];
        }
        else
        {
            var trimmed = query.Q.Trim();
            var isPiva = Regex.IsMatch(trimmed, @"^\d{11}$");
            var isCf = Regex.IsMatch(trimmed, @"^[A-Za-z0-9]{16}$");

            if (trimmed.Length < 2 && !isPiva && !isCf)
            {
                errors["q"] = ["Inserire almeno 2 caratteri per la ricerca."];
            }

            if (trimmed.Length > 100)
            {
                errors["q"] = ["La ricerca non può superare 100 caratteri."];
            }
        }

        if (query.Page < 1)
        {
            errors["page"] = ["La pagina deve essere >= 1."];
        }

        if (query.PageSize < 1 || query.PageSize > MaxPageSize)
        {
            errors["pageSize"] = [$"La dimensione pagina deve essere tra 1 e {MaxPageSize}."];
        }

        return errors.Count > 0 ? errors : null;
    }
}
