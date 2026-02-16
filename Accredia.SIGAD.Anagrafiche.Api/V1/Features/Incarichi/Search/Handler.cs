using System.Text.RegularExpressions;
using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.Search;

internal static class Handler
{
    public static async Task<PagedResponse<IncaricoSearchItem>> Handle(
        Query query,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(query);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var trimmed = query.Q.Trim();
        var isPiva = Regex.IsMatch(trimmed, @"^\d{11}$");
        var isCf = Regex.IsMatch(trimmed, @"^[A-Za-z0-9]{16}$");
        var offset = (query.Page - 1) * query.PageSize;

        const string baseWhere = @"
i.DataCancellazione IS NULL
AND i.DataInizioValidita <= SYSUTCDATETIME()
AND i.DataFineValidita >= SYSUTCDATETIME()";

        string filterSql;
        object parameters;

        if (isCf)
        {
            filterSql = "p.CodiceFiscale = @Query";
            parameters = new { Query = trimmed, Offset = offset, PageSize = query.PageSize };
        }
        else if (isPiva)
        {
            filterSql = "o.PartitaIVA = @Query OR ou.PartitaIVA = @Query";
            parameters = new { Query = trimmed, Offset = offset, PageSize = query.PageSize };
        }
        else
        {
            filterSql = @"
p.Cognome LIKE @Like
OR p.Nome LIKE @Like
OR CONCAT(p.Cognome, ' ', p.Nome) LIKE @Like
OR o.Denominazione LIKE @Like
OR o.RagioneSociale LIKE @Like
OR ou.Denominazione LIKE @Like
OR ou.RagioneSociale LIKE @Like
OR tr.Descrizione LIKE @Like
OR i.StatoIncarico LIKE @Like";
            parameters = new { Like = $"%{trimmed}%", Offset = offset, PageSize = query.PageSize };
        }

        var whereSql = $"{baseWhere} AND ({filterSql})";

        var countSql = $@"
SELECT COUNT(1)
FROM [Organizzazioni].[Incarico] i
LEFT JOIN [Persone].[Persona] p ON p.PersonaId = i.PersonaId
LEFT JOIN [Organizzazioni].[Organizzazione] o ON o.OrganizzazioneId = i.OrganizzazioneId
LEFT JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
LEFT JOIN [Organizzazioni].[Organizzazione] ou ON ou.OrganizzazioneId = u.OrganizzazioneId
LEFT JOIN [Tipologica].[TipoRuolo] tr ON tr.TipoRuoloId = i.TipoRuoloId
WHERE {whereSql};";

        var listSql = $@"
SELECT
    i.IncaricoId,
    i.PersonaId,
    p.Cognome AS PersonaCognome,
    p.Nome AS PersonaNome,
    COALESCE(i.OrganizzazioneId, u.OrganizzazioneId) AS OrganizzazioneId,
    COALESCE(o.Denominazione, ou.Denominazione) AS OrganizzazioneDenominazione,
    COALESCE(tr.Descrizione, CAST(i.TipoRuoloId AS nvarchar(50))) AS Ruolo,
    i.StatoIncarico,
    i.DataInizio,
    i.DataFine
FROM [Organizzazioni].[Incarico] i
LEFT JOIN [Persone].[Persona] p ON p.PersonaId = i.PersonaId
LEFT JOIN [Organizzazioni].[Organizzazione] o ON o.OrganizzazioneId = i.OrganizzazioneId
LEFT JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
LEFT JOIN [Organizzazioni].[Organizzazione] ou ON ou.OrganizzazioneId = u.OrganizzazioneId
LEFT JOIN [Tipologica].[TipoRuolo] tr ON tr.TipoRuoloId = i.TipoRuoloId
WHERE {whereSql}
ORDER BY i.DataInizio DESC
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var totalCount = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(countSql, parameters, cancellationToken: cancellationToken));

        var items = (await connection.QueryAsync<IncaricoSearchItem>(
            new CommandDefinition(listSql, parameters, cancellationToken: cancellationToken)))
            .ToList();

        return new PagedResponse<IncaricoSearchItem>(items, query.Page, query.PageSize, totalCount);
    }
}
