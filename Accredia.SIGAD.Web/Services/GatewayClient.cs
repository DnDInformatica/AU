using System.Net;
using System.Net.Http.Json;
using Accredia.SIGAD.Web.Models.Auth;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Models.RisorseUmane;
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

    public async Task<ApiResult<IReadOnlyList<ContactLookupItem>>> GetPersonaIndirizziLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<ContactLookupItem>>("anagrafiche/v1/persone/indirizzi/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaIndirizzoItem>>> GetPersonaIndirizziAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaIndirizzoItem>>(
            $"anagrafiche/v1/persone/{personaId}/indirizzi?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<PersonaIndirizzoItem>> CreatePersonaIndirizzoAsync(int personaId, CreatePersonaIndirizzoRequest request, CancellationToken cancellationToken)
        => await PostAsync<PersonaIndirizzoItem>($"anagrafiche/v1/persone/{personaId}/indirizzi", request, cancellationToken);

    public async Task<ApiResult<PersonaIndirizzoItem>> UpdatePersonaIndirizzoAsync(
        int personaId,
        int personaIndirizzoId,
        UpdatePersonaIndirizzoRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<PersonaIndirizzoItem>($"anagrafiche/v1/persone/{personaId}/indirizzi/{personaIndirizzoId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeletePersonaIndirizzoAsync(int personaId, int personaIndirizzoId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/{personaId}/indirizzi/{personaIndirizzoId}", cancellationToken);

    public async Task<ApiResult<QualificheLookupsResponse>> GetPersonaQualificheLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<QualificheLookupsResponse>("anagrafiche/v1/persone/qualifiche/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaQualificaItem>>> GetPersonaQualificheAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaQualificaItem>>(
            $"anagrafiche/v1/persone/{personaId}/qualifiche?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<PersonaQualificaItem>> CreatePersonaQualificaAsync(int personaId, CreatePersonaQualificaRequest request, CancellationToken cancellationToken)
        => await PostAsync<PersonaQualificaItem>($"anagrafiche/v1/persone/{personaId}/qualifiche", request, cancellationToken);

    public async Task<ApiResult<PersonaQualificaItem>> UpdatePersonaQualificaAsync(
        int personaId,
        int personaQualificaId,
        UpdatePersonaQualificaRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<PersonaQualificaItem>($"anagrafiche/v1/persone/{personaId}/qualifiche/{personaQualificaId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeletePersonaQualificaAsync(int personaId, int personaQualificaId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/{personaId}/qualifiche/{personaQualificaId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<TipoRelazionePersonaleLookupItem>>> GetPersonaRelazioniPersonaliLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<TipoRelazionePersonaleLookupItem>>("anagrafiche/v1/persone/relazioni-personali/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaRelazionePersonaleItem>>> GetPersonaRelazioniPersonaliAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaRelazionePersonaleItem>>(
            $"anagrafiche/v1/persone/{personaId}/relazioni-personali?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<PersonaRelazionePersonaleItem>> CreatePersonaRelazionePersonaleAsync(int personaId, CreatePersonaRelazionePersonaleRequest request, CancellationToken cancellationToken)
        => await PostAsync<PersonaRelazionePersonaleItem>($"anagrafiche/v1/persone/{personaId}/relazioni-personali", request, cancellationToken);

    public async Task<ApiResult<PersonaRelazionePersonaleItem>> UpdatePersonaRelazionePersonaleAsync(
        int personaId,
        int personaRelazionePersonaleId,
        UpdatePersonaRelazionePersonaleRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<PersonaRelazionePersonaleItem>($"anagrafiche/v1/persone/{personaId}/relazioni-personali/{personaRelazionePersonaleId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeletePersonaRelazionePersonaleAsync(int personaId, int personaRelazionePersonaleId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/{personaId}/relazioni-personali/{personaRelazionePersonaleId}", cancellationToken);

    public async Task<ApiResult<TitoliStudioLookupsResponse>> GetPersonaTitoliStudioLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<TitoliStudioLookupsResponse>("anagrafiche/v1/persone/titoli-studio/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaTitoloStudioItem>>> GetPersonaTitoliStudioAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaTitoloStudioItem>>(
            $"anagrafiche/v1/persone/{personaId}/titoli-studio?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<PersonaTitoloStudioItem>> CreatePersonaTitoloStudioAsync(int personaId, CreatePersonaTitoloStudioRequest request, CancellationToken cancellationToken)
        => await PostAsync<PersonaTitoloStudioItem>($"anagrafiche/v1/persone/{personaId}/titoli-studio", request, cancellationToken);

    public async Task<ApiResult<PersonaTitoloStudioItem>> UpdatePersonaTitoloStudioAsync(
        int personaId,
        int personaTitoloStudioId,
        UpdatePersonaTitoloStudioRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<PersonaTitoloStudioItem>($"anagrafiche/v1/persone/{personaId}/titoli-studio/{personaTitoloStudioId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeletePersonaTitoloStudioAsync(int personaId, int personaTitoloStudioId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/{personaId}/titoli-studio/{personaTitoloStudioId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<TipoFinalitaTrattamentoLookupItem>>> GetPersonaConsensiLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<TipoFinalitaTrattamentoLookupItem>>("anagrafiche/v1/persone/consensi/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<ConsensoPersonaItem>>> GetPersonaConsensiAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<ConsensoPersonaItem>>(
            $"anagrafiche/v1/persone/{personaId}/consensi?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<ConsensoPersonaItem>> CreatePersonaConsensoAsync(int personaId, CreateConsensoPersonaRequest request, CancellationToken cancellationToken)
        => await PostAsync<ConsensoPersonaItem>($"anagrafiche/v1/persone/{personaId}/consensi", request, cancellationToken);

    public async Task<ApiResult<ConsensoPersonaItem>> UpdatePersonaConsensoAsync(
        int personaId,
        int consensoPersonaId,
        UpdateConsensoPersonaRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<ConsensoPersonaItem>($"anagrafiche/v1/persone/{personaId}/consensi/{consensoPersonaId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeletePersonaConsensoAsync(int personaId, int consensoPersonaId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/{personaId}/consensi/{consensoPersonaId}", cancellationToken);

    public async Task<ApiResult<PersonaUtenteItem>> GetPersonaUtenteAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<PersonaUtenteItem>(
            $"anagrafiche/v1/persone/{personaId}/utente?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<PersonaUtenteItem>> CreatePersonaUtenteAsync(int personaId, CreatePersonaUtenteRequest request, CancellationToken cancellationToken)
        => await PostAsync<PersonaUtenteItem>($"anagrafiche/v1/persone/{personaId}/utente", request, cancellationToken);

    public async Task<ApiResult<PersonaUtenteItem>> UpdatePersonaUtenteAsync(
        int personaId,
        int personaUtenteId,
        UpdatePersonaUtenteRequest request,
        CancellationToken cancellationToken)
        => await PutAsync<PersonaUtenteItem>($"anagrafiche/v1/persone/{personaId}/utente/{personaUtenteId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeletePersonaUtenteAsync(int personaId, int personaUtenteId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/{personaId}/utente/{personaUtenteId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<TipoDirittoInteressatoLookupItem>>> GetRichiesteGdprLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<TipoDirittoInteressatoLookupItem>>("anagrafiche/v1/persone/richieste-gdpr/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<RichiestaGdprItem>>> GetRichiesteGdprAsync(
        int? personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
    {
        var url = $"anagrafiche/v1/persone/richieste-gdpr?includeDeleted={(includeDeleted ? "true" : "false")}";
        if (personaId.HasValue)
        {
            url += $"&personaId={personaId.Value}";
        }

        return await GetAsync<IReadOnlyList<RichiestaGdprItem>>(url, cancellationToken);
    }

    public async Task<ApiResult<RichiestaGdprItem>> GetRichiestaGdprByIdAsync(int richiestaGdprId, CancellationToken cancellationToken)
        => await GetAsync<RichiestaGdprItem>($"anagrafiche/v1/persone/richieste-gdpr/{richiestaGdprId}", cancellationToken);

    public async Task<ApiResult<RichiestaGdprItem>> CreateRichiestaGdprAsync(CreateRichiestaGdprRequest request, CancellationToken cancellationToken)
        => await PostAsync<RichiestaGdprItem>("anagrafiche/v1/persone/richieste-gdpr", request, cancellationToken);

    public async Task<ApiResult<RichiestaGdprItem>> UpdateRichiestaGdprAsync(int richiestaGdprId, UpdateRichiestaGdprRequest request, CancellationToken cancellationToken)
        => await PutAsync<RichiestaGdprItem>($"anagrafiche/v1/persone/richieste-gdpr/{richiestaGdprId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeleteRichiestaGdprAsync(int richiestaGdprId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/richieste-gdpr/{richiestaGdprId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<TipoFinalitaRegistroTrattamentiLookupItem>>> GetRegistroTrattamentiLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<TipoFinalitaRegistroTrattamentiLookupItem>>("anagrafiche/v1/persone/registro-trattamenti/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<RegistroTrattamentiItem>>> GetRegistroTrattamentiAsync(
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<RegistroTrattamentiItem>>(
            $"anagrafiche/v1/persone/registro-trattamenti?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<RegistroTrattamentiItem>> GetRegistroTrattamentiByIdAsync(int registroTrattamentiId, CancellationToken cancellationToken)
        => await GetAsync<RegistroTrattamentiItem>($"anagrafiche/v1/persone/registro-trattamenti/{registroTrattamentiId}", cancellationToken);

    public async Task<ApiResult<RegistroTrattamentiItem>> CreateRegistroTrattamentiAsync(CreateRegistroTrattamentiRequest request, CancellationToken cancellationToken)
        => await PostAsync<RegistroTrattamentiItem>("anagrafiche/v1/persone/registro-trattamenti", request, cancellationToken);

    public async Task<ApiResult<RegistroTrattamentiItem>> UpdateRegistroTrattamentiAsync(int registroTrattamentiId, UpdateRegistroTrattamentiRequest request, CancellationToken cancellationToken)
        => await PutAsync<RegistroTrattamentiItem>($"anagrafiche/v1/persone/registro-trattamenti/{registroTrattamentiId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeleteRegistroTrattamentiAsync(int registroTrattamentiId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/registro-trattamenti/{registroTrattamentiId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<TipoDirittoInteressatoLookupItem>>> GetRichiesteEsercizioDirittiLookupsAsync(CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<TipoDirittoInteressatoLookupItem>>("anagrafiche/v1/persone/richieste-esercizio-diritti/lookups", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<RichiestaEsercizioDirittiItem>>> GetRichiesteEsercizioDirittiAsync(
        int? personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
    {
        var url = $"anagrafiche/v1/persone/richieste-esercizio-diritti?includeDeleted={(includeDeleted ? "true" : "false")}";
        if (personaId.HasValue)
        {
            url += $"&personaId={personaId.Value}";
        }

        return await GetAsync<IReadOnlyList<RichiestaEsercizioDirittiItem>>(url, cancellationToken);
    }

    public async Task<ApiResult<RichiestaEsercizioDirittiItem>> GetRichiestaEsercizioDirittiByIdAsync(int richiestaEsercizioDirittiId, CancellationToken cancellationToken)
        => await GetAsync<RichiestaEsercizioDirittiItem>($"anagrafiche/v1/persone/richieste-esercizio-diritti/{richiestaEsercizioDirittiId}", cancellationToken);

    public async Task<ApiResult<RichiestaEsercizioDirittiItem>> CreateRichiestaEsercizioDirittiAsync(CreateRichiestaEsercizioDirittiRequest request, CancellationToken cancellationToken)
        => await PostAsync<RichiestaEsercizioDirittiItem>("anagrafiche/v1/persone/richieste-esercizio-diritti", request, cancellationToken);

    public async Task<ApiResult<RichiestaEsercizioDirittiItem>> UpdateRichiestaEsercizioDirittiAsync(int richiestaEsercizioDirittiId, UpdateRichiestaEsercizioDirittiRequest request, CancellationToken cancellationToken)
        => await PutAsync<RichiestaEsercizioDirittiItem>($"anagrafiche/v1/persone/richieste-esercizio-diritti/{richiestaEsercizioDirittiId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeleteRichiestaEsercizioDirittiAsync(int richiestaEsercizioDirittiId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/richieste-esercizio-diritti/{richiestaEsercizioDirittiId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<DataBreachItem>>> GetDataBreachAsync(
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<DataBreachItem>>(
            $"anagrafiche/v1/persone/data-breach?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<DataBreachItem>> GetDataBreachByIdAsync(int dataBreachId, CancellationToken cancellationToken)
        => await GetAsync<DataBreachItem>($"anagrafiche/v1/persone/data-breach/{dataBreachId}", cancellationToken);

    public async Task<ApiResult<DataBreachItem>> CreateDataBreachAsync(CreateDataBreachRequest request, CancellationToken cancellationToken)
        => await PostAsync<DataBreachItem>("anagrafiche/v1/persone/data-breach", request, cancellationToken);

    public async Task<ApiResult<DataBreachItem>> UpdateDataBreachAsync(int dataBreachId, UpdateDataBreachRequest request, CancellationToken cancellationToken)
        => await PutAsync<DataBreachItem>($"anagrafiche/v1/persone/data-breach/{dataBreachId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeleteDataBreachAsync(int dataBreachId, CancellationToken cancellationToken)
        => await DeleteAsync($"anagrafiche/v1/persone/data-breach/{dataBreachId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaStoricoEvent>>> GetPersonaStoricoAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/persona", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaEmailStoricoEvent>>> GetPersonaStoricoEmailAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaEmailStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/email", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaTelefonoStoricoEvent>>> GetPersonaStoricoTelefoniAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaTelefonoStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/telefoni", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaIndirizzoStoricoEvent>>> GetPersonaStoricoIndirizziAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaIndirizzoStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/indirizzi", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaQualificaStoricoEvent>>> GetPersonaStoricoQualificheAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaQualificaStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/qualifiche", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaTitoloStudioStoricoEvent>>> GetPersonaStoricoTitoliStudioAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaTitoloStudioStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/titoli-studio", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaRelazionePersonaleStoricoEvent>>> GetPersonaStoricoRelazioniPersonaliAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaRelazionePersonaleStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/relazioni-personali", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<PersonaUtenteStoricoEvent>>> GetPersonaStoricoUtenteAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<PersonaUtenteStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/utente", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<ConsensoPersonaStoricoEvent>>> GetPersonaStoricoConsensiAsync(int personaId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<ConsensoPersonaStoricoEvent>>($"anagrafiche/v1/persone/{personaId}/storico/consensi", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<RichiestaGdprStoricoEvent>>> GetRichiestaGdprStoricoAsync(int richiestaGdprId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<RichiestaGdprStoricoEvent>>($"anagrafiche/v1/persone/richieste-gdpr/{richiestaGdprId}/storico", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<RegistroTrattamentiStoricoEvent>>> GetRegistroTrattamentiStoricoAsync(int registroTrattamentiId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<RegistroTrattamentiStoricoEvent>>($"anagrafiche/v1/persone/registro-trattamenti/{registroTrattamentiId}/storico", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<RichiestaEsercizioDirittiStoricoEvent>>> GetRichiestaEsercizioDirittiStoricoAsync(int richiestaEsercizioDirittiId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<RichiestaEsercizioDirittiStoricoEvent>>($"anagrafiche/v1/persone/richieste-esercizio-diritti/{richiestaEsercizioDirittiId}/storico", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<DataBreachStoricoEvent>>> GetDataBreachStoricoAsync(int dataBreachId, CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<DataBreachStoricoEvent>>($"anagrafiche/v1/persone/data-breach/{dataBreachId}/storico", cancellationToken);

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

    public async Task<ApiResult<PagedResponse<DipendenteDettaglioCompletoListItem>>> GetDipendentiDettaglioCompletoAsync(
        string? q,
        string? matricola,
        int? statoDipendenteId,
        int? personaId,
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        var query = new List<string>
        {
            $"page={page}",
            $"pageSize={pageSize}"
        };

        if (!string.IsNullOrWhiteSpace(q))
        {
            query.Add($"q={Uri.EscapeDataString(q)}");
        }

        if (!string.IsNullOrWhiteSpace(matricola))
        {
            query.Add($"matricola={Uri.EscapeDataString(matricola)}");
        }

        if (statoDipendenteId is not null && statoDipendenteId > 0)
        {
            query.Add($"statoDipendenteId={statoDipendenteId.Value}");
        }

        if (personaId is not null && personaId > 0)
        {
            query.Add($"personaId={personaId.Value}");
        }

        var url = $"bff/risorseumane/v1/dipendenti/dettaglio-completo?{string.Join("&", query)}";
        return await GetAsync<PagedResponse<DipendenteDettaglioCompletoListItem>>(url, cancellationToken);
    }

    public async Task<ApiResult<DipendenteDettaglioCompletoDto>> GetDipendenteDettaglioCompletoAsync(
        int dipendenteId,
        CancellationToken cancellationToken)
        => await GetAsync<DipendenteDettaglioCompletoDto>($"bff/risorseumane/v1/dipendenti/{dipendenteId}/dettaglio-completo", cancellationToken);

    public async Task<ApiResult<PagedResponse<PersonaLookupItem>>> SearchPersoneRuLookupAsync(
        string query,
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        var url = $"bff/risorseumane/v1/persone/lookup?q={Uri.EscapeDataString(query)}&page={page}&pageSize={pageSize}";
        return await GetAsync<PagedResponse<PersonaLookupItem>>(url, cancellationToken);
    }

    public async Task<ApiResult<CreateDipendenteResponse>> CreateDipendenteAsync(
        CreateDipendenteRequest request,
        CancellationToken cancellationToken)
        => await PostAsync<CreateDipendenteResponse>("risorseumane/v1/dipendenti", request, cancellationToken);

    public async Task<ApiResult<object>> UpdateDipendenteAsync(
        int dipendenteId,
        UpdateDipendenteRequest request,
        CancellationToken cancellationToken)
        => await PutNoContentAsync($"risorseumane/v1/dipendenti/{dipendenteId}", request, cancellationToken);

    public async Task<ApiResult<object>> DeleteDipendenteAsync(
        int dipendenteId,
        CancellationToken cancellationToken)
        => await DeleteAsync($"risorseumane/v1/dipendenti/{dipendenteId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<DipendenteStoricoDto>>> GetDipendenteStoricoAsync(
        int dipendenteId,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<DipendenteStoricoDto>>($"risorseumane/v1/dipendenti/{dipendenteId}/storico", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<ContrattoDto>>> GetContrattiByDipendenteAsync(
        int dipendenteId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<ContrattoDto>>(
            $"risorseumane/v1/dipendenti/{dipendenteId}/contratti?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<ContrattoDto>> GetContrattoByIdAsync(
        int contrattoId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<ContrattoDto>(
            $"risorseumane/v1/contratti/{contrattoId}?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<CreateContrattoResponse>> CreateContrattoAsync(
        int dipendenteId,
        CreateContrattoRequest request,
        CancellationToken cancellationToken)
        => await PostAsync<CreateContrattoResponse>($"risorseumane/v1/dipendenti/{dipendenteId}/contratti", request, cancellationToken);

    public async Task<ApiResult<object>> UpdateContrattoAsync(
        int dipendenteId,
        int contrattoId,
        UpdateContrattoRequest request,
        CancellationToken cancellationToken)
        => await PutNoContentAsync(
            $"risorseumane/v1/dipendenti/{dipendenteId}/contratti/{contrattoId}",
            request,
            cancellationToken);

    public async Task<ApiResult<object>> DeleteContrattoAsync(
        int dipendenteId,
        int contrattoId,
        CancellationToken cancellationToken)
        => await DeleteAsync($"risorseumane/v1/dipendenti/{dipendenteId}/contratti/{contrattoId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<ContrattoStoricoDto>>> GetContrattoStoricoAsync(
        int contrattoId,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<ContrattoStoricoDto>>($"risorseumane/v1/contratti/{contrattoId}/storico", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<DotazioneDto>>> GetDotazioniByDipendenteAsync(
        int dipendenteId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<DotazioneDto>>(
            $"risorseumane/v1/dipendenti/{dipendenteId}/dotazioni?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<DotazioneDto>> GetDotazioneByIdAsync(
        int dotazioneId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<DotazioneDto>(
            $"risorseumane/v1/dotazioni/{dotazioneId}?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<CreateDotazioneResponse>> CreateDotazioneAsync(
        int dipendenteId,
        CreateDotazioneRequest request,
        CancellationToken cancellationToken)
        => await PostAsync<CreateDotazioneResponse>($"risorseumane/v1/dipendenti/{dipendenteId}/dotazioni", request, cancellationToken);

    public async Task<ApiResult<object>> UpdateDotazioneAsync(
        int dipendenteId,
        int dotazioneId,
        UpdateDotazioneRequest request,
        CancellationToken cancellationToken)
        => await PutNoContentAsync(
            $"risorseumane/v1/dipendenti/{dipendenteId}/dotazioni/{dotazioneId}",
            request,
            cancellationToken);

    public async Task<ApiResult<object>> DeleteDotazioneAsync(
        int dipendenteId,
        int dotazioneId,
        CancellationToken cancellationToken)
        => await DeleteAsync($"risorseumane/v1/dipendenti/{dipendenteId}/dotazioni/{dotazioneId}", cancellationToken);

    public async Task<ApiResult<IReadOnlyList<FormazioneObbligatoriaDto>>> GetFormazioneByDipendenteAsync(
        int dipendenteId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<IReadOnlyList<FormazioneObbligatoriaDto>>(
            $"risorseumane/v1/dipendenti/{dipendenteId}/formazione-obbligatoria?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<FormazioneObbligatoriaDto>> GetFormazioneByIdAsync(
        int formazioneObbligatoriaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => await GetAsync<FormazioneObbligatoriaDto>(
            $"risorseumane/v1/formazione-obbligatoria/{formazioneObbligatoriaId}?includeDeleted={(includeDeleted ? "true" : "false")}",
            cancellationToken);

    public async Task<ApiResult<CreateFormazioneObbligatoriaResponse>> CreateFormazioneAsync(
        int dipendenteId,
        CreateFormazioneObbligatoriaRequest request,
        CancellationToken cancellationToken)
        => await PostAsync<CreateFormazioneObbligatoriaResponse>(
            $"risorseumane/v1/dipendenti/{dipendenteId}/formazione-obbligatoria",
            request,
            cancellationToken);

    public async Task<ApiResult<object>> UpdateFormazioneAsync(
        int dipendenteId,
        int formazioneObbligatoriaId,
        UpdateFormazioneObbligatoriaRequest request,
        CancellationToken cancellationToken)
        => await PutNoContentAsync(
            $"risorseumane/v1/dipendenti/{dipendenteId}/formazione-obbligatoria/{formazioneObbligatoriaId}",
            request,
            cancellationToken);

    public async Task<ApiResult<object>> DeleteFormazioneAsync(
        int dipendenteId,
        int formazioneObbligatoriaId,
        CancellationToken cancellationToken)
        => await DeleteAsync(
            $"risorseumane/v1/dipendenti/{dipendenteId}/formazione-obbligatoria/{formazioneObbligatoriaId}",
            cancellationToken);

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

    private async Task<ApiResult<object>> PutNoContentAsync(string url, object body, CancellationToken cancellationToken)
    {
        try
        {
            var response = await _httpClient.PutAsJsonAsync(url, body, cancellationToken);
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
