# Mandanten-Artefakt: Vorlage

Stand 2026-11-25 · 🟡 **Vorlage mit erfundenen Testdaten gebaut, wartet auf Hugos Blick** (Schritt 1 und 2 aus `docs/10-mandanten-artefakt.md`, „Umsetzung“)

## Zweck

`mandant-vorlage.html` ist die Vorlage für das **eine Artefakt je Mandant**: Hugos Präsentation und Navigationsbasis in Analyse, Konzept und Update-Termin. Gezeigt wird es nur per Bildschirmfreigabe in Teams. Der Mandant bekommt keinen Link.

Die Vorlage enthält **nur erfundene Testdaten** (Paar „Lena & Jonas“, Empfehlungsgeberin „Carla“, Anbieter heißen „Anbieter A“, „Kasse B“ usw.). Oben steht dezent „Testdaten“.

| Datei | Inhalt |
|---|---|
| `mandant-vorlage.html` | eine Datei, alles eingebaut: Gestaltung, Gerüst, Daten, Rechner. Kein Netzwerkzugriff, keine fremden Bibliotheken, Systemschrift |
| `README.md` | diese Beschreibung |

## Anschauen und bedienen

- **Lokal:** Datei im Browser öffnen (Doppelklick). **Als Artefakt:** die Datei veröffentlichen. Sie ist nach dem Seitenvertrag für Artefakte gebaut (kein eigenes `<html>`/`<body>`, das Gerüst kommt beim Veröffentlichen dazu). Lokal ergänzt der Browser es selbst.
- **In Teams:** nur das Browser-Fenster freigeben, dann „Präsentation“ (oder Taste `F`).

| Bedienung | Was passiert |
|---|---|
| Kachel auf der Startseite | springt in das Kapitel (Kachel zoomt auf) |
| „Übersicht“ oben, Klick auf den Namen oder `Esc` | zurück zur Startseite |
| `→` / `←`, `Bild ab` / `Bild auf`, Leertaste, „Weiter“ | vor und zurück. Auf Folien mit „Heute / Vorschlag“ schaltet `→` **erst** auf „Vorschlag“ und geht dann weiter (wie eine Animation in PowerPoint) |
| `Pos1` / `Ende` | erste / letzte Folie |
| Fortschrittsleiste unten | zeigt, wo wir sind. Jeder Abschnitt ist anklickbar |
| Schalter „Animationen“ | alle Bewegungen aus. Die Wahl merkt sich der Browser. Ist am Gerät „Bewegung reduzieren“ eingestellt, starten sie aus |
| Halbmond-Knopf | hell / dunkel |
| „Präsentation“ oder `F` | Vollbild ohne Kopfzeile. Zurück mit `Esc` oder „Beenden“ |
| Regler (Folien 7 und 8) | rechnen sofort neu. „Zurück zum Vorschlag“ stellt die Startwerte wieder her |

## Kapitel und Sprungadressen

Jede Folie hat eine Adresse zum Anhängen an den Link, z. B. `…#rentenluecke`.

