namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Poteri;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(ListCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(CreateCommand command)
        => ValidatePayload(command.OrganizzazioneId, command.Request.IncaricoId, command.Request.TipoPotereId, command.Request.DataInizio, command.Request.DataFine);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.OrganizzazioneId, command.Request.IncaricoId, command.Request.TipoPotereId, command.Request.DataInizio, command.Request.DataFine)
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PotereId <= 0)
        {
            errors["potereId"] = ["PotereId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (command.PotereId <= 0)
        {
            errors["potereId"] = ["PotereId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(
        int organizzazioneId,
        int incaricoId,
        int tipoPotereId,
        DateTime? dataInizio,
        DateTime? dataFine)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (organizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (incaricoId <= 0)
        {
            errors["incaricoId"] = ["IncaricoId non valido."];
        }

        if (tipoPotereId <= 0)
        {
            errors["tipoPotereId"] = ["TipoPotereId non valido."];
        }

        if (dataInizio.HasValue && dataFine.HasValue && dataFine.Value.Date < dataInizio.Value.Date)
        {
            errors["dataFine"] = ["DataFine non puo essere precedente a DataInizio."];
        }

        return errors.Count == 0 ? null : errors;
    }
}
