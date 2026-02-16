namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RegistroTrattamenti;

internal static class Validator
{
    private static readonly HashSet<string> BaseGiuridica = new(StringComparer.OrdinalIgnoreCase)
    {
        "ART6_1_A",
        "ART6_1_B",
        "ART6_1_C",
        "ART6_1_D",
        "ART6_1_E",
        "ART6_1_F"
    };

    private static readonly HashSet<string> Stato = new(StringComparer.OrdinalIgnoreCase)
    {
        "ATTIVO",
        "SOSPESO",
        "CESSATO"
    };

    public static Dictionary<string, string[]>? Validate(LookupsCommand _)
        => null;

    public static Dictionary<string, string[]>? Validate(ListCommand _)
        => null;

    public static Dictionary<string, string[]>? Validate(GetByIdCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.RegistroTrattamentiId <= 0)
        {
            errors["registroTrattamentiId"] = ["RegistroTrattamentiId non valido."];
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
        if (string.IsNullOrWhiteSpace(command.Request.NomeTrattamento))
        {
            errors["nomeTrattamento"] = ["NomeTrattamento obbligatorio."];
        }
        if (command.Request.TipoFinalitaTrattamentoId <= 0)
        {
            errors["tipoFinalitaTrattamentoId"] = ["TipoFinalitaTrattamentoId non valido."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.BaseGiuridica))
        {
            errors["baseGiuridica"] = ["BaseGiuridica obbligatoria."];
        }
        else if (!BaseGiuridica.Contains(command.Request.BaseGiuridica.Trim()))
        {
            errors["baseGiuridica"] = ["BaseGiuridica non valida."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.CategorieDati))
        {
            errors["categorieDati"] = ["CategorieDati obbligatorie."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.CategorieInteressati))
        {
            errors["categorieInteressati"] = ["CategorieInteressati obbligatorie."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.TermineConservazione))
        {
            errors["termineConservazione"] = ["TermineConservazione obbligatorio."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.Stato))
        {
            errors["stato"] = ["Stato obbligatorio."];
        }
        else if (!Stato.Contains(command.Request.Stato.Trim()))
        {
            errors["stato"] = ["Stato non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = Validate(new CreateCommand(new CreateRequest(
            command.Request.Codice,
            command.Request.NomeTrattamento,
            command.Request.Descrizione,
            command.Request.TipoFinalitaTrattamentoId,
            command.Request.BaseGiuridica,
            command.Request.CategorieDati,
            command.Request.CategorieInteressati,
            command.Request.DatiParticolari,
            command.Request.DatiGiudiziari,
            command.Request.CategorieDestinatari,
            command.Request.TrasferimentoExtraUE,
            command.Request.PaesiExtraUE,
            command.Request.GaranzieExtraUE,
            command.Request.TermineConservazione,
            command.Request.TermineConservazioneGiorni,
            command.Request.MisureSicurezza,
            command.Request.ResponsabileTrattamentoId,
            command.Request.ContitolareId,
            command.Request.DPONotificato,
            command.Request.Stato,
            command.Request.DataInizioTrattamento,
            command.Request.DataFineTrattamento), command.Actor)) ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.RegistroTrattamentiId <= 0)
        {
            errors["registroTrattamentiId"] = ["RegistroTrattamentiId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.RegistroTrattamentiId <= 0)
        {
            errors["registroTrattamentiId"] = ["RegistroTrattamentiId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }
}