| Kap. | Folie | Adresse | Schritte | Inhalt | Termin |
|---|---|---|---|---|---|
| – | Übersicht | `#start` | – | Kacheln für alle Folien | alle |
| 1 | Ziele | `#ziele` | – | Zeitstrahl kurz / mittel / lang, Summe je Topf | Analyse |
| 2 | Drittel-Regel | `#drittel` | Heute → Mit Vorschlag | Faustregel, Ist, Abstand zum Drittel | Analyse |
| 3 | Heute aufgestellt | `#heute` | – | Rücklage, Sparraten und Anlagen je Topf, Risikoprofil | Analyse |
| 4 | Einkommen | `#einkommen` | Heute → Im Alter | Brutto fließt in Steuer, Abgaben, Netto und Verwendung. Dann: was im Alter bleibt | Konzept |
| 5 | Übersicht Bereiche | `#uebersicht` | Heute → Vorschlag | Aufwand je Bereich, Summe. Klick öffnet den Bereich | Konzept |
| 6 | Gesundheit | `#gesundheit` | Heute → Vorschlag | Vertrag heute, Vorschlag, „Warum dieser“ mit den verglichenen Tarifen, Faktenbox | Konzept |
| 6 | Basisrisiken | `#basisrisiken` | Heute → Vorschlag | wie oben | Konzept |
| 6 | Einkommen absichern | `#arbeitskraft` | Heute → Vorschlag | wie oben | Konzept |
| 7 | Drei Töpfe | `#toepfe` | Heute → Vorschlag | Sparrate je Topf, Ziele, Produkte | Konzept |
| 7 | Vermögensaufbau | `#vermoegensaufbau` | – | Kurve je Topf mit Entnahmen für die Ziele, Regler | Konzept |
| 7 | Kurz oder mittel | `#kurz-mittel` | – | gleiche Sparrate, Tagesgeld gegen Aktienfonds, Regler | Konzept |
| 8 | Rentenlücke | `#rentenluecke` | Heute → Mit Vorschlag | Bedarf, Netto-Rente, Lücke, Regler | Konzept |
| 9 | Nächste Schritte | `#schritte` | – | nächster Termin, Unterlagen, Aufgaben beider Seiten | alle |
| 10 | Verlauf | `#verlauf` | – | Depot, erreichte Ziele, Termine, Neuerungen | Update |
| – | Zum Schluss | `#empfehlungen` | – | dezente Empfehlungsfolie, abschaltbar | Hugo entscheidet |

Folien ausblenden: Kennung ohne `#` in `DATEN.optionen.ausgeblendet` eintragen, z. B. `["verlauf"]`. Die Empfehlungsfolie hat einen eigenen Schalter: `DATEN.optionen.empfehlungsfolie`. Ein Bereich ohne Verträge bekommt von selbst keine Detail-Folie.

## Aufbau der Datei

| Abschnitt | Inhalt | Ändert der Agent je Mandant? |
|---|---|---|
| `<title>` | Name des Artefakts in der Galerie | ja: z. B. „Finanzplan Nachname“ |
| `<style>` | Farben als Variablen (hell und dunkel), Layout, Animationen | nein |
| Gerüst | Kopf, Bühne, Fuß | nein |
| `1. DATEN` | **alle** Mandantendaten in einem Objekt | **ja, nur das** |
| `2. RECHT` | gesetzliche Werte 2026 (Quelle `agent/fachwissen.md`) | nein, jährlich prüfen |
| `3. RECHENKERN` | Rechenfunktionen ohne Bildschirm (`RECHNEN.…`) | nein |
| `4. HELFER` | Formatierung, Anrede du/ihr, Animation, Diagramme, Regler | nein |
| `5. FOLIEN` | je Folie: `render`, `betreten`, `schritt`, `rechne` | nein |
| `6. BÜHNE` | Navigation, Tastatur, Sprungadressen, Präsentation | nein |

Die Datei hat rund 170 KB. Der Agent liest für eine Aktualisierung nur den Block `const DATEN = { … };` (er steht direkt am Anfang des Skripts) und tauscht ihn aus.

## Das Datenobjekt `DATEN`

Feldnamen wie in der Datenbank (`db/migrations/001_init.sql`, `docs/02-schema.md` „Entitäten“). Beträge in Euro, Finanzstatus pro Monat. **„nur Artefakt“** heißt: Dieses Feld gibt es in der DB (noch) nicht. Der Agent leitet es aus dem Profil, aus Unterlagen oder aus Hugos Vorgaben ab. Schlüssel (`…Id`) sind in der DB GUIDs, in den Testdaten kurze Kürzel. Fehlende Listen dürfen fehlen oder leer sein.

### `meta` und `optionen` (nur Artefakt)

