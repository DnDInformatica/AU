namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Login;

internal sealed record Command(string UserName, string Password);
