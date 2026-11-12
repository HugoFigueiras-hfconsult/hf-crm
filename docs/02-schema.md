# Phase 3 – DB-Schema

**Status: 🟡 Konzept v0 in Diskussion (2026-11-12).** Der Tabellenentwurf aus `docs/HANDOVER-2026-11-11.md` (Abschnitt 7, Phase 3) ist laut Hugo **ungültig** und wird nicht verwendet.
Noch **keine** Migration; DAB hat nur den Platzhalter `Verbindungstest`.

## Konzept v0 (Vorschlag Agent, 2026-11-12, noch nicht freigegeben)

### Ausgangspunkt (Hugo, 2026-11-12)

- Hauptsystem ist **JDC** (Jung, DMS & Cie. Portal): Vertragsbestand. **Keine Schnittstelle.** Das CRM von **VVO** wird kaum noch genutzt.
- Der Agent soll alles übernehmen, was in JDC **nicht** geht:
  - Termin-**Transkripte** dem Mandanten zuordnen und darauf zugreifen
  - **Fristen und Konditionen** der Verträge kennen (Quelle JDC oder Kopie in OneDrive)
  - in **OneDrive** navigieren, Dokumente lesen, OneDrive **organisieren** (ein Ordner je Mandant)
  - Termine sauber **vor- und nachbereiten**, Kontext zusammenstellen → braucht ein **Gedächtnis**
- Also **kein klassisches CRM**, sondern eine Datenbank, die **verknüpft** und sich **merkt**.

### Rollen der Speicher („jede Information hat genau einen Heimatort“)

| Speicher | Heimat für | Zugriff Agent |
|---|---|---|
| **JDC** | Vertragsbestand (Wahrheit) | keiner (keine API). Hugo exportiert bei Bedarf (PDF/Excel) in den OneDrive-Eingang |
| **OneDrive** (Ordner je Mandant) | **Dokumente und lange Texte**: Policen, Angebote, Transkripte, Protokolle | Microsoft-365-Connector in claude.ai (lesen, suchen, Ordner anlegen, verschieben, umbenennen) |
| **HF-CRM-Datenbank** | **Gedächtnis + Verknüpfungen**: wer ist wer, welcher Ordner, welche Fristen, was wurde besprochen, was ist offen. Kurzfassungen + Links, keine Volltexte | Connector `HF-CRM` (lesen, anlegen, ändern; kein Löschen) |
| **Outlook** | Termine und Mails (Wahrheit für Zeitpunkte) | Microsoft-365-Connector |
| **GitHub-Repo** | **Arbeitsanweisungen** des Agenten (wie Vorbereitung/Nachbereitung/Ablage gehen) + Bauplan. **Keine Mandantendaten** | Repo-Dateien als Anweisungen für Routinen/Projekte |

**Gedächtnis: Repo oder Datenbank?** Beides, getrennt nach Art:
- *Was* der Agent über Mandanten weiß → **Datenbank** (abfragbar: „alle Fristen in 90 Tagen“, „was weiß ich über Familie X“; erreichbar aus jedem Claude-Zugang und für Copilot/Dashboard; liegt im eigenen Azure-Tenant in der EU, Zugriff nur mit Hugos Login).
- *Wie* der Agent arbeitet → **Repo** (versioniert, gut lesbar, als Anweisung ladbar).
- Mandantendaten **nicht** ins Repo (GitHub, schlecht abfragbar, Datenschutz) und **nicht** in Claudes eingebaute Erinnerungsfunktion (nicht strukturiert, nicht teilbar mit Routinen).

### Tabellen v0 (Skelett, Details folgen „on the way“)

