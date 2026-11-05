CREATE   PROCEDURE ImportSIAC.usp_Censimento_ApplicaApprovate
    @ApplicateCount INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET @ApplicateCount = 0;

    DECLARE
        @Id INT,
        @Categoria NVARCHAR(20),
        @SourceValue NVARCHAR(400),
        @Azione NVARCHAR(20),
        @Riferimento NVARCHAR(200),
        @Codice NVARCHAR(100),
        @CodiceVersione NVARCHAR(20),
        @TitoloIta NVARCHAR(1000),
        @TitoloEng NVARCHAR(1000),
        @TipoNorma NVARCHAR(30),
        @CategoriaFonte NVARCHAR(30),
        @StatoNormaId INT,
        @GerarchiaFiglioId INT,
        @TipoRelazioneId INT,
        @TargetEsistenteId INT,
        @ApprovatoDa NVARCHAR(100),
        @DataApprovazione DATETIME2(3),
        @NuovaNormaId INT,
        @MappingTargetId INT,
        @MappingExists BIT,
        @SistemaOrigine NVARCHAR(50),
        @ErrorNote NVARCHAR(2000);

    DECLARE approvate_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT
            NormaCensimentoPropostaId, Categoria, SourceValue, Azione,
            Riferimento_Proposto, Codice_Proposto, CodiceVersione_Proposto,
            TitoloIta_Proposto, TitoloEng_Proposto,
            TipoNorma_Proposto, CategoriaFonte_Proposto,
            StatoNormaId_Proposto,
            GerarchiaFiglioId_Proposto, TipoRelazioneNormaId_Proposto,
            TargetEsistenteId, ApprovatoDa, DataApprovazione
        FROM ImportSIAC.NormaCensimentoProposta
        WHERE Stato = N'APPROVATA'
        ORDER BY NormaCensimentoPropostaId;

    OPEN approvate_cursor;
    FETCH NEXT FROM approvate_cursor INTO
        @Id, @Categoria, @SourceValue, @Azione,
        @Riferimento, @Codice, @CodiceVersione,
        @TitoloIta, @TitoloEng, @TipoNorma, @CategoriaFonte,
        @StatoNormaId, @GerarchiaFiglioId, @TipoRelazioneId,
        @TargetEsistenteId, @ApprovatoDa, @DataApprovazione;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT
            @NuovaNormaId = NULL,
            @MappingTargetId = NULL,
            @MappingExists = 0,
            @SistemaOrigine = CONCAT(N'CENSIMENTO-', @Categoria),
            @ErrorNote = NULL;

        BEGIN TRY
            BEGIN TRANSACTION;

            IF @ApprovatoDa IS NULL OR LTRIM(RTRIM(@ApprovatoDa)) = N''
               OR @DataApprovazione IS NULL
                SET @ErrorNote = N'ERRORE applicazione: approvazione umana non documentata';

            IF @ErrorNote IS NULL AND @Azione = N'CENSISCI_NUOVA'
            BEGIN
                IF @Riferimento IS NULL OR LTRIM(RTRIM(@Riferimento)) = N''
                   OR @Codice IS NULL OR LTRIM(RTRIM(@Codice)) = N''
                   OR @TipoNorma IS NULL
                   OR @CategoriaFonte IS NULL
                   OR @StatoNormaId IS NULL
                    SET @ErrorNote = N'ERRORE applicazione: campi obbligatori della nuova norma mancanti';

                IF @ErrorNote IS NULL AND EXISTS (
                    SELECT 1 FROM Standard.NormaAccreditamento WHERE Codice = @Codice
                )
                    SET @ErrorNote = CONCAT(
                        N'ERRORE applicazione: Codice già esistente in catalogo (', @Codice, N')'
                    );

                IF @ErrorNote IS NULL AND @GerarchiaFiglioId IS NOT NULL
                   AND @TipoRelazioneId IS NULL
                    SET @ErrorNote = N'ERRORE applicazione: tipo relazione mancante per la gerarchia proposta';

                IF @ErrorNote IS NULL AND EXISTS (
                    SELECT 1
                    FROM ImportSIAC.MapNormaAccreditamento
                    WHERE SistemaOrigine = @SistemaOrigine
                      AND SourceValue = @SourceValue
                )
                    SET @ErrorNote = N'ERRORE applicazione: lineage già esistente per origine e SourceValue';

                IF @ErrorNote IS NULL
                BEGIN
                    INSERT INTO Standard.NormaAccreditamento (
                        Riferimento, Codice, CodiceVersione,
                        TitoloIta, TitoloEng,
                        TipoNorma, CategoriaFonte, StatoNormaId,
                        Attivo, DataCreazione, CreatoDa
                    )
                    VALUES (
                        @Riferimento, @Codice, @CodiceVersione,
                        @TitoloIta, @TitoloEng,
                        @TipoNorma, @CategoriaFonte, @StatoNormaId,
                        1, SYSUTCDATETIME(), NULL
                    );

                    SET @NuovaNormaId = CONVERT(INT, SCOPE_IDENTITY());

                    INSERT INTO Standard.NormaAccreditamentoGerarchia (
                        PadreId, FiglioId, Profondita, TipoRelazioneNormaId
                    )
                    VALUES (@NuovaNormaId, @NuovaNormaId, 0, 1);

                    IF @GerarchiaFiglioId IS NOT NULL
                       AND NOT EXISTS (
                           SELECT 1
                           FROM Standard.NormaAccreditamentoGerarchia
                           WHERE PadreId = @NuovaNormaId
                             AND FiglioId = @GerarchiaFiglioId
                       )
                    BEGIN
                        INSERT INTO Standard.NormaAccreditamentoGerarchia (
                            PadreId, FiglioId, Profondita, TipoRelazioneNormaId
                        )
                        VALUES (
                            @NuovaNormaId, @GerarchiaFiglioId, 1, @TipoRelazioneId
                        );
                    END;

                    INSERT INTO ImportSIAC.MapNormaAccreditamento (
                        SistemaOrigine, SourceValue, NormalizedValue,
                        TargetNormaAccreditamentoId, IsApproved, Notes
                    )
                    VALUES (
                        @SistemaOrigine, @SourceValue, @Codice,
                        @NuovaNormaId, 1,
                        CONCAT(
                            N'Censita da proposta #', @Id,
                            N'; approvata da ', @ApprovatoDa,
                            N' il ', CONVERT(NVARCHAR(19), @DataApprovazione, 120)
                        )
                    );

                    UPDATE ImportSIAC.NormaCensimentoProposta
                    SET Stato = N'APPLICATA', NormaCreataId = @NuovaNormaId,
                        Note = CONCAT_WS(N'; ', NULLIF(Note, N''), N'Applicazione completata')
                    WHERE NormaCensimentoPropostaId = @Id;
                END;
            END
            ELSE IF @ErrorNote IS NULL AND @Azione = N'MAPPA_A_ESISTENTE'
            BEGIN
                IF @TargetEsistenteId IS NULL OR NOT EXISTS (
                    SELECT 1
                    FROM Standard.NormaAccreditamento
                    WHERE NormaAccreditamentoId = @TargetEsistenteId
                      AND DataCancellazione IS NULL
                )
                    SET @ErrorNote = N'ERRORE applicazione: TargetEsistenteId mancante o non valido';

                IF @ErrorNote IS NULL
                BEGIN
                    SELECT @MappingExists = 1,
                           @MappingTargetId = TargetNormaAccreditamentoId
                    FROM ImportSIAC.MapNormaAccreditamento
                    WHERE SistemaOrigine = @SistemaOrigine
                      AND SourceValue = @SourceValue;

                    IF @MappingExists = 1
                       AND (@MappingTargetId IS NULL OR @MappingTargetId <> @TargetEsistenteId)
                        SET @ErrorNote = N'ERRORE applicazione: lineage esistente verso un target differente';
                END;

                IF @ErrorNote IS NULL
                BEGIN
                    IF @MappingExists = 0
                    BEGIN
                        INSERT INTO ImportSIAC.MapNormaAccreditamento (
                            SistemaOrigine, SourceValue, NormalizedValue,
                            TargetNormaAccreditamentoId, IsApproved, Notes
                        )
                        VALUES (
                            @SistemaOrigine, @SourceValue, @Codice,
                            @TargetEsistenteId, 1,
                            CONCAT(
                                N'Mappata a esistente da proposta #', @Id,
                                N'; approvata da ', @ApprovatoDa,
                                N' il ', CONVERT(NVARCHAR(19), @DataApprovazione, 120)
                            )
                        );
                    END;

                    UPDATE ImportSIAC.NormaCensimentoProposta
                    SET Stato = N'APPLICATA', NormaCreataId = @TargetEsistenteId,
                        Note = CONCAT_WS(N'; ', NULLIF(Note, N''), N'Applicazione completata')
                    WHERE NormaCensimentoPropostaId = @Id;
                END;
            END
            ELSE IF @ErrorNote IS NULL
                SET @ErrorNote = CONCAT(N'ERRORE applicazione: azione non applicabile (', @Azione, N')');

            IF @ErrorNote IS NOT NULL
            BEGIN
                ROLLBACK TRANSACTION;
                UPDATE ImportSIAC.NormaCensimentoProposta
                SET Note = LEFT(CONCAT_WS(N'; ', NULLIF(Note, N''), @ErrorNote), 2000)
                WHERE NormaCensimentoPropostaId = @Id;
            END
            ELSE
            BEGIN
                COMMIT TRANSACTION;
                SET @ApplicateCount += 1;
            END;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;

            UPDATE ImportSIAC.NormaCensimentoProposta
            SET Note = LEFT(CONCAT_WS(N'; ', NULLIF(Note, N''),
                CONCAT(N'ERRORE applicazione: ', ERROR_MESSAGE())), 2000)
            WHERE NormaCensimentoPropostaId = @Id;
        END CATCH;

        FETCH NEXT FROM approvate_cursor INTO
            @Id, @Categoria, @SourceValue, @Azione,
            @Riferimento, @Codice, @CodiceVersione,
            @TitoloIta, @TitoloEng, @TipoNorma, @CategoriaFonte,
            @StatoNormaId, @GerarchiaFiglioId, @TipoRelazioneId,
            @TargetEsistenteId, @ApprovatoDa, @DataApprovazione;
    END;

    CLOSE approvate_cursor;
    DEALLOCATE approvate_cursor;
END;

GO

