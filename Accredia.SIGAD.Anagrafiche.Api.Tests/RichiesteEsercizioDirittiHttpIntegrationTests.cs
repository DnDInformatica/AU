using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class RichiesteEsercizioDirittiHttpIntegrationTests
{
    [Fact]
    public async Task ListCreateUpdateDelete_Works()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var tipoId = await GetTipoDirittoIdAsync(client);
        var id = 0;

        try
        {
            var created = await CreateAsync(client, new
            {
                personaId = (int?)null,
                nomeRichiedente = "Mario",
                emailRichiedente = "mario.rossi@example.test",
                telefonoRichiedente = (string?)null,
                codice = $"DIR_{DateTime.UtcNow:yyyyMMddHHmmss}",
                tipoDirittoGdprId = tipoId,
                dataRichiesta = DateTime.UtcNow,
                modalitaRichiesta = "EMAIL",
                testoRichiesta = (string?)null,
                documentoRichiesta = (string?)null,
                identitaVerificata = false,
                dataVerificaIdentita = (DateTime?)null,
                modalitaVerifica = (string?)null,
                dataScadenza = DateTime.UtcNow.Date.AddDays(30),
                dataProrogaRichiesta = (DateTime?)null,
                motivoProrogaRichiesta = (string?)null,
                stato = "RICEVUTA",
                responsabileGestioneId = (int?)null,
                note = "test",
                dataRisposta = (DateTime?)null,
                esitoRisposta = (string?)null,
                motivoRifiuto = (string?)null,
                testoRisposta = (string?)null,
                documentoRisposta = (string?)null,
                dataEsecuzione = (DateTime?)null,
                datiCancellati = (string?)null
            });
            id = created.RichiestaEsercizioDirittiId;

            var list = await ListAsync(client, includeDeleted: false);
            Assert.Contains(list, x => x.RichiestaEsercizioDirittiId == id);

            var updated = await UpdateAsync(client, id, new
            {
                personaId = created.PersonaId,
                nomeRichiedente = created.NomeRichiedente,
                emailRichiedente = created.EmailRichiedente,
                telefonoRichiedente = created.TelefonoRichiedente,
                codice = created.Codice,
                tipoDirittoGdprId = created.TipoDirittoGdprId,
                dataRichiesta = created.DataRichiesta,
                modalitaRichiesta = created.ModalitaRichiesta,
                testoRichiesta = created.TestoRichiesta,
                documentoRichiesta = created.DocumentoRichiesta,
                identitaVerificata = true,
                dataVerificaIdentita = DateTime.UtcNow,
                modalitaVerifica = "EMAIL",
                dataScadenza = created.DataScadenza,
                dataProrogaRichiesta = (DateTime?)null,
                motivoProrogaRichiesta = (string?)null,
                stato = "IN_LAVORAZIONE",
                responsabileGestioneId = (int?)null,
                note = "updated",
                dataRisposta = (DateTime?)null,
                esitoRisposta = (string?)null,
                motivoRifiuto = (string?)null,
                testoRisposta = (string?)null,
                documentoRisposta = (string?)null,
                dataEsecuzione = (DateTime?)null,
                datiCancellati = (string?)null
            });
            Assert.Equal("IN_LAVORAZIONE", updated.Stato);
            Assert.True(updated.IdentitaVerificata);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/richieste-esercizio-diritti/{id}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var listAfter = await ListAsync(client, includeDeleted: false);
            Assert.DoesNotContain(listAfter, x => x.RichiestaEsercizioDirittiId == id);

            var listAfterIncl = await ListAsync(client, includeDeleted: true);
            Assert.Contains(listAfterIncl, x => x.RichiestaEsercizioDirittiId == id);
        }
        finally
        {
            if (id > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/richieste-esercizio-diritti/{id}");
            }
        }
    }

    private static async Task<int> GetTipoDirittoIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/richieste-esercizio-diritti/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No TipoDirittoGDPR lookup found.");
    }

    private static async Task<IReadOnlyList<RowDto>> ListAsync(HttpClient client, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/richieste-esercizio-diritti?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new RowDto(
                item?["richiestaEsercizioDirittiId"]?.GetValue<int>() ?? 0,
                item?["codice"]?.GetValue<string>() ?? string.Empty,
                item?["stato"]?.GetValue<string>() ?? string.Empty,
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<ItemDto> CreateAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone/richieste-esercizio-diritti", request);
        response.EnsureSuccessStatusCode();
        return ParseItem(await response.Content.ReadAsStringAsync());
    }

    private static async Task<ItemDto> UpdateAsync(HttpClient client, int id, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/richieste-esercizio-diritti/{id}", request);
        response.EnsureSuccessStatusCode();
        return ParseItem(await response.Content.ReadAsStringAsync());
    }

    private static ItemDto ParseItem(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid richiesta esercizio diritti payload.");

        return new ItemDto(
            json["richiestaEsercizioDirittiId"]?.GetValue<int>() ?? 0,
            json["codice"]?.GetValue<string>() ?? string.Empty,
            json["stato"]?.GetValue<string>() ?? string.Empty,
            json["dataCancellazione"]?.GetValue<DateTime?>())
        {
            PersonaId = json["personaId"]?.GetValue<int?>(),
            NomeRichiedente = json["nomeRichiedente"]?.GetValue<string>() ?? string.Empty,
            EmailRichiedente = json["emailRichiedente"]?.GetValue<string>() ?? string.Empty,
            TelefonoRichiedente = json["telefonoRichiedente"]?.GetValue<string>(),
            TipoDirittoGdprId = json["tipoDirittoGdprId"]?.GetValue<int>() ?? 0,
            DataRichiesta = json["dataRichiesta"]?.GetValue<DateTime>() ?? DateTime.MinValue,
            ModalitaRichiesta = json["modalitaRichiesta"]?.GetValue<string>() ?? string.Empty,
            TestoRichiesta = json["testoRichiesta"]?.GetValue<string>(),
            DocumentoRichiesta = json["documentoRichiesta"]?.GetValue<string>(),
            DataScadenza = json["dataScadenza"]?.GetValue<DateTime>() ?? DateTime.MinValue,
            IdentitaVerificata = json["identitaVerificata"]?.GetValue<bool>() ?? false
        };
    }

    private sealed record RowDto(
        int RichiestaEsercizioDirittiId,
        string Codice,
        string Stato,
        DateTime? DataCancellazione);

    private sealed record ItemDto(
        int RichiestaEsercizioDirittiId,
        string Codice,
        string Stato,
        DateTime? DataCancellazione)
    {
        public int? PersonaId { get; init; }
        public string NomeRichiedente { get; init; } = string.Empty;
        public string EmailRichiedente { get; init; } = string.Empty;
        public string? TelefonoRichiedente { get; init; }
        public int TipoDirittoGdprId { get; init; }
        public DateTime DataRichiesta { get; init; }
        public string ModalitaRichiesta { get; init; } = string.Empty;
        public string? TestoRichiesta { get; init; }
        public string? DocumentoRichiesta { get; init; }
        public DateTime DataScadenza { get; init; }
        public bool IdentitaVerificata { get; init; }
    }
}
