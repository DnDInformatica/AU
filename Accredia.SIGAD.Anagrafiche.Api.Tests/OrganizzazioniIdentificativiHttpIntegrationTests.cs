using System;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniIdentificativiHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_Identificativo_WorksEndToEnd()
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
        var suffix = Guid.NewGuid().ToString("N")[..8].ToUpperInvariant();
        var initialValue = $"TEST-{suffix}";
        var updatedValue = $"UPD-{suffix}";

        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/identificativi",
            new
            {
                paeseISO2 = "IT",
                tipoIdentificativo = "ALTRO",
                valore = initialValue,
                principale = false,
                note = "test"
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var id = created!["id"]?.GetValue<int>() ?? 0;
        Assert.True(id > 0);

        var listAfterCreate = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/identificativi");
        listAfterCreate.EnsureSuccessStatusCode();
        var createdItems = JsonNode.Parse(await listAfterCreate.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(createdItems);
        Assert.Contains(createdItems!, x => x?["id"]?.GetValue<int>() == id && x?["valore"]?.GetValue<string>() == initialValue);

        var updateResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/identificativi/{id}",
            new
            {
                paeseISO2 = "IT",
                tipoIdentificativo = "ALTRO",
                valore = updatedValue,
                principale = true,
                note = "updated"
            });
        updateResponse.EnsureSuccessStatusCode();

        var updated = JsonNode.Parse(await updateResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(updated);
        Assert.Equal(updatedValue, updated!["valore"]?.GetValue<string>());
        Assert.True(updated["principale"]?.GetValue<bool>());

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/identificativi/{id}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDelete = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/identificativi");
        listAfterDelete.EnsureSuccessStatusCode();
        var deletedItems = JsonNode.Parse(await listAfterDelete.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(deletedItems);
        Assert.DoesNotContain(deletedItems!, x => x?["id"]?.GetValue<int>() == id);
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }
}

