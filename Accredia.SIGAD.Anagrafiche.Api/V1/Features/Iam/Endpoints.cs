using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Shared.Auth;
using Dapper;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Iam;

/// <summary>
/// Ruoli, catalogo dei permessi e associazione ruolo-permesso su IAM, per la
/// console di amministrazione. Sostituiscono identity/v1/roles e
/// identity/v1/permissions di Identity.Api (in dismissione), che scrivevano lo
/// schema Identity: i permessi effettivi di SIGAD e del Portale stanno in
/// IAM.RuoloPermesso. Il contratto JSON resta quello della console.
///
/// COLLOCAZIONE PROVVISORIA, come /v1/me: da spostare quando il dominio
/// identita' avra' un servizio proprio.
///
/// IAM.RuoloPermesso e' temporale con cancellazione logica: il salvataggio
/// tocca solo le righe che cambiano (revoca, riattivazione, nuova
/// assegnazione), cosi' lo storico registra le sole modifiche e il loro autore.
/// </summary>
internal static class Endpoints
{
    private const string PermessoGestione = "ADMIN.PERMISSIONS.MANAGE";
    private static readonly string[] PermessiLettura = ["ADMIN.PERMISSIONS.MANAGE", "ADMIN.ROLES.MANAGE", "MODULE.ADMIN.ACCESS"];

    public sealed record RuoloDto(string RoleId, string Name, string? Description, string Ambito);

    public sealed record PermessoDto(int PermissionId, string Code, string Description, string Module, string Scope, bool Attivo);

    public sealed record PermessiRuoloResponse(string RoleId, string RoleName, IReadOnlyList<string> Permissions);

    public sealed record AggiornaPermessiRuoloRequest(IReadOnlyList<string>? Permissions);

    private const string SqlRuoli = @"
SELECT CAST(RuoloSistemaId AS nvarchar(20)) AS RoleId, CodiceRuolo AS Name,
       Descrizione AS Description, AmbitoRuolo AS Ambito
FROM IAM.RuoloSistema
WHERE Attivo = 1 AND DataCancellazione IS NULL
ORDER BY AmbitoRuolo, CodiceRuolo;";

    private const string SqlRuolo = @"
SELECT CodiceRuolo
FROM IAM.RuoloSistema
WHERE RuoloSistemaId = @RuoloId AND Attivo = 1 AND DataCancellazione IS NULL;";

    private const string SqlPermessi = @"
SELECT PermessoId AS PermissionId, Codice AS Code, Descrizione AS Description,
       Modulo AS Module, Ambito AS Scope, Attivo
FROM IAM.Permesso
WHERE DataCancellazione IS NULL
ORDER BY Modulo, Codice;";

    private const string SqlPermessiRuolo = @"
SELECT p.Codice
FROM IAM.RuoloPermesso rp
JOIN IAM.Permesso p ON p.PermessoId = rp.PermessoId AND p.DataCancellazione IS NULL
WHERE rp.RuoloSistemaId = @RuoloId AND rp.DataCancellazione IS NULL
ORDER BY p.Codice;";

    private const string SqlIdPermessi = @"
SELECT PermessoId
FROM IAM.Permesso
WHERE Codice IN @Codici AND Attivo = 1 AND DataCancellazione IS NULL;";

    private const string SqlRevoca = @"
UPDATE IAM.RuoloPermesso
SET DataCancellazione = SYSUTCDATETIME(), CancellatoDa = @UtenteId
WHERE RuoloSistemaId = @RuoloId AND DataCancellazione IS NULL
  AND PermessoId NOT IN @Ids;";

    private const string SqlRiattiva = @"
UPDATE IAM.RuoloPermesso
SET DataCancellazione = NULL, CancellatoDa = NULL,
    DataCreazione = SYSUTCDATETIME(), CreatoDa = @UtenteId
WHERE RuoloSistemaId = @RuoloId AND DataCancellazione IS NOT NULL
  AND PermessoId IN @Ids;";

    private const string SqlInserisci = @"
INSERT INTO IAM.RuoloPermesso (RuoloSistemaId, PermessoId, CreatoDa)
SELECT @RuoloId, p.PermessoId, @UtenteId
FROM IAM.Permesso p
WHERE p.PermessoId IN @Ids
  AND NOT EXISTS (SELECT 1 FROM IAM.RuoloPermesso x
                  WHERE x.RuoloSistemaId = @RuoloId AND x.PermessoId = p.PermessoId);";

