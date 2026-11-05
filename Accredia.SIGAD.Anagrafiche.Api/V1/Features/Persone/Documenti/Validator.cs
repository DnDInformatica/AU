namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Documenti;

internal static class Validator
{
    private const long MaxFileSizeBytes = 25 * 1024 * 1024;

    public static Dictionary<string, string[]>? Validate(ListCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(UploadCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }

        if (command.File.Length <= 0)
        {
            errors["file"] = ["File obbligatorio."];
        }
        else if (command.File.Length > MaxFileSizeBytes)
        {
            errors["file"] = [$"File troppo grande. Limite: {MaxFileSizeBytes} byte."];
        }

        if (!string.IsNullOrWhiteSpace(command.Note) && command.Note.Trim().Length > 1000)
        {
            errors["note"] = ["Note troppo lunghe."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DownloadCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }
        if (command.DocumentoId <= 0)
        {
            errors["documentoId"] = ["DocumentoId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
        => Validate(new DownloadCommand(command.PersonaId, command.DocumentoId));
}
