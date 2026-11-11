-- STATUS: FREIGEGEBEN (Setup, kein Schema)
-- ZWECK: Phase 4.8 – Managed Identity der Container App (DAB) als DB-User, lesen + schreiben.
-- Ausführen als Entra-Admin NACH infra/03-containerapp.sh (Identity muss existieren).
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'ca-hf-crm-dab')
    CREATE USER [ca-hf-crm-dab] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [ca-hf-crm-dab];
ALTER ROLE db_datawriter ADD MEMBER [ca-hf-crm-dab];
-- Bewusst KEIN db_ddladmin: Schemaänderungen nur durch Hugo.
