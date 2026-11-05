CREATE SCHEMA [Platform]
    AUTHORIZATION [dbo];


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Owner', @value = N'DC', @level0type = N'SCHEMA', @level0name = N'Platform';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.Status', @value = N'Active', @level0type = N'SCHEMA', @level0name = N'Platform';


GO

EXECUTE sp_addextendedproperty @name = N'Accredia.SinceVersion', @value = N'2026.06', @level0type = N'SCHEMA', @level0name = N'Platform';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Schema di configurazione operativa della piattaforma SIGAD. Contiene la configurazione runtime dei worker job e dei domini di pubblicazione certificati.', @level0type = N'SCHEMA', @level0name = N'Platform';


GO

