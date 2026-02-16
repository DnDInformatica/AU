using System.Text.RegularExpressions;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Search;

internal static class Validator
{
    private const int MaxPageSize = 50;

    public static Dictionary<string, string[]>? Validate(Query query)
    {
        var errors = new Dictionary<string, string[]>();

        if (string.IsNullOrWhiteSpace(query.Q))
        {
            // q obbligatorio solo se non ci sono filtri alternativi
            if (query.StatoAttivitaId is null && query.TipoOrganizzazioneId is null)
            {
                errors["q"] = ["Il parametro di ricerca è obbligatorio."];
            }
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

        // Optional filters
        if (query.StatoAttivitaId is < 1)
        {
            errors["statoAttivitaId"] = ["Lo stato attività deve essere >= 1."];
        }

        if (query.TipoOrganizzazioneId is < 1)
        {
            errors["tipoOrganizzazioneId"] = ["La tipologia deve essere >= 1."];
        }

        return errors.Count > 0 ? errors : null;
    }
}
