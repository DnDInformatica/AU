namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RelazioniPersonali;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(LookupsCommand _)
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
        var errors = ValidateBase(command.PersonaId, command.Request.PersonaCollegataId, command.Request.TipoRelazionePersonaleId);
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidateBase(command.PersonaId, command.Request.PersonaCollegataId, command.Request.TipoRelazionePersonaleId);
        if (command.PersonaRelazionePersonaleId <= 0)
        {
            errors["personaRelazionePersonaleId"] = ["PersonaRelazionePersonaleId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }
        if (command.PersonaRelazionePersonaleId <= 0)
        {
            errors["personaRelazionePersonaleId"] = ["PersonaRelazionePersonaleId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]> ValidateBase(int personaId, int personaCollegataId, int tipoRelazionePersonaleId)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (personaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }
        if (personaCollegataId <= 0)
        {
            errors["personaCollegataId"] = ["PersonaCollegataId non valido."];
        }
        if (personaId > 0 && personaCollegataId > 0 && personaId == personaCollegataId)
        {
            errors["personaCollegataId"] = ["PersonaCollegataId non puo' essere uguale a PersonaId."];
        }
        if (tipoRelazionePersonaleId <= 0)
        {
            errors["tipoRelazionePersonaleId"] = ["TipoRelazionePersonaleId non valido."];
        }

        return errors;
    }
}

