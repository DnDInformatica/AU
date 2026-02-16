namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaAttivita;

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
        => ValidatePayload(command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, command.Request.CodiceAtecoRi, command.Request.DataInizioAttivita, command.Request.DataFineAttivita);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, command.Request.CodiceAtecoRi, command.Request.DataInizioAttivita, command.Request.DataFineAttivita)
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.UnitaAttivitaId <= 0)
        {
            errors["unitaAttivitaId"] = ["UnitaAttivitaId non valido."];
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

        if (command.UnitaAttivitaId <= 0)
        {
            errors["unitaAttivitaId"] = ["UnitaAttivitaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(
        int organizzazioneId,
        int unitaOrganizzativaId,
        string codiceAtecoRi,
        DateTime? dataInizioAttivita,
        DateTime? dataFineAttivita)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (organizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (unitaOrganizzativaId <= 0)
        {
            errors["unitaOrganizzativaId"] = ["UnitaOrganizzativaId non valido."];
        }

        if (string.IsNullOrWhiteSpace(codiceAtecoRi))
        {
            errors["codiceAtecoRi"] = ["CodiceAtecoRi obbligatorio."];
        }

        if (dataInizioAttivita.HasValue && dataFineAttivita.HasValue && dataFineAttivita.Value.Date < dataInizioAttivita.Value.Date)
        {
            errors["dataFineAttivita"] = ["DataFineAttivita non puo essere precedente a DataInizioAttivita."];
        }

        return errors.Count == 0 ? null : errors;
    }
}
