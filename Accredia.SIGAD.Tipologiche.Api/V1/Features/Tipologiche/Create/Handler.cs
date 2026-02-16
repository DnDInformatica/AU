using Dapper;
using Microsoft.Data.SqlClient;
using Accredia.SIGAD.Tipologiche.Api.Database;
using Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.Create;

internal static class Handler
{
    private const string Sql = """
        INSERT INTO [Tipologiche].[TipoVoceTipologica] ([Code], [Description], [IsActive], [Ordine])
        VALUES (@Code, @Description, @IsActive, @Ordine);
        SELECT CAST(SCOPE_IDENTITY() AS int);
        """;

    public static async Task<IResult> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        try
        {
            await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
            var id = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(Sql, command, cancellationToken: cancellationToken));

            var response = new CreateResponse(id, command.Code, command.Description, command.IsActive, command.Ordine);
            return Results.Created($"/{ApiVersioning.DefaultVersion}/tipologiche/{id}", response);
        }
        catch (SqlException ex) when (ex.Number is 2601 or 2627)
        {
            return Results.Conflict(new ErrorResponse("DuplicateCode", "A tipologica with the same code already exists."));
        }
    }
}
