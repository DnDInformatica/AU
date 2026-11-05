
-- ================================================================================
-- ImportSIAC.usp_BH_07_SCD2_Parent
-- MIG_143_STATE_TIMELINE_V1
-- Timeline padre con eventi di scadenza/revoca e checkpoint giornaliero.
-- ================================================================================
CREATE PROCEDURE ImportSIAC.usp_BH_07_SCD2_Parent
    @BuildHistoryLogId INT,
    @RowsAffected BIGINT = NULL OUTPUT,
    @AsOfDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @StepStart datetime2(7) = SYSUTCDATETIME();
    DECLARE @StepLogId int = NULL;
    DECLARE @Rows bigint = 0;
    DECLARE @LockResult int;
    IF @AsOfDate IS NULL
        SET @AsOfDate =
            CONVERT
            (
                date,
                SYSDATETIMEOFFSET()
                    AT TIME ZONE 'Central European Standard Time'
            );
    DECLARE @AsOfTs datetime2(7) = CONVERT(datetime2(7), @AsOfDate);
    DECLARE @CheckpointSignature nvarchar(200) =
        CONCAT
        (
            N'MIG_143_STATE_TIMELINE_V1|ASOF=',
            CONVERT(char(8), @AsOfDate, 112)
        );
    DECLARE @TipoFPC int =
    (
        SELECT TipoCertificazioneId
        FROM Certificazione.TipoCertificazione
        WHERE Codice = N'FPC'
          AND DataCancellazione IS NULL
    );
    DECLARE @TipoPRD int =
    (
        SELECT TipoCertificazioneId
        FROM Certificazione.TipoCertificazione
        WHERE Codice = N'PRD'
          AND DataCancellazione IS NULL
    );
    DECLARE @StatoAttivo int =
    (
        SELECT StatoCertificazioneId
        FROM Certificazione.StatoCertificazione
        WHERE Codice = N'ATTIVO'
          AND DataCancellazione IS NULL
    );
    DECLARE @StatoScaduto int =
    (
        SELECT StatoCertificazioneId
        FROM Certificazione.StatoCertificazione
        WHERE Codice = N'SCADUTO'
          AND DataCancellazione IS NULL
    );
    DECLARE @StatoRevocato int =
    (
        SELECT StatoCertificazioneId
        FROM Certificazione.StatoCertificazione
        WHERE Codice = N'REVOCATO'
          AND DataCancellazione IS NULL
    );
    IF @TipoFPC IS NULL OR @TipoPRD IS NULL
        THROW 64320, 'Catalogo tipo FPC/PRD non disponibile.', 1;
    IF @StatoAttivo IS NULL OR @StatoScaduto IS NULL OR @StatoRevocato IS NULL
        THROW 64321, 'Catalogo stato ATTIVO/SCADUTO/REVOCATO non disponibile.', 1;
    IF @AsOfDate < '2000-01-01' OR @AsOfDate >= '9999-12-31'
        THROW 64322, '@AsOfDate fuori intervallo operativo.', 1;
    EXEC @LockResult = sys.sp_getapplock
        @Resource = N'ImportSIAC.BuildHistory.07_SCD2_PARENT',
        @LockMode = N'Exclusive',
        @LockOwner = N'Session',
        @LockTimeout = 0;
    IF @LockResult < 0
        THROW 64323, 'Step 07_SCD2_PARENT gia in esecuzione.', 1;
    BEGIN TRY
        DECLARE @CkValid bit = 0;
        DECLARE @CkReason nvarchar(200);
        DECLARE @SavedSignature nvarchar(200);
        EXEC ImportSIAC.usp_BH_Checkpoint_Check
            @StepCode = N'07_SCD2_PARENT',
            @IsValid = @CkValid OUTPUT,
            @Reason = @CkReason OUTPUT;
        IF @CkValid = 1
        BEGIN
            SELECT @SavedSignature = SourceSignature
            FROM ImportSIAC.BuildHistory_Checkpoint
            WHERE StepCode = N'07_SCD2_PARENT'
              AND Status = N'VALID';
            IF ISNULL(@SavedSignature, N'') <> @CheckpointSignature
            BEGIN
                SET @CkValid = 0;
                SET @CkReason = N'Firma temporale diversa: lo stato SCADUTO deve essere rivalutato.';
            END;
        END;
        IF @CkValid = 1
        BEGIN
            SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_All_Final);
            SET @RowsAffected = @Rows;
            INSERT INTO ImportSIAC.BuildHistory_StepLog
            (
                BuildHistoryLogId, StepNo, StepCode, StepName,
                StartedAt, FinishedAt, DurationMs, Status,
                RowsAffected, ExtraInfo
            )
            VALUES
            (
                @BuildHistoryLogId, 7, N'07_SCD2_PARENT',
                N'SCD2 padre stati (RESUMED)',
                SYSUTCDATETIME(), SYSUTCDATETIME(), 0, N'SUCCESS',
                @Rows,
                CONCAT(N'RESUMED; firma=', @CheckpointSignature)
            );
            PRINT CONCAT
            (
                'STEP 07_SCD2_PARENT: RESUMED, ',
                @Rows,
                '; AsOf=',
                CONVERT(char(10), @AsOfDate, 23)
            );
            EXEC sys.sp_releaseapplock
                @Resource = N'ImportSIAC.BuildHistory.07_SCD2_PARENT',
                @LockOwner = N'Session';
            RETURN;
        END;
        /* Se 07 viene ricostruito, il padre e tutti i consumer fisici del
           padre devono essere ricostruiti nello stesso run. Gli output 05B,
           08 e 09 non dipendono dallo stato del certificato e restano validi. */
        DECLARE @Staled table
        (
            StepCode nvarchar(50) NOT NULL,
            OutputTable nvarchar(200) NULL,
            ExpectedRows bigint NULL
        );
        UPDATE cp
           SET Status = N'STALE',
               Notes = LEFT
               (
                   CONCAT
                   (
                       N'MIG_143/runtime: timeline stati da rigenerare. ',
                       COALESCE(cp.Notes, N'')
                   ),
                   500
               )
        OUTPUT
            deleted.StepCode,
            deleted.OutputTable,
            deleted.RowCountAtSave
        INTO @Staled (StepCode, OutputTable, ExpectedRows)
        FROM ImportSIAC.BuildHistory_Checkpoint AS cp
        WHERE cp.StepCode IN
        (
            N'07_SCD2_PARENT',
            N'10_REBUILD_CERT',
            N'11_SG',
            N'12B_SEDE',
            N'12_PRD',
            N'13_FPC'
        )
          AND cp.Status = N'VALID';
        INSERT INTO ImportSIAC.BuildHistory_CheckpointAudit
        (
            StepCode, OutputTable, ExpectedRows,
            ActualRows, IsValid, Reason
        )
        SELECT
            s.StepCode, s.OutputTable, s.ExpectedRows,
            NULL, 0,
            CONCAT
            (
                N'MIG_143: invalidazione dipendenza timeline; AsOf=',
                CONVERT(char(10), @AsOfDate, 23),
                N'; motivo=',
                COALESCE(@CkReason, N'checkpoint non valido')
            )
        FROM @Staled AS s;
        INSERT INTO ImportSIAC.BuildHistory_StepLog
        (
            BuildHistoryLogId, StepNo, StepCode,
            StepName, StartedAt, Status
        )
        VALUES
        (
            @BuildHistoryLogId, 7, N'07_SCD2_PARENT',
            N'SCD2 padre: timeline ATTIVO/SCADUTO/REVOCATO',
            @StepStart, N'RUNNING'
        );
        SET @StepLogId = SCOPE_IDENTITY();
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentSnapshotSpan;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentEvents;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentEffective;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentSigned;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentChangeCandidates;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentChanges;
        DROP TABLE IF EXISTS ImportSIAC.wrk_All_Final;
        /* Le snapshot export_base_YYYY_M descrivono lo stato al primo giorno
           del mese. SnapshotDate e' quindi il tempo di osservazione corretto;
           SnapshotBusinessTs (fine mese) non viene usato dalla timeline padre. */
        SELECT
            mb.RawId,
            mb.ChiaveBusinessHash,
            mb.NumeroCertificato,
            mb.OrganizzazioneODCId,
            CASE mb.Dominio
                WHEN N'FPC' THEN @TipoFPC
                WHEN N'PRD' THEN @TipoPRD
                ELSE mb.TipoCertificazioneId
            END AS TipoCertificazioneId,
            mb.NormaAccreditamentoId,
            mb.StatoCertificazioneId AS StatoOsservatoId,
            mb.DataEmissione,
            mb.DataScadenza,
            mb.DataRevoca,
            mb.Privato,
            mb.DataPrimoRilascio,
            mb.DataUltimoRinnovo,
            mb.Dominio,
            CONVERT(datetime2(7), mb.SnapshotDate) AS ObservationTs,
            LEAD(CONVERT(datetime2(7), mb.SnapshotDate)) OVER
            (
                PARTITION BY mb.ChiaveBusinessHash
                ORDER BY mb.SnapshotDate, mb.RawId
            ) AS NextObservationTs,
            LEAD(mb.DataScadenza) OVER
            (
                PARTITION BY mb.ChiaveBusinessHash
                ORDER BY mb.SnapshotDate, mb.RawId
            ) AS NextDataScadenza,
            LEAD(mb.DataUltimoRinnovo) OVER
            (
                PARTITION BY mb.ChiaveBusinessHash
                ORDER BY mb.SnapshotDate, mb.RawId
            ) AS NextDataUltimoRinnovo
        INTO ImportSIAC.wrk_ParentSnapshotSpan
        FROM ImportSIAC.wrk_MonthlyBest AS mb
        WHERE mb.SnapshotDate <= @AsOfDate
        OPTION (MAXDOP 8);
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_ParentSnapshotSpan
            ON ImportSIAC.wrk_ParentSnapshotSpan;
        /* Evento di osservazione. */
        SELECT
            s.RawId,
            s.ChiaveBusinessHash,
            s.NumeroCertificato,
            s.OrganizzazioneODCId,
            s.TipoCertificazioneId,
            s.NormaAccreditamentoId,
            CASE
                WHEN
                (
                    s.DataRevoca IS NOT NULL
                    AND s.DataRevoca <= CONVERT(date, s.ObservationTs)
                )
                OR
                (
                    s.StatoOsservatoId = @StatoRevocato
                    AND s.DataRevoca IS NULL
                )
                    THEN @StatoRevocato
                WHEN s.DataScadenza IS NOT NULL
                 AND s.DataScadenza < CONVERT(date, s.ObservationTs)
                    THEN @StatoScaduto
                WHEN s.StatoOsservatoId = @StatoRevocato
                 AND s.DataRevoca > CONVERT(date, s.ObservationTs)
                    THEN @StatoAttivo
                ELSE COALESCE(s.StatoOsservatoId, @StatoAttivo)
            END AS CandidateStateId,
            s.DataEmissione,
            s.DataScadenza,
            CASE
                WHEN s.DataRevoca IS NOT NULL
                 AND s.DataRevoca <= CONVERT(date, s.ObservationTs)
                    THEN s.DataRevoca
                ELSE NULL
            END AS VisibleDataRevoca,
            s.Privato,
            s.DataPrimoRilascio,
            s.Dominio,
            s.ObservationTs AS EventTs,
            CONVERT
            (
                bit,
                CASE
                    WHEN
                    (
                        s.DataRevoca IS NOT NULL
                        AND s.DataRevoca <= CONVERT(date, s.ObservationTs)
                    )
                    OR
                    (
                        s.StatoOsservatoId = @StatoRevocato
                        AND s.DataRevoca IS NULL
                    )
                        THEN 1
                    ELSE 0
                END
            ) AS IsRevocationEvent,
            CONVERT(tinyint, 10) AS EventPriority
        INTO ImportSIAC.wrk_ParentEvents
        FROM ImportSIAC.wrk_ParentSnapshotSpan AS s
        UNION ALL
        /* Evento SCADUTO alle 00:00 del giorno successivo alla scadenza. */
        SELECT
            s.RawId,
            s.ChiaveBusinessHash,
            s.NumeroCertificato,
            s.OrganizzazioneODCId,
            s.TipoCertificazioneId,
            s.NormaAccreditamentoId,
            @StatoScaduto,
            s.DataEmissione,
            s.DataScadenza,
            CAST(NULL AS date),
            s.Privato,
            s.DataPrimoRilascio,
            s.Dominio,
            x.ExpiryTs,
            CAST(0 AS bit),
            CONVERT(tinyint, 20)
        FROM ImportSIAC.wrk_ParentSnapshotSpan AS s
        CROSS APPLY
        (
            SELECT
                CONVERT
                (
                    datetime2(7),
                    DATEADD
                    (
                        day,
                        1,
                        CASE
                            WHEN s.DataScadenza < '9999-12-31'
                                THEN s.DataScadenza
                            ELSE NULL
                        END
                    )
                ) AS ExpiryTs
        ) AS x
        WHERE x.ExpiryTs IS NOT NULL
          AND x.ExpiryTs > s.ObservationTs
          AND x.ExpiryTs <= @AsOfTs
          AND
          (
              s.NextObservationTs IS NULL
              OR x.ExpiryTs < s.NextObservationTs
          )
          AND NOT
          (
              s.StatoOsservatoId = @StatoRevocato
              AND s.DataRevoca IS NULL
          )
          AND NOT
          (
              s.DataRevoca IS NOT NULL
              AND CONVERT(datetime2(7), s.DataRevoca) <= x.ExpiryTs
          )
          AND
          (
              CASE
                  WHEN s.NextDataScadenza > s.DataScadenza
                   AND s.NextDataUltimoRinnovo IS NOT NULL
                   AND s.NextDataUltimoRinnovo <= s.DataScadenza
                      THEN 0
                  ELSE 1
              END
          ) = 1
        UNION ALL
        /* Evento REVOCATO alla data effettiva, se successiva alla snapshot. */
        SELECT
            s.RawId,
            s.ChiaveBusinessHash,
            s.NumeroCertificato,
            s.OrganizzazioneODCId,
            s.TipoCertificazioneId,
            s.NormaAccreditamentoId,
            @StatoRevocato,
            s.DataEmissione,
            s.DataScadenza,
            s.DataRevoca,
            s.Privato,
            s.DataPrimoRilascio,
            s.Dominio,
            CONVERT(datetime2(7), s.DataRevoca),
            CAST(1 AS bit),
            CONVERT(tinyint, 30)
        FROM ImportSIAC.wrk_ParentSnapshotSpan AS s
        WHERE s.DataRevoca IS NOT NULL
          AND CONVERT(datetime2(7), s.DataRevoca) > s.ObservationTs
          AND CONVERT(datetime2(7), s.DataRevoca) <= @AsOfTs
          AND
          (
              s.NextObservationTs IS NULL
              OR CONVERT(datetime2(7), s.DataRevoca) < s.NextObservationTs
          )
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_ParentSnapshotSpan;
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_ParentEvents
            ON ImportSIAC.wrk_ParentEvents;
        /* Deduplica gli eventi simultanei e rende REVOCATO terminale. */
        ;WITH Ranked AS
        (
            SELECT
                e.*,
                ROW_NUMBER() OVER
                (
                    PARTITION BY e.ChiaveBusinessHash, e.EventTs
                    ORDER BY e.EventPriority DESC, e.RawId DESC
                ) AS EventRank
            FROM ImportSIAC.wrk_ParentEvents AS e
        ),
        Selected AS
        (
            SELECT *
            FROM Ranked
            WHERE EventRank = 1
        ),
        RunningState AS
        (
            SELECT
                s.*,
                MAX(CONVERT(tinyint, s.IsRevocationEvent)) OVER
                (
                    PARTITION BY s.ChiaveBusinessHash
                    ORDER BY s.EventTs
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                ) AS HasBeenRevoked,
                MIN(s.VisibleDataRevoca) OVER
                (
                    PARTITION BY s.ChiaveBusinessHash
                    ORDER BY s.EventTs
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                ) AS EffectiveDataRevoca
            FROM Selected AS s
        )
        SELECT
            r.RawId,
            r.ChiaveBusinessHash,
            r.NumeroCertificato,
            r.OrganizzazioneODCId,
            r.TipoCertificazioneId,
            r.NormaAccreditamentoId,
            CASE
                WHEN r.HasBeenRevoked = 1 THEN @StatoRevocato
                ELSE r.CandidateStateId
            END AS StatoCertificazioneId,
            r.DataEmissione,
            r.DataScadenza,
            CASE
                WHEN r.HasBeenRevoked = 1 THEN r.EffectiveDataRevoca
                ELSE NULL
            END AS DataRevoca,
            r.Privato,
            r.DataPrimoRilascio,
            r.Dominio,
            r.EventTs
        INTO ImportSIAC.wrk_ParentEffective
        FROM RunningState AS r
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_ParentEvents;
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_ParentEffective
            ON ImportSIAC.wrk_ParentEffective;
        SELECT
            e.*,
            HASHBYTES
            (
                'SHA2_256',
                CONCAT
                (
                    ISNULL(CONVERT(varchar(20), e.TipoCertificazioneId), 'NULL'), '|',
                    ISNULL(CONVERT(varchar(20), e.NormaAccreditamentoId), 'NULL'), '|',
                    ISNULL(CONVERT(varchar(20), e.StatoCertificazioneId), 'NULL'), '|',
                    ISNULL(CONVERT(varchar(10), e.DataEmissione, 23), 'NULL'), '|',
                    ISNULL(CONVERT(varchar(10), e.DataScadenza, 23), 'NULL'), '|',
                    ISNULL(CONVERT(varchar(10), e.DataRevoca, 23), 'NULL'), '|',
                    ISNULL(CONVERT(varchar(1), e.Privato), 'NULL')
                )
            ) AS RowSig
        INTO ImportSIAC.wrk_ParentSigned
        FROM ImportSIAC.wrk_ParentEffective AS e
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_ParentEffective;
        CREATE CLUSTERED COLUMNSTORE INDEX CCI_ParentSigned
            ON ImportSIAC.wrk_ParentSigned;
        SELECT
            s.*,
            LAG(s.RowSig) OVER
            (
                PARTITION BY s.ChiaveBusinessHash
                ORDER BY s.EventTs
            ) AS PrevRowSig
        INTO ImportSIAC.wrk_ParentChangeCandidates
        FROM ImportSIAC.wrk_ParentSigned AS s
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_ParentSigned;
        SELECT
            c.RawId,
            c.ChiaveBusinessHash,
            c.NumeroCertificato,
            c.OrganizzazioneODCId,
            c.TipoCertificazioneId,
            c.NormaAccreditamentoId,
            c.StatoCertificazioneId,
            c.DataEmissione,
            c.DataScadenza,
            c.DataRevoca,
            c.Privato,
            c.DataPrimoRilascio,
            c.Dominio,
            c.EventTs
        INTO ImportSIAC.wrk_ParentChanges
        FROM ImportSIAC.wrk_ParentChangeCandidates AS c
        WHERE c.PrevRowSig IS NULL
           OR c.PrevRowSig <> c.RowSig
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_ParentChangeCandidates;
        ;WITH Timeline AS
        (
            SELECT
                c.*,
                LEAD(c.EventTs) OVER
                (
                    PARTITION BY c.ChiaveBusinessHash
                    ORDER BY c.EventTs
                ) AS NextEventTs
            FROM ImportSIAC.wrk_ParentChanges AS c
        )
        SELECT
            t.ChiaveBusinessHash,
            t.NumeroCertificato,
            t.OrganizzazioneODCId,
            t.TipoCertificazioneId,
            t.NormaAccreditamentoId,
            t.StatoCertificazioneId,
            t.DataEmissione,
            t.DataScadenza,
            t.DataRevoca,
            t.Privato,
            t.DataPrimoRilascio,
            t.EventTs AS DataInizioValidita,
            COALESCE
            (
                DATEADD(nanosecond, -100, t.NextEventTs),
                CONVERT(datetime2(7), '9999-12-31 23:59:59.9999999')
            ) AS DataFineValidita,
            CASE WHEN t.NextEventTs IS NULL THEN 1 ELSE 0 END AS IsCorrente,
            t.Dominio
        INTO ImportSIAC.wrk_All_Final
        FROM Timeline AS t
        OPTION (MAXDOP 8);
        DROP TABLE ImportSIAC.wrk_ParentChanges;
        CREATE CLUSTERED INDEX CX_All_Final
            ON ImportSIAC.wrk_All_Final
            (
                ChiaveBusinessHash,
                DataInizioValidita
            );
        IF EXISTS
        (
            SELECT 1
            FROM ImportSIAC.wrk_All_Final
            WHERE DataInizioValidita >= DataFineValidita
              AND DataFineValidita <> CONVERT
                  (
                      datetime2(7),
                      '9999-12-31 23:59:59.9999999'
                  )
        )
            THROW 64324, 'Timeline padre con intervalli non positivi.', 1;
        IF EXISTS
        (
            SELECT ChiaveBusinessHash
            FROM ImportSIAC.wrk_All_Final
            WHERE IsCorrente = 1
            GROUP BY ChiaveBusinessHash
            HAVING COUNT_BIG(*) <> 1
        )
            THROW 64325, 'Timeline padre con numero di correnti diverso da uno.', 1;
        IF EXISTS
        (
            SELECT 1
            FROM ImportSIAC.wrk_All_Final AS f
            WHERE f.IsCorrente = 1
              AND f.StatoCertificazioneId = @StatoAttivo
              AND f.DataScadenza IS NOT NULL
              AND f.DataScadenza < @AsOfDate
        )
            THROW 64326, 'Persistono certificati ATTIVI con scadenza passata.', 1;
        SET @Rows = (SELECT COUNT_BIG(*) FROM ImportSIAC.wrk_All_Final);
        SET @RowsAffected = @Rows;
        UPDATE ImportSIAC.BuildHistory_StepLog
           SET FinishedAt = SYSUTCDATETIME(),
               DurationMs = DATEDIFF_BIG
               (
                   millisecond,
                   StartedAt,
                   SYSUTCDATETIME()
               ),
               Status = N'SUCCESS',
               RowsAffected = @Rows,
               ExtraInfo = CONCAT
               (
                   N'AsOf=',
                   CONVERT(char(10), @AsOfDate, 23),
                   N'; firma=',
                   @CheckpointSignature
               )
        WHERE BuildHistoryStepLogId = @StepLogId;
        PRINT CONCAT
        (
            'STEP 07_SCD2_PARENT: ',
            @Rows,
            '; AsOf=',
            CONVERT(char(10), @AsOfDate, 23)
        );
        EXEC ImportSIAC.usp_BH_Checkpoint_Mark
            @StepCode = N'07_SCD2_PARENT',
            @OutputTable = N'ImportSIAC.wrk_All_Final',
            @RowCountAtSave = @Rows,
            @SourceSignature = @CheckpointSignature,
            @Notes = N'MIG_143: timeline ATTIVO/SCADUTO/REVOCATO con eventi effettivi.';
        EXEC sys.sp_releaseapplock
            @Resource = N'ImportSIAC.BuildHistory.07_SCD2_PARENT',
            @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg nvarchar(4000) =
            LEFT
            (
                CONCAT(N'ERR ', ERROR_NUMBER(), N': ', ERROR_MESSAGE()),
                4000
            );
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentSnapshotSpan;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentEvents;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentEffective;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentSigned;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentChangeCandidates;
        DROP TABLE IF EXISTS ImportSIAC.wrk_ParentChanges;
        IF @StepLogId IS NOT NULL
        BEGIN
            UPDATE ImportSIAC.BuildHistory_StepLog
               SET FinishedAt = SYSUTCDATETIME(),
                   DurationMs = DATEDIFF_BIG
                   (
                       millisecond,
                       StartedAt,
                       SYSUTCDATETIME()
                   ),
                   Status = N'FAILED',
                   ErrorMessage = @ErrMsg
            WHERE BuildHistoryStepLogId = @StepLogId;
        END;
        EXEC sys.sp_releaseapplock
            @Resource = N'ImportSIAC.BuildHistory.07_SCD2_PARENT',
            @LockOwner = N'Session';
        THROW;
    END CATCH;
END;

GO

