namespace Accredia.SIGAD.Web.Models.Auth;

public sealed record MeResponse(string UserId, string Username, IReadOnlyList<string> Roles, IReadOnlyList<string> Permissions);
