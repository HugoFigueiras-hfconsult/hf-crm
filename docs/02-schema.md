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
- *Was* der Agent über Mandanten weiß → **Datenbank** (abfragbar: „alle Fristen in 90 Tagen“, „was weiß ich über Familie X“; erreichbar aus jedem Claude-Zugang und für Copilot/Dashboard; liegt im eigenen Azure-Tenant in der EU, Zugriff nur mit Hugos Login). Das Weiche steht als **Markdown-Profil je Mandant** in der DB (`Mandant.Profil`), das Harte in Tabellen.
- *Wie* der Agent arbeitet → **Repo** (versioniert, gut lesbar, als Anweisung ladbar).
- Mandantendaten **nicht** ins Repo (GitHub, jede Cloud-Session klont eine Kopie, nur in Claude Code erreichbar, übergreifend schlecht abfragbar) und **nicht** in Claudes eingebaute Erinnerungsfunktion (nicht strukturiert, nicht teilbar mit Routinen).

### Voller Kontext: drei Schichten (Entscheidung Hugo 2026-11-12: „immer voller Kontext über den Mandanten“)

| Schicht | Inhalt | Umfang | Wann geladen |
|---|---|---|---|
| **1. Profil** `Mandant.Profil` | Lebendes Markdown-Dokument: Familie, Beruf, Ziele, Vorlieben, Absicherungslage in Worten, Gesprächsverlauf in Kurzform, offene Themen. Der Agent **verdichtet** es nach jedem Termin | 1–3 Seiten, ca. 2–4k Tokens | **immer** (jede Vorbereitung, jede Frage zum Mandanten) |
| **2. Verlauf + harte Daten** | `Termin.Zusammenfassung`/`Ergebnisse` (letzte 3–5), offene `Aufgabe`n, `Vertrag` mit Fristen/Konditionen | ca. 2–3k Tokens | **immer** bei Vorbereitung |
| **3. Rohmaterial** | Volltranskripte, Policen, Angebote | je Transkript ca. 13k Tokens (1 h) | **nur bei Bedarf**, gezielt (z. B. „was genau hat er zur Rente gesagt?“) |

Warum nicht immer alles laden: Alle Transkripte eines Mandanten nach 5 Jahren (4 Termine/Jahr) wären ca. 255k Tokens. Das passt nicht sinnvoll in den Kontext, ist langsam, verbraucht Nutzungslimits und verschlechtert die Antworten („lost in the middle“). **Voller Kontext entsteht dadurch, dass die Nachbereitung jedes Transkript sofort in Profil und Zusammenfassung verdichtet.** Rohmaterial bleibt jederzeit abrufbar.

### Performance (Abwägung Repo vs. DB, 2026-11-12)

- Anzahl der Connector-Aufrufe hängt vom Design ab, nicht von der Zahl der Notizen: Vorbereitung = 2–3 Aufrufe (Profil, offene Aufgaben/Fristen, letzte Termine), parallel möglich. Nachbereitung = Profil 1× schreiben + Termin + wenige Aufgaben.
- Warm ca. 0,5–2 s je Aufruf. **Kaltstart** beim ersten Zugriff nach Leerlauf: Container wacht auf (Sekunden) und die Free-DB läuft nach 60 min Pause wieder an (bis ca. 1 min). Gegenmittel: Morgen-Routine (Terminvorbereitung) weckt alles vorab. Noch nicht gemessen.
- Repo-Dateien wären in Claude-Code-Sessions zwar sofort lesbar, aber nicht im claude.ai-Chat/Handy, nicht für Dashboard/Copilot, übergreifend schlecht abfragbar, und jede Cloud-Session hätte eine Kopie aller Mandantendaten. Token-Kosten sind bei beiden gleich.

### Tabellen v0 (Skelett, Details folgen „on the way“)

