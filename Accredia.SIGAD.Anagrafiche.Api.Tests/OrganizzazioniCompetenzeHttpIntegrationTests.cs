using System;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniCompetenzeHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_Competenza_WorksEndToEnd()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        client.DefaultRequestHeaders.Add("X-Actor", "1");

        var suffix = Guid.NewGuid().ToString("N")[..8].ToUpperInvariant();
        var codiceCreate = $"CMP-{suffix}";
        var codiceUpdate = $"CMPU-{suffix}";

        var createResponse = await client.PostAsJsonAsync(
            "/anagrafiche/v1/organizzazioni/competenze",
            new
            {
                codiceCompetenza = codiceCreate,
                descrizioneCompetenza = "Test create",
                principale = true,
                attivo = true,
                verificato = false
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var competenzaId = created!["competenzaId"]?.GetValue<int>() ?? 0;
        Assert.True(competenzaId > 0);

        var updateResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/competenze/{competenzaId}",
            new
            {
                codiceCompetenza = codiceUpdate,
                descrizioneCompetenza = "Test update",
                principale = false,
                attivo = true,
                verificato = true
            });
        updateResponse.EnsureSuccessStatusCode();

        var updated = JsonNode.Parse(await updateResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(updated);
        Assert.Equal(codiceUpdate, updated!["codiceCompetenza"]?.GetValue<string>());
        Assert.True(updated["verificato"]?.GetValue<bool>());

        var listResponse = await client.GetAsync("/anagrafiche/v1/organizzazioni/competenze");
        listResponse.EnsureSuccessStatusCode();
        var list = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(list);
        Assert.Contains(list!, x => x?["competenzaId"]?.GetValue<int>() == competenzaId);

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/competenze/{competenzaId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDeleteResponse = await client.GetAsync("/anagrafiche/v1/organizzazioni/competenze");
        listAfterDeleteResponse.EnsureSuccessStatusCode();
        var listAfterDelete = JsonNode.Parse(await listAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(listAfterDelete);
        Assert.DoesNotContain(listAfterDelete!, x => x?["competenzaId"]?.GetValue<int>() == competenzaId);
    }
}
