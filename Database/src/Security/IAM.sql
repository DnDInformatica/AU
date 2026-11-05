CREATE SCHEMA [IAM]
    AUTHORIZATION [dbo];


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.06', @level0type = N'SCHEMA', @level0name = N'IAM';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'IAM';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'IAM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Schema IAM (Identity and Access Management) ACCREDIA. Gestisce utenti, ruoli, permessi e associazioni con OdC e ispettori esterni. Sostituisce lo schema Identity (ASP.NET Identity) con un modello nativo ACCREDIA integrato con Entra ID e Entra External ID.', @level0type = N'SCHEMA', @level0name = N'IAM';


GO

