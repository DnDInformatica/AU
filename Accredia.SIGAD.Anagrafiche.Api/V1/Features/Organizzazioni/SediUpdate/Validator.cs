namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediUpdate;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }
        if (command.SedeId <= 0)
        {
            errors["sedeId"] = ["SedeId non valido."];
        }

        if (command.Request.DataApertura.HasValue && command.Request.DataCessazione.HasValue
            && command.Request.DataCessazione.Value < command.Request.DataApertura.Value)
        {
            errors["dataCessazione"] = ["Data cessazione non puo essere antecedente alla data apertura."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

