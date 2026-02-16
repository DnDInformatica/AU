namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetByIdInt;

// Keep aligned with Accredia.SIGAD.Web.Models.Anagrafiche.OrganizzazioneDetail (int-based model).
//
// NOTE:
// Dapper constructor-mapping is brittle across schema/type variants (nullable vs non-nullable,
// different SQL types, etc.). Using a DTO with a parameterless constructor and settable properties
// makes materialization resilient and avoids runtime "no matching constructor" failures.
internal sealed class OrganizzazioneDetailDto
{
    public int OrganizzazioneId { get; set; }
    public string Denominazione { get; set; } = string.Empty;
    public string RagioneSociale { get; set; } = string.Empty;
    public string? PartitaIVA { get; set; }
    public string? CodiceFiscale { get; set; }
    public string? NRegistroImprese { get; set; }
    public int? TipoCodiceNaturaGiuridicaId { get; set; }
    public string? NaturaGiuridicaDescrizione { get; set; }
    public byte? StatoAttivitaId { get; set; }
    public string? OggettoSociale { get; set; }
    public DateTime? DataIscrizioneIscrizioneRI { get; set; }
    public DateTime? DataCostituzione { get; set; }
    public DateTime? DataCancellazione { get; set; }
    public Guid? UniqueRowId { get; set; }
    public DateTime? DataCreazione { get; set; }
    public string? CreatoDa { get; set; }
    public DateTime? DataModifica { get; set; }
    public string? ModificatoDa { get; set; }
    public DateTime? DataInizioValidita { get; set; }
    public DateTime? DataFineValidita { get; set; }
}
