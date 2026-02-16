namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.CreateInt;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>();

        if (command.Request.PersonaId < 1)
        {
            errors["personaId"] = ["Persona obbligatoria."];
        }

        if (command.Request.OrganizzazioneId < 1)
        {
            errors["organizzazioneId"] = ["Organizzazione obbligatoria."];
        }

        if (!command.Request.TipoRuoloId.HasValue)
        {
            errors["tipoRuoloId"] = ["Tipo ruolo obbligatorio."];
        }
        else if (command.Request.TipoRuoloId is < 1)
        {
            errors["tipoRuoloId"] = ["Tipo ruolo non valido."];
        }

        if (string.IsNullOrWhiteSpace(command.Request.StatoIncarico))
        {
            errors["statoIncarico"] = ["Stato incarico obbligatorio."];
        }
        else if (command.Request.StatoIncarico.Trim().Length > 50)
        {
            errors["statoIncarico"] = ["Stato incarico troppo lungo (max 50)."];
        }

        if (command.Request.DataInizio == default)
        {
            errors["dataInizio"] = ["Data inizio obbligatoria."];
        }

        if (command.Request.DataFine.HasValue && command.Request.DataFine.Value < command.Request.DataInizio)
        {
            errors["dataFine"] = ["Data fine non puo essere precedente alla data inizio."];
        }

        if (command.Request.UnitaOrganizzativaId is < 1)
        {
            errors["unitaOrganizzativaId"] = ["Unita organizzativa non valida."];
        }

        return errors.Count > 0 ? errors : null;
    }
}
