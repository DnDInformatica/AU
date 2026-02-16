namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIvaMembri;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(ListCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.GruppoIvaId <= 0)
        {
            errors["gruppoIvaId"] = ["GruppoIvaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(CreateCommand command)
        => ValidatePayload(command.GruppoIvaId, command.Request.OrganizzazioneId, command.Request.DataAdesione, command.Request.DataUscita, command.Request.PercentualePartecipazione);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.GruppoIvaId, command.Request.OrganizzazioneId, command.Request.DataAdesione, command.Request.DataUscita, command.Request.PercentualePartecipazione)
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.GruppoIvaMembroId <= 0)
        {
            errors["gruppoIvaMembroId"] = ["GruppoIvaMembroId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.GruppoIvaId <= 0)
        {
            errors["gruppoIvaId"] = ["GruppoIvaId non valido."];
        }

        if (command.GruppoIvaMembroId <= 0)
        {
            errors["gruppoIvaMembroId"] = ["GruppoIvaMembroId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(
        int gruppoIvaId,
        int organizzazioneId,
        DateTime? dataAdesione,
        DateTime? dataUscita,
        decimal? percentualePartecipazione)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (gruppoIvaId <= 0)
        {
            errors["gruppoIvaId"] = ["GruppoIvaId non valido."];
        }

        if (organizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (dataAdesione.HasValue && dataUscita.HasValue && dataUscita.Value.Date < dataAdesione.Value.Date)
        {
            errors["dataUscita"] = ["DataUscita non puo essere precedente a DataAdesione."];
        }

        if (percentualePartecipazione is < 0 or > 100)
        {
            errors["percentualePartecipazione"] = ["PercentualePartecipazione deve essere tra 0 e 100."];
        }

        return errors.Count == 0 ? null : errors;
    }
}