| Tabelle | Zweck | Kernfelder |
|---|---|---|
| `Mandant` | Wer, und wo liegt was | `MandantId` (GUID), `Anzeigename`, `Art` (Person/Haushalt/Firma), `Status` (Interessent/aktiv/inaktiv), `OneDriveOrdnerId` + `OneDriveOrdnerPfad`, `JdcKundennummer`, `VvoKundennummer`, `EMail` (Zuordnung von Kalender/Mails), `ErstelltAm`, `GeaendertAm` |
| `Termin` | Jeder Kontakt mit Vor- und Nachbereitung (auch Telefonat) | `TerminId`, `MandantId`, `Beginn`, `Art` (Erstgespräch, Jahresgespräch, Quartal, Telefonat …), `OutlookEventId`, `Vorbereitung` (Kurztext), `Zusammenfassung`, `Ergebnisse`, `TranskriptLink` (OneDrive), `Status` (geplant/vorbereitet/durchgeführt/nachbereitet) |
| `Fakt` | Das eigentliche **Gedächtnis**: einzelne Aussagen über den Mandanten | `FaktId`, `MandantId`, `Kategorie` (Familie, Beruf, Ziele, Präferenzen, Kommunikation, Risiko …), `Inhalt` (kurz), `QuelleTerminId` / `QuelleLink`, `GueltigAb`, `Status` (aktuell/überholt), `ErsetztDurch`, `ErstelltVon` (Agent/Hugo). Neues Wissen **ersetzt** altes (Status „überholt“), statt es zu überschreiben → Verlauf bleibt |
| `Vertrag` | Kurzinfo für Fristen und Konditionen, **nicht** der Bestand | `VertragId`, `MandantId`, `Sparte`, `Gesellschaft`, `Vertragsnummer`, `Beginn`, `Ablauf`, `KuendigungBis` (Datum), `Beitrag`, `Zahlweise`, `KonditionenKurz`, `QuelleLink` (OneDrive/JDC-Export), `StandVom` |
| `Aufgabe` | Fristen, Wiedervorlagen, To-dos | `AufgabeId`, `MandantId` (optional), `Titel`, `FaelligAm`, `Art` (Frist/Wiedervorlage/To-do), `VertragId`/`TerminId` (optional), `Status` (offen/erledigt), `ErledigtAm` |
| _später:_ `Dokument` | Index wichtiger Dateien mit Kurzbeschreibung | erst, wenn OneDrive-Suche nicht reicht |

### Abläufe (Beispiele)

- **Vorbereitung** (Routine morgens oder auf Zuruf): Outlook-Termine → Mandant über E-Mail/Name zuordnen → aus der DB `Fakt` (aktuell), letzte `Termin`e, offene `Aufgabe`n, `Vertrag` mit nahen Fristen; aus OneDrive neue Dokumente → Briefing an Hugo, Kurzfassung in `Termin.Vorbereitung`.
- **Nachbereitung**: Transkript landet in OneDrive → Agent verschiebt es in den Mandantenordner → `Termin.Zusammenfassung`/`Ergebnisse` + Link, neue `Fakt`en (alte ggf. „überholt“), `Aufgabe`n, Entwurf der Folge-Mail in Outlook.
- **Fristen**: wöchentlich `Vertrag.KuendigungBis`/`Ablauf` und `Aufgabe.FaelligAm` der nächsten 90 Tage → Liste an Hugo.
- **JDC-Abgleich**: Hugo legt Exporte in den OneDrive-Eingang → Agent legt sie im Mandantenordner ab und trägt Fristen/Konditionen in `Vertrag` ein (mit `StandVom` + Link).

### OneDrive-Struktur (Vorschlag)

```
Mandanten/
  _Eingang/                       ← JDC-Exporte, neue Transkripte; der Agent sortiert von hier
  Nachname, Vorname/              ← Ordner-ID steht in Mandant.OneDriveOrdnerId
    01 Verträge/
    02 Termine/                   ← JJJJ-MM-TT Art.docx, Transkripte, Protokolle
    03 Korrespondenz/
    04 Analysen und Angebote/
    05 Unterlagen Mandant/
```

### Offene Entscheidungen (Hugo)

1. **Gesundheitsdaten in Transkripten/Dokumenten**: Wenn der Agent Transkripte und Policen aus OneDrive liest, sieht Claude auch BU/PKV-Gesundheitsangaben (besondere Kategorie, Art. 9 DSGVO). Die bisherige Regel schützt nur DB-Felder. Mit dem Max-Plan (Consumer Terms, kein AVV, O5) ist das ein Risiko. Optionen: Team-Plan mit AVV **vor** echten Mandantendaten, oder Gesundheitsunterlagen außerhalb der vom Agenten gelesenen Ordner halten.
2. **Mandant = Person oder Haushalt?** Vorschlag: Mandant = die Einheit mit **einem** OneDrive-Ordner (oft der Haushalt); einzelne Personen bei Bedarf später als eigene Tabelle.
3. **Woher kommen Transkripte?** (Teams, Diktier-App, Telefon-Aufzeichnung …) → bestimmt die Nachbereitungs-Routine.
4. **Was kann JDC exportieren?** Eine Bestandsliste (Excel/CSV) je Mandant oder gesamt wäre ideal: Dann kann der Agent `Vertrag` in einem Rutsch füllen.

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
