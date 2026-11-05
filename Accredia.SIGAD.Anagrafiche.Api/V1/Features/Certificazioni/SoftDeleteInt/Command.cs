namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.SoftDeleteInt;

internal sealed record Command(int CertificazioneId, string? Actor);
