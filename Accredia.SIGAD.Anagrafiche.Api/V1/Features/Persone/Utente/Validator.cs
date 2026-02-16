namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Utente;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(GetCommand command)
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

        if (string.IsNullOrWhiteSpace(command.Request.UserId))
        {
            errors["userId"] = ["UserId obbligatorio."];
        }
        else if (command.Request.UserId.Trim().Length > 450)
        {
            errors["userId"] = ["UserId troppo lungo."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = Validate(new CreateCommand(command.PersonaId, new CreateRequest(command.Request.UserId), command.Actor))
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.PersonaUtenteId <= 0)
        {
            errors["personaUtenteId"] = ["PersonaUtenteId non valido."];
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
        if (command.PersonaUtenteId <= 0)
        {
            errors["personaUtenteId"] = ["PersonaUtenteId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

