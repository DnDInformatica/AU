namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaRelazioni;

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
        => ValidatePayload(command.OrganizzazioneId, command.Request.UnitaPadreId, command.Request.UnitaFigliaId, command.Request.TipoRelazioneId);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.OrganizzazioneId, command.Request.UnitaPadreId, command.Request.UnitaFigliaId, command.Request.TipoRelazioneId)
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.UnitaRelazioneId <= 0)
        {
            errors["unitaRelazioneId"] = ["UnitaRelazioneId non valido."];
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

        if (command.UnitaRelazioneId <= 0)
        {
            errors["unitaRelazioneId"] = ["UnitaRelazioneId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(int organizzazioneId, int unitaPadreId, int unitaFigliaId, int tipoRelazioneId)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (organizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (unitaPadreId <= 0)
        {
            errors["unitaPadreId"] = ["UnitaPadreId non valido."];
        }

        if (unitaFigliaId <= 0)
        {
            errors["unitaFigliaId"] = ["UnitaFigliaId non valido."];
        }

        if (unitaPadreId > 0 && unitaFigliaId > 0 && unitaPadreId == unitaFigliaId)
        {
            errors["unitaFigliaId"] = ["UnitaPadreId e UnitaFigliaId devono essere diversi."];
        }

        if (tipoRelazioneId <= 0)
        {
            errors["tipoRelazioneId"] = ["TipoRelazioneId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

