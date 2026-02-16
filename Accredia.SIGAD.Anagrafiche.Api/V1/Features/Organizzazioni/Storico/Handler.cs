using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Storico;

internal static class Handler
{
    public static async Task<IReadOnlyList<OrganizzazioneStoricoDto>?> GetOrganizzazioneAsync(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                o.OrganizzazioneId,
                o.RagioneSociale,
                o.Denominazione,
                o.PartitaIVA AS PartitaIva,
                o.CodiceFiscale,
                o.DataInizioValidita,
                o.DataFineValidita,
                o.DataCancellazione
            FROM [Organizzazioni].[OrganizzazioneStorico] o
            WHERE o.OrganizzazioneId = @OrganizzazioneId
            ORDER BY o.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await OrganizzazioneExistsAsync(connection, command.OrganizzazioneId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<OrganizzazioneStoricoDto>(new CommandDefinition(
            sql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<UnitaOrganizzativaStoricoDto>?> GetUnitaAsync(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                u.UnitaOrganizzativaId,
                u.OrganizzazioneId,
                u.Nome,
                u.Principale,
                u.DataInizioValidita,
                u.DataFineValidita,
                u.DataCancellazione
            FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
            WHERE u.OrganizzazioneId = @OrganizzazioneId
            ORDER BY u.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await OrganizzazioneExistsAsync(connection, command.OrganizzazioneId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<UnitaOrganizzativaStoricoDto>(new CommandDefinition(
            sql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<SedeStoricoDto>?> GetSediAsync(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                s.SedeId,
                s.OrganizzazioneId,
                s.Indirizzo,
                s.Localita,
                s.StatoSede,
                s.DataInizioValidita,
                s.DataFineValidita,
                s.DataCancellazione
            FROM [Organizzazioni].[SedeStorico] s
            WHERE s.OrganizzazioneId = @OrganizzazioneId
            ORDER BY s.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await OrganizzazioneExistsAsync(connection, command.OrganizzazioneId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<SedeStoricoDto>(new CommandDefinition(
            sql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<IncaricoStoricoDto>?> GetIncarichiAsync(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                i.IncaricoId,
                i.PersonaId,
                i.TipoRuoloId,
                i.OrganizzazioneId,
                i.UnitaOrganizzativaId,
                CAST(i.DataInizio AS datetime2) AS DataInizio,
                CAST(i.DataFine AS datetime2) AS DataFine,
                i.StatoIncarico,
                i.DataInizioValidita,
                i.DataFineValidita,
                i.DataCancellazione
            FROM [Organizzazioni].[IncaricoStorico] i
            WHERE i.OrganizzazioneId = @OrganizzazioneId
               OR EXISTS (
                    SELECT 1
                    FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
                    WHERE u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
                      AND u.OrganizzazioneId = @OrganizzazioneId)
            ORDER BY i.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await OrganizzazioneExistsAsync(connection, command.OrganizzazioneId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<IncaricoStoricoDto>(new CommandDefinition(
            sql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<RelazioniStoricoResponse?> GetRelazioniAsync(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await OrganizzazioneExistsAsync(connection, command.OrganizzazioneId, cancellationToken))
        {
            return null;
        }

        var tipologie = (await connection.QueryAsync<OrganizzazioneTipoOrganizzazioneStoricoDto>(new CommandDefinition("""
            SELECT OrganizzazioneTipoOrganizzazioneId, OrganizzazioneId, TipoOrganizzazioneId, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[OrganizzazioneTipoOrganizzazioneStorico]
            WHERE OrganizzazioneId = @OrganizzazioneId
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var sedi = (await connection.QueryAsync<OrganizzazioneSedeStoricoDto>(new CommandDefinition("""
            SELECT OrganizzazioneSedeId, OrganizzazioneId, TipoOrganizzazioneSedeId, CAST(DataApertura AS datetime2) AS DataApertura, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[OrganizzazioneSedeStorico]
            WHERE OrganizzazioneId = @OrganizzazioneId
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var unitaRelazioni = (await connection.QueryAsync<UnitaRelazioneStoricoDto>(new CommandDefinition("""
            SELECT UnitaRelazioneId, UnitaPadreId, UnitaFigliaId, TipoRelazioneId, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[UnitaRelazioneStorico] r
            WHERE EXISTS (
                    SELECT 1
                    FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
                    WHERE u.UnitaOrganizzativaId = r.UnitaPadreId
                      AND u.OrganizzazioneId = @OrganizzazioneId)
               OR EXISTS (
                    SELECT 1
                    FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
                    WHERE u.UnitaOrganizzativaId = r.UnitaFigliaId
                      AND u.OrganizzazioneId = @OrganizzazioneId)
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var unitaFunzioni = (await connection.QueryAsync<UnitaFunzioneStoricoDto>(new CommandDefinition("""
            SELECT UnitaOrganizzativaFunzioneId, UnitaOrganizzativaId, TipoFunzioneUnitaLocaleId, Principale, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[UnitaOrganizzativaFunzioneStorico] f
            WHERE EXISTS (
                SELECT 1
                FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
                WHERE u.UnitaOrganizzativaId = f.UnitaOrganizzativaId
                  AND u.OrganizzazioneId = @OrganizzazioneId)
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var sediUnita = (await connection.QueryAsync<SedeUnitaStoricoDto>(new CommandDefinition("""
            SELECT SedeUnitaOrganizzativaId, SedeId, UnitaOrganizzativaId, Principale, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[SedeUnitaOrganizzativaStorico] su
            WHERE EXISTS (
                SELECT 1
                FROM [Organizzazioni].[SedeStorico] s
                WHERE s.SedeId = su.SedeId
                  AND s.OrganizzazioneId = @OrganizzazioneId)
               OR EXISTS (
                SELECT 1
                FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
                WHERE u.UnitaOrganizzativaId = su.UnitaOrganizzativaId
                  AND u.OrganizzazioneId = @OrganizzazioneId)
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var gruppiIva = (await connection.QueryAsync<GruppoIvaStoricoDto>(new CommandDefinition("""
            SELECT g.GruppoIVAId AS GruppoIvaId, g.PartitaIVAGruppo AS PartitaIvaGruppo, g.Denominazione, g.DataInizioValidita, g.DataFineValidita, g.DataCancellazione
            FROM [Organizzazioni].[GruppoIVAStorico] g
            WHERE g.OrganizzazioneCapogruppoId = @OrganizzazioneId
               OR EXISTS (
                    SELECT 1
                    FROM [Organizzazioni].[GruppoIVAMembriStorico] m
                    WHERE m.GruppoIVAId = g.GruppoIVAId
                      AND m.OrganizzazioneId = @OrganizzazioneId)
            ORDER BY g.DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var gruppiIvaMembri = (await connection.QueryAsync<GruppoIvaMembroStoricoDto>(new CommandDefinition("""
            SELECT m.GruppoIVAMembroId AS GruppoIvaMembroId, m.GruppoIVAId AS GruppoIvaId, m.OrganizzazioneId, m.IsCapogruppo, m.DataInizioValidita, m.DataFineValidita, m.DataCancellazione
            FROM [Organizzazioni].[GruppoIVAMembriStorico] m
            WHERE m.OrganizzazioneId = @OrganizzazioneId
               OR EXISTS (
                    SELECT 1
                    FROM [Organizzazioni].[GruppoIVAStorico] g
                    WHERE g.GruppoIVAId = m.GruppoIVAId
                      AND g.OrganizzazioneCapogruppoId = @OrganizzazioneId)
            ORDER BY m.DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        return new RelazioniStoricoResponse(
            tipologie,
            sedi,
            unitaRelazioni,
            unitaFunzioni,
            sediUnita,
            gruppiIva,
            gruppiIvaMembri);
    }

    public static async Task<AttributiStoricoResponse?> GetAttributiAsync(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await OrganizzazioneExistsAsync(connection, command.OrganizzazioneId, cancellationToken))
        {
            return null;
        }

        var identificativi = (await connection.QueryAsync<OrganizzazioneIdentificativoFiscaleStoricoDto>(new CommandDefinition("""
            SELECT OrganizzazioneIdentificativoFiscaleId, OrganizzazioneId, PaeseISO2, TipoIdentificativo, Valore, Principale, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[OrganizzazioneIdentificativoFiscaleStorico]
            WHERE OrganizzazioneId = @OrganizzazioneId
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var contatti = (await connection.QueryAsync<ContattoUnitaStoricoDto>(new CommandDefinition("""
            SELECT ContattoId, UnitaOrganizzativaId, TipoContattoId, Valore, Principale, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[ContattoUnitaOrganizzativaStorico] c
            WHERE EXISTS (
                SELECT 1
                FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
                WHERE u.UnitaOrganizzativaId = c.UnitaOrganizzativaId
                  AND u.OrganizzazioneId = @OrganizzazioneId)
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var indirizzi = (await connection.QueryAsync<IndirizzoUnitaStoricoDto>(new CommandDefinition("""
            SELECT IndirizzoId, UnitaOrganizzativaId, TipoIndirizzoId, Indirizzo, Principale, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[IndirizzoUnitaOrganizzativaStorico] i
            WHERE EXISTS (
                SELECT 1
                FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
                WHERE u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
                  AND u.OrganizzazioneId = @OrganizzazioneId)
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var competenze = (await connection.QueryAsync<CompetenzaStoricoDto>(new CommandDefinition("""
            SELECT CompetenzaId, CodiceCompetenza, Principale, Attivo, Verificato, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[CompetenzaStorico]
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var poteri = (await connection.QueryAsync<PotereStoricoDto>(new CommandDefinition("""
            SELECT PotereId, IncaricoId, TipoPotereId, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[PotereStorico] p
            WHERE EXISTS (
                SELECT 1
                FROM [Organizzazioni].[IncaricoStorico] i
                WHERE i.IncaricoId = p.IncaricoId
                  AND (i.OrganizzazioneId = @OrganizzazioneId
                       OR EXISTS (
                            SELECT 1
                            FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
                            WHERE u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
                              AND u.OrganizzazioneId = @OrganizzazioneId)))
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        var attivita = (await connection.QueryAsync<UnitaAttivitaStoricoDto>(new CommandDefinition("""
            SELECT UnitaAttivitaId, UnitaOrganizzativaId, CodiceATECORI AS CodiceAtecoRi, Importanza, DataInizioValidita, DataFineValidita, DataCancellazione
            FROM [Organizzazioni].[UnitaAttivitaStorico] a
            WHERE EXISTS (
                SELECT 1
                FROM [Organizzazioni].[UnitaOrganizzativaStorico] u
                WHERE u.UnitaOrganizzativaId = a.UnitaOrganizzativaId
                  AND u.OrganizzazioneId = @OrganizzazioneId)
            ORDER BY DataInizioValidita DESC;
            """, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        return new AttributiStoricoResponse(
            identificativi,
            contatti,
            indirizzi,
            competenze,
            poteri,
            attivita);
    }

    private static async Task<bool> OrganizzazioneExistsAsync(
        System.Data.Common.DbConnection connection,
        int organizzazioneId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Organizzazione] o
            WHERE o.OrganizzazioneId = @OrganizzazioneId
              AND o.DataCancellazione IS NULL
              AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
              AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());
            """;
        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql, new { OrganizzazioneId = organizzazioneId }, cancellationToken: cancellationToken));
        return count > 0;
    }
}