| Feld | Bedeutung |
|---|---|
| `meta.Stand` | Stichtag aller Rechnungen (`JJJJ-MM-TT`). Daraus kommen „heute“ und die Jahre bis zur Rente |
| `meta.Testdaten` | `true` zeigt das Kennzeichen „Testdaten“. Bei echten Mandanten `false` |
| `meta.AktuellerTerminId` | Termin, für den das Artefakt vorbereitet ist (steht auf der Startseite, steuert „Nächster Termin“) |
| `optionen.empfehlungsfolie` | letzte Folie zeigen (`true`/`false`) |
| `optionen.animationen` | Startwert des Schalters |
| `optionen.kaufkraft` | `"heute"` (alles in heutiger Kaufkraft) oder `"nominal"` |
| `optionen.ausgeblendet` | Liste von Folien-Kennungen, die nicht gezeigt werden |

### `mandant` ← Tabelle `Mandant`

`MandantId`, `Anzeigename`, `Art`, `Status`, `Geburtsjahr` (für Alter und Rentenbeginn), `Schwerpunkt`, `Risikoprofil` (1–10) + `RisikoprofilAm`, `EmpfohlenVonText`, `Terminrhythmus`.
Nur Artefakt: `EmpfohlenVonAnzeige` (so, wie Hugo den Namen sagen würde, z. B. nur der Vorname; sonst wird `EmpfohlenVonText` gezeigt).
**Nicht** ins Artefakt: `Profil`, `Erstkontakt`, Kundennummern, OneDrive-Pfade, E-Mail.

### `personen` (nur Artefakt, aus `Mandant.Profil`)

Liste mit `Vorname`, `Geburtsjahr`, `Beruf`. Zwei Einträge schalten die Anrede auf „ihr“, einer auf „du“. Die Vornamen bilden den Namen im Kopf. Leer: Es wird `Anzeigename` gezeigt.

### `ziele` ← Tabelle `Ziel`

`ZielId`, `Topf` (kurz/mittel/lang), `Beschreibung`, `Betrag`, `Jahr`, `Status` (offen/erreicht/verworfen), `Notiz`.
Regeln: `verworfen` wird nicht gezeigt. `Betrag` ist **in heutiger Kaufkraft** gemeint. Ziele ohne Betrag (z. B. „mit 67 gut leben“) stehen auf dem Zeitstrahl, werden aber nicht entnommen. `Notiz` ist für den Mandanten sichtbar.

### `finanzstatus` ← Tabelle `Finanzstatus` (jüngster Stichtag)

| Feld | Verwendung |
|---|---|
| `Brutto`, `Steuer`, `AbgabenAV`, `AbgabenKVPV`, `AbgabenRV` | Folie Einkommen. Netto = Brutto minus diese vier |
| `NettoVon`, `NettoBis` | nur wenn `Brutto` fehlt: Netto = Mitte der Spanne |
| `Nebeneinkommen` | zählt in der Drittel-Regel zum Netto |
| `Wohnkosten`, `Lebenshaltung`, `Verbindlichkeiten` | Drittel-Regel, Einkommen |
| `Ruecklage` | Folie 3 und Start des kurzen Topfs |
| `SparrateKurz`, `SparrateMittel`, `SparrateLang` | Sparraten **heute** |
| `RenteLautInfo`, `RenteninfoStand` | Hochrechnung zur Regelaltersgrenze aus der Renteninformation, **brutto** (bei Paaren die Summe) |
| `Rentenbeginn`, `Annahmen` | zur Information. Gerechnet wird mit `mandant.Geburtsjahr` + `annahmen.Rentenalter` |
| `BedarfImAlter` | Netto-Bedarf im Monat in heutiger Kaufkraft (wenn `bedarfImAlter` fehlt) |
| `Rentenluecke` | Kontrollwert des Agenten. Das Artefakt rechnet selbst und meldet in der Browser-Konsole, wenn es mehr als 5 € abweicht |

Nur Artefakt: `RenteBisherErreicht` (bisher erreichte Anwartschaft aus der Renteninformation). Damit rechnet der Regler „Rentenbeginn“ bei 63 bis 66 mit weniger Beitragsjahren. Fehlt es, wird nur der Abschlag gerechnet.

### `bedarfImAlter` und `vorschlag` (nur Artefakt)

