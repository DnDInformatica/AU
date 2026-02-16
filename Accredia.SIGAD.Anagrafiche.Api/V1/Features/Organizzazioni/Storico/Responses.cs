namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Storico;

internal sealed record RelazioniStoricoResponse(
    IReadOnlyList<OrganizzazioneTipoOrganizzazioneStoricoDto> OrganizzazioneTipologie,
    IReadOnlyList<OrganizzazioneSedeStoricoDto> OrganizzazioneSedi,
    IReadOnlyList<UnitaRelazioneStoricoDto> UnitaRelazioni,
    IReadOnlyList<UnitaFunzioneStoricoDto> UnitaFunzioni,
    IReadOnlyList<SedeUnitaStoricoDto> SediUnita,
    IReadOnlyList<GruppoIvaStoricoDto> GruppiIva,
    IReadOnlyList<GruppoIvaMembroStoricoDto> GruppiIvaMembri);

internal sealed record AttributiStoricoResponse(
    IReadOnlyList<OrganizzazioneIdentificativoFiscaleStoricoDto> IdentificativiFiscali,
    IReadOnlyList<ContattoUnitaStoricoDto> ContattiUnita,
    IReadOnlyList<IndirizzoUnitaStoricoDto> IndirizziUnita,
    IReadOnlyList<CompetenzaStoricoDto> Competenze,
    IReadOnlyList<PotereStoricoDto> Poteri,
    IReadOnlyList<UnitaAttivitaStoricoDto> UnitaAttivita);
