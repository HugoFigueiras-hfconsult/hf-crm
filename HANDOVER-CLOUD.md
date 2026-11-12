# Handover → Cloud-Session: Datenbank-Schema (Phase 3)

Stand: 2026-11-12 · Repo: `HugoFigueiras-hfconsult/hf-crm` (Branch `main`) · vorher: `HANDOVER-LOKAL.md` (erledigt)

## Was schon läuft (nicht neu bauen)

- **Azure SQL** `sql-hf-crm-106af6.database.windows.net`, DB `hfcrm` (Free Offer, AutoPause), **leer**.
- **MCP-Server** `https://mcp.hf-consult.de/mcp`: Container App `ca-hf-crm-dab` mit Caddy (Türsteher, Login-Pflicht) + DAB 2.1.5.
- **Claude-Connector `HF-CRM`** in claude.ai: verbunden und getestet (Entra-Login, nur Hugo).
- Einzige DAB-Entity: Platzhalter `Verbindungstest` (System-View, nur lesen). Wird mit den echten Entities entfernt.

Gesamtbild: `docs/ARCHITEKTUR.md`. Betrieb/Erweitern Schritt für Schritt: `docs/BETRIEB.md`.

## Auftrag

Mit Hugo das CRM-Schema definieren und so weit bringen, dass Claude über den Connector echte CRM-Daten lesen/anlegen/ändern kann.

1. Fachlich mit Hugo klären: Objekte (z. B. Mandanten, Kontakte, Verträge/Policen, Termine, Aufgaben), Beziehungen, Felder, **was an Claude geht und was nicht** (Gesundheitsdaten nie). Ergebnis in `docs/02-schema.md` (Tabelle pro Entität).
2. Migration `db/migrations/001_init.sql` mit `-- STATUS: VORSCHLAG` schreiben (Regeln: `docs/02-schema.md`, `CLAUDE.md`). Commit + Push.
3. **Hugo gibt frei** → Status auf `FREIGEGEBEN (Datum)`.
4. DAB-Entities in `dab/dab-config.json` ergänzen, Platzhalter `Verbindungstest` entfernen (Checkliste: `docs/BETRIEB.md` Abschnitt 2). Commit + Push.
5. Hugo (oder lokale Session) führt das SQL aus und rollt das neue Image aus (`docs/BETRIEB.md` Abschnitte 3 + 4). Image bauen per GitHub Actions.
6. Test über den Connector (`describe_entities`, Testdatensatz anlegen/lesen/ändern), Ergebnis ins LOG.

## Was die Cloud-Session kann und was nicht

- ✅ Schema entwerfen, SQL-Migration schreiben, `dab-config.json` ändern, Doku, Commit + Push.
- ✅ Über den Connector `HF-CRM` Daten lesen/schreiben (wenn in der Session aktiv), sobald die Entities ausgerollt sind.
- ✅/❓ Image-Build anstoßen, falls die Session GitHub-Zugriff (`gh`) hat; sonst klickt Hugo in GitHub Actions auf „Run workflow“.
- ❌ **Kein Azure-Zugang** (`az login` aus Cloud-Sessions durch Security Defaults blockiert, AADSTS530035). Also: kein SQL ausführen, kein Ausrollen. Dafür Hugo-Wege in `docs/BETRIEB.md` Abschnitt 3 (Portal-Abfrage-Editor / Cloud Shell) und Abschnitt 4 (Portal → neue Revision) nennen, mit fertigem Text zum Einfügen.
- ❌ DAB kann keine Tabellen anlegen (App-Identität hat kein DDL-Recht, so gewollt).

## Harte Regeln (Kurzfassung, vollständig in `CLAUDE.md`)

- Schema portabel: Standardtypen, Primärschlüssel, keine Trigger/Funktionen/Prozeduren, Logik im Agenten.
- Datenschutz-Regel „keine Gesundheitsdaten an Claude“ ist **vorerst ausgesetzt** (Hugo, 2026-11-12, AVV später mit Team-Account). Originaldokumente bleiben in OneDrive.
- Schemaänderungen nur als Vorschlag, Ausführung erst nach Hugos Freigabe.
- Keine Secrets ins Repo. Jede Aktion in `docs/LOG.md` + `docs/STATUS.md`, nach jedem Schritt Commit + Push.

## Start-Prompt (in die Cloud-Session kopieren)

```
Lies CLAUDE.md, HANDOVER-CLOUD.md, docs/STATUS.md, docs/ARCHITEKTUR.md, docs/BETRIEB.md
und docs/02-schema.md. Der MCP-Server und der Connector HF-CRM laufen bereits.
Ziel: Wir definieren zusammen das Datenbank-Schema für mein CRM. Frag mich zuerst
fachlich ab, was das CRM abbilden soll, und schlag dann eine Migration als VORSCHLAG vor.
Nichts ausführen, was Azure-Zugang braucht. Dokumentiere jede Entscheidung in docs/
und pushe nach jedem Schritt.
```
