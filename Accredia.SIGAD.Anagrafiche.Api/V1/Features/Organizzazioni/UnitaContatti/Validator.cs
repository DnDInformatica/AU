namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaContatti;

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

    public static Dictionary<string, string[]>? Validate(CreateCommand command)
        => ValidatePayload(command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, command.Request.TipoContattoId, command.Request.Valore, command.Request.DataInizio, command.Request.DataFine);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, command.Request.TipoContattoId, command.Request.Valore, command.Request.DataInizio, command.Request.DataFine)
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.ContattoId <= 0)
        {
            errors["contattoId"] = ["ContattoId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.OrganizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (command.ContattoId <= 0)
        {
            errors["contattoId"] = ["ContattoId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(
        int organizzazioneId,
        int unitaOrganizzativaId,
        int tipoContattoId,
        string valore,
        DateTime? dataInizio,
        DateTime? dataFine)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (organizzazioneId <= 0)
        {
            errors["organizzazioneId"] = ["OrganizzazioneId non valido."];
        }

        if (unitaOrganizzativaId <= 0)
        {
            errors["unitaOrganizzativaId"] = ["UnitaOrganizzativaId non valido."];
        }

        if (tipoContattoId <= 0)
        {
            errors["tipoContattoId"] = ["TipoContattoId non valido."];
        }

        if (string.IsNullOrWhiteSpace(valore))
        {
            errors["valore"] = ["Valore obbligatorio."];
        }

        if (dataInizio.HasValue && dataFine.HasValue && dataFine.Value.Date < dataInizio.Value.Date)
        {
            errors["dataFine"] = ["DataFine non puo essere precedente a DataInizio."];
        }

        return errors.Count == 0 ? null : errors;
    }
}
