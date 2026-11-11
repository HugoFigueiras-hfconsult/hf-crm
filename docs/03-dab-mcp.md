# Phase 4 – Data API builder / SQL MCP Server

Status: 🟡 Config-Grundgerüst + Skripte vorbereitet. **Entities fehlen bewusst**, weil das Schema offen ist (O3).

## Bausteine

| Datei | Zweck |
|---|---|
| `dab/dab-config.json` | REST unter `/api`, MCP unter `/mcp`, GraphQL aus, Auth `EntraId`. Alle umgebungsspezifischen Werte per `@env()` |
| `dab/Dockerfile` | Offizielles DAB-Image + Config |
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

## MCP-Tools (dml-tools)

describe-entities, create-record, read-records, update-record: **an**. delete-record, execute-entity: **aus**.
Begründung: Agent darf Datensätze schreiben, Löschen nur durch Hugo.

## Schritte

| # | Schritt | Status |
|---|---|---|
| 4.1 | `dotnet tool install -g Microsoft.DataApiBuilder` (lokal, ≥ 2.0) | ⬜ |
| 4.2 | Config-Grundgerüst | ✅ (manuell erstellt, mit `dab validate` gegenprüfen) |
| 4.3 | Entities hinzufügen (`dab add …`) | ⛔ wartet auf Schema (O3) |
| 4.4 | MCP aktivieren | ✅ in Config. VERIFIZIEREN: Schlüsselnamen `runtime.mcp.*` mit `dab configure --help` |
| 4.5 | Auth EntraId per `@env()` | ✅ in Config |
| 4.6 | Image bauen (GitHub Action) | ⬜ Workflow vorerst nur manuell; push-Trigger nach Entities aktivieren |
| 4.7 | Container App | 🟡 `infra/03-containerapp.sh` |
| 4.8 | DB-Zugriff Managed Identity | 🟡 `db/setup/01_user_dab.sql` |
| 4.9 | Connection String als Secret | 🟡 in 03-containerapp.sh |
| 4.10 | Custom Domain `mcp.hf-consult.de` | 🟡 `infra/03b-custom-domain.sh`, braucht DNS-Zugang (O2) |
| 4.11 | Test REST + MCP Inspector | ⬜ |

## GHCR-Zugriff für die Container App

Das Package `hf-crm-dab` ist privat. Hugo erstellt auf GitHub einen **Fine-grained/Classic PAT nur mit `read:packages`** und übergibt ihn beim Aufruf als `GHCR_PAT`. Er wird nur als Registry-Secret in der Container App gespeichert. Ablaufdatum ins LOG.

## Kosten

Container Apps Consumption, Free Grant pro Monat (laut MS, gegenprüfen): 180.000 vCPU-s, 360.000 GiB-s, 2 Mio. Requests. Bei 0,25 vCPU/0,5 GiB und scale-to-zero weit darunter. Kein ACR, kein Log Analytics.
Kaltstart nach Leerlauf: einige Sekunden.

## Quellen

- https://devblogs.microsoft.com/azure-sql/introducing-sql-mcp-server
- https://learn.microsoft.com/en-us/azure/data-api-builder/mcp/how-to-configure-authentication
