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
| 2026-11-12 | DAB-Entities | **Ausdrücklich** pro Tabelle in `dab/dab-config.json` freigeben, keine `autoentities` (DAB 2.1) | Datensparsamkeit: Was Claude sieht, muss im Repo stehen und geprüft sein (Gesundheitsdaten nie an Claude). Automatische Erkennung würde jede neue Tabelle sofort freigeben |
| 2026-11-12 | Ebenen-Trennung | DAB-Fähigkeiten im **Image** (Config eingebacken), Umgebungswerte in der **Container App**, Daten in der **DB** | Reproduzierbar (jeder Stand = Commit-SHA), keine Config-Dateien außerhalb des Repos. Ablauf: `docs/BETRIEB.md` |
| 2026-11-12 | Gedächtnis-Form | **Markdown-Profil je Mandant in der DB** (`Mandant.Profil`) statt Tabelle `Fakt` und statt .md-Dateien im Repo; harte Daten (Fristen, Aufgaben, Termine) in Tabellen | Hugo: „immer voller Kontext“. Profil = 1 Aufruf lesen/schreiben, überall erreichbar (Chat, Routinen, Dashboard), Mandantendaten bleiben aus GitHub/Cloud-Klonen raus. Voller Kontext über drei Schichten (Profil immer, Verlauf + harte Daten bei Vorbereitung, Rohmaterial bei Bedarf), siehe `02-schema.md` |
| 2026-11-12 | Mandantendaten im Repo | **Nein** (auch nicht als Index) | GitHub als zusätzlicher Dienstleister, Kopie in jeder Cloud-Session, nur in Claude Code erreichbar. Repo enthält nur Arbeitsanweisungen + Bauplan |
| 2026-11-12 | Datenschutz/AVV | **Vorerst ignorieren**; Hugo löst es später mit einem Claude-Team-Account (AVV). Regel „Gesundheitsdaten nie an Claude“ bis dahin ausgesetzt | Entscheidung Hugo. Konzept soll nicht durch Einschränkungen verbogen werden, die mit dem Team-Account ohnehin neu bewertet werden |
| 2026-11-12 | Transkripte | **Volltext in eigener Tabelle `Transkript`** (1:1 zu `Termin`), Originaldatei bleibt in OneDrive. Einpflegen ist Teil der Nachbereitung | Ein Connector für alles, Suche über alle Transkripte, Kosten 0 € (≈ 43 MB/Jahr bei 100 Mandanten). Eigene Tabelle statt Spalte, damit Volltexte nie versehentlich mitgeladen werden. Stufe 1: Agent schreibt selbst (≈ 13k Output-Tokens je Gesprächsstunde, Längenkontrolle); Stufe 2 bei Bedarf: automatischer Import aus OneDrive |
| 2026-11-12 | Transkripte (revidiert) | **Volltext bleibt in OneDrive, DB verlinkt** (`Termin.TranskriptLink`) + Zusammenfassung/Profil. Ersetzt den Eintrag „Volltext in eigener Tabelle“ vom selben Tag | Hugo, nachdem klar war: Für die DB müsste Claude jeden Volltext komplett abschreiben (≈ 13k Output-Tokens je Gesprächsstunde, Minuten, Kopierfehler-Risiko). Lesen bei Bedarf kostet nur Eingabe-Tokens. Tabelle `Transkript` erst, wenn ein automatischer Import ohne Claude existiert |
