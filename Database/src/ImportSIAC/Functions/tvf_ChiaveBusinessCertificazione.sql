
CREATE   FUNCTION ImportSIAC.tvf_ChiaveBusinessCertificazione
(
    @Dominio nvarchar(3),
    @NumeroCertificato nvarchar(200),
    @OrganizzazioneODCId int,
    @DataPrimoRilascio date,
    @FiscalCode nvarchar(100),
    @PersonCode nvarchar(150),
    @Nome nvarchar(400),
    @Cognome nvarchar(400),
    @DataNascita date,
    @LuogoNascita nvarchar(400),
    @ProfiloProfessionaleCodice nvarchar(4000)
)
RETURNS TABLE
AS
RETURN
(
    WITH Normalizzati AS
    (
        SELECT
            UPPER(LTRIM(RTRIM(COALESCE(@Dominio, N'')))) AS Dominio,
            UPPER(LTRIM(RTRIM(COALESCE(@NumeroCertificato, N'')))) AS Numero,
            UPPER(LTRIM(RTRIM(COALESCE(@FiscalCode, N'')))) AS CF,
            UPPER(LTRIM(RTRIM(COALESCE(@PersonCode, N'')))) AS CodicePersona,
            UPPER(LTRIM(RTRIM(COALESCE(@Nome, N'')))) AS Nome,
            UPPER(LTRIM(RTRIM(COALESCE(@Cognome, N'')))) AS Cognome,
            UPPER(LTRIM(RTRIM(COALESCE(@LuogoNascita, N'')))) AS LuogoNascita,
            UPPER
            (
                LTRIM
                (
                    RTRIM
                    (
                        COALESCE(@ProfiloProfessionaleCodice, N'')
                    )
                )
            ) AS Profilo
    ),
    Identita AS
    (
        SELECT
            n.*,
            CASE
                WHEN n.Dominio <> N'FPC' THEN N'-'
                WHEN LEN(n.CF) = 16 THEN N'CF:' + n.CF
                WHEN n.CodicePersona <> N'' THEN N'PC:' + n.CodicePersona
                ELSE
                    CONCAT
                    (
                        N'NK:C', LEN(n.Cognome), N':', n.Cognome,
                        N'|N', LEN(n.Nome), N':', n.Nome,
                        N'|D', COALESCE(CONVERT(nvarchar(10), @DataNascita, 23), N''),
                        N'|L', LEN(n.LuogoNascita), N':', n.LuogoNascita
                    )
            END AS IdentitaPersona,
            CASE WHEN n.Dominio = N'FPC' THEN n.Profilo ELSE N'-' END
                AS ProfiloBusiness
        FROM Normalizzati AS n
    )
    SELECT
        CONVERT
        (
            binary(32),
            HASHBYTES
            (
                'SHA2_256',
                CONVERT
                (
                    varbinary(max),
                    CONCAT
                    (
                        N'D', LEN(i.Dominio), N':', i.Dominio,
                        N'|C', LEN(i.Numero), N':', i.Numero,
                        N'|O', COALESCE(CONVERT(nvarchar(20), @OrganizzazioneODCId), N''),
                        N'|R',
                        CASE
                            WHEN i.Dominio = N'FPC' THEN N'-'
                            ELSE COALESCE(CONVERT(nvarchar(10), @DataPrimoRilascio, 23), N'')
                        END,
                        N'|P', LEN(i.IdentitaPersona), N':', i.IdentitaPersona,
                        N'|F', LEN(i.ProfiloBusiness), N':', i.ProfiloBusiness
                    )
                )
            )
        ) AS ChiaveBusinessHash
    FROM Identita AS i
);

GO

