namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutUsers;

internal sealed record Command(IReadOnlyList<string> UserIds);
