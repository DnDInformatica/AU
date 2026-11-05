using Accredia.SIGAD.Shared.Auth;
using Accredia.SIGAD.RisorseUmane.Api.Database;
using Dapper;

namespace Accredia.SIGAD.RisorseUmane.Api.Services.Auth;

/// <summary>
/// Risolve l'identita' Entra su IAM. RF-060, RF-061, RF-062, RF-063.
///
/// Principio: l'emittente stabilisce chi e' il soggetto, IAM stabilisce che cosa
/// puo' fare e su quali righe. Nessun permesso proviene dai claim del token.
///
/// L'implementazione e' propria del servizio e non condivisa: la connection
/// factory e' interna e non va esposta trasversalmente. La ripetizione delle
/// interrogazioni e' preferibile all'esposizione dell'accesso ai dati.
/// </summary>
internal sealed class IamUserScopeResolver : IUserScopeResolver
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public IamUserScopeResolver(ISqlConnectionFactory connectionFactory)
        => _connectionFactory = connectionFactory;

    private const string SqlUtente = @"
SELECT UtenteId
FROM IAM.Utente
WHERE EntraObjectId = @Oid
  AND EntraProvider = @Provider
  AND Attivo = 1
  AND DataCancellazione IS NULL;";

    // Nota: le tabelle di associazione (UtenteRuolo, RuoloPermesso) non hanno
    // la colonna Attivo: la validita' e' data dalla sola DataCancellazione.
    private const string SqlPermessi = @"
SELECT DISTINCT p.Codice
FROM IAM.UtenteRuolo ur
JOIN IAM.RuoloPermesso rp ON rp.RuoloSistemaId = ur.RuoloSistemaId
JOIN IAM.Permesso p       ON p.PermessoId      = rp.PermessoId
WHERE ur.UtenteId = @UtenteId
  AND ur.DataCancellazione IS NULL
  AND rp.DataCancellazione IS NULL
  AND p.Attivo = 1 AND p.DataCancellazione IS NULL;";

    private const string SqlOrganismi = @"
SELECT OrganizzazioneOdCId
FROM IAM.UtenteOdC
WHERE UtenteId = @UtenteId
  AND Attivo = 1 AND DataCancellazione IS NULL
  AND (DataScadenza IS NULL OR DataScadenza >= CAST(SYSUTCDATETIME() AS date));";

    private const string SqlIspettore = @"
SELECT TOP 1 IspettoreId
FROM IAM.UtenteIspettore
WHERE UtenteId = @UtenteId
  AND Attivo = 1 AND DataCancellazione IS NULL;";

    public async Task<UserScope> ResolveAsync(
        string entraObjectId, string entraProvider, CancellationToken cancellationToken)
    {
        await using var connection =
            await _connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var utenteId = await connection.ExecuteScalarAsync<int?>(
            new CommandDefinition(SqlUtente,
                new { Oid = entraObjectId, Provider = entraProvider },
                cancellationToken: cancellationToken));

        if (utenteId is null or 0) return UserScope.NonRisolto;

        var parametri = new { UtenteId = utenteId.Value };

        var permessi = (await connection.QueryAsync<string>(
            new CommandDefinition(SqlPermessi, parametri, cancellationToken: cancellationToken)))
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        var organismi = (await connection.QueryAsync<int>(
            new CommandDefinition(SqlOrganismi, parametri, cancellationToken: cancellationToken)))
            .ToList();

        var ispettoreId = await connection.ExecuteScalarAsync<int?>(
            new CommandDefinition(SqlIspettore, parametri, cancellationToken: cancellationToken));

        return new UserScope(utenteId.Value, permessi, organismi, ispettoreId);
    }
}

