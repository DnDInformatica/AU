CREATE FUNCTION Eventi.fn_RuoloPartecipazioneAmmetteDelega (@TipoRuoloPartecipazioneEventoId INT)
RETURNS BIT
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @Ammette BIT;
    SELECT @Ammette = AmmetteDelega
      FROM Tipologica.TipoRuoloPartecipazioneEvento
     WHERE TipoRuoloPartecipazioneEventoId = @TipoRuoloPartecipazioneEventoId;
    RETURN ISNULL(@Ammette, 0);
END

GO

