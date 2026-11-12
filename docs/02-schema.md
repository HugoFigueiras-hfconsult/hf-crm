# Phase 3 – DB-Schema

**Status: ⬜ offen.** Der Tabellenentwurf aus `docs/HANDOVER-2026-11-11.md` (Abschnitt 7, Phase 3) ist laut Hugo **ungültig** und wird nicht verwendet.
Das Schema wird neu mit Hugo definiert (geplant in einer Cloud-Session, Start-Prompt in `HANDOVER-CLOUD.md`). Bis dahin gibt es **keine** Migration; DAB hat nur den Platzhalter `Verbindungstest`.

## Ausgangslage (2026-11-12)

- DB `hfcrm` auf `sql-hf-crm-106af6.database.windows.net` existiert, ist **leer** (Schema `dbo`).
- Die App-Identität `ca-hf-crm-dab` hat `db_datareader` + `db_datawriter` → darf **alle** künftigen Tabellen lesen/schreiben, aber **keine** anlegen/ändern. Neue Tabellen brauchen also keine zusätzlichen Rechte.
- Später kommt `hf-crm-copilot` (nur lesen, `db/setup/02_user_copilot.sql`, Phase 6).
- Der Connector `HF-CRM` in claude.ai läuft. Sobald Entities ausgerollt sind, kann Claude direkt damit arbeiten.

## Rahmenbedingungen (gelten weiter, aus `CLAUDE.md`)

- Portabel: nur Standardtypen, keine Trigger/Funktionen/Stored Procedures, Logik im Agenten (Fallback Supabase/Postgres muss möglich bleiben)
- Keine Gesundheitsdaten (BU/PKV-Angaben) in Feldern, die an Claude gehen
- Dokumente/Transkripte nur als Link (OneDrive/SharePoint), DB hält Zusammenfassung + Link
- Schemaänderungen durch Agenten nur als Vorschlag

## Hinweise für den Entwurf (DAB + Claude)

- **Jede Tabelle braucht einen Primärschlüssel**, sonst kann DAB sie nicht als Entity anbieten (Views brauchen `key-fields` in der Config).
- Primärschlüssel einfach halten (`INT IDENTITY` oder `UNIQUEIDENTIFIER DEFAULT NEWID()`), Fremdschlüssel als normale Spalten mit `FOREIGN KEY`.
- **Sprechende Spaltennamen** und optional Feldbeschreibungen in der DAB-Config: Claude sieht über `describe_entities` nur Namen und Beschreibungen.
- Zeitstempel als `DATETIME2`, Geldbeträge als `DECIMAL(12,2)`, Texte als `NVARCHAR(n)` (Umlaute). Kein `NVARCHAR(MAX)` für Felder, nach denen gefiltert wird.
- Löschen ist für Claude abgeschaltet. Falls „Archivieren“ nötig ist: Statusfeld (z. B. `Aktiv BIT`) statt Löschen.
- Sensible Daten so schneiden, dass sie in **eigenen Tabellen/Spalten** liegen, die in DAB nicht freigegeben werden. Das ist robuster als Feld-Ausschlüsse.

## Vorgehen (vom Entwurf bis live)

1. Hugo beschreibt fachlich, was das CRM abbilden soll (Objekte, Beziehungen, Felder, was an Claude/Copilot geht).
2. Agent legt den Vorschlag als `db/migrations/001_init.sql` an (Kopf `-- STATUS: VORSCHLAG` + `-- ZWECK:`) und dokumentiert ihn hier (Tabelle pro Entität: Felder, Typ, an Claude ja/nein).
3. Hugo gibt frei → Kopfzeile `-- STATUS: FREIGEGEBEN (Datum)`.
4. **SQL ausführen** (nur Hugo als Entra-Admin), einer der Wege aus `docs/BETRIEB.md` Abschnitt 3:
   - A. Azure-Portal → `hfcrm` → Abfrage-Editor (geht aus jeder Session, auch Cloud)
   - B. Lokale Session:

     ```bash
     ./infra/02b-firewall-myip.sh add
     ```

     ```bash
     ./db/apply.sh db/migrations/001_init.sql
     ```

     ```bash
     ./infra/02b-firewall-myip.sh remove
     ```
   - C. Azure Cloud Shell mit `sqlcmd`
5. DAB-Entities in `dab/dab-config.json` ergänzen, Platzhalter `Verbindungstest` entfernen (`docs/BETRIEB.md` Abschnitt 2).
6. Image bauen + ausrollen (`docs/BETRIEB.md` Abschnitt 4), über den Connector testen, LOG + STATUS.

## Migrationskonventionen

- Dateien `db/migrations/NNN_beschreibung.sql`, fortlaufend, nie nachträglich ändern; Korrekturen = neue Migration
- Jede Datei beginnt mit `-- STATUS:` und `-- ZWECK:`
- Idempotent wo möglich (`IF NOT EXISTS`)
- `db/apply.sh` verweigert Dateien, die noch `-- STATUS: VORSCHLAG` tragen

## Entitäten (wird beim Entwurf gefüllt)

| Tabelle | Zweck | Felder (Typ) | An Claude | An Copilot |
|---|---|---|---|---|
| _offen_ | | | | |
