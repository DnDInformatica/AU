namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Storico;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(PersonaCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["id"] = ["PersonaId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(RegistroTrattamentiCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.RegistroTrattamentiId <= 0)
        {
            errors["id"] = ["RegistroTrattamentiId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(RichiestaGdprCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.RichiestaGdprId <= 0)
        {
            errors["id"] = ["RichiestaGdprId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(RichiestaEsercizioDirittiCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.RichiestaEsercizioDirittiId <= 0)
        {
            errors["id"] = ["RichiestaEsercizioDirittiId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DataBreachCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.DataBreachId <= 0)
        {
            errors["id"] = ["DataBreachId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }
}

