using System.Net.Http.Json;
using Accredia.SIGAD.Web.Models.Admin;
using Accredia.SIGAD.Web.Models.Common;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Client per le operazioni amministrative (User, Role, Permission management).
/// 
/// AUTENTICAZIONE RICHIESTA:
/// Tutti i metodi richiedono che l'utente sia autenticato e abbia i permessi admin appropriati.
/// Il GatewayAuthorizationHandler injecta automaticamente il Bearer token.
/// 
/// PERMESSI RICHIESTI:
/// - User Management: ADMIN.USERS.MANAGE
/// - Role Management: ADMIN.ROLES.MANAGE
/// - Permission Management: ADMIN.PERMISSIONS.MANAGE
/// </summary>
internal sealed class AdminClient
{
    private readonly HttpClient _httpClient;

    public AdminClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    // ==========================================
    // USER MANAGEMENT
    // ==========================================

    /// <summary>
    /// Ottiene la lista di tutti gli utenti (paginata)
    /// </summary>
    public async Task<ApiResult<UsersListResponse>> GetUsersAsync(int page, int pageSize, CancellationToken cancellationToken)
    {
        var url = $"identity/v1/users?page={page}&pageSize={pageSize}";
        return await GetAsync<UsersListResponse>(url, cancellationToken);
    }

    /// <summary>
    /// Ottiene i dettagli di un utente specifico
    /// </summary>
    public async Task<ApiResult<UserListDto>> GetUserAsync(string userId, CancellationToken cancellationToken)
    {
        var url = $"identity/v1/users/{userId}";
        return await GetAsync<UserListDto>(url, cancellationToken);
    }

    /// <summary>
    /// Ottiene i ruoli assegnati a un utente
    /// </summary>
    public async Task<ApiResult<List<RoleDto>>> GetUserRolesAsync(string userId, CancellationToken cancellationToken)
    {
        var url = $"identity/v1/users/{userId}/roles";
        return await GetAsync<List<RoleDto>>(url, cancellationToken);
    }

    /// <summary>
    /// Assegna ruoli a un utente (sovrascrive i ruoli esistenti)
    /// </summary>
    public async Task<ApiResult> SetUserRolesAsync(string userId, List<string> roles, CancellationToken cancellationToken)
    {
        var request = new SetUserRolesRequest { Roles = roles };
        var response = await _httpClient.PutAsJsonAsync($"identity/v1/users/{userId}/roles", request, cancellationToken);
        
        if (response.IsSuccessStatusCode)
        {
            return ApiResult.Success(response.StatusCode);
        }

        var error = await response.Content.ReadAsStringAsync(cancellationToken);
        return ApiResult.Failure(string.IsNullOrWhiteSpace(error) ? "Assegnazione ruoli fallita." : error, response.StatusCode);
    }

    /// <summary>
    /// Esegue il logout forzato di uno o piu' utenti (admin action).
    /// Identity API espone solo bulk logout: POST /identity/v1/auth/logout/users
    /// </summary>
    public async Task<ApiResult> LogoutUsersAsync(List<string> userIds, CancellationToken cancellationToken)
    {
        var request = new LogoutUsersRequest(userIds);
        var response = await _httpClient.PostAsJsonAsync("identity/v1/auth/logout/users", request, cancellationToken);
        
        if (response.IsSuccessStatusCode)
        {
            return ApiResult.Success(response.StatusCode);
        }

        var error = await response.Content.ReadAsStringAsync(cancellationToken);
        return ApiResult.Failure(string.IsNullOrWhiteSpace(error) ? "Logout utenti fallito." : error, response.StatusCode);
    }

    // ==========================================
    // ROLE MANAGEMENT
    // ==========================================

    /// <summary>
    /// Ottiene la lista di tutti i ruoli
    /// </summary>
    public async Task<ApiResult<List<RoleDto>>> GetRolesAsync(CancellationToken cancellationToken)
    {
        return await GetAsync<List<RoleDto>>("identity/v1/roles", cancellationToken);
    }

    /// <summary>
    /// Ottiene i permessi assegnati a un ruolo
    /// </summary>
    public async Task<ApiResult<RolePermissionsResponse>> GetRolePermissionsAsync(string roleId, CancellationToken cancellationToken)
    {
        var url = $"identity/v1/roles/{roleId}/permissions";
        return await GetAsync<RolePermissionsResponse>(url, cancellationToken);
    }

