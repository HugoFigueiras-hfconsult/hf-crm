# Phase 5 – Claude Custom Connector (Entra OAuth)

Status: 🟡 Türsteher ✅, Entra-App `hf-crm-mcp` ✅, DAB-Audience ✅, Custom Domain ✅ · offen: Client Secret, Connector, Test (Hugo). Kritischster Teil des Projekts (R2).

## So läuft der Login (Soll)

1. claude.ai ruft `https://mcp.hf-consult.de/mcp` ohne Token auf → **Caddy** antwortet 401 + `WWW-Authenticate: Bearer resource_metadata=…`.
2. claude.ai liest `/.well-known/oauth-protected-resource` (→ Login über `https://mcp.hf-consult.de`) und `/.well-known/oauth-authorization-server` (→ Entras authorize/token, PKCE S256). Beides liefert Caddy, Werte aus Env-Variablen (`dab/start.sh`).
3. Kein DCR → claude.ai verlangt „Use your own OAuth client“: Client-ID + Secret der App `hf-crm-mcp`.
4. Browser → Microsoft-Login (Hugo + MFA, nur Hugo ist zugewiesen) → zurück an `https://claude.ai/api/mcp/auth_callback`.
5. claude.ai tauscht den Code bei Entra gegen ein Token (`aud` = Client-ID, `scp` = `access_as_user`) und schickt es mit jeder MCP-Anfrage.
6. Caddy lässt Anfragen mit Token durch, **DAB prüft das Token** (Issuer, Audience, Signatur) → Rolle `authenticated` → sieht die Entities.

## Schritte

| # | Schritt | Wie | Status |
|---|---|---|---|
| 5.0 | Türsteher: 401 + Discovery vor DAB (R5) | `dab/Caddyfile`, `dab/start.sh`, Port 8000 | ✅ 2026-11-12 |
| 5.1 | App-Registrierung `hf-crm-mcp`, Single-Tenant | `infra/04-entra.sh` | ✅ Client-ID `c3f40bf1-158a-4fff-8c08-de80976c7875` |
| 5.2 | App-ID-URI = exakte MCP-URL `https://mcp.hf-consult.de/mcp` (sonst AADSTS9010010) | Skript | ✅ |
| — | Scope `access_as_user`, `requestedAccessTokenVersion = 2` | Skript (Graph PATCH) | ✅ |
| 5.3 | Redirect URI `https://claude.ai/api/mcp/auth_callback` (Web) | Skript | ✅ |
| 5.5 | „Zuweisung erforderlich“ = Ja, nur Hugo zugewiesen | Skript | ✅ |
| — | `DAB_JWT_AUDIENCE` = Client-ID | `infra/03c-update-app.sh` | ✅ Revision `--0000002` |
| 5.6 | Discovery erreichbar | `curl -i https://mcp.hf-consult.de/.well-known/oauth-protected-resource` | ✅ 2026-11-12 (App-FQDN + Custom Domain) |
| 4.10 | Custom Domain `mcp.hf-consult.de` | DNS bei INWX, `./infra/03b-custom-domain.sh bind` | ✅ 2026-11-12 |
| 5.4 | Client Secret | **Hugo selbst** (siehe unten). Wert direkt in Claude eingeben, nie in Chat/Repo. Nur Ablaufdatum ins LOG | ⬜ |
| 5.7 | Connector in claude.ai anlegen | Hugo im Browser (siehe unten) | ⬜ |
| 5.8 | Test im Chat: „Welche Entities gibt es?“ → `Verbindungstest` lesen | Hugo | ⬜ |

## DNS bei INWX (Hugo)

INWX → Domains → `hf-consult.de` → DNS (Nameserver-Einträge) → Eintrag hinzufügen:

| Typ | Name | Wert | TTL |
|---|---|---|---|
| CNAME | `mcp` | `ca-hf-crm-dab.purpleflower-b72b09c0.germanywestcentral.azurecontainerapps.io` | 3600 |
| TXT | `asuid.mcp` | `A615C0D9CBDA4E9EA542291C80000F32D37C428C08602AC000839AD9010ED01D` | 3600 |

