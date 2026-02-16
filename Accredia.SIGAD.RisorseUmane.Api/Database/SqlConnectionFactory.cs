using Microsoft.Data.SqlClient;

namespace Accredia.SIGAD.RisorseUmane.Api.Database;

internal interface ISqlConnectionFactory
{
    Task<SqlConnection> CreateOpenConnectionAsync(CancellationToken cancellationToken);
}

internal sealed class SqlConnectionFactory(IConfiguration configuration) : ISqlConnectionFactory
{
    private readonly string _connectionString = configuration.GetConnectionString("RisorseUmaneDb")
        ?? throw new InvalidOperationException("Missing connection string 'RisorseUmaneDb'.");

    public async Task<SqlConnection> CreateOpenConnectionAsync(CancellationToken cancellationToken)
    {
        var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync(cancellationToken);
        return connection;
    }
}

