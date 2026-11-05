namespace Accredia.SIGAD.Anagrafiche.Api.Services.Monitoring;

internal sealed class DocumentStorageMonitoringOptions
{
    public const string SectionName = "DocumentStorage:Monitoring";

    public bool Enabled { get; set; } = true;
    public int ProbeIntervalSeconds { get; set; } = 60;
    public int FailureThreshold { get; set; } = 3;
}
