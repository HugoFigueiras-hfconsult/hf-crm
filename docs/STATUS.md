# Status

Stand: 2026-11-12 · Legende: ⬜ offen · 🟡 vorbereitet (Skript da, nicht ausgeführt) · ✅ erledigt · ⛔ blockiert

## Nächster Schritt

Azure läuft unter **`https://mcp.hf-consult.de/mcp`**: SQL-DB `hfcrm` (Free Offer), Container App `ca-hf-crm-dab` mit **Caddy (Türsteher) + DAB 2.1.5**, Entra-App `hf-crm-mcp`, DNS bei INWX, Zertifikat bis 13.05.2027. Der Server verlangt einen Login (401 + Discovery) und akzeptiert nur Tokens für `hf-crm-mcp`.

✅ **Claude-Connector `HF-CRM` ist verbunden (2026-11-12)** und liest echte Daten aus Azure SQL. Architektur-Überblick: `docs/ARCHITEKTUR.md`.

**Jetzt:** Schema definieren (O3, Phase 3) → Migration als Vorschlag → Hugo gibt frei → echte DAB-Entities statt Platzhalter `Verbindungstest` (dann Image neu bauen + `infra/03c-update-app.sh`).
Azure-Login aus Claude-Cloud-Sessions ist durch Security Defaults blockiert (AADSTS530035), Azure-Befehle daher lokal.

## Phasen

| Phase | Inhalt | Status | Doku | Skripte |
|---|---|---|---|---|
| 0 | Repo + Dokumentationsstruktur | ✅ | diese Datei | – |
| 1 | Azure-Basis: Abo prüfen, Variablen, Budget 5 € | ✅ Abo/Tenant/Provider · ⬜ Budget (verschoben) | `01-azure-basis.md` | `infra/00-vars.sh`, `infra/01-budget.sh`, `infra/01b-providers.sh` |
| 2 | Azure SQL Free Offer (Entra-only, AutoPause) | ✅ | `01-azure-basis.md` | `infra/02-rg-sql.sh` |
| 3 | DB-Schema | ⬜ **offen**: Entwurf aus Handover ungültig, wird mit Hugo neu definiert | `02-schema.md` | `db/migrations/` (leer) |
| 4 | DAB / SQL MCP Server auf Container Apps | ✅ läuft (DAB 2.1.5 + Caddy, Platzhalter-Entity), DB-User ok, Custom Domain ✅ · ⛔ Entities (O3) | `03-dab-mcp.md` | `dab/`, `infra/03-containerapp.sh`, `infra/03c-update-app.sh`, `db/setup/01_user_dab.sql` |
| 5 | Claude Custom Connector (Entra OAuth) | ✅ verbunden 2026-11-12 (Versuch 2), Lesen getestet | `04-claude-connector.md` | `infra/04-entra.sh` |
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
| Container-App-Umgebung | `cae-hf-crm` (Consumption, Logs: keine) | `…/rg-hf-crm/providers/Microsoft.App/managedEnvironments/cae-hf-crm` | ✅ Domain `purpleflower-b72b09c0.germanywestcentral.azurecontainerapps.io` |
| Container App | `ca-hf-crm-dab` (0,25 vCPU, 0,5 GiB, Replicas 0–1, Port 8000 = Caddy) | `…/rg-hf-crm/providers/Microsoft.App/containerapps/ca-hf-crm-dab` | ✅ Revision `ca-hf-crm-dab--0000002`, Image `:f05e633…` · Managed Identity `d7c46e40-6750-4ce8-ab5a-b993cdaebb94` · `DAB_JWT_AUDIENCE` = `c3f40bf1-…` |
| DB-User | `ca-hf-crm-dab` (EXTERNAL_USER) | – | ✅ `db_datareader` + `db_datawriter`, kein DDL |
| Entra-App | `hf-crm-mcp` (Single-Tenant, Token v2) | Client-ID `c3f40bf1-158a-4fff-8c08-de80976c7875` · Object-ID `0e3a33c5-0564-4aa7-a815-0d8994b25a4d` | ✅ App-ID-URI `https://mcp.hf-consult.de/mcp`, Scope `access_as_user`, Redirect claude.ai, nur Hugo zugewiesen · ⬜ Client Secret (Hugo) |
| Custom Domain | `mcp.hf-consult.de` (CNAME + TXT bei INWX) | Zertifikat `mc-cae-hf-crm-mcp-hf-consult-d-7121` | ✅ SNI, DigiCert bis 13.05.2027, Auto-Erneuerung |
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
| ~~O2~~ | ✅ 2026-11-12: DNS bei **INWX** (Konto auf Hugos privater E-Mail). CNAME + TXT für `mcp` angelegt. Empfehlung: 2FA bei INWX aktivieren | – |
| O3 | DB-Schema neu definieren (Handover-Entwurf ungültig). Blockiert Phase 3, DAB-Entities (4.3) und alles danach | Hugo + Agent |
| O4 | JDC-Anbindung (kein API/MCP; Browser-Weg nur mit Always-on-PC) | später |
| O5 | AVV-Lage: Max = Consumer Terms, kein AVV mit Anthropic. Team-Plan später | Hugo, bewusst entschieden |
| ~~O6~~ | ✅ 2026-11-11: **Nein**, DAB 2.1.5 antwortet auf `/.well-known/oauth-protected-resource` mit 400. Gelöst durch Caddy (R5) | – |
| ~~O7~~ | ✅ 2026-11-11: **Nein**, DAB 2.1.5 braucht mind. eine Entity. Gelöst mit Platzhalter `Verbindungstest` auf `INFORMATION_SCHEMA.TABLES` (nur lesen, keine Schemaänderung). Entfernen, sobald echte Entities da sind | – |
| O8 | Budget-Alarm einrichten (verschoben am 2026-11-11), dafür E-Mail-Adresse (nicht ins Repo). Spätestens vor Umstellung auf Pay-As-You-Go (O1), Worst Case Container App ≈ 13 €/Monat | Hugo |