| Tabelle | Zweck | Kernfelder |
|---|---|---|
| `Mandant` | Wer, und wo liegt was | `MandantId` (GUID), `Anzeigename`, `Art` (Person/Haushalt/Firma), `Status` (Interessent/aktiv/inaktiv), `OneDriveOrdnerId` + `OneDriveOrdnerPfad`, `JdcKundennummer`, `VvoKundennummer`, `EMail` (Zuordnung von Kalender/Mails), **`Profil`** (Markdown, `NVARCHAR(MAX)`, Schicht 1), `ProfilStand` (wann zuletzt verdichtet), `ErstelltAm`, `GeaendertAm` |
| `Termin` | Jeder Kontakt mit Vor- und Nachbereitung (auch Telefonat) | `TerminId`, `MandantId`, `Beginn`, `Art` (Erstgespräch, Jahresgespräch, Quartal, Telefonat …), `OutlookEventId`, `Vorbereitung` (Kurztext), `Zusammenfassung`, `Ergebnisse`, `TranskriptLink` (OneDrive), `Status` (geplant/vorbereitet/durchgeführt/nachbereitet) |
| `Vertrag` | Kurzinfo für Fristen und Konditionen, **nicht** der Bestand | `VertragId`, `MandantId`, `Sparte`, `Gesellschaft`, `Vertragsnummer`, `Beginn`, `Ablauf`, `KuendigungBis` (Datum), `Beitrag`, `Zahlweise`, `KonditionenKurz`, `QuelleLink` (OneDrive/JDC-Export), `StandVom` |
| `Aufgabe` | Fristen, Wiedervorlagen, To-dos | `AufgabeId`, `MandantId` (optional), `Titel`, `FaelligAm`, `Art` (Frist/Wiedervorlage/To-do), `VertragId`/`TerminId` (optional), `Status` (offen/erledigt), `ErledigtAm` |
| _optional:_ `Transkript` | Volltext eines Transkripts (Schicht 3), getrennt von `Termin`, damit er nie versehentlich mitgeladen wird | `TranskriptId`, `TerminId`, `Text` (`NVARCHAR(MAX)`), `Quelle` (OneDrive-Link der Originaldatei). Nur falls Entscheidung 5 = „auch in der DB“ |
| _später:_ `ProfilVersion` | Alte Profilstände, falls Verlauf über die Termin-Zusammenfassungen hinaus gebraucht wird | erst bei Bedarf |
| _später:_ `Dokument` | Index wichtiger Dateien mit Kurzbeschreibung | erst, wenn OneDrive-Suche nicht reicht |

Entfallen gegenüber dem ersten Entwurf: Tabelle `Fakt` (einzelne Aussagen) → ersetzt durch `Mandant.Profil` (weniger Aufrufe, liest sich wie eine Akte, Agent verdichtet selbst).

### Abläufe (Beispiele)

- **Vorbereitung** (Routine morgens oder auf Zuruf): Outlook-Termine → Mandant über E-Mail/Name zuordnen → aus der DB `Mandant.Profil`, letzte `Termin`e, offene `Aufgabe`n, `Vertrag` mit nahen Fristen (Schichten 1 + 2); aus OneDrive neue Dokumente → Briefing an Hugo, Kurzfassung in `Termin.Vorbereitung`.
- **Nachbereitung**: Transkript landet in OneDrive → Agent verschiebt es in den Mandantenordner → `Termin.Zusammenfassung`/`Ergebnisse` + Link → **`Mandant.Profil` aktualisieren und verdichten** (Neues einarbeiten, Überholtes ersetzen, Umfang halten) → `Aufgabe`n → Entwurf der Folge-Mail in Outlook.
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
5. **Transkripte auch als Text in der DB?** Kosten sind kein Argument (siehe unten). Für die DB spricht: ein Connector, Suche über alle Transkripte per SQL. Dagegen: doppelte Ablage, Originaldatei bleibt ohnehin in OneDrive, Microsoft-Suche findet Text in OneDrive-Dokumenten auch. Und: Transkripte enthalten Gesundheitsangaben → in der DB wären das Felder, die an Claude gehen (Regel aus `CLAUDE.md`, hängt an Entscheidung 1). Vorschlag Agent: Original in OneDrive, Verdichtung in Profil/Termin; Volltext in der DB (`Transkript`) erst, wenn die OneDrive-Suche nicht reicht.

### Kosten: Transkripte in der DB (Schätzung 2026-11-12)

| Größe | Wert |
|---|---|
| 1 h Gespräch | ca. 8.500 Wörter ≈ 57.000 Zeichen ≈ **110 KB** in `NVARCHAR` (UTF-16) ≈ **13k Tokens** |
| 100 Mandanten × 4 Termine/Jahr | ca. **43 MB/Jahr**, nach 10 Jahren ca. 0,4 GB |
| 100 Mandanten × 8 Termine/Jahr | ca. 87 MB/Jahr, nach 10 Jahren ca. 0,8 GB |
| Free Offer | **32 GB** Daten (geprüft: `maxSizeBytes` = 32 GB) + 32 GB Backup, 100.000 vCore-Sekunden/Monat |

→ Speicher kostet **0 €**, auch nach Jahren (unter 3 % des Freikontingents). Lesen/Schreiben von Text ist für die DB-Rechenzeit vernachlässigbar. Der echte „Preis“ sind Tokens im Kontext (siehe Schichten), nicht der Speicherort.

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
