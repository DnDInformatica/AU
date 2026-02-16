namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Competenze;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(ListCommand command)
        => null;

    public static Dictionary<string, string[]>? Validate(CreateCommand command)
        => ValidatePayload(command.Request.CodiceCompetenza);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.Request.CodiceCompetenza) ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.CompetenzaId <= 0)
        {
            errors["competenzaId"] = ["CompetenzaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.CompetenzaId <= 0)
        {
            errors["competenzaId"] = ["CompetenzaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(string codiceCompetenza)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (string.IsNullOrWhiteSpace(codiceCompetenza))
        {
            errors["codiceCompetenza"] = ["CodiceCompetenza obbligatorio."];
        }

        return errors.Count == 0 ? null : errors;
    }
}
