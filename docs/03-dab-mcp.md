# Phase 4 – Data API builder / SQL MCP Server

Status: 🟡 Config lokal mit DAB 2.1.5 gegen die echte DB getestet (2026-11-11). Einzige Entity: Platzhalter `Verbindungstest` (System-View `INFORMATION_SCHEMA.TABLES`, nur lesen), weil DAB ohne Entity nicht startet und das Schema offen ist (O3).

## Bausteine

| Datei | Zweck |
|---|---|
| `dab/dab-config.json` | REST unter `/api`, MCP unter `/mcp`, GraphQL aus, Auth `EntraId`. Alle umgebungsspezifischen Werte per `@env()` |
| `dab/Dockerfile` | Offizielles DAB-Image + Caddy (Türsteher, Port 8000) + Config |
| `dab/Caddyfile`, `dab/start.sh` | Türsteher: 401 + OAuth-Discovery für claude.ai, startet DAB (intern :5000) + Caddy (siehe `04-claude-connector.md`) |
| `infra/03c-update-app.sh` | Bestehende App auf neues Image (`:<commit-sha>`) + aktuelle Env-Variablen |
| `.github/workflows/dab-image.yml` | Build + Push nach `ghcr.io/hugofigueiras-hfconsult/hf-crm-dab` (vorerst nur manuell) |
| `infra/03-containerapp.sh` | Container-App-Umgebung + App (scale-to-zero, Managed Identity) |
| `infra/03b-custom-domain.sh` | `mcp.hf-consult.de` + Managed Cert |
| `db/setup/01_user_dab.sql` | Managed Identity als DB-User (lesen/schreiben, kein DDL) |

## Umgebungsvariablen der Container App

| Variable | Inhalt | Quelle |
|---|---|---|
| `DAB_CONNSTRING` | `Server=tcp:sql-hf-crm-106af6.database.windows.net,1433;Database=hfcrm;Authentication=Active Directory Managed Identity;Encrypt=True;` | Container-App-**Secret** `dab-connstring` (enthält kein Passwort, trotzdem als Secret) |
| `DAB_JWT_ISSUER` | `https://login.microsoftonline.com/<TENANT_ID>/v2.0` | 03-containerapp.sh |
| `DAB_JWT_AUDIENCE` | **Client-ID** der App `hf-crm-mcp` (v2-Tokens: `aud` = Client-ID) | nach Phase 5 setzen |
| `DAB_CA_FQDN` | Standard-Hostname der Container App (`ca-hf-crm-dab.<defaultDomain>`), für `runtime.mcp.allowed-hosts` | 03-containerapp.sh |

## MCP-Tools (dml-tools)

describe-entities, create-record, read-records, update-record: **an**. delete-record, execute-entity: **aus**.
Begründung: Agent darf Datensätze schreiben, Löschen nur durch Hugo.

## Schritte

| # | Schritt | Status |
|---|---|---|
| 4.1 | `dotnet tool install -g Microsoft.DataApiBuilder --version 2.1.5` (braucht .NET 10 SDK) | ✅ 2026-11-11 |
| 4.2 | Config-Grundgerüst | ✅ `dab validate` gegen echte DB ok (mit Platzhalter-Entity) |
| 4.3 | Entities hinzufügen (`dab add …`), danach Platzhalter `Verbindungstest` entfernen | ⛔ wartet auf Schema (O3) |
| 4.4 | MCP aktivieren | ✅ Schlüssel gegen Schema 2.1.5 geprüft; `allowed-hosts` ergänzt (Pflicht für Nicht-localhost-Hosts, sonst 403) |
| 4.5 | Auth `EntraID` per `@env()` | ✅ (Schreibweise `EntraID`, nicht `EntraId`) |
| 4.6 | Image bauen (GitHub Action) | ✅ 2026-11-11, Run 43113418463 (DAB 2.1.5). Workflow weiter nur manuell; push-Trigger nach Entities aktivieren |
| 4.7 | Container App | ✅ 2026-11-11 `ca-hf-crm-dab` (FQDN siehe STATUS) |
| 4.8 | DB-Zugriff Managed Identity | ✅ 2026-11-11 `db/setup/01_user_dab.sql` (reader + writer) |
| 4.9 | Connection String als Secret | ✅ Secret `dab-connstring` |
| 4.10 | Custom Domain `mcp.hf-consult.de` | 🟡 `infra/03b-custom-domain.sh`, braucht DNS-Zugang (O2) |
| 4.11 | Test REST + MCP | 🟡 ohne Token ok (MCP initialize 200, tools/list, anonym keine Daten, REST 403). Mit Token: nach Phase 5 |

## GHCR-Zugriff für die Container App

Das Package `hf-crm-dab` ist **öffentlich** (Entscheidung Hugo 2026-11-11, `00-entscheidungen.md`). Die Container App zieht das Image ohne Credentials. `infra/03-containerapp.sh` prüft vorab, ob das Image anonym abrufbar ist (HTTP 200), sonst Abbruch.

Sichtbarkeit ändern (einmalig, nur im GitHub-Portal möglich, keine API): GitHub → Profil → **Packages** → `hf-crm-dab` → **Package settings** → Danger Zone → **Change visibility** → Public → Paketnamen bestätigen.

## Kosten

Container Apps Consumption, Free Grant pro Abo und Monat: 180.000 vCPU-s, 360.000 GiB-s, 2 Mio. Requests. Kein ACR, kein Log Analytics.

Rechnung für `ca-hf-crm-dab` (0,25 vCPU / 0,5 GiB), Stand 2026-11-11:

| Fall | Aktive Zeit/Monat | Kosten |
|---|---|---|
| Kostenlos bis | **≈ 200 h** (180.000 / 0,25 s = 200 h; 360.000 / 0,5 s = 200 h) | 0 € |
| Realistisch: ~20 Nutzungen/Tag, je ~10 min wach (inkl. 5 min Nachlauf vor scale-to-zero) | ≈ 100 h | 0 € |
| Darüber | je weitere Stunde ≈ 0,025 € (Listenpreis ca. 0,000024 $/vCPU-s + 0,000003 $/GiB-s; die Retail-Price-API rundet auf 4 Stellen, daher nicht exakt prüfbar) | gering |
| Worst Case: rund um die Uhr wach (z. B. Dauer-Abfragen, Scanner) | 730 h | ≈ 13 €/Monat (Obergrenze durch max. 1 Replica) |

Bis 11.12.2026 (Testversion mit Ausgabenlimit) wird nichts berechnet. **Vor der Umstellung auf Pay-As-You-Go Budget-Alarm einrichten (O8)**, weil der Worst Case über der 5-€-Grenze liegt. Die SQL-DB kann nie kosten (Free Offer + AutoPause).
Kaltstart nach Leerlauf: einige Sekunden.

## Quellen

- https://devblogs.microsoft.com/azure-sql/introducing-sql-mcp-server
- https://learn.microsoft.com/en-us/azure/data-api-builder/mcp/how-to-configure-authentication
