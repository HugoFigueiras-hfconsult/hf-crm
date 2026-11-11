# Phase 3 – DB-Schema

**Status: ⬜ offen.** Der Tabellenentwurf aus `docs/HANDOVER-2026-11-11.md` (Abschnitt 7, Phase 3) ist laut Hugo **ungültig** und wird nicht verwendet.
Das Schema wird neu mit Hugo definiert. Bis dahin gibt es **keine** Migration und **keine** DAB-Entities.

## Rahmenbedingungen (gelten weiter, aus `CLAUDE.md`)

- Portabel: nur Standardtypen, keine Trigger/Funktionen/Stored Procedures, Logik im Agenten (Fallback Supabase/Postgres muss möglich bleiben)
- Keine Gesundheitsdaten (BU/PKV-Angaben) in Feldern, die an Claude gehen
- Dokumente/Transkripte nur als Link (OneDrive/SharePoint), DB hält Zusammenfassung + Link
- Schemaänderungen durch Agenten nur als Vorschlag

## Vorgehen

1. Hugo beschreibt fachlich, was das CRM abbilden soll (Objekte, Beziehungen, Felder, was an Claude/Copilot geht).
2. Agent legt Vorschlag als `db/migrations/001_init.sql` mit Kopfzeile `-- STATUS: VORSCHLAG` an und dokumentiert ihn hier (Tabelle pro Entität).
3. Hugo gibt frei → Kopfzeile `-- STATUS: FREIGEGEBEN (Datum)`, dann Ausführung:

```bash
./infra/02b-firewall-myip.sh add
```

```bash
./db/apply.sh db/migrations/001_init.sql
```

```bash
./infra/02b-firewall-myip.sh remove
```

4. LOG-Eintrag, danach DAB-Entities in `dab/dab-config.json` ergänzen (Phase 4.3).

## Migrationskonventionen

- Dateien `db/migrations/NNN_beschreibung.sql`, fortlaufend, nie nachträglich ändern; Korrekturen = neue Migration
- Jede Datei beginnt mit `-- STATUS:` und `-- ZWECK:`
- Idempotent wo möglich (`IF NOT EXISTS`)
