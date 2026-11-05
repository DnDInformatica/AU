using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Shared.Auth;
using Dapper;

namespace Accredia.SIGAD.Anagrafiche.Api.Services.Auth;

/// <summary>
/// Risolve l'identita' Entra su IAM. RF-060, RF-061, RF-062, RF-063.
///
/// Principio: l'emittente stabilisce chi e' il soggetto, IAM stabilisce che cosa
/// puo' fare e su quali righe. Nessun permesso proviene dai claim del token.
/// </summary>
internal sealed class IamUserScopeResolver : IUserScopeResolver
{
    private readonly IDbConnectionFactory _connectionFactory;

    public IamUserScopeResolver(IDbConnectionFactory connectionFactory)
        => _connectionFactory = connectionFactory;

    private const string SqlUtente = @"
SELECT UtenteId
FROM IAM.Utente
WHERE EntraObjectId = @Oid
  AND EntraProvider = @Provider
  AND Attivo = 1
  AND DataCancellazione IS NULL;";

    // Contratto di lettura di IAM (script IAM 20261105_08): le viste dicono che
    // cosa vale oggi (utente e ruolo attivi, assegnazione non scaduta, organismo
    // non cancellato) e applicano la regola dei destinatari: SIGAD e IAM sono
    // solo per uso interno. Solo i permessi delle applicazioni SIGAD e IAM, dai
    // ruoli globali: i permessi di un'altra applicazione (PORTALE.*) qui non
    // valgono. IAM resta finche' le pagine di amministrazione di SIGAD non
    // passano alla console IAM.
    private const string SqlPermessi = @"
SELECT DISTINCT Permesso
FROM IAM.vw_PermessiEffettivi
WHERE UtenteId = @UtenteId
  AND Origine = N'GLOBALE'
  AND Applicazione IN (N'SIGAD', N'IAM');";

    private const string SqlOrganismi = @"
SELECT DISTINCT OrganizzazioneId
FROM IAM.vw_AssegnazioniEffettive
WHERE UtenteId = @UtenteId
  AND Origine = N'ODC';";

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
