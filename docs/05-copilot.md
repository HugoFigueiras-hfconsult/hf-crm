# Phase 6 – Copilot Studio (nur lesen)

Status: ⬜ offen. Hängt an Schema (O3) und Phase 2.

| # | Schritt | Detail | Status |
|---|---|---|---|
| 6.1 | Service Principal | Entra-App `hf-crm-copilot`, in SQL `db/setup/02_user_copilot.sql` (nur `db_datareader`) | ⬜ |
| 6.2 | Agent anlegen | copilotstudio.microsoft.com → Wissen → Azure SQL → Tabellen wählen | ⬜ |
| 6.3 | Kostenschutz | Nur interne Nutzung unter Hugos Identität im Copilot-Business-Umfang. **Keine** Agent Flows/Autonomie (Credits). Power Platform Admin Center → Licensing → Copilot Studio → Manage Agents → Set limit (Hard Stop) | ⬜ |

Datensparsamkeit: Nur Tabellen/Spalten freigeben, die Copilot wirklich braucht.

Quellen:
- https://www.matthewdevaney.com/copilot-studio-connect-an-azure-sql-database-as-knowledge/
- https://learn.microsoft.com/en-us/power-platform/admin/manage-copilot-studio-copilot-credits-capacity
