namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediUnita;

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
        => ValidatePayload(command.OrganizzazioneId, command.Request.SedeId, command.Request.UnitaOrganizzativaId, command.Request.DataInizio, command.Request.DataFine, command.Request.PercentualeAttivita);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.OrganizzazioneId, command.Request.SedeId, command.Request.UnitaOrganizzativaId, command.Request.DataInizio, command.Request.DataFine, command.Request.PercentualeAttivita)
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.SedeUnitaOrganizzativaId <= 0)
        {
            errors["sedeUnitaOrganizzativaId"] = ["SedeUnitaOrganizzativaId non valido."];
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

        if (command.SedeUnitaOrganizzativaId <= 0)
        {
            errors["sedeUnitaOrganizzativaId"] = ["SedeUnitaOrganizzativaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(
        int organizzazioneId,
        int sedeId,
        int unitaOrganizzativaId,
        DateTime? dataInizio,
        DateTime? dataFine,
        decimal? percentualeAttivita)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (organizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (sedeId <= 0)
        {
            errors["sedeId"] = ["SedeId non valido."];
        }

        if (unitaOrganizzativaId <= 0)
        {
            errors["unitaOrganizzativaId"] = ["UnitaOrganizzativaId non valido."];
        }

        if (dataInizio.HasValue && dataFine.HasValue && dataFine.Value.Date < dataInizio.Value.Date)
        {
            errors["dataFine"] = ["DataFine non puo essere precedente a DataInizio."];
        }

        if (percentualeAttivita is < 0 or > 100)
        {
            errors["percentualeAttivita"] = ["PercentualeAttivita deve essere tra 0 e 100."];
        }

        return errors.Count == 0 ? null : errors;
    }
}
