using System;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniSediLinkHttpIntegrationTests
{
    [Fact]
    public async Task CreateListDelete_SediLink_WorksEndToEnd()
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
        var tipoOrganizzazioneSedeId = GetTestTipoOrganizzazioneSedeId();

        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi-link",
            new
            {
                tipoOrganizzazioneSedeId,
                denominazione = "Sede Link Test",
                insegna = "SLT"
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var organizzazioneSedeId = created!["organizzazioneSedeId"]?.GetValue<int>() ?? 0;
        Assert.True(organizzazioneSedeId > 0);

        var listResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi-link");
        listResponse.EnsureSuccessStatusCode();
        var list = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(list);
        Assert.Contains(list!, x => x?["organizzazioneSedeId"]?.GetValue<int>() == organizzazioneSedeId);

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi-link/{organizzazioneSedeId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDeleteResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi-link");
        listAfterDeleteResponse.EnsureSuccessStatusCode();
        var listAfterDelete = JsonNode.Parse(await listAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(listAfterDelete);
        Assert.DoesNotContain(listAfterDelete!, x => x?["organizzazioneSedeId"]?.GetValue<int>() == organizzazioneSedeId);
    }

    [Fact]
    public async Task SediLink_MissingOrganizzazione_ReturnsNotFound()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        const int missingOrganizzazioneId = int.MaxValue;
        var response = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{missingOrganizzazioneId}/sedi-link");
        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }

    private static byte GetTestTipoOrganizzazioneSedeId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_TIPO_ORGANIZZAZIONE_SEDE_ID");
        return byte.TryParse(raw, out var parsed) && parsed > 0 ? parsed : (byte)1;
    }
}
