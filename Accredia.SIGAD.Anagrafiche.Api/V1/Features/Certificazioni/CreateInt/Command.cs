namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.CreateInt;

internal sealed record Command(CreateCertificazioneRequest Request, string? Actor);
