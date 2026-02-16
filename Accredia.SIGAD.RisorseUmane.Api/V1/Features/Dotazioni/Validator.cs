namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Dotazioni;

internal static class Validator
{
    public static Dictionary<string, string[]> Validate(DotazioneCreateRequest request)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.Ordinal);

        if (request.TipoDotazioneId <= 0)
        {
            errors["tipoDotazioneId"] = ["TipoDotazioneId non valido."];
        }

        if (string.IsNullOrWhiteSpace(request.Descrizione))
        {
            errors["descrizione"] = ["Descrizione obbligatoria."];
        }

        if (request.DataRestituzione.HasValue && request.DataRestituzione.Value < request.DataAssegnazione)
        {
            errors["dataRestituzione"] = ["DataRestituzione non puo essere antecedente a DataAssegnazione."];
        }

        return errors;
    }

    public static Dictionary<string, string[]> Validate(DotazioneUpdateRequest request)
        => Validate(new DotazioneCreateRequest(
            request.TipoDotazioneId,
            request.Descrizione,
            request.NumeroInventario,
            request.NumeroSerie,
            request.DataAssegnazione,
            request.DataRestituzione,
            request.IsRestituito,
            request.Note));
}

