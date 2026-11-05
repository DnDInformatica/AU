
CREATE   VIEW Standard.vw_ControlloConformitaCatalogoClassificazioni
AS
    SELECT Anomalia, Id, Dettaglio
    FROM Standard.vw_ControlloConformitaClassificazioni

    UNION ALL

    SELECT Anomalia, Id, Dettaglio
    FROM Standard.vw_ControlloConformitaGerarchieClassificazione

    UNION ALL

    SELECT Anomalia, Id, Dettaglio
    FROM Standard.vw_ControlloConformitaCorrispondenzeClassificazione

    UNION ALL

    SELECT Anomalia, Id, Dettaglio
    FROM Standard.vw_ControlloCoperturaCorrispondenzeClassificazione

    UNION ALL

    SELECT Anomalia, Id, Dettaglio
    FROM Standard.vw_ControlloConformitaDominiApplicabilita

    UNION ALL

    SELECT Anomalia, Id, Dettaglio
    FROM Standard.vw_ControlloConformitaAttivitaEconomiche

    UNION ALL

    SELECT Anomalia, Id, Dettaglio
    FROM Standard.vw_ControlloConformitaPercorsiClassificazione;

GO

