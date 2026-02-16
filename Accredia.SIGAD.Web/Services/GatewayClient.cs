using System.Net;
using System.Net.Http.Json;
using Accredia.SIGAD.Web.Models.Auth;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Models.Search;
using Accredia.SIGAD.Web.Models.Tipologiche;

namespace Accredia.SIGAD.Web.Services;

internal sealed class GatewayClient
{
    private readonly HttpClient _httpClient;

    public GatewayClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<ApiResult<TokenResponse>> LoginAsync(LoginRequest request, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _httpClient.PostAsJsonAsync("identity/v1/auth/login", request, cancellationToken);
            if (response.IsSuccessStatusCode)
            {
                var token = await response.Content.ReadFromJsonAsync<TokenResponse>(cancellationToken);
                return token is null
                    ? ApiResult<TokenResponse>.Failure("Risposta login non valida.", response.StatusCode)
                    : ApiResult<TokenResponse>.Success(token, response.StatusCode);
            }

            if (response.StatusCode == HttpStatusCode.Unauthorized)
            {
                return ApiResult<TokenResponse>.Failure("Utente non presente o password errata.", response.StatusCode);
            }

            var error = await response.Content.ReadAsStringAsync(cancellationToken);
            return ApiResult<TokenResponse>.Failure(string.IsNullOrWhiteSpace(error) ? "Login fallito." : error, response.StatusCode);
        }
        catch (HttpRequestException)
        {
            return ApiResult<TokenResponse>.Failure("Gateway non raggiungibile. Avvia SIGAD Gateway e riprova.", null);
        }
        catch (TaskCanceledException)
        {
            return ApiResult<TokenResponse>.Failure("Timeout durante il login (Gateway non disponibile o lento).", null);
        }
        catch (Exception ex)
        {
            return ApiResult<TokenResponse>.Failure(ex.Message, null);
        }
    }

    public async Task<ApiResult> LogoutAsync(string refreshToken, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _httpClient.PostAsJsonAsync("identity/v1/auth/logout", new RefreshRequest(refreshToken), cancellationToken);
            if (response.IsSuccessStatusCode)
            {
                return ApiResult.Success(response.StatusCode);
            }

            var error = await response.Content.ReadAsStringAsync(cancellationToken);
            return ApiResult.Failure(string.IsNullOrWhiteSpace(error) ? "Logout fallito." : error, response.StatusCode);
        }
        catch (HttpRequestException)
        {
            return ApiResult.Failure("Gateway non raggiungibile durante il logout.", null);
        }
        catch (TaskCanceledException)
        {
            return ApiResult.Failure("Timeout durante il logout.", null);
        }
    }

    /// <summary>
    /// Effettua il refresh del token JWT chiamando POST /identity/v1/auth/refresh
    /// </summary>
    /// <param name="refreshToken">Refresh token corrente</param>
    /// <param name="cancellationToken">Token di cancellazione</param>
    /// <returns>Nuovo access token e refresh token oppure errore</returns>
    public async Task<ApiResult<TokenResponse>> RefreshTokenAsync(string refreshToken, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _httpClient.PostAsJsonAsync("identity/v1/auth/refresh", new RefreshRequest(refreshToken), cancellationToken);
            if (response.IsSuccessStatusCode)
            {
                var token = await response.Content.ReadFromJsonAsync<TokenResponse>(cancellationToken);
                return token is null
                    ? ApiResult<TokenResponse>.Failure("Risposta refresh non valida.", response.StatusCode)
                    : ApiResult<TokenResponse>.Success(token, response.StatusCode);
            }

            var error = await response.Content.ReadAsStringAsync(cancellationToken);
            return ApiResult<TokenResponse>.Failure(string.IsNullOrWhiteSpace(error) ? "Refresh fallito." : error, response.StatusCode);
        }
        catch (HttpRequestException)
        {
            return ApiResult<TokenResponse>.Failure("Gateway non raggiungibile durante il refresh token.", null);
        }
        catch (TaskCanceledException)
        {
            return ApiResult<TokenResponse>.Failure("Timeout durante il refresh token.", null);
        }
    }

    public async Task<ApiResult<MeResponse>> GetMeAsync(CancellationToken cancellationToken)
        => await GetAsync<MeResponse>("identity/v1/me", cancellationToken);

    public async Task<ApiResult<GlobalSearchResponse>> SearchGlobalAsync(string query, int page, int pageSize, CancellationToken cancellationToken)
    {
        var url = $"search/global?query={Uri.EscapeDataString(query)}&page={page}&pageSize={pageSize}";
        return await GetAsync<GlobalSearchResponse>(url, cancellationToken);
    }

    public async Task<ApiResult<PagedResponse<OrganizzazioneListItem>>> SearchOrganizzazioniAsync(
        string? query,
        int page,
        int pageSize,
        int? statoAttivitaId,
        int? tipoOrganizzazioneId,
        CancellationToken cancellationToken)
    {
        var url = $"anagrafiche/v1/organizzazioni/search?q={Uri.EscapeDataString(query ?? string.Empty)}&page={page}&pageSize={pageSize}";

        if (statoAttivitaId.HasValue)
        {
            url += $"&statoAttivitaId={statoAttivitaId.Value}";
        }

        if (tipoOrganizzazioneId.HasValue)
        {
            url += $"&tipoOrganizzazioneId={tipoOrganizzazioneId.Value}";
        }

        return await GetAsync<PagedResponse<OrganizzazioneListItem>>(url, cancellationToken);
    }

    public async Task<ApiResult<PagedResponse<PersonaListItem>>> SearchPersoneAsync(
        string? query,
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        var url = $"anagrafiche/v1/persone/search?q={Uri.EscapeDataString(query ?? string.Empty)}&page={page}&pageSize={pageSize}";
        return await GetAsync<PagedResponse<PersonaListItem>>(url, cancellationToken);
    }

    public async Task<ApiResult<PersonaDetail>> GetPersonaDetailAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<PersonaDetail>($"anagrafiche/v1/persone/{personaId}", cancellationToken);

    public async Task<ApiResult<PersonaDetail>> CreatePersonaAsync(CreatePersonaRequest request, CancellationToken cancellationToken)
        => await PostAsync<PersonaDetail>("anagrafiche/v1/persone", request, cancellationToken);

    public async Task<ApiResult<PersonaDetail>> UpdatePersonaAsync(int personaId, UpdatePersonaRequest request, CancellationToken cancellationToken)
        => await PutAsync<PersonaDetail>($"anagrafiche/v1/persone/{personaId}", request, cancellationToken);

    public async Task<ApiResult<object>> SoftDeletePersonaAsync(int personaId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/{personaId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<ContactLookupItem>>> GetPersonaEmailLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<ContactLookupItem>>("anagrafiche/v1/persone/email/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaEmailItem>>> GetPersonaEmailAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaEmailItem>>(
            $"anagrafiche/v1/persone/{personaId}/email?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<PersonaEmailItem>> CreatePersonaEmailAsync(int personaId, CreatePersonaEmailRequest request, CancellationToken cancellationToken)
        => await PostAsync<PersonaEmailItem>($"anagrafiche/v1/persone/{personaId}/email", request, cancellationToken);

    public async Task<ApiResult<PersonaEmailItem>> UpdatePersonaEmailAsync(
        int personaId,
        int personaEmailId,
        UpdatePersonaEmailRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<PersonaEmailItem>($"anagrafiche/v1/persone/{personaId}/email/{personaEmailId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeletePersonaEmailAsync(int personaId, int personaEmailId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/{personaId}/email/{personaEmailId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<ContactLookupItem>>> GetPersonaTelefonoLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<ContactLookupItem>>("anagrafiche/v1/persone/telefono/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaTelefonoItem>>> GetPersonaTelefoniAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaTelefonoItem>>(
            $"anagrafiche/v1/persone/{personaId}/telefoni?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<PersonaTelefonoItem>> CreatePersonaTelefonoAsync(int personaId, CreatePersonaTelefonoRequest request, CancellationToken cancellationToken)
        => await PostAsync<PersonaTelefonoItem>($"anagrafiche/v1/persone/{personaId}/telefoni", request, cancellationToken);

    public async Task<ApiResult<PersonaTelefonoItem>> UpdatePersonaTelefonoAsync(
        int personaId,
        int personaTelefonoId,
        UpdatePersonaTelefonoRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<PersonaTelefonoItem>($"anagrafiche/v1/persone/{personaId}/telefoni/{personaTelefonoId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeletePersonaTelefonoAsync(int personaId, int personaTelefonoId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/{personaId}/telefoni/{personaTelefonoId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaStoricoEvent>>> GetPersonaStoricoAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/persona", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaEmailStoricoEvent>>> GetPersonaStoricoEmailAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaEmailStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/email", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaTelefonoStoricoEvent>>> GetPersonaStoricoTelefoniAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaTelefonoStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/telefoni", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaIncaricoItem>>> GetPersonaIncarichiAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaIncaricoItem>>(
            $"anagrafiche/v1/persone/{personaId}/incarichi?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<PagedResponse<IncaricoListItem>>> SearchIncarichiAsync(
        string? query,
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        var url = $"anagrafiche/v1/incarichi/search?q={Uri.EscapeDataString(query ?? string.Empty)}&page={page}&pageSize={pageSize}";
        return await GetAsync<PagedResponse<IncaricoListItem>>(url, cancellationToken);
    }

    public async Task<ApiResult<IncaricoDetail>> GetIncaricoDetailAsync(int incaricoId, CancellationToken cancellationToken)
        => await GetAsync<IncaricoDetail>($"anagrafiche/v1/incarichi/{incaricoId}", cancellationToken);

    public async Task<ApiResult<IncaricoDetail>> CreateIncaricoAsync(CreateIncaricoRequest request, CancellationToken cancellationToken)
        => await PostAsync<IncaricoDetail>("anagrafiche/v1/incarichi", request, cancellationToken);

    public async Task<ApiResult<IncaricoDetail>> UpdateIncaricoAsync(int incaricoId, UpdateIncaricoRequest request, CancellationToken cancellationToken)
        => await PutAsync<IncaricoDetail>($"anagrafiche/v1/incarichi/{incaricoId}", request, cancellationToken);

    public async Task<ApiResult<object>> SoftDeleteIncaricoAsync(int incaricoId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/incarichi/{incaricoId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<LookupItem>>> GetIncarichiLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<LookupItem>>("anagrafiche/v1/incarichi/lookups", cancellationToken);

    public async Task<ApiResult<OrganizzazioneDetail>> GetOrganizzazioneDetailAsync(int organizzazioneId, CancellationToken cancellationToken)
        => await GetAsync<OrganizzazioneDetail>($"anagrafiche/v1/organizzazioni/{organizzazioneId}", cancellationToken);

    public async Task<ApiResult<OrganizzazioneDetail>> CreateOrganizzazioneAsync(
        CreateOrganizzazioneRequest request,
        CancellationToken cancellationToken)
        => await PostAsync<OrganizzazioneDetail>("anagrafiche/v1/organizzazioni", request, cancellationToken);

    public async Task<ApiResult<OrganizzazioneDetail>> UpdateOrganizzazioneAsync(
        int organizzazioneId,
        UpdateOrganizzazioneRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<OrganizzazioneDetail>($"anagrafiche/v1/organizzazioni/{organizzazioneId}", request, cancellationToken);

    public async Task<ApiResult<IReadOnlyList<LookupItem>>> GetOrganizzazioneStatiAttivitaLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<LookupItem>>("anagrafiche/v1/organizzazioni/stati-attivita/lookups", cancellationToken);

    public async Task<ApiResult<object>> SoftDeleteOrganizzazioneAsync(int organizzazioneId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/organizzazioni/{organizzazioneId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<SedeItem>>> GetOrganizzazioneSediAsync(int organizzazioneId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<SedeItem>>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi", cancellationToken);

    public async Task<ApiResult<SedeItem>> GetOrganizzazioneSedeAsync(int organizzazioneId, int sedeId, CancellationToken cancellationToken)
        => await GetAsync<SedeItem>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi/{sedeId}", cancellationToken);

    public async Task<ApiResult<SedeItem>> CreateSedeAsync(int organizzazioneId, CreateSedeRequest request, CancellationToken cancellationToken)
        => await PostAsync<SedeItem>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi", request, cancellationToken);

    public async Task<ApiResult<SedeItem>> UpdateSedeAsync(int organizzazioneId, int sedeId, UpdateSedeRequest request, CancellationToken cancellationToken)
        => await PutAsync<SedeItem>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi/{sedeId}", request, cancellationToken);

    public async Task<ApiResult<object>> SoftDeleteSedeAsync(int organizzazioneId, int sedeId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi/{sedeId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<LookupItem>>> GetSediLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<LookupItem>>("anagrafiche/v1/organizzazioni/sedi/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<UnitaOrganizzativaItem>>> GetOrganizzazioneUnitaAsync(int organizzazioneId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<UnitaOrganizzativaItem>>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative", cancellationToken);

    public async Task<ApiResult<UnitaLookupsResponse>> GetUnitaLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<UnitaLookupsResponse>("anagrafiche/v1/organizzazioni/unita-organizzative/lookups", cancellationToken);

    public async Task<ApiResult<UnitaOrganizzativaItem>> GetOrganizzazioneUnitaByIdAsync(int organizzazioneId, int unitaOrganizzativaId, CancellationToken cancellationToken)
        => await GetAsync<UnitaOrganizzativaItem>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative/{unitaOrganizzativaId}", cancellationToken);

    public async Task<ApiResult<UnitaOrganizzativaItem>> CreateUnitaAsync(int organizzazioneId, CreateUnitaOrganizzativaRequest request, CancellationToken cancellationToken)
        => await PostAsync<UnitaOrganizzativaItem>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative", request, cancellationToken);

    public async Task<ApiResult<UnitaOrganizzativaItem>> UpdateUnitaAsync(int organizzazioneId, int unitaOrganizzativaId, UpdateUnitaOrganizzativaRequest request, CancellationToken cancellationToken)
        => await PutAsync<UnitaOrganizzativaItem>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative/{unitaOrganizzativaId}", request, cancellationToken);

    public async Task<ApiResult<object>> SoftDeleteUnitaAsync(int organizzazioneId, int unitaOrganizzativaId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative/{unitaOrganizzativaId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<IncaricoItem>>> GetOrganizzazioneIncarichiAsync(
        int organizzazioneId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<IncaricoItem>>(
            $"anagrafiche/v1/organizzazioni/{organizzazioneId}/incarichi?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<IReadOnlyList<OrganizzazioneTipoItem>>> GetOrganizzazioneTipiAsync(int organizzazioneId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<OrganizzazioneTipoItem>>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/tipologie", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<LookupItem>>> GetOrganizzazioneTipologieLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<LookupItem>>("anagrafiche/v1/organizzazioni/tipologie/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<OrganizzazioneTipoItem>>> SetOrganizzazioneTipologiaAsync(
        int organizzazioneId,
        SetOrganizzazioneTipologiaRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<IReadOnlyList<OrganizzazioneTipoItem>>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/tipologie", request, cancellationToken);

    public async Task<ApiResult<IReadOnlyList<OrganizzazioneIdentificativoFiscaleItem>>> GetOrganizzazioneIdentificativiAsync(int organizzazioneId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<OrganizzazioneIdentificativoFiscaleItem>>($"anagrafiche/v1/organizzazioni/{organizzazioneId}/identificativi", cancellationToken);

    public async Task<ApiResult<PagedResponse<TipologicaListItem>>> GetTipologicheAsync(int page, int pageSize, string? query, CancellationToken cancellationToken)
    {
        var url = $"tipologiche/v1/tipologiche?page={page}&pageSize={pageSize}";
        if (!string.IsNullOrWhiteSpace(query))
        {
            url += $"&q={Uri.EscapeDataString(query)}";
        }

        return await GetAsync<PagedResponse<TipologicaListItem>>(url, cancellationToken);
    }

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
        catch (HttpRequestException)
        {
            return ApiResult<T>.Failure("Gateway non raggiungibile.", null);
        }
        catch (TaskCanceledException)
        {
            return ApiResult<T>.Failure("Timeout chiamata API (Gateway non disponibile o lento).", null);
        }
        catch (Exception ex)
        {
            return ApiResult<T>.Failure(ex.Message, null);
        }
    }

    private async Task<ApiResult<T>> PostAsync<T>(string url, object body, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _httpClient.PostAsJsonAsync(url, body, cancellationToken);
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
        catch (HttpRequestException)
        {
            return ApiResult<T>.Failure("Gateway non raggiungibile.", null);
        }
        catch (TaskCanceledException)
        {
            return ApiResult<T>.Failure("Timeout chiamata API (Gateway non disponibile o lento).", null);
        }
        catch (Exception ex)
        {
            return ApiResult<T>.Failure(ex.Message, null);
        }
    }

    private async Task<ApiResult<T>> PutAsync<T>(string url, object body, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _httpClient.PutAsJsonAsync(url, body, cancellationToken);
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
        catch (HttpRequestException)
        {
            return ApiResult<T>.Failure("Gateway non raggiungibile.", null);
        }
        catch (TaskCanceledException)
        {
            return ApiResult<T>.Failure("Timeout chiamata API (Gateway non disponibile o lento).", null);
        }
        catch (Exception ex)
        {
            return ApiResult<T>.Failure(ex.Message, null);
        }
    }

    private async Task<ApiResult<object>> DeleteAsync(string url, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _httpClient.DeleteAsync(url, cancellationToken);
            if (response.IsSuccessStatusCode)
            {
                return ApiResult<object>.Success(new object(), response.StatusCode);
            }

            var error = await response.Content.ReadAsStringAsync(cancellationToken);
            return ApiResult<object>.Failure(string.IsNullOrWhiteSpace(error) ? "Richiesta fallita." : error, response.StatusCode);
        }
        catch (HttpRequestException)
        {
            return ApiResult<object>.Failure("Gateway non raggiungibile.", null);
        }
        catch (TaskCanceledException)
        {
            return ApiResult<object>.Failure("Timeout chiamata API (Gateway non disponibile o lento).", null);
        }
        catch (Exception ex)
        {
            return ApiResult<object>.Failure(ex.Message, null);
        }
    }
}
