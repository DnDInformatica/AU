using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.RisorseUmane.Api.Tests;

public sealed class RisorseUmaneCrudHttpIntegrationTests
{
    [Fact]
    public async Task Dipendente_And_Related_Tables_Crud_Flows()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var personaId = await IntegrationTestSupport.GetPersonaIdAsync(client);
        var today = DateTime.UtcNow.Date.ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture);

        // Create Dipendente
        var matricola = "TST-" + Guid.NewGuid().ToString("N")[..10];
        var dipendenteCreate = await client.PostAsJsonAsync("/risorseumane/v1/dipendenti", new
        {
            personaId,
            matricola,
            emailAziendale = "test.hr@accredia.local",
            telefonoInterno = "1234",
            dataAssunzione = today,
            dataCessazione = (string?)null,
            statoDipendenteId = 1,
            abilitatoAttivitaIspettiva = false,
            note = "integration-test"
        });
        dipendenteCreate.EnsureSuccessStatusCode();

        var dipCreateJson = JsonNode.Parse(await dipendenteCreate.Content.ReadAsStringAsync())?.AsObject();
        var dipendenteId = dipCreateJson?["dipendenteId"]?.GetValue<int>()
                          ?? throw new InvalidOperationException("dipendenteId missing.");

        // Read Dipendente
        var dipendenteGet = await client.GetAsync($"/risorseumane/v1/dipendenti/{dipendenteId}");
        dipendenteGet.EnsureSuccessStatusCode();

        // Update Dipendente
        var dipendenteUpdate = await client.PutAsJsonAsync($"/risorseumane/v1/dipendenti/{dipendenteId}", new
        {
            personaId,
            matricola,
            emailAziendale = "test.hr2@accredia.local",
            telefonoInterno = "1234",
            unitaOrganizzativaId = (int?)null,
            responsabileDirettoId = (int?)null,
            dataAssunzione = today,
            dataCessazione = (string?)null,
            statoDipendenteId = 1,
            abilitatoAttivitaIspettiva = false,
            note = "integration-test-updated"
        });
        Assert.True(dipendenteUpdate.StatusCode is System.Net.HttpStatusCode.NoContent or System.Net.HttpStatusCode.OK);

        // Create Contratto
        var contrattoCreate = await client.PostAsJsonAsync($"/risorseumane/v1/dipendenti/{dipendenteId}/contratti", new
        {
            tipoContrattoId = 1,
            dataInizio = today,
            dataFine = (string?)null,
            livelloInquadramento = "L1",
            ccnlApplicato = "CCNL",
            ral = 12345.67m,
            percentualePartTime = (decimal?)null,
            oreLavoroSettimanali = (decimal?)null,
            isContrattoCorrente = true,
            note = "integration-test"
        });
        contrattoCreate.EnsureSuccessStatusCode();
        var contrCreateJson = JsonNode.Parse(await contrattoCreate.Content.ReadAsStringAsync())?.AsObject();
        var contrattoId = contrCreateJson?["contrattoId"]?.GetValue<int>()
                         ?? throw new InvalidOperationException("contrattoId missing.");

        // Storico Contratto (should be reachable)
        var contrattoStorico = await client.GetAsync($"/risorseumane/v1/contratti/{contrattoId}/storico");
        contrattoStorico.EnsureSuccessStatusCode();

        // Create Dotazione
        var dotazioneCreate = await client.PostAsJsonAsync($"/risorseumane/v1/dipendenti/{dipendenteId}/dotazioni", new
        {
            tipoDotazioneId = 1,
            descrizione = "Laptop",
            numeroInventario = "INV-1",
            numeroSerie = "SER-1",
            dataAssegnazione = today,
            dataRestituzione = (string?)null,
            isRestituito = false,
            note = "integration-test"
        });
        dotazioneCreate.EnsureSuccessStatusCode();
        var dotCreateJson = JsonNode.Parse(await dotazioneCreate.Content.ReadAsStringAsync())?.AsObject();
        var dotazioneId = dotCreateJson?["dotazioneId"]?.GetValue<int>()
                         ?? throw new InvalidOperationException("dotazioneId missing.");

        // Create FormazioneObbligatoria
        var formazioneCreate = await client.PostAsJsonAsync($"/risorseumane/v1/dipendenti/{dipendenteId}/formazione-obbligatoria", new
        {
            tipoFormazioneObbligatoriaId = 1,
            dataCompletamento = today,
            dataScadenza = (string?)null,
            estremiAttestato = "ATTEST-1",
            enteFormatore = "Ente",
            durataOreCorso = 8,
            note = "integration-test"
        });
        formazioneCreate.EnsureSuccessStatusCode();
        var formCreateJson = JsonNode.Parse(await formazioneCreate.Content.ReadAsStringAsync())?.AsObject();
        var formazioneId = formCreateJson?["formazioneObbligatoriaId"]?.GetValue<int>()
                          ?? throw new InvalidOperationException("formazioneObbligatoriaId missing.");

        // Cleanup (soft delete children first)
        var delContratto = await client.DeleteAsync($"/risorseumane/v1/dipendenti/{dipendenteId}/contratti/{contrattoId}");
        Assert.True(delContratto.StatusCode is System.Net.HttpStatusCode.NoContent or System.Net.HttpStatusCode.NotFound);

        var delDotazione = await client.DeleteAsync($"/risorseumane/v1/dipendenti/{dipendenteId}/dotazioni/{dotazioneId}");
        Assert.True(delDotazione.StatusCode is System.Net.HttpStatusCode.NoContent or System.Net.HttpStatusCode.NotFound);

        var delFormazione = await client.DeleteAsync($"/risorseumane/v1/dipendenti/{dipendenteId}/formazione-obbligatoria/{formazioneId}");
        Assert.True(delFormazione.StatusCode is System.Net.HttpStatusCode.NoContent or System.Net.HttpStatusCode.NotFound);

        var delDipendente = await client.DeleteAsync($"/risorseumane/v1/dipendenti/{dipendenteId}");
        Assert.True(delDipendente.StatusCode is System.Net.HttpStatusCode.NoContent or System.Net.HttpStatusCode.NotFound);
    }
}

