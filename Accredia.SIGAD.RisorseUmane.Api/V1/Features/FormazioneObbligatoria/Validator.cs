namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.FormazioneObbligatoria;

internal static class Validator
{
    public static Dictionary<string, string[]> Validate(FormazioneObbligatoriaCreateRequest request)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.Ordinal);

        if (request.TipoFormazioneObbligatoriaId <= 0)
        {
            errors["tipoFormazioneObbligatoriaId"] = ["TipoFormazioneObbligatoriaId non valido."];
        }

        if (request.DataScadenza.HasValue && request.DataScadenza.Value < request.DataCompletamento)
        {
            errors["dataScadenza"] = ["DataScadenza non puo essere antecedente a DataCompletamento."];
        }

        if (request.DurataOreCorso is < 0)
        {
            errors["durataOreCorso"] = ["DurataOreCorso non valida."];
        }

        return errors;
    }

    public static Dictionary<string, string[]> Validate(FormazioneObbligatoriaUpdateRequest request)
        => Validate(new FormazioneObbligatoriaCreateRequest(
            request.TipoFormazioneObbligatoriaId,
            request.DataCompletamento,
            request.DataScadenza,
            request.EstremiAttestato,
            request.EnteFormatore,
            request.DurataOreCorso,
            request.Note));
}

