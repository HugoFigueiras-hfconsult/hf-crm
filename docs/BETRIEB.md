# Betrieb + Erweitern (Runbook)

Stand 2026-11-12. Für Hugo und für jede Agent-Session. Gesamtbild: `docs/ARCHITEKTUR.md`. Aktueller Stand: `docs/STATUS.md`.

## 1. Das Prinzip in drei Ebenen

| Ebene | Was sie bestimmt | Wo sie steht | Ändern = |
|---|---|---|---|
| **Datenbank** | Welche Daten es gibt (Tabellen, Spalten) | Azure SQL `hfcrm`, Skripte in `db/migrations/` | Migration schreiben → **Hugo gibt frei** → ausführen (Abschnitt 3) |
| **Image** | Was DAB darf (Entities, Felder, Rechte, MCP-Werkzeuge) und was der Türsteher Caddy tut | `dab/dab-config.json`, `dab/Caddyfile`, `dab/start.sh`, `dab/Dockerfile` → gebaut nach `ghcr.io/hugofigueiras-hfconsult/hf-crm-dab` | Repo ändern → Image bauen → ausrollen (Abschnitt 4) |
| **Container App** | Wo und womit es läuft (DB-Adresse, Tenant, Client-ID, CPU/RAM, Skalierung, Port) | Einstellungen von `ca-hf-crm-dab` (Env-Variablen, Secret `dab-connstring`) | `infra/03c-update-app.sh` oder `az containerapp update` |

**DAB ist ein konfigurierter Übersetzer, keine Geschäftslogik:** Er übersetzt die MCP-Werkzeuge `describe_entities`, `read_records`, `create_record`, `update_record`, `aggregate_records` in parametrisiertes SQL und setzt dabei die Rechte aus `dab-config.json` durch. `delete_record` und `execute_entity` sind aus. Die Logik („was bedeutet ein Quartalstermin“) liegt bei Claude (Prompts/Routinen), die DB hat keine Trigger/Prozeduren. Dieselben Entities gibt es auch als REST unter `/api/<Entity>` (z. B. fürs Dashboard).

## 2. Neue Tabelle für Claude freigeben (Checkliste)

1. **Fachlich klären** (Hugo): Welche Felder? Welche davon darf Claude sehen/ändern? (Datenschutz-Regel zu Gesundheitsdaten vorerst ausgesetzt, siehe `CLAUDE.md`.)
2. **Migration** `db/migrations/NNN_beschreibung.sql`, Kopf `-- STATUS: VORSCHLAG` + `-- ZWECK:`. Nur Standardtypen, Primärschlüssel pro Tabelle, keine Trigger/Prozeduren. Details: `docs/02-schema.md`.
3. **Hugo gibt frei** → Kopf auf `-- STATUS: FREIGEGEBEN (Datum)` ändern → ausführen (Abschnitt 3).
4. **Entity in `dab/dab-config.json`** ergänzen. Muster (Syntax vor dem Build mit `dab validate` oder `dab add --help` prüfen):
   ```json
   "Mandant": {
     "source": { "object": "dbo.Mandant", "type": "table" },
     "permissions": [
       { "role": "authenticated", "actions": ["read", "create", "update"] }
     ]
   }
   ```
   - Felder, die Claude nicht sehen darf: in der Berechtigung per `fields`-Ausschluss sperren (DAB-Doku „field-level security“) **oder** gar nicht erst in diese Tabelle legen.
   - Bewusst **keine** `autoentities` (automatische Tabellenerkennung): Jede Freigabe soll ausdrücklich im Repo stehen (Datensparsamkeit). Siehe `00-entscheidungen.md`.
   - DAB-Hinweis „entities missing fields definition while MCP is enabled“: Feldbeschreibungen helfen Claude, die Spalten richtig zu nutzen. Empfohlen, nicht Pflicht.
5. **Platzhalter entfernen**, sobald die erste echte Entity drin ist: Entity `Verbindungstest` (zeigt `INFORMATION_SCHEMA.TABLES`) löschen. DAB startet nur mit mindestens einer Entity.
6. **Image bauen + ausrollen** (Abschnitt 4), danach **testen** (Abschnitt 6).
7. LOG + STATUS, Commit + Push.

DB-Rechte der App müssen dafür **nicht** angepasst werden: Die Managed Identity `ca-hf-crm-dab` ist in `db_datareader` + `db_datawriter` und darf damit alle Tabellen lesen/schreiben, aber **kein** DDL (keine Tabellen anlegen/ändern).

## 3. SQL in der Datenbank ausführen (nur Hugo als Entra-Admin)

