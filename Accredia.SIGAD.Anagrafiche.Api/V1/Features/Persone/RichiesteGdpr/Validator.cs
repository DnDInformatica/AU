namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RichiesteGdpr;

internal static class Validator
{
    private static readonly HashSet<string> Canali = new(StringComparer.OrdinalIgnoreCase)
    {
        "TELEFONO",
        "APP_MOBILE",
        "WEB",
        "SPORTELLO",
        "RACCOMANDATA",
        "PEC",
        "EMAIL"
    };

    private static readonly HashSet<string> Stati = new(StringComparer.OrdinalIgnoreCase)
    {
        "RICEVUTA",
        "IN_LAVORAZIONE",
        "IN_ATTESA_DOC",
        "COMPLETATA",
        "ANNULLATA"
    };

    private static readonly HashSet<string> Esiti = new(StringComparer.OrdinalIgnoreCase)
    {
        "ACCOLTA",
        "PARZIALMENTE_ACCOLTA",
        "NEGATA",
        "ANNULLATA",
        "NON_APPLICABILE"
    };

    public static Dictionary<string, string[]>? Validate(LookupsCommand _)
        => null;

    public static Dictionary<string, string[]>? Validate(ListCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId is not null && command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(GetByIdCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.RichiestaGdprId <= 0)
        {
            errors["richiestaGdprId"] = ["RichiestaGdprId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(CreateCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.Request.PersonaId is not null && command.Request.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.NomeRichiedente))
        {
            errors["nomeRichiedente"] = ["NomeRichiedente obbligatorio."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.CognomeRichiedente))
        {
            errors["cognomeRichiedente"] = ["CognomeRichiedente obbligatorio."];
        }
        if (command.Request.TipoDirittoInteressatoId <= 0)
        {
            errors["tipoDirittoInteressatoId"] = ["TipoDirittoInteressatoId non valido."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.Codice))
        {
            errors["codice"] = ["Codice obbligatorio."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.CanaleRichiesta))
        {
            errors["canaleRichiesta"] = ["CanaleRichiesta obbligatorio."];
        }
        else if (!Canali.Contains(command.Request.CanaleRichiesta.Trim()))
        {
            errors["canaleRichiesta"] = ["CanaleRichiesta non valido."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.Stato))
        {
            errors["stato"] = ["Stato obbligatorio."];
        }
        else if (!Stati.Contains(command.Request.Stato.Trim()))
        {
            errors["stato"] = ["Stato non valido."];
        }
        if (!string.IsNullOrWhiteSpace(command.Request.EsitoRichiesta) && !Esiti.Contains(command.Request.EsitoRichiesta.Trim()))
        {
            errors["esitoRichiesta"] = ["EsitoRichiesta non valido."];
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
            command.Request.PersonaId,
            command.Request.NomeRichiedente,
            command.Request.CognomeRichiedente,
            command.Request.EmailRichiedente,
            command.Request.TelefonoRichiedente,
            command.Request.TipoDirittoInteressatoId,
            command.Request.Codice,
            command.Request.DataRichiesta,
            command.Request.CanaleRichiesta,
            command.Request.DescrizioneRichiesta,
            command.Request.DocumentoIdentita,
            command.Request.DataScadenzaRisposta,
            command.Request.Stato,
            command.Request.ResponsabileGestioneId,
            command.Request.DataPresaInCarico,
            command.Request.DataRisposta,
            command.Request.EsitoRichiesta,
            command.Request.MotivoRifiuto,
            command.Request.DescrizioneRisposta,
            command.Request.ModalitaRisposta,
            command.Request.RiferimentoDocumentoRisposta,
            command.Request.Note), command.Actor)) ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.RichiestaGdprId <= 0)
        {
            errors["richiestaGdprId"] = ["RichiestaGdprId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.RichiestaGdprId <= 0)
        {
            errors["richiestaGdprId"] = ["RichiestaGdprId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }
}

