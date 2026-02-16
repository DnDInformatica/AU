using System;
using System.Net.Http.Headers;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniStoricoHttpIntegrationTests
{
    [Fact]
    public async Task Storico_ReadOnly_Endpoints_ReturnOk_ForExistingOrganizzazione()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var organizzazioneId = GetTestOrganizzazioneId();

        await AssertArrayEndpointAsync(client, $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/storico/organizzazione");
        await AssertArrayEndpointAsync(client, $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/storico/unita-organizzative");
        await AssertArrayEndpointAsync(client, $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/storico/sedi");
        await AssertArrayEndpointAsync(client, $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/storico/incarichi");
        await AssertObjectEndpointAsync(client, $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/storico/relazioni");
        await AssertObjectEndpointAsync(client, $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/storico/attributi");
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }

    private static async Task AssertArrayEndpointAsync(System.Net.Http.HttpClient client, string url)
    {
        var response = await client.GetAsync(url);
        response.EnsureSuccessStatusCode();
        var content = await response.Content.ReadAsStringAsync();
        var parsed = JsonNode.Parse(content)?.AsArray();
        Assert.NotNull(parsed);
    }

    private static async Task AssertObjectEndpointAsync(System.Net.Http.HttpClient client, string url)
    {
        var response = await client.GetAsync(url);
        response.EnsureSuccessStatusCode();
        var content = await response.Content.ReadAsStringAsync();
        var parsed = JsonNode.Parse(content)?.AsObject();
        Assert.NotNull(parsed);
    }
}