- `bedarfImAlter`: `Lebenshaltung`, `Wohnkosten`, `Absicherung`. Die Summe ist der Bedarf im Alter (Folie 4 „Im Alter“ und Folie 8). Steuer und Krankenversicherung im Alter gehören **nicht** hinein, die zieht das Artefakt von der Rente ab.
- `vorschlag`: `SparrateKurz`, `SparrateMittel`, `SparrateLang` **mit Vorschlag**. Muss zu den Kapital-Verträgen passen (Summe der Beiträge je Topf). Fehlt es, gibt es keinen Schritt „Vorschlag“ bei Drittel-Regel und Töpfen.

### `vertraege` ← Tabelle `Vertrag`

`VertragId`, `Bereich` (Gesundheit/Basisrisiken/Einkommen/Wohnen/Kapital), `Topf` (nur Kapital), `Sparte`, `Gesellschaft`, `Tarif`, `Beitrag`, `Zahlweise`, `KonditionenKurz`, `Status`, `Betreuung`, `Hinweis`, `ErsetztVertragId`, `Variante`, `Beginn`.

Regeln:
- Gezeigt werden `Status` **aktiv** (= heute) und **Vorschlag**. Andere Status weglassen.
- Ein Vorschlag mit `ErsetztVertragId` ist ein **Wechsel**, ohne ist er **neu**. Ein aktiver Vertrag ohne Vorschlag **bleibt**.
- `Beitrag` wird über `Zahlweise` auf den Monat umgerechnet (`jaehrlich` ÷ 12 usw.). `einmalig` zählt nicht.
- `KonditionenKurz` und `Hinweis` sieht der Mandant. Nichts Internes hineinschreiben, bestehende Verträge fair beschreiben.

Nur Artefakt:

| Feld | Bedeutung |
|---|---|
| `Person` | bei Paaren: wem der Vertrag gehört |
| `UeberGehalt` | Beitrag läuft über die Gehaltsabrechnung (gesetzliche Krankenkasse, Entgeltumwandlung). Zählt in der Bereichs-Übersicht, aber **nicht** in der Verwendung des Netto |
| `Wert` | heutiger Stand bei Kapital-Verträgen (Guthaben, Depotwert). Startwert der Kurven |
| `MaxBeitrag` | Maximalbeitrag (BU): wird immer neben dem Zahlbeitrag gezeigt |
| `Rentenfaktor` | € Monatsrente je 10.000 € Kapital (langer Topf, aus dem Angebot) |
| `EffektivkostenProzent` | Kosten pro Jahr aus dem Basisinformationsblatt (langer Topf) |
| `RentenArt` | `privat` (Standard), `gefoerdert` (Riester, Altersvorsorgedepot) oder `bav`. Steuert die Abzüge in der Rentenlücke |

### `vergleiche` (nur Artefakt, aus dem Leistungsvergleich-PDF)

Je Vorschlag (`VertragId`) die verglichenen Tarife für „Warum dieser“: `Kriterien` (Liste), `Tarife` (`Variante` guenstig / Preis-Leistung / Top oder freier Text, `Gesellschaft`, `Tarif`, `Beitrag`, `MaxBeitrag`, `Werte`, `Gewaehlt`), `Warum` (zwei bis drei sachliche Sätze).
`Werte` je Kriterium: `2` erfüllt, `1` eingeschränkt, `0` nicht erfüllt, oder ein kurzer Text („50 Mio. €“). In der DB steht laut Entscheidung vom 25.11. nur der empfohlene Tarif, die anderen stehen im verlinkten PDF.

### `annahmen` (nur Artefakt, Startwerte der Regler)

