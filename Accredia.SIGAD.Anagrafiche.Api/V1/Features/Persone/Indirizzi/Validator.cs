namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Indirizzi;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(LookupsCommand command)
        => null;

    public static Dictionary<string, string[]>? Validate(ListCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(CreateCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }

        ValidatePayload(command.Request, errors);
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }

        if (command.PersonaIndirizzoId <= 0)
        {
            errors["personaIndirizzoId"] = ["PersonaIndirizzoId non valido."];
        }

        ValidatePayload(command.Request, errors);
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }

        if (command.PersonaIndirizzoId <= 0)
        {
            errors["personaIndirizzoId"] = ["PersonaIndirizzoId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static void ValidatePayload(CreateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.IndirizzoId, request.TipoIndirizzoId, errors);

    private static void ValidatePayload(UpdateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.IndirizzoId, request.TipoIndirizzoId, errors);

    private static void ValidatePayload(int indirizzoId, int tipoIndirizzoId, Dictionary<string, string[]> errors)
    {
        if (indirizzoId <= 0)
        {
            errors["indirizzoId"] = ["IndirizzoId obbligatorio."];
        }

        if (tipoIndirizzoId <= 0)
        {
            errors["tipoIndirizzoId"] = ["TipoIndirizzoId obbligatorio."];
        }
    }
}

