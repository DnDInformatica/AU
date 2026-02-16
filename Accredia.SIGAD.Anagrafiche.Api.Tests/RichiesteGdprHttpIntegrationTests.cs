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

public sealed class RichiesteGdprHttpIntegrationTests
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
                cognomeRichiedente = "Rossi",
                emailRichiedente = "mario.rossi@example.test",
                telefonoRichiedente = (string?)null,
                tipoDirittoInteressatoId = tipoId,
                codice = $"GDPR_{DateTime.UtcNow:yyyyMMddHHmmss}",
                dataRichiesta = DateTime.UtcNow,
                canaleRichiesta = "EMAIL",
                descrizioneRichiesta = (string?)null,
                documentoIdentita = (string?)null,
                dataScadenzaRisposta = DateTime.UtcNow.Date.AddDays(30),
                stato = "RICEVUTA",
                responsabileGestioneId = (int?)null,
                dataPresaInCarico = (DateTime?)null,
                dataRisposta = (DateTime?)null,
                esitoRichiesta = (string?)null,
                motivoRifiuto = (string?)null,
                descrizioneRisposta = (string?)null,
                modalitaRisposta = (string?)null,
                riferimentoDocumentoRisposta = (string?)null,
                note = "test"
            });
            id = created.RichiestaGdprId;

            var list = await ListAsync(client, includeDeleted: false);
            Assert.Contains(list, x => x.RichiestaGdprId == id);

            var updated = await UpdateAsync(client, id, new
            {
                personaId = (int?)null,
                nomeRichiedente = created.NomeRichiedente,
                cognomeRichiedente = created.CognomeRichiedente,
                emailRichiedente = created.EmailRichiedente,
                telefonoRichiedente = created.TelefonoRichiedente,
                tipoDirittoInteressatoId = created.TipoDirittoInteressatoId,
                codice = created.Codice,
                dataRichiesta = created.DataRichiesta,
                canaleRichiesta = created.CanaleRichiesta,
                descrizioneRichiesta = created.DescrizioneRichiesta,
                documentoIdentita = created.DocumentoIdentita,
                dataScadenzaRisposta = created.DataScadenzaRisposta,
                stato = "IN_LAVORAZIONE",
                responsabileGestioneId = (int?)null,
                dataPresaInCarico = DateTime.UtcNow,
                dataRisposta = (DateTime?)null,
                esitoRichiesta = (string?)null,
                motivoRifiuto = (string?)null,
                descrizioneRisposta = (string?)null,
                modalitaRisposta = (string?)null,
                riferimentoDocumentoRisposta = (string?)null,
                note = "updated"
            });
            Assert.Equal("IN_LAVORAZIONE", updated.Stato);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/richieste-gdpr/{id}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var listAfter = await ListAsync(client, includeDeleted: false);
            Assert.DoesNotContain(listAfter, x => x.RichiestaGdprId == id);

            var listAfterIncl = await ListAsync(client, includeDeleted: true);
            Assert.Contains(listAfterIncl, x => x.RichiestaGdprId == id);
        }
        finally
        {
            if (id > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/richieste-gdpr/{id}");
            }
        }
    }

    private static async Task<int> GetTipoDirittoIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/richieste-gdpr/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No TipoDirittoInteressato lookup found.");
    }

    private static async Task<IReadOnlyList<RichiestaDto>> ListAsync(HttpClient client, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/richieste-gdpr?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new RichiestaDto(
                item?["richiestaGdprId"]?.GetValue<int>() ?? 0,
                item?["codice"]?.GetValue<string>() ?? string.Empty,
                item?["stato"]?.GetValue<string>() ?? string.Empty,
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<RichiestaDto> CreateAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone/richieste-gdpr", request);
        response.EnsureSuccessStatusCode();
        return ParseRichiesta(await response.Content.ReadAsStringAsync());
    }

    private static async Task<RichiestaDto> UpdateAsync(HttpClient client, int id, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/richieste-gdpr/{id}", request);
        response.EnsureSuccessStatusCode();
        return ParseRichiesta(await response.Content.ReadAsStringAsync());
    }

    private static RichiestaDto ParseRichiesta(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid richiesta GDPR payload.");

        return new RichiestaDto(
            json["richiestaGdprId"]?.GetValue<int>() ?? 0,
            json["codice"]?.GetValue<string>() ?? string.Empty,
            json["stato"]?.GetValue<string>() ?? string.Empty,
            json["dataCancellazione"]?.GetValue<DateTime?>())
        {
            PersonaId = json["personaId"]?.GetValue<int?>(),
            NomeRichiedente = json["nomeRichiedente"]?.GetValue<string>() ?? string.Empty,
            CognomeRichiedente = json["cognomeRichiedente"]?.GetValue<string>() ?? string.Empty,
            EmailRichiedente = json["emailRichiedente"]?.GetValue<string>(),
            TelefonoRichiedente = json["telefonoRichiedente"]?.GetValue<string>(),
            TipoDirittoInteressatoId = json["tipoDirittoInteressatoId"]?.GetValue<int>() ?? 0,
            DataRichiesta = json["dataRichiesta"]?.GetValue<DateTime>() ?? DateTime.MinValue,
            CanaleRichiesta = json["canaleRichiesta"]?.GetValue<string>() ?? string.Empty,
            DescrizioneRichiesta = json["descrizioneRichiesta"]?.GetValue<string>(),
            DocumentoIdentita = json["documentoIdentita"]?.GetValue<string>(),
            DataScadenzaRisposta = json["dataScadenzaRisposta"]?.GetValue<DateTime>() ?? DateTime.MinValue,
            Note = json["note"]?.GetValue<string>()
        };
    }

    private sealed record RichiestaDto(
        int RichiestaGdprId,
        string Codice,
        string Stato,
        DateTime? DataCancellazione)
    {
        public int? PersonaId { get; init; }
        public string NomeRichiedente { get; init; } = string.Empty;
        public string CognomeRichiedente { get; init; } = string.Empty;
        public string? EmailRichiedente { get; init; }
        public string? TelefonoRichiedente { get; init; }
        public int TipoDirittoInteressatoId { get; init; }
        public DateTime DataRichiesta { get; init; }
        public string CanaleRichiesta { get; init; } = string.Empty;
        public string? DescrizioneRichiesta { get; init; }
        public string? DocumentoIdentita { get; init; }
        public DateTime DataScadenzaRisposta { get; init; }
        public string? Note { get; init; }
    }
}