| Feld | Testwert | Bedeutung |
|---|---|---|
| `RenditeProzent` / `RenditeBandbreite` | 5,0 / 2,0 | Rendite vor Kosten pro Jahr. Bandbreite = Rendite minus/plus so viele Punkte |
| `ZinsKurzProzent` / `ZinsKurzBandbreite` | 2,0 / 1,0 | Tagesgeld |
| `InflationProzent` | 2,0 | |
| `KostenMittelProzent` / `KostenLangProzent` | 0,5 / 1,1 | Effektivkosten pro Jahr |
| `Rentenfaktor` | 27,50 | wenn am Vertrag keiner steht |
| `DynamikProzent` | 0 | jährliche Erhöhung der Sparraten |
| `SteuersatzAlterProzent` | 10 | persönlicher Durchschnitts-Steuersatz im Alter (Annahme) |
| `Rentenalter` | 67 | Startwert des Reglers (63 bis 67) |
| `Kinderlos` | true | Pflegeversicherung der Rentner mit Zuschlag (12,95 % statt 12,35 %) |
| `SparerpauschbetragJahr` | 2000 | frei verfügbarer Pauschbetrag (Paar 2.000 €, allein 1.000 €, schon verbraucht 0) |
| `VergleichSparrate` / `VergleichJahre` | 300 / 15 | Startwerte „Kurz oder mittel“ |

### Übrige Listen

| Schlüssel | Quelle | Felder und Regeln |
|---|---|---|
| `aufgaben` | Tabelle `Aufgabe` | `Titel`, `Art`, `Zustaendig`, `Status`, `FaelligAm`, `ErledigtAm`. Nur, was der Mandant sehen darf. `Zustaendig` „Mandant“ steht unter „Bei dir/euch“, „Hugo“ und „Agent“ unter „Bei mir“ |
| `unterlagen` | nur Artefakt | Liste der Dokumente, die nach dem Termin per Mail kommen (`agent/vorlagen/konzept-mail.md`) |
| `termine` | Tabelle `Termin` | `TerminId`, `Beginn`, `Art`, `Ort`, `Status`, `Ergebnisse`. In `Ergebnisse` nur eine mandantentaugliche Kurzfassung |
| `depotstaende` | Tabellen `Depotstand` + `DepotPosition` | `Stichtag`, `Gesamtwert`, `Einzahlungen`, darunter `positionen` (`Bezeichnung`, `ISIN`, `Anteile`, `Wert`, `Anteil`). Positionen werden vom jüngsten Stand gezeigt |
| `neuerungen` | Tabelle `Thema` (nur passende) | `Titel`, `GiltAb`, `Kurzfassung` |
| `fakten` | `agent/fachwissen.md` Abschnitt 9 | je Folien-Kennung (`gesundheit`, `basisrisiken`, `arbeitskraft`, `kurz-mittel`, `rentenluecke`) eine Liste aus `Text` und `Quelle`. Nur geprüfte Werte, nur was zum Mandanten passt |

## So füllt der Agent das Artefakt

1. Bestehende Version lesen (`Mandant.ArtefaktUrl`), sonst diese Vorlage nehmen.
2. Aus der DB lesen: `Mandant`, offene und erreichte `Ziel`e, jüngster `Finanzstatus`, `Vertrag` mit Status aktiv und Vorschlag, `Aufgabe`n, `Termin`e, `Depotstand` mit Positionen, passende `Thema`-Zeilen.
3. Die Felder „nur Artefakt“ ergänzen: `personen` aus dem Profil, `bedarfImAlter`, `vorschlag`, `vergleiche` aus den Vergleichs-PDFs, `annahmen` (Kosten und Rentenfaktor aus dem Angebot), `fakten`, `unterlagen`.
4. Prüfen: Summe der Verwendung = Netto (sonst zeigt die Folie Einkommen „Nicht zugeordnet“). `vorschlag`-Sparraten = Summe der Kapital-Verträge. Zahlen und Aussagen gegen `agent/fachwissen.md`.
5. **Nichts Internes:** keine Kandidaten, Lücken, Leitfragen, Provisionen, keine Gesundheitsangaben. Das gehört ins Briefing im Chat.
6. Nur den Block `const DATEN = { … };` und den `<title>` austauschen, `meta.Testdaten: false` setzen, veröffentlichen (gleiche Adresse), Adresse in `Mandant.ArtefaktUrl`.
7. Für den Termin die passende Startfolie nennen (z. B. `…#einkommen` fürs Konzept) und Folien ausblenden, die noch leer wären (Analyse: meist `uebersicht`, die Bereiche, `kurz-mittel`, `rentenluecke`, `verlauf`).

