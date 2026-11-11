# HF-CRM

Eigenes CRM für HF-Consult (Finanzberatung, Einzelunternehmen, M365-Tenant `hf-consult.de`).
Eine Datenbank (Azure SQL, Free Offer), bereitgestellt über **Data API builder (DAB) / SQL MCP Server** als REST + MCP.

> **Agenten:** zuerst `CLAUDE.md` lesen, dann `docs/STATUS.md`.

## Konsumenten

| Konsument | Zugriff | Zweck |
|---|---|---|
| Claude-Routine (Cloud, Max-Abo) | Custom Connector → SQL MCP Server | Termin-Vor-/Nachbereitung, Ablauferinnerungen, Quartalstermine |
| Claude-Artefakt (Dashboard) | `mcp`-Capability über denselben Connector | Mandanten durchtabben, live laden |
| Copilot-Agent (Copilot Studio) | Azure SQL als Wissensquelle (nur lesen) | Interaktive Abfragen in Teams/Chat |
| Später: Telegram-Bot | Cloudflare Worker → Routine-`/fire` | Proaktive Kommunikation Hugo + Ehefrau |

## Architektur

```
Claude-Routine ──┐
                 ├─► SQL MCP Server / DAB (Container App, mcp.hf-consult.de) ─► Azure SQL (Free, Germany West Central)
Claude-Artefakt ─┘          ▲ Entra-JWT                                            ▲
                                                                                    │ Service Principal (db_datareader)
Copilot-Agent (Copilot Studio) ─────────────────────────────────────────────────────┘

Telegram ─► Cloudflare Worker (Allowlist Hugo+Frau) ─► POST /fire ─► Claude-Routine   (Phase 7)
```

## Repo-Struktur

```
hf-crm/
├─ CLAUDE.md                 # Regeln für Agenten (zuerst lesen)
├─ README.md
├─ docs/
│  ├─ STATUS.md              # Ist-Stand, nächster Schritt, offene Punkte
│  ├─ LOG.md                 # chronologisches Setup-Log
│  ├─ LOKALE-SESSION.md      # Setup + Start-Prompt für lokale Session (Windows)
│  ├─ 00-entscheidungen.md
│  ├─ 01-azure-basis.md      # Phase 1+2: Abo, Budget, SQL
│  ├─ 02-schema.md           # Phase 3 (Schema offen)
│  ├─ 03-dab-mcp.md          # Phase 4
│  ├─ 04-claude-connector.md # Phase 5
│  ├─ 05-copilot.md          # Phase 6
│  ├─ 06-trigger-telegram.md # Phase 7
│  ├─ 07-dashboard.md        # Phase 8
│  └─ HANDOVER-2026-11-11.md # ursprüngliches Übergabedokument
├─ infra/                    # alle Azure-Aktionen als Skript
├─ db/
│  ├─ apply.sh               # SQL-Datei als Entra-Admin ausführen
│  ├─ migrations/            # Schema, nummeriert (leer, Schema offen)
│  └─ setup/                 # DB-User/Rechte (kein Schema)
├─ dab/                      # dab-config.json + Dockerfile
├─ dashboard/                # HTML des Claude-Artefakts (Phase 8)
└─ .github/workflows/        # Image-Build nach ghcr.io
```

## Lokal weiterarbeiten (PC/Laptop)

```bash
git clone https://github.com/HugoFigueiras-hfconsult/hf-crm.git
```

```bash
cd hf-crm && git pull
```

Voraussetzungen und Start-Prompt für eine lokale Claude-Code-Session: `docs/LOKALE-SESSION.md`.
