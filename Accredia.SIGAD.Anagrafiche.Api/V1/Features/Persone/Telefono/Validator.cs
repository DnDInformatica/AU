using System.Text.RegularExpressions;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Telefono;

internal static class Validator
{
    private static readonly Regex DigitsRegex = new(@"^[0-9]+$", RegexOptions.Compiled);

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

        if (command.PersonaTelefonoId <= 0)
        {
            errors["personaTelefonoId"] = ["PersonaTelefonoId non valido."];
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

        if (command.PersonaTelefonoId <= 0)
        {
            errors["personaTelefonoId"] = ["PersonaTelefonoId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static void ValidatePayload(CreateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.TipoTelefonoId, request.PrefissoInternazionale, request.Numero, request.Estensione, request.Verificato, request.DataVerifica, errors);

    private static void ValidatePayload(UpdateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.TipoTelefonoId, request.PrefissoInternazionale, request.Numero, request.Estensione, request.Verificato, request.DataVerifica, errors);

    private static void ValidatePayload(
        int tipoTelefonoId,
        string? prefissoInternazionale,
        string numero,
        string? estensione,
        bool verificato,
        DateTime? dataVerifica,
        Dictionary<string, string[]> errors)
    {
        if (tipoTelefonoId <= 0)
        {
            errors["tipoTelefonoId"] = ["TipoTelefonoId obbligatorio."];
        }

        if (string.IsNullOrWhiteSpace(numero))
        {
            errors["numero"] = ["Numero obbligatorio."];
        }
        else
        {
            var trimmed = numero.Trim();
            if (trimmed.Length > 50)
            {
                errors["numero"] = ["Numero troppo lungo (max 50)."];
            }
            else if (!DigitsRegex.IsMatch(trimmed))
            {
                errors["numero"] = ["Numero non valido (solo cifre)."];
            }
        }

        if (!string.IsNullOrWhiteSpace(prefissoInternazionale))
        {
            var p = prefissoInternazionale.Trim();
            if (p.Length > 10)
            {
                errors["prefissoInternazionale"] = ["PrefissoInternazionale troppo lungo (max 10)."];
            }
            else if (!DigitsRegex.IsMatch(p.TrimStart('+')))
            {
                errors["prefissoInternazionale"] = ["PrefissoInternazionale non valido (solo cifre, opzionale '+')."];
            }
        }

        if (!string.IsNullOrWhiteSpace(estensione) && estensione.Trim().Length > 10)
        {
            errors["estensione"] = ["Estensione troppo lunga (max 10)."];
        }

        if (!verificato && dataVerifica is not null)
        {
            errors["dataVerifica"] = ["DataVerifica non ammessa se Verificato=false."];
        }
    }
}

