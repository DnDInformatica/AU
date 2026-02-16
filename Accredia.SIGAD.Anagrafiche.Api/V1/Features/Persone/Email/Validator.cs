using System.Text.RegularExpressions;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Email;

internal static class Validator
{
    private static readonly Regex EmailRegex = new(@"^[^@\s]+@[^@\s]+\.[^@\s]+$", RegexOptions.Compiled);

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

        if (command.PersonaEmailId <= 0)
        {
            errors["personaEmailId"] = ["PersonaEmailId non valido."];
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

        if (command.PersonaEmailId <= 0)
        {
            errors["personaEmailId"] = ["PersonaEmailId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static void ValidatePayload(CreateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.TipoEmailId, request.Email, request.Verificata, request.DataVerifica, errors);

    private static void ValidatePayload(UpdateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.TipoEmailId, request.Email, request.Verificata, request.DataVerifica, errors);

    private static void ValidatePayload(int tipoEmailId, string email, bool verificata, DateTime? dataVerifica, Dictionary<string, string[]> errors)
    {
        if (tipoEmailId <= 0)
        {
            errors["tipoEmailId"] = ["TipoEmailId obbligatorio."];
        }

        if (string.IsNullOrWhiteSpace(email))
        {
            errors["email"] = ["Email obbligatoria."];
        }
        else
        {
            var trimmed = email.Trim();
            if (trimmed.Length > 256)
            {
                errors["email"] = ["Email troppo lunga (max 256)."];
            }
            else if (!EmailRegex.IsMatch(trimmed))
            {
                errors["email"] = ["Email non valida."];
            }
        }

        if (!verificata && dataVerifica is not null)
        {
            errors["dataVerifica"] = ["DataVerifica non ammessa se Verificata=false."];
        }
    }
}

