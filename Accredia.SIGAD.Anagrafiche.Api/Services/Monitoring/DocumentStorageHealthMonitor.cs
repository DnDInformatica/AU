using Accredia.SIGAD.Anagrafiche.Api.Services.DocumentStorage;
using Microsoft.Extensions.Options;

namespace Accredia.SIGAD.Anagrafiche.Api.Services.Monitoring;

internal sealed class DocumentStorageHealthMonitor : BackgroundService
{
    private readonly IPersonaDocumentStorage _storage;
    private readonly IOptionsMonitor<DocumentStorageMonitoringOptions> _options;
    private readonly IOptions<PersonaDocumentStorageOptions> _storageOptions;
    private readonly ILogger<DocumentStorageHealthMonitor> _logger;

    public DocumentStorageHealthMonitor(
        IPersonaDocumentStorage storage,
        IOptionsMonitor<DocumentStorageMonitoringOptions> options,
        IOptions<PersonaDocumentStorageOptions> storageOptions,
        ILogger<DocumentStorageHealthMonitor> logger)
    {
        _storage = storage;
        _options = options;
        _storageOptions = storageOptions;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var provider = _storageOptions.Value.Provider;
        var consecutiveFailures = 0;
        var alertActive = false;

        while (!stoppingToken.IsCancellationRequested)
        {
            var config = _options.CurrentValue;
            if (!config.Enabled)
            {
                await Task.Delay(TimeSpan.FromSeconds(15), stoppingToken);
                continue;
            }

            var (isHealthy, detail) = await _storage.CheckAvailabilityAsync(stoppingToken);
            if (isHealthy)
            {
                if (alertActive)
                {
                    _logger.LogInformation(
                        "RECOVERY: Document storage health restored. Provider={Provider}, PreviousConsecutiveFailures={FailureCount}",
                        provider,
                        consecutiveFailures);
                }

                consecutiveFailures = 0;
                alertActive = false;
            }
            else
            {
                consecutiveFailures++;
                if (!alertActive && consecutiveFailures >= Math.Max(1, config.FailureThreshold))
                {
                    alertActive = true;
                    _logger.LogError(
                        "ALERT: Document storage unhealthy. Provider={Provider}, ConsecutiveFailures={FailureCount}, Detail={Detail}",
                        provider,
                        consecutiveFailures,
                        detail ?? "n/a");
                }
            }

            await Task.Delay(TimeSpan.FromSeconds(Math.Max(5, config.ProbeIntervalSeconds)), stoppingToken);
        }
    }
}
