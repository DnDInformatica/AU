using System;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

internal static class IntegrationTestSupport
{
    private const string RunFlagName = "SIGAD_RUN_HTTP_INTEGRATION";
    private const string DefaultBaseUrl = "http://localhost:7100";
    private const string DefaultUser = "admin";
    private const string DefaultPassword = "Password!12345";

    public static bool ShouldRun()
        => string.Equals(Environment.GetEnvironmentVariable(RunFlagName), "1", StringComparison.Ordinal);

    public static HttpClient CreateClient()
    {
        var baseUrl = Environment.GetEnvironmentVariable("SIGAD_BASE_URL");
        var root = string.IsNullOrWhiteSpace(baseUrl) ? DefaultBaseUrl : baseUrl.Trim();
        return new HttpClient { BaseAddress = new Uri(root, UriKind.Absolute) };
    }

    public static async Task<string> LoginAndGetTokenAsync(HttpClient client)
    {
        var username = Environment.GetEnvironmentVariable("SIGAD_TEST_USER") ?? DefaultUser;
        var password = Environment.GetEnvironmentVariable("SIGAD_TEST_PASSWORD") ?? DefaultPassword;
        var login = await client.PostAsJsonAsync("/identity/v1/auth/login", new { username, password });
        login.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await login.Content.ReadAsStringAsync())?.AsObject();
        return json?["accessToken"]?.GetValue<string>()
               ?? throw new InvalidOperationException("Access token missing.");
    }

    public static async Task<int> GetPersonaIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/search?q=an&page=1&pageSize=1");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        return json?["items"]?[0]?["personaId"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No persona found for integration test.");
    }

    public static async Task<int> GetTipoRuoloIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/incarichi/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No tipo ruolo lookup found.");
    }
}
