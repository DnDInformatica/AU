namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Qualifiche;

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

        if (command.PersonaQualificaId <= 0)
        {
            errors["personaQualificaId"] = ["PersonaQualificaId non valido."];
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

        if (command.PersonaQualificaId <= 0)
        {
            errors["personaQualificaId"] = ["PersonaQualificaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static void ValidatePayload(CreateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.TipoQualificaId, request.EnteRilascioQualificaId, request.CodiceAttestato, request.DataRilascio, request.DataScadenza, request.Note, errors);

    private static void ValidatePayload(UpdateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.TipoQualificaId, request.EnteRilascioQualificaId, request.CodiceAttestato, request.DataRilascio, request.DataScadenza, request.Note, errors);

    private static void ValidatePayload(
        int tipoQualificaId,
        int? enteRilascioQualificaId,
        string? codiceAttestato,
        DateTime? dataRilascio,
        DateTime? dataScadenza,
        string? note,
        Dictionary<string, string[]> errors)
    {
        if (tipoQualificaId <= 0)
        {
            errors["tipoQualificaId"] = ["TipoQualificaId obbligatorio."];
        }

        if (enteRilascioQualificaId is <= 0)
        {
            errors["enteRilascioQualificaId"] = ["EnteRilascioQualificaId non valido."];
        }

        if (!string.IsNullOrWhiteSpace(codiceAttestato) && codiceAttestato.Trim().Length > 60)
        {
            errors["codiceAttestato"] = ["CodiceAttestato troppo lungo (max 60)."];
        }

        if (!string.IsNullOrWhiteSpace(note) && note.Trim().Length > 300)
        {
            errors["note"] = ["Note troppo lunghe (max 300)."];
        }

        if (dataRilascio is not null && dataScadenza is not null && dataScadenza.Value.Date < dataRilascio.Value.Date)
        {
            errors["dataScadenza"] = ["DataScadenza non puo essere precedente a DataRilascio."];
        }
    }
}

