namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SetTipologie;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>();

        if (command.OrganizzazioneId < 1)
        {
            errors["id"] = ["Id organizzazione non valido."];
        }

        if (command.Request.TipoOrganizzazioneId is < 1)
        {
            errors["tipoOrganizzazioneId"] = ["La tipologia deve essere >= 1."];
        }

        return errors.Count > 0 ? errors : null;
    }
}

