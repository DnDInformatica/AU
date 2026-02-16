namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Mappings;

internal sealed record MappingCategoriaSedeDto(
    int MappingId,
    string CategoriaOrigine,
    int TipoUnitaOrganizzativaId,
    int TipoSedeId,
    bool Principale,
    bool Escludere,
    string? Note);

internal sealed record MappingTipoSedeIndirizzoDto(
    int MappingId,
    string TipoSedeOrigine,
    int TipoIndirizzoId,
    bool Principale,
    string? Note);

