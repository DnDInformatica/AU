namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.UpdateInt;

internal sealed record Command(int IncaricoId, UpdateIncaricoRequest Request, string? Actor);

