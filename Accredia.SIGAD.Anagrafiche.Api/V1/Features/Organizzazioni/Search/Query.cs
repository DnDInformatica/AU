namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Search;

internal sealed record Query(string Q, int Page, int PageSize, byte? StatoAttivitaId, int? TipoOrganizzazioneId);
