using Microsoft.Extensions.Localization;
using MudBlazor;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Testi italiani dei componenti MudBlazor (paginatori, filtri e menu delle
/// tabelle, chiusure, selettori di data). Senza questa classe la libreria
/// mostrava "Rows per page", "1-13 of 13", "Add filter" in pagine altrimenti
/// tutte in italiano.
/// Le chiavi sono quelle della risorsa LanguageResource di MudBlazor 8.15;
/// una chiave assente qui ricade sul testo inglese della libreria.
/// Copia del Portale Accredia (Accredia.Portal.Web/Services/MudLocalizerItaliano.cs).
/// </summary>
public sealed class MudLocalizerItaliano : MudLocalizer
{
    private static readonly IReadOnlyDictionary<string, string> Testi = new Dictionary<string, string>
    {
        ["Converter_ConversionError"] = "Errore di conversione: {0}",
        ["Converter_ConversionFailed"] = "Conversione da {0} a {1} non riuscita: {2}",
        ["Converter_InvalidBoolean"] = "Valore booleano non valido",
        ["Converter_InvalidDateTime"] = "Data e ora non valide",
        ["Converter_InvalidGUID"] = "Identificativo non valido",
        ["Converter_InvalidNumber"] = "Numero non valido",
        ["Converter_InvalidTimeSpan"] = "Intervallo di tempo non valido",
        ["Converter_InvalidType"] = "{0} non valido",

        ["MudAlert_Close"] = "Chiudi",
        ["MudChip_Close"] = "Rimuovi",
        ["MudDialog_Close"] = "Chiudi",
        ["MudSnackbar_Close"] = "Chiudi",
        ["MudInput_Clear"] = "Cancella",
        ["MudInput_Decrement"] = "Diminuisci",
        ["MudInput_Increment"] = "Aumenta",
        ["MudNavGroup_ToggleExpand"] = "Apri o chiudi {0}",
        ["MudTreeView_CollapseItem"] = "Comprimi",
        ["MudTreeView_ExpandItem"] = "Espandi",
        ["MudFileUpload_FileSizeError"] = "Il file '{0}' supera la dimensione massima consentita di {1} byte.",

        ["MudBaseDatePicker_NextMonth"] = "Mese successivo {0}",
        ["MudBaseDatePicker_NextYear"] = "Anno successivo {0}",
        ["MudBaseDatePicker_Open"] = "Apri calendario",
        ["MudBaseDatePicker_PrevMonth"] = "Mese precedente {0}",
        ["MudBaseDatePicker_PrevYear"] = "Anno precedente {0}",
        ["MudTimePicker_Open"] = "Apri selettore orario",

        ["MudDataGrid_AddFilter"] = "Aggiungi filtro",
        ["MudDataGrid_Apply"] = "Applica",
        ["MudDataGrid_Cancel"] = "Annulla",
        ["MudDataGrid_Clear"] = "Cancella",
        ["MudDataGrid_ClearFilter"] = "Rimuovi filtro",
        ["MudDataGrid_CollapseAllGroups"] = "Comprimi tutti i gruppi",
        ["MudDataGrid_Column"] = "Colonna",
        ["MudDataGrid_Columns"] = "Colonne",
        ["MudDataGrid_Contains"] = "contiene",
        ["MudDataGrid_EndsWith"] = "termina con",
        ["MudDataGrid_Equals"] = "uguale a",
        ["MudDataGrid_ExpandAllGroups"] = "Espandi tutti i gruppi",
        ["MudDataGrid_False"] = "falso",
        ["MudDataGrid_Filter"] = "Filtra",
        ["MudDataGrid_FilterValue"] = "Valore del filtro",
        ["MudDataGrid_Group"] = "Raggruppa",
        ["MudDataGrid_Hide"] = "Nascondi",
        ["MudDataGrid_HideAll"] = "Nascondi tutte",
        ["MudDataGrid_Is"] = "è",
        ["MudDataGrid_IsAfter"] = "è dopo il",
        ["MudDataGrid_IsBefore"] = "è prima del",
        ["MudDataGrid_IsEmpty"] = "è vuoto",
        ["MudDataGrid_IsNot"] = "non è",
        ["MudDataGrid_IsNotEmpty"] = "non è vuoto",
        ["MudDataGrid_IsOnOrAfter"] = "è dal",
        ["MudDataGrid_IsOnOrBefore"] = "è fino al",
        ["MudDataGrid_Loading"] = "Caricamento...",
        ["MudDataGrid_MoveDown"] = "Sposta giù",
        ["MudDataGrid_MoveUp"] = "Sposta su",
        ["MudDataGrid_NotContains"] = "non contiene",
        ["MudDataGrid_NotEquals"] = "diverso da",
        ["MudDataGrid_OpenFilters"] = "Apri filtri",
        ["MudDataGrid_Operator"] = "Operatore",
        ["MudDataGrid_RefreshData"] = "Aggiorna dati",
        ["MudDataGrid_RemoveFilter"] = "Rimuovi filtro",
        ["MudDataGrid_Save"] = "Salva",
        ["MudDataGrid_ShowAll"] = "Mostra tutte",
        ["MudDataGrid_ShowColumnOptions"] = "Opzioni colonna",
        ["MudDataGrid_Sort"] = "Ordina",
        ["MudDataGrid_StartsWith"] = "inizia con",
        ["MudDataGrid_ToggleGroupExpansion"] = "Apri o chiudi gruppo",
        ["MudDataGrid_True"] = "vero",
        ["MudDataGrid_Ungroup"] = "Separa",
        ["MudDataGrid_Unsort"] = "Rimuovi ordinamento",
        ["MudDataGrid_Value"] = "Valore",

        ["MudDataGridPager_AllItems"] = "Tutte",
        ["MudDataGridPager_FirstPage"] = "Prima pagina",
        ["MudDataGridPager_InfoFormat"] = "{0}-{1} di {2}",
        ["MudDataGridPager_LastPage"] = "Ultima pagina",
        ["MudDataGridPager_NextPage"] = "Pagina successiva",
        ["MudDataGridPager_PreviousPage"] = "Pagina precedente",
        ["MudDataGridPager_RowsPerPage"] = "Righe per pagina:",

        ["MudTablePager_FirstPage"] = "Prima pagina",
        ["MudTablePager_LastPage"] = "Ultima pagina",
        ["MudTablePager_NextPage"] = "Pagina successiva",
        ["MudTablePager_PreviousPage"] = "Pagina precedente",

        ["MudPagination_CurrentPage"] = "Pagina corrente {0}",
        ["MudPagination_FirstPage"] = "Prima pagina",
        ["MudPagination_LastPage"] = "Ultima pagina",
        ["MudPagination_NextPage"] = "Pagina successiva",
        ["MudPagination_PageIndex"] = "Pagina {0}",
        ["MudPagination_PreviousPage"] = "Pagina precedente",

        ["MudStepper_Complete"] = "Completa",
        ["MudStepper_Next"] = "Avanti",
        ["MudStepper_Previous"] = "Indietro",
        ["MudStepper_Reset"] = "Ricomincia",
        ["MudStepper_Skip"] = "Salta",
    };

    public override LocalizedString this[string key]
        => Testi.TryGetValue(key, out var testo)
            ? new LocalizedString(key, testo)
            : new LocalizedString(key, key, resourceNotFound: true);
}
