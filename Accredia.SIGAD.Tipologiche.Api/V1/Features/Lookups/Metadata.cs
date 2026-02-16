namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Lookups;

internal sealed record LookupTableMetadata(
    string Schema,
    string Table,
    string PrimaryKeyColumn,
    string? CodeColumn,
    string DescriptionColumn,
    string? IsActiveColumn,
    string? OrdineColumn,
    string? DataCancellazioneColumn);

