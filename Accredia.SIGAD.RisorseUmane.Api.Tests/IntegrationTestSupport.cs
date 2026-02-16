using System;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;

namespace Accredia.SIGAD.RisorseUmane.Api.Tests;

internal static class IntegrationTestSupport
{
    private const string RunFlagName = "SIGAD_RUN_HTTP_INTEGRATION";
    // Prefer explicit IPv4 loopback: some environments resolve "localhost" to ::1 first.
    private const string DefaultBaseUrl = "http://127.0.0.1:7100";
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
        // Avoid coupling HR tests to Anagrafiche search behavior/seed data: create a dedicated persona.
        var cf = Guid.NewGuid().ToString("N")[..16].ToUpperInvariant();
        var request = new
        {
            cognome = "Integration",
            nome = "Test",
            codiceFiscale = cf,
            dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
        };

        using var httpRequest = new HttpRequestMessage(HttpMethod.Post, "/anagrafiche/v1/persone")
        {
            Content = JsonContent.Create(request)
        };
        httpRequest.Headers.TryAddWithoutValidation("X-Actor", "RisorseUmane.Api.Tests");

        var response = await client.SendAsync(httpRequest);
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        return json?["personaId"]?.GetValue<int>()
               ?? throw new InvalidOperationException("PersonaId missing in create response.");
    }
}
