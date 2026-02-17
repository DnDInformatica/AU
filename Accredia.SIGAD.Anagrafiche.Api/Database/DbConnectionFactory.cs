using Microsoft.Data.SqlClient;

namespace Accredia.SIGAD.Anagrafiche.Api.Database;

internal interface IDbConnectionFactory
{
    Task<SqlConnection> CreateOpenConnectionAsync(CancellationToken cancellationToken);
}

internal sealed class SqlConnectionFactory : IDbConnectionFactory
{
    private const string ConnectionStringName = "AnagraficheDb";
    private readonly string _connectionString;
    private readonly ILogger<SqlConnectionFactory> _logger;
    private readonly bool _isDevelopment;

    public SqlConnectionFactory(
        IConfiguration configuration,
        IHostEnvironment environment,
        ILogger<SqlConnectionFactory> logger)
    {
        _logger = logger;
        _isDevelopment = environment.IsDevelopment();
        var rawConnectionString = configuration.GetConnectionString(ConnectionStringName)
            ?? throw new InvalidOperationException($"Missing connection string '{ConnectionStringName}'.");

        // In Development we enforce local SQL settings that avoid TLS pre-login handshake failures.
        // This keeps local runs deterministic even when machine-level SQL client defaults change.
        if (_isDevelopment)
        {
            var builder = new SqlConnectionStringBuilder(rawConnectionString)
            {
                Encrypt = false,
                TrustServerCertificate = true
            };

            _connectionString = builder.ConnectionString;
            return;
        }

        _connectionString = rawConnectionString;
    }

    public async Task<SqlConnection> CreateOpenConnectionAsync(CancellationToken cancellationToken)
    {
        var builder = new SqlConnectionStringBuilder(_connectionString);
        _logger.LogInformation(
            "Opening SQL connection DataSource={DataSource} InitialCatalog={InitialCatalog} Encrypt={Encrypt} TrustServerCertificate={TrustServerCertificate} IntegratedSecurity={IntegratedSecurity} Authentication={Authentication} Dev={Development}",
            builder.DataSource,
            builder.InitialCatalog,
            builder.Encrypt,
            builder.TrustServerCertificate,
            builder.IntegratedSecurity,
            builder.Authentication,
            _isDevelopment);

        var connection = new SqlConnection(builder.ConnectionString);
        await connection.OpenAsync(cancellationToken);
        return connection;
    }
}
