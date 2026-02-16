namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SoftDeleteInt;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        if (command.OrganizzazioneId <= 0)
        {
            return new Dictionary<string, string[]>
            {
                ["id"] = ["Id non valido."]
            };
        }

        return null;
    }
}

