-- STATUS: FREIGEGEBEN (Setup, kein Schema)
-- ZWECK: Phase 6.1 – Service Principal für Copilot Studio, NUR lesen.
-- Ausführen als Entra-Admin, nachdem die Entra-App 'hf-crm-copilot' existiert.
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'hf-crm-copilot')
    CREATE USER [hf-crm-copilot] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [hf-crm-copilot];
