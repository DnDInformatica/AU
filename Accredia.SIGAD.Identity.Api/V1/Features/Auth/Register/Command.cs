namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Register;

internal sealed record Command(string UserName, string Email, string Password);

internal sealed record RegisterRequest(string UserName, string Email, string Password);

// Id è stringa in ASP.NET Identity
internal sealed record RegisterResponse(string UserId, string UserName, string Email);
