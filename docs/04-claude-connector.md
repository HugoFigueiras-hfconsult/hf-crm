# Phase 5 – Claude Custom Connector (Entra OAuth)

Status: 🟡 `infra/04-entra.sh` vorbereitet. Kritischster Teil des Projekts.

## Voraussetzungen

- R1 geklärt: `hf-consult.de` ist im selben Tenant wie das Azure-Abo verifiziert
- Phase 4.10: `mcp.hf-consult.de` an die Container App gebunden

## Schritte

| # | Schritt | Wie | Status |
|---|---|---|---|
| 5.1 | App-Registrierung `hf-crm-mcp`, Single-Tenant | `infra/04-entra.sh` | 🟡 |
| 5.2 | App-ID-URI = exakte MCP-URL `https://mcp.hf-consult.de/mcp` (sonst AADSTS9010010) | Skript | 🟡 |
| — | Scope `access_as_user`, `requestedAccessTokenVersion = 2` | Skript (Graph PATCH) | 🟡 |
| 5.3 | Redirect URI `https://claude.ai/api/mcp/auth_callback` (Web) | Skript | 🟡 |
| 5.4 | Client Secret | **Hugo selbst**, Befehl gibt das Skript am Ende aus. Wert direkt in Claude eingeben, nie ins Repo. Nur Ablaufdatum ins LOG | ⬜ |
| 5.5 | „Zuweisung erforderlich“ = Ja, nur Hugo zugewiesen | Skript | 🟡 |
| — | `DAB_JWT_AUDIENCE` = Client-ID setzen | Befehl gibt das Skript aus | ⬜ |
| 5.6 | Liefert DAB `/.well-known/oauth-protected-resource`? | `curl -i https://mcp.hf-consult.de/.well-known/oauth-protected-resource` | ⬜ (O6) |
| 5.7 | Claude → Einstellungen → Connectors → Benutzerdefiniert → URL `https://mcp.hf-consult.de/mcp` → Erweitert → „Use your own OAuth client“ → Client-ID + Secret | Hugo im Browser | ⬜ |
| 5.8 | Test im Chat: Entities beschreiben, Testdatensatz schreiben/lesen | Hugo | ⬜ |

## Token-Details (häufige Fehlerquelle)

- Mit `requestedAccessTokenVersion = 2` ist `iss` = `https://login.microsoftonline.com/<TENANT_ID>/v2.0` und `aud` = **Client-ID** (GUID), nicht die App-ID-URI.
- Erstes echtes Token unter https://jwt.ms dekodieren und `aud`, `iss`, `scp` (= `access_as_user`) ins LOG schreiben (Token selbst nicht!).

## Bekannte Probleme

Entra + claude.ai Custom Connectors: https://github.com/anthropics/claude-ai-mcp/issues/506 und https://github.com/anthropics/claude-ai-mcp/issues/122. **Vor Start lesen.**
Falls 5.6 fehlt: Option API Management als OAuth-Gateway (MS-Referenz „Claude-Ready Entra ID-Protected MCP Servers with Azure API Management“). **Kosten prüfen**, APIM sprengt ggf. das 5-€-Limit.

**Abbruchkriterium:** Nach 2 ernsthaften Versuchen nicht lauffähig → Fallback Supabase (offizieller Claude-Connector). Versuche im LOG nummerieren.

## Quellen

- https://claude.com/docs/connectors/building/authentication
- https://claude.com/docs/connectors/custom/remote-mcp
