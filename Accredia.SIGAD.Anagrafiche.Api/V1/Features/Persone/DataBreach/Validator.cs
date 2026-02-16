namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.DataBreach;

internal static class Validator
{
    private static readonly HashSet<string> TipoViolazione = new(StringComparer.OrdinalIgnoreCase)
    {
        "MULTIPLA",
        "DISPONIBILITA",
        "INTEGRITA",
        "RISERVATEZZA"
    };

    private static readonly HashSet<string> Rischio = new(StringComparer.OrdinalIgnoreCase)
    {
        "CRITICO",
        "ALTO",
        "MEDIO",
        "BASSO"
    };

    private static readonly HashSet<string> Stato = new(StringComparer.OrdinalIgnoreCase)
    {
        "APERTO",
        "IN_GESTIONE",
        "CHIUSO"
    };

    public static Dictionary<string, string[]>? Validate(ListCommand _)
        => null;

    public static Dictionary<string, string[]>? Validate(GetByIdCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.DataBreachId <= 0)
        {
            errors["dataBreachId"] = ["DataBreachId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(CreateCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (string.IsNullOrWhiteSpace(command.Request.Codice))
        {
            errors["codice"] = ["Codice obbligatorio."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.Titolo))
        {
            errors["titolo"] = ["Titolo obbligatorio."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.Descrizione))
        {
            errors["descrizione"] = ["Descrizione obbligatoria."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.TipoViolazione))
        {
            errors["tipoViolazione"] = ["TipoViolazione obbligatoria."];
        }
        else if (!TipoViolazione.Contains(command.Request.TipoViolazione.Trim()))
        {
            errors["tipoViolazione"] = ["TipoViolazione non valida."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.CausaViolazione))
        {
            errors["causaViolazione"] = ["CausaViolazione obbligatoria."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.CategorieDatiCoinvolti))
        {
            errors["categorieDatiCoinvolti"] = ["CategorieDatiCoinvolti obbligatorio."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.CategorieInteressati))
        {
            errors["categorieInteressati"] = ["CategorieInteressati obbligatorio."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.RischioPerInteressati))
        {
            errors["rischioPerInteressati"] = ["RischioPerInteressati obbligatorio."];
        }
        else if (!Rischio.Contains(command.Request.RischioPerInteressati.Trim()))
        {
            errors["rischioPerInteressati"] = ["RischioPerInteressati non valido."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.Stato))
        {
            errors["stato"] = ["Stato obbligatorio."];
        }
        else if (!Stato.Contains(command.Request.Stato.Trim()))
        {
            errors["stato"] = ["Stato non valido."];
        }
        if (command.Request.ResponsabileGestioneId is not null && command.Request.ResponsabileGestioneId <= 0)
        {
            errors["responsabileGestioneId"] = ["ResponsabileGestioneId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = Validate(new CreateCommand(new CreateRequest(
            command.Request.Codice,
            command.Request.Titolo,
            command.Request.Descrizione,
            command.Request.DataScoperta,
            command.Request.DataInizioViolazione,
            command.Request.DataFineViolazione,
            command.Request.TipoViolazione,
            command.Request.CausaViolazione,
            command.Request.CategorieDatiCoinvolti,
            command.Request.DatiParticolariCoinvolti,
            command.Request.NumeroInteressatiStimato,
            command.Request.CategorieInteressati,
            command.Request.RischioPerInteressati,
            command.Request.DescrizioneRischio,
            command.Request.NotificaGaranteRichiesta,
            command.Request.DataNotificaGarante,
            command.Request.ProtocolloGarante,
            command.Request.TermineNotificaGarante,
            command.Request.ComunicazioneInteressatiRichiesta,
            command.Request.DataComunicazioneInteressati,
            command.Request.ModalitaComunicazione,
            command.Request.MisureContenimento,
            command.Request.MisurePrevenzione,
            command.Request.ResponsabileGestioneId,
            command.Request.DPOCoinvolto,
            command.Request.Stato,
            command.Request.DataChiusura), command.Actor)) ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.DataBreachId <= 0)
        {
            errors["dataBreachId"] = ["DataBreachId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.DataBreachId <= 0)
        {
            errors["dataBreachId"] = ["DataBreachId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }
}

