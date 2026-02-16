namespace Accredia.SIGAD.Identity.Api.Contracts;

public record LoginRequest(string Username, string Password);

public record TokenResponse(string AccessToken, string RefreshToken, int ExpiresInSeconds);

public record RefreshRequest(string RefreshToken);

public record LogoutUsersRequest(IReadOnlyList<string> UserIds);
