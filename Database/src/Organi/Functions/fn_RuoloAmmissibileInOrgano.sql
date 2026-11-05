CREATE FUNCTION Organi.fn_RuoloAmmissibileInOrgano (@TipoRuoloPartecipazioneEventoId INT)
RETURNS BIT
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @Cat NVARCHAR(30);
    SELECT @Cat = Categoria FROM Tipologica.TipoRuoloPartecipazioneEvento
     WHERE TipoRuoloPartecipazioneEventoId = @TipoRuoloPartecipazioneEventoId;
    RETURN CASE WHEN @Cat IN ('DELIBERANTE','SUPPORTO') THEN 1 ELSE 0 END;
END

GO

