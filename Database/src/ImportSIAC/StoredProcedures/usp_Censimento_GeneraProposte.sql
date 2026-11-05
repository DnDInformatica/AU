CREATE   PROCEDURE ImportSIAC.usp_Censimento_GeneraProposte
    @BatchId       UNIQUEIDENTIFIER = NULL OUTPUT,
    @RigheGenerate INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @BatchId = COALESCE(@BatchId, NEWID());
    SET @RigheGenerate = 0;

    DROP TABLE IF EXISTS #FpcLookup;
    DROP TABLE IF EXISTS #FpcLog;
    DROP TABLE IF EXISTS #PpNorme;
    DROP TABLE IF EXISTS #Irrisolte;

    -- Ogni external table viene letta una sola volta e materializzata localmente.
    SELECT Code, DescriptionIt, DescriptionEn, LawRegulationItJson, LawRegulationEnJson
    INTO #FpcLookup
    FROM ImportSIAC.Ext_FPC_NormLookupRaw;
    CREATE UNIQUE CLUSTERED INDEX CX_FpcLookup ON #FpcLookup (Code);

    SELECT Code, DescriptionIt, DescriptionEn, LawRegulationItJson, LawRegulationEnJson
    INTO #FpcLog
    FROM (
        SELECT Code, DescriptionIt, DescriptionEn, LawRegulationItJson, LawRegulationEnJson,
               ROW_NUMBER() OVER (
                   PARTITION BY Code ORDER BY DateLog DESC, IdLog DESC
               ) AS rn
        FROM ImportSIAC.Ext_FPC_NormLookupLogRaw
        WHERE Code IS NOT NULL
    ) src
    WHERE rn = 1;
    CREATE UNIQUE CLUSTERED INDEX CX_FpcLog ON #FpcLog (Code);

    SELECT Norma, TitoloIta, TitoloIng
    INTO #PpNorme
    FROM (
        SELECT Norma, TitoloIta, TitoloIng,
               ROW_NUMBER() OVER (
                   PARTITION BY Norma
                   ORDER BY IdRelease DESC, TitoloIta DESC, TitoloIng DESC
               ) AS rn
        FROM ImportSIAC.Ext_PP_NormeCertRaw
        WHERE Norma IS NOT NULL
    ) src
    WHERE rn = 1;
    CREATE UNIQUE CLUSTERED INDEX CX_PpNorme ON #PpNorme (Norma);

    SELECT DISTINCT wm.norma_raw AS SourceValue
    INTO #Irrisolte
    FROM ImportSIAC.wrk_NormaMap wm
    WHERE wm.NormaAccreditamentoId IS NULL
      AND wm.norma_raw IS NOT NULL
      AND LTRIM(RTRIM(wm.norma_raw)) <> N''
      AND NOT EXISTS (
          SELECT 1
          FROM ImportSIAC.NormaCensimentoProposta p
          WHERE p.SourceValue = wm.norma_raw
            AND p.Stato <> N'RIFIUTATA'
      );
    CREATE UNIQUE CLUSTERED INDEX CX_Irrisolte ON #Irrisolte (SourceValue);

    DECLARE
        @SourceValue NVARCHAR(400),
        @Azione NVARCHAR(20),
        @TargetEsistenteId INT,
        @Categoria NVARCHAR(20),
        @FonteLookup NVARCHAR(60),
        @DescIt NVARCHAR(1000),
        @DescEn NVARCHAR(1000),
        @LawItJson NVARCHAR(MAX),
        @LawEnJson NVARCHAR(MAX),
        @PrimoRifNormativo NVARCHAR(1000),
        @Riferimento NVARCHAR(200),
        @Codice NVARCHAR(100),
        @CodicePreferito NVARCHAR(400),
        @CodiceVersione NVARCHAR(20),
        @TipoNorma NVARCHAR(30),
        @CategoriaFonte NVARCHAR(30),
        @StatoNormaId INT,
        @GerarchiaFiglioId INT,
        @TipoRelazioneId INT,
        @Note NVARCHAR(2000),
        @Base NVARCHAR(400),
        @Candidati INT,
        @SoloId INT,
        @Suffix NVARCHAR(20),
        @Hash NVARCHAR(8);

    DECLARE proposta_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT SourceValue FROM #Irrisolte ORDER BY SourceValue;

    OPEN proposta_cursor;
    FETCH NEXT FROM proposta_cursor INTO @SourceValue;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT
            @Categoria = NULL,
            @Azione = N'CENSISCI_NUOVA',
            @TargetEsistenteId = NULL,
            @FonteLookup = NULL,
            @DescIt = NULL,
            @DescEn = NULL,
            @LawItJson = NULL,
            @LawEnJson = NULL,
            @PrimoRifNormativo = NULL,
            @Riferimento = NULL,
            @Codice = NULL,
            @CodicePreferito = NULL,
            @CodiceVersione = NULL,
            @TipoNorma = N'SchemaCertificazione',
            @CategoriaFonte = NULL,
            @StatoNormaId = NULL,
            @GerarchiaFiglioId = NULL,
            @TipoRelazioneId = NULL,
            @Note = NULL,
            @Base = NULL,
            @Candidati = NULL,
            @SoloId = NULL,
            @Suffix = NULL,
            @Hash = NULL;

        IF @SourceValue LIKE N'04.%'
        BEGIN
            SELECT
                @DescIt = DescriptionIt,
                @DescEn = DescriptionEn,
                @LawItJson = LawRegulationItJson,
                @LawEnJson = LawRegulationEnJson
            FROM #FpcLookup
            WHERE Code = @SourceValue;

            IF @@ROWCOUNT > 0
            BEGIN
                SET @Categoria = N'FPC-CORRENTE';
                SET @FonteLookup = N'FPC.NormLookupRaw';
                SET @CodiceVersione = N'LOOKUP-FPC';
                SET @StatoNormaId = 1;
            END
            ELSE
            BEGIN
                SELECT
                    @DescIt = DescriptionIt,
                    @DescEn = DescriptionEn,
                    @LawItJson = LawRegulationItJson,
                    @LawEnJson = LawRegulationEnJson
                FROM #FpcLog
                WHERE Code = @SourceValue;

                IF @@ROWCOUNT > 0
                BEGIN
                    SET @Categoria = N'FPC-STORICA';
                    SET @FonteLookup = N'FPC.NormLookupLogRaw';
                    SET @CodiceVersione = N'LOOKUP-FPC-LOG';
                    SET @StatoNormaId = 3;
                END;
            END;

            IF @Categoria IS NOT NULL
            BEGIN
                SELECT TOP (1) @PrimoRifNormativo = LTRIM(RTRIM([value]))
                FROM OPENJSON(@LawItJson)
                WHERE LTRIM(RTRIM([value])) <> N''
                ORDER BY CONVERT(INT, [key]);

                SET @Riferimento = LEFT(CONCAT(N'FPC-', @SourceValue), 200);
                SET @CodicePreferito = @SourceValue;

                IF @PrimoRifNormativo IS NOT NULL AND @DescIt IS NOT NULL
                BEGIN
                    DECLARE @CandidatoFpc NVARCHAR(2000) =
                        CONCAT(@PrimoRifNormativo, N' (', @DescIt, N')');

                    IF LEN(@CandidatoFpc) <= 100
                       AND NOT EXISTS (
                           SELECT 1 FROM Standard.NormaAccreditamento
                           WHERE Codice = @CandidatoFpc
                       )
                       AND NOT EXISTS (
                           SELECT 1 FROM ImportSIAC.NormaCensimentoProposta
                           WHERE Codice_Proposto = @CandidatoFpc
                             AND Stato <> N'RIFIUTATA'
                       )
                        SET @CodicePreferito = @CandidatoFpc;
                END;

                SET @CategoriaFonte =
                    CASE
                        WHEN @PrimoRifNormativo LIKE N'%UNI%'
                          OR @PrimoRifNormativo LIKE N'%ISO%'
                          OR @PrimoRifNormativo LIKE N'%EN [0-9]%'
                            THEN N'StandardInternazionale'
                        WHEN @PrimoRifNormativo LIKE N'%Regolamento%'
                          OR @PrimoRifNormativo LIKE N'%Reg. UE%'
                          OR @PrimoRifNormativo LIKE N'%(UE)%'
                            THEN N'NormativaEuropea'
                        WHEN @PrimoRifNormativo LIKE N'%D.Lgs%'
                          OR @PrimoRifNormativo LIKE N'%D.P.R%'
                          OR @PrimoRifNormativo LIKE N'%Legge%'
                          OR @PrimoRifNormativo LIKE N'%L. [0-9]%'
                            THEN N'NormativaItaliana'
                        ELSE N'SchemaPropietario'
                    END;
            END;
        END
        ELSE
        BEGIN
            SELECT @DescIt = TitoloIta, @DescEn = TitoloIng
            FROM #PpNorme
            WHERE Norma = @SourceValue;

            IF @@ROWCOUNT > 0
            BEGIN
                SET @Categoria = N'PP-NORMA';
                SET @FonteLookup = N'PP.NormeCertRaw';
                SET @CodiceVersione = N'LOOKUP-PP';
                SET @StatoNormaId = 3;
                SET @DescIt = LEFT(COALESCE(@DescIt, @SourceValue), 1000);
                SET @DescEn = LEFT(COALESCE(@DescEn, @SourceValue), 1000);
                SET @CodicePreferito = @SourceValue;
                SET @Riferimento = LEFT(CONCAT(
                    N'PP-',
                    REPLACE(REPLACE(REPLACE(@SourceValue, N' ', N'-'), N':', N'-'), N'/', N'-')
                ), 200);
                SET @CategoriaFonte =
                    CASE
                        WHEN @SourceValue LIKE N'ISO%'
                          OR @SourceValue LIKE N'UNI%'
                          OR @SourceValue LIKE N'EN [0-9]%'
                          OR @SourceValue LIKE N'PREN%'
                          OR @SourceValue LIKE N'BS %'
                            THEN N'StandardInternazionale'
                        ELSE N'SchemaPropietario'
                    END;

                -- Le edizioni PP storiche possono essere già censite ma inattive.
                -- In tal caso si propone il lineage verso l'esistente, non un duplicato.
                SELECT @TargetEsistenteId = NormaAccreditamentoId
                FROM Standard.NormaAccreditamento
                WHERE Codice = @SourceValue;

                IF @TargetEsistenteId IS NOT NULL
                BEGIN
                    SET @Azione = N'MAPPA_A_ESISTENTE';
                    SET @Note = N'Norma già censita nel catalogo; proposta mappatura alla voce esistente';
                END
                ELSE
                BEGIN
                    SET @Base = LEFT(@SourceValue, CHARINDEX(N':', @SourceValue + N':') - 1);

                    SELECT @Candidati = COUNT(*)
                    FROM Standard.NormaAccreditamento
                    WHERE Attivo = 1
                      AND DataCancellazione IS NULL
                      AND Codice LIKE N'%' + @Base + N':%';

                    IF @Candidati = 1
                    BEGIN
                        SELECT @SoloId = NormaAccreditamentoId
                        FROM Standard.NormaAccreditamento
                        WHERE Attivo = 1
                          AND DataCancellazione IS NULL
                          AND Codice LIKE N'%' + @Base + N':%';
                        SET @GerarchiaFiglioId = @SoloId;
                        SET @TipoRelazioneId = 2;
                    END
                    ELSE
                        SET @Note = CONCAT(
                            N'Ceppo non identificato univocamente (', @Candidati, N' candidati)'
                        );
                END;
            END;
        END;

        IF @Categoria IS NOT NULL
        BEGIN
            -- Il codice preferito viene prima troncato in modo deterministico.
            SET @Codice = LEFT(@CodicePreferito, 100);

            -- Se il pattern descrittivo FPC collide, prova prima il codice sorgente.
            IF @Azione = N'CENSISCI_NUOVA'
               AND @CodicePreferito <> @SourceValue
               AND (
                   EXISTS (SELECT 1 FROM Standard.NormaAccreditamento WHERE Codice=@Codice)
                   OR EXISTS (
                       SELECT 1 FROM ImportSIAC.NormaCensimentoProposta
                       WHERE Codice_Proposto=@Codice AND Stato<>N'RIFIUTATA'
                   )
               )
                SET @Codice = LEFT(@SourceValue, 100);

            -- Ultimo fallback: suffisso hash stabile, preservando il limite NVARCHAR(100).
            IF @Azione = N'CENSISCI_NUOVA'
               AND (
                   LEN(@CodicePreferito) > 100
                   OR EXISTS (SELECT 1 FROM Standard.NormaAccreditamento WHERE Codice=@Codice)
                   OR EXISTS (
                       SELECT 1 FROM ImportSIAC.NormaCensimentoProposta
                       WHERE Codice_Proposto=@Codice AND Stato<>N'RIFIUTATA'
                   )
               )
            BEGIN
                SET @Hash = LEFT(CONVERT(NVARCHAR(64), HASHBYTES(
                    'SHA2_256', CONCAT(@Categoria, N'|', @SourceValue)
                ), 2), 8);
                SET @Suffix = CONCAT(N' [', @Hash, N']');
                SET @Codice = LEFT(@SourceValue, 100 - LEN(@Suffix)) + @Suffix;
                SET @Note = CONCAT_WS(N'; ', NULLIF(@Note, N''),
                    N'Codice proposto adattato per lunghezza/collisione');
            END;

            INSERT INTO ImportSIAC.NormaCensimentoProposta (
                BatchId, Categoria, SourceValue, FonteLookup, Azione, TargetEsistenteId,
                Riferimento_Proposto, Codice_Proposto, CodiceVersione_Proposto,
                TitoloIta_Proposto, TitoloEng_Proposto,
                TipoNorma_Proposto, CategoriaFonte_Proposto,
                StatoNormaId_Proposto, RiferimentiNormativiJson,
                GerarchiaFiglioId_Proposto, TipoRelazioneNormaId_Proposto, Note
            )
            VALUES (
                @BatchId, @Categoria, @SourceValue, @FonteLookup, @Azione, @TargetEsistenteId,
                @Riferimento, @Codice, @CodiceVersione,
                @DescIt, @DescEn, @TipoNorma, @CategoriaFonte,
                @StatoNormaId, @LawItJson,
                @GerarchiaFiglioId, @TipoRelazioneId, @Note
            );

            SET @RigheGenerate += 1;
        END;

        FETCH NEXT FROM proposta_cursor INTO @SourceValue;
    END;

    CLOSE proposta_cursor;
    DEALLOCATE proposta_cursor;

    DROP TABLE IF EXISTS #FpcLookup;
    DROP TABLE IF EXISTS #FpcLog;
    DROP TABLE IF EXISTS #PpNorme;
    DROP TABLE IF EXISTS #Irrisolte;
END;

GO

