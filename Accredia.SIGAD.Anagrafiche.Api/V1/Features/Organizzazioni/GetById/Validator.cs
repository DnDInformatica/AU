namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetById;

internal static class Validator
{
    public static Dictionary<string, string[]>? Validate(Command command)
    {
        ArgumentNullException.ThrowIfNull(command);

        if (command.OrganizzazioneId == Guid.Empty)
        {
            return new Dictionary<string, string[]> { ["id"] = new[] { "Id must be a non-empty GUID." } };
        }

        return null;
    }
}
