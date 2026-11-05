namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.CreateInt;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>();

        if (string.IsNullOrWhiteSpace(command.Request.Denominazione))
        {
            errors["denominazione"] = ["Denominazione obbligatoria."];
        }
        else if (command.Request.Denominazione.Trim().Length > 300)
        {
            errors["denominazione"] = ["Denominazione troppo lunga (max 300)."];
        }

        if (!string.IsNullOrWhiteSpace(command.Request.Sigla) && command.Request.Sigla.Trim().Length > 50)
        {
            errors["sigla"] = ["Sigla troppo lunga (max 50)."];
        }

        if (!string.IsNullOrWhiteSpace(command.Request.Note) && command.Request.Note.Trim().Length > 2000)
        {
            errors["note"] = ["Note troppo lunghe (max 2000)."];
        }

        if (command.Request.DataFondazione.HasValue && command.Request.DataFondazione.Value.Year < 1800)
        {
            errors["dataFondazione"] = ["Data fondazione non valida."];
        }

        return errors.Count > 0 ? errors : null;
    }
}
