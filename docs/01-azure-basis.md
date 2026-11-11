# Phase 1 + 2 – Azure-Basis und Azure SQL (Free Offer)

Status: 🟡 Skripte vorbereitet, nicht ausgeführt. Ausführen: **Hugo auf dem Laptop** (Login/MFA macht Hugo).

## Voraussetzungen lokal

- Azure CLI aktuell (`az upgrade`), Free-Offer-Flags brauchen eine aktuelle Version
- `go-sqlcmd` (für Migrationen)

## 1.2 Abo + Tenant prüfen (zuerst!)

```bash
az login
```

```bash
az account show --query "{abo:name, id:id, tenant:tenantId, user:user.name}" -o table
```

**Risiko R1:** Die Tenant-ID muss die des M365-Tenants `hf-consult.de` sein (M365 Admin Center → Einstellungen → Organisationseinstellungen → Organisationsprofil). Ist sie anders, wurde mit der Testversion ein **neuer** Tenant „HF Consulting“ angelegt. Dann vor jeder Ressource: Portal → Abonnements → Abo → „Verzeichnis ändern“ → M365-Tenant. Sonst scheitern Phase 5.2 (verifizierte Domain) und Phase 6 (Copilot).

Abo-ID + Tenant-ID in `infra/00-vars.sh` (`SUBSCRIPTION_ID`, `TENANT_ID`) und `docs/LOG.md` eintragen. Das sind keine Secrets.

## 1.4 Budget 5 €

```bash
BUDGET_EMAIL="<deine Mail>" ./infra/01-budget.sh
```

Danach im Portal prüfen: Kostenverwaltung → Budgets → `budget-hf-crm-5eur` → 3 Warnungen (50 % Ist, 100 % Ist, 100 % Prognose).

## 2 Azure SQL

```bash
./infra/02-rg-sql.sh
```

Das Skript fragt den Kontext ab, prüft die CLI-Flags und legt dann an:

| Ressource | Name | Wichtige Einstellungen |
|---|---|---|
| Ressourcengruppe | `rg-hf-crm` | Germany West Central |
| SQL-Server | `sql-hf-crm-106af6` | **nur Entra-Auth**, Hugo als Admin, TLS 1.2 |
| Datenbank | `hfcrm` | GP Serverless Gen5 2 vCore, `use-free-limit`, **AutoPause** bei Erschöpfung, Backup lokal |
| Firewall | `AllowAllWindowsAzureIps` | 0.0.0.0 = Azure-Dienste (Container App, Copilot Studio) |

Free Offer: 100.000 vCore-Sekunden, 32 GB Daten, 32 GB Backup pro Monat, dauerhaft, max. 10 DBs/Abo.
Quelle: https://learn.microsoft.com/azure/azure-sql/database/free-offer

**Hinweis Firewall:** 0.0.0.0 erlaubt Verbindungen aus *allen* Azure-Diensten, auch fremden Tenants. Akzeptabel, weil der Server nur Entra-Auth erlaubt (kein SQL-Login/Passwort).

## Eigene IP temporär (für Migrationen)

```bash
./infra/02b-firewall-myip.sh add
```

```bash
./infra/02b-firewall-myip.sh remove
```

## Nach Ausführung dokumentieren

- `docs/LOG.md`: Ausgabe-Tabellen (Namen, Resource-IDs)
- `docs/STATUS.md`: Phase 1/2 → ✅, Ressourcentabelle füllen
