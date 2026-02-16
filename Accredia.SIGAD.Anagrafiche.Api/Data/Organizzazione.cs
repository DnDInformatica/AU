namespace Accredia.SIGAD.Anagrafiche.Api.Data;

internal sealed class Organizzazione
{
    public Guid OrganizzazioneId { get; set; }

    public string Codice { get; set; } = string.Empty;

    public string Denominazione { get; set; } = string.Empty;

    public bool IsActive { get; set; }

    public DateTime CreatedUtc { get; set; }
}
