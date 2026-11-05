CREATE FUNCTION Organizzazioni.fn_EsitoVerificaAttEcoCodice (@EsitoVerificaAttivitaEconomicaId INT)
RETURNS NVARCHAR(50)
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @c NVARCHAR(50);
    SELECT @c = Codice FROM Tipologica.EsitoVerificaAttivitaEconomica
     WHERE EsitoVerificaAttivitaEconomicaId = @EsitoVerificaAttivitaEconomicaId;
    RETURN @c;
END

GO

