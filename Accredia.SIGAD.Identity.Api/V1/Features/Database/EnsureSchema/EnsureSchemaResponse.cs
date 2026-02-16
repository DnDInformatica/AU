namespace Accredia.SIGAD.Identity.Api.V1.Features.Database.EnsureSchema;

internal sealed record EnsureSchemaResponse(string Schema, int CurrentVersion);
