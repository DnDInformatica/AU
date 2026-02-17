namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Dipendenti;

internal static class Validator
{
    public static Dictionary<string, string[]> Validate(DipendenteCreateRequest request)
    {
        var errors = new Dictionary<string, string[]>(StringComparer.Ordinal);

        if (request.PersonaId <= 0)
        {
            errors["personaId"] = ["PersonaId non valido."];
        }

        if (string.IsNullOrWhiteSpace(request.Matricola))
        {
            errors["matricola"] = ["Matricola obbligatoria."];
        }
        else if (request.Matricola.Trim().Length > 20)
        {
            errors["matricola"] = ["Matricola non puo superare 20 caratteri."];
        }

        if (!string.IsNullOrWhiteSpace(request.EmailAziendale) && request.EmailAziendale.Trim().Length > 100)
        {
            errors["emailAziendale"] = ["EmailAziendale non puo superare 100 caratteri."];
        }

        if (!string.IsNullOrWhiteSpace(request.TelefonoInterno) && request.TelefonoInterno.Trim().Length > 10)
        {
            errors["telefonoInterno"] = ["TelefonoInterno non puo superare 10 caratteri."];
        }

        if (request.DataCessazione.HasValue && request.DataCessazione.Value < request.DataAssunzione)
        {
            errors["dataCessazione"] = ["DataCessazione non puo essere antecedente a DataAssunzione."];
        }

        if (request.StatoDipendenteId <= 0)
        {
            errors["statoDipendenteId"] = ["StatoDipendenteId non valido."];
        }

        return errors;
    }

    public static Dictionary<string, string[]> Validate(DipendenteUpdateRequest request)
        => Validate(new DipendenteCreateRequest(
            request.PersonaId,
            request.Matricola,
            request.EmailAziendale,
            request.TelefonoInterno,
            request.UnitaOrganizzativaId,
            request.ResponsabileDirettoId,
            request.DataAssunzione,
            request.DataCessazione,
            request.StatoDipendenteId,
            request.AbilitatoAttivitaIspettiva,
            request.Note));
}
