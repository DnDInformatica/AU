namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.Search;

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
        else if (query.Q.Trim().Length < 2)
        {
            errors["q"] = ["Inserire almeno 2 caratteri per la ricerca."];
        }
        else if (query.Q.Trim().Length > 100)
        {
            errors["q"] = ["La ricerca non può superare 100 caratteri."];
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
