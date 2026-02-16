using Microsoft.AspNetCore.Components.Authorization;
using Accredia.SIGAD.Web.Models.Auth;

namespace Accredia.SIGAD.Web.Services;

internal sealed class UserContext
{
    private readonly GatewayClient _gatewayClient;
    private readonly AuthenticationStateProvider _authStateProvider;
    private readonly ILogger<UserContext> _logger;
    private readonly SemaphoreSlim _lock = new(1, 1);
    private bool _loaded;

    public UserContext(GatewayClient gatewayClient, AuthenticationStateProvider authStateProvider, ILogger<UserContext> logger)
    {
        _gatewayClient = gatewayClient;
        _authStateProvider = authStateProvider;
        _logger = logger;
    }

    public MeResponse? Current { get; private set; }

    public bool IsAuthenticated => Current is not null;

    public bool IsAdmin => HasRole("SIGAD_ADMIN") || HasRole("SIGAD_SUPERADMIN");

    public bool HasRole(string role)
        => Current?.Roles.Any(r => string.Equals(r, role, StringComparison.OrdinalIgnoreCase)) ?? false;

    public bool HasPermission(string permission)
        => Current?.Permissions.Any(p => string.Equals(p, permission, StringComparison.OrdinalIgnoreCase)) ?? false;

    public async Task EnsureLoadedAsync(CancellationToken cancellationToken = default)
    {
        if (_loaded)
        {
            return;
        }

        await _lock.WaitAsync(cancellationToken);
        try
        {
            if (_loaded)
            {
                return;
            }

            var authState = await _authStateProvider.GetAuthenticationStateAsync();
            if (authState.User.Identity?.IsAuthenticated != true)
            {
                Current = null;
                _loaded = true;
                return;
            }

            var result = await _gatewayClient.GetMeAsync(cancellationToken);
            if (result.IsSuccess && result.Data is not null)
            {
                Current = result.Data;
            }
            else
            {
                _logger.LogWarning("Impossibile caricare /me: {Error}", result.Error ?? "unknown");
                Current = null;
            }

            _loaded = true;
        }
        finally
        {
            _lock.Release();
        }
    }

    public void Reset()
    {
        _loaded = false;
        Current = null;
    }
}
