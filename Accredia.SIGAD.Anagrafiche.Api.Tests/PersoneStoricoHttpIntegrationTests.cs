using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class PersoneStoricoHttpIntegrationTests
{
    [Fact]
    public async Task StoricoEndpoints_Work()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var personaId = 0;
        var persona2Id = 0;
        var personaEmailId = 0;
        var personaUtenteId = 0;
        var relazioneId = 0;
        var consensoId = 0;
        var registroId = 0;
        var richiestaGdprId = 0;
        var richiestaDirittiId = 0;
        var dataBreachId = 0;

        try
        {
            personaId = await CreatePersonaAndGetIdAsync(client, $"Storico_{DateTime.UtcNow:yyyyMMddHHmmss}");

            Assert.True(await GetArrayCountAsync(client, $"/anagrafiche/v1/persone/{personaId}/storico/persona") > 0);

            // Email storico
            var tipoEmailId = await GetFirstLookupIdAsync(client, "/anagrafiche/v1/persone/email/lookups");
            personaEmailId = await PostAndGetIdAsync(client, $"/anagrafiche/v1/persone/{personaId}/email", "personaEmailId", new
            {
                tipoEmailId,
                email = $"t_{Guid.NewGuid():N}@example.test",
                principale = true,
                verificata = false,
                dataVerifica = (DateTime?)null
            });
            Assert.True(await GetArrayCountAsync(client, $"/anagrafiche/v1/persone/{personaId}/storico/email") > 0);

            // Utente storico
            personaUtenteId = await PostAndGetIdAsync(client, $"/anagrafiche/v1/persone/{personaId}/utente", "personaUtenteId", new
            {
                userId = $"user_{Guid.NewGuid():N}"
            });
            Assert.True(await GetArrayCountAsync(client, $"/anagrafiche/v1/persone/{personaId}/storico/utente") > 0);

            // Relazioni personali storico
            persona2Id = await CreatePersonaAndGetIdAsync(client, $"Storico2_{DateTime.UtcNow:yyyyMMddHHmmss}");
            var tipoRelazioneId = await GetFirstLookupIdAsync(client, "/anagrafiche/v1/persone/relazioni-personali/lookups");
            relazioneId = await PostAndGetIdAsync(client, $"/anagrafiche/v1/persone/{personaId}/relazioni-personali", "personaRelazionePersonaleId", new
            {
                personaCollegataId = persona2Id,
                tipoRelazionePersonaleId = tipoRelazioneId,
                note = "test"
            });
            Assert.True(await GetArrayCountAsync(client, $"/anagrafiche/v1/persone/{personaId}/storico/relazioni-personali") > 0);

            // Consensi storico
            var finalitaId = await GetFirstLookupIdAsync(client, "/anagrafiche/v1/persone/consensi/lookups");
            consensoId = await PostAndGetIdAsync(client, $"/anagrafiche/v1/persone/{personaId}/consensi", "consensoPersonaId", new
            {
                tipoFinalitaTrattamentoId = finalitaId,
                consenso = true,
                dataConsenso = DateTime.UtcNow,
                dataScadenza = (DateTime?)null,
                dataRevoca = (DateTime?)null,
                modalitaAcquisizione = "WEB",
                modalitaRevoca = (string?)null,
                riferimentoDocumento = (string?)null,
                ipAddress = (string?)null,
                userAgent = (string?)null,
                motivoRevoca = (string?)null,
                versioneInformativa = "1.0",
                dataInformativa = DateTime.UtcNow.Date,
                note = "test"
            });
            Assert.True(await GetArrayCountAsync(client, $"/anagrafiche/v1/persone/{personaId}/storico/consensi") > 0);

            // Registro trattamenti storico
            var finalitaRegistroId = await GetFirstLookupIdAsync(client, "/anagrafiche/v1/persone/registro-trattamenti/lookups");
            registroId = await PostAndGetIdAsync(client, "/anagrafiche/v1/persone/registro-trattamenti", "registroTrattamentiId", new
            {
                codice = $"RTS_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nomeTrattamento = "Trattamento test",
                descrizione = (string?)null,
                tipoFinalitaTrattamentoId = finalitaRegistroId,
                baseGiuridica = "ART6_1_A",
                categorieDati = "DATI_TEST",
                categorieInteressati = "INTERESSATI_TEST",
                datiParticolari = false,
                datiGiudiziari = false,
                categorieDestinatari = (string?)null,
                trasferimentoExtraUE = false,
                paesiExtraUE = (string?)null,
                garanzieExtraUE = (string?)null,
                termineConservazione = "30 giorni",
                termineConservazioneGiorni = 30,
                misureSicurezza = (string?)null,
                responsabileTrattamentoId = (int?)null,
                contitolareId = (int?)null,
                dpoNotificato = false,
                stato = "ATTIVO",
                dataInizioTrattamento = DateTime.UtcNow.Date,
                dataFineTrattamento = (DateTime?)null
            });
            Assert.True(await GetArrayCountAsync(client, $"/anagrafiche/v1/persone/registro-trattamenti/{registroId}/storico") > 0);

            // Richiesta GDPR storico
            var tipoDirittoInteressatoId = await GetFirstLookupIdAsync(client, "/anagrafiche/v1/persone/richieste-gdpr/lookups");
            richiestaGdprId = await PostAndGetIdAsync(client, "/anagrafiche/v1/persone/richieste-gdpr", "richiestaGdprId", new
            {
                personaId = (int?)null,
                nomeRichiedente = "Mario",
                cognomeRichiedente = "Rossi",
                emailRichiedente = "mario.rossi@example.test",
                telefonoRichiedente = (string?)null,
                tipoDirittoInteressatoId,
                codice = $"GDPRS_{DateTime.UtcNow:yyyyMMddHHmmss}",
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
                note = (string?)null
            });
            Assert.True(await GetArrayCountAsync(client, $"/anagrafiche/v1/persone/richieste-gdpr/{richiestaGdprId}/storico") > 0);

            // Richiesta esercizio diritti storico
            var tipoDirittoGdprId = await GetFirstLookupIdAsync(client, "/anagrafiche/v1/persone/richieste-esercizio-diritti/lookups");
            richiestaDirittiId = await PostAndGetIdAsync(client, "/anagrafiche/v1/persone/richieste-esercizio-diritti", "richiestaEsercizioDirittiId", new
            {
                personaId = (int?)null,
                nomeRichiedente = "Mario",
                emailRichiedente = "mario.rossi@example.test",
                telefonoRichiedente = (string?)null,
                codice = $"DIRS_{DateTime.UtcNow:yyyyMMddHHmmss}",
                tipoDirittoGdprId,
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
                note = (string?)null,
                dataRisposta = (DateTime?)null,
                esitoRisposta = (string?)null,
                motivoRifiuto = (string?)null,
                testoRisposta = (string?)null,
                documentoRisposta = (string?)null,
                dataEsecuzione = (DateTime?)null,
                datiCancellati = (string?)null
            });
            Assert.True(await GetArrayCountAsync(client, $"/anagrafiche/v1/persone/richieste-esercizio-diritti/{richiestaDirittiId}/storico") > 0);

            // Data breach storico
            dataBreachId = await PostAndGetIdAsync(client, "/anagrafiche/v1/persone/data-breach", "dataBreachId", new
            {
                codice = $"DBS_{DateTime.UtcNow:yyyyMMddHHmmss}",
                titolo = "Data breach test",
                descrizione = "descr",
                dataScoperta = DateTime.UtcNow,
                dataInizioViolazione = (DateTime?)null,
                dataFineViolazione = (DateTime?)null,
                tipoViolazione = "RISERVATEZZA",
                causaViolazione = "errore",
                categorieDatiCoinvolti = "DATI_TEST",
                datiParticolariCoinvolti = false,
                numeroInteressatiStimato = (int?)null,
                categorieInteressati = "INTERESSATI_TEST",
                rischioPerInteressati = "BASSO",
                descrizioneRischio = (string?)null,
                notificaGaranteRichiesta = false,
                dataNotificaGarante = (DateTime?)null,
                protocolloGarante = (string?)null,
                termineNotificaGarante = (DateTime?)null,
                comunicazioneInteressatiRichiesta = false,
                dataComunicazioneInteressati = (DateTime?)null,
                modalitaComunicazione = (string?)null,
                misureContenimento = (string?)null,
                misurePrevenzione = (string?)null,
                responsabileGestioneId = (int?)null,
                dpoCoinvolto = false,
                stato = "APERTO",
                dataChiusura = (DateTime?)null
            });
            Assert.True(await GetArrayCountAsync(client, $"/anagrafiche/v1/persone/data-breach/{dataBreachId}/storico") > 0);
        }
        finally
        {
            if (dataBreachId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/data-breach/{dataBreachId}");
            }
            if (richiestaDirittiId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/richieste-esercizio-diritti/{richiestaDirittiId}");
            }
            if (richiestaGdprId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/richieste-gdpr/{richiestaGdprId}");
            }
            if (registroId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/registro-trattamenti/{registroId}");
            }
            if (consensoId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/consensi/{consensoId}");
            }
            if (relazioneId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/relazioni-personali/{relazioneId}");
            }
            if (personaUtenteId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/utente/{personaUtenteId}");
            }
            if (personaEmailId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/email/{personaEmailId}");
            }
            if (persona2Id > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{persona2Id}");
            }
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<int> CreatePersonaAndGetIdAsync(HttpClient client, string cognome)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", new
        {
            cognome,
            nome = "Test",
            codiceFiscale = NewFiscalCode(),
            dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
        });
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        return json?["personaId"]?.GetValue<int>() ?? throw new InvalidOperationException("personaId missing.");
    }

    private static async Task<int> GetFirstLookupIdAsync(HttpClient client, string path)
    {
        var response = await client.GetAsync(path);
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>() ?? throw new InvalidOperationException($"No lookup found for {path}.");
    }

    private static async Task<int> PostAndGetIdAsync(HttpClient client, string path, string idField, object request)
    {
        var response = await client.PostAsJsonAsync(path, request);
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        return json?[idField]?.GetValue<int>() ?? throw new InvalidOperationException($"{idField} missing from {path}.");
    }

    private static async Task<int> GetArrayCountAsync(HttpClient client, string path)
    {
        var response = await client.GetAsync(path);
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?.Count ?? 0;
    }

    private static string NewFiscalCode()
        => $"TS{Guid.NewGuid():N}".Substring(0, 16).ToUpperInvariant();
}

