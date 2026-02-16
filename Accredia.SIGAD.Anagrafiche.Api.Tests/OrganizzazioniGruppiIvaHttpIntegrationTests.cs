using System;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniGruppiIvaHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_GruppoIva_And_Membri_WorksEndToEnd()
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
        var piva = $"IT{suffix}123";

        var createGroupResponse = await client.PostAsJsonAsync(
            "/anagrafiche/v1/organizzazioni/gruppi-iva",
            new
            {
                partitaIvaGruppo = piva,
                denominazione = $"Gruppo IVA {suffix}",
                codiceGruppo = $"GRP-{suffix[..4]}",
                dataCostituzione = DateTime.UtcNow.Date,
                dataApprovazione = (DateTime?)null,
                protocolloAgenziaEntrate = (string?)null,
                numeroProvvedimento = (string?)null,
                statoGruppo = "ATTIVO",
                dataCessazione = (DateTime?)null,
                motivoCessazione = (string?)null,
                organizzazioneCapogruppoId = organizzazioneId,
                note = "test create",
                documentazioneRiferimento = (string?)null
            });
        createGroupResponse.EnsureSuccessStatusCode();

        var groupCreated = JsonNode.Parse(await createGroupResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(groupCreated);
        var gruppoIvaId = groupCreated!["gruppoIvaId"]?.GetValue<int>() ?? 0;
        Assert.True(gruppoIvaId > 0);

        var createMembroResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/gruppi-iva/{gruppoIvaId}/membri",
            new
            {
                organizzazioneId,
                dataAdesione = DateTime.UtcNow.Date,
                dataUscita = (DateTime?)null,
                motivoUscita = (string?)null,
                protocolloUscita = (string?)null,
                isCapogruppo = true,
                ruoloNelGruppo = "Capogruppo",
                percentualePartecipazione = 100m,
                statoMembro = "ATTIVO",
                note = "test create membro"
            });
        createMembroResponse.EnsureSuccessStatusCode();

        var membroCreated = JsonNode.Parse(await createMembroResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(membroCreated);
        var gruppoIvaMembroId = membroCreated!["gruppoIvaMembroId"]?.GetValue<int>() ?? 0;
        Assert.True(gruppoIvaMembroId > 0);

        var updateMembroResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/gruppi-iva/{gruppoIvaId}/membri/{gruppoIvaMembroId}",
            new
            {
                organizzazioneId,
                dataAdesione = DateTime.UtcNow.Date,
                dataUscita = (DateTime?)null,
                motivoUscita = (string?)null,
                protocolloUscita = (string?)null,
                isCapogruppo = true,
                ruoloNelGruppo = "Capogruppo Update",
                percentualePartecipazione = 80m,
                statoMembro = "ATTIVO",
                note = "test update membro"
            });
        updateMembroResponse.EnsureSuccessStatusCode();

        var listMembriResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/gruppi-iva/{gruppoIvaId}/membri");
        listMembriResponse.EnsureSuccessStatusCode();
        var membri = JsonNode.Parse(await listMembriResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(membri);
        Assert.Contains(membri!, x => x?["gruppoIvaMembroId"]?.GetValue<int>() == gruppoIvaMembroId);

        var updateGroupResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/gruppi-iva/{gruppoIvaId}",
            new
            {
                partitaIvaGruppo = piva,
                denominazione = $"Gruppo IVA {suffix} Updated",
                codiceGruppo = $"GRP-{suffix[..4]}",
                dataCostituzione = DateTime.UtcNow.Date,
                dataApprovazione = (DateTime?)null,
                protocolloAgenziaEntrate = (string?)null,
                numeroProvvedimento = (string?)null,
                statoGruppo = "ATTIVO",
                dataCessazione = (DateTime?)null,
                motivoCessazione = (string?)null,
                organizzazioneCapogruppoId = organizzazioneId,
                note = "test update gruppo",
                documentazioneRiferimento = (string?)null
            });
        updateGroupResponse.EnsureSuccessStatusCode();

        var deleteMembroResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/gruppi-iva/{gruppoIvaId}/membri/{gruppoIvaMembroId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteMembroResponse.StatusCode);

        var listMembriAfterDeleteResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/gruppi-iva/{gruppoIvaId}/membri");
        listMembriAfterDeleteResponse.EnsureSuccessStatusCode();
        var membriAfterDelete = JsonNode.Parse(await listMembriAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(membriAfterDelete);
        Assert.DoesNotContain(membriAfterDelete!, x => x?["gruppoIvaMembroId"]?.GetValue<int>() == gruppoIvaMembroId);

        var deleteGroupResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/gruppi-iva/{gruppoIvaId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteGroupResponse.StatusCode);

        var listGroupsAfterDeleteResponse = await client.GetAsync("/anagrafiche/v1/organizzazioni/gruppi-iva");
        listGroupsAfterDeleteResponse.EnsureSuccessStatusCode();
        var groupsAfterDelete = JsonNode.Parse(await listGroupsAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(groupsAfterDelete);
        Assert.DoesNotContain(groupsAfterDelete!, x => x?["gruppoIvaId"]?.GetValue<int>() == gruppoIvaId);
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }
}
