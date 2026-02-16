namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RichiesteEsercizioDiritti;

internal static class Validator
{
    private static readonly HashSet<string> Modalita = new(StringComparer.OrdinalIgnoreCase)
    {
        "TELEFONO",
        "WEB",
        "CARTACEO",
        "PEC",
        "EMAIL"
    };

    private static readonly HashSet<string> Stati = new(StringComparer.OrdinalIgnoreCase)
    {
        "RICEVUTA",
        "IN_VERIFICA",
        "IN_LAVORAZIONE",
        "COMPLETATA",
        "ANNULLATA"
    };

    private static readonly HashSet<string> Esiti = new(StringComparer.OrdinalIgnoreCase)
    {
        "ACCOLTA",
        "PARZIALE",
        "RIFIUTATA"
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
        if (command.RichiestaEsercizioDirittiId <= 0)
        {
            errors["richiestaEsercizioDirittiId"] = ["RichiestaEsercizioDirittiId non valido."];
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
        if (string.IsNullOrWhiteSpace(command.Request.EmailRichiedente))
        {
            errors["emailRichiedente"] = ["EmailRichiedente obbligatoria."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.Codice))
        {
            errors["codice"] = ["Codice obbligatorio."];
        }
        if (command.Request.TipoDirittoGdprId <= 0)
        {
            errors["tipoDirittoGdprId"] = ["TipoDirittoGDPRId non valido."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.ModalitaRichiesta))
        {
            errors["modalitaRichiesta"] = ["ModalitaRichiesta obbligatoria."];
        }
        else if (!Modalita.Contains(command.Request.ModalitaRichiesta.Trim()))
        {
            errors["modalitaRichiesta"] = ["ModalitaRichiesta non valida."];
        }
        if (string.IsNullOrWhiteSpace(command.Request.Stato))
        {
            errors["stato"] = ["Stato obbligatorio."];
        }
        else if (!Stati.Contains(command.Request.Stato.Trim()))
        {
            errors["stato"] = ["Stato non valido."];
        }
        if (!string.IsNullOrWhiteSpace(command.Request.EsitoRisposta) && !Esiti.Contains(command.Request.EsitoRisposta.Trim()))
        {
            errors["esitoRisposta"] = ["EsitoRisposta non valido."];
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
            command.Request.EmailRichiedente,
            command.Request.TelefonoRichiedente,
            command.Request.Codice,
            command.Request.TipoDirittoGdprId,
            command.Request.DataRichiesta,
            command.Request.ModalitaRichiesta,
            command.Request.TestoRichiesta,
            command.Request.DocumentoRichiesta,
            command.Request.IdentitaVerificata,
            command.Request.DataVerificaIdentita,
            command.Request.ModalitaVerifica,
            command.Request.DataScadenza,
            command.Request.DataProrogaRichiesta,
            command.Request.MotivoProrogaRichiesta,
            command.Request.Stato,
            command.Request.ResponsabileGestioneId,
            command.Request.Note,
            command.Request.DataRisposta,
            command.Request.EsitoRisposta,
            command.Request.MotivoRifiuto,
            command.Request.TestoRisposta,
            command.Request.DocumentoRisposta,
            command.Request.DataEsecuzione,
            command.Request.DatiCancellati), command.Actor)) ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.RichiestaEsercizioDirittiId <= 0)
        {
            errors["richiestaEsercizioDirittiId"] = ["RichiestaEsercizioDirittiId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.RichiestaEsercizioDirittiId <= 0)
        {
            errors["richiestaEsercizioDirittiId"] = ["RichiestaEsercizioDirittiId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }
}

