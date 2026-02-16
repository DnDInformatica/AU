namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Contratti;

internal static class Validator
{
    public static Dictionary<string, string[]> Validate(ContrattoCreateRequest request)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.Ordinal);

        if (request.TipoContrattoId <= 0)
        {
            errors["tipoContrattoId"] = ["TipoContrattoId non valido."];
        }

        if (request.DataFine.HasValue && request.DataFine.Value < request.DataInizio)
        {
            errors["dataFine"] = ["DataFine non puo essere antecedente a DataInizio."];
        }

        return errors;
    }

    public static Dictionary<string, string[]> Validate(ContrattoUpdateRequest request)
        => Validate(new ContrattoCreateRequest(
            request.TipoContrattoId,
            request.DataInizio,
            request.DataFine,
            request.LivelloInquadramento,
            request.CCNLApplicato,
            request.RAL,
            request.PercentualePartTime,
            request.OreLavoroSettimanali,
            request.IsContrattoCorrente,
            request.Note));
}

