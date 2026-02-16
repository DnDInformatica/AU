namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIva;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(ListCommand command)
        => null;

    public static Dictionary<string, string[]>? Validate(CreateCommand command)
        => ValidatePayload(command.Request.PartitaIvaGruppo, command.Request.Denominazione, command.Request.DataCostituzione, command.Request.DataCessazione);

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = ValidatePayload(command.Request.PartitaIvaGruppo, command.Request.Denominazione, command.Request.DataCostituzione, command.Request.DataCessazione)
                     ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.GruppoIvaId <= 0)
        {
            errors["gruppoIvaId"] = ["GruppoIvaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.GruppoIvaId <= 0)
        {
            errors["gruppoIvaId"] = ["GruppoIvaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]>? ValidatePayload(
        string partitaIvaGruppo,
        string denominazione,
        DateTime? dataCostituzione,
        DateTime? dataCessazione)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (string.IsNullOrWhiteSpace(partitaIvaGruppo))
        {
            errors["partitaIvaGruppo"] = ["PartitaIvaGruppo obbligatoria."];
        }

        if (string.IsNullOrWhiteSpace(denominazione))
        {
            errors["denominazione"] = ["Denominazione obbligatoria."];
        }

        if (dataCostituzione.HasValue && dataCessazione.HasValue && dataCessazione.Value.Date < dataCostituzione.Value.Date)
        {
            errors["dataCessazione"] = ["DataCessazione non puo essere precedente a DataCostituzione."];
        }

        return errors.Count == 0 ? null : errors;
    }
}
