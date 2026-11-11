# Status

Stand: 2026-11-11 · Legende: ⬜ offen · 🟡 vorbereitet (Skript da, nicht ausgeführt) · ✅ erledigt · ⛔ blockiert

## Nächster Schritt

**Hugo, auf dem Laptop:** `az login` (MFA), dann `az account show -o table` und Tenant prüfen (siehe Risiko R1 unten).
Ergebnis (Abo-ID, Tenant-ID, Tenant-Name) in `docs/LOG.md` eintragen, danach `infra/01-budget.sh` und `infra/02-rg-sql.sh`.

## Phasen

| Phase | Inhalt | Status | Doku | Skripte |
|---|---|---|---|---|
| 0 | Repo + Dokumentationsstruktur | ✅ | diese Datei | – |
| 1 | Azure-Basis: Abo prüfen, Variablen, Budget 5 € | 🟡 | `01-azure-basis.md` | `infra/00-vars.sh`, `infra/01-budget.sh` |
| 2 | Azure SQL Free Offer (Entra-only, AutoPause) | 🟡 | `01-azure-basis.md` | `infra/02-rg-sql.sh` |
| 3 | Schema `001_init.sql` | 🟡 Entwurf, mit Hugo abstimmen | `02-schema.md` | `db/migrations/001_init.sql` |
| 4 | DAB / SQL MCP Server auf Container Apps | 🟡 | `03-dab-mcp.md` | `dab/`, `infra/03-containerapp.sh` |
| 5 | Claude Custom Connector (Entra OAuth) | 🟡 | `04-claude-connector.md` | `infra/04-entra.sh` |
| 6 | Copilot Studio (nur lesen) | ⬜ | `05-copilot.md` | – |
| 7 | Routine + Telegram-Trigger | ⬜ | `06-trigger-telegram.md` | – |
| 8 | Dashboard-Artefakt | ⬜ | `07-dashboard.md` | `dashboard/` |

## Azure-Ressourcen (Ist)

| Ressource | Name | ID | Status |
|---|---|---|---|
| Abo | Kostenlose Testversion | _noch nicht notiert_ | angelegt von Hugo |
| Alle weiteren | – | – | **noch keine angelegt** |

## Fristen

| Datum | Was | Wer |
|---|---|---|
| **11.12.2026** | Testversion → Pay-As-You-Go umstellen, sonst werden Ressourcen deaktiviert | Hugo |
| 15.11.2026 | Dataverse for Teams: keine neuen Umgebungen mehr (nur informativ, verworfen) | – |
| 07.01.2027 | Claude-Modelle in Copilot für Tenant verfügbar | – |

## Offene Punkte

| # | Punkt | Wer |
|---|---|---|
| O1 | Testversion → Pay-As-You-Go bis 11.12.2026 | Hugo |
| O2 | DNS-Anbieter für `hf-consult.de` (für Custom Domain, Phase 4.10) | Hugo |
| O3 | Schema-Entwurf bestätigen/ergänzen (`docs/02-schema.md`) | Hugo |
| O4 | JDC-Anbindung (kein API/MCP; Browser-Weg nur mit Always-on-PC) | später |
| O5 | AVV-Lage: Max = Consumer Terms, kein AVV mit Anthropic. Team-Plan später | Hugo, bewusst entschieden |
| O6 | Liefert DAB `/.well-known/oauth-protected-resource`? (Phase 5.6) | Agent, recherchieren |

## Risiken

| # | Risiko | Auswirkung | Prüfung / Gegenmaßnahme |
|---|---|---|---|
| **R1** | Die Testversion wurde im Verzeichnis **„HF Consulting“** angelegt. Ist das ein **anderer Entra-Tenant** als der M365-Tenant `hf-consult.de`? | Domain `hf-consult.de` dort nicht verifiziert → App-ID-URI `https://mcp.hf-consult.de/mcp` unmöglich (Phase 5.2). Copilot Studio + Hugos M365-Identität in fremdem Tenant | `az account show --query tenantId` vergleichen mit M365 Admin Center → Einstellungen → Organisationsprofil (Mandanten-ID). Falls verschieden: Abo per „Verzeichnis ändern“ in den M365-Tenant verschieben, **bevor** Ressourcen angelegt werden |
| R2 | Entra + claude.ai Custom Connector (Issues anthropics/claude-ai-mcp #506, #122) | Phase 5 scheitert | Nach 2 ernsthaften Versuchen → Fallback Supabase |
| R3 | Log Analytics der Container-App-Umgebung verursacht Kosten | Budget | `--logs-destination none` in `infra/03-containerapp.sh` |
| R4 | Image in privater GHCR → Container App braucht Pull-Credentials | Deployment | PAT (nur `read:packages`) als Registry-Secret der Container App, siehe `03-dab-mcp.md` |
