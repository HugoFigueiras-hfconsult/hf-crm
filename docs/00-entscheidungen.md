# Entscheidungen

Nicht ohne neuen Grund neu diskutieren. Neue Entscheidungen unten anhängen (Datum + Begründung).

| Thema | Entscheidung | Begründung / verworfene Alternativen |
|---|---|---|
| DB | **Azure SQL Database, Free Offer** | Daten im eigenen Tenant, MS-AVV, EU. Supabase verworfen (Hugo will MS-Seite; 500-MB-Limit-Sorge). Supabase bleibt **Fallback** (offizieller Claude-Connector, 5 Min Setup) |
| API/MCP | **Data API builder (DAB) ≥ 2.0 mit SQL MCP Server** | Liefert REST + MCP aus einer `dab-config.json`. GA seit 06/2026. Kein offizieller Azure-SQL-Connector in Claude vorhanden |
| Hosting DAB | Azure Container Apps (Consumption, min. Replicas 0) | Free Grant. ACR vermeiden (Basic ≈ 5 $/Monat) → Image in **GitHub Container Registry** |
| Auth DAB | Entra ID (JWT, Provider `EntraId`) | Claude Custom Connector mit eigenem OAuth-Client |
| Frontend | Claude-Artefakt statt Power Apps / Static Web App | Power Apps + SQL-Connector = Premium (~20 $/Nutzer). SWA nur falls später nötig |
| Power Apps / Lists / Dataverse for Teams | Verworfen | Lists keine echte DB; Dataverse for Teams: keine neuen Umgebungen ab 15.11.2026 |
| Blaze SQL / Composio | Verworfen | 150–800 $/Monat bzw. zusätzlicher Dienstleister für Mandantendaten |
| Claude-Plan | Max (privat, Consumer Terms) bleibt vorerst | Team-Plan (AVV) bewusst später (spätestens volle Selbstständigkeit Ende 2027). Hugo trägt Risiko bewusst |
| Copilot | M365 Copilot Business vorhanden | Claude-Modelle in Copilot (Anthropic-Subprozessor) aktiviert, Rollout ab 07.01.2027. Credits/Cowork **nicht** nutzen (teuer) |

## Nachträge

| Datum | Thema | Entscheidung | Begründung |
|---|---|---|---|
| 2026-11-11 | Repo | GitHub `HugoFigueiras-hfconsult/hf-crm` (privat), Arbeit wird nach jedem Schritt gepusht | Hugo arbeitet abwechselnd in Claude-Cloud-Sessions und auf dem Laptop |
| 2026-11-11 | Container-App-Logs | `--logs-destination none` | Log Analytics kann Kosten verursachen; Ziel 0 € |
| 2026-11-11 | DB-Schema | Schema-Entwurf aus dem Handover ist **ungültig**. Schema wird neu mit Hugo definiert | Vorgabe Hugo |
| 2026-11-11 | DAB-Config | Umgebungsspezifisches (Connection String, JWT Audience/Issuer) per `@env()` | Config enthält keine Secrets und keine Tenant-Werte, Image ist umgebungsneutral |
