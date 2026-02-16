| Schema | Tabella | Colonna | Ord | IsHistory | TemporalType | HistoryTable | Tipo | Len/Prec | Obbl. | Null | IsPK | PKName | IsFK | FKs | EP |
|---|---|---|---:|---:|---:|---|---|---|---|---|---:|---|---:|---|---|
| Accreditamento | DocumentoEvento | DocumentoEventoId | 1 | 0 | 2 | Accreditamento.DocumentoEventoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_DocumentoEvento | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | EventoRegolatorioId | 2 | 0 | 2 | Accreditamento.DocumentoEventoStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_DocumentoEvento_Evento -> Accreditamento.EventoRegolatorio.EventoRegolatorioId | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | ProvvedimentoRegolatorioId | 3 | 0 | 2 | Accreditamento.DocumentoEventoStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_DocumentoEvento_Provvedimento -> Accreditamento.ProvvedimentoRegolatorio.ProvvedimentoRegolatorioId | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | TipoDocumento | 4 | 0 | 2 | Accreditamento.DocumentoEventoStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | NomeFile | 5 | 0 | 2 | Accreditamento.DocumentoEventoStorico | nvarchar | 255 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | Descrizione | 6 | 0 | 2 | Accreditamento.DocumentoEventoStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | PercorsoFile | 7 | 0 | 2 | Accreditamento.DocumentoEventoStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | HashFile | 8 | 0 | 2 | Accreditamento.DocumentoEventoStorico | nvarchar | 64 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | DimensioneBytes | 9 | 0 | 2 | Accreditamento.DocumentoEventoStorico | bigint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | DataDocumento | 10 | 0 | 2 | Accreditamento.DocumentoEventoStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | DataCaricamento | 11 | 0 | 2 | Accreditamento.DocumentoEventoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | DataCreazione | 12 | 0 | 2 | Accreditamento.DocumentoEventoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | CreatoDa | 13 | 0 | 2 | Accreditamento.DocumentoEventoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | DataModifica | 14 | 0 | 2 | Accreditamento.DocumentoEventoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | ModificatoDa | 15 | 0 | 2 | Accreditamento.DocumentoEventoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | DataCancellazione | 16 | 0 | 2 | Accreditamento.DocumentoEventoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | CancellatoDa | 17 | 0 | 2 | Accreditamento.DocumentoEventoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | UniqueRowId | 18 | 0 | 2 | Accreditamento.DocumentoEventoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | DataInizioValidita | 19 | 0 | 2 | Accreditamento.DocumentoEventoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEvento | DataFineValidita | 20 | 0 | 2 | Accreditamento.DocumentoEventoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | DocumentoEventoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | EventoRegolatorioId | 2 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | ProvvedimentoRegolatorioId | 3 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | TipoDocumento | 4 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | NomeFile | 5 | 1 | 1 |  | nvarchar | 255 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | Descrizione | 6 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | PercorsoFile | 7 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | HashFile | 8 | 1 | 1 |  | nvarchar | 64 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | DimensioneBytes | 9 | 1 | 1 |  | bigint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | DataDocumento | 10 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | DataCaricamento | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | DataCreazione | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | CreatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | DataModifica | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | ModificatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | DataCancellazione | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | CancellatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | UniqueRowId | 18 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | DataInizioValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | DocumentoEventoStorico | DataFineValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamento | EnteAccreditamentoId | 1 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__EnteAccr__0DE86FF1CC339441 | 0 |  -> .. | MS_Description = Chiave primaria identificativa univoca dell'ente accreditato |
| Accreditamento | EnteAccreditamento | Denominazione | 2 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | nvarchar | 255 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Denominazione ufficiale |
| Accreditamento | EnteAccreditamento | Sigla | 3 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Sigla o acronimo |
| Accreditamento | EnteAccreditamento | Note | 4 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Note generali |
| Accreditamento | EnteAccreditamento | DataFondazione | 5 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Data di fondazione |
| Accreditamento | EnteAccreditamento | DataCreazione | 6 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Accreditamento | EnteAccreditamento | CreatoDa | 7 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente creatore |
| Accreditamento | EnteAccreditamento | DataModifica | 8 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di modifica |
| Accreditamento | EnteAccreditamento | ModificatoDa | 9 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente modificatore |
| Accreditamento | EnteAccreditamento | DataCancellazione | 10 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Accreditamento | EnteAccreditamento | CancellatoDa | 11 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente cancellatore |
| Accreditamento | EnteAccreditamento | UniqueRowId | 12 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = GUID univoco del record |
| Accreditamento | EnteAccreditamento | DataInizioValidita | 13 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data inizio validità temporale |
| Accreditamento | EnteAccreditamento | DataFineValidita | 14 | 0 | 2 | Accreditamento.EnteAccreditamentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data fine validità temporale |
| Accreditamento | EnteAccreditamentoDatiFiscali | EnteAccreditamentoDatiFiscaliId | 1 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__EnteAccr__5FE4A25DADB4D6F6 | 0 |  -> .. | MS_Description = Chiave primaria della tabella |
| Accreditamento | EnteAccreditamentoDatiFiscali | AccreditamentoId | 2 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_DatiFiscali_EnteAccreditamento -> Accreditamento.EnteAccreditamento.EnteAccreditamentoId | MS_Description = Chiave esterna riferimento a Accreditamento.EnteAccreditamento |
| Accreditamento | EnteAccreditamentoDatiFiscali | NomeCampo | 3 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Nome del campo fiscale (es: PartitaIVA, CodiceFiscale, NIscrizioneREA) |
| Accreditamento | EnteAccreditamentoDatiFiscali | Valore | 4 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | nvarchar | 255 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Valore del campo fiscale |
| Accreditamento | EnteAccreditamentoDatiFiscali | DataFondazione | 5 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscali | DataCreazione | 6 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Accreditamento | EnteAccreditamentoDatiFiscali | CreatoDa | 7 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha creato il record |
| Accreditamento | EnteAccreditamentoDatiFiscali | DataModifica | 8 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Accreditamento | EnteAccreditamentoDatiFiscali | ModificatoDa | 9 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha modificato il record |
| Accreditamento | EnteAccreditamentoDatiFiscali | DataCancellazione | 10 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Accreditamento | EnteAccreditamentoDatiFiscali | CancellatoDa | 11 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha cancellato il record |
| Accreditamento | EnteAccreditamentoDatiFiscali | UniqueRowId | 12 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = GUID univoco del record |
| Accreditamento | EnteAccreditamentoDatiFiscali | DataInizioValidita | 13 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscali | DataFineValidita | 14 | 0 | 2 | Accreditamento.EnteAccreditamentoDatiFiscaliStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | EnteAccreditamentoDatiFiscaliId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | AccreditamentoId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | NomeCampo | 3 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | Valore | 4 | 1 | 1 |  | nvarchar | 255 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | DataFondazione | 5 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoDatiFiscaliStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | EnteAccreditamentoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | Denominazione | 2 | 1 | 1 |  | nvarchar | 255 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | Sigla | 3 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | Note | 4 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | DataFondazione | 5 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EnteAccreditamentoStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | EventoRegolatorioId | 1 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_EventoRegolatorio | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | OrganizzazioneId | 2 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_EventoRegolatorio_Organizzazione -> Organizzazioni.Organizzazione.OrganizzazioneId | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | UnitaOrganizzativaId | 3 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_EventoRegolatorio_UnitaOrganizzativa -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | EnteAccreditamentoId | 4 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | TipoEventoRegolatorioId | 5 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_EventoRegolatorio_TipoEvento -> Tipologica.TipoEventoRegolatorio.TipoEventoRegolatorioId | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | Codice | 6 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | Titolo | 7 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | Descrizione | 8 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | DataEvento | 9 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | DataNotifica | 10 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | DataScadenzaRisposta | 11 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | Esito | 12 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | NoteEsito | 13 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | DataChiusura | 14 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | ResponsabileInternoId | 15 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_EventoRegolatorio_ResponsabileInterno -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | ProtocolloEsterno | 16 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | RiferimentoNormativo | 17 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | NomeIspettore | 18 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | EnteIspettore | 19 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | DataCreazione | 20 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | CreatoDa | 21 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | DataModifica | 22 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | ModificatoDa | 23 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | DataCancellazione | 24 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | CancellatoDa | 25 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | UniqueRowId | 26 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | DataInizioValidita | 27 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorio | DataFineValidita | 28 | 0 | 2 | Accreditamento.EventoRegolatorioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | EventoRegolatorioId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | OrganizzazioneId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | UnitaOrganizzativaId | 3 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | EnteAccreditamentoId | 4 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | TipoEventoRegolatorioId | 5 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | Codice | 6 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | Titolo | 7 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | Descrizione | 8 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | DataEvento | 9 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | DataNotifica | 10 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | DataScadenzaRisposta | 11 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | Esito | 12 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | NoteEsito | 13 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | DataChiusura | 14 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | ResponsabileInternoId | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | ProtocolloEsterno | 16 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | RiferimentoNormativo | 17 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | NomeIspettore | 18 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | EnteIspettore | 19 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | DataCreazione | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | CreatoDa | 21 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | DataModifica | 22 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | ModificatoDa | 23 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | DataCancellazione | 24 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | CancellatoDa | 25 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | UniqueRowId | 26 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | DataInizioValidita | 27 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | EventoRegolatorioStorico | DataFineValidita | 28 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | ProvvedimentoRegolatorioId | 1 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_ProvvedimentoRegolatorio | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | EventoRegolatorioId | 2 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_ProvvedimentoRegolatorio_Evento -> Accreditamento.EventoRegolatorio.EventoRegolatorioId | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | TipoProvvedimentoId | 3 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_ProvvedimentoRegolatorio_TipoProvv -> Tipologica.TipoProvvedimento.TipoProvvedimentoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | Codice | 4 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | Titolo | 5 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | Descrizione | 6 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | NormativaViolata | 7 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | RequisitoViolato | 8 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | DataEmissione | 9 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | DataScadenza | 10 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | DataChiusura | 11 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | Stato | 12 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | AzioneCorrettivaRichiesta | 13 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | AzioneCorrettivaEffettuata | 14 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | DataVerificaEfficacia | 15 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | EsitoVerificaEfficacia | 16 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | AmbitoAccreditamentoImpattato | 17 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | ImportoSanzione | 18 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | Valuta | 19 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | nvarchar | 3 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | ResponsabileAzioneId | 20 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_ProvvedimentoRegolatorio_Responsabile -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | DataCreazione | 21 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | CreatoDa | 22 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | DataModifica | 23 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | ModificatoDa | 24 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | DataCancellazione | 25 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | CancellatoDa | 26 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | UniqueRowId | 27 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | DataInizioValidita | 28 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorio | DataFineValidita | 29 | 0 | 2 | Accreditamento.ProvvedimentoRegolatorioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | ProvvedimentoRegolatorioId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | EventoRegolatorioId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | TipoProvvedimentoId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | Codice | 4 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | Titolo | 5 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | Descrizione | 6 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | NormativaViolata | 7 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | RequisitoViolato | 8 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | DataEmissione | 9 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | DataScadenza | 10 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | DataChiusura | 11 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | Stato | 12 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | AzioneCorrettivaRichiesta | 13 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | AzioneCorrettivaEffettuata | 14 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | DataVerificaEfficacia | 15 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | EsitoVerificaEfficacia | 16 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | AmbitoAccreditamentoImpattato | 17 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | ImportoSanzione | 18 | 1 | 1 |  | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | Valuta | 19 | 1 | 1 |  | nvarchar | 3 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | ResponsabileAzioneId | 20 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | DataCreazione | 21 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | CreatoDa | 22 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | DataModifica | 23 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | ModificatoDa | 24 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | DataCancellazione | 25 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | CancellatoDa | 26 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | UniqueRowId | 27 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | DataInizioValidita | 28 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ProvvedimentoRegolatorioStorico | DataFineValidita | 29 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccredia | ResponsabilitaAccrediaId | 1 | 0 | 2 | Accreditamento.ResponsabilitaAccrediaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_ResponsabilitaAccredia | 0 |  -> .. | MS_Description = Chiave primaria della responsabilità |
| Accreditamento | ResponsabilitaAccredia | UnitaOrganizzativaId | 2 | 0 | 2 | Accreditamento.ResponsabilitaAccrediaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Responsabilita_UnitaOrganizzativa -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = Chiave esterna verso Organizzazioni.UnitaOrganizzativa a cui è assegnata la responsabilità |
| Accreditamento | ResponsabilitaAccredia | TipoResponsabilita | 3 | 0 | 2 | Accreditamento.ResponsabilitaAccrediaStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Tipo di responsabilità (es: RESPONSABILE_TECNICO, RESPONSABILE_GESTIONALE, SUPERVISORE) |
| Accreditamento | ResponsabilitaAccredia | PersonaId | 4 | 0 | 2 | Accreditamento.ResponsabilitaAccrediaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID della persona fisica (da tabella Persone esterna) |
| Accreditamento | ResponsabilitaAccredia | DataInizio | 5 | 0 | 2 | Accreditamento.ResponsabilitaAccrediaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data inizio della responsabilità (business date) |
| Accreditamento | ResponsabilitaAccredia | DataFine | 6 | 0 | 2 | Accreditamento.ResponsabilitaAccrediaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Data fine della responsabilità (business date) - NULL significa attualmente valida |
| Accreditamento | ResponsabilitaAccredia | Note | 7 | 0 | 2 | Accreditamento.ResponsabilitaAccrediaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Note sulla responsabilità (es: ambito specifico, limitazioni, delega) |
| Accreditamento | ResponsabilitaAccredia | DataInizioValidita | 8 | 0 | 2 | Accreditamento.ResponsabilitaAccrediaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccredia | DataFineValidita | 9 | 0 | 2 | Accreditamento.ResponsabilitaAccrediaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccrediaStorico | ResponsabilitaAccrediaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccrediaStorico | UnitaOrganizzativaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccrediaStorico | TipoResponsabilita | 3 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccrediaStorico | PersonaId | 4 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccrediaStorico | DataInizio | 5 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccrediaStorico | DataFine | 6 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccrediaStorico | Note | 7 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccrediaStorico | DataInizioValidita | 8 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ResponsabilitaAccrediaStorico | DataFineValidita | 9 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccredia | TipoUnitaOrganizzativaAccrediaId | 1 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoUnitaOrganizzativaAccredia | 0 |  -> .. | MS_Description = Chiave primaria del tipo di unità |
| Accreditamento | TipoUnitaOrganizzativaAccredia | Codice | 2 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice univoco del tipo di unità (es: LAB, DIR, UL-TECNICA) |
| Accreditamento | TipoUnitaOrganizzativaAccredia | Descrizione | 3 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione del tipo di unità secondo standard ACCREDIA |
| Accreditamento | TipoUnitaOrganizzativaAccredia | EsplicazioneMasNormativa | 4 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccredia | PuoAvereResponsabilita | 5 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag: questa unità può avere responsabilità tecniche e gestionali |
| Accreditamento | TipoUnitaOrganizzativaAccredia | PuoSvolgerAttivitaAccreditate | 6 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccredia | PuoAvereFunzioniTecniche | 7 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag: questa unità può avere funzioni tecniche specializzate |
| Accreditamento | TipoUnitaOrganizzativaAccredia | EsempreSottoAudit | 8 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag: questa unità è sempre soggetta a audit secondo le norme ACCREDIA |
| Accreditamento | TipoUnitaOrganizzativaAccredia | DataCreazione | 9 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Accreditamento | TipoUnitaOrganizzativaAccredia | DataModifica | 10 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Accreditamento | TipoUnitaOrganizzativaAccredia | DataInizioValidita | 11 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccredia | DataFineValidita | 12 | 0 | 2 | Accreditamento.TipoUnitaOrganizzativaAccrediaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | TipoUnitaOrganizzativaAccrediaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | EsplicazioneMasNormativa | 4 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | PuoAvereResponsabilita | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | PuoSvolgerAttivitaAccreditate | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | PuoAvereFunzioniTecniche | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | EsempreSottoAudit | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | DataCreazione | 9 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | DataModifica | 10 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | DataInizioValidita | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | TipoUnitaOrganizzativaAccrediaStorico | DataFineValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativa | ValidazioneNormativaId | 1 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | bigint |  | OBBLIGATORIO | NOT NULL | 1 | PK_ValidazioneNormativa | 0 |  -> .. | MS_Description = Chiave primaria della validazione |
| Accreditamento | ValidazioneNormativa | EntityType | 2 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Tipo di entità validata (es: ORGANIZZAZIONE, UNITA, RESPONSABILE, ATTIVITA) |
| Accreditamento | ValidazioneNormativa | EntityId | 3 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = ID dell'entità validata - utilizzato con EntityType per polimorfismo |
| Accreditamento | ValidazioneNormativa | Step | 4 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Step di validazione nel workflow (es: STEP_1_VERIFICA, STEP_2_REVISIONE, STEP_3_APPROVAZIONE) |
| Accreditamento | ValidazioneNormativa | Regola | 5 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Regola normativa applicata (es: ISO17011_PAR_6.2, NAB_REQ_COMPETENCE) |
| Accreditamento | ValidazioneNormativa | StatoValidazione | 6 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Stato della validazione (CONFORME, NON_CONFORME, CONDICIONATO, IN_REVISIONE) |
| Accreditamento | ValidazioneNormativa | Descrizione | 7 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativa | DettagliViolazione | 8 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativa | DataValidazione | 9 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativa | UtenteCheHaValidato | 10 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativa | DataInizioValidita | 11 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativa | DataFineValidita | 12 | 0 | 2 | Accreditamento.ValidazioneNormativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | ValidazioneNormativaId | 1 | 1 | 1 |  | bigint |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | EntityType | 2 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | EntityId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | Step | 4 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | Regola | 5 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | StatoValidazione | 6 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | Descrizione | 7 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | DettagliViolazione | 8 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | DataValidazione | 9 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | UtenteCheHaValidato | 10 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | DataInizioValidita | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Accreditamento | ValidazioneNormativaStorico | DataFineValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| dbo | Staging_GruppiIVA | PartitaIVA | 1 | 0 | 0 |  | nvarchar | 11 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_GruppiIVA | NumMembri | 2 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_GruppiIVA | CapogruppoId | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_GruppiIVA | DenominazioneGruppo | 4 | 0 | 0 |  | nvarchar | 4000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_GruppiIVA | DenominazioneCapogruppo | 5 | 0 | 0 |  | nvarchar | 550 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | CHIAVE | 1 | 0 | 0 |  | varchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | RagioneSociale | 2 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | Denominazione | 3 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | PartitaIVA | 4 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | CodiceFiscale | 5 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | NRegistroImprese | 6 | 0 | 0 |  | varchar | 21 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | TipoCodiceNaturaGiuridicaID | 7 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | StatoAttivitaId | 8 | 0 | 0 |  | tinyint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | OggettoSociale | 9 | 0 | 0 |  | varchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | DataIscrizioneRI | 10 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | DataCostituzione | 11 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | ORIGINE | 12 | 0 | 0 |  | varchar | 5 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | Staging_NuoveOrganizzazioni | CATEGORIA | 13 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | CHIAVE | 1 | 0 | 0 |  | varchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | Denominazione | 2 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | RagioneSociale | 3 | 0 | 0 |  | varchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | PartitaIVA | 4 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | CodiceFiscale | 5 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | NRegistroImprese | 6 | 0 | 0 |  | varchar | 21 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | TipoCodiceNaturaGiuridicaID | 7 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | NaturaGiuridica | 8 | 0 | 0 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | StatoAttivitaId | 9 | 0 | 0 |  | tinyint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | OggettoSociale | 10 | 0 | 0 |  | varchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | DataIscrizioneIscrizioneRI | 11 | 0 | 0 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | DataCostituzione | 12 | 0 | 0 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | TipoOrganizzazioneId | 13 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | ORIGINE | 14 | 0 | 0 |  | varchar | 5 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | CODICE_GAMMA | 15 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | CODICE_GIDAS | 16 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | CODICE_SIA | 17 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | CODICE_SIAT | 18 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | EmailPrincipale | 19 | 0 | 0 |  | varchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | SitoWebFlow | 20 | 0 | 0 |  | varchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | FaxFlow | 21 | 0 | 0 |  | varchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | NoteFlow | 22 | 0 | 0 |  | varchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | CATEGORIA | 23 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | TelefonoUL | 24 | 0 | 0 |  | varchar | 16 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | STG_Organizzazione_Flow | RN | 25 | 0 | 0 |  | bigint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | sysdiagrams | name | 1 | 0 | 0 |  | sysname |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | sysdiagrams | principal_id | 2 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | sysdiagrams | diagram_id | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__sysdiagr__C2B05B61FA37230F | 0 |  -> .. | (Nessuna proprietà) |
| dbo | sysdiagrams | version | 4 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | sysdiagrams | definition | 5 | 0 | 0 |  | varbinary | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | TableConstraintsMetadata | MetadataID | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__TableCon__66106FF92D8EA04C | 0 |  -> .. | (Nessuna proprietà) |
| dbo | TableConstraintsMetadata | SchemaName | 2 | 0 | 0 |  | nvarchar | 128 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | TableConstraintsMetadata | TableName | 3 | 0 | 0 |  | nvarchar | 128 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | TableConstraintsMetadata | OrderID | 4 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | TableConstraintsMetadata | ConstraintType | 5 | 0 | 0 |  | varchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | TableConstraintsMetadata | ConstraintName | 6 | 0 | 0 |  | nvarchar | 128 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | TableConstraintsMetadata | RecreateScript | 7 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| dbo | TableConstraintsMetadata | SavedDate | 8 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | __EFMigrationsHistory | MigrationId | 1 | 0 | 0 |  | nvarchar | 150 | OBBLIGATORIO | NOT NULL | 1 | PK___EFMigrationsHistory | 0 |  -> .. | (Nessuna proprietà) |
| Identity | __EFMigrationsHistory | ProductVersion | 2 | 0 | 0 |  | nvarchar | 32 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetRoleClaims | Id | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetRoleClaims | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetRoleClaims | RoleId | 2 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_AspNetRoleClaims_AspNetRoles_RoleId -> Identity.AspNetRoles.Id | (Nessuna proprietà) |
| Identity | AspNetRoleClaims | ClaimType | 3 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetRoleClaims | ClaimValue | 4 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetRoles | Id | 1 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetRoles | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetRoles | Name | 2 | 0 | 0 |  | nvarchar | 256 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetRoles | NormalizedName | 3 | 0 | 0 |  | nvarchar | 256 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetRoles | ConcurrencyStamp | 4 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserClaims | Id | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetUserClaims | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserClaims | UserId | 2 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_AspNetUserClaims_AspNetUsers_UserId -> Identity.AspNetUsers.Id | (Nessuna proprietà) |
| Identity | AspNetUserClaims | ClaimType | 3 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserClaims | ClaimValue | 4 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserLogins | LoginProvider | 1 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetUserLogins | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserLogins | ProviderKey | 2 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetUserLogins | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserLogins | ProviderDisplayName | 3 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserLogins | UserId | 4 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_AspNetUserLogins_AspNetUsers_UserId -> Identity.AspNetUsers.Id | (Nessuna proprietà) |
| Identity | AspNetUserRoles | UserId | 1 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetUserRoles | 1 | FK_AspNetUserRoles_AspNetUsers_UserId -> Identity.AspNetUsers.Id | (Nessuna proprietà) |
| Identity | AspNetUserRoles | RoleId | 2 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetUserRoles | 1 | FK_AspNetUserRoles_AspNetRoles_RoleId -> Identity.AspNetRoles.Id | (Nessuna proprietà) |
| Identity | AspNetUsers | Id | 1 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetUsers | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | UserName | 2 | 0 | 0 |  | nvarchar | 256 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | NormalizedUserName | 3 | 0 | 0 |  | nvarchar | 256 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | Email | 4 | 0 | 0 |  | nvarchar | 256 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | NormalizedEmail | 5 | 0 | 0 |  | nvarchar | 256 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | EmailConfirmed | 6 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | PasswordHash | 7 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | SecurityStamp | 8 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | ConcurrencyStamp | 9 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | PhoneNumber | 10 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | PhoneNumberConfirmed | 11 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | TwoFactorEnabled | 12 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | LockoutEnd | 13 | 0 | 0 |  | datetimeoffset | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | LockoutEnabled | 14 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUsers | AccessFailedCount | 15 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserTokens | UserId | 1 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetUserTokens | 1 | FK_AspNetUserTokens_AspNetUsers_UserId -> Identity.AspNetUsers.Id | (Nessuna proprietà) |
| Identity | AspNetUserTokens | LoginProvider | 2 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetUserTokens | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserTokens | Name | 3 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_AspNetUserTokens | 0 |  -> .. | (Nessuna proprietà) |
| Identity | AspNetUserTokens | Value | 4 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | PermissionId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_Permission | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | Code | 2 | 0 | 0 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | Description | 3 | 0 | 0 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | Module | 4 | 0 | 0 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | Scope | 5 | 0 | 0 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | Attivo | 6 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | CreatedAt | 7 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | CreatedBy | 8 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | UpdatedAt | 9 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | UpdatedBy | 10 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | DeletedAt | 11 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | DeletedBy | 12 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | Permission | IsDeleted | 13 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | RefreshToken | RefreshTokenId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_RefreshToken | 0 |  -> .. | (Nessuna proprietà) |
| Identity | RefreshToken | UserId | 2 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_RefreshToken_AspNetUsers_UserId -> Identity.AspNetUsers.Id | (Nessuna proprietà) |
| Identity | RefreshToken | Token | 3 | 0 | 0 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | RefreshToken | CreatedAt | 4 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | RefreshToken | ExpiresAt | 5 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | RefreshToken | RevokedAt | 6 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | RefreshToken | ReplacedByToken | 7 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Identity | RolePermission | RoleId | 1 | 0 | 0 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 1 | PK_RolePermission | 1 | FK_RolePermission_AspNetRoles_RoleId -> Identity.AspNetRoles.Id | (Nessuna proprietà) |
| Identity | RolePermission | PermissionId | 2 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_RolePermission | 1 | FK_RolePermission_Permission_PermissionId -> Identity.Permission.PermissionId | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | AssegnazioneIspettoreId | 1 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_AssegnazioneIspettore | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | GruppoVerificaId | 2 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_AssegnazioneIspettore_Gruppo -> Ispettori.GruppoVerifica.GruppoVerificaId | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | IspettoreId | 3 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_AssegnazioneIspettore_Ispettore -> Ispettori.Ispettore.IspettoreId | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | RuoloNelGruppo | 4 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | IsTeamLeader | 5 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | QualificaIspettoreId | 6 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | DataAssegnazione | 7 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | DataConferma | 8 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | DataPartecipazione | 9 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | StatoAssegnazione | 10 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | MotivoRifiuto | 11 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | ConflittoRilevato | 12 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | DescrizioneConflitto | 13 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | ConflittoRisolto | 14 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | OrePreventivate | 15 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | OreEffettive | 16 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | ValutazioneTeamLeader | 17 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | Note | 18 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | DataCreazione | 19 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | CreatoDa | 20 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | DataModifica | 21 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | ModificatoDa | 22 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | DataCancellazione | 23 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | CancellatoDa | 24 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | UniqueRowId | 25 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | DataInizioValidita | 26 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettore | DataFineValidita | 27 | 0 | 2 | Ispettori.AssegnazioneIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | AssegnazioneIspettoreId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | GruppoVerificaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | IspettoreId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | RuoloNelGruppo | 4 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | IsTeamLeader | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | QualificaIspettoreId | 6 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | DataAssegnazione | 7 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | DataConferma | 8 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | DataPartecipazione | 9 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | StatoAssegnazione | 10 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | MotivoRifiuto | 11 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | ConflittoRilevato | 12 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | DescrizioneConflitto | 13 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | ConflittoRisolto | 14 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | OrePreventivate | 15 | 1 | 1 |  | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | OreEffettive | 16 | 1 | 1 |  | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | ValutazioneTeamLeader | 17 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | Note | 18 | 1 | 1 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | DataCreazione | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | CreatoDa | 20 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | DataModifica | 21 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | ModificatoDa | 22 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | DataCancellazione | 23 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | CancellatoDa | 24 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | UniqueRowId | 25 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | DataInizioValidita | 26 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | AssegnazioneIspettoreStorico | DataFineValidita | 27 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | DisponibilitaIspettoreId | 1 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_DisponibilitaIspettore | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | IspettoreId | 2 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_DisponibilitaIspettore_Ispettore -> Ispettori.Ispettore.IspettoreId | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | DataInizio | 3 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | DataFine | 4 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | TipoDisponibilita | 5 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | Motivo | 6 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | GiorniSettimanaDisponibili | 7 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | OreGiornaliereMax | 8 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | Note | 9 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | DataCreazione | 10 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | CreatoDa | 11 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | DataModifica | 12 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | ModificatoDa | 13 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | DataCancellazione | 14 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | CancellatoDa | 15 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | UniqueRowId | 16 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | DataInizioValidita | 17 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettore | DataFineValidita | 18 | 0 | 2 | Ispettori.DisponibilitaIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | DisponibilitaIspettoreId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | IspettoreId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | DataInizio | 3 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | DataFine | 4 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | TipoDisponibilita | 5 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | Motivo | 6 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | GiorniSettimanaDisponibili | 7 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | OreGiornaliereMax | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | Note | 9 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | DataCreazione | 10 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | CreatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | DataModifica | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | ModificatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | DataCancellazione | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | CancellatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | UniqueRowId | 16 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | DataInizioValidita | 17 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | DisponibilitaIspettoreStorico | DataFineValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | GruppoVerificaId | 1 | 0 | 2 | Ispettori.GruppoVerificaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_GruppoVerifica | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | VisitaIspettivaId | 2 | 0 | 2 | Ispettori.GruppoVerificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | OrganismoAccreditatoId | 3 | 0 | 2 | Ispettori.GruppoVerificaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DipartimentoAccreditaId | 4 | 0 | 2 | Ispettori.GruppoVerificaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_GruppoVerifica_Dipartimento -> Tipologica.DipartimentoAccredia.DipartimentoAccreditaId | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | CodiceGruppo | 5 | 0 | 2 | Ispettori.GruppoVerificaStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DataCostituzione | 6 | 0 | 2 | Ispettori.GruppoVerificaStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DataVerifica | 7 | 0 | 2 | Ispettori.GruppoVerificaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DataFineVerifica | 8 | 0 | 2 | Ispettori.GruppoVerificaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | TipoVerifica | 9 | 0 | 2 | Ispettori.GruppoVerificaStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | ModalitaVerifica | 10 | 0 | 2 | Ispettori.GruppoVerificaStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | TeamLeaderId | 11 | 0 | 2 | Ispettori.GruppoVerificaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_GruppoVerifica_TeamLeader -> Ispettori.Ispettore.IspettoreId | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | StatoGruppo | 12 | 0 | 2 | Ispettori.GruppoVerificaStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | ConflittiVerificati | 13 | 0 | 2 | Ispettori.GruppoVerificaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DataVerificaConflitti | 14 | 0 | 2 | Ispettori.GruppoVerificaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | VerificaConflittiDa | 15 | 0 | 2 | Ispettori.GruppoVerificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | Note | 16 | 0 | 2 | Ispettori.GruppoVerificaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | NoteInterne | 17 | 0 | 2 | Ispettori.GruppoVerificaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DataCreazione | 18 | 0 | 2 | Ispettori.GruppoVerificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | CreatoDa | 19 | 0 | 2 | Ispettori.GruppoVerificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DataModifica | 20 | 0 | 2 | Ispettori.GruppoVerificaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | ModificatoDa | 21 | 0 | 2 | Ispettori.GruppoVerificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DataCancellazione | 22 | 0 | 2 | Ispettori.GruppoVerificaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | CancellatoDa | 23 | 0 | 2 | Ispettori.GruppoVerificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | UniqueRowId | 24 | 0 | 2 | Ispettori.GruppoVerificaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DataInizioValidita | 25 | 0 | 2 | Ispettori.GruppoVerificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerifica | DataFineValidita | 26 | 0 | 2 | Ispettori.GruppoVerificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | GruppoVerificaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | VisitaIspettivaId | 2 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | OrganismoAccreditatoId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DipartimentoAccreditaId | 4 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | CodiceGruppo | 5 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DataCostituzione | 6 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DataVerifica | 7 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DataFineVerifica | 8 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | TipoVerifica | 9 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | ModalitaVerifica | 10 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | TeamLeaderId | 11 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | StatoGruppo | 12 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | ConflittiVerificati | 13 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DataVerificaConflitti | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | VerificaConflittiDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | Note | 16 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | NoteInterne | 17 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DataCreazione | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | CreatoDa | 19 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DataModifica | 20 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | ModificatoDa | 21 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DataCancellazione | 22 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | CancellatoDa | 23 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | UniqueRowId | 24 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DataInizioValidita | 25 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | GruppoVerificaStorico | DataFineValidita | 26 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | IspettoreId | 1 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_Ispettore | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | CodiceIspettore | 2 | 0 | 2 | Ispettori.IspettoreStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | PersonaId | 3 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Ispettore_Persona -> Persone.Persona.PersonaId | (Nessuna proprietà) |
| Ispettori | Ispettore | IsIspettoreInterno | 4 | 0 | 2 | Ispettori.IspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | IncaricoId | 5 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Ispettore_Incarico -> Organizzazioni.Incarico.IncaricoId | (Nessuna proprietà) |
| Ispettori | Ispettore | DatoreLavoroOrganizzazioneId | 6 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Ispettore_DatoreLavoro -> Organizzazioni.Organizzazione.OrganizzazioneId | (Nessuna proprietà) |
| Ispettori | Ispettore | TipoRapportoLavoro | 7 | 0 | 2 | Ispettori.IspettoreStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | TipoRuoloIspettoreId | 8 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Ispettore_TipoRuolo -> Tipologica.TipoRuoloIspettore.TipoRuoloIspettoreId | (Nessuna proprietà) |
| Ispettori | Ispettore | StatoIspettoreId | 9 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Ispettore_Stato -> Tipologica.StatoIspettore.StatoIspettoreId | (Nessuna proprietà) |
| Ispettori | Ispettore | DataQualifica | 10 | 0 | 2 | Ispettori.IspettoreStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataPrimaQualifica | 11 | 0 | 2 | Ispettori.IspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataUltimoRinnovo | 12 | 0 | 2 | Ispettori.IspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataScadenzaQualifica | 13 | 0 | 2 | Ispettori.IspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | NumeroConvenzione | 14 | 0 | 2 | Ispettori.IspettoreStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataFirmaConvenzione | 15 | 0 | 2 | Ispettori.IspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataScadenzaConvenzione | 16 | 0 | 2 | Ispettori.IspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | TariffaGiornaliera | 17 | 0 | 2 | Ispettori.IspettoreStorico | decimal | 10,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | IBAN | 18 | 0 | 2 | Ispettori.IspettoreStorico | nvarchar | 34 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DisponibilitaMensile | 19 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | ZonaGeograficaPreferita | 20 | 0 | 2 | Ispettori.IspettoreStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | Note | 21 | 0 | 2 | Ispettori.IspettoreStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataCreazione | 22 | 0 | 2 | Ispettori.IspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | CreatoDa | 23 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataModifica | 24 | 0 | 2 | Ispettori.IspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | ModificatoDa | 25 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataCancellazione | 26 | 0 | 2 | Ispettori.IspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | CancellatoDa | 27 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | UniqueRowId | 28 | 0 | 2 | Ispettori.IspettoreStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataInizioValidita | 29 | 0 | 2 | Ispettori.IspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DataFineValidita | 30 | 0 | 2 | Ispettori.IspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | Ispettore | DipendenteId | 31 | 0 | 2 | Ispettori.IspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Ispettore_Dipendente -> RisorseUmane.Dipendente.DipendenteId | Accredia.Doc = Collegamento a RisorseUmane.Dipendente per ispettori interni. Sostituisce il precedente IncaricoId. Permette di accedere a tutti i dati HR del dipendente (matricola, contratto, formazione). Il check constraint CK_Ispettore_InternoEsterno garantisce che sia valorizzato solo per IsIspettoreInterno=TRUE. \| MS_Description = FK verso RisorseUmane.Dipendente. Obbligatorio per ispettori INTERNI. |
| Ispettori | IspettoreDipartimento | IspettoreDipartimentoId | 1 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_IspettoreDipartimento | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | IspettoreId | 2 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_IspDip_Ispettore -> Ispettori.Ispettore.IspettoreId | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | DipartimentoAccreditaId | 3 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_IspDip_Dipartimento -> Tipologica.DipartimentoAccredia.DipartimentoAccreditaId | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | StatoNelDipartimento | 4 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | DataInizioCollaborazione | 5 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | DataFineCollaborazione | 6 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | NumeroConvenzione | 7 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | DataFirmaConvenzione | 8 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | IsDipartimentoPrincipale | 9 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | TariffaGiornaliera | 10 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | decimal | 10,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | Note | 11 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | DataCreazione | 12 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | CreatoDa | 13 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | DataModifica | 14 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | ModificatoDa | 15 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | DataCancellazione | 16 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | CancellatoDa | 17 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | UniqueRowId | 18 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | DataInizioValidita | 19 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimento | DataFineValidita | 20 | 0 | 2 | Ispettori.IspettoreDipartimentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | IspettoreDipartimentoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | IspettoreId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | DipartimentoAccreditaId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | StatoNelDipartimento | 4 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | DataInizioCollaborazione | 5 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | DataFineCollaborazione | 6 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | NumeroConvenzione | 7 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | DataFirmaConvenzione | 8 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | IsDipartimentoPrincipale | 9 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | TariffaGiornaliera | 10 | 1 | 1 |  | decimal | 10,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | Note | 11 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | DataCreazione | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | CreatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | DataModifica | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | ModificatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | DataCancellazione | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | CancellatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | UniqueRowId | 18 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | DataInizioValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreDipartimentoStorico | DataFineValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | IspettoreId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | CodiceIspettore | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | PersonaId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | IsIspettoreInterno | 4 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | IncaricoId | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DatoreLavoroOrganizzazioneId | 6 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | TipoRapportoLavoro | 7 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | TipoRuoloIspettoreId | 8 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | StatoIspettoreId | 9 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataQualifica | 10 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataPrimaQualifica | 11 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataUltimoRinnovo | 12 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataScadenzaQualifica | 13 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | NumeroConvenzione | 14 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataFirmaConvenzione | 15 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataScadenzaConvenzione | 16 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | TariffaGiornaliera | 17 | 1 | 1 |  | decimal | 10,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | IBAN | 18 | 1 | 1 |  | nvarchar | 34 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DisponibilitaMensile | 19 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | ZonaGeograficaPreferita | 20 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | Note | 21 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataCreazione | 22 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | CreatoDa | 23 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataModifica | 24 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | ModificatoDa | 25 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataCancellazione | 26 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | CancellatoDa | 27 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | UniqueRowId | 28 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataInizioValidita | 29 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DataFineValidita | 30 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | IspettoreStorico | DipendenteId | 31 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | MonitoraggioIspettoreId | 1 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_MonitoraggioIspettore | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | IspettoreId | 2 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_MonitoraggioIspettore_Ispettore -> Ispettori.Ispettore.IspettoreId | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | VisitaIspettivaId | 3 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | OrganismoAccreditatoId | 4 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | TipoMonitoraggio | 5 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DataMonitoraggio | 6 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | ValutatoreId | 7 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | RuoloValutatore | 8 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | EsitoMonitoraggioId | 9 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_MonitoraggioIspettore_Esito -> Tipologica.EsitoMonitoraggio.EsitoMonitoraggioId | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | PunteggioComplessivo | 10 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | ValutazioneCompetenzaTecnica | 11 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | ValutazioneCompetenzaSistema | 12 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | ValutazioneConduzione | 13 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | ValutazioneDocumentazione | 14 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | ValutazioneRelazioneCab | 15 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | ValutazioneRispettoTempi | 16 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | PuntiForza | 17 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | AreeMiglioramento | 18 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | RaccomandazioniFormazione | 19 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | RichiedeAzioneCorrettiva | 20 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DescrizioneAzioneCorrettiva | 21 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DataScadenzaAzione | 22 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | AzioneCompletata | 23 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DataCompletamentoAzione | 24 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | ConfermaQualifica | 25 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DataProssimoMonitoraggio | 26 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | RapportoAllegato | 27 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | RiferimentoRapporto | 28 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | Note | 29 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | NoteRiservate | 30 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DataCreazione | 31 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | CreatoDa | 32 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DataModifica | 33 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | ModificatoDa | 34 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DataCancellazione | 35 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | CancellatoDa | 36 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | UniqueRowId | 37 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DataInizioValidita | 38 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettore | DataFineValidita | 39 | 0 | 2 | Ispettori.MonitoraggioIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | MonitoraggioIspettoreId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | IspettoreId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | VisitaIspettivaId | 3 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | OrganismoAccreditatoId | 4 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | TipoMonitoraggio | 5 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DataMonitoraggio | 6 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | ValutatoreId | 7 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | RuoloValutatore | 8 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | EsitoMonitoraggioId | 9 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | PunteggioComplessivo | 10 | 1 | 1 |  | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | ValutazioneCompetenzaTecnica | 11 | 1 | 1 |  | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | ValutazioneCompetenzaSistema | 12 | 1 | 1 |  | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | ValutazioneConduzione | 13 | 1 | 1 |  | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | ValutazioneDocumentazione | 14 | 1 | 1 |  | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | ValutazioneRelazioneCab | 15 | 1 | 1 |  | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | ValutazioneRispettoTempi | 16 | 1 | 1 |  | decimal | 3,1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | PuntiForza | 17 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | AreeMiglioramento | 18 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | RaccomandazioniFormazione | 19 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | RichiedeAzioneCorrettiva | 20 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DescrizioneAzioneCorrettiva | 21 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DataScadenzaAzione | 22 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | AzioneCompletata | 23 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DataCompletamentoAzione | 24 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | ConfermaQualifica | 25 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DataProssimoMonitoraggio | 26 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | RapportoAllegato | 27 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | RiferimentoRapporto | 28 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | Note | 29 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | NoteRiservate | 30 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DataCreazione | 31 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | CreatoDa | 32 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DataModifica | 33 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | ModificatoDa | 34 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DataCancellazione | 35 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | CancellatoDa | 36 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | UniqueRowId | 37 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DataInizioValidita | 38 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Ispettori | MonitoraggioIspettoreStorico | DataFineValidita | 39 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | ConformitaTabellaId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__Conformi__D5B0050A963C1445 | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | NomeSchema | 2 | 0 | 0 |  | nvarchar | 128 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | NomeTabella | 3 | 0 | 0 |  | nvarchar | 128 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | IsConforme | 4 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | DataUltimaVerifica | 5 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | ErroriConformita | 6 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | NumeroErrori | 7 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | DataCreazioneTabellaDB | 8 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | DataModificaTabellaDB | 9 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | DataCreazione | 10 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | CreatoDa | 11 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | ConformitaTabella | UniqueRowId | 12 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | RegolaConformitaId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__RegolaCo__E24F2B79E53644B7 | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | Categoria | 2 | 0 | 0 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | NomeRegola | 3 | 0 | 0 |  | nvarchar | 128 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | Descrizione | 4 | 0 | 0 |  | nvarchar | MAX | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | CampoSchema | 5 | 0 | 0 |  | nvarchar | 128 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | TipoDato | 6 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | DefaultValue | 7 | 0 | 0 |  | nvarchar | 255 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | IsNullable | 8 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | IsComputed | 9 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | ComputedFormula | 10 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | Obbligatorio | 11 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | ApplicazioneCondizione | 12 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | SourceScript | 13 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | NoteImplementazione | 14 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | DataCreazione | 15 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | CreatoDa | 16 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | DataModifica | 17 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | ModificatoDa | 18 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | DataCancellazione | 19 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | CancellatoDa | 20 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| metadata | RegolaConformita | UniqueRowId | 21 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Organizzazioni | Competenza | CompetenzaId | 1 | 0 | 2 | Organizzazioni.CompetenzaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__Competen__75049DF05BE545F1 | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | CodiceCompetenza | 2 | 0 | 2 | Organizzazioni.CompetenzaStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | DescrizioneCompetenza | 3 | 0 | 2 | Organizzazioni.CompetenzaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | Principale | 4 | 0 | 2 | Organizzazioni.CompetenzaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | Attivo | 5 | 0 | 2 | Organizzazioni.CompetenzaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | Cancellato | 6 | 0 | 2 | Organizzazioni.CompetenzaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | Verificato | 7 | 0 | 2 | Organizzazioni.CompetenzaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | DataCreazione | 8 | 0 | 2 | Organizzazioni.CompetenzaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | CreatoDa | 9 | 0 | 2 | Organizzazioni.CompetenzaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | DataModifica | 10 | 0 | 2 | Organizzazioni.CompetenzaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | ModificatoDa | 11 | 0 | 2 | Organizzazioni.CompetenzaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | DataCancellazione | 12 | 0 | 2 | Organizzazioni.CompetenzaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | CancellatoDa | 13 | 0 | 2 | Organizzazioni.CompetenzaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | UniqueRowId | 14 | 0 | 2 | Organizzazioni.CompetenzaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | DataInizioValidita | 15 | 0 | 2 | Organizzazioni.CompetenzaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Competenza | DataFineValidita | 16 | 0 | 2 | Organizzazioni.CompetenzaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | CompetenzaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | CodiceCompetenza | 2 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | DescrizioneCompetenza | 3 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | Principale | 4 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | Attivo | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | Cancellato | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | Verificato | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | DataCreazione | 8 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | CreatoDa | 9 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | DataModifica | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | ModificatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | DataCancellazione | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | CancellatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | UniqueRowId | 14 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | DataInizioValidita | 15 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | CompetenzaStorico | DataFineValidita | 16 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativa | ContattoId | 1 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__Contatto__22C8CDF6DBE1FD6E | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativa | UnitaOrganizzativaId | 2 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_ContattoUnitaOrganizzativa_UnitaOrganizzativa -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = Chiave esterna verso l'unità organizzativa |
| Organizzazioni | ContattoUnitaOrganizzativa | TipoContattoId | 3 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_ContattoUnitaOrganizzativa_TipoContatto -> Tipologica.TipoContatto.TipoContattoId | MS_Description = Chiave esterna tipo contatto |
| Organizzazioni | ContattoUnitaOrganizzativa | Valore | 4 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Valore contatto |
| Organizzazioni | ContattoUnitaOrganizzativa | ValoreSecondario | 5 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Valore secondario |
| Organizzazioni | ContattoUnitaOrganizzativa | Descrizione | 6 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | nvarchar | 250 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativa | Note | 7 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativa | DataInizio | 8 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativa | DataFine | 9 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativa | Principale | 10 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag principale |
| Organizzazioni | ContattoUnitaOrganizzativa | OrdinePriorita | 11 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Ordine priorità |
| Organizzazioni | ContattoUnitaOrganizzativa | IsVerificato | 12 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag verificato |
| Organizzazioni | ContattoUnitaOrganizzativa | DataVerifica | 13 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativa | IsPubblico | 14 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag pubblico |
| Organizzazioni | ContattoUnitaOrganizzativa | DataCreazione | 15 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Organizzazioni | ContattoUnitaOrganizzativa | CreatoDa | 16 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha creato il record |
| Organizzazioni | ContattoUnitaOrganizzativa | DataModifica | 17 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Organizzazioni | ContattoUnitaOrganizzativa | ModificatoDa | 18 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha modificato il record |
| Organizzazioni | ContattoUnitaOrganizzativa | DataCancellazione | 19 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Organizzazioni | ContattoUnitaOrganizzativa | CancellatoDa | 20 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha cancellato il record |
| Organizzazioni | ContattoUnitaOrganizzativa | UniqueRowId | 21 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = GUID univoco del record |
| Organizzazioni | ContattoUnitaOrganizzativa | DataInizioValidita | 22 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativa | DataFineValidita | 23 | 0 | 2 | Organizzazioni.ContattoUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | ContattoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | UnitaOrganizzativaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | TipoContattoId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | Valore | 4 | 1 | 1 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | ValoreSecondario | 5 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | Descrizione | 6 | 1 | 1 |  | nvarchar | 250 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | Note | 7 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | DataInizio | 8 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | DataFine | 9 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | Principale | 10 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | OrdinePriorita | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | IsVerificato | 12 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | DataVerifica | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | IsPubblico | 14 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | DataCreazione | 15 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | CreatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | DataModifica | 17 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | ModificatoDa | 18 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | DataCancellazione | 19 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | CancellatoDa | 20 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | UniqueRowId | 21 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | DataInizioValidita | 22 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | ContattoUnitaOrganizzativaStorico | DataFineValidita | 23 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | GruppoIVAId | 1 | 0 | 2 | Organizzazioni.GruppoIVAStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_GruppoIVA | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | PartitaIVAGruppo | 2 | 0 | 2 | Organizzazioni.GruppoIVAStorico | nvarchar | 11 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | Denominazione | 3 | 0 | 2 | Organizzazioni.GruppoIVAStorico | nvarchar | 255 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | CodiceGruppo | 4 | 0 | 2 | Organizzazioni.GruppoIVAStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | DataCostituzione | 5 | 0 | 2 | Organizzazioni.GruppoIVAStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | DataApprovazione | 6 | 0 | 2 | Organizzazioni.GruppoIVAStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | ProtocolloAgenziaEntrate | 7 | 0 | 2 | Organizzazioni.GruppoIVAStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | NumeroProvvedimento | 8 | 0 | 2 | Organizzazioni.GruppoIVAStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | StatoGruppo | 9 | 0 | 2 | Organizzazioni.GruppoIVAStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | DataCessazione | 10 | 0 | 2 | Organizzazioni.GruppoIVAStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | MotivoCessazione | 11 | 0 | 2 | Organizzazioni.GruppoIVAStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | OrganizzazioneCapogruppoId | 12 | 0 | 2 | Organizzazioni.GruppoIVAStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_GruppoIVA_OrganizzazioneCapogruppo -> Organizzazioni.Organizzazione.OrganizzazioneId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | Note | 13 | 0 | 2 | Organizzazioni.GruppoIVAStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | DocumentazioneRiferimento | 14 | 0 | 2 | Organizzazioni.GruppoIVAStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | DataCreazione | 15 | 0 | 2 | Organizzazioni.GruppoIVAStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | CreatoDa | 16 | 0 | 2 | Organizzazioni.GruppoIVAStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | DataModifica | 17 | 0 | 2 | Organizzazioni.GruppoIVAStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | ModificatoDa | 18 | 0 | 2 | Organizzazioni.GruppoIVAStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | DataCancellazione | 19 | 0 | 2 | Organizzazioni.GruppoIVAStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | CancellatoDa | 20 | 0 | 2 | Organizzazioni.GruppoIVAStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | UniqueRowId | 21 | 0 | 2 | Organizzazioni.GruppoIVAStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | DataInizioValidita | 22 | 0 | 2 | Organizzazioni.GruppoIVAStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVA | DataFineValidita | 23 | 0 | 2 | Organizzazioni.GruppoIVAStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | GruppoIVAMembroId | 1 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_GruppoIVAMembri | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | GruppoIVAId | 2 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_GruppoIVAMembri_GruppoIVA -> Organizzazioni.GruppoIVA.GruppoIVAId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | OrganizzazioneId | 3 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_GruppoIVAMembri_Organizzazione -> Organizzazioni.Organizzazione.OrganizzazioneId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | DataAdesione | 4 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | DataUscita | 5 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | MotivoUscita | 6 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | ProtocolloUscita | 7 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | IsCapogruppo | 8 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | RuoloNelGruppo | 9 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | PercentualePartecipazione | 10 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | StatoMembro | 11 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | Note | 12 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | DataCreazione | 13 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | CreatoDa | 14 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | DataModifica | 15 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | ModificatoDa | 16 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | DataCancellazione | 17 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | CancellatoDa | 18 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | UniqueRowId | 19 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | DataInizioValidita | 20 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembri | DataFineValidita | 21 | 0 | 2 | Organizzazioni.GruppoIVAMembriStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | GruppoIVAMembroId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | GruppoIVAId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | OrganizzazioneId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | DataAdesione | 4 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | DataUscita | 5 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | MotivoUscita | 6 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | ProtocolloUscita | 7 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | IsCapogruppo | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | RuoloNelGruppo | 9 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | PercentualePartecipazione | 10 | 1 | 1 |  | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | StatoMembro | 11 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | Note | 12 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | DataCreazione | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | CreatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | DataModifica | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | ModificatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | DataCancellazione | 17 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | CancellatoDa | 18 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | UniqueRowId | 19 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | DataInizioValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAMembriStorico | DataFineValidita | 21 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | GruppoIVAId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | PartitaIVAGruppo | 2 | 1 | 1 |  | nvarchar | 11 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | Denominazione | 3 | 1 | 1 |  | nvarchar | 255 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | CodiceGruppo | 4 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | DataCostituzione | 5 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | DataApprovazione | 6 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | ProtocolloAgenziaEntrate | 7 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | NumeroProvvedimento | 8 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | StatoGruppo | 9 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | DataCessazione | 10 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | MotivoCessazione | 11 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | OrganizzazioneCapogruppoId | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | Note | 13 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | DocumentazioneRiferimento | 14 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | DataCreazione | 15 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | CreatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | DataModifica | 17 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | ModificatoDa | 18 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | DataCancellazione | 19 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | CancellatoDa | 20 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | UniqueRowId | 21 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | DataInizioValidita | 22 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | GruppoIVAStorico | DataFineValidita | 23 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | IncaricoId | 1 | 0 | 2 | Organizzazioni.IncaricoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_Incarico | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | PersonaId | 2 | 0 | 2 | Organizzazioni.IncaricoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Incarico_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | TipoRuoloId | 3 | 0 | 2 | Organizzazioni.IncaricoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Incarico_TipoRuolo -> Tipologica.TipoRuolo.TipoRuoloId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | OrganizzazioneId | 4 | 0 | 2 | Organizzazioni.IncaricoStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Incarico_Organizzazione -> Organizzazioni.Organizzazione.OrganizzazioneId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | UnitaOrganizzativaId | 5 | 0 | 2 | Organizzazioni.IncaricoStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Incarico_UnitaOrganizzativa -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DataInizio | 6 | 0 | 2 | Organizzazioni.IncaricoStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DataFine | 7 | 0 | 2 | Organizzazioni.IncaricoStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | FonteNomina | 8 | 0 | 2 | Organizzazioni.IncaricoStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DataDelibera | 9 | 0 | 2 | Organizzazioni.IncaricoStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | NumeroAtto | 10 | 0 | 2 | Organizzazioni.IncaricoStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | NotaioRogante | 11 | 0 | 2 | Organizzazioni.IncaricoStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | RepertorioNotarile | 12 | 0 | 2 | Organizzazioni.IncaricoStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | StatoIncarico | 13 | 0 | 2 | Organizzazioni.IncaricoStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | MotivoCessazione | 14 | 0 | 2 | Organizzazioni.IncaricoStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DescrizioneEstesa | 15 | 0 | 2 | Organizzazioni.IncaricoStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | IsAdInterim | 16 | 0 | 2 | Organizzazioni.IncaricoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | IncaricoSostituitoId | 17 | 0 | 2 | Organizzazioni.IncaricoStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Incarico_IncaricoSostituito -> Organizzazioni.Incarico.IncaricoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | ProtocolloCCIAA | 18 | 0 | 2 | Organizzazioni.IncaricoStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DataComunicazioneCCIAA | 19 | 0 | 2 | Organizzazioni.IncaricoStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | Note | 20 | 0 | 2 | Organizzazioni.IncaricoStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DataCreazione | 21 | 0 | 2 | Organizzazioni.IncaricoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | CreatoDa | 22 | 0 | 2 | Organizzazioni.IncaricoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DataModifica | 23 | 0 | 2 | Organizzazioni.IncaricoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | ModificatoDa | 24 | 0 | 2 | Organizzazioni.IncaricoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DataCancellazione | 25 | 0 | 2 | Organizzazioni.IncaricoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | CancellatoDa | 26 | 0 | 2 | Organizzazioni.IncaricoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | UniqueRowId | 27 | 0 | 2 | Organizzazioni.IncaricoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DataInizioValidita | 28 | 0 | 2 | Organizzazioni.IncaricoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Incarico | DataFineValidita | 29 | 0 | 2 | Organizzazioni.IncaricoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | IncaricoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | PersonaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | TipoRuoloId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | OrganizzazioneId | 4 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | UnitaOrganizzativaId | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DataInizio | 6 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DataFine | 7 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | FonteNomina | 8 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DataDelibera | 9 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | NumeroAtto | 10 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | NotaioRogante | 11 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | RepertorioNotarile | 12 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | StatoIncarico | 13 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | MotivoCessazione | 14 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DescrizioneEstesa | 15 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | IsAdInterim | 16 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | IncaricoSostituitoId | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | ProtocolloCCIAA | 18 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DataComunicazioneCCIAA | 19 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | Note | 20 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DataCreazione | 21 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | CreatoDa | 22 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DataModifica | 23 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | ModificatoDa | 24 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DataCancellazione | 25 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | CancellatoDa | 26 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | UniqueRowId | 27 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DataInizioValidita | 28 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IncaricoStorico | DataFineValidita | 29 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativa | IndirizzoId | 1 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__Indirizz__2918148313C85B62 | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativa | UnitaOrganizzativaId | 2 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_IndirizzoUnitaOrganizzativa_UnitaOrganizzativa -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = Chiave esterna verso l'unità organizzativa |
| Organizzazioni | IndirizzoUnitaOrganizzativa | TipoIndirizzoId | 3 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_IndirizzoUnitaOrganizzativa_TipoIndirizzo -> Tipologica.TipoIndirizzo.TipoIndirizzoId | MS_Description = Chiave esterna tipo indirizzo |
| Organizzazioni | IndirizzoUnitaOrganizzativa | ComuneId | 4 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativa | Indirizzo | 5 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | nvarchar | 250 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Via/Piazza |
| Organizzazioni | IndirizzoUnitaOrganizzativa | NumeroCivico | 6 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Numero civico |
| Organizzazioni | IndirizzoUnitaOrganizzativa | CAP | 7 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | nvarchar | 5 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Codice postale |
| Organizzazioni | IndirizzoUnitaOrganizzativa | Localita | 8 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Comune/Città |
| Organizzazioni | IndirizzoUnitaOrganizzativa | Presso | 9 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | nvarchar | 250 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativa | Latitudine | 10 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | decimal | 10,8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Latitudine GPS |
| Organizzazioni | IndirizzoUnitaOrganizzativa | Longitudine | 11 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | decimal | 11,8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Longitudine GPS |
| Organizzazioni | IndirizzoUnitaOrganizzativa | Piano | 12 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Piano |
| Organizzazioni | IndirizzoUnitaOrganizzativa | Interno | 13 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Interno/appartamento |
| Organizzazioni | IndirizzoUnitaOrganizzativa | Edificio | 14 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Nome edificio |
| Organizzazioni | IndirizzoUnitaOrganizzativa | ZonaIndustriale | 15 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | nvarchar | 150 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Zona industriale |
| Organizzazioni | IndirizzoUnitaOrganizzativa | DataInizio | 16 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativa | DataFine | 17 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativa | Principale | 18 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativa | DataCreazione | 19 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Organizzazioni | IndirizzoUnitaOrganizzativa | CreatoDa | 20 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha creato il record |
| Organizzazioni | IndirizzoUnitaOrganizzativa | DataModifica | 21 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Organizzazioni | IndirizzoUnitaOrganizzativa | ModificatoDa | 22 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha modificato il record |
| Organizzazioni | IndirizzoUnitaOrganizzativa | DataCancellazione | 23 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Organizzazioni | IndirizzoUnitaOrganizzativa | CancellatoDa | 24 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha cancellato il record |
| Organizzazioni | IndirizzoUnitaOrganizzativa | UniqueRowId | 25 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = GUID univoco del record |
| Organizzazioni | IndirizzoUnitaOrganizzativa | DataInizioValidita | 26 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativa | DataFineValidita | 27 | 0 | 2 | Organizzazioni.IndirizzoUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | IndirizzoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | UnitaOrganizzativaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | TipoIndirizzoId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | ComuneId | 4 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | Indirizzo | 5 | 1 | 1 |  | nvarchar | 250 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | NumeroCivico | 6 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | CAP | 7 | 1 | 1 |  | nvarchar | 5 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | Localita | 8 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | Presso | 9 | 1 | 1 |  | nvarchar | 250 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | Latitudine | 10 | 1 | 1 |  | decimal | 10,8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | Longitudine | 11 | 1 | 1 |  | decimal | 11,8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | Piano | 12 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | Interno | 13 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | Edificio | 14 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | ZonaIndustriale | 15 | 1 | 1 |  | nvarchar | 150 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | DataInizio | 16 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | DataFine | 17 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | Principale | 18 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | DataCreazione | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | CreatoDa | 20 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | DataModifica | 21 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | ModificatoDa | 22 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | DataCancellazione | 23 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | CancellatoDa | 24 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | UniqueRowId | 25 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | DataInizioValidita | 26 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | IndirizzoUnitaOrganizzativaStorico | DataFineValidita | 27 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Organizzazione | OrganizzazioneId | 1 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__Organizz__97166FFDA2E30765 | 0 |  -> .. | MS_Description = Chiave primaria dell'organizzazione |
| Organizzazioni | Organizzazione | EnteAccreditamentoId | 2 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Organizzazione_EnteAccreditamento -> Accreditamento.EnteAccreditamento.EnteAccreditamentoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Organizzazione | RagioneSociale | 3 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | nvarchar | 550 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Ragione sociale ufficiale |
| Organizzazioni | Organizzazione | Denominazione | 4 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | nvarchar | 550 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Denominazione commerciale |
| Organizzazioni | Organizzazione | PartitaIVA | 5 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | nvarchar | 11 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Partita IVA (identità fiscale nazionale). Può essere NULL per soggetti senza posizione IVA italiana. |
| Organizzazioni | Organizzazione | CodiceFiscale | 6 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | nvarchar | 16 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Codice Fiscale (identità giuridica/legale). Può coincidere con P.IVA solo in casi specifici (es. ditta individuale). |
| Organizzazioni | Organizzazione | NRegistroImprese | 7 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | nvarchar | 21 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Numero iscrizione Registro Imprese |
| Organizzazioni | Organizzazione | TipoCodiceNaturaGiuridicaID | 8 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Organizzazione_TipoCodiceNaturaGiuridica -> Tipologica.TipoCodiceNaturaGiuridica.TipoCodiceNaturaGiuridicaID | MS_Description = Chiave esterna verso Tipologica.TipoCodiceNaturaGiuridica (es: SRL, SPA, COOP) |
| Organizzazioni | Organizzazione | StatoAttivitaId | 9 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | tinyint |  | OPZIONALE | NULL | 0 |  | 1 | FK_Organizzazione_CodiceStatoAttivita -> Tipologica.CodiceStatoAttivita.CodiceStatoAttivitaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Organizzazione | OggettoSociale | 10 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Organizzazione | DataIscrizioneIscrizioneRI | 11 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Organizzazione | DataCostituzione | 12 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Organizzazione | TipoOrganizzazioneId | 13 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Organizzazione_TipoOrganizzazione -> Tipologica.TipoOrganizzazione.TipoOrganizzazioneId | MS_Description = [DEPRECATO] Tipo principale organizzazione. Usare OrganizzazioneTipoOrganizzazione per relazione N:N completa. |
| Organizzazioni | Organizzazione | DataCreazione | 14 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Organizzazioni | Organizzazione | CreatoDa | 15 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha creato il record |
| Organizzazioni | Organizzazione | DataModifica | 16 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Organizzazioni | Organizzazione | ModificatoDa | 17 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha modificato il record |
| Organizzazioni | Organizzazione | DataCancellazione | 18 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Organizzazioni | Organizzazione | CancellatoDa | 19 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha cancellato il record |
| Organizzazioni | Organizzazione | UniqueRowId | 20 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = GUID univoco del record |
| Organizzazioni | Organizzazione | DataInizioValidita | 21 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data di inizio validità temporale |
| Organizzazioni | Organizzazione | DataFineValidita | 22 | 0 | 2 | Organizzazioni.OrganizzazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data di fine validità temporale |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | OrganizzazioneIdentificativoFiscaleId | 1 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_OrganizzazioneIdentificativoFiscale | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | OrganizzazioneId | 2 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_OrgIdentFisc_Organizzazione -> Organizzazioni.Organizzazione.OrganizzazioneId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | PaeseISO2 | 3 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | nchar | 2 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice paese ISO 3166-1 alpha-2 (es. IT, DE, US). |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | TipoIdentificativo | 4 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Tipo identificativo (es. VAT, TIN, FISCAL_CODE, REGISTRY_ID). |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | Valore | 5 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Valore dell'identificativo fiscale/legale (formato variabile per paese). |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | Principale | 6 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | Note | 7 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | CreatoDa | 8 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | ModificatoDa | 9 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | DataCreazione | 10 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | DataModifica | 11 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | UniqueRowId | 12 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | DataInizioValidita | 13 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscale | DataFineValidita | 14 | 0 | 2 | Organizzazioni.OrganizzazioneIdentificativoFiscaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | OrganizzazioneIdentificativoFiscaleId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | OrganizzazioneId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | PaeseISO2 | 3 | 1 | 1 |  | nchar | 2 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | TipoIdentificativo | 4 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | Valore | 5 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | Principale | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | Note | 7 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | CreatoDa | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | DataCreazione | 10 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | DataModifica | 11 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneIdentificativoFiscaleStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | OrganizzazioneSedeId | 1 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__Organizz__5455BD6D3E0CAC84 | 0 |  -> .. | MS_Description = Chiave primaria della sede |
| Organizzazioni | OrganizzazioneSede | OrganizzazioneId | 2 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_OrganizzazioneSede_Organizzazione -> Organizzazioni.Organizzazione.OrganizzazioneId | MS_Description = Chiave esterna verso Organizzazione padre |
| Organizzazioni | OrganizzazioneSede | Progressivo | 3 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | smallint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | NIscrizioneREA | 4 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | nvarchar | 9 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Numero iscrizione nel Registro Economico Amministrativo (REA) della Camera di Commercio |
| Organizzazioni | OrganizzazioneSede | SiglaProvinciaREA | 5 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | nvarchar | 2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Sigla della provincia nel REA (es: MI, TO, RM) |
| Organizzazioni | OrganizzazioneSede | DataIscrizioneREA | 6 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | TipoOrganizzazioneSedeId | 7 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | tinyint |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_OrganizzazioneSede_TipoOrganizzazioneSede -> Tipologica.TipoOrganizzazioneSede.TipoOrganizzazioneSedeId | MS_Description = Chiave esterna verso Tipologica.TipoOrganizzazioneSede (es: PRINCIPALE, SECONDARIA, DEPOSITO) |
| Organizzazioni | OrganizzazioneSede | Denominazione | 8 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | Insegna | 9 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | DataApertura | 10 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | CodiceStatoAttivitaId | 11 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | nvarchar | 1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | DescrizioneAttivita | 12 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | DataInizioAttivita | 13 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | CodiceAttivitaISTAT | 14 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | nvarchar | 6 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | CodiceCausaleCessazione | 15 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | nvarchar | 8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | DataCessazioneUL | 16 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | DataDenunciaCessazione | 17 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | IndirizzoID | 18 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | bigint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | DataCreazione | 19 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Organizzazioni | OrganizzazioneSede | CreatoDa | 20 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha creato il record |
| Organizzazioni | OrganizzazioneSede | DataModifica | 21 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Organizzazioni | OrganizzazioneSede | ModificatoDa | 22 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha modificato il record |
| Organizzazioni | OrganizzazioneSede | DataCancellazione | 23 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Organizzazioni | OrganizzazioneSede | CancellatoDa | 24 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha cancellato il record |
| Organizzazioni | OrganizzazioneSede | UniqueRowId | 25 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = GUID univoco del record |
| Organizzazioni | OrganizzazioneSede | DataInizioValidita | 26 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSede | DataFineValidita | 27 | 0 | 2 | Organizzazioni.OrganizzazioneSedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | OrganizzazioneSedeId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | OrganizzazioneId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | Progressivo | 3 | 1 | 1 |  | smallint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | NIscrizioneREA | 4 | 1 | 1 |  | nvarchar | 9 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | SiglaProvinciaREA | 5 | 1 | 1 |  | nvarchar | 2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataIscrizioneREA | 6 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | TipoOrganizzazioneSedeId | 7 | 1 | 1 |  | tinyint |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | Denominazione | 8 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | Insegna | 9 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataApertura | 10 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | CodiceStatoAttivitaId | 11 | 1 | 1 |  | nvarchar | 1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DescrizioneAttivita | 12 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataInizioAttivita | 13 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | CodiceAttivitaISTAT | 14 | 1 | 1 |  | nvarchar | 6 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | CodiceCausaleCessazione | 15 | 1 | 1 |  | nvarchar | 8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataCessazioneUL | 16 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataDenunciaCessazione | 17 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | IndirizzoID | 18 | 1 | 1 |  | bigint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataCreazione | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | CreatoDa | 20 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataModifica | 21 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | ModificatoDa | 22 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataCancellazione | 23 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | CancellatoDa | 24 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | UniqueRowId | 25 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataInizioValidita | 26 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneSedeStorico | DataFineValidita | 27 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | OrganizzazioneId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | EnteAccreditamentoId | 2 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | RagioneSociale | 3 | 1 | 1 |  | nvarchar | 550 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | Denominazione | 4 | 1 | 1 |  | nvarchar | 550 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | PartitaIVA | 5 | 1 | 1 |  | nvarchar | 11 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | CodiceFiscale | 6 | 1 | 1 |  | nvarchar | 16 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | NRegistroImprese | 7 | 1 | 1 |  | nvarchar | 21 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | TipoCodiceNaturaGiuridicaID | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | StatoAttivitaId | 9 | 1 | 1 |  | tinyint |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | OggettoSociale | 10 | 1 | 1 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | DataIscrizioneIscrizioneRI | 11 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | DataCostituzione | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | TipoOrganizzazioneId | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | DataCreazione | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | CreatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | DataModifica | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | ModificatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | DataCancellazione | 18 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | CancellatoDa | 19 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | UniqueRowId | 20 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | DataInizioValidita | 21 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneStorico | DataFineValidita | 22 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | OrganizzazioneTipoId | 1 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_OrganizzazioneTipoOrganizzazione | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | OrganizzazioneId | 2 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_OrgTipoOrg_Organizzazione -> Organizzazioni.Organizzazione.OrganizzazioneId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | TipoOrganizzazioneId | 3 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_OrgTipoOrg_TipoOrganizzazione -> Tipologica.TipoOrganizzazione.TipoOrganizzazioneId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | DataAssegnazione | 4 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data di assegnazione della tipologia |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | DataRevoca | 5 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Data di revoca (NULL = ancora attiva) |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | MotivoRevoca | 6 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | Principale | 7 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag per indicare il tipo principale (utile per visualizzazione UI) |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | Note | 8 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | DataCreazione | 9 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | CreatoDa | 10 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | DataModifica | 11 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | ModificatoDa | 12 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | DataCancellazione | 13 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | CancellatoDa | 14 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | UniqueRowId | 15 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | DataInizioValidita | 16 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazione | DataFineValidita | 17 | 0 | 2 | Organizzazioni.OrganizzazioneTipoOrganizzazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | OrganizzazioneTipoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | OrganizzazioneId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | TipoOrganizzazioneId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | DataAssegnazione | 4 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | DataRevoca | 5 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | MotivoRevoca | 6 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | Principale | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | Note | 8 | 1 | 1 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | DataCreazione | 9 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | CreatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | DataModifica | 11 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | ModificatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | DataCancellazione | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | CancellatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | UniqueRowId | 15 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | DataInizioValidita | 16 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | OrganizzazioneTipoOrganizzazioneStorico | DataFineValidita | 17 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | PotereId | 1 | 0 | 2 | Organizzazioni.PotereStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_Potere | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | IncaricoId | 2 | 0 | 2 | Organizzazioni.PotereStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Potere_Incarico -> Organizzazioni.Incarico.IncaricoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | TipoPotereId | 3 | 0 | 2 | Organizzazioni.PotereStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Potere_TipoPotere -> Tipologica.TipoPotere.TipoPotereId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DataInizio | 4 | 0 | 2 | Organizzazioni.PotereStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DataFine | 5 | 0 | 2 | Organizzazioni.PotereStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | LimiteImportoSingolo | 6 | 0 | 2 | Organizzazioni.PotereStorico | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | LimiteImportoGiornaliero | 7 | 0 | 2 | Organizzazioni.PotereStorico | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | LimiteImportoMensile | 8 | 0 | 2 | Organizzazioni.PotereStorico | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | LimiteImportoAnnuo | 9 | 0 | 2 | Organizzazioni.PotereStorico | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | Valuta | 10 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 3 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | ModalitaFirma | 11 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | FirmaCongiuntaCon | 12 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | AmbitoTerritoriale | 13 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | AmbitoMateriale | 14 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | TipoOperazioniAmmesse | 15 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | PuoDelegare | 16 | 0 | 2 | Organizzazioni.PotereStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DelegatoDa | 17 | 0 | 2 | Organizzazioni.PotereStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Potere_DelegatoDa -> Organizzazioni.Potere.PotereId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | StatoPotere | 18 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DataRevoca | 19 | 0 | 2 | Organizzazioni.PotereStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | MotivoRevoca | 20 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | ProtocolloCCIAA | 21 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DataRegistrazioneCCIAA | 22 | 0 | 2 | Organizzazioni.PotereStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | NumeroRepertorioNotarile | 23 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | Note | 24 | 0 | 2 | Organizzazioni.PotereStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DataCreazione | 25 | 0 | 2 | Organizzazioni.PotereStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | CreatoDa | 26 | 0 | 2 | Organizzazioni.PotereStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DataModifica | 27 | 0 | 2 | Organizzazioni.PotereStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | ModificatoDa | 28 | 0 | 2 | Organizzazioni.PotereStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DataCancellazione | 29 | 0 | 2 | Organizzazioni.PotereStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | CancellatoDa | 30 | 0 | 2 | Organizzazioni.PotereStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | UniqueRowId | 31 | 0 | 2 | Organizzazioni.PotereStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DataInizioValidita | 32 | 0 | 2 | Organizzazioni.PotereStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Potere | DataFineValidita | 33 | 0 | 2 | Organizzazioni.PotereStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | PotereId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | IncaricoId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | TipoPotereId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DataInizio | 4 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DataFine | 5 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | LimiteImportoSingolo | 6 | 1 | 1 |  | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | LimiteImportoGiornaliero | 7 | 1 | 1 |  | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | LimiteImportoMensile | 8 | 1 | 1 |  | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | LimiteImportoAnnuo | 9 | 1 | 1 |  | decimal | 18,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | Valuta | 10 | 1 | 1 |  | nvarchar | 3 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | ModalitaFirma | 11 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | FirmaCongiuntaCon | 12 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | AmbitoTerritoriale | 13 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | AmbitoMateriale | 14 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | TipoOperazioniAmmesse | 15 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | PuoDelegare | 16 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DelegatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | StatoPotere | 18 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DataRevoca | 19 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | MotivoRevoca | 20 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | ProtocolloCCIAA | 21 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DataRegistrazioneCCIAA | 22 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | NumeroRepertorioNotarile | 23 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | Note | 24 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DataCreazione | 25 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | CreatoDa | 26 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DataModifica | 27 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | ModificatoDa | 28 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DataCancellazione | 29 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | CancellatoDa | 30 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | UniqueRowId | 31 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DataInizioValidita | 32 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | PotereStorico | DataFineValidita | 33 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | SedeId | 1 | 0 | 2 | Organizzazioni.SedeStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_Sede | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | OrganizzazioneId | 2 | 0 | 2 | Organizzazioni.SedeStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Sede_Organizzazione -> Organizzazioni.Organizzazione.OrganizzazioneId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | TipoSedeId | 3 | 0 | 2 | Organizzazioni.SedeStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Sede_TipoSede -> Tipologica.TipoSede.TipoSedeId | MS_Description = FK verso TipoSede (SEDE_LEGALE, SEDE_SECONDARIA, UNITA_LOCALE) |
| Organizzazioni | Sede | CodiceSede | 4 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Denominazione | 5 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Insegna | 6 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | NIscrizioneREA | 7 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 11 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | SiglaProvinciaREA | 8 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | DataIscrizioneREA | 9 | 0 | 2 | Organizzazioni.SedeStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Indirizzo | 10 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 250 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | NumeroCivico | 11 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | CAP | 12 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Localita | 13 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 150 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Provincia | 14 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | ComuneId | 15 | 0 | 2 | Organizzazioni.SedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Nazione | 16 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Latitudine | 17 | 0 | 2 | Organizzazioni.SedeStorico | decimal | 10,8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Longitudine | 18 | 0 | 2 | Organizzazioni.SedeStorico | decimal | 11,8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Piano | 19 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Interno | 20 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Edificio | 21 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | ZonaIndustriale | 22 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 150 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | Presso | 23 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 250 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | StatoSede | 24 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Stato operativo: ATTIVA, CESSATA, SOSPESA |
| Organizzazioni | Sede | DataApertura | 25 | 0 | 2 | Organizzazioni.SedeStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | DataCessazione | 26 | 0 | 2 | Organizzazioni.SedeStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | MotivoCessazione | 27 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | CodiceATECO | 28 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | DescrizioneAttivita | 29 | 0 | 2 | Organizzazioni.SedeStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | DataInizioAttivita | 30 | 0 | 2 | Organizzazioni.SedeStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | IsSedePrincipale | 31 | 0 | 2 | Organizzazioni.SedeStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = TRUE se è la sede principale dell organizzazione |
| Organizzazioni | Sede | IsSedeOperativa | 32 | 0 | 2 | Organizzazioni.SedeStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | DataCreazione | 33 | 0 | 2 | Organizzazioni.SedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | CreatoDa | 34 | 0 | 2 | Organizzazioni.SedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | DataModifica | 35 | 0 | 2 | Organizzazioni.SedeStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | ModificatoDa | 36 | 0 | 2 | Organizzazioni.SedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | DataCancellazione | 37 | 0 | 2 | Organizzazioni.SedeStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | CancellatoDa | 38 | 0 | 2 | Organizzazioni.SedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | UniqueRowId | 39 | 0 | 2 | Organizzazioni.SedeStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | DataInizioValidita | 40 | 0 | 2 | Organizzazioni.SedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | Sede | DataFineValidita | 41 | 0 | 2 | Organizzazioni.SedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | SedeId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | OrganizzazioneId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | TipoSedeId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | CodiceSede | 4 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Denominazione | 5 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Insegna | 6 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | NIscrizioneREA | 7 | 1 | 1 |  | nvarchar | 11 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | SiglaProvinciaREA | 8 | 1 | 1 |  | nvarchar | 2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DataIscrizioneREA | 9 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Indirizzo | 10 | 1 | 1 |  | nvarchar | 250 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | NumeroCivico | 11 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | CAP | 12 | 1 | 1 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Localita | 13 | 1 | 1 |  | nvarchar | 150 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Provincia | 14 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | ComuneId | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Nazione | 16 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Latitudine | 17 | 1 | 1 |  | decimal | 10,8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Longitudine | 18 | 1 | 1 |  | decimal | 11,8 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Piano | 19 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Interno | 20 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Edificio | 21 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | ZonaIndustriale | 22 | 1 | 1 |  | nvarchar | 150 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | Presso | 23 | 1 | 1 |  | nvarchar | 250 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | StatoSede | 24 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DataApertura | 25 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DataCessazione | 26 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | MotivoCessazione | 27 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | CodiceATECO | 28 | 1 | 1 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DescrizioneAttivita | 29 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DataInizioAttivita | 30 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | IsSedePrincipale | 31 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | IsSedeOperativa | 32 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DataCreazione | 33 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | CreatoDa | 34 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DataModifica | 35 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | ModificatoDa | 36 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DataCancellazione | 37 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | CancellatoDa | 38 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | UniqueRowId | 39 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DataInizioValidita | 40 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeStorico | DataFineValidita | 41 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | SedeUnitaOrganizzativaId | 1 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_SedeUnitaOrganizzativa | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | SedeId | 2 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_SedeUO_Sede -> Organizzazioni.Sede.SedeId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | UnitaOrganizzativaId | 3 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_SedeUO_UnitaOrganizzativa -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | RuoloOperativo | 4 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Ruolo operativo della UO in questa sede |
| Organizzazioni | SedeUnitaOrganizzativa | DescrizioneRuolo | 5 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | DataInizio | 6 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data inizio operatività della UO in questa sede |
| Organizzazioni | SedeUnitaOrganizzativa | DataFine | 7 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Data fine operatività (NULL = ancora attivo) |
| Organizzazioni | SedeUnitaOrganizzativa | Principale | 8 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | IsTemporanea | 9 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | PercentualeAttivita | 10 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | Note | 11 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | DataCreazione | 12 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | CreatoDa | 13 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | DataModifica | 14 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | ModificatoDa | 15 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | DataCancellazione | 16 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | CancellatoDa | 17 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | UniqueRowId | 18 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | DataInizioValidita | 19 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativa | DataFineValidita | 20 | 0 | 2 | Organizzazioni.SedeUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | SedeUnitaOrganizzativaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | SedeId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | UnitaOrganizzativaId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | RuoloOperativo | 4 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | DescrizioneRuolo | 5 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | DataInizio | 6 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | DataFine | 7 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | Principale | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | IsTemporanea | 9 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | PercentualeAttivita | 10 | 1 | 1 |  | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | Note | 11 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | DataCreazione | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | CreatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | DataModifica | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | ModificatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | DataCancellazione | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | CancellatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | UniqueRowId | 18 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | DataInizioValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | SedeUnitaOrganizzativaStorico | DataFineValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivita | UnitaAttivitaId | 1 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__UnitaAtt__3C52D790FDCF4D2D | 0 |  -> .. | MS_Description = Chiave primaria |
| Organizzazioni | UnitaAttivita | UnitaOrganizzativaId | 2 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_UnitaAttivita_UnitaOrganizzativa -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = Chiave esterna verso l'unità organizzativa |
| Organizzazioni | UnitaAttivita | CodiceATECORI | 3 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice ATECO |
| Organizzazioni | UnitaAttivita | DescrizioneAttivita | 4 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione attività |
| Organizzazioni | UnitaAttivita | Importanza | 5 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Importanza |
| Organizzazioni | UnitaAttivita | DataCreazione | 6 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Organizzazioni | UnitaAttivita | CreatoDa | 7 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha creato il record |
| Organizzazioni | UnitaAttivita | DataModifica | 8 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Organizzazioni | UnitaAttivita | ModificatoDa | 9 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha modificato il record |
| Organizzazioni | UnitaAttivita | DataCancellazione | 10 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Organizzazioni | UnitaAttivita | CancellatoDa | 11 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha cancellato il record |
| Organizzazioni | UnitaAttivita | UniqueRowId | 12 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = GUID univoco del record |
| Organizzazioni | UnitaAttivita | DataInizioValidita | 13 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivita | DataFineValidita | 14 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivita | DataInizioAttivita | 15 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivita | DataFineAttivita | 16 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivita | FonteDato | 17 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Fonte dati |
| Organizzazioni | UnitaAttivita | Note | 18 | 0 | 2 | Organizzazioni.UnitaAttivitaStorico | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | UnitaAttivitaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | UnitaOrganizzativaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | CodiceATECORI | 3 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | DescrizioneAttivita | 4 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | Importanza | 5 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | DataInizioAttivita | 15 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | DataFineAttivita | 16 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | FonteDato | 17 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaAttivitaStorico | Note | 18 | 1 | 1 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativa | UnitaOrganizzativaId | 1 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__UnitaOrg__551555E333834BBE | 0 |  -> .. | MS_Description = Chiave primaria dell'unità organizzativa |
| Organizzazioni | UnitaOrganizzativa | OrganizzazioneId | 2 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_UnitaOrganizzativa_Organizzazione -> Organizzazioni.Organizzazione.OrganizzazioneId | MS_Description = Chiave esterna verso l'organizzazione padre |
| Organizzazioni | UnitaOrganizzativa | TipoUnitaOrganizzativaId | 3 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_UnitaOrganizzativa_TipoUnitaOrganizzativa -> Tipologica.TipoUnitaOrganizzativa.TipoUnitaOrganizzativaId | MS_Description = Chiave esterna verso il tipo di unità organizzativa (lookup) |
| Organizzazioni | UnitaOrganizzativa | Nome | 4 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Nome dell'unità |
| Organizzazioni | UnitaOrganizzativa | NIscrizioneREA | 5 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | nvarchar | 11 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Numero iscrizione REA |
| Organizzazioni | UnitaOrganizzativa | Codice | 6 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | nvarchar | 150 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Codice interno |
| Organizzazioni | UnitaOrganizzativa | Principale | 7 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag principale |
| Organizzazioni | UnitaOrganizzativa | DataCreazione | 8 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Organizzazioni | UnitaOrganizzativa | CreatoDa | 9 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha creato il record |
| Organizzazioni | UnitaOrganizzativa | DataModifica | 10 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Organizzazioni | UnitaOrganizzativa | ModificatoDa | 11 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha modificato il record |
| Organizzazioni | UnitaOrganizzativa | DataCancellazione | 12 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Organizzazioni | UnitaOrganizzativa | CancellatoDa | 13 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha cancellato il record |
| Organizzazioni | UnitaOrganizzativa | UniqueRowId | 14 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = GUID univoco del record |
| Organizzazioni | UnitaOrganizzativa | DataInizioValidita | 15 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data di inizio validità temporale |
| Organizzazioni | UnitaOrganizzativa | DataFineValidita | 16 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data di fine validità temporale |
| Organizzazioni | UnitaOrganizzativa | TipoUnitaOrganizzativaAccrediaId | 17 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_UnitaOrganizzativa_TipoNormativo -> Accreditamento.TipoUnitaOrganizzativaAccredia.TipoUnitaOrganizzativaAccrediaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativa | TipoSedeId | 18 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_UnitaOrganizzativa_TipoSede -> Tipologica.TipoSede.TipoSedeId | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativa | CodiceUnitaOrganizzativa | 19 | 0 | 2 | Organizzazioni.UnitaOrganizzativaStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzione | UnitaOrganizzativaFunzioneId | 1 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__UnitaOrg__B8BAD16E0C0CDFB0 | 0 |  -> .. | MS_Description = Identificatore univoco |
| Organizzazioni | UnitaOrganizzativaFunzione | UnitaOrganizzativaId | 2 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_UnitaOrgFunzione_UnitaOrganizzativa -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = Identificatore univoco |
| Organizzazioni | UnitaOrganizzativaFunzione | TipoFunzioneUnitaLocaleId | 3 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_UnitaOrgFunzione_TipoFunzione -> Tipologica.TipoFunzioneUnitaLocale.TipoFunzioneUnitaLocaleId | MS_Description = Identificatore univoco |
| Organizzazioni | UnitaOrganizzativaFunzione | Principale | 4 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzione | Note | 5 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzione | DataCreazione | 6 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Organizzazioni | UnitaOrganizzativaFunzione | CreatoDa | 7 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha creato il record |
| Organizzazioni | UnitaOrganizzativaFunzione | DataModifica | 8 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Organizzazioni | UnitaOrganizzativaFunzione | ModificatoDa | 9 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha modificato il record |
| Organizzazioni | UnitaOrganizzativaFunzione | DataCancellazione | 10 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Organizzazioni | UnitaOrganizzativaFunzione | CancellatoDa | 11 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha cancellato il record |
| Organizzazioni | UnitaOrganizzativaFunzione | UniqueRowId | 12 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzione | DataInizioValidita | 13 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzione | DataFineValidita | 14 | 0 | 2 | Organizzazioni.UnitaOrganizzativaFunzioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | UnitaOrganizzativaFunzioneId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | UnitaOrganizzativaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | TipoFunzioneUnitaLocaleId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | Principale | 4 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | Note | 5 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaFunzioneStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | UnitaOrganizzativaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | OrganizzazioneId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | TipoUnitaOrganizzativaId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | Nome | 4 | 1 | 1 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | NIscrizioneREA | 5 | 1 | 1 |  | nvarchar | 11 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | Codice | 6 | 1 | 1 |  | nvarchar | 150 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | Principale | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | DataCreazione | 8 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | CreatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | DataModifica | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | ModificatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | DataCancellazione | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | CancellatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | UniqueRowId | 14 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | DataInizioValidita | 15 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | DataFineValidita | 16 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | TipoUnitaOrganizzativaAccrediaId | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | TipoSedeId | 18 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaOrganizzativaStorico | CodiceUnitaOrganizzativa | 19 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazione | UnitaRelazioneId | 1 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__UnitaRel__E3D3A4179D6C4496 | 0 |  -> .. | MS_Description = Chiave primaria della relazione |
| Organizzazioni | UnitaRelazione | UnitaPadreId | 2 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_UnitaRelazione_UnitaPadre -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = Chiave esterna unità padre |
| Organizzazioni | UnitaRelazione | UnitaFigliaId | 3 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_UnitaRelazione_UnitaFiglia -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | MS_Description = Chiave esterna unità figlia |
| Organizzazioni | UnitaRelazione | TipoRelazioneId | 4 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Chiave esterna tipo relazione |
| Organizzazioni | UnitaRelazione | DataCreazione | 5 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di creazione |
| Organizzazioni | UnitaRelazione | CreatoDa | 6 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha creato il record |
| Organizzazioni | UnitaRelazione | DataModifica | 7 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di ultima modifica |
| Organizzazioni | UnitaRelazione | ModificatoDa | 8 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha modificato il record |
| Organizzazioni | UnitaRelazione | DataCancellazione | 9 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Timestamp di cancellazione logica |
| Organizzazioni | UnitaRelazione | CancellatoDa | 10 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = ID utente che ha cancellato il record |
| Organizzazioni | UnitaRelazione | UniqueRowId | 11 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = GUID univoco del record |
| Organizzazioni | UnitaRelazione | DataInizioValidita | 12 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data di inizio validità temporale |
| Organizzazioni | UnitaRelazione | DataFineValidita | 13 | 0 | 2 | Organizzazioni.UnitaRelazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data di fine validità temporale |
| Organizzazioni | UnitaRelazioneStorico | UnitaRelazioneId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | UnitaPadreId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | UnitaFigliaId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | TipoRelazioneId | 4 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | DataCreazione | 5 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | CreatoDa | 6 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | DataModifica | 7 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | ModificatoDa | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | DataCancellazione | 9 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | CancellatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | UniqueRowId | 11 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | DataInizioValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Organizzazioni | UnitaRelazioneStorico | DataFineValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | ConsensoPersonaId | 1 | 0 | 2 | Persone.ConsensoPersonaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_ConsensoPersona | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | PersonaId | 2 | 0 | 2 | Persone.ConsensoPersonaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_ConsensoPersona_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | TipoFinalitaTrattamentoId | 3 | 0 | 2 | Persone.ConsensoPersonaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_ConsensoPersona_Finalita -> Tipologica.TipoFinalitaTrattamento.TipoFinalitaTrattamentoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | Consenso | 4 | 0 | 2 | Persone.ConsensoPersonaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | DataConsenso | 5 | 0 | 2 | Persone.ConsensoPersonaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | DataScadenza | 6 | 0 | 2 | Persone.ConsensoPersonaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | DataRevoca | 7 | 0 | 2 | Persone.ConsensoPersonaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | ModalitaAcquisizione | 8 | 0 | 2 | Persone.ConsensoPersonaStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | RiferimentoDocumento | 9 | 0 | 2 | Persone.ConsensoPersonaStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | IPAddress | 10 | 0 | 2 | Persone.ConsensoPersonaStorico | nvarchar | 45 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | UserAgent | 11 | 0 | 2 | Persone.ConsensoPersonaStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | MotivoRevoca | 12 | 0 | 2 | Persone.ConsensoPersonaStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | ModalitaRevoca | 13 | 0 | 2 | Persone.ConsensoPersonaStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | VersioneInformativa | 14 | 0 | 2 | Persone.ConsensoPersonaStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | DataInformativa | 15 | 0 | 2 | Persone.ConsensoPersonaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | Note | 16 | 0 | 2 | Persone.ConsensoPersonaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | DataCreazione | 17 | 0 | 2 | Persone.ConsensoPersonaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | CreatoDa | 18 | 0 | 2 | Persone.ConsensoPersonaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | DataModifica | 19 | 0 | 2 | Persone.ConsensoPersonaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | ModificatoDa | 20 | 0 | 2 | Persone.ConsensoPersonaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | DataCancellazione | 21 | 0 | 2 | Persone.ConsensoPersonaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | CancellatoDa | 22 | 0 | 2 | Persone.ConsensoPersonaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | UniqueRowId | 23 | 0 | 2 | Persone.ConsensoPersonaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | DataInizioValidita | 24 | 0 | 2 | Persone.ConsensoPersonaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersona | DataFineValidita | 25 | 0 | 2 | Persone.ConsensoPersonaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | ConsensoPersonaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | PersonaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | TipoFinalitaTrattamentoId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | Consenso | 4 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | DataConsenso | 5 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | DataScadenza | 6 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | DataRevoca | 7 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | ModalitaAcquisizione | 8 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | RiferimentoDocumento | 9 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | IPAddress | 10 | 1 | 1 |  | nvarchar | 45 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | UserAgent | 11 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | MotivoRevoca | 12 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | ModalitaRevoca | 13 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | VersioneInformativa | 14 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | DataInformativa | 15 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | Note | 16 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | DataCreazione | 17 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | CreatoDa | 18 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | DataModifica | 19 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | ModificatoDa | 20 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | DataCancellazione | 21 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | CancellatoDa | 22 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | UniqueRowId | 23 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | DataInizioValidita | 24 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | ConsensoPersonaStorico | DataFineValidita | 25 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataBreachId | 1 | 0 | 2 | Persone.DataBreachStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_DataBreach | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | Codice | 2 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | Titolo | 3 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | Descrizione | 4 | 0 | 2 | Persone.DataBreachStorico | nvarchar | MAX | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataScoperta | 5 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataInizioViolazione | 6 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataFineViolazione | 7 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | TipoViolazione | 8 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | CausaViolazione | 9 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | CategorieDatiCoinvolti | 10 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DatiParticolariCoinvolti | 11 | 0 | 2 | Persone.DataBreachStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | NumeroInteressatiStimato | 12 | 0 | 2 | Persone.DataBreachStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | CategorieInteressati | 13 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | RischioPerInteressati | 14 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DescrizioneRischio | 15 | 0 | 2 | Persone.DataBreachStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | NotificaGaranteRichiesta | 16 | 0 | 2 | Persone.DataBreachStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataNotificaGarante | 17 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | ProtocolloGarante | 18 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | TermineNotificaGarante | 19 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | ComunicazioneInteressatiRichiesta | 20 | 0 | 2 | Persone.DataBreachStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataComunicazioneInteressati | 21 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | ModalitaComunicazione | 22 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | MisureContenimento | 23 | 0 | 2 | Persone.DataBreachStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | MisurePrevenzione | 24 | 0 | 2 | Persone.DataBreachStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | ResponsabileGestioneId | 25 | 0 | 2 | Persone.DataBreachStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_DataBreach_Responsabile -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DPOCoinvolto | 26 | 0 | 2 | Persone.DataBreachStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | Stato | 27 | 0 | 2 | Persone.DataBreachStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataChiusura | 28 | 0 | 2 | Persone.DataBreachStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataCreazione | 29 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | CreatoDa | 30 | 0 | 2 | Persone.DataBreachStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataModifica | 31 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | ModificatoDa | 32 | 0 | 2 | Persone.DataBreachStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataCancellazione | 33 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | CancellatoDa | 34 | 0 | 2 | Persone.DataBreachStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | UniqueRowId | 35 | 0 | 2 | Persone.DataBreachStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataInizioValidita | 36 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreach | DataFineValidita | 37 | 0 | 2 | Persone.DataBreachStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataBreachId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | Titolo | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | Descrizione | 4 | 1 | 1 |  | nvarchar | MAX | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataScoperta | 5 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataInizioViolazione | 6 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataFineViolazione | 7 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | TipoViolazione | 8 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | CausaViolazione | 9 | 1 | 1 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | CategorieDatiCoinvolti | 10 | 1 | 1 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DatiParticolariCoinvolti | 11 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | NumeroInteressatiStimato | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | CategorieInteressati | 13 | 1 | 1 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | RischioPerInteressati | 14 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DescrizioneRischio | 15 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | NotificaGaranteRichiesta | 16 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataNotificaGarante | 17 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | ProtocolloGarante | 18 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | TermineNotificaGarante | 19 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | ComunicazioneInteressatiRichiesta | 20 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataComunicazioneInteressati | 21 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | ModalitaComunicazione | 22 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | MisureContenimento | 23 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | MisurePrevenzione | 24 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | ResponsabileGestioneId | 25 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DPOCoinvolto | 26 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | Stato | 27 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataChiusura | 28 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataCreazione | 29 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | CreatoDa | 30 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataModifica | 31 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | ModificatoDa | 32 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataCancellazione | 33 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | CancellatoDa | 34 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | UniqueRowId | 35 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataInizioValidita | 36 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | DataBreachStorico | DataFineValidita | 37 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | PersonaId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_Persona | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | CodiceFiscale | 2 | 0 | 0 |  | nvarchar | 16 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | TitoloOnorificoId | 3 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Persona_TitoloOnorifico -> Tipologica.TitoloOnorifico.TitoloOnorificoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | Cognome | 4 | 0 | 0 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | Nome | 5 | 0 | 0 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | Genere | 6 | 0 | 0 |  | char | 1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | DataNascita | 7 | 0 | 0 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | ComuneNascitaId | 8 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Riferimento logico a Accredia.Territorio.Paese.PaeseId (comune di nascita) |
| Persone | Persona | LuogoNascita | 9 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | ProvinciaNascita | 10 | 0 | 0 |  | nvarchar | 2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | StatoNascitaId | 11 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Riferimento logico a Accredia.Territorio.Paese.PaeseId (stato/nazione di nascita) |
| Persone | Persona | ConsensoPrivacy | 13 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Consenso al trattamento dati personali ex art. 7 Reg. UE 2016/679 (GDPR) |
| Persone | Persona | DataConsensoPrivacy | 14 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Data e ora di acquisizione del consenso privacy (obbligatoria se ConsensoPrivacy = 1) |
| Persone | Persona | Note | 15 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | DataCreazione | 16 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | CreatoDa | 17 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | DataModifica | 18 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | ModificatoDa | 19 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | DataCancellazione | 20 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | CancellatoDa | 21 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | UniqueRowId | 22 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | DataInizioValidita | 23 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | Persona | DataFineValidita | 24 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | PersonaEmailId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_PersonaEmail | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | PersonaId | 2 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaEmail_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | TipoEmailId | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaEmail_TipoEmail -> Tipologica.TipoEmail.TipoEmailId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | Email | 4 | 0 | 0 |  | nvarchar | 256 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | Principale | 5 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | Verificata | 6 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | DataVerifica | 7 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | DataCreazione | 8 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | CreatoDa | 9 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | DataModifica | 10 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | ModificatoDa | 11 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | DataCancellazione | 12 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | CancellatoDa | 13 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | UniqueRowId | 14 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | DataInizioValidita | 15 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmail | DataFineValidita | 16 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | PersonaEmailId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | PersonaId | 2 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | TipoEmailId | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | Email | 4 | 0 | 0 |  | nvarchar | 256 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | Principale | 5 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | Verificata | 6 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | DataVerifica | 7 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | DataCreazione | 8 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | CreatoDa | 9 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | DataModifica | 10 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | ModificatoDa | 11 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | DataCancellazione | 12 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | CancellatoDa | 13 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | UniqueRowId | 14 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | DataInizioValidita | 15 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaEmailStorico | DataFineValidita | 16 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | PersonaIndirizzoId | 1 | 0 | 2 | Persone.PersonaIndirizzoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_PersonaIndirizzo | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | PersonaId | 2 | 0 | 2 | Persone.PersonaIndirizzoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaIndirizzo_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | IndirizzoId | 3 | 0 | 2 | Persone.PersonaIndirizzoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | TipoIndirizzoId | 4 | 0 | 2 | Persone.PersonaIndirizzoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaIndirizzo_TipoIndirizzo -> Tipologica.TipoIndirizzo.TipoIndirizzoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | Principale | 5 | 0 | 2 | Persone.PersonaIndirizzoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | Attivo | 6 | 0 | 2 | Persone.PersonaIndirizzoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | DataCreazione | 7 | 0 | 2 | Persone.PersonaIndirizzoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | CreatoDa | 8 | 0 | 2 | Persone.PersonaIndirizzoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | DataModifica | 9 | 0 | 2 | Persone.PersonaIndirizzoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | ModificatoDa | 10 | 0 | 2 | Persone.PersonaIndirizzoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | DataCancellazione | 11 | 0 | 2 | Persone.PersonaIndirizzoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | CancellatoDa | 12 | 0 | 2 | Persone.PersonaIndirizzoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | UniqueRowId | 13 | 0 | 2 | Persone.PersonaIndirizzoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | DataInizioValidita | 14 | 0 | 2 | Persone.PersonaIndirizzoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzo | DataFineValidita | 15 | 0 | 2 | Persone.PersonaIndirizzoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | PersonaIndirizzoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | PersonaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | IndirizzoId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | TipoIndirizzoId | 4 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | Principale | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | Attivo | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | DataCreazione | 7 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | CreatoDa | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | DataModifica | 9 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | ModificatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | DataCancellazione | 11 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | CancellatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | UniqueRowId | 13 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | DataInizioValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaIndirizzoStorico | DataFineValidita | 15 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | PersonaQualificaId | 1 | 0 | 2 | Persone.PersonaQualificaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_PersonaQualifica | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | PersonaId | 2 | 0 | 2 | Persone.PersonaQualificaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaQualifica_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | TipoQualificaId | 3 | 0 | 2 | Persone.PersonaQualificaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaQualifica_Tipo -> Tipologica.TipoQualifica.TipoQualificaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | EnteRilascioQualificaId | 4 | 0 | 2 | Persone.PersonaQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_PersonaQualifica_Ente -> Tipologica.EnteRilascioQualifica.EnteRilascioQualificaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | CodiceAttestato | 5 | 0 | 2 | Persone.PersonaQualificaStorico | nvarchar | 60 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | DataRilascio | 6 | 0 | 2 | Persone.PersonaQualificaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | DataScadenza | 7 | 0 | 2 | Persone.PersonaQualificaStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | Valida | 8 | 0 | 2 | Persone.PersonaQualificaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | Note | 9 | 0 | 2 | Persone.PersonaQualificaStorico | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | DataCreazione | 10 | 0 | 2 | Persone.PersonaQualificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | CreatoDa | 11 | 0 | 2 | Persone.PersonaQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | DataModifica | 12 | 0 | 2 | Persone.PersonaQualificaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | ModificatoDa | 13 | 0 | 2 | Persone.PersonaQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | DataCancellazione | 14 | 0 | 2 | Persone.PersonaQualificaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | CancellatoDa | 15 | 0 | 2 | Persone.PersonaQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | UniqueRowId | 16 | 0 | 2 | Persone.PersonaQualificaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | DataInizioValidita | 17 | 0 | 2 | Persone.PersonaQualificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualifica | DataFineValidita | 18 | 0 | 2 | Persone.PersonaQualificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | PersonaQualificaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | PersonaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | TipoQualificaId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | EnteRilascioQualificaId | 4 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | CodiceAttestato | 5 | 1 | 1 |  | nvarchar | 60 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | DataRilascio | 6 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | DataScadenza | 7 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | Valida | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | Note | 9 | 1 | 1 |  | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | DataCreazione | 10 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | CreatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | DataModifica | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | ModificatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | DataCancellazione | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | CancellatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | UniqueRowId | 16 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | DataInizioValidita | 17 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaQualificaStorico | DataFineValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | PersonaRelazionePersonaleId | 1 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_PersonaRelazionePersonale | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | PersonaId | 2 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaRelazionePersonale_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | PersonaCollegataId | 3 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaRelazionePersonale_PersonaCollegata -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | TipoRelazionePersonaleId | 4 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | Note | 5 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | DataCreazione | 6 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | CreatoDa | 7 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | DataModifica | 8 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | ModificatoDa | 9 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | DataCancellazione | 10 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | CancellatoDa | 11 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | UniqueRowId | 12 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | DataInizioValidita | 13 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonale | DataFineValidita | 14 | 0 | 2 | Persone.PersonaRelazionePersonaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | PersonaRelazionePersonaleId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | PersonaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | PersonaCollegataId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | TipoRelazionePersonaleId | 4 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | Note | 5 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaRelazionePersonaleStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | PersonaId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | CodiceFiscale | 2 | 0 | 0 |  | nvarchar | 16 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | TitoloOnorificoId | 3 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | Cognome | 4 | 0 | 0 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | Nome | 5 | 0 | 0 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | Genere | 6 | 0 | 0 |  | char | 1 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | DataNascita | 7 | 0 | 0 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | ComuneNascitaId | 8 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | LuogoNascita | 9 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | ProvinciaNascita | 10 | 0 | 0 |  | nvarchar | 2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | StatoNascitaId | 11 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | ConsensoPrivacy | 13 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | DataConsensoPrivacy | 14 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | Note | 15 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | DataCreazione | 16 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | CreatoDa | 17 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | DataModifica | 18 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | ModificatoDa | 19 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | DataCancellazione | 20 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | CancellatoDa | 21 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | UniqueRowId | 22 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | DataInizioValidita | 23 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaStorico | DataFineValidita | 24 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | PersonaTelefonoId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_PersonaTelefono | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | PersonaId | 2 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaTelefono_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | TipoTelefonoId | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaTelefono_TipoTelefono -> Tipologica.TipoTelefono.TipoTelefonoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | PrefissoInternazionale | 4 | 0 | 0 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | Numero | 5 | 0 | 0 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | Estensione | 6 | 0 | 0 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | Principale | 7 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | Verificato | 8 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | DataVerifica | 9 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | DataCreazione | 10 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | CreatoDa | 11 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | DataModifica | 12 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | ModificatoDa | 13 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | DataCancellazione | 14 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | CancellatoDa | 15 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | UniqueRowId | 16 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | DataInizioValidita | 17 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefono | DataFineValidita | 18 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | PersonaTelefonoId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | PersonaId | 2 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | TipoTelefonoId | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | PrefissoInternazionale | 4 | 0 | 0 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | Numero | 5 | 0 | 0 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | Estensione | 6 | 0 | 0 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | Principale | 7 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | Verificato | 8 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | DataVerifica | 9 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | DataCreazione | 10 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | CreatoDa | 11 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | DataModifica | 12 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | ModificatoDa | 13 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | DataCancellazione | 14 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | CancellatoDa | 15 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | UniqueRowId | 16 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | DataInizioValidita | 17 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTelefonoStorico | DataFineValidita | 18 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | PersonaTitoloStudioId | 1 | 0 | 2 | Persone.PersonaTitoloStudioStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_PersonaTitoloStudio | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | PersonaId | 2 | 0 | 2 | Persone.PersonaTitoloStudioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaTitoloStudio_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | TipoTitoloStudioId | 3 | 0 | 2 | Persone.PersonaTitoloStudioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaTitoloStudio_Tipo -> Tipologica.TipoTitoloStudio.TipoTitoloStudioId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | Istituzione | 4 | 0 | 2 | Persone.PersonaTitoloStudioStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | Corso | 5 | 0 | 2 | Persone.PersonaTitoloStudioStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | DataConseguimento | 6 | 0 | 2 | Persone.PersonaTitoloStudioStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | Voto | 7 | 0 | 2 | Persone.PersonaTitoloStudioStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | Lode | 8 | 0 | 2 | Persone.PersonaTitoloStudioStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | Paese | 9 | 0 | 2 | Persone.PersonaTitoloStudioStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | Note | 10 | 0 | 2 | Persone.PersonaTitoloStudioStorico | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | Principale | 11 | 0 | 2 | Persone.PersonaTitoloStudioStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | DataCreazione | 12 | 0 | 2 | Persone.PersonaTitoloStudioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | CreatoDa | 13 | 0 | 2 | Persone.PersonaTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | DataModifica | 14 | 0 | 2 | Persone.PersonaTitoloStudioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | ModificatoDa | 15 | 0 | 2 | Persone.PersonaTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | DataCancellazione | 16 | 0 | 2 | Persone.PersonaTitoloStudioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | CancellatoDa | 17 | 0 | 2 | Persone.PersonaTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | UniqueRowId | 18 | 0 | 2 | Persone.PersonaTitoloStudioStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | DataInizioValidita | 19 | 0 | 2 | Persone.PersonaTitoloStudioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudio | DataFineValidita | 20 | 0 | 2 | Persone.PersonaTitoloStudioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | PersonaTitoloStudioId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | PersonaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | TipoTitoloStudioId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | Istituzione | 4 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | Corso | 5 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | DataConseguimento | 6 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | Voto | 7 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | Lode | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | Paese | 9 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | Note | 10 | 1 | 1 |  | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | Principale | 11 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | DataCreazione | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | CreatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | DataModifica | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | ModificatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | DataCancellazione | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | CancellatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | UniqueRowId | 18 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | DataInizioValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaTitoloStudioStorico | DataFineValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | PersonaUtenteId | 1 | 0 | 2 | Persone.PersonaUtenteStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_PersonaUtente | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | PersonaId | 2 | 0 | 2 | Persone.PersonaUtenteStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_PersonaUtente_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | UserId | 3 | 0 | 2 | Persone.PersonaUtenteStorico | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | DataCreazione | 4 | 0 | 2 | Persone.PersonaUtenteStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | CreatoDa | 5 | 0 | 2 | Persone.PersonaUtenteStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | DataModifica | 6 | 0 | 2 | Persone.PersonaUtenteStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | ModificatoDa | 7 | 0 | 2 | Persone.PersonaUtenteStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | DataCancellazione | 8 | 0 | 2 | Persone.PersonaUtenteStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | CancellatoDa | 9 | 0 | 2 | Persone.PersonaUtenteStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | UniqueRowId | 10 | 0 | 2 | Persone.PersonaUtenteStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | DataInizioValidita | 11 | 0 | 2 | Persone.PersonaUtenteStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtente | DataFineValidita | 12 | 0 | 2 | Persone.PersonaUtenteStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | PersonaUtenteId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | PersonaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | UserId | 3 | 1 | 1 |  | nvarchar | 450 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | DataCreazione | 4 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | CreatoDa | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | DataModifica | 6 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | ModificatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | DataCancellazione | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | CancellatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | UniqueRowId | 10 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | DataInizioValidita | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | PersonaUtenteStorico | DataFineValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | RegistroTrattamentiId | 1 | 0 | 2 | Persone.RegistroTrattamentiStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_RegistroTrattamenti | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | Codice | 2 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | NomeTrattamento | 3 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | Descrizione | 4 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | TipoFinalitaTrattamentoId | 5 | 0 | 2 | Persone.RegistroTrattamentiStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_RegistroTrattamenti_Finalita -> Tipologica.TipoFinalitaTrattamento.TipoFinalitaTrattamentoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | BaseGiuridica | 6 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | CategorieDati | 7 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | CategorieInteressati | 8 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DatiParticolari | 9 | 0 | 2 | Persone.RegistroTrattamentiStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DatiGiudiziari | 10 | 0 | 2 | Persone.RegistroTrattamentiStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | CategorieDestinatari | 11 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | TrasferimentoExtraUE | 12 | 0 | 2 | Persone.RegistroTrattamentiStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | PaesiExtraUE | 13 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | GaranzieExtraUE | 14 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | TermineConservazione | 15 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | TermineConservazioneGiorni | 16 | 0 | 2 | Persone.RegistroTrattamentiStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | MisureSicurezza | 17 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | ResponsabileTrattamentoId | 18 | 0 | 2 | Persone.RegistroTrattamentiStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_RegistroTrattamenti_Responsabile -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | ContitolareId | 19 | 0 | 2 | Persone.RegistroTrattamentiStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DPONotificato | 20 | 0 | 2 | Persone.RegistroTrattamentiStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | Stato | 21 | 0 | 2 | Persone.RegistroTrattamentiStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DataInizioTrattamento | 22 | 0 | 2 | Persone.RegistroTrattamentiStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DataFineTrattamento | 23 | 0 | 2 | Persone.RegistroTrattamentiStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DataCreazione | 24 | 0 | 2 | Persone.RegistroTrattamentiStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | CreatoDa | 25 | 0 | 2 | Persone.RegistroTrattamentiStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DataModifica | 26 | 0 | 2 | Persone.RegistroTrattamentiStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | ModificatoDa | 27 | 0 | 2 | Persone.RegistroTrattamentiStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DataCancellazione | 28 | 0 | 2 | Persone.RegistroTrattamentiStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | CancellatoDa | 29 | 0 | 2 | Persone.RegistroTrattamentiStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | UniqueRowId | 30 | 0 | 2 | Persone.RegistroTrattamentiStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DataInizioValidita | 31 | 0 | 2 | Persone.RegistroTrattamentiStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamenti | DataFineValidita | 32 | 0 | 2 | Persone.RegistroTrattamentiStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | RegistroTrattamentiId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | NomeTrattamento | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | Descrizione | 4 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | TipoFinalitaTrattamentoId | 5 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | BaseGiuridica | 6 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | CategorieDati | 7 | 1 | 1 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | CategorieInteressati | 8 | 1 | 1 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DatiParticolari | 9 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DatiGiudiziari | 10 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | CategorieDestinatari | 11 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | TrasferimentoExtraUE | 12 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | PaesiExtraUE | 13 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | GaranzieExtraUE | 14 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | TermineConservazione | 15 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | TermineConservazioneGiorni | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | MisureSicurezza | 17 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | ResponsabileTrattamentoId | 18 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | ContitolareId | 19 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DPONotificato | 20 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | Stato | 21 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DataInizioTrattamento | 22 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DataFineTrattamento | 23 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DataCreazione | 24 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | CreatoDa | 25 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DataModifica | 26 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | ModificatoDa | 27 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DataCancellazione | 28 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | CancellatoDa | 29 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | UniqueRowId | 30 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DataInizioValidita | 31 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RegistroTrattamentiStorico | DataFineValidita | 32 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | RichiestaEsercizioDirittiId | 1 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_RichiestaEsercizioDiritti | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | PersonaId | 2 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_RichiestaEsercizioDiritti_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | NomeRichiedente | 3 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | EmailRichiedente | 4 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | TelefonoRichiedente | 5 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | Codice | 6 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | TipoDirittoGDPRId | 7 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_RichiestaEsercizioDiritti_TipoDiritto -> Tipologica.TipoDirittoGDPR.TipoDirittoGDPRId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataRichiesta | 8 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | ModalitaRichiesta | 9 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | TestoRichiesta | 10 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DocumentoRichiesta | 11 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | IdentitaVerificata | 12 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataVerificaIdentita | 13 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | ModalitaVerifica | 14 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataScadenza | 15 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataProrogaRichiesta | 16 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | MotivoProrogaRichiesta | 17 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | Stato | 18 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | ResponsabileGestioneId | 19 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_RichiestaEsercizioDiritti_Responsabile -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | Note | 20 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataRisposta | 21 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | EsitoRisposta | 22 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | MotivoRifiuto | 23 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | TestoRisposta | 24 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DocumentoRisposta | 25 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataEsecuzione | 26 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DatiCancellati | 27 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataCreazione | 28 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | CreatoDa | 29 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataModifica | 30 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | ModificatoDa | 31 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataCancellazione | 32 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | CancellatoDa | 33 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | UniqueRowId | 34 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataInizioValidita | 35 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDiritti | DataFineValidita | 36 | 0 | 2 | Persone.RichiestaEsercizioDirittiStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | RichiestaEsercizioDirittiId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | PersonaId | 2 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | NomeRichiedente | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | EmailRichiedente | 4 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | TelefonoRichiedente | 5 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | Codice | 6 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | TipoDirittoGDPRId | 7 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataRichiesta | 8 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | ModalitaRichiesta | 9 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | TestoRichiesta | 10 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DocumentoRichiesta | 11 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | IdentitaVerificata | 12 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataVerificaIdentita | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | ModalitaVerifica | 14 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataScadenza | 15 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataProrogaRichiesta | 16 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | MotivoProrogaRichiesta | 17 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | Stato | 18 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | ResponsabileGestioneId | 19 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | Note | 20 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataRisposta | 21 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | EsitoRisposta | 22 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | MotivoRifiuto | 23 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | TestoRisposta | 24 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DocumentoRisposta | 25 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataEsecuzione | 26 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DatiCancellati | 27 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataCreazione | 28 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | CreatoDa | 29 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataModifica | 30 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | ModificatoDa | 31 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataCancellazione | 32 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | CancellatoDa | 33 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | UniqueRowId | 34 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataInizioValidita | 35 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaEsercizioDirittiStorico | DataFineValidita | 36 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | RichiestaGDPRId | 1 | 0 | 2 | Persone.RichiestaGDPRStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_RichiestaGDPR | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | PersonaId | 2 | 0 | 2 | Persone.RichiestaGDPRStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_RichiestaGDPR_Persona -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | NomeRichiedente | 3 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | CognomeRichiedente | 4 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | EmailRichiedente | 5 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | TelefonoRichiedente | 6 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | TipoDirittoInteressatoId | 7 | 0 | 2 | Persone.RichiestaGDPRStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_RichiestaGDPR_TipoDiritto -> Tipologica.TipoDirittoInteressato.TipoDirittoInteressatoId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | Codice | 8 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DataRichiesta | 9 | 0 | 2 | Persone.RichiestaGDPRStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | CanaleRichiesta | 10 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DescrizioneRichiesta | 11 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DocumentoIdentita | 12 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DataScadenzaRisposta | 13 | 0 | 2 | Persone.RichiestaGDPRStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | Stato | 14 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | ResponsabileGestioneId | 15 | 0 | 2 | Persone.RichiestaGDPRStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_RichiestaGDPR_Responsabile -> Persone.Persona.PersonaId | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DataPresaInCarico | 16 | 0 | 2 | Persone.RichiestaGDPRStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DataRisposta | 17 | 0 | 2 | Persone.RichiestaGDPRStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | EsitoRichiesta | 18 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | MotivoRifiuto | 19 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DescrizioneRisposta | 20 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | ModalitaRisposta | 21 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | RiferimentoDocumentoRisposta | 22 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | Note | 23 | 0 | 2 | Persone.RichiestaGDPRStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DataCreazione | 24 | 0 | 2 | Persone.RichiestaGDPRStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | CreatoDa | 25 | 0 | 2 | Persone.RichiestaGDPRStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DataModifica | 26 | 0 | 2 | Persone.RichiestaGDPRStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | ModificatoDa | 27 | 0 | 2 | Persone.RichiestaGDPRStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DataCancellazione | 28 | 0 | 2 | Persone.RichiestaGDPRStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | CancellatoDa | 29 | 0 | 2 | Persone.RichiestaGDPRStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | UniqueRowId | 30 | 0 | 2 | Persone.RichiestaGDPRStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DataInizioValidita | 31 | 0 | 2 | Persone.RichiestaGDPRStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPR | DataFineValidita | 32 | 0 | 2 | Persone.RichiestaGDPRStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | RichiestaGDPRId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | PersonaId | 2 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | NomeRichiedente | 3 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | CognomeRichiedente | 4 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | EmailRichiedente | 5 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | TelefonoRichiedente | 6 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | TipoDirittoInteressatoId | 7 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | Codice | 8 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DataRichiesta | 9 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | CanaleRichiesta | 10 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DescrizioneRichiesta | 11 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DocumentoIdentita | 12 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DataScadenzaRisposta | 13 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | Stato | 14 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | ResponsabileGestioneId | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DataPresaInCarico | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DataRisposta | 17 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | EsitoRichiesta | 18 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | MotivoRifiuto | 19 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DescrizioneRisposta | 20 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | ModalitaRisposta | 21 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | RiferimentoDocumentoRisposta | 22 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | Note | 23 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DataCreazione | 24 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | CreatoDa | 25 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DataModifica | 26 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | ModificatoDa | 27 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DataCancellazione | 28 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | CancellatoDa | 29 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | UniqueRowId | 30 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DataInizioValidita | 31 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| Persone | RichiestaGDPRStorico | DataFineValidita | 32 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = [TODO] Descrizione colonna da completare. |
| RisorseUmane | Contratto | ContrattoId | 1 | 0 | 2 | RisorseUmane.ContrattoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_Contratto | 0 |  -> .. | MS_Description = Chiave primaria surrogate auto-incrementale. |
| RisorseUmane | Contratto | DipendenteId | 2 | 0 | 2 | RisorseUmane.ContrattoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Contratto_Dipendente -> RisorseUmane.Dipendente.DipendenteId | MS_Description = FK verso RisorseUmane.Dipendente. |
| RisorseUmane | Contratto | TipoContrattoId | 3 | 0 | 2 | RisorseUmane.ContrattoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Contratto_TipoContratto -> Tipologica.TipoContratto.TipoContrattoId | MS_Description = FK verso Tipologica.TipoContratto. INDET, DET, APPRENDISTATO, etc. |
| RisorseUmane | Contratto | DataInizio | 4 | 0 | 2 | RisorseUmane.ContrattoStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data decorrenza contratto. |
| RisorseUmane | Contratto | DataFine | 5 | 0 | 2 | RisorseUmane.ContrattoStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Data scadenza contratto. NULL per tempo indeterminato. |
| RisorseUmane | Contratto | LivelloInquadramento | 6 | 0 | 2 | RisorseUmane.ContrattoStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Livello di inquadramento CCNL (es. Q, 1, 2, 3S, 3, 4, 5). |
| RisorseUmane | Contratto | CCNLApplicato | 7 | 0 | 2 | RisorseUmane.ContrattoStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = CCNL applicato (es. Commercio, Metalmeccanico). |
| RisorseUmane | Contratto | RAL | 8 | 0 | 2 | RisorseUmane.ContrattoStorico | decimal | 12,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | Accredia.Doc = RAL annuale concordata. Dato sensibile soggetto a restrizioni GDPR. Accesso limitato a HR e direzione. Per full-time è il totale annuo, per part-time è proporzionato alla percentuale. \| MS_Description = Retribuzione Annua Lorda. DATO SENSIBILE con accesso ristretto. |
| RisorseUmane | Contratto | PercentualePartTime | 9 | 0 | 2 | RisorseUmane.ContrattoStorico | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Percentuale part-time (es. 50, 80). NULL per full-time. |
| RisorseUmane | Contratto | OreLavoroSettimanali | 10 | 0 | 2 | RisorseUmane.ContrattoStorico | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Ore lavoro settimanali (es. 40 full-time, 20 part-time 50%). |
| RisorseUmane | Contratto | IsContrattoCorrente | 11 | 0 | 2 | RisorseUmane.ContrattoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Solo un contratto per dipendente può avere questo flag TRUE. Usato per identificare rapidamente il contratto vigente senza calcolare date. Quando si inserisce nuovo contratto, il precedente deve essere aggiornato a FALSE. \| MS_Description = TRUE se è il contratto attualmente in vigore per il dipendente. |
| RisorseUmane | Contratto | Note | 12 | 0 | 2 | RisorseUmane.ContrattoStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Contratto | DataCreazione | 13 | 0 | 2 | RisorseUmane.ContrattoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Contratto | CreatoDa | 14 | 0 | 2 | RisorseUmane.ContrattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Contratto | DataModifica | 15 | 0 | 2 | RisorseUmane.ContrattoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Contratto | ModificatoDa | 16 | 0 | 2 | RisorseUmane.ContrattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Contratto | DataCancellazione | 17 | 0 | 2 | RisorseUmane.ContrattoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Contratto | CancellatoDa | 18 | 0 | 2 | RisorseUmane.ContrattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Contratto | UniqueRowId | 19 | 0 | 2 | RisorseUmane.ContrattoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Contratto | DataInizioValidita | 20 | 0 | 2 | RisorseUmane.ContrattoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Contratto | DataFineValidita | 21 | 0 | 2 | RisorseUmane.ContrattoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | ContrattoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | DipendenteId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | TipoContrattoId | 3 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | DataInizio | 4 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | DataFine | 5 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | LivelloInquadramento | 6 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | CCNLApplicato | 7 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | RAL | 8 | 1 | 1 |  | decimal | 12,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | PercentualePartTime | 9 | 1 | 1 |  | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | OreLavoroSettimanali | 10 | 1 | 1 |  | decimal | 5,2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | IsContrattoCorrente | 11 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | Note | 12 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | DataCreazione | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | CreatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | DataModifica | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | ModificatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | DataCancellazione | 17 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | CancellatoDa | 18 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | UniqueRowId | 19 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | DataInizioValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | ContrattoStorico | DataFineValidita | 21 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dipendente | DipendenteId | 1 | 0 | 2 | RisorseUmane.DipendenteStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_Dipendente | 0 |  -> .. | MS_Description = Chiave primaria surrogate auto-incrementale. |
| RisorseUmane | Dipendente | PersonaId | 2 | 0 | 2 | RisorseUmane.DipendenteStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Dipendente_Persona -> Persone.Persona.PersonaId | Accredia.Doc = Collegamento alla tabella anagrafica persone. I dati identificativi (nome, cognome, CF, data nascita) sono gestiti in Persone.Persona. Constraint UNIQUE garantisce che ogni persona fisica può avere al massimo un record dipendente. \| MS_Description = FK verso Persone.Persona. Relazione 1:1, una persona può essere dipendente ACCREDIA una sola volta. |
| RisorseUmane | Dipendente | Matricola | 3 | 0 | 2 | RisorseUmane.DipendenteStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Identificativo numerico o alfanumerico assegnato dall'ufficio personale al momento dell'assunzione. Usato in tutti i documenti interni, buste paga, comunicazioni. Non cambia per tutta la durata del rapporto. \| MS_Description = Matricola aziendale univoca assegnata al dipendente. |
| RisorseUmane | Dipendente | EmailAziendale | 4 | 0 | 2 | RisorseUmane.DipendenteStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Indirizzo email aziendale @accredia.it. |
| RisorseUmane | Dipendente | TelefonoInterno | 5 | 0 | 2 | RisorseUmane.DipendenteStorico | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Numero telefonico interno (es. 301, 402). |
| RisorseUmane | Dipendente | UnitaOrganizzativaId | 6 | 0 | 2 | RisorseUmane.DipendenteStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Dipendente_UnitaOrganizzativa -> Organizzazioni.UnitaOrganizzativa.UnitaOrganizzativaId | Accredia.Doc = Indica la collocazione organizzativa del dipendente (es. Direzione Certificazione, Area IT, Direzione Generale). Riusa la struttura di Organizzazioni.UnitaOrganizzativa già definita per ACCREDIA. \| MS_Description = FK verso Organizzazioni.UnitaOrganizzativa. Area/Direzione di appartenenza. |
| RisorseUmane | Dipendente | ResponsabileDirettoId | 7 | 0 | 2 | RisorseUmane.DipendenteStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_Dipendente_Responsabile -> RisorseUmane.Dipendente.DipendenteId | Accredia.Doc = Riferimento gerarchico per costruire organigramma. NULL per il vertice (DG). Permette query ricorsive CTE per navigare la gerarchia e calcolare riporti diretti/indiretti. \| MS_Description = FK self-reference. DipendenteId del responsabile diretto gerarchico. |
| RisorseUmane | Dipendente | DataAssunzione | 8 | 0 | 2 | RisorseUmane.DipendenteStorico | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data di inizio rapporto di lavoro (assunzione). |
| RisorseUmane | Dipendente | DataCessazione | 9 | 0 | 2 | RisorseUmane.DipendenteStorico | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Data di fine rapporto di lavoro. NULL se ancora in essere. |
| RisorseUmane | Dipendente | StatoDipendenteId | 10 | 0 | 2 | RisorseUmane.DipendenteStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Dipendente_Stato -> Tipologica.StatoDipendente.StatoDipendenteId | MS_Description = FK verso Tipologica.StatoDipendente. Stato corrente: ATTIVO, PROVA, SOSPESO, CESSATO. |
| RisorseUmane | Dipendente | AbilitatoAttivitaIspettiva | 11 | 0 | 2 | RisorseUmane.DipendenteStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Flag che indica se il dipendente può essere collegato a Ispettori.Ispettore come ispettore interno. Solo i dipendenti con questo flag = TRUE possono avere un record nella tabella Ispettori con IsIspettoreInterno = TRUE. Prerequisito per svolgere visite ispettive per conto di ACCREDIA. \| MS_Description = TRUE se il dipendente è abilitato a svolgere attività ispettiva come ispettore interno. |
| RisorseUmane | Dipendente | Note | 12 | 0 | 2 | RisorseUmane.DipendenteStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Note libere sul dipendente. |
| RisorseUmane | Dipendente | DataCreazione | 13 | 0 | 2 | RisorseUmane.DipendenteStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dipendente | CreatoDa | 14 | 0 | 2 | RisorseUmane.DipendenteStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dipendente | DataModifica | 15 | 0 | 2 | RisorseUmane.DipendenteStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dipendente | ModificatoDa | 16 | 0 | 2 | RisorseUmane.DipendenteStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dipendente | DataCancellazione | 17 | 0 | 2 | RisorseUmane.DipendenteStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dipendente | CancellatoDa | 18 | 0 | 2 | RisorseUmane.DipendenteStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dipendente | UniqueRowId | 19 | 0 | 2 | RisorseUmane.DipendenteStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dipendente | DataInizioValidita | 20 | 0 | 2 | RisorseUmane.DipendenteStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dipendente | DataFineValidita | 21 | 0 | 2 | RisorseUmane.DipendenteStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | DipendenteId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | PersonaId | 2 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | Matricola | 3 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | EmailAziendale | 4 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | TelefonoInterno | 5 | 1 | 1 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | UnitaOrganizzativaId | 6 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | ResponsabileDirettoId | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | DataAssunzione | 8 | 1 | 1 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | DataCessazione | 9 | 1 | 1 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | StatoDipendenteId | 10 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | AbilitatoAttivitaIspettiva | 11 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | Note | 12 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | DataCreazione | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | CreatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | DataModifica | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | ModificatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | DataCancellazione | 17 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | CancellatoDa | 18 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | UniqueRowId | 19 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | DataInizioValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | DipendenteStorico | DataFineValidita | 21 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dotazione | DotazioneId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_Dotazione | 0 |  -> .. | MS_Description = Chiave primaria surrogate auto-incrementale. |
| RisorseUmane | Dotazione | DipendenteId | 2 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Dotazione_Dipendente -> RisorseUmane.Dipendente.DipendenteId | MS_Description = FK verso RisorseUmane.Dipendente. |
| RisorseUmane | Dotazione | TipoDotazioneId | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Dotazione_TipoDotazione -> Tipologica.TipoDotazione.TipoDotazioneId | MS_Description = FK verso Tipologica.TipoDotazione. |
| RisorseUmane | Dotazione | Descrizione | 4 | 0 | 0 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione specifica del bene (es. Dell Latitude 5540, iPhone 14 Pro). |
| RisorseUmane | Dotazione | NumeroInventario | 5 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Numero inventario aziendale. |
| RisorseUmane | Dotazione | NumeroSerie | 6 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Numero di serie del dispositivo. |
| RisorseUmane | Dotazione | DataAssegnazione | 7 | 0 | 0 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data consegna al dipendente. |
| RisorseUmane | Dotazione | DataRestituzione | 8 | 0 | 0 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Data restituzione. NULL se ancora in uso. |
| RisorseUmane | Dotazione | IsRestituito | 9 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = TRUE se la dotazione è stata restituita. |
| RisorseUmane | Dotazione | Note | 10 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dotazione | DataCreazione | 11 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dotazione | CreatoDa | 12 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dotazione | DataModifica | 13 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dotazione | ModificatoDa | 14 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dotazione | DataCancellazione | 15 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dotazione | CancellatoDa | 16 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | Dotazione | UniqueRowId | 17 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | FormazioneObbligatoria | FormazioneObbligatoriaId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_FormazioneObbligatoria | 0 |  -> .. | MS_Description = Chiave primaria surrogate auto-incrementale. |
| RisorseUmane | FormazioneObbligatoria | DipendenteId | 2 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_FormazioneObbligatoria_Dipendente -> RisorseUmane.Dipendente.DipendenteId | MS_Description = FK verso RisorseUmane.Dipendente. |
| RisorseUmane | FormazioneObbligatoria | TipoFormazioneObbligatoriaId | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_FormazioneObbligatoria_Tipo -> Tipologica.TipoFormazioneObbligatoria.TipoFormazioneObbligatoriaId | MS_Description = FK verso Tipologica.TipoFormazioneObbligatoria. |
| RisorseUmane | FormazioneObbligatoria | DataCompletamento | 4 | 0 | 0 |  | date |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Data completamento/superamento del corso. |
| RisorseUmane | FormazioneObbligatoria | DataScadenza | 5 | 0 | 0 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Calcolata come DataCompletamento + DurataValiditaMesi del tipo formazione. Usata per generare alert di rinnovo. Il sistema dovrebbe notificare HR 30 giorni prima della scadenza. \| MS_Description = Data scadenza validità. NULL se non scade. |
| RisorseUmane | FormazioneObbligatoria | EstremiAttestato | 6 | 0 | 0 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Riferimento all'attestato (numero, codice). |
| RisorseUmane | FormazioneObbligatoria | EnteFormatore | 7 | 0 | 0 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Ente che ha erogato la formazione. |
| RisorseUmane | FormazioneObbligatoria | DurataOreCorso | 8 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Durata in ore del corso completato. |
| RisorseUmane | FormazioneObbligatoria | Note | 9 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | FormazioneObbligatoria | DataCreazione | 10 | 0 | 0 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | FormazioneObbligatoria | CreatoDa | 11 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | FormazioneObbligatoria | DataModifica | 12 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | FormazioneObbligatoria | ModificatoDa | 13 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | FormazioneObbligatoria | DataCancellazione | 14 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | FormazioneObbligatoria | CancellatoDa | 15 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| RisorseUmane | FormazioneObbligatoria | UniqueRowId | 16 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | LogId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__LOG_Migr__5E54864878928666 | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | SessioneId | 2 | 0 | 0 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | DataOperazione | 3 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | Fase | 4 | 0 | 0 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | Sorgente | 5 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | Operazione | 6 | 0 | 0 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | RecordProcessati | 7 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | RecordValidi | 8 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | RecordScartati | 9 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | RecordInseriti | 10 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | RecordAggiornati | 11 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | RecordDuplicati | 12 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | Durata_ms | 13 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | Esito | 14 | 0 | 0 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | LOG_Migrazione | Messaggio | 15 | 0 | 0 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Errors | Id | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__STG_Ragi__3214EC07B1E96EF8 | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Errors | PartitaIVA | 2 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Errors | CodiceFiscale | 3 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Errors | RagioneSociale | 4 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Errors | Sorgente | 5 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Errors | CodiceOrigine | 6 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Errors | ChiaveOrigine | 7 | 0 | 0 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Errors | NoteValidazione | 8 | 0 | 0 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Errors | DataErrore | 9 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | RowId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__STG_Ragi__FFEE74315F162513 | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | PartitaIVA | 2 | 0 | 0 |  | nvarchar | 11 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | CodiceFiscale | 3 | 0 | 0 |  | nvarchar | 16 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | RagioneSociale | 4 | 0 | 0 |  | nvarchar | 550 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | RagioneSocialeNormalizzata | 5 | 0 | 0 |  | nvarchar | 550 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | NaturaGiuridica | 6 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | StatoAttivita | 7 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | OggettoSociale | 8 | 0 | 0 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | PEC | 9 | 0 | 0 |  | nvarchar | 255 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | Email | 10 | 0 | 0 |  | nvarchar | 255 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | Telefono | 11 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | SitoWeb | 12 | 0 | 0 |  | nvarchar | 255 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | Sorgente | 13 | 0 | 0 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | CodiceOrigine | 14 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | ChiaveOrigine | 15 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | IsPartitaIVAValida | 16 | 0 | 0 |  | bit |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | IsCodiceFiscaleValido | 17 | 0 | 0 |  | bit |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | StatoValidazione | 18 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | NoteValidazione | 19 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | OrganizzazioneIdMatch | 20 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | TipoMatch | 21 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | DataImportazione | 22 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | DataValidazione | 23 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_RagioniSociali_Unificate | DataMigrazione | 24 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | RowId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__STG_Sedi__FFEE74319F526B9B | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | PartitaIVA | 2 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | CodiceFiscale | 3 | 0 | 0 |  | nvarchar | 16 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | RagioneSociale | 4 | 0 | 0 |  | nvarchar | 550 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | TipoSede | 5 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | DenominazioneSede | 6 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | Indirizzo | 7 | 0 | 0 |  | nvarchar | 250 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | NumeroCivico | 8 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | CAP | 9 | 0 | 0 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | Localita | 10 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | Provincia | 11 | 0 | 0 |  | nvarchar | 5 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | Nazione | 12 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | StatoAttivita | 13 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | Sorgente | 14 | 0 | 0 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | CodiceOrigine | 15 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | DataImportazione | 16 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | CodiceSede | 17 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | Insegna | 18 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | NIscrizioneREA | 19 | 0 | 0 |  | nvarchar | 11 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | SiglaProvinciaREA | 20 | 0 | 0 |  | nvarchar | 2 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | DataIscrizioneREA | 21 | 0 | 0 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | ProgressivoUL | 22 | 0 | 0 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | Regione | 23 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | CodiceATECO | 24 | 0 | 0 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | DescrizioneAttivita | 25 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | DataApertura | 26 | 0 | 0 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | DataCessazione | 27 | 0 | 0 |  | date |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | StatoValidazione | 28 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_Sedi | OrganizzazioneIdMatch | 29 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | RowId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__STG_Unit__FFEE7431AD5E56BA | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | PartitaIVA | 2 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | CodiceFiscale | 3 | 0 | 0 |  | nvarchar | 16 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | RagioneSociale | 4 | 0 | 0 |  | nvarchar | 550 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | NomeUO | 5 | 0 | 0 |  | nvarchar | 500 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | CodiceUO | 6 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | SiglaUO | 7 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | TipoUO | 8 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | CategoriaOrigine | 9 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | SettoreAttivita | 10 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | NumeroAccreditamento | 11 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | IsSedePrincipale | 12 | 0 | 0 |  | bit |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | StatoAttivo | 13 | 0 | 0 |  | bit |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | Sorgente | 14 | 0 | 0 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | CodiceOrigine | 15 | 0 | 0 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | StatoClassificazione | 16 | 0 | 0 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | MotivoClassificazione | 17 | 0 | 0 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | OrganizzazioneIdMatch | 18 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | UnitaOrganizzativaIdMatch | 19 | 0 | 0 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Staging | STG_UnitaOrganizzative | DataImportazione | 20 | 0 | 0 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivita | CodiceStatoAttivitaId | 1 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | tinyint |  | OBBLIGATORIO | NOT NULL | 1 | PK_CodiceStatoAttivita | 0 |  -> .. | MS_Description = Identificatore univoco |
| Tipologica | CodiceStatoAttivita | Codice | 2 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice identificativo |
| Tipologica | CodiceStatoAttivita | Descrizione | 3 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione dettagliata |
| Tipologica | CodiceStatoAttivita | Attivo | 4 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag di attivazione |
| Tipologica | CodiceStatoAttivita | rowguid | 5 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivita | DataCreazione | 6 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivita | CreatoDa | 7 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivita | DataModifica | 8 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivita | ModificatoDa | 9 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivita | DataCancellazione | 10 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivita | CancellatoDa | 11 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivita | DataInizioValidita | 12 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivita | DataFineValidita | 13 | 0 | 2 | Tipologica.CodiceStatoAttivitaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | CodiceStatoAttivitaId | 1 | 1 | 1 |  | tinyint |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | Attivo | 4 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | rowguid | 5 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | DataInizioValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | CodiceStatoAttivitaStorico | DataFineValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | DipartimentoAccreditaId | 1 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_DipartimentoAccredia | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | Codice | 2 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | nvarchar | 10 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | Descrizione | 3 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | ResponsabileEmail | 5 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | Ordine | 6 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | Attivo | 7 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | DataCreazione | 8 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | CreatoDa | 9 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | DataModifica | 10 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | ModificatoDa | 11 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | DataCancellazione | 12 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | CancellatoDa | 13 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | UniqueRowId | 14 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | DataInizioValidita | 15 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccredia | DataFineValidita | 16 | 0 | 2 | Tipologica.DipartimentoAccreditaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | DipartimentoAccreditaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 10 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | ResponsabileEmail | 5 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | Ordine | 6 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | Attivo | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | DataCreazione | 8 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | CreatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | DataModifica | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | ModificatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | DataCancellazione | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | CancellatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | UniqueRowId | 14 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | DataInizioValidita | 15 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | DipartimentoAccreditaStorico | DataFineValidita | 16 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | EnteRilascioQualificaId | 1 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_EnteRilascioQualifica | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | Codice | 2 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | Descrizione | 3 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | DataCreazione | 4 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | CreatoDa | 5 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | DataModifica | 6 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | ModificatoDa | 7 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | DataCancellazione | 8 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | CancellatoDa | 9 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | UniqueRowId | 10 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | DataInizioValidita | 11 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualifica | DataFineValidita | 12 | 0 | 2 | Tipologica.EnteRilascioQualificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | EnteRilascioQualificaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | DataCreazione | 4 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | CreatoDa | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | DataModifica | 6 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | ModificatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | DataCancellazione | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | CancellatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | UniqueRowId | 10 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | DataInizioValidita | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EnteRilascioQualificaStorico | DataFineValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | EsitoMonitoraggioId | 1 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_EsitoMonitoraggio | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | Codice | 2 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | Descrizione | 3 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | ConfermaQualifica | 5 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | RichiedeAzioneCorrettiva | 6 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | RichiedeSospensione | 7 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | ColoreUI | 8 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | nvarchar | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | Ordine | 9 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | Attivo | 10 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | DataCreazione | 11 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | CreatoDa | 12 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | DataModifica | 13 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | ModificatoDa | 14 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | DataCancellazione | 15 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | CancellatoDa | 16 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | UniqueRowId | 17 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | DataInizioValidita | 18 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggio | DataFineValidita | 19 | 0 | 2 | Tipologica.EsitoMonitoraggioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | EsitoMonitoraggioId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | ConfermaQualifica | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | RichiedeAzioneCorrettiva | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | RichiedeSospensione | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | ColoreUI | 8 | 1 | 1 |  | nvarchar | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | Ordine | 9 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | Attivo | 10 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | DataCreazione | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | CreatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | DataModifica | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | ModificatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | DataCancellazione | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | CancellatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | UniqueRowId | 17 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | DataInizioValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | EsitoMonitoraggioStorico | DataFineValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | LivelloTitoloStudioId | 1 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_LivelloTitoloStudio | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | Descrizione | 2 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | Codice | 3 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | Description = Codice univoco del livello (max 20 char). |
| Tipologica | LivelloTitoloStudio | Ordine | 4 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | RiferimentoNormativo | 5 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | DataCreazione | 6 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | CreatoDa | 7 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | DataModifica | 8 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | ModificatoDa | 9 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | DataCancellazione | 10 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | CancellatoDa | 11 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | UniqueRowId | 12 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | DataInizioValidita | 13 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudio | DataFineValidita | 14 | 0 | 2 | Tipologica.LivelloTitoloStudioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | LivelloTitoloStudioId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | Descrizione | 2 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | Codice | 3 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | Ordine | 4 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | RiferimentoNormativo | 5 | 1 | 1 |  | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | LivelloTitoloStudioStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingCategoriaSede | MappingId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__MappingC__8B57819D2AE35DB6 | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingCategoriaSede | CategoriaOrigine | 2 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingCategoriaSede | TipoUnitaOrganizzativaId | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Mapping_TipoUO -> Tipologica.TipoUnitaOrganizzativa.TipoUnitaOrganizzativaId | (Nessuna proprietà) |
| Tipologica | MappingCategoriaSede | TipoSedeId | 4 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_Mapping_TipoSede -> Tipologica.TipoSede.TipoSedeId | (Nessuna proprietà) |
| Tipologica | MappingCategoriaSede | Principale | 5 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingCategoriaSede | Escludere | 6 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingCategoriaSede | Note | 7 | 0 | 0 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingTipoSedeIndirizzo | MappingId | 1 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__MappingT__8B57819D70B02E3B | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingTipoSedeIndirizzo | TipoSedeOrigine | 2 | 0 | 0 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingTipoSedeIndirizzo | TipoIndirizzoId | 3 | 0 | 0 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingTipoSedeIndirizzo | Principale | 4 | 0 | 0 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | MappingTipoSedeIndirizzo | Note | 5 | 0 | 0 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | StatoDipendenteId | 1 | 0 | 2 | Tipologica.StatoDipendenteStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_StatoDipendente | 0 |  -> .. | MS_Description = Chiave primaria surrogate auto-incrementale. |
| Tipologica | StatoDipendente | Codice | 2 | 0 | 2 | Tipologica.StatoDipendenteStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice univoco stato: ATTIVO, PROVA, SOSPESO, MATERNITA, ASPETTATIVA, CESSATO. |
| Tipologica | StatoDipendente | Descrizione | 3 | 0 | 2 | Tipologica.StatoDipendenteStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione breve dello stato. |
| Tipologica | StatoDipendente | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.StatoDipendenteStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | ConsenteOperativita | 5 | 0 | 2 | Tipologica.StatoDipendenteStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Flag che determina se il dipendente è operativo. Solo stati ATTIVO e PROVA hanno questo flag a TRUE. Usato per filtri su assegnazioni ispettive e altre attività. \| MS_Description = Se TRUE il dipendente in questo stato può svolgere attività lavorativa. |
| Tipologica | StatoDipendente | ConsenteAssegnazioni | 6 | 0 | 2 | Tipologica.StatoDipendenteStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Se TRUE il dipendente può ricevere nuove assegnazioni (es. visite ispettive). |
| Tipologica | StatoDipendente | RichiedeDataFine | 7 | 0 | 2 | Tipologica.StatoDipendenteStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Se TRUE lo stato richiede una data fine prevista (es. maternità, aspettativa). |
| Tipologica | StatoDipendente | ColoreUI | 8 | 0 | 2 | Tipologica.StatoDipendenteStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Colore esadecimale per rappresentazione UI. |
| Tipologica | StatoDipendente | Icona | 9 | 0 | 2 | Tipologica.StatoDipendenteStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Icona Material Design Icons per UI. |
| Tipologica | StatoDipendente | Ordine | 10 | 0 | 2 | Tipologica.StatoDipendenteStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | Attivo | 11 | 0 | 2 | Tipologica.StatoDipendenteStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | DataCreazione | 12 | 0 | 2 | Tipologica.StatoDipendenteStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | CreatoDa | 13 | 0 | 2 | Tipologica.StatoDipendenteStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | DataModifica | 14 | 0 | 2 | Tipologica.StatoDipendenteStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | ModificatoDa | 15 | 0 | 2 | Tipologica.StatoDipendenteStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | DataCancellazione | 16 | 0 | 2 | Tipologica.StatoDipendenteStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | CancellatoDa | 17 | 0 | 2 | Tipologica.StatoDipendenteStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | UniqueRowId | 18 | 0 | 2 | Tipologica.StatoDipendenteStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | DataInizioValidita | 19 | 0 | 2 | Tipologica.StatoDipendenteStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendente | DataFineValidita | 20 | 0 | 2 | Tipologica.StatoDipendenteStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | StatoDipendenteId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | ConsenteOperativita | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | ConsenteAssegnazioni | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | RichiedeDataFine | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | ColoreUI | 8 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | Icona | 9 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | Ordine | 10 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | Attivo | 11 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | DataCreazione | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | CreatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | DataModifica | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | ModificatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | DataCancellazione | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | CancellatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | UniqueRowId | 18 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | DataInizioValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoDipendenteStorico | DataFineValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | StatoIspettoreId | 1 | 0 | 2 | Tipologica.StatoIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_StatoIspettore | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | Codice | 2 | 0 | 2 | Tipologica.StatoIspettoreStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | Descrizione | 3 | 0 | 2 | Tipologica.StatoIspettoreStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.StatoIspettoreStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | Categoria | 5 | 0 | 2 | Tipologica.StatoIspettoreStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | ConsenteAssegnazione | 6 | 0 | 2 | Tipologica.StatoIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | ConsenteFormazione | 7 | 0 | 2 | Tipologica.StatoIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | RichiedeMotivazione | 8 | 0 | 2 | Tipologica.StatoIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | ColoreUI | 9 | 0 | 2 | Tipologica.StatoIspettoreStorico | nvarchar | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | Ordine | 10 | 0 | 2 | Tipologica.StatoIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | Attivo | 11 | 0 | 2 | Tipologica.StatoIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | DataCreazione | 12 | 0 | 2 | Tipologica.StatoIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | CreatoDa | 13 | 0 | 2 | Tipologica.StatoIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | DataModifica | 14 | 0 | 2 | Tipologica.StatoIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | ModificatoDa | 15 | 0 | 2 | Tipologica.StatoIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | DataCancellazione | 16 | 0 | 2 | Tipologica.StatoIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | CancellatoDa | 17 | 0 | 2 | Tipologica.StatoIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | UniqueRowId | 18 | 0 | 2 | Tipologica.StatoIspettoreStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | DataInizioValidita | 19 | 0 | 2 | Tipologica.StatoIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettore | DataFineValidita | 20 | 0 | 2 | Tipologica.StatoIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | StatoIspettoreId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | Categoria | 5 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | ConsenteAssegnazione | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | ConsenteFormazione | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | RichiedeMotivazione | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | ColoreUI | 9 | 1 | 1 |  | nvarchar | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | Ordine | 10 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | Attivo | 11 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | DataCreazione | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | CreatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | DataModifica | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | ModificatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | DataCancellazione | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | CancellatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | UniqueRowId | 18 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | DataInizioValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | StatoIspettoreStorico | DataFineValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridica | TipoCodiceNaturaGiuridicaID | 1 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoCodiceNaturaGiuridica | 0 |  -> .. | MS_Description = Chiave primaria |
| Tipologica | TipoCodiceNaturaGiuridica | Codice | 2 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice natura giuridica (SRL, SPA, COOP, etc) |
| Tipologica | TipoCodiceNaturaGiuridica | Descrizione | 3 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione |
| Tipologica | TipoCodiceNaturaGiuridica | NormaRiferimento | 4 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Norma riferimento |
| Tipologica | TipoCodiceNaturaGiuridica | Attivo | 5 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag attivo |
| Tipologica | TipoCodiceNaturaGiuridica | rowguid | 6 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridica | DataCreazione | 7 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridica | CreatoDa | 8 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridica | DataModifica | 9 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridica | ModificatoDa | 10 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridica | DataCancellazione | 11 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridica | CancellatoDa | 12 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridica | DataInizioValidita | 13 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridica | DataFineValidita | 14 | 0 | 2 | Tipologica.TipoCodiceNaturaGiuridicaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | TipoCodiceNaturaGiuridicaID | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | NormaRiferimento | 4 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | Attivo | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | rowguid | 6 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | DataCreazione | 7 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | CreatoDa | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | DataModifica | 9 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | ModificatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | DataCancellazione | 11 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | CancellatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCodiceNaturaGiuridicaStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | TipoCompetenzaIspettoreId | 1 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoCompetenzaIspettore | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | Codice | 2 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | Descrizione | 3 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | Categoria | 5 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | RichiedeValiditaTemporale | 6 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | DurataValiditaMesi | 7 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | RichiedeRinnovo | 8 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | Ordine | 9 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | Attivo | 10 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | DataCreazione | 11 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | CreatoDa | 12 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | DataModifica | 13 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | ModificatoDa | 14 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | DataCancellazione | 15 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | CancellatoDa | 16 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | UniqueRowId | 17 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | DataInizioValidita | 18 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettore | DataFineValidita | 19 | 0 | 2 | Tipologica.TipoCompetenzaIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | TipoCompetenzaIspettoreId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | Categoria | 5 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | RichiedeValiditaTemporale | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | DurataValiditaMesi | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | RichiedeRinnovo | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | Ordine | 9 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | Attivo | 10 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | DataCreazione | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | CreatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | DataModifica | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | ModificatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | DataCancellazione | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | CancellatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | UniqueRowId | 17 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | DataInizioValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoCompetenzaIspettoreStorico | DataFineValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | TipoContattoId | 1 | 0 | 2 | Tipologica.TipoContattoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__TipoCont__51BE5B96BD3F200A | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | Descrizione | 2 | 0 | 2 | Tipologica.TipoContattoStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | Codice | 3 | 0 | 2 | Tipologica.TipoContattoStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | Categoria | 4 | 0 | 2 | Tipologica.TipoContattoStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | FormatoValidazione | 5 | 0 | 2 | Tipologica.TipoContattoStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | PrefissoValore | 6 | 0 | 2 | Tipologica.TipoContattoStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | IconaCss | 7 | 0 | 2 | Tipologica.TipoContattoStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | Ordine | 8 | 0 | 2 | Tipologica.TipoContattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | DataCreazione | 9 | 0 | 2 | Tipologica.TipoContattoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | CreatoDa | 10 | 0 | 2 | Tipologica.TipoContattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | DataModifica | 11 | 0 | 2 | Tipologica.TipoContattoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | ModificatoDa | 12 | 0 | 2 | Tipologica.TipoContattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | DataCancellazione | 13 | 0 | 2 | Tipologica.TipoContattoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | CancellatoDa | 14 | 0 | 2 | Tipologica.TipoContattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | UniqueRowId | 15 | 0 | 2 | Tipologica.TipoContattoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | DataInizioValidita | 16 | 0 | 2 | Tipologica.TipoContattoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContatto | DataFineValidita | 17 | 0 | 2 | Tipologica.TipoContattoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | TipoContattoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | Descrizione | 2 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | Codice | 3 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | Categoria | 4 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | FormatoValidazione | 5 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | PrefissoValore | 6 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | IconaCss | 7 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | Ordine | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | DataCreazione | 9 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | CreatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | DataModifica | 11 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | ModificatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | DataCancellazione | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | CancellatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | UniqueRowId | 15 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | DataInizioValidita | 16 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContattoStorico | DataFineValidita | 17 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | TipoContrattoId | 1 | 0 | 2 | Tipologica.TipoContrattoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoContratto | 0 |  -> .. | MS_Description = Chiave primaria surrogate auto-incrementale. |
| Tipologica | TipoContratto | Codice | 2 | 0 | 2 | Tipologica.TipoContrattoStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice univoco tipo contratto. |
| Tipologica | TipoContratto | Descrizione | 3 | 0 | 2 | Tipologica.TipoContrattoStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.TipoContrattoStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | IsTempoIndeterminato | 5 | 0 | 2 | Tipologica.TipoContrattoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Flag per distinguere contratti stabili da quelli a termine. I contratti a tempo indeterminato non richiedono data scadenza e non hanno durata massima. \| MS_Description = TRUE se contratto a tempo indeterminato (senza scadenza). |
| Tipologica | TipoContratto | RichiedeDataScadenza | 6 | 0 | 2 | Tipologica.TipoContrattoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = TRUE se il contratto richiede obbligatoriamente una data di scadenza. |
| Tipologica | TipoContratto | DurataMaxMesi | 7 | 0 | 2 | Tipologica.TipoContrattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Limite massimo di durata imposto dalla normativa. Es: contratto a tempo determinato max 24 mesi (D.Lgs. 81/2015 Art. 19). Usato per validazioni e alert scadenze. \| MS_Description = Durata massima consentita in mesi per legge (NULL se illimitata). |
| Tipologica | TipoContratto | RiferimentoNormativo | 8 | 0 | 2 | Tipologica.TipoContrattoStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Riferimento normativo (es. D.Lgs. 81/2015 Art. X). |
| Tipologica | TipoContratto | Ordine | 9 | 0 | 2 | Tipologica.TipoContrattoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | Attivo | 10 | 0 | 2 | Tipologica.TipoContrattoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | DataCreazione | 11 | 0 | 2 | Tipologica.TipoContrattoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | CreatoDa | 12 | 0 | 2 | Tipologica.TipoContrattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | DataModifica | 13 | 0 | 2 | Tipologica.TipoContrattoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | ModificatoDa | 14 | 0 | 2 | Tipologica.TipoContrattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | DataCancellazione | 15 | 0 | 2 | Tipologica.TipoContrattoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | CancellatoDa | 16 | 0 | 2 | Tipologica.TipoContrattoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | UniqueRowId | 17 | 0 | 2 | Tipologica.TipoContrattoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | DataInizioValidita | 18 | 0 | 2 | Tipologica.TipoContrattoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContratto | DataFineValidita | 19 | 0 | 2 | Tipologica.TipoContrattoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | TipoContrattoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | IsTempoIndeterminato | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | RichiedeDataScadenza | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | DurataMaxMesi | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | RiferimentoNormativo | 8 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | Ordine | 9 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | Attivo | 10 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | DataCreazione | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | CreatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | DataModifica | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | ModificatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | DataCancellazione | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | CancellatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | UniqueRowId | 17 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | DataInizioValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoContrattoStorico | DataFineValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | TipoDirittoGDPRId | 1 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoDirittoGDPR | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | Codice | 2 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | Descrizione | 3 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | ArticoloGDPR | 4 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | TermineRispostaGiorni | 5 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | RichiedeVerificaIdentita | 6 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | Ordine | 7 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | DataCreazione | 8 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | CreatoDa | 9 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | DataModifica | 10 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | ModificatoDa | 11 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | DataCancellazione | 12 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | CancellatoDa | 13 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | UniqueRowId | 14 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | DataInizioValidita | 15 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPR | DataFineValidita | 16 | 0 | 2 | Tipologica.TipoDirittoGDPRStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | TipoDirittoGDPRId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | ArticoloGDPR | 4 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | TermineRispostaGiorni | 5 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | RichiedeVerificaIdentita | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | Ordine | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | DataCreazione | 8 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | CreatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | DataModifica | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | ModificatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | DataCancellazione | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | CancellatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | UniqueRowId | 14 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | DataInizioValidita | 15 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoGDPRStorico | DataFineValidita | 16 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | TipoDirittoInteressatoId | 1 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoDirittoInteressato | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | Codice | 2 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | Descrizione | 3 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | ArticoloGDPR | 4 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | DescrizioneEstesa | 5 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | GiorniMaxRisposta | 6 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | PuoEssereNegato | 7 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | Ordine | 8 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | DataCreazione | 9 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | CreatoDa | 10 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | DataModifica | 11 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | ModificatoDa | 12 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | DataCancellazione | 13 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | CancellatoDa | 14 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | UniqueRowId | 15 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | DataInizioValidita | 16 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressato | DataFineValidita | 17 | 0 | 2 | Tipologica.TipoDirittoInteressatoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | TipoDirittoInteressatoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | ArticoloGDPR | 4 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | DescrizioneEstesa | 5 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | GiorniMaxRisposta | 6 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | PuoEssereNegato | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | Ordine | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | DataCreazione | 9 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | CreatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | DataModifica | 11 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | ModificatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | DataCancellazione | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | CancellatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | UniqueRowId | 15 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | DataInizioValidita | 16 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDirittoInteressatoStorico | DataFineValidita | 17 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | TipoDotazioneId | 1 | 0 | 2 | Tipologica.TipoDotazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoDotazione | 0 |  -> .. | MS_Description = Chiave primaria surrogate auto-incrementale. |
| Tipologica | TipoDotazione | Codice | 2 | 0 | 2 | Tipologica.TipoDotazioneStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice univoco tipo dotazione. |
| Tipologica | TipoDotazione | Descrizione | 3 | 0 | 2 | Tipologica.TipoDotazioneStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.TipoDotazioneStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | Categoria | 5 | 0 | 2 | Tipologica.TipoDotazioneStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Raggruppamento per tipologia: INFORMATICA (hardware IT), COMUNICAZIONE (dispositivi comunicazione), ACCESSO (strumenti accesso fisico), MOBILITA (veicoli e accessori), ALTRO (varie). \| MS_Description = Categoria macro: INFORMATICA, COMUNICAZIONE, ACCESSO, MOBILITA, ALTRO. |
| Tipologica | TipoDotazione | RichiedeNumeroInventario | 6 | 0 | 2 | Tipologica.TipoDotazioneStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Se TRUE la dotazione richiede un numero inventario aziendale. |
| Tipologica | TipoDotazione | RichiedeRestituzione | 7 | 0 | 2 | Tipologica.TipoDotazioneStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Flag per checklist di offboarding. Le dotazioni con questo flag a TRUE devono essere verificate e restituite quando il dipendente cessa il rapporto. \| MS_Description = Se TRUE la dotazione deve essere restituita alla cessazione del rapporto. |
| Tipologica | TipoDotazione | Icona | 8 | 0 | 2 | Tipologica.TipoDotazioneStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | Ordine | 9 | 0 | 2 | Tipologica.TipoDotazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | Attivo | 10 | 0 | 2 | Tipologica.TipoDotazioneStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | DataCreazione | 11 | 0 | 2 | Tipologica.TipoDotazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | CreatoDa | 12 | 0 | 2 | Tipologica.TipoDotazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | DataModifica | 13 | 0 | 2 | Tipologica.TipoDotazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | ModificatoDa | 14 | 0 | 2 | Tipologica.TipoDotazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | DataCancellazione | 15 | 0 | 2 | Tipologica.TipoDotazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | CancellatoDa | 16 | 0 | 2 | Tipologica.TipoDotazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | UniqueRowId | 17 | 0 | 2 | Tipologica.TipoDotazioneStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | DataInizioValidita | 18 | 0 | 2 | Tipologica.TipoDotazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazione | DataFineValidita | 19 | 0 | 2 | Tipologica.TipoDotazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | TipoDotazioneId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | Categoria | 5 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | RichiedeNumeroInventario | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | RichiedeRestituzione | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | Icona | 8 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | Ordine | 9 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | Attivo | 10 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | DataCreazione | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | CreatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | DataModifica | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | ModificatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | DataCancellazione | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | CancellatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | UniqueRowId | 17 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | DataInizioValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoDotazioneStorico | DataFineValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | TipoEmailId | 1 | 0 | 2 | Tipologica.TipoEmailStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__TipoEmai__1C0DC5CAEACBEC44 | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | Codice | 2 | 0 | 2 | Tipologica.TipoEmailStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | Descrizione | 3 | 0 | 2 | Tipologica.TipoEmailStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | DataCreazione | 4 | 0 | 2 | Tipologica.TipoEmailStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | CreatoDa | 5 | 0 | 2 | Tipologica.TipoEmailStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | DataModifica | 6 | 0 | 2 | Tipologica.TipoEmailStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | ModificatoDa | 7 | 0 | 2 | Tipologica.TipoEmailStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | DataCancellazione | 8 | 0 | 2 | Tipologica.TipoEmailStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | CancellatoDa | 9 | 0 | 2 | Tipologica.TipoEmailStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | UniqueRowId | 10 | 0 | 2 | Tipologica.TipoEmailStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | DataInizioValidita | 11 | 0 | 2 | Tipologica.TipoEmailStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmail | DataFineValidita | 12 | 0 | 2 | Tipologica.TipoEmailStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | TipoEmailId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | Codice | 2 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | DataCreazione | 4 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | CreatoDa | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | DataModifica | 6 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | ModificatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | DataCancellazione | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | CancellatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | UniqueRowId | 10 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | DataInizioValidita | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEmailStorico | DataFineValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | TipoEventoRegolatorioId | 1 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoEventoRegolatorio | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | Codice | 2 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | Descrizione | 3 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | Categoria | 4 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | EnteCompetente | 5 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | RichiedeFollowUp | 6 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | GiorniMaxFollowUp | 7 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | GravitaDefault | 8 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | Ordine | 9 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | DataCreazione | 10 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | CreatoDa | 11 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | DataModifica | 12 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | ModificatoDa | 13 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | DataCancellazione | 14 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | CancellatoDa | 15 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | UniqueRowId | 16 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | DataInizioValidita | 17 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorio | DataFineValidita | 18 | 0 | 2 | Tipologica.TipoEventoRegolatorioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | TipoEventoRegolatorioId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | Categoria | 4 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | EnteCompetente | 5 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | RichiedeFollowUp | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | GiorniMaxFollowUp | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | GravitaDefault | 8 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | Ordine | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | DataCreazione | 10 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | CreatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | DataModifica | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | ModificatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | DataCancellazione | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | CancellatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | UniqueRowId | 16 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | DataInizioValidita | 17 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoEventoRegolatorioStorico | DataFineValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | TipoFinalitaTrattamentoId | 1 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoFinalitaTrattamento | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | Codice | 2 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | Descrizione | 3 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | Categoria | 5 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | BaseGiuridicaDefault | 6 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | RichiedeConsensoEsplicito | 7 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | DurataConservazioneAnni | 8 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | IsObbligatorio | 9 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | Ordine | 10 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | DataCreazione | 11 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | CreatoDa | 12 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | DataModifica | 13 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | ModificatoDa | 14 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | DataCancellazione | 15 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | CancellatoDa | 16 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | UniqueRowId | 17 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | DataInizioValidita | 18 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamento | DataFineValidita | 19 | 0 | 2 | Tipologica.TipoFinalitaTrattamentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | TipoFinalitaTrattamentoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | Categoria | 5 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | BaseGiuridicaDefault | 6 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | RichiedeConsensoEsplicito | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | DurataConservazioneAnni | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | IsObbligatorio | 9 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | Ordine | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | DataCreazione | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | CreatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | DataModifica | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | ModificatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | DataCancellazione | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | CancellatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | UniqueRowId | 17 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | DataInizioValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFinalitaTrattamentoStorico | DataFineValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | TipoFormazioneObbligatoriaId | 1 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoFormazioneObbligatoria | 0 |  -> .. | MS_Description = Chiave primaria surrogate auto-incrementale. |
| Tipologica | TipoFormazioneObbligatoria | Codice | 2 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice univoco tipo formazione. |
| Tipologica | TipoFormazioneObbligatoria | Descrizione | 3 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | Categoria | 5 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Categoria: SICUREZZA, PRIVACY, QUALITA, TECNICA, ALTRO. |
| Tipologica | TipoFormazioneObbligatoria | DurataOreMinima | 6 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Durata minima del corso in ore. |
| Tipologica | TipoFormazioneObbligatoria | ValiditaMesi | 7 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | Accredia.Doc = Durata validità dell attestato. Decorso questo periodo dalla data completamento, il corso deve essere ripetuto. NULL indica formazione che non scade (es. sicurezza generale). \| MS_Description = Validità in mesi. NULL se la formazione non scade mai. |
| Tipologica | TipoFormazioneObbligatoria | RiferimentoNormativo | 8 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Riferimento normativo che impone la formazione. |
| Tipologica | TipoFormazioneObbligatoria | ObbligatoriaPerTutti | 9 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Se TRUE tutti i dipendenti devono completare questa formazione. |
| Tipologica | TipoFormazioneObbligatoria | Ordine | 10 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | Attivo | 11 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | DataCreazione | 12 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | CreatoDa | 13 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | DataModifica | 14 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | ModificatoDa | 15 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | DataCancellazione | 16 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | CancellatoDa | 17 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | UniqueRowId | 18 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | DataInizioValidita | 19 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoria | DataFineValidita | 20 | 0 | 2 | Tipologica.TipoFormazioneObbligatoriaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | TipoFormazioneObbligatoriaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | Categoria | 5 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | DurataOreMinima | 6 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | ValiditaMesi | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | RiferimentoNormativo | 8 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | ObbligatoriaPerTutti | 9 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | Ordine | 10 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | Attivo | 11 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | DataCreazione | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | CreatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | DataModifica | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | ModificatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | DataCancellazione | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | CancellatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | UniqueRowId | 18 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | DataInizioValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFormazioneObbligatoriaStorico | DataFineValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | TipoFunzioneUnitaLocaleId | 1 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__TipoFunz__EBAEFA55D774A1C7 | 0 |  -> .. | MS_Description = Identificatore univoco |
| Tipologica | TipoFunzioneUnitaLocale | Codice | 2 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice identificativo |
| Tipologica | TipoFunzioneUnitaLocale | Descrizione | 3 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | nvarchar | 150 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione dettagliata |
| Tipologica | TipoFunzioneUnitaLocale | Ordine | 4 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | DataCreazione | 5 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | CreatoDa | 6 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | DataModifica | 7 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | ModificatoDa | 8 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | DataCancellazione | 9 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | CancellatoDa | 10 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | UniqueRowId | 11 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | DataInizioValidita | 12 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocale | DataFineValidita | 13 | 0 | 2 | Tipologica.TipoFunzioneUnitaLocaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | TipoFunzioneUnitaLocaleId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 150 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | Ordine | 4 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | DataCreazione | 5 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | CreatoDa | 6 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | DataModifica | 7 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | ModificatoDa | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | DataCancellazione | 9 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | CancellatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | UniqueRowId | 11 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | DataInizioValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoFunzioneUnitaLocaleStorico | DataFineValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | TipoIncompatibilitaId | 1 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoIncompatibilita | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | Codice | 2 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | Descrizione | 3 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | Categoria | 5 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | RiferimentoConvenzione | 6 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | Gravita | 7 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | AmmetteDeroghe | 8 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | Ordine | 9 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | Attivo | 10 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | DataCreazione | 11 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | CreatoDa | 12 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | DataModifica | 13 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | ModificatoDa | 14 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | DataCancellazione | 15 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | CancellatoDa | 16 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | UniqueRowId | 17 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | DataInizioValidita | 18 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilita | DataFineValidita | 19 | 0 | 2 | Tipologica.TipoIncompatibilitaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | TipoIncompatibilitaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | Categoria | 5 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | RiferimentoConvenzione | 6 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | Gravita | 7 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | AmmetteDeroghe | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | Ordine | 9 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | Attivo | 10 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | DataCreazione | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | CreatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | DataModifica | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | ModificatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | DataCancellazione | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | CancellatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | UniqueRowId | 17 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | DataInizioValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIncompatibilitaStorico | DataFineValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | TipoIndirizzoId | 1 | 0 | 2 | Tipologica.TipoIndirizzoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__TipoIndi__D7EB055B7EE5ED60 | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | Descrizione | 2 | 0 | 2 | Tipologica.TipoIndirizzoStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | Codice | 3 | 0 | 2 | Tipologica.TipoIndirizzoStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | DataCreazione | 4 | 0 | 2 | Tipologica.TipoIndirizzoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | CreatoDa | 5 | 0 | 2 | Tipologica.TipoIndirizzoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | DataModifica | 6 | 0 | 2 | Tipologica.TipoIndirizzoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | ModificatoDa | 7 | 0 | 2 | Tipologica.TipoIndirizzoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | DataCancellazione | 8 | 0 | 2 | Tipologica.TipoIndirizzoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | CancellatoDa | 9 | 0 | 2 | Tipologica.TipoIndirizzoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | UniqueRowId | 10 | 0 | 2 | Tipologica.TipoIndirizzoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | DataInizioValidita | 11 | 0 | 2 | Tipologica.TipoIndirizzoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzo | DataFineValidita | 12 | 0 | 2 | Tipologica.TipoIndirizzoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | TipoIndirizzoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | Descrizione | 2 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | Codice | 3 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | DataCreazione | 4 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | CreatoDa | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | DataModifica | 6 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | ModificatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | DataCancellazione | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | CancellatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | UniqueRowId | 10 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | DataInizioValidita | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoIndirizzoStorico | DataFineValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | TipoOrganismoId | 1 | 0 | 2 | Tipologica.TipoOrganismoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoOrganismo | 0 |  -> .. | MS_Description = Chiave primaria |
| Tipologica | TipoOrganismo | Codice | 2 | 0 | 2 | Tipologica.TipoOrganismoStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice organismo (SOG, AGR, SAM, OdV) |
| Tipologica | TipoOrganismo | Descrizione | 3 | 0 | 2 | Tipologica.TipoOrganismoStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione |
| Tipologica | TipoOrganismo | NormaRiferimento | 4 | 0 | 2 | Tipologica.TipoOrganismoStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | Attivo | 5 | 0 | 2 | Tipologica.TipoOrganismoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag attivo |
| Tipologica | TipoOrganismo | rowguid | 6 | 0 | 2 | Tipologica.TipoOrganismoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | DataCreazione | 7 | 0 | 2 | Tipologica.TipoOrganismoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | CreatoDa | 8 | 0 | 2 | Tipologica.TipoOrganismoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | DataModifica | 9 | 0 | 2 | Tipologica.TipoOrganismoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | ModificatoDa | 10 | 0 | 2 | Tipologica.TipoOrganismoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | DataCancellazione | 11 | 0 | 2 | Tipologica.TipoOrganismoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | CancellatoDa | 12 | 0 | 2 | Tipologica.TipoOrganismoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | DataInizioValidita | 13 | 0 | 2 | Tipologica.TipoOrganismoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismo | DataFineValidita | 14 | 0 | 2 | Tipologica.TipoOrganismoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | TipoOrganismoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | NormaRiferimento | 4 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | Attivo | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | rowguid | 6 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | DataCreazione | 7 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | CreatoDa | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | DataModifica | 9 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | ModificatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | DataCancellazione | 11 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | CancellatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganismoStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | TipoOrganizzazioneId | 1 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoOrganizzazione | 0 |  -> .. | MS_Description = Chiave primaria |
| Tipologica | TipoOrganizzazione | Codice | 2 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice univoco (es: OC_SGQ, LAB_PROVA, OI) |
| Tipologica | TipoOrganizzazione | Descrizione | 3 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | nvarchar | 250 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | CodiceSchemaAccreditamento | 4 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Schema accreditamento ACCREDIA (SGQ, PRD, PRS, ISP, VHG, LAB, LAT, MED, PTP, RMP, BIO) |
| Tipologica | TipoOrganizzazione | NormaRiferimento | 5 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Norma ISO/IEC di riferimento (es: 17021-1, 17025, 17020) |
| Tipologica | TipoOrganizzazione | Attivo | 6 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | DataCreazione | 7 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | CreatoDa | 8 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | DataModifica | 9 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | ModificatoDa | 10 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | DataCancellazione | 11 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | CancellatoDa | 12 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | UniqueRowId | 13 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | DataInizioValidita | 14 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazione | DataFineValidita | 15 | 0 | 2 | Tipologica.TipoOrganizzazioneStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSede | TipoOrganizzazioneSedeId | 1 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | tinyint |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoOrganizzazioneSede | 0 |  -> .. | MS_Description = Identificatore univoco |
| Tipologica | TipoOrganizzazioneSede | Codice | 2 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Codice identificativo |
| Tipologica | TipoOrganizzazioneSede | Descrizione | 3 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione dettagliata |
| Tipologica | TipoOrganizzazioneSede | Attivo | 4 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Flag di attivazione |
| Tipologica | TipoOrganizzazioneSede | rowguid | 5 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSede | DataCreazione | 6 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSede | CreatoDa | 7 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSede | DataModifica | 8 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSede | ModificatoDa | 9 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSede | DataCancellazione | 10 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSede | CancellatoDa | 11 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSede | DataInizioValidita | 12 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSede | DataFineValidita | 13 | 0 | 2 | Tipologica.TipoOrganizzazioneSedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | TipoOrganizzazioneSedeId | 1 | 1 | 1 |  | tinyint |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | Attivo | 4 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | rowguid | 5 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | DataInizioValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneSedeStorico | DataFineValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | TipoOrganizzazioneId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | Codice | 2 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 250 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | CodiceSchemaAccreditamento | 4 | 1 | 1 |  | nvarchar | 20 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | NormaRiferimento | 5 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | Attivo | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | DataCreazione | 7 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | CreatoDa | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | DataModifica | 9 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | ModificatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | DataCancellazione | 11 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | CancellatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | UniqueRowId | 13 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | DataInizioValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoOrganizzazioneStorico | DataFineValidita | 15 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | TipoPotereId | 1 | 0 | 2 | Tipologica.TipoPotereStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoPotere | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | Codice | 2 | 0 | 2 | Tipologica.TipoPotereStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | Descrizione | 3 | 0 | 2 | Tipologica.TipoPotereStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | Categoria | 4 | 0 | 2 | Tipologica.TipoPotereStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | RichiedeLimiteImporto | 5 | 0 | 2 | Tipologica.TipoPotereStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | RichiedeScadenza | 6 | 0 | 2 | Tipologica.TipoPotereStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | FonteNormativa | 7 | 0 | 2 | Tipologica.TipoPotereStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | DescrizioneEstesa | 8 | 0 | 2 | Tipologica.TipoPotereStorico | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | Ordine | 9 | 0 | 2 | Tipologica.TipoPotereStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | Attivo | 10 | 0 | 2 | Tipologica.TipoPotereStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | DataCreazione | 11 | 0 | 2 | Tipologica.TipoPotereStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | CreatoDa | 12 | 0 | 2 | Tipologica.TipoPotereStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | DataModifica | 13 | 0 | 2 | Tipologica.TipoPotereStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | ModificatoDa | 14 | 0 | 2 | Tipologica.TipoPotereStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | DataCancellazione | 15 | 0 | 2 | Tipologica.TipoPotereStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | CancellatoDa | 16 | 0 | 2 | Tipologica.TipoPotereStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | UniqueRowId | 17 | 0 | 2 | Tipologica.TipoPotereStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | DataInizioValidita | 18 | 0 | 2 | Tipologica.TipoPotereStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotere | DataFineValidita | 19 | 0 | 2 | Tipologica.TipoPotereStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | TipoPotereId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | Categoria | 4 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | RichiedeLimiteImporto | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | RichiedeScadenza | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | FonteNormativa | 7 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | DescrizioneEstesa | 8 | 1 | 1 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | Ordine | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | Attivo | 10 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | DataCreazione | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | CreatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | DataModifica | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | ModificatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | DataCancellazione | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | CancellatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | UniqueRowId | 17 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | DataInizioValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoPotereStorico | DataFineValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | TipoProvvedimentoId | 1 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoProvvedimento | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | Codice | 2 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | Descrizione | 3 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | Categoria | 4 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | Gravita | 5 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | RichiedeAzioneCorrettiva | 6 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | GiorniMaxRisoluzione | 7 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | ImpattaAccreditamento | 8 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | Ordine | 9 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | DataCreazione | 10 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | CreatoDa | 11 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | DataModifica | 12 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | ModificatoDa | 13 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | DataCancellazione | 14 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | CancellatoDa | 15 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | UniqueRowId | 16 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | DataInizioValidita | 17 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimento | DataFineValidita | 18 | 0 | 2 | Tipologica.TipoProvvedimentoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | TipoProvvedimentoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | Categoria | 4 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | Gravita | 5 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | RichiedeAzioneCorrettiva | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | GiorniMaxRisoluzione | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | ImpattaAccreditamento | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | Ordine | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | DataCreazione | 10 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | CreatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | DataModifica | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | ModificatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | DataCancellazione | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | CancellatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | UniqueRowId | 16 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | DataInizioValidita | 17 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoProvvedimentoStorico | DataFineValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | TipoQualificaId | 1 | 0 | 2 | Tipologica.TipoQualificaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoQualifica | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | Codice | 2 | 0 | 2 | Tipologica.TipoQualificaStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | Descrizione | 3 | 0 | 2 | Tipologica.TipoQualificaStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | Categoria | 4 | 0 | 2 | Tipologica.TipoQualificaStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | RichiedeScadenza | 5 | 0 | 2 | Tipologica.TipoQualificaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | DataCreazione | 6 | 0 | 2 | Tipologica.TipoQualificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | CreatoDa | 7 | 0 | 2 | Tipologica.TipoQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | DataModifica | 8 | 0 | 2 | Tipologica.TipoQualificaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | ModificatoDa | 9 | 0 | 2 | Tipologica.TipoQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | DataCancellazione | 10 | 0 | 2 | Tipologica.TipoQualificaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | CancellatoDa | 11 | 0 | 2 | Tipologica.TipoQualificaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | UniqueRowId | 12 | 0 | 2 | Tipologica.TipoQualificaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | DataInizioValidita | 13 | 0 | 2 | Tipologica.TipoQualificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualifica | DataFineValidita | 14 | 0 | 2 | Tipologica.TipoQualificaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | TipoQualificaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | Categoria | 4 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | RichiedeScadenza | 5 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoQualificaStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | TipoRelazionePersonaleId | 1 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoRelazionePersonale | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | Codice | 2 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | Descrizione | 3 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | Simmetrica | 4 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | TipoRelazioneInversaId | 5 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_TipoRelazionePersonale_Inversa -> Tipologica.TipoRelazionePersonale.TipoRelazionePersonaleId | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | DataCreazione | 6 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | CreatoDa | 7 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | DataModifica | 8 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | ModificatoDa | 9 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | DataCancellazione | 10 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | CancellatoDa | 11 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | UniqueRowId | 12 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | DataInizioValidita | 13 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonale | DataFineValidita | 14 | 0 | 2 | Tipologica.TipoRelazionePersonaleStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | TipoRelazionePersonaleId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | Simmetrica | 4 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | TipoRelazioneInversaId | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRelazionePersonaleStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | TipoRuoloId | 1 | 0 | 2 | Tipologica.TipoRuoloStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoRuolo | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | Codice | 2 | 0 | 2 | Tipologica.TipoRuoloStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | Descrizione | 3 | 0 | 2 | Tipologica.TipoRuoloStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | Categoria | 4 | 0 | 2 | Tipologica.TipoRuoloStorico | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | CategoriaAccredia | 5 | 0 | 2 | Tipologica.TipoRuoloStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | RequisitiMinimi | 6 | 0 | 2 | Tipologica.TipoRuoloStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | FonteNormativa | 7 | 0 | 2 | Tipologica.TipoRuoloStorico | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | RichiedeIscrizioneAlbo | 8 | 0 | 2 | Tipologica.TipoRuoloStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | AlboRiferimento | 9 | 0 | 2 | Tipologica.TipoRuoloStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | LimiteMaxPerOrganizzazione | 10 | 0 | 2 | Tipologica.TipoRuoloStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | LimiteMaxPerUO | 11 | 0 | 2 | Tipologica.TipoRuoloStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | Ordine | 12 | 0 | 2 | Tipologica.TipoRuoloStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | Attivo | 13 | 0 | 2 | Tipologica.TipoRuoloStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | DataCreazione | 14 | 0 | 2 | Tipologica.TipoRuoloStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | CreatoDa | 15 | 0 | 2 | Tipologica.TipoRuoloStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | DataModifica | 16 | 0 | 2 | Tipologica.TipoRuoloStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | ModificatoDa | 17 | 0 | 2 | Tipologica.TipoRuoloStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | DataCancellazione | 18 | 0 | 2 | Tipologica.TipoRuoloStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | CancellatoDa | 19 | 0 | 2 | Tipologica.TipoRuoloStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | UniqueRowId | 20 | 0 | 2 | Tipologica.TipoRuoloStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | DataInizioValidita | 21 | 0 | 2 | Tipologica.TipoRuoloStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuolo | DataFineValidita | 22 | 0 | 2 | Tipologica.TipoRuoloStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | TipoRuoloIspettoreId | 1 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoRuoloIspettore | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | Codice | 2 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | Descrizione | 3 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | DescrizioneEstesa | 4 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | Categoria | 5 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | PuoEssereTeamLeader | 6 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | PuoCondurreVerificaSistema | 7 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | PuoCondurreVerificaTecnica | 8 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | RequisitiMinimi | 9 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | Ordine | 10 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | Attivo | 11 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | DataCreazione | 12 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | CreatoDa | 13 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | DataModifica | 14 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | ModificatoDa | 15 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | DataCancellazione | 16 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | CancellatoDa | 17 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | UniqueRowId | 18 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | DataInizioValidita | 19 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettore | DataFineValidita | 20 | 0 | 2 | Tipologica.TipoRuoloIspettoreStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | TipoRuoloIspettoreId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | DescrizioneEstesa | 4 | 1 | 1 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | Categoria | 5 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | PuoEssereTeamLeader | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | PuoCondurreVerificaSistema | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | PuoCondurreVerificaTecnica | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | RequisitiMinimi | 9 | 1 | 1 |  | nvarchar | MAX | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | Ordine | 10 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | Attivo | 11 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | DataCreazione | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | CreatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | DataModifica | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | ModificatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | DataCancellazione | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | CancellatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | UniqueRowId | 18 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | DataInizioValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloIspettoreStorico | DataFineValidita | 20 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | TipoRuoloId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | Codice | 2 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | Categoria | 4 | 1 | 1 |  | nvarchar | 30 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | CategoriaAccredia | 5 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | RequisitiMinimi | 6 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | FonteNormativa | 7 | 1 | 1 |  | nvarchar | 200 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | RichiedeIscrizioneAlbo | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | AlboRiferimento | 9 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | LimiteMaxPerOrganizzazione | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | LimiteMaxPerUO | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | Ordine | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | Attivo | 13 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | DataCreazione | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | CreatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | DataModifica | 16 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | ModificatoDa | 17 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | DataCancellazione | 18 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | CancellatoDa | 19 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | UniqueRowId | 20 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | DataInizioValidita | 21 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoRuoloStorico | DataFineValidita | 22 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | TipoSedeId | 1 | 0 | 2 | Tipologica.TipoSedeStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoSede | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | Codice | 2 | 0 | 2 | Tipologica.TipoSedeStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | Descrizione | 3 | 0 | 2 | Tipologica.TipoSedeStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | DescrizioneBreve | 4 | 0 | 2 | Tipologica.TipoSedeStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | NormaRiferimento | 5 | 0 | 2 | Tipologica.TipoSedeStorico | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | AutonomiaGestionale | 6 | 0 | 2 | Tipologica.TipoSedeStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | Accreditabile | 7 | 0 | 2 | Tipologica.TipoSedeStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | IsSedeUnica | 8 | 0 | 2 | Tipologica.TipoSedeStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | Ordine | 9 | 0 | 2 | Tipologica.TipoSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | Attivo | 10 | 0 | 2 | Tipologica.TipoSedeStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | DataCreazione | 11 | 0 | 2 | Tipologica.TipoSedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | CreatoDa | 12 | 0 | 2 | Tipologica.TipoSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | DataModifica | 13 | 0 | 2 | Tipologica.TipoSedeStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | ModificatoDa | 14 | 0 | 2 | Tipologica.TipoSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | DataCancellazione | 15 | 0 | 2 | Tipologica.TipoSedeStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | CancellatoDa | 16 | 0 | 2 | Tipologica.TipoSedeStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | rowguid | 17 | 0 | 2 | Tipologica.TipoSedeStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | DataInizioValidita | 18 | 0 | 2 | Tipologica.TipoSedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | DataFineValidita | 19 | 0 | 2 | Tipologica.TipoSedeStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSede | NoteAccreditabilita | 20 | 0 | 2 | Tipologica.TipoSedeStorico | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | TipoSedeId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | Codice | 2 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | DescrizioneBreve | 4 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | NormaRiferimento | 5 | 1 | 1 |  | nvarchar | 100 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | AutonomiaGestionale | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | Accreditabile | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | IsSedeUnica | 8 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | Ordine | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | Attivo | 10 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | DataCreazione | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | CreatoDa | 12 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | DataModifica | 13 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | ModificatoDa | 14 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | DataCancellazione | 15 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | CancellatoDa | 16 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | rowguid | 17 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | DataInizioValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | DataFineValidita | 19 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSedeStorico | NoteAccreditabilita | 20 | 1 | 1 |  | nvarchar | 1000 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | TipoSistemaFormativoId | 1 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoSistemaFormativo | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | Descrizione | 2 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | Codice | 3 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | RiferimentoNormativo | 4 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | Ordine | 5 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | DataCreazione | 6 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | CreatoDa | 7 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | DataModifica | 8 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | ModificatoDa | 9 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | DataCancellazione | 10 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | CancellatoDa | 11 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | UniqueRowId | 12 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | DataInizioValidita | 13 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativo | DataFineValidita | 14 | 0 | 2 | Tipologica.TipoSistemaFormativoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | TipoSistemaFormativoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | Descrizione | 2 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | Codice | 3 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | RiferimentoNormativo | 4 | 1 | 1 |  | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | Ordine | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoSistemaFormativoStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | TipoTelefonoId | 1 | 0 | 2 | Tipologica.TipoTelefonoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__TipoTele__08B1AC81DBDC01F9 | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | Codice | 2 | 0 | 2 | Tipologica.TipoTelefonoStorico | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | Descrizione | 3 | 0 | 2 | Tipologica.TipoTelefonoStorico | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | DataCreazione | 4 | 0 | 2 | Tipologica.TipoTelefonoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | CreatoDa | 5 | 0 | 2 | Tipologica.TipoTelefonoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | DataModifica | 6 | 0 | 2 | Tipologica.TipoTelefonoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | ModificatoDa | 7 | 0 | 2 | Tipologica.TipoTelefonoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | DataCancellazione | 8 | 0 | 2 | Tipologica.TipoTelefonoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | CancellatoDa | 9 | 0 | 2 | Tipologica.TipoTelefonoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | UniqueRowId | 10 | 0 | 2 | Tipologica.TipoTelefonoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | DataInizioValidita | 11 | 0 | 2 | Tipologica.TipoTelefonoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefono | DataFineValidita | 12 | 0 | 2 | Tipologica.TipoTelefonoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | TipoTelefonoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | Codice | 2 | 1 | 1 |  | nvarchar | 50 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 200 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | DataCreazione | 4 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | CreatoDa | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | DataModifica | 6 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | ModificatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | DataCancellazione | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | CancellatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | UniqueRowId | 10 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | DataInizioValidita | 11 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTelefonoStorico | DataFineValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | TipoTitoloStudioId | 1 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoTitoloStudio | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | Descrizione | 2 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | nvarchar | 250 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | Codice | 3 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | LivelloTitoloStudioId | 4 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_TipoTitoloStudio_Livello -> Tipologica.LivelloTitoloStudio.LivelloTitoloStudioId | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | TipoSistemaFormativoId | 5 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 1 | FK_TipoTitoloStudio_Sistema -> Tipologica.TipoSistemaFormativo.TipoSistemaFormativoId | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | HaValoreLegale | 6 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | RichiedeTitoloPrevio | 7 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | RiferimentoNormativo | 8 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | Ordine | 9 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | DataCreazione | 10 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | CreatoDa | 11 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | DataModifica | 12 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | ModificatoDa | 13 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | DataCancellazione | 14 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | CancellatoDa | 15 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | UniqueRowId | 16 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | DataInizioValidita | 17 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudio | DataFineValidita | 18 | 0 | 2 | Tipologica.TipoTitoloStudioStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | TipoTitoloStudioId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | Descrizione | 2 | 1 | 1 |  | nvarchar | 250 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | Codice | 3 | 1 | 1 |  | nvarchar | 20 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | LivelloTitoloStudioId | 4 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | TipoSistemaFormativoId | 5 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | HaValoreLegale | 6 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | RichiedeTitoloPrevio | 7 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | RiferimentoNormativo | 8 | 1 | 1 |  | nvarchar | 300 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | Ordine | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | DataCreazione | 10 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | CreatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | DataModifica | 12 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | ModificatoDa | 13 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | DataCancellazione | 14 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | CancellatoDa | 15 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | UniqueRowId | 16 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | DataInizioValidita | 17 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoTitoloStudioStorico | DataFineValidita | 18 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | TipoUnitaOrganizzativaId | 1 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TipoUnitaOrganizzativa | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | Codice | 2 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | Descrizione | 3 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | nvarchar | 150 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | TipoUnitaOrganizzativaCategoriaId | 4 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 1 | FK_TipoUnitaOrganizzativa_TipoUnitaOrganizzativaCategoria -> Tipologica.TipoUnitaOrganizzativaCategoria.TipoUnitaOrganizzativaCategoriaId | MS_Description = FK verso TipoUnitaOrganizzativaCategoria. Identifica la categoria gerarchica del tipo (es. LAB=Laboratori, ORG=Organismi, ISP=Ispezione) |
| Tipologica | TipoUnitaOrganizzativa | OrdineGerarchico | 5 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | DataCreazione | 6 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | CreatoDa | 7 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | DataModifica | 8 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | ModificatoDa | 9 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | DataCancellazione | 10 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | CancellatoDa | 11 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | UniqueRowId | 12 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | DataInizioValidita | 13 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | DataFineValidita | 14 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | CategoriaRegolatoria | 15 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | IsAuditabile | 16 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | HasResponsabilitaTecnica | 17 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | PuoSvolgereAttivitaAccreditate | 18 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativa | NoteNormative | 19 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaStorico | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoria | TipoUnitaOrganizzativaCategoriaId | 1 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK__TipoUnit__C9257F2D1690BF94 | 0 |  -> .. | MS_Description = Chiave primaria |
| Tipologica | TipoUnitaOrganizzativaCategoria | Codice | 2 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Codice della categoria |
| Tipologica | TipoUnitaOrganizzativaCategoria | Descrizione | 3 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | nvarchar | 150 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | MS_Description = Descrizione |
| Tipologica | TipoUnitaOrganizzativaCategoria | OrdineGerarchico | 4 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | MS_Description = Ordine gerarchico |
| Tipologica | TipoUnitaOrganizzativaCategoria | DataCreazione | 5 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoria | CreatoDa | 6 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoria | DataModifica | 7 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoria | ModificatoDa | 8 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoria | DataCancellazione | 9 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoria | CancellatoDa | 10 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoria | UniqueRowId | 11 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoria | DataInizioValidita | 12 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoria | DataFineValidita | 13 | 0 | 2 | Tipologica.TipoUnitaOrganizzativaCategoriaStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | TipoUnitaOrganizzativaCategoriaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 150 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | OrdineGerarchico | 4 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | DataCreazione | 5 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | CreatoDa | 6 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | DataModifica | 7 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | ModificatoDa | 8 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | DataCancellazione | 9 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | CancellatoDa | 10 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | UniqueRowId | 11 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | DataInizioValidita | 12 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaCategoriaStorico | DataFineValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | TipoUnitaOrganizzativaId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | Codice | 2 | 1 | 1 |  | nvarchar | 10 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 150 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | TipoUnitaOrganizzativaCategoriaId | 4 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | OrdineGerarchico | 5 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | CategoriaRegolatoria | 15 | 1 | 1 |  | nvarchar | 30 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | IsAuditabile | 16 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | HasResponsabilitaTecnica | 17 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | PuoSvolgereAttivitaAccreditate | 18 | 1 | 1 |  | bit |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TipoUnitaOrganizzativaStorico | NoteNormative | 19 | 1 | 1 |  | nvarchar | 500 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | TitoloOnorificoId | 1 | 0 | 2 | Tipologica.TitoloOnorificoStorico | int |  | OBBLIGATORIO | NOT NULL | 1 | PK_TitoloOnorifico | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | Codice | 2 | 0 | 2 | Tipologica.TitoloOnorificoStorico | nvarchar | 10 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | Descrizione | 3 | 0 | 2 | Tipologica.TitoloOnorificoStorico | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | TitoloMaschile | 4 | 0 | 2 | Tipologica.TitoloOnorificoStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | TitoloFemminile | 5 | 0 | 2 | Tipologica.TitoloOnorificoStorico | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | DataCreazione | 6 | 0 | 2 | Tipologica.TitoloOnorificoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | CreatoDa | 7 | 0 | 2 | Tipologica.TitoloOnorificoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | DataModifica | 8 | 0 | 2 | Tipologica.TitoloOnorificoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | ModificatoDa | 9 | 0 | 2 | Tipologica.TitoloOnorificoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | DataCancellazione | 10 | 0 | 2 | Tipologica.TitoloOnorificoStorico | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | CancellatoDa | 11 | 0 | 2 | Tipologica.TitoloOnorificoStorico | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | UniqueRowId | 12 | 0 | 2 | Tipologica.TitoloOnorificoStorico | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | DataInizioValidita | 13 | 0 | 2 | Tipologica.TitoloOnorificoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorifico | DataFineValidita | 14 | 0 | 2 | Tipologica.TitoloOnorificoStorico | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | TitoloOnorificoId | 1 | 1 | 1 |  | int |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | Codice | 2 | 1 | 1 |  | nvarchar | 10 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | Descrizione | 3 | 1 | 1 |  | nvarchar | 100 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | TitoloMaschile | 4 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | TitoloFemminile | 5 | 1 | 1 |  | nvarchar | 50 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | DataCreazione | 6 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | CreatoDa | 7 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | DataModifica | 8 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | ModificatoDa | 9 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | DataCancellazione | 10 | 1 | 1 |  | datetime2 | 7 | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | CancellatoDa | 11 | 1 | 1 |  | int |  | OPZIONALE | NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | UniqueRowId | 12 | 1 | 1 |  | uniqueidentifier |  | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | DataInizioValidita | 13 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |
| Tipologica | TitoloOnorificoStorico | DataFineValidita | 14 | 1 | 1 |  | datetime2 | 7 | OBBLIGATORIO | NOT NULL | 0 |  | 0 |  -> .. | (Nessuna proprietà) |