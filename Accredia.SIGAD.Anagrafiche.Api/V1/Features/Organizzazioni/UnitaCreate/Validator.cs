namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaCreate;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.Nome))
        {
            errors["nome"] = ["Nome obbligatorio."];
        }
        if (command.Request.TipoUnitaOrganizzativaId <= 0)
        {
            errors["tipoUnitaOrganizzativaId"] = ["TipoUnitaOrganizzativaId obbligatorio."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

