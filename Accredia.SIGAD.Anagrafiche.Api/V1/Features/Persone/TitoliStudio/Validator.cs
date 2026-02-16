namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.TitoliStudio;

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

        if (command.PersonaTitoloStudioId <= 0)
        {
            errors["personaTitoloStudioId"] = ["PersonaTitoloStudioId non valido."];
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

        if (command.PersonaTitoloStudioId <= 0)
        {
            errors["personaTitoloStudioId"] = ["PersonaTitoloStudioId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static void ValidatePayload(CreateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.TipoTitoloStudioId, request.Istituzione, request.Corso, request.Voto, request.Paese, request.Note, request.DataConseguimento, errors);

    private static void ValidatePayload(UpdateRequest request, Dictionary<string, string[]> errors)
        => ValidatePayload(request.TipoTitoloStudioId, request.Istituzione, request.Corso, request.Voto, request.Paese, request.Note, request.DataConseguimento, errors);

    private static void ValidatePayload(
        int tipoTitoloStudioId,
        string? istituzione,
        string? corso,
        string? voto,
        string? paese,
        string? note,
        DateTime? dataConseguimento,
        Dictionary<string, string[]> errors)
    {
        if (tipoTitoloStudioId <= 0)
        {
            errors["tipoTitoloStudioId"] = ["TipoTitoloStudioId obbligatorio."];
        }

        if (!string.IsNullOrWhiteSpace(istituzione) && istituzione.Trim().Length > 200)
        {
            errors["istituzione"] = ["Istituzione troppo lunga (max 200)."];
        }

        if (!string.IsNullOrWhiteSpace(corso) && corso.Trim().Length > 200)
        {
            errors["corso"] = ["Corso troppo lungo (max 200)."];
        }

        if (!string.IsNullOrWhiteSpace(voto) && voto.Trim().Length > 30)
        {
            errors["voto"] = ["Voto troppo lungo (max 30)."];
        }

        if (!string.IsNullOrWhiteSpace(paese) && paese.Trim().Length > 100)
        {
            errors["paese"] = ["Paese troppo lungo (max 100)."];
        }

        if (!string.IsNullOrWhiteSpace(note) && note.Trim().Length > 300)
        {
            errors["note"] = ["Note troppo lunghe (max 300)."];
        }

        if (dataConseguimento is not null && dataConseguimento.Value.Date > DateTime.UtcNow.Date)
        {
            errors["dataConseguimento"] = ["DataConseguimento non puo essere nel futuro."];
        }
    }
}

