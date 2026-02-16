namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SetTipologie;

internal sealed record Command(int OrganizzazioneId, SetOrganizzazioneTipologiaRequest Request, string? Actor);

