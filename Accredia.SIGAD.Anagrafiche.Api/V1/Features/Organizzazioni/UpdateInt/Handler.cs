using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetByIdInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UpdateInt;

internal static class Handler
{
    public static async Task<OrganizzazioneDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var columns = await CreateInt.DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        if (!columns.ContainsKey("Denominazione"))
        {
            throw new InvalidOperationException("Colonna Denominazione mancante su [Organizzazioni].[Organizzazione].");
        }

        var now = DateTime.UtcNow;
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();

        var sets = new List<string>();
        var p = new DynamicParameters();
        p.Add("OrganizzazioneId", command.OrganizzazioneId);

        static bool IsUpdatable(CreateInt.DbIntrospection.ColumnInfo col)
            => !col.IsIdentity && !col.IsComputed && !col.IsHidden && !col.IsGeneratedAlways;

        void Set(string col, string sql, object? value = null)
        {
            if (!columns.TryGetValue(col, out var info))
            {
                return;
            }

            if (!IsUpdatable(info))
            {
                return;
            }

            sets.Add(sql);
            p.Add(col, value);
        }

        Set("Denominazione", "[Denominazione] = @Denominazione", command.Request.Denominazione.Trim());
        Set("RagioneSociale", "[RagioneSociale] = @RagioneSociale", string.IsNullOrWhiteSpace(command.Request.RagioneSociale) ? null : command.Request.RagioneSociale.Trim());
        Set("PartitaIVA", "[PartitaIVA] = @PartitaIVA", string.IsNullOrWhiteSpace(command.Request.PartitaIVA) ? null : command.Request.PartitaIVA.Trim());
        Set("CodiceFiscale", "[CodiceFiscale] = @CodiceFiscale", string.IsNullOrWhiteSpace(command.Request.CodiceFiscale) ? null : command.Request.CodiceFiscale.Trim());
        Set("StatoAttivitaId", "[StatoAttivitaId] = @StatoAttivitaId", command.Request.StatoAttivitaId ?? (byte)1);
        Set("NRegistroImprese", "[NRegistroImprese] = @NRegistroImprese", string.IsNullOrWhiteSpace(command.Request.NRegistroImprese) ? null : command.Request.NRegistroImprese.Trim());
        Set("OggettoSociale", "[OggettoSociale] = @OggettoSociale", string.IsNullOrWhiteSpace(command.Request.OggettoSociale) ? null : command.Request.OggettoSociale.Trim());
        Set("DataIscrizioneIscrizioneRI", "[DataIscrizioneIscrizioneRI] = @DataIscrizioneIscrizioneRI", command.Request.DataIscrizioneIscrizioneRI);
        Set("DataCostituzione", "[DataCostituzione] = @DataCostituzione", command.Request.DataCostituzione);
        Set("TipoCodiceNaturaGiuridicaId", "[TipoCodiceNaturaGiuridicaId] = @TipoCodiceNaturaGiuridicaId", command.Request.TipoCodiceNaturaGiuridicaId);

        Set("DataModifica", "[DataModifica] = @DataModifica", now);
        Set(
            "ModificatoDa",
            "[ModificatoDa] = @ModificatoDa",
            CreateInt.DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor));

        if (sets.Count == 0)
        {
            return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(command.OrganizzazioneId), connectionFactory, cancellationToken);
        }

        var updateSql = $"""
            UPDATE [Organizzazioni].[Organizzazione]
            SET {string.Join(", ", sets)}
            WHERE [OrganizzazioneId] = @OrganizzazioneId
              AND [DataCancellazione] IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(updateSql, p, cancellationToken: cancellationToken));
        if (rows == 0)
        {
            return null;
        }

        return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(command.OrganizzazioneId), connectionFactory, cancellationToken);
    }
}
