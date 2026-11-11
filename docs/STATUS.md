# Status

Stand: 2026-11-11 · Legende: ⬜ offen · 🟡 vorbereitet (Skript da, nicht ausgeführt) · ✅ erledigt · ⛔ blockiert

## Nächster Schritt

Lokale Session auf Hugos Windows-PC läuft: `az login` ok, Tenant geprüft (R1 erledigt), SQL-Server + DB `hfcrm` im Free Offer angelegt (Phase 2 ✅). Budget-Alarm auf Hugos Wunsch verschoben.
**Jetzt:** Phase 4 vorbereiten, `docs/LOKALE-SESSION.md` Abschnitt 4: DAB ohne Entities testen (O7), dann Image bauen und Container App.
Ziel: Azure SQL aufsetzen + MCP-Connector für Claude. Schema folgt am 2026-11-12.
Azure-Login aus Claude-Cloud-Sessions ist durch Security Defaults blockiert (AADSTS530035), daher lokal.

## Phasen

| Phase | Inhalt | Status | Doku | Skripte |
|---|---|---|---|---|
| 0 | Repo + Dokumentationsstruktur | ✅ | diese Datei | – |
| 1 | Azure-Basis: Abo prüfen, Variablen, Budget 5 € | ✅ Abo/Tenant/Provider · ⬜ Budget (verschoben) | `01-azure-basis.md` | `infra/00-vars.sh`, `infra/01-budget.sh`, `infra/01b-providers.sh` |
| 2 | Azure SQL Free Offer (Entra-only, AutoPause) | ✅ | `01-azure-basis.md` | `infra/02-rg-sql.sh` |
| 3 | DB-Schema | ⬜ **offen**: Entwurf aus Handover ungültig, wird mit Hugo neu definiert | `02-schema.md` | `db/migrations/` (leer) |
| 4 | DAB / SQL MCP Server auf Container Apps | 🟡 | `03-dab-mcp.md` | `dab/`, `infra/03-containerapp.sh` |
| 5 | Claude Custom Connector (Entra OAuth) | 🟡 | `04-claude-connector.md` | `infra/04-entra.sh` |
| 6 | Copilot Studio (nur lesen) | ⬜ | `05-copilot.md` | – |
| 7 | Routine + Telegram-Trigger | ⬜ | `06-trigger-telegram.md` | – |
| 8 | Dashboard-Artefakt | ⬜ | `07-dashboard.md` | `dashboard/` |

## Azure-Ressourcen (Ist)

| Ressource | Name | ID | Status |
|---|---|---|---|
| Abo | Azure subscription 1 (`FreeTrial_2014-09-01`, Ausgabenlimit an) | `b349b1a4-88aa-4b1f-82bf-8b24bbe47daa` | aktiv · Tenant `14cc25a5-e8d0-4504-90dc-cb97d813d29c` (HF Consulting = `hf-consult.de`) |
| Ressourcengruppe | `rg-hf-crm` (germanywestcentral) | `/subscriptions/b349b1a4-88aa-4b1f-82bf-8b24bbe47daa/resourceGroups/rg-hf-crm` | ✅ |
| SQL-Server | `sql-hf-crm-106af6.database.windows.net` | `…/rg-hf-crm/providers/Microsoft.Sql/servers/sql-hf-crm-106af6` | ✅ nur Entra-Auth, Admin Hugo, TLS 1.2, Firewall: Azure-Dienste |
| SQL-DB | `hfcrm` (GP_S_Gen5, Serverless, Free Offer, AutoPause) | `…/servers/sql-hf-crm-106af6/databases/hfcrm` | ✅ 0 €, leer (kein Schema) |
| Budget | `budget-hf-crm-5eur` | – | ⬜ verschoben (Hugo), Ausgabenlimit der Testversion greift |

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
| O3 | DB-Schema neu definieren (Handover-Entwurf ungültig). Blockiert Phase 3, DAB-Entities (4.3) und alles danach | Hugo + Agent |
| O4 | JDC-Anbindung (kein API/MCP; Browser-Weg nur mit Always-on-PC) | später |
| O5 | AVV-Lage: Max = Consumer Terms, kein AVV mit Anthropic. Team-Plan später | Hugo, bewusst entschieden |
| O6 | Liefert DAB `/.well-known/oauth-protected-resource`? (Phase 5.6) | Agent, recherchieren |
| O7 | Startet DAB 2.x ohne Entities? Sonst braucht der Connector-Test vor dem Schema eine Test-Tabelle (nur mit Hugos Freigabe) | Agent, lokal prüfen |
| O8 | Budget-Alarm einrichten (verschoben am 2026-11-11), dafür E-Mail-Adresse (nicht ins Repo). Spätestens vor Umstellung auf Pay-As-You-Go (O1) | Hugo |

## Risiken

| # | Risiko | Auswirkung | Prüfung / Gegenmaßnahme |
|---|---|---|---|
| ~~R1~~ | ✅ **Erledigt 2026-11-11**: Verzeichnis „HF Consulting“ ist der M365-Tenant `hf-consult.de` (Abo-Tenant = Tenant mit verifizierter Domain, `14cc25a5-…`). Siehe LOG | – | – |
| R2 | Entra + claude.ai Custom Connector (Issues anthropics/claude-ai-mcp #506, #122) | Phase 5 scheitert | Nach 2 ernsthaften Versuchen → Fallback Supabase |
| R3 | Log Analytics der Container-App-Umgebung verursacht Kosten | Budget | `--logs-destination none` in `infra/03-containerapp.sh` |
| R4 | Image in privater GHCR → Container App braucht Pull-Credentials | Deployment | PAT (nur `read:packages`) als Registry-Secret der Container App, siehe `03-dab-mcp.md` |
