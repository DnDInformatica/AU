using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Shared.Auth;
using Dapper;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Me;

/// <summary>
/// Espone identita', ruoli e permessi dell'utente corrente, letti da IAM.
/// Sostituisce 'identity/v1/me' di Identity.Api (in dismissione): i permessi
/// non provengono piu' dai claim del token ma da IAM (RF-061).
///
/// COLLOCAZIONE PROVVISORIA: l'endpoint appartiene al dominio IAM, non ad
/// Anagrafiche. E' qui perche' Anagrafiche e' il primo servizio con
/// autenticazione e risoluzione IAM attive. Da spostare quando il dominio
/// identita' avra' un servizio proprio.
/// </summary>
internal static class Endpoints
{
    public sealed record MeResponse(
        string UserId,
        string Username,
        IReadOnlyList<string> Roles,
        IReadOnlyList<string> Permissions);

    private const string SqlRuoli = @"
SELECT r.CodiceRuolo
FROM IAM.UtenteRuolo ur
JOIN IAM.RuoloSistema r ON r.RuoloSistemaId = ur.RuoloSistemaId
WHERE ur.UtenteId = @UtenteId
  AND ur.DataCancellazione IS NULL
  AND r.Attivo = 1 AND r.DataCancellazione IS NULL;";

    private const string SqlUtente = @"
SELECT ISNULL(DisplayName, Email) FROM IAM.Utente WHERE UtenteId = @UtenteId;";

    public static void Map(IEndpointRouteBuilder app)
    {
        app.MapGet("/v1/me", async (
            ICurrentUser currentUser,
            IDbConnectionFactory connectionFactory,
            CancellationToken cancellationToken) =>
        {
            if (currentUser.UtenteId == 0)
            {
                return Results.Json(
                    new { error = "Utenza non abilitata al sistema." },
                    statusCode: StatusCodes.Status403Forbidden);
            }

            await using var connection =
                await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

            var parametri = new { UtenteId = currentUser.UtenteId };

            var username = await connection.ExecuteScalarAsync<string>(
                new CommandDefinition(SqlUtente, parametri, cancellationToken: cancellationToken));

            var ruoli = (await connection.QueryAsync<string>(
                new CommandDefinition(SqlRuoli, parametri, cancellationToken: cancellationToken)))
                .ToList();

            return Results.Ok(new MeResponse(
                currentUser.UtenteId.ToString(),
                username ?? "(senza nome)",
                ruoli,
                currentUser.Permessi.ToList()));
        })
        .WithName("GetMe")
        .WithTags("Me");
    }
}
