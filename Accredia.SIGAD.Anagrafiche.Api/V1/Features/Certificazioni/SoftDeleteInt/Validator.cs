namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.SoftDeleteInt;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        if (command.CertificazioneId < 1)
        {
            return new Dictionary<string, string[]>
            {
                ["id"] = ["Id certificazione non valido."]
            };
        }

        return null;
    }
}
