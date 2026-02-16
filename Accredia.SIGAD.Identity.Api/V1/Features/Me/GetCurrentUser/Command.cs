namespace Accredia.SIGAD.Identity.Api.V1.Features.Me.GetCurrentUser;

// UserId è stringa in ASP.NET Identity, non GUID
internal sealed record Command(string UserId);