Hinweis: Es gibt einen Wildcard-Eintrag `*.hf-consult.de` → `185.181.104.242`. Der eigene CNAME für `mcp` hat Vorrang, der Wildcard bleibt unberührt.
Prüfen: `nslookup -type=CNAME mcp.hf-consult.de` und `nslookup -type=TXT asuid.mcp.hf-consult.de`. Danach Agent: `./infra/03b-custom-domain.sh bind`.

## Client Secret (Hugo, 5.4)

Entweder im Portal: https://entra.microsoft.com → App-Registrierungen → `hf-crm-mcp` → Zertifikate & Geheimnisse → Neuer geheimer Clientschlüssel → Beschreibung `claude-connector`, Ablauf 12 Monate → **Wert** sofort kopieren (wird nur einmal angezeigt).

Oder im eigenen Terminal (nicht im Claude-Chat):

```bash
az ad app credential reset --id c3f40bf1-158a-4fff-8c08-de80976c7875 --append --display-name claude-connector --years 1 --query password -o tsv
```

Ablaufdatum fürs LOG: `az ad app credential list --id c3f40bf1-158a-4fff-8c08-de80976c7875 --query "[].{name:displayName, ende:endDateTime}" -o table`

## Connector anlegen (Hugo, 5.7)

claude.ai → Einstellungen → Connectors → **Benutzerdefinierten Connector hinzufügen**:

- Name: `HF-CRM`
- URL: `https://mcp.hf-consult.de/mcp`
- Erweiterte Einstellungen → OAuth Client ID: `c3f40bf1-158a-4fff-8c08-de80976c7875`, OAuth Client Secret: der Wert aus 5.4
- Verbinden → Microsoft-Login mit `hugo.figueiras@hf-consult.de` → ggf. Zustimmung („Consent“) bestätigen

Bei Fehler: Meldung + `ofid_…`-Referenz + Uhrzeit ins LOG (Versuch 1, 2 …).

## Token-Details (häufige Fehlerquelle)

- Mit `requestedAccessTokenVersion = 2` ist `iss` = `https://login.microsoftonline.com/<TENANT_ID>/v2.0` und `aud` = **Client-ID** (GUID), nicht die App-ID-URI.
- Erstes echtes Token unter https://jwt.ms dekodieren und `aud`, `iss`, `scp` (= `access_as_user`) ins LOG schreiben (Token selbst nicht!).

## Bekannte Probleme (Stand 2026-11-12)

- **Entra + claude.ai**: offene Bugs #506, #632, #1080, #1248 in https://github.com/anthropics/claude-ai-mcp. Signatur: Microsoft-Login erfolgreich (Entra-Anmeldeprotokoll „Erfolg“), dann „Authorization with … failed“ mit `ofid_…`; claude.ai holt kein Token oder schickt keins mit.
- #82/#214: claude.ai findet Metadaten von Login-Servern mit Pfad im Issuer nicht → bei uns umgangen (Metadaten auf eigenem Host).
- #1152: claude.ai sendet `prompt=consent` → Microsoft zeigt die Zustimmungsseite. Für Hugo (Admin) unkritisch: bestätigen.
- #228: Token-Erneuerung (Refresh) bei Custom Connectors wird teils nicht versucht → evtl. nach ~1 h neu verbinden.

**Abbruchkriterium:** Nach 2 ernsthaften Versuchen nicht lauffähig → Entscheidung mit Hugo: eigener kleiner OAuth-Server vor Entra („Token-Broker“, in #506 als funktionierend berichtet) oder Fallback Supabase. Versuche im LOG nummerieren.

## Quellen

- https://claude.com/docs/connectors/building/authentication
- https://claude.com/docs/connectors/custom/remote-mcp
- https://learn.microsoft.com/en-us/azure/container-apps/mcp-authentication
- RFC 9728 (Protected Resource Metadata), RFC 8414 (Authorization Server Metadata)
