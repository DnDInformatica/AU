using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniUnitaAttivitaHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_UnitaAttivita_WorksEndToEnd()
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
        var unitaOrganizzativaId = await EnsureUnitAsync(client, organizzazioneId);
        var suffix = Guid.NewGuid().ToString("N")[..6].ToUpperInvariant();

        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-attivita",
            new
            {
                unitaOrganizzativaId,
                codiceAtecoRi = $"ATECO-{suffix}",
                descrizioneAttivita = "Test create",
                importanza = "primaria",
                dataInizioAttivita = DateTime.UtcNow.Date,
                dataFineAttivita = (DateTime?)null,
                fonteDato = "RegistroImprese",
                note = "note create"
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var unitaAttivitaId = created!["unitaAttivitaId"]?.GetValue<int>() ?? 0;
        Assert.True(unitaAttivitaId > 0);

        var updateResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-attivita/{unitaAttivitaId}",
            new
            {
                unitaOrganizzativaId,
                codiceAtecoRi = $"ATECO-{suffix}",
                descrizioneAttivita = "Test update",
                importanza = "secondaria",
                dataInizioAttivita = DateTime.UtcNow.Date,
                dataFineAttivita = (DateTime?)null,
                fonteDato = "RegistroImprese",
                note = "note update"
            });
        updateResponse.EnsureSuccessStatusCode();

        var updated = JsonNode.Parse(await updateResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(updated);
        Assert.Equal(unitaAttivitaId, updated!["unitaAttivitaId"]?.GetValue<int>());
        Assert.Equal("Test update", updated["descrizioneAttivita"]?.GetValue<string>());

        var listResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-attivita");
        listResponse.EnsureSuccessStatusCode();
        var list = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(list);
        Assert.Contains(list!, x => x?["unitaAttivitaId"]?.GetValue<int>() == unitaAttivitaId);

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-attivita/{unitaAttivitaId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDeleteResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-attivita");
        listAfterDeleteResponse.EnsureSuccessStatusCode();
        var listAfterDelete = JsonNode.Parse(await listAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(listAfterDelete);
        Assert.DoesNotContain(listAfterDelete!, x => x?["unitaAttivitaId"]?.GetValue<int>() == unitaAttivitaId);
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }

    private static async Task<int> EnsureUnitAsync(HttpClient client, int organizzazioneId)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative");
        response.EnsureSuccessStatusCode();
        var units = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        var existingId = units?[0]?["unitaOrganizzativaId"]?.GetValue<int>() ?? 0;
        if (existingId > 0)
        {
            return existingId;
        }

        var lookupsResponse = await client.GetAsync("/anagrafiche/v1/organizzazioni/unita-organizzative/lookups");
        lookupsResponse.EnsureSuccessStatusCode();
        var lookupsJson = JsonNode.Parse(await lookupsResponse.Content.ReadAsStringAsync())?.AsObject();
        var tipoUnitaId = lookupsJson?["tipiUnitaOrganizzativa"]?[0]?["id"]?.GetValue<int>() ?? 1;

        var suffix = Guid.NewGuid().ToString("N")[..8];
        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative",
            new
            {
                nome = $"UO TEST {suffix}",
                codice = $"UT{suffix[..4]}",
                principale = false,
                tipoUnitaOrganizzativaId = tipoUnitaId,
                tipoSedeId = (int?)null
            });
        createResponse.EnsureSuccessStatusCode();
        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        return created?["unitaOrganizzativaId"]?.GetValue<int>() ?? 0;
    }
}
