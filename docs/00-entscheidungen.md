# Entscheidungen

Nicht ohne neuen Grund neu diskutieren. Neue Entscheidungen unten anhängen (Datum + Begründung).

| Thema | Entscheidung | Begründung / verworfene Alternativen |
|---|---|---|
| DB | **Azure SQL Database, Free Offer** | Daten im eigenen Tenant, MS-AVV, EU. Supabase verworfen (Hugo will MS-Seite; 500-MB-Limit-Sorge). Supabase bleibt **Fallback** (offizieller Claude-Connector, 5 Min Setup) |
| API/MCP | **Data API builder (DAB) ≥ 2.0 mit SQL MCP Server** | Liefert REST + MCP aus einer `dab-config.json`. GA seit 06/2026. Kein offizieller Azure-SQL-Connector in Claude vorhanden |
| Hosting DAB | Azure Container Apps (Consumption, min. Replicas 0) | Free Grant. ACR vermeiden (Basic ≈ 5 $/Monat) → Image in **GitHub Container Registry** |
| Auth DAB | Entra ID (JWT, Provider `EntraID`) | Claude Custom Connector mit eigenem OAuth-Client |
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
| 2026-11-11 | GHCR-Package `hf-crm-dab` | **Öffentlich**, Container App zieht ohne Credentials | Image enthält nur die DAB-Config (keine Secrets, keine Daten; sichtbar sind nur Server-/Hostnamen). Verworfen: privates Package + PAT mit `read:packages` (läuft ab → Kaltstart scheitert, ein Secret mehr). Entscheidung Hugo |
| 2026-11-11 | DAB-Platzhalter-Entity | `Verbindungstest` auf System-View `INFORMATION_SCHEMA.TABLES` (nur lesen, Rolle `authenticated`) | DAB 2.1.5 startet nicht ohne Entity; so ist der Connector-Test vor dem Schema möglich, **ohne** Test-Tabelle/Schemaänderung. Wird mit den echten Entities entfernt |
| 2026-11-12 | Login-Signal für claude.ai | **Caddy als Türsteher im DAB-Image** (Port 8000): 401 + `WWW-Authenticate`, PRM + AS-Metadaten auf `mcp.hf-consult.de`, Login bei Entra | DAB 2.1.5 fordert keinen Login an (R5). Eigene AS-Metadaten auf dem MCP-Host, weil claude.ai Entras Pfad-Issuer nicht findet (#82/#214). Verworfen: Easy Auth (kein `resource_metadata`), APIM (Kosten), eigener OAuth-Server (Aufwand; bleibt Option, falls Entra-Bug #506/#632 uns trifft) |
