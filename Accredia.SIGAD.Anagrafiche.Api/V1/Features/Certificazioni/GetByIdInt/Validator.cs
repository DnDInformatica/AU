namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.GetByIdInt;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        var errors = new Dictionary<string, string[]>();
        if (command.CertificazioneId < 1)
        {
            errors["id"] = ["Id certificazione non valido."];
        }

        return errors.Count > 0 ? errors : null;
    }
}