## Risiken

| # | Risiko | Auswirkung | Prüfung / Gegenmaßnahme |
|---|---|---|---|
| ~~R1~~ | ✅ **Erledigt 2026-11-11**: Verzeichnis „HF Consulting“ ist der M365-Tenant `hf-consult.de` (Abo-Tenant = Tenant mit verifizierter Domain, `14cc25a5-…`). Siehe LOG | – | – |
| R2 | ✅ Verbindung steht seit 2026-11-12 (Code-Tausch + Token funktionieren). Restrisiko: Token-Erneuerung (#228), Neu-Verbinden nach Bearbeiten (#1000). Ursprünglich: Stand 11/2026 mehrere **offene** Bugs (anthropics/claude-ai-mcp #506, #632, #1080, #1248): Microsoft-Login klappt, claude.ai tauscht den Code nicht ein / schickt kein Token | Phase 5 scheitert trotz korrekter Konfiguration | Versuche nummeriert ins LOG. Nach 2 ernsthaften Versuchen: Entscheidung mit Hugo zwischen (a) eigenem kleinen OAuth-Server vor Entra („Token-Broker“, in #506 als funktionierend berichtet) und (b) Fallback Supabase |
| R3 | Log Analytics der Container-App-Umgebung verursacht Kosten | Budget | `--logs-destination none` in `infra/03-containerapp.sh` |
| ~~R4~~ | ✅ 2026-11-11: Package öffentlich, keine Pull-Credentials nötig (siehe `00-entscheidungen.md`) | – | – |
| ~~R5~~ | ✅ 2026-11-12: DAB fordert keinen Login an → **gelöst** mit Caddy als Türsteher (401 + `WWW-Authenticate`, Discovery-Dokumente). Getestet, siehe LOG | – | – |
