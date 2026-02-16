namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIncarichi;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);

        if (command.OrganizzazioneId < 1)
        {
            return new Dictionary<string, string[]> { ["id"] = ["Id deve essere >= 1."] };
        }

        return null;
    }
}

