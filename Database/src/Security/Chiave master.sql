-- Chiave master del database: protegge le credenziali con ambito database
-- usate dalle origini dati esterne (staging GIDAS, SIAC, SIA).
-- Nessuna password nel progetto: su Azure SQL e' facoltativa e la chiave
-- esistente non viene ricreata dal rilascio. Se serve una protezione con
-- password, si aggiunge a mano (ALTER MASTER KEY ADD ENCRYPTION BY PASSWORD)
-- con un valore conservato in Key Vault; procedura in
-- docs/sicurezza/20261105-segreti-e-rotazioni.md.
CREATE MASTER KEY;
GO
