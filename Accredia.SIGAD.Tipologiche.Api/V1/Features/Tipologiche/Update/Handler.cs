using Dapper;
using Microsoft.Data.SqlClient;
using Accredia.SIGAD.Tipologiche.Api.Database;
using Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.Update;

internal static class Handler
{
    private const string Sql = """
        UPDATE [Tipologiche].[TipoVoceTipologica]
        SET [Code] = @Code,
            [Description] = @Description,
            [IsActive] = @IsActive,
            [Ordine] = @Ordine
        WHERE [Id] = @Id;
        """;

    public static async Task<IResult> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        try
        {
            await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
            var affected = await connection.ExecuteAsync(
                new CommandDefinition(Sql, command, cancellationToken: cancellationToken));

            if (affected == 0)
            {
                return Results.NotFound();
            }

            var response = new UpdateResponse(command.Id, command.Code, command.Description, command.IsActive, command.Ordine);
            return Results.Ok(response);
        }
        catch (SqlException ex) when (ex.Number is 2601 or 2627)
        {
            return Results.Conflict(new ErrorResponse("DuplicateCode", "A tipologica with the same code already exists."));
        }
    }
}
