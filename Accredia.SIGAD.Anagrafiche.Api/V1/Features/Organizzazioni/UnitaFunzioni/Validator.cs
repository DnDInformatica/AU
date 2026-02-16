namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaFunzioni;

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
        => ValidatePayload(command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, command.Request.TipoFunzioneUnitaLocaleId);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, command.Request.TipoFunzioneUnitaLocaleId)
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.UnitaOrganizzativaFunzioneId <= 0)
        {
            errors["unitaOrganizzativaFunzioneId"] = ["UnitaOrganizzativaFunzioneId non valido."];
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

        if (command.UnitaOrganizzativaFunzioneId <= 0)
        {
            errors["unitaOrganizzativaFunzioneId"] = ["UnitaOrganizzativaFunzioneId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(int organizzazioneId, int unitaOrganizzativaId, int tipoFunzioneUnitaLocaleId)
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

        if (tipoFunzioneUnitaLocaleId <= 0)
        {
            errors["tipoFunzioneUnitaLocaleId"] = ["TipoFunzioneUnitaLocaleId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

