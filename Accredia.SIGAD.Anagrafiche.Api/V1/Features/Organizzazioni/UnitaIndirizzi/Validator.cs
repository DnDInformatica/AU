namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaIndirizzi;

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
        => ValidatePayload(command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, command.Request.TipoIndirizzoId, command.Request.Indirizzo, command.Request.DataInizio, command.Request.DataFine);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, command.Request.TipoIndirizzoId, command.Request.Indirizzo, command.Request.DataInizio, command.Request.DataFine)
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.IndirizzoId <= 0)
        {
            errors["indirizzoId"] = ["IndirizzoId non valido."];
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

        if (command.IndirizzoId <= 0)
        {
            errors["indirizzoId"] = ["IndirizzoId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(
        int organizzazioneId,
        int unitaOrganizzativaId,
        int tipoIndirizzoId,
        string indirizzo,
        DateTime? dataInizio,
        DateTime? dataFine)
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

        if (tipoIndirizzoId <= 0)
        {
            errors["tipoIndirizzoId"] = ["TipoIndirizzoId non valido."];
        }

        if (string.IsNullOrWhiteSpace(indirizzo))
        {
            errors["indirizzo"] = ["Indirizzo obbligatorio."];
        }

        if (dataInizio.HasValue && dataFine.HasValue && dataFine.Value.Date < dataInizio.Value.Date)
        {
            errors["dataFine"] = ["DataFine non puo essere precedente a DataInizio."];
        }

        return errors.Count == 0 ? null : errors;
    }
}
