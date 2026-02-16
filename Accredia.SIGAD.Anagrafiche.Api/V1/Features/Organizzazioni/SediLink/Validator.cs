namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediLink;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(ListCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(LinkCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (command.Request.TipoOrganizzazioneSedeId <= 0)
        {
            errors["tipoOrganizzazioneSedeId"] = ["TipoOrganizzazioneSedeId obbligatorio."];
        }

        if (!string.IsNullOrWhiteSpace(command.Request.Denominazione) && command.Request.Denominazione.Trim().Length > 250)
        {
            errors["denominazione"] = ["Denominazione troppo lunga (max 250)."];
        }

        if (!string.IsNullOrWhiteSpace(command.Request.Insegna) && command.Request.Insegna.Trim().Length > 250)
        {
            errors["insegna"] = ["Insegna troppo lunga (max 250)."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(UnlinkCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (command.OrganizzazioneSedeId <= 0)
        {
            errors["organizzazioneSedeId"] = ["OrganizzazioneSedeId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }
}