## Rechenregeln und Annahmen

Grundlage ist `agent/fachwissen.md` Abschnitt 6.1 bis 6.4. Alle Hochrechnungen stehen mit Bandbreite und sichtbaren Annahmen auf der Folie.

### Kaufkraft

Es wird immer erst in Euro des jeweiligen Zeitpunkts (nominal) gerechnet und dann für die Anzeige „In heutiger Kaufkraft“ durch `(1 + Inflation)^Jahre` geteilt. Der Schalter „In Euro von später“ zeigt alles nominal. **Nie gemischt.** Die gesetzliche Rente aus der Renteninformation gilt als heutige Kaufkraft (Annahme: Rentenanpassungen gleichen die Inflation aus).

### Sparplan (alle Hochrechnungen)

Rate am Monatsanfang, Zins monatlich: `Monatszins = (1 + Rendite − Kosten)^(1/12) − 1`. Kapital nach `n` Monaten: `Rate × ((1 + Monatszins)^n − 1) / Monatszins × (1 + Monatszins)`.

### Rentenlücke (Folie 8, erstes Rentenjahr)

| Schritt | Regel | Quelle |
|---|---|---|
| Bedarf | Summe `bedarfImAlter`, netto, heutige Kaufkraft | 6.1 Nr. 1 |
| Gesetzliche Rente | `RenteLautInfo`, **brutto** | 6.1 Nr. 2 |
| Rentenbeginn vor 67 | weniger Beitragsjahre: gerade Linie zwischen `RenteBisherErreicht` und `RenteLautInfo`. Dann Abschlag 0,3 % je Monat (mit 63: 14,4 %). Geht nur mit 35 Versicherungsjahren | §§ 36, 77 SGB VI |
| Kranken-/Pflegeversicherung | minus 12,35 %, kinderlos 12,95 % | 6.1 Nr. 3 |
| Steuer | Rente × Besteuerungsanteil × Steuersatz. Besteuerungsanteil nach Jahr des Rentenbeginns: 2026 84 %, jedes Jahr 0,5 Punkte mehr, 100 % ab 2058 | § 22 EStG |
| Lücke heute | Bedarf − Netto-Rente − Vorsorge, die schon läuft | |
| Vorschlag | Kapital aus dem Sparplan × Rentenfaktor ÷ 10.000 = Monatsrente brutto | 6.1 Nr. 5 |
| Abzüge je `RentenArt` | `privat`: nur der Ertragsanteil ist steuerpflichtig (67: 17 %, 65/66: 18 %, 64: 19 %, 63: 20 %). `gefoerdert`: voll steuerpflichtig. `bav`: voll steuerpflichtig, dazu volle Kranken- und Pflegebeiträge über dem Freibetrag (197,75 €, wächst mit der Inflation) | 6.2 |
| Bandbreite | dieselbe Rechnung mit Rendite minus und plus `RenditeBandbreite` | 6.4 |

„Ganz geschlossen wäre sie mit rund … im Monat“ ist dieselbe Rechnung rückwärts, auf 25 € gerundet.

### Kurz oder mittel (Folie 7)

Gleiche Sparrate und Laufzeit auf beiden Seiten, beides nach Kosten und Steuern (6.4).

- **Kurz:** Tagesgeld, keine Kosten. Zinsen werden jedes Jahr mit 26,375 % versteuert, soweit sie über dem Sparerpauschbetrag liegen.
- **Mittel:** Aktienfonds, Rendite minus `KostenMittelProzent`. Steuer einmal beim Verkauf: `(Gewinn × 70 % − Sparerpauschbetrag) × 26,375 %` (30 % Teilfreistellung).
- Jeder Punkt der Kurve ist der Wert, **wenn man in dem Jahr alles auflöst**. Dadurch passen Kurve und Zahlen zusammen.
- „Eingezahlt“ ist in heutiger Kaufkraft kleiner als Rate × Monate (jede Rate wird zurückgerechnet). Die Summe in Euro steht daneben.