Die DB akzeptiert nur Entra-Anmeldung, Admin ist `hugo.figueiras@hf-consult.de`. Drei Wege:

| Weg | Wann | Ablauf |
|---|---|---|
| **A. Azure-Portal, Abfrage-Editor** | aus jeder Session, ohne Werkzeuge | portal.azure.com → SQL-Datenbanken → `hfcrm` → **Abfrage-Editor (Vorschau)** → „Weiter als hugo.figueiras@…“ (Entra) → bei Firewall-Hinweis „IP-Adresse zulassen“ → SQL aus der freigegebenen Datei einfügen → Ausführen. Danach: SQL-Server `sql-hf-crm-106af6` → Netzwerk → die hinzugefügte Client-IP-Regel wieder löschen |
| **B. Lokale Session (Windows-PC)** | wenn ohnehin lokal gearbeitet wird | `./infra/02b-firewall-myip.sh add` → `./db/apply.sh db/migrations/NNN_….sql` → `./infra/02b-firewall-myip.sh remove` (Git Bash; `db/apply.sh` verweigert Dateien mit `STATUS: VORSCHLAG`) |
| **C. Azure Cloud Shell** | Browser, Hugo ist dort angemeldet | Datei-Inhalt in Cloud Shell als Datei anlegen, `sqlcmd -S sql-hf-crm-106af6.database.windows.net -d hfcrm --authentication-method ActiveDirectoryDefault -i datei.sql` (Cloud Shell liegt in Azure → Firewall-Regel „Azure-Dienste“ greift) |

Ergebnis (Zeitpunkt, Datei, Weg) immer ins LOG.

## 4. Neues Image bauen und ausrollen

1. **Bauen** (GitHub Actions, manuell): GitHub → Repo `hf-crm` → Actions → „DAB-Image bauen und nach GHCR pushen“ → Run workflow (Branch `main`). Oder: `gh workflow run dab-image.yml --ref main`. Ergebnis: `ghcr.io/hugofigueiras-hfconsult/hf-crm-dab:<commit-sha>` und `:latest`. Der Build prüft die Caddy-Config (`caddy validate`), **nicht** die DAB-Config gegen die DB.
2. **Ausrollen** (braucht Azure-Zugang):
   - Lokal: `IMAGE_TAG=<commit-sha> ./infra/03c-update-app.sh`
   - Portal: Container App `ca-hf-crm-dab` → Revisionen und Replikate → **Neue Revision erstellen** → Container bearbeiten → Image-Tag `<commit-sha>` → Erstellen
   - Cloud Shell: `az containerapp update -g rg-hf-crm -n ca-hf-crm-dab --image ghcr.io/hugofigueiras-hfconsult/hf-crm-dab:<commit-sha>`
3. **Prüfen**: neue Revision „Running“ (Portal oder `az containerapp revision list -g rg-hf-crm -n ca-hf-crm-dab -o table`), dann Test (Abschnitt 6). Startet die Revision nicht, ist meist die DAB-Config ungültig → Logs (Abschnitt 7), alte Revision läuft weiter bzw. Image-Tag zurücksetzen.

Immer per Commit-SHA ausrollen, nicht `:latest` (sonst unklar, welcher Stand läuft). Laufender Stand steht in `docs/STATUS.md` (Ressourcentabelle).

## 5. Was geht von wo?

| Aufgabe | Cloud-Session (claude.ai / Claude Code in der Cloud) | Lokale Session (Hugos PC) | Hugo im Browser |
|---|---|---|---|
| Schema entwerfen, Migration als Vorschlag | ✅ | ✅ | – |
| `dab-config.json` ändern, committen | ✅ | ✅ | – |
| Image bauen (GitHub Actions) | ✅ falls GitHub-Zugriff (`gh`) vorhanden, sonst Hugo klickt „Run workflow“ | ✅ | ✅ |
| SQL in der DB ausführen | ❌ (`az login` blockiert, AADSTS530035) | ✅ Weg B | ✅ Weg A / C |
| Image ausrollen | ❌ | ✅ | ✅ Portal / Cloud Shell |
| Daten lesen/schreiben über den Connector | ✅ wenn der Connector `HF-CRM` in der Session aktiv ist | ✅ | ✅ claude.ai-Chat |
| Entra, DNS, Secrets | ❌ | ✅ (Hugo meldet sich an) | ✅ |

Option für später (O9): Ausrollen per GitHub Actions mit Azure-OIDC (ohne Secret), dann ginge auch das aus der Cloud-Session. Noch nicht eingerichtet.

## 6. Testen

