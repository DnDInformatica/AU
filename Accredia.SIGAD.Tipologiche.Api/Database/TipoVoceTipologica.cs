namespace Accredia.SIGAD.Tipologiche.Api.Database;

internal sealed class TipoVoceTipologica
{
    public int Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public bool IsActive { get; set; }
    public int Ordine { get; set; }
}