    /// <summary>
    /// Aggiorna i permessi di un ruolo (sovrascrive i permessi esistenti)
    /// </summary>
    public async Task<ApiResult> UpdateRolePermissionsAsync(string roleId, List<string> permissions, CancellationToken cancellationToken)
    {
        var request = new UpdateRolePermissionsRequest { Permissions = permissions };
        var response = await _httpClient.PutAsJsonAsync($"identity/v1/roles/{roleId}/permissions", request, cancellationToken);
        
        if (response.IsSuccessStatusCode)
        {
            return ApiResult.Success(response.StatusCode);
        }

        var error = await response.Content.ReadAsStringAsync(cancellationToken);
        return ApiResult.Failure(string.IsNullOrWhiteSpace(error) ? "Aggiornamento permessi fallito." : error, response.StatusCode);
    }

    // ==========================================
    // PERMISSION MANAGEMENT
    // ==========================================

    /// <summary>
    /// Ottiene la lista di tutti i permessi disponibili nel sistema (27 totali)
    /// </summary>
    public async Task<ApiResult<List<PermissionDto>>> GetPermissionsAsync(CancellationToken cancellationToken)
    {
        return await GetAsync<List<PermissionDto>>("identity/v1/permissions", cancellationToken);
    }

    // ==========================================
    // CONVENIENCE METHODS (for Razor components)
    // ==========================================

    /// <summary>
    /// Ottiene tutti gli utenti (wrapper per compatibilità Razor)
    /// </summary>
    public async Task<ApiResult<List<UserListDto>>> GetAllUsersAsync(CancellationToken cancellationToken = default)
    {
        // Per ora ritorna tutti gli utenti (server-side paginato, qui facciamo 1 pagina "larga").
        var result = await GetUsersAsync(1, 200, cancellationToken);

        if (!result.IsSuccess || result.Data is null)
        {
            return ApiResult<List<UserListDto>>.Failure(result.Error ?? "Impossibile recuperare utenti", result.StatusCode);
        }

        return ApiResult<List<UserListDto>>.Success(result.Data.Users.ToList(), result.StatusCode!.Value);
    }

    /// <summary>
    /// Ottiene tutti i ruoli (wrapper per compatibilità Razor)
    /// </summary>
    public async Task<ApiResult<List<RoleDto>>> GetAllRolesAsync(CancellationToken cancellationToken = default)
    {
        var result = await GetRolesAsync(cancellationToken);
        
        if (!result.IsSuccess || result.Data == null)
        {
            return ApiResult<List<RoleDto>>.Failure(result.Error ?? "Impossibile recuperare ruoli", result.StatusCode);
        }

        return ApiResult<List<RoleDto>>.Success(result.Data, result.StatusCode!.Value);
    }

    /// <summary>
    /// Aggiorna ruoli utente (wrapper per compatibilità Razor con Guid)
    /// </summary>
    public async Task<ApiResult> UpdateUserRolesAsync(UpdateUserRolesRequest request, CancellationToken cancellationToken = default)
    {
        return await SetUserRolesAsync(request.UserId, request.RoleNames, cancellationToken);
    }

    /// <summary>
    /// Logout utente singolo (wrapper).
    /// </summary>
    public async Task<ApiResult> LogoutUserAsync(string userId, CancellationToken cancellationToken = default)
    {
        return await LogoutUsersAsync(new List<string> { userId }, cancellationToken);
    }

    /// <summary>
    /// Bulk logout (wrapper).
    /// </summary>
    public async Task<ApiResult> BulkLogoutAsync(LogoutUsersRequest request, CancellationToken cancellationToken = default)
    {
        return await LogoutUsersAsync(request.UserIds, cancellationToken);
    }

    // ==========================================
    // HELPER METHODS
    // ==========================================

    private async Task<ApiResult<T>> GetAsync<T>(string url, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _httpClient.GetAsync(url, cancellationToken);
            if (response.IsSuccessStatusCode)
            {
                var data = await response.Content.ReadFromJsonAsync<T>(cancellationToken);
                return data is null
                    ? ApiResult<T>.Failure("Risposta non valida.", response.StatusCode)
                    : ApiResult<T>.Success(data, response.StatusCode);
            }

            var error = await response.Content.ReadAsStringAsync(cancellationToken);
            return ApiResult<T>.Failure(string.IsNullOrWhiteSpace(error) ? "Richiesta fallita." : error, response.StatusCode);
        }
        catch (Exception ex)
        {
            return ApiResult<T>.Failure(ex.Message, null);
        }
    }
}
