using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Storico;

internal static class Handler
{
    public static async Task<IReadOnlyList<PersonaStoricoDto>?> GetPersonaAsync(
        PersonaCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                p.PersonaId,
                p.CodiceFiscale,
                p.Cognome,
                p.Nome,
                CAST(p.DataNascita AS datetime2) AS DataNascita,
                p.DataInizioValidita,
                p.DataFineValidita,
                p.DataCancellazione
            FROM [Persone].[PersonaStorico] p
            WHERE p.PersonaId = @PersonaId
            ORDER BY p.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await PersonaExistsAsync(connection, command.PersonaId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<PersonaStoricoDto>(new CommandDefinition(
            sql, new { command.PersonaId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<PersonaEmailStoricoDto>?> GetEmailAsync(
        PersonaCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                e.PersonaEmailId,
                e.PersonaId,
                e.TipoEmailId,
                e.Email,
                e.Principale,
                e.Verificata,
                e.DataVerifica,
                e.DataInizioValidita,
                e.DataFineValidita,
                e.DataCancellazione
            FROM [Persone].[PersonaEmailStorico] e
            WHERE e.PersonaId = @PersonaId
            ORDER BY e.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await PersonaExistsAsync(connection, command.PersonaId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<PersonaEmailStoricoDto>(new CommandDefinition(
            sql, new { command.PersonaId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<PersonaTelefonoStoricoDto>?> GetTelefoniAsync(
        PersonaCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                t.PersonaTelefonoId,
                t.PersonaId,
                t.TipoTelefonoId,
                t.PrefissoInternazionale,
                t.Numero,
                t.Estensione,
                t.Principale,
                t.Verificato,
                t.DataVerifica,
                t.DataInizioValidita,
                t.DataFineValidita,
                t.DataCancellazione
            FROM [Persone].[PersonaTelefonoStorico] t
            WHERE t.PersonaId = @PersonaId
            ORDER BY t.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await PersonaExistsAsync(connection, command.PersonaId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<PersonaTelefonoStoricoDto>(new CommandDefinition(
            sql, new { command.PersonaId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<PersonaIndirizzoStoricoDto>?> GetIndirizziAsync(
        PersonaCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                i.PersonaIndirizzoId,
                i.PersonaId,
                i.IndirizzoId,
                i.TipoIndirizzoId,
                i.Principale,
                i.Attivo,
                i.DataInizioValidita,
                i.DataFineValidita,
                i.DataCancellazione
            FROM [Persone].[PersonaIndirizzoStorico] i
            WHERE i.PersonaId = @PersonaId
            ORDER BY i.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await PersonaExistsAsync(connection, command.PersonaId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<PersonaIndirizzoStoricoDto>(new CommandDefinition(
            sql, new { command.PersonaId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<PersonaQualificaStoricoDto>?> GetQualificheAsync(
        PersonaCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                q.PersonaQualificaId,
                q.PersonaId,
                q.TipoQualificaId,
                q.EnteRilascioQualificaId,
                q.CodiceAttestato,
                CAST(q.DataRilascio AS datetime2) AS DataRilascio,
                CAST(q.DataScadenza AS datetime2) AS DataScadenza,
                q.Valida,
                q.Note,
                q.DataInizioValidita,
                q.DataFineValidita,
                q.DataCancellazione
            FROM [Persone].[PersonaQualificaStorico] q
            WHERE q.PersonaId = @PersonaId
            ORDER BY q.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await PersonaExistsAsync(connection, command.PersonaId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<PersonaQualificaStoricoDto>(new CommandDefinition(
            sql, new { command.PersonaId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<PersonaTitoloStudioStoricoDto>?> GetTitoliStudioAsync(
        PersonaCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                t.PersonaTitoloStudioId,
                t.PersonaId,
                t.TipoTitoloStudioId,
                t.Istituzione,
                t.Corso,
                CAST(t.DataConseguimento AS datetime2) AS DataConseguimento,
                t.Voto,
                t.Lode,
                t.Paese,
                t.Note,
                t.Principale,
                t.DataInizioValidita,
                t.DataFineValidita,
                t.DataCancellazione
            FROM [Persone].[PersonaTitoloStudioStorico] t
            WHERE t.PersonaId = @PersonaId
            ORDER BY t.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await PersonaExistsAsync(connection, command.PersonaId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<PersonaTitoloStudioStoricoDto>(new CommandDefinition(
            sql, new { command.PersonaId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<PersonaRelazionePersonaleStoricoDto>?> GetRelazioniPersonaliAsync(
        PersonaCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.PersonaRelazionePersonaleId,
                r.PersonaId,
                r.PersonaCollegataId,
                r.TipoRelazionePersonaleId,
                r.Note,
                r.DataInizioValidita,
                r.DataFineValidita,
                r.DataCancellazione
            FROM [Persone].[PersonaRelazionePersonaleStorico] r
            WHERE r.PersonaId = @PersonaId
               OR r.PersonaCollegataId = @PersonaId
            ORDER BY r.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await PersonaExistsAsync(connection, command.PersonaId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<PersonaRelazionePersonaleStoricoDto>(new CommandDefinition(
            sql, new { command.PersonaId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<PersonaUtenteStoricoDto>?> GetUtenteAsync(
        PersonaCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                u.PersonaUtenteId,
                u.PersonaId,
                u.UserId,
                u.DataInizioValidita,
                u.DataFineValidita,
                u.DataCancellazione
            FROM [Persone].[PersonaUtenteStorico] u
            WHERE u.PersonaId = @PersonaId
            ORDER BY u.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await PersonaExistsAsync(connection, command.PersonaId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<PersonaUtenteStoricoDto>(new CommandDefinition(
            sql, new { command.PersonaId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<ConsensoPersonaStoricoDto>?> GetConsensiAsync(
        PersonaCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                c.ConsensoPersonaId,
                c.PersonaId,
                c.TipoFinalitaTrattamentoId,
                c.Consenso,
                c.DataConsenso,
                c.DataRevoca,
                c.ModalitaAcquisizione,
                c.ModalitaRevoca,
                c.DataInizioValidita,
                c.DataFineValidita,
                c.DataCancellazione
            FROM [Persone].[ConsensoPersonaStorico] c
            WHERE c.PersonaId = @PersonaId
            ORDER BY c.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await PersonaExistsAsync(connection, command.PersonaId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<ConsensoPersonaStoricoDto>(new CommandDefinition(
            sql, new { command.PersonaId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<RegistroTrattamentiStoricoDto>?> GetRegistroTrattamentiAsync(
        RegistroTrattamentiCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.RegistroTrattamentiId,
                r.Codice,
                r.NomeTrattamento,
                r.TipoFinalitaTrattamentoId,
                r.BaseGiuridica,
                r.Stato,
                CAST(r.DataInizioTrattamento AS datetime2) AS DataInizioTrattamento,
                CAST(r.DataFineTrattamento AS datetime2) AS DataFineTrattamento,
                r.DataInizioValidita,
                r.DataFineValidita,
                r.DataCancellazione
            FROM [Persone].[RegistroTrattamentiStorico] r
            WHERE r.RegistroTrattamentiId = @RegistroTrattamentiId
            ORDER BY r.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await RegistroTrattamentiExistsAsync(connection, command.RegistroTrattamentiId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<RegistroTrattamentiStoricoDto>(new CommandDefinition(
            sql, new { command.RegistroTrattamentiId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<RichiestaGdprStoricoDto>?> GetRichiestaGdprAsync(
        RichiestaGdprCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.RichiestaGDPRId AS RichiestaGdprId,
                r.Codice,
                r.PersonaId,
                r.TipoDirittoInteressatoId,
                r.DataRichiesta,
                CAST(r.DataScadenzaRisposta AS datetime2) AS DataScadenzaRisposta,
                r.Stato,
                r.DataInizioValidita,
                r.DataFineValidita,
                r.DataCancellazione
            FROM [Persone].[RichiestaGDPRStorico] r
            WHERE r.RichiestaGDPRId = @RichiestaGdprId
            ORDER BY r.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await RichiestaGdprExistsAsync(connection, command.RichiestaGdprId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<RichiestaGdprStoricoDto>(new CommandDefinition(
            sql, new { command.RichiestaGdprId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<RichiestaEsercizioDirittiStoricoDto>?> GetRichiestaEsercizioDirittiAsync(
        RichiestaEsercizioDirittiCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.RichiestaEsercizioDirittiId,
                r.Codice,
                r.PersonaId,
                r.TipoDirittoGDPRId AS TipoDirittoGdprId,
                r.DataRichiesta,
                CAST(r.DataScadenza AS datetime2) AS DataScadenza,
                r.Stato,
                r.DataInizioValidita,
                r.DataFineValidita,
                r.DataCancellazione
            FROM [Persone].[RichiestaEsercizioDirittiStorico] r
            WHERE r.RichiestaEsercizioDirittiId = @RichiestaEsercizioDirittiId
            ORDER BY r.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await RichiestaEsercizioDirittiExistsAsync(connection, command.RichiestaEsercizioDirittiId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<RichiestaEsercizioDirittiStoricoDto>(new CommandDefinition(
            sql, new { command.RichiestaEsercizioDirittiId }, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<DataBreachStoricoDto>?> GetDataBreachAsync(
        DataBreachCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                d.DataBreachId,
                d.Codice,
                d.DataScoperta,
                d.Stato,
                d.DataInizioValidita,
                d.DataFineValidita,
                d.DataCancellazione
            FROM [Persone].[DataBreachStorico] d
            WHERE d.DataBreachId = @DataBreachId
            ORDER BY d.DataInizioValidita DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await DataBreachExistsAsync(connection, command.DataBreachId, cancellationToken))
        {
            return null;
        }

        return (await connection.QueryAsync<DataBreachStoricoDto>(new CommandDefinition(
            sql, new { command.DataBreachId }, cancellationToken: cancellationToken))).ToList();
    }

    private static async Task<bool> PersonaExistsAsync(
        System.Data.Common.DbConnection connection,
        int personaId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Persone].[Persona] p
            WHERE p.PersonaId = @PersonaId
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;
        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql, new { PersonaId = personaId }, cancellationToken: cancellationToken));
        return count > 0;
    }

    private static async Task<bool> RegistroTrattamentiExistsAsync(
        System.Data.Common.DbConnection connection,
        int id,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Persone].[RegistroTrattamenti] r
            WHERE r.RegistroTrattamentiId = @Id
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;
        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql, new { Id = id }, cancellationToken: cancellationToken));
        return count > 0;
    }

    private static async Task<bool> RichiestaGdprExistsAsync(
        System.Data.Common.DbConnection connection,
        int id,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Persone].[RichiestaGDPR] r
            WHERE r.RichiestaGDPRId = @Id
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;
        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql, new { Id = id }, cancellationToken: cancellationToken));
        return count > 0;
    }

    private static async Task<bool> RichiestaEsercizioDirittiExistsAsync(
        System.Data.Common.DbConnection connection,
        int id,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Persone].[RichiestaEsercizioDiritti] r
            WHERE r.RichiestaEsercizioDirittiId = @Id
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;
        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql, new { Id = id }, cancellationToken: cancellationToken));
        return count > 0;
    }

    private static async Task<bool> DataBreachExistsAsync(
        System.Data.Common.DbConnection connection,
        int id,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Persone].[DataBreach] d
            WHERE d.DataBreachId = @Id
              AND d.DataCancellazione IS NULL
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME());
            """;
        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql, new { Id = id }, cancellationToken: cancellationToken));
        return count > 0;
    }
}

