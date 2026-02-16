namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.GetIncarichi;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        if (command.PersonaId <= 0)
        {
            return new Dictionary<string, string[]>
            {
                ["personaId"] = ["PersonaId deve essere maggiore di 0."]
            };
        }

        return null;
    }
}

