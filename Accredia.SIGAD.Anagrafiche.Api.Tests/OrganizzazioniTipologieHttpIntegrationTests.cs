using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniTipologieHttpIntegrationTests
{
    [Fact]
    public async Task SetTipologia_ThenGetTipologie_ReturnsSelectedType()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        client.DefaultRequestHeaders.Add("X-Actor", "1");

        var organizzazioneId = GetTestOrganizzazioneId();
        var tipoOrganizzazioneId = await GetFirstTipologiaIdAsync(client);

        var putResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/tipologie",
            new { tipoOrganizzazioneId });
        putResponse.EnsureSuccessStatusCode();

        var getResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/tipologie");
        getResponse.EnsureSuccessStatusCode();
        var payload = JsonNode.Parse(await getResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(payload);
        Assert.Contains(payload!, item => item?["tipoOrganizzazioneId"]?.GetValue<int>() == tipoOrganizzazioneId);
    }

    [Fact]
    public async Task GetTipologie_MissingOrganizzazione_ReturnsNotFound()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        const int missingOrganizzazioneId = int.MaxValue;
        var response = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{missingOrganizzazioneId}/tipologie");
        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }

    private static async Task<int> GetFirstTipologiaIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/organizzazioni/tipologie/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        if (json is null)
        {
            throw new InvalidOperationException("No tipologia lookup available for integration test.");
        }

        foreach (var item in json)
        {
            var id = item?["id"]?.GetValue<int>();
            if (id is > 0)
            {
                return id.Value;
            }
        }

        throw new InvalidOperationException("No tipologia lookup available for integration test.");
    }
}