### Vermögensaufbau (Folie 7)

Je Topf Monat für Monat: Start (`Ruecklage` bzw. `Wert` der aktiven Verträge) + Sparrate + Zins bzw. Rendite nach Kosten. Offene Ziele mit Betrag werden **in der Mitte des Zieljahres** entnommen, der Betrag wächst mit der Inflation mit. Reicht das Geld nicht, steht „es fehlen rund …“ und der Punkt ist hohl. Ohne Steuern gerechnet (steht bei den Annahmen).

### Drittel-Regel, Übersicht, Einkommen

- **Drittel-Regel:** Wohnen = `Wohnkosten`. Leben später = Summe der Sparraten. Leben = Netto minus beides (also alles andere, auch Versicherungen und Kredite).
- **Übersicht:** je Bereich die Summe der Monatsbeiträge, heute (aktiv) und mit Vorschlag (aktiv ohne ersetzte, plus Vorschläge). Kapital = Sparraten aus `finanzstatus` bzw. `vorschlag`.
- **Einkommen:** Verwendung des Netto = Verträge im Bereich Einkommen (ohne `UeberGehalt`), Sparraten, `Lebenshaltung`, `Verbindlichkeiten`, `Wohnkosten`, Verträge in Gesundheit, Basisrisiken und Wohnen (ohne `UeberGehalt`). Im Alter fallen Sparraten, Arbeitskraft-Absicherung und Kredite weg, der Rest kommt aus `bedarfImAlter`.

## Animationen (Teams-tauglich)

Alle Bewegungen haben einen klaren Anfang und ein klares Ende (0,45 bis 1,2 Sekunden), nichts läuft dauerhaft: Zahlen zählen hoch · Folien blenden weich ein · Kacheln zoomen auf und zurück · der Zeitstrahl deckt sich von links auf · die Drittel-Balken wandern von der Faustregel zum Ist und zum Vorschlag · das Einkommen fließt von links nach rechts und verwandelt sich in den Bedarf im Alter · Balken wachsen und wandern von „heute“ zu „Vorschlag“ (ein Strich markiert den alten Stand) · die Töpfe füllen sich · Kurven zeichnen sich · die Rentenlücke schließt sich.

## Geprüft am 2026-11-25

Mit Playwright (Chromium), Befehle und Bilder liegen nur im Arbeitsordner der Session, nicht im Repo.

| Prüfung | Ergebnis |
|---|---|
| Alle 16 Folien mit allen Schritten, hell und dunkel, 1920×1080 und Handy 390×844 | Browser-Konsole ohne Fehler und Warnungen, keine Seite scrollt seitlich |
| Fenstergrößen 1920×1080, 1700×900, 1536×864, 1366×768, 1280×720 | jede Folie passt ohne Scrollen auf die Bühne |
| Tastatur, Kacheln, Sprungadressen, Regler, „Zurück zum Vorschlag“, Animationsschalter, Präsentationsmodus, „Bewegung reduzieren“ | alle 31 Prüfpunkte in Ordnung |
| Datei ohne Veröffentlichungs-Gerüst direkt geöffnet | läuft ebenfalls |
| Wenig Daten (nur Analyse, eine Person, ohne Vorschläge) und fast leerer Datensatz | keine Fehler |

Handrechnung gegen die Anzeige (Testdaten, Rentenbeginn 67, Steuersatz 10 %, Rendite 5 %, Kosten 1,1 %, Inflation 2 %):

| Wert | von Hand | Anzeige |
|---|---|---|
| Netto-Rente: 3.200 − 414,40 (12,95 %) − 320,00 (100 % × 10 %) | 2.465,60 € | 2.466 € |
| Lücke heute: 3.400 − 2.465,60 | 934,40 € | 934 € |
| Kapital aus 400 € × 444 Monate bei 3,9 %, in heutiger Kaufkraft | 188.361 € | rund 188.000 € |
| Private Rente: 391.919 € × 27,50 ÷ 10.000 = 1.077,78 €, minus 1,7 % Steuer, ÷ 1,02³⁷ | 509,19 € | rund 510 € (330 € bis 800 €) |
| Lücke mit Vorschlag | 425,21 € | rund 430 € (130 € bis 600 €) |
| Rentenbeginn 63: (520 + 2.680 × 33/37) × 0,856, minus 12,95 % und 10 % | 1.919,46 € | 1.919 € |

