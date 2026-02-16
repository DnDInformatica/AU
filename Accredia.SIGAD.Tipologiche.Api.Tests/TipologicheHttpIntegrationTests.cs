using System.Net.Http.Headers;
using System.Text.Json.Nodes;
using Xunit;

namespace Accredia.SIGAD.Tipologiche.Api.Tests;

public sealed class TipologicheHttpIntegrationTests
{
    [Fact]
    public async Task Health_And_Swagger_Are_Reachable_Via_Gateway()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();

        var health = await client.GetAsync("/tipologiche/health");
        health.EnsureSuccessStatusCode();

        var swaggerJson = await client.GetAsync("/tipologiche/swagger/v1/swagger.json");
        swaggerJson.EnsureSuccessStatusCode();
    }

    [Fact]
    public async Task Lookup_And_Mappings_Endpoints_Are_Reachable_When_Authenticated()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var lookups = await client.GetAsync("/tipologiche/v1/lookups");
        lookups.EnsureSuccessStatusCode();
        var lookupsJson = JsonNode.Parse(await lookups.Content.ReadAsStringAsync()) as JsonArray;
        Assert.NotNull(lookupsJson);
        Assert.NotEmpty(lookupsJson!);

        var firstLookupName = lookupsJson![0]?["name"]?.GetValue<string>();
        Assert.False(string.IsNullOrWhiteSpace(firstLookupName));

        var lookupItems = await client.GetAsync($"/tipologiche/v1/lookups/{firstLookupName}?page=1&pageSize=5");
        lookupItems.EnsureSuccessStatusCode();
        var lookupItemsJson = JsonNode.Parse(await lookupItems.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(lookupItemsJson);
        Assert.NotNull(lookupItemsJson!["items"]);

        var mappingCategoriaSede = await client.GetAsync("/tipologiche/v1/mappings/categoria-sede");
        mappingCategoriaSede.EnsureSuccessStatusCode();

        var mappingTipoSedeIndirizzo = await client.GetAsync("/tipologiche/v1/mappings/tipo-sede-indirizzo");
        mappingTipoSedeIndirizzo.EnsureSuccessStatusCode();
    }
}
