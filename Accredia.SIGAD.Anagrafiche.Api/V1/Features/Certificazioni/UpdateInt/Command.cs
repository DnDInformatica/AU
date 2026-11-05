namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.UpdateInt;

internal sealed record Command(int CertificazioneId, UpdateCertificazioneRequest Request, string? Actor);
