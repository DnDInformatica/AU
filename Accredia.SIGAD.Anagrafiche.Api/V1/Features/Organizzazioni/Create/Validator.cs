namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Create;

internal static class Validator
{
    private const int MaxCodiceLength = 50;
    private const int MaxDenominazioneLength = 200;

    public static Dictionary<string, string[]>? Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);

        var errors = new Dictionary<string, string[]>();
        var request = command.Request;

        if (request is null)
        {
            errors["request"] = new[] { "Request body is required." };
            return errors;
        }

        if (string.IsNullOrWhiteSpace(request.Codice))
        {
            errors["codice"] = new[] { "Codice is required." };
        }
        else if (request.Codice.Length > MaxCodiceLength)
        {
            errors["codice"] = new[] { $"Codice must be at most {MaxCodiceLength} characters." };
        }

        if (string.IsNullOrWhiteSpace(request.Denominazione))
        {
            errors["denominazione"] = new[] { "Denominazione is required." };
        }
        else if (request.Denominazione.Length > MaxDenominazioneLength)
        {
            errors["denominazione"] = new[] { $"Denominazione must be at most {MaxDenominazioneLength} characters." };
        }

        return errors.Count > 0 ? errors : null;
    }
}
