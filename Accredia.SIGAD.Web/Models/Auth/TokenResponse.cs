namespace Accredia.SIGAD.Web.Models.Auth;

public sealed record TokenResponse(string AccessToken, string RefreshToken, int ExpiresInSeconds);
