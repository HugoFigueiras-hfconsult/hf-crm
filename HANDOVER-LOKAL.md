# Handover → lokale Claude-Code-Session (Hugos Windows-PC)

Stand: 2026-11-11 · Repo: `HugoFigueiras-hfconsult/hf-crm` (Branch `main`)

## Auftrag

Azure SQL Database (Free Offer) aufsetzen und den HF-CRM MCP Server (Data API builder) so bereitstellen, dass sich Claude per **Custom Connector** verbinden kann. **Das DB-Schema wird erst morgen definiert**, daher heute keine Tabellen anlegen (Ausnahme nur mit Hugos Freigabe, s. u.).

## Warum lokal

Aus der Claude-Cloud-Session ist `az login` blockiert (AADSTS530035, Security Defaults des Tenants `hf-consult.de`). Auf Hugos PC funktioniert die normale Browser-Anmeldung.

## Was schon da ist

- `CLAUDE.md`: Regeln (Kosten max. 5 €/Monat, keine Secrets im Repo, Login/Secrets gibt Hugo selbst ein, Schemaänderungen nur mit Freigabe, jede Aktion in `docs/LOG.md` + `docs/STATUS.md`, nach jedem Schritt pushen)
- `infra/*.sh`: fertige Skripte (Git-Bash-tauglich), **noch nie ausgeführt**
- `dab/`: DAB-Config ohne Entities + Dockerfile, `.github/workflows/dab-image.yml` (manuell starten)
- `docs/`: Doku je Phase, LOG, STATUS
- Schema-Entwurf im alten Handover (`docs/HANDOVER-2026-11-11.md`) ist **ungültig**
- Azure-Ressourcen: **keine**

## Schritte (Skripte in Git Bash ausführen)

1. `az login` → Hugo meldet sich im Browser an.
2. **Tenant prüfen:** `az account list -o table`. Das Abo muss im Tenant liegen, in dem `hf-consult.de` verifiziert ist. Sonst **stoppen** und Hugo fragen.
3. `SUBSCRIPTION_ID` + `TENANT_ID` in `infra/00-vars.sh` eintragen.
4. Budget: Hugo nach Alarm-E-Mail fragen → `BUDGET_EMAIL=… ./infra/01-budget.sh`
5. SQL: `CONFIRMED=j ./infra/02-rg-sql.sh` (RG `rg-hf-crm`, Server `sql-hf-crm-106af6`, DB `hfcrm`, Free Offer + AutoPause, nur Entra-Auth)
6. Prüfen, ob DAB 2.x ohne Entities startet (`dab validate`). Falls nicht: Hugo fragen, ob eine Test-Tabelle angelegt werden darf.
7. Image bauen (GitHub Actions, manuell) → Package öffentlich (Hugo) → `./infra/03-containerapp.sh`
8. `db/setup/01_user_dab.sql` ausführen (Managed Identity der Container App als DB-User)
9. Custom Domain `mcp.hf-consult.de`: `./infra/03b-custom-domain.sh records` → Hugo setzt DNS → `… bind`
10. Entra-App: `./infra/04-entra.sh`, danach `DAB_JWT_AUDIENCE` = Client-ID setzen
11. Hugo erzeugt das Client Secret selbst und legt den Connector in claude.ai an (URL `https://mcp.hf-consult.de/mcp`, „Use your own OAuth client“). Test im Chat.

Details je Schritt: `docs/01-azure-basis.md`, `docs/03-dab-mcp.md`, `docs/04-claude-connector.md`.
Bei Problemen mit Entra + Claude-Connector: nach 2 Versuchen mit Hugo über Fallback (Supabase) sprechen.
