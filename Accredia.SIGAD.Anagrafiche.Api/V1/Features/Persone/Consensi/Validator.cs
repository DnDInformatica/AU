namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Consensi;

internal static class Validator
{
    private static readonly HashSet<string> Modalita = new(StringComparer.OrdinalIgnoreCase)
    {
        "ALTRO",
        "APP_MOBILE",
        "PEC",
        "EMAIL",
        "TELEFONICO",
        "CARTACEO",
        "WEB"
    };

    public static Dictionary<string, string[]>? Validate(LookupsCommand _)
        => null;

    public static Dictionary<string, string[]>? Validate(ListCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(CreateCommand command)
    {
        var errors = ValidateBase(command.PersonaId, command.Request.TipoFinalitaTrattamentoId, command.Request.ModalitaAcquisizione);

        if (command.Request.DataRevoca is not null)
        {
            if (command.Request.Consenso)
            {
                errors["consenso"] = ["Consenso deve essere false se DataRevoca e' valorizzata."];
            }

            if (string.IsNullOrWhiteSpace(command.Request.ModalitaRevoca))
            {
                errors["modalitaRevoca"] = ["ModalitaRevoca obbligatoria se DataRevoca e' valorizzata."];
            }
            else if (!Modalita.Contains(command.Request.ModalitaRevoca.Trim()))
            {
                errors["modalitaRevoca"] = ["ModalitaRevoca non valida."];
            }
        }
        else if (!string.IsNullOrWhiteSpace(command.Request.ModalitaRevoca) && !Modalita.Contains(command.Request.ModalitaRevoca.Trim()))
        {
            errors["modalitaRevoca"] = ["ModalitaRevoca non valida."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(UpdateCommand command)
    {
        var errors = Validate(new CreateCommand(command.PersonaId, new CreateRequest(
            command.Request.TipoFinalitaTrattamentoId,
            command.Request.Consenso,
            command.Request.DataConsenso,
            command.Request.DataScadenza,
            command.Request.DataRevoca,
            command.Request.ModalitaAcquisizione,
            command.Request.ModalitaRevoca,
            command.Request.RiferimentoDocumento,
            command.Request.IPAddress,
            command.Request.UserAgent,
            command.Request.MotivoRevoca,
            command.Request.VersioneInformativa,
            command.Request.DataInformativa,
            command.Request.Note), command.Actor)) ?? new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);

        if (command.ConsensoPersonaId <= 0)
        {
            errors["consensoPersonaId"] = ["ConsensoPersonaId non valido."];
        }

        return errors.Count == 0 ? null : errors;
    }

    public static Dictionary<string, string[]>? Validate(DeleteCommand command)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (command.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }
        if (command.ConsensoPersonaId <= 0)
        {
            errors["consensoPersonaId"] = ["ConsensoPersonaId non valido."];
        }
        return errors.Count == 0 ? null : errors;
    }

    private static Dictionary<string, string[]> ValidateBase(int personaId, int tipoFinalitaTrattamentoId, string modalitaAcquisizione)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.OrdinalIgnoreCase);
        if (personaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }
        if (tipoFinalitaTrattamentoId <= 0)
        {
            errors["tipoFinalitaTrattamentoId"] = ["TipoFinalitaTrattamentoId non valido."];
        }
        if (string.IsNullOrWhiteSpace(modalitaAcquisizione))
        {
            errors["modalitaAcquisizione"] = ["ModalitaAcquisizione obbligatoria."];
        }
        else if (!Modalita.Contains(modalitaAcquisizione.Trim()))
        {
            errors["modalitaAcquisizione"] = ["ModalitaAcquisizione non valida."];
        }
        return errors;
    }
}