    // Dopo il salvataggio deve restare almeno un utente attivo in grado di
    // amministrare i permessi: altrimenti la console non si potrebbe piu' usare.
    private const string SqlAmministratoriRimasti = @"
SELECT COUNT(*)
FROM IAM.UtenteRuolo ur
JOIN IAM.Utente u         ON u.UtenteId = ur.UtenteId AND u.Attivo = 1 AND u.DataCancellazione IS NULL
JOIN IAM.RuoloSistema r   ON r.RuoloSistemaId = ur.RuoloSistemaId AND r.Attivo = 1 AND r.DataCancellazione IS NULL
JOIN IAM.RuoloPermesso rp ON rp.RuoloSistemaId = r.RuoloSistemaId AND rp.DataCancellazione IS NULL
JOIN IAM.Permesso p       ON p.PermessoId = rp.PermessoId AND p.Attivo = 1 AND p.DataCancellazione IS NULL
WHERE ur.DataCancellazione IS NULL AND p.Codice = @Codice;";

    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/iam/ruoli", "IamRuoli", async (
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                var ruoli = await connection.QueryAsync<RuoloDto>(
                    new CommandDefinition(SqlRuoli, cancellationToken: cancellationToken));
                return Results.Ok(ruoli.ToList());
            },
            builder => builder
                .Produces<IReadOnlyList<RuoloDto>>(StatusCodes.Status200OK)
                .RichiedePermesso(PermessiLettura));

        ApiVersioning.MapVersionedGet(app, "/iam/permessi", "IamPermessi", async (
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                var permessi = await connection.QueryAsync<PermessoDto>(
                    new CommandDefinition(SqlPermessi, cancellationToken: cancellationToken));
                return Results.Ok(permessi.ToList());
            },
            builder => builder
                .Produces<IReadOnlyList<PermessoDto>>(StatusCodes.Status200OK)
                .RichiedePermesso(PermessiLettura));

        ApiVersioning.MapVersionedGet(app, "/iam/ruoli/{ruoloId:int}/permessi", "IamPermessiRuolo", async (
                int ruoloId,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                var parametri = new { RuoloId = ruoloId };
                var codiceRuolo = await connection.ExecuteScalarAsync<string?>(
                    new CommandDefinition(SqlRuolo, parametri, cancellationToken: cancellationToken));
                if (codiceRuolo is null)
                    return Results.NotFound();

                var permessi = await connection.QueryAsync<string>(
                    new CommandDefinition(SqlPermessiRuolo, parametri, cancellationToken: cancellationToken));
                return Results.Ok(new PermessiRuoloResponse(ruoloId.ToString(), codiceRuolo, permessi.ToList()));
            },
            builder => builder
                .Produces<PermessiRuoloResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .RichiedePermesso(PermessiLettura));

        ApiVersioning.MapVersionedPut(app, "/iam/ruoli/{ruoloId:int}/permessi", "IamAggiornaPermessiRuolo", async (
                int ruoloId,
                AggiornaPermessiRuoloRequest request,
                ICurrentUser currentUser,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                if (request.Permissions is null)
                    return Results.BadRequest(new { error = "Indicare l'elenco dei permessi, anche vuoto." });

                var codici = request.Permissions
                    .Where(c => !string.IsNullOrWhiteSpace(c))
                    .Select(c => c.Trim())
                    .Distinct(StringComparer.OrdinalIgnoreCase)
                    .ToArray();

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                var codiceRuolo = await connection.ExecuteScalarAsync<string?>(
                    new CommandDefinition(SqlRuolo, new { RuoloId = ruoloId }, cancellationToken: cancellationToken));
                if (codiceRuolo is null)
                    return Results.NotFound();

                var ids = (await connection.QueryAsync<int>(
                    new CommandDefinition(SqlIdPermessi, new { Codici = codici }, cancellationToken: cancellationToken))).ToArray();
                if (ids.Length != codici.Length)
                    return Results.BadRequest(new { error = "Uno o piu' permessi non esistono o non sono attivi." });

                await using var tx = await connection.BeginTransactionAsync(cancellationToken);
                var parametri = new { RuoloId = ruoloId, Ids = ids, UtenteId = currentUser.UtenteId };

                var revocati = await connection.ExecuteAsync(
                    new CommandDefinition(SqlRevoca, parametri, tx, cancellationToken: cancellationToken));
                var riattivati = await connection.ExecuteAsync(
                    new CommandDefinition(SqlRiattiva, parametri, tx, cancellationToken: cancellationToken));
                var inseriti = await connection.ExecuteAsync(
                    new CommandDefinition(SqlInserisci, parametri, tx, cancellationToken: cancellationToken));

                var amministratori = await connection.ExecuteScalarAsync<int>(
                    new CommandDefinition(SqlAmministratoriRimasti, new { Codice = PermessoGestione }, tx, cancellationToken: cancellationToken));
                if (amministratori == 0)
                {
                    await tx.RollbackAsync(cancellationToken);
                    return Results.Conflict(new
                    {
                        error = $"Modifica annullata: nessun utente attivo avrebbe piu' il permesso {PermessoGestione}."
                    });
                }

                await tx.CommitAsync(cancellationToken);
                return Results.Ok(new { revocati, riattivati, inseriti });
            },
            builder => builder
                .Produces(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .RichiedePermesso(PermessoGestione));
    }
}