- **Ohne Login** (geht überall): `curl -i https://mcp.hf-consult.de/mcp` → **401** mit `www-authenticate: Bearer resource_metadata="https://mcp.hf-consult.de/.well-known/oauth-protected-resource", …`. Erster Aufruf nach Leerlauf dauert einige Sekunden (Kaltstart).
- **Mit Login**: im Claude-Chat mit aktivem Connector `HF-CRM`: „Welche Entities gibt es?“ (`describe_entities`), dann ein Datensatz lesen/anlegen. Erwartung: neue Entities mit den freigegebenen Aktionen (`READ`, `CREATE`, `UPDATE`).
- REST ohne Token → 403 ist richtig.

## 7. Logs ansehen

Keine Log-Analytics (Kosten). Live-Konsole der laufenden Revision:

```bash
az containerapp logs show -g rg-hf-crm -n ca-hf-crm-dab --tail 100 --format text
```

Enthält DAB-Fehler (z. B. ungültige Config, SQL-Fehler) und Caddy-Startmeldungen. Caddy protokolliert keine einzelnen Anfragen (bei Bedarf `log`-Block im `Caddyfile` ergänzen). Logins: Entra Admin Center → Anmeldeprotokolle (Filter Anwendung `hf-crm-mcp`).

## 8. Bekannte Fehlerbilder

| Meldung / Symptom | Ursache | Lösung |
|---|---|---|
| „Authorization with HF-CRM failed … AADSTS7000215“ | falsches Client Secret (oft „Geheime ID“ statt „Wert“ kopiert) | neues Secret, Connector löschen + neu anlegen (Abschnitt 9) |
| Connector funktioniert, später „Authorization failed“ | Token abgelaufen, claude.ai erneuert bei Custom Connectors nicht immer (anthropics/claude-ai-mcp #228) | in claude.ai neu verbinden |
| Nach Bearbeiten des Connectors kein neuer Login | bekannter claude.ai-Fehler (#1000-Umfeld) | Connector **löschen und neu anlegen**, nicht bearbeiten |
| 403 „not in the list of trusted hosts“ | neuer Hostname nicht in `runtime.mcp.allowed-hosts` | Hostname in `dab-config.json` ergänzen, Image neu |
| Neue Revision startet nicht | DAB-Config ungültig oder keine Entity | Logs (Abschnitt 7); vorher lokal `dab validate` |
| 401 `invalid_token` von DAB | Token für andere App/Tenant, oder `DAB_JWT_AUDIENCE` falsch | Audience = Client-ID `c3f40bf1-…` prüfen |
| Microsoft-Login zeigt Zustimmungsseite | claude.ai sendet `prompt=consent` (#1152) | bestätigen (unkritisch) |

## 9. Wartung / Fristen

| Was | Wann | Wie |
|---|---|---|
| **Client Secret** `hf-crm-mcp` | läuft ab **2028-11-11** | Entra Admin Center → App-Registrierungen → `hf-crm-mcp` → Zertifikate & Geheimnisse → neues Secret (**Wert** kopieren) → claude.ai: Connector löschen + neu anlegen (Client-ID `c3f40bf1-158a-4fff-8c08-de80976c7875`, URL `https://mcp.hf-consult.de/mcp`) → altes Secret löschen → Ablaufdatum ins LOG |
| **TLS-Zertifikat** `mcp.hf-consult.de` | bis 13.05.2027, **erneuert sich automatisch** | Voraussetzung: CNAME `mcp` + TXT `asuid.mcp` bei INWX bleiben bestehen |
| **Testversion → Pay-As-You-Go** | bis **11.12.2026** (O1) | Hugo im Portal. Vorher Budget-Alarm (O8): `BUDGET_EMAIL=… ./infra/01-budget.sh` |
| **DAB-Version** | gelegentlich | neue Version auf MCR/NuGet prüfen, `DAB_TAG` im Dockerfile ändern, lokal `dab validate`, bauen, ausrollen |
| **INWX** | einmalig | Zwei-Faktor-Anmeldung aktivieren (DNS = Mail-Verkehr) |

## 10. Kosten

0 € im Normalbetrieb: SQL Free Offer pausiert statt zu kosten; Container App gratis bis ≈ 200 aktive Stunden/Monat (0,25 vCPU / 0,5 GiB, schläft nach ~5 min ohne Anfragen); kein Log Analytics, kein ACR, GHCR öffentlich, Zertifikat gratis. Worst Case (rund um die Uhr wach) ≈ 13 €/Monat → Budget-Alarm vor Pay-As-You-Go. Details: `docs/03-dab-mcp.md`, Abschnitt Kosten.