## Bekannte Grenzen

- **Paare als ein Haushalt:** ein Geburtsjahr, ein Rentenbeginn, Renten und Einkommen als Summe. Bei unterschiedlichem Alter ist das ungenau.
- **Steuer im Alter** ist ein pauschaler Satz auf den steuerpflichtigen Teil. Grundfreibetrag, andere Einkünfte und Kirchensteuer rechnet das Artefakt nicht. Der Besteuerungsanteil ist nach der Tabelle gerechnet, der feste Freibetrag in Euro nicht.
- **Rentenfaktor** gilt für Rentenbeginn 67. Bei früherem Beginn ist er niedriger, das steht auf der Folie, wird aber nicht gerechnet.
- **Private Rente** steigt im Ruhestand nicht automatisch, der Bedarf schon. Die Lücke gilt für das erste Rentenjahr.
- **Kurz oder mittel:** Vorabpauschale nicht gerechnet (klein, wird angerechnet). Sparerpauschbetrag vereinfacht: beim Tagesgeld jedes Jahr, beim Fonds einmal beim Verkauf.
- **Ziele** werden in der Mitte des Zieljahres entnommen. `Ziel` kennt nur das Jahr.
- **Nebeneinkommen** fehlt im Fluss-Bild (zählt nur in der Drittel-Regel).
- Ein Vertrag, der **ersatzlos wegfallen** soll, lässt sich noch nicht zeigen. „Wohnen“ hat keine Detail-Folie.
- **Referentenansicht** (zweites Fenster nur für Hugo, `docs/10-mandanten-artefakt.md`) ist nicht gebaut. Formulierungshilfen kommen weiter ins Briefing.
- **Schrift:** Es wird die Systemschrift benutzt (auf Windows Segoe UI). Das Bild weicht leicht von den Test-Bildern ab (dort Inter).
- **Vollbild** kann im veröffentlichten Artefakt gesperrt sein. Dann bleibt die Ansicht ohne Kopfzeile, Vollbild geht mit `F11`.
- Am Handy gibt es statt des Fluss-Bilds eine Liste und keine Fortschrittsleiste.

## Offene Fragen an Hugo

1. **Empfehlungsfolie:** bleibt sie, und passt der Wortlaut?
2. **Kopfzeile:** bisher nur die Vornamen und das Drei-Töpfe-Zeichen. Soll dein Name oder ein Logo hinein?
3. **Krankenkasse in der Übersicht:** Der Arbeitnehmeranteil zählt bei „Gesundheit“ mit, damit ein Kassenwechsel sichtbar wird. So gewollt?
4. **Rentenlücke:** private Rente über den Rentenfaktor (lebenslange Rente) gerechnet. Oder lieber als Entnahmeplan über eine feste Zahl von Jahren? Passen die Startwerte (Rendite 5 %, Bandbreite 2 Punkte, Inflation 2 %, Steuersatz 10 %)?
5. **Paare:** zusammen als Haushalt (wie jetzt) oder je Person?
6. **Ziele in heutiger Kaufkraft** (Betrag wächst mit der Inflation mit): passt das zu dem, wie du es im Termin erklärst?
7. **Felder „nur Artefakt“:** Welche sollen in die Datenbank? Kandidaten: `Vertrag.Wert`, `MaxBeitrag`, `Rentenfaktor`, `EffektivkostenProzent`, `RentenArt`, `UeberGehalt`, `Person`, dazu `Finanzstatus.RenteBisherErreicht`, die Aufteilung des Bedarfs und die Sparraten mit Vorschlag. Das wäre ein Schema-Vorschlag (`db/migrations/NNN_*.sql`), noch nicht angelegt.
