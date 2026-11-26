---
name: kfz-vergleich
description: Kfz-Versicherung (Pkw, Motorrad, Anhänger) für einen Mandanten von Hugo im JDC-Maklerportal (icrm.jungdms.de) und im NAFI-KFZ-Rechner vergleichen. Interessent anlegen, Wechselvergleich zum 01.01. rechnen, gespeicherten Vergleich mit nachgelieferten Angaben ändern, Varianten rechnen und das Ergebnis fair gegen den Altvertrag aufbereiten. Immer verwenden, wenn es um Autoversicherung, Motorradversicherung, Kfz-Wechsel, Kfz-Kündigung zum 30.11., Beitragserhöhung in der Kfz-Versicherung, NAFI oder einen Kfz-Tarifvergleich geht, auch wenn das Portal nicht genannt wird.
---

# Kfz-Vergleich über JDC und NAFI

Stand 2026-11-26 · erprobt an echten Fällen (Pkw und Motorrad, Wechsel zum 01.01., Nachberechnung mit nachgelieferten Angaben). Diese Datei ist die **einzige** Anleitung dafür. Neue Erkenntnisse hier eintragen, ohne Mandantendaten.

## 1. Rahmen

| Punkt | Regel |
|---|---|
| Werkzeug | **Claude in Chrome** in Hugos Edge. Der Agent sieht nur Tabs seiner Tab-Gruppe. Zu Beginn `tabs_context_mcp` |
| Login | **Gibt Hugo selbst ein** (JDC, Microsoft). Login- oder Kontoauswahl-Seite: stoppen, Hugo Bescheid geben |
| Darf | Interessent anlegen, Rechner ausfüllen, Vergleich **speichern** (mit Beschreibung) |
| Nur mit Hugos ausdrücklichem OK | **Antrag**, **eVB**, Kündigung über den JDC-Kündigungsservice, Mail an den Mandanten aus dem Portal, PDF/Excel-Download |
| Nie | IBAN, Steuer-ID, SV-Nummer eintragen. Häkchen „Eingabedaten in Kunden-Stammdaten übernehmen“ setzen, solange Annahmen drin sind |
| Nicht in NAFI | Direktversicherer ohne Courtage (z. B. **WGV, HUK24**). Ihren Beitrag aus der letzten Beitragsrechnung nehmen |
| Mandantendaten | Nur im OneDrive-Mandantenordner (`Profil <Name>.md`), nie im Repo |

## 2. Vorher sammeln

Aus **Versicherungsschein / Beitragsrechnung fürs Folgejahr**: Versicherer, SF-Klasse **zum neuen Beginn**, Kasko-Art und Selbstbeteiligung, Bausteine (Schutzbrief, Fahrerschutz, Auslandsschadenschutz, Kfz-Unfall), **Werkstattbindung ja/nein** (z. B. WGV „Kasko SELECT“), Fahrleistung, Abstellort, Fahrerkreis, Beitrag getrennt nach KH, Kasko, Bausteinen.

Aus dem **Fahrzeugschein**: HSN (Feld 2.1), TSN (Feld 2.2, erste 3 Zeichen), Erstzulassung (B), Kennzeichen, Leergewicht (G) und Höchstgeschwindigkeit (T) beim Motorrad, **nächste HU** (überfällig? Hugo melden).

**Beim Mandanten erfragen** (eine Mail mit allem, siehe Abschnitt 9):

| Angabe | Warum | Wenn unbekannt |
|---|---|---|
| Foto Führerschein **Vorder- und Rückseite** | Rückseite zeigt das Datum je Klasse: **B** fürs Auto, **A** fürs Motorrad (nicht A1/A2). Datum mit 17 = begleitetes Fahren | 18. Geburtstag als Annahme |
| Wer fährt noch? Geburtsdaten, wohnen sie im selben Haushalt? | großer Preishebel | „nur Versicherungsnehmer“ rechnen, markieren |
| Kaufpreis, Kaufdatum | Pflichtfeld | Schätzung, markieren |
| Kilometerstand, Fahrleistung pro Jahr **heute** | Pflichtfeld | aus letztem Stand hochrechnen |
| Abstellort **heute** (Garage abschließbar? Carport? Straße?) | Merkmal zur Beitragsberechnung | nachfragen |
| Schäden der letzten 5 Jahre, auch Glas, Wild, Steinschlag | wird abgefragt | „keine“ nur, wenn bestätigt |
| Werkstattbindung okay? | macht günstiger, manche wollen sie nicht (eigene Werkstatt im Umfeld) | beide Varianten zeigen |
| ADAC-Mitglied? | Schutzbrief doppelt? | nachfragen |
| Motorrad: Zulassung auf sie seit, Saison (Winter?), Abstellort | Pflichtfelder | nachfragen |

**Abweichung zum Altvertrag** (z. B. Carport statt Garage, weniger km): Der Mandant muss sie dem Altversicherer melden (AKB K.4), egal ob er wechselt. Sonst gilt rückwirkend der richtige Beitrag, bei Vorsatz kommt eine Vertragsstrafe dazu. Hugo darauf hinweisen.

## 3. JDC: Interessent anlegen (falls neu)

1. Dashboard → Feld **Kundensuche** (über der Kundenliste) → Nachname + Enter. Erst anlegen, wenn kein Treffer.
2. **+ Kunde anlegen**. Status ist automatisch „Interessent“.
3. Felder: Anrede, Briefanrede („Hallo“), Vorname, Nachname, Geburtsdatum (`TT.MM.JJJJ` tippen), Geschlecht, Erwerbstätigkeit (z. B. „Öffentlicher Dienst“), Beruf (Anfang tippen, Vorschlag anklicken; fehlt der Beruf, den nächstliegenden nehmen und Hugo sagen), Straße, Haus-Nr., PLZ, Ort (wird nicht automatisch gefüllt), E-Mail.
4. **Kunde anlegen** → „Haushalts-Nr. hinterlegen?“ → **Nein**.

## 4. Von JDC in NAFI

- Kundenliste (nach Suche) → in der Zeile das **Taschenrechner-Symbol** („Rechner & Beratung“) → **KFZ-Rechner**. NAFI öffnet sich per Single Sign-on in einem **neuen Tab**, der Kunde ist schon gewählt. Danach `tabs_context_mcp` für die neue Tab-ID.
- Die NAFI-Sitzung läuft **16 Stunden**. Meldung „Sitzungskennung ungültig oder abgelaufen“: einfach aus JDC neu öffnen, der JDC-Login gilt meist weiter.
- NAFI-Startseite: „Pkw in Eigenverwendung“ oder „Alle Fahrzeugarten“ (Motorrad). Rechts „Belegübersicht zum aktuellen Kunden“ mit gespeicherten Vergleichen.

## 5. Pkw neu rechnen

Linke Leiste: Start → Fahrzeug → Merkmale → Versicherungsnehmer → Fahrer → Deckung → SF → Anforderungen → Ergebnis. Unten rechts **Weiter**, fehlende Pflichtfelder werden rot. Man kann links direkt zu jedem Schritt springen.

| Schritt | Eingaben | Stolpersteine |
|---|---|---|
| **Start** | „Tarif/Versicherer wechseln“, Häkchen **„zum 01. Januar wechseln“**, Zulassung normal | Status, Halter, PLZ kommen aus JDC |
| **Fahrzeug** | HSN, TSN → Modell, Leistung, Typklassen, Neuwert erscheinen. Kennzeichen (3 Felder), Erstzulassung, Zulassung auf Halter, Erstbesitzer, **Kaufpreis**, Sonderausstattung | Kennzeichen und Kaufpreis sind Pflicht. Das **?** öffnet rechts eine Hilfe und verschiebt das Formular: danach neuer Screenshot |
| **Merkmale** | Fahrleistung, km-Stand, Nutzung EU/CH/NO/UK, Finanzierung, Nutzung, Fahrtzweck (z. B. „Priv.Nutzung – Weg zur Arbeit“), Vorsteuer, **nächtlicher Abstellplatz**, abgeschlossen / öffentlich | Abstellplatz ist ein Auswahlfeld, `form_input` geht. Optionen u. a.: Einzel-/Doppelgarage, Tief-/Sammelgarage, Carport auf eigenem Grundstück, Carport (andere), Straße |
| **Versicherungsnehmer** | Anrede, Familienstand, Nationalität, **Datum Fahrerlaubnis (Klasse B)**, Wohneigentum, Branche, Firma | Keine passende Branche: „Andere – <Bereich>“ (z. B. „Andere – Gesundheit“) |
| **Fahrer** | Fahrerkreis: nur VN / festgelegt / **beliebig mit Altersgrenzen** / beliebig | „mit Altersgrenzen“: Geburtsdatum jüngster **und** ältester Fahrer. **„Alle Fahrer sind Familienangehörige in häuslicher Gemeinschaft“ ist mit Ja vorbelegt**: leben Partner oder Geschwister woanders, auf **Nein**. „Kürzester Führerscheinbesitz“ ist Pflicht (unbekannt: Annahme, markieren). Datum mit 17 setzt „begleitetes Fahren“ automatisch auf Ja |
| **Deckung** | Haftpflicht Höchstdeckung, Kasko-Art, Selbstbehalt, Zahlweise | Selbstbehalt-**Schieberegler** reagiert nur auf **Ziehen** mit der Maus |
| **SF** | Vorversicherer, dort seit, gekündigt, weitere Fahrzeuge, SF-Klasse **manuell zum Vertragsbeginn**, Sondereinstufung, **Schäden** (Jahr + Sparte) | SF-Auswahl ist ein Suchfeld: anklicken, „SF 10“ tippen, Enter. „Schaden hinzufügen“ → Jahr tippen, Sparte wählen (Haftpflicht, Vollkasko, Teilkasko). Teilkasko-Schäden kosten keine SF-Klasse, werden aber abgefragt |
| **Anforderungen** | Vorbelegt: Wildschaden mind. Nutztiere, Fahrerschutz, grobe Fahrlässigkeit. **Bausteine des Altvertrags auf „Ja“** (Schutzbrief, Auslandsschadenschutz). Kfz-Unfall „nicht wichtig“ | Auswahlfelder hier: anklicken, **Escape**, dann **Pfeil runter**. Mausklick auf die Option greift nicht |
| **Ergebnis** | Rechenlauf ca. 10–15 s | siehe Abschnitt 7 |

## 5a. Motorrad (Wagnis 003)

| Schritt | Abweichung zum Pkw |
|---|---|
| Einstieg | NAFI-Startseite → **Alle Fahrzeugarten** → „Krafträder/Roller“ → „003 / Krafträder und -roller mit mehr als 125 ccm oder mehr als 11 kW“ → Weiter → „neue Berechnung?“ **Ja** → „Eingabedaten übernehmen?“ **Ja** |
| Versicherungsnehmer | Anrede, Familienstand, Führerscheindatum und Branche **neu eintragen**. Führerscheindatum = **Klasse A** |
| Fahrzeug | „Hersteller des Krades“ mit HSN wählen, TSN in „Typschlüsselcode“ + Lupe → kW, ccm, Modell. Dialog „Fahrzeugsuche (Krad)“ schließen. Dazu Krad-Typ, Kraftstoff (Escape, Pfeil runter = Benzin), Leergewicht, Höchstgeschwindigkeit, ABS, **Neuwert** und **Kaufpreis** (Pflicht) |
| Anforderungen | eigene Liste (Auslandsschadenschutz, Schutzbrief, Pannenhilfe, Rabattschutz, Wertminderung, Bekleidungsschutz). Kein Fahrerschutz |

Erfahrung: Bei Motorrädern mit hoher SF-Klasse liegen die günstigen Tarife oft nur wenige Euro auseinander. Erst rechnen, wenn der Bestand deutlich über ca. 150 € im Jahr liegt oder Leistungen fehlen. Saisonfahrer: Fahrleistung realistisch angeben (spart beim Altversicherer).

## 6. Gespeicherten Vergleich ändern (Angaben nachgeliefert)

1. NAFI aus JDC öffnen (Abschnitt 4).
2. Startseite → „Belegübersicht zum aktuellen Kunden“ → **Vergleiche** → Zeile **anklicken** (das ⋮-Menü hat nur Ausdruck/Löschen).
3. „Vergleich im Detail“ → **Vergleich laden**. Alle Eingaben sind wieder da.
4. Links zum betroffenen Schritt springen, ändern, dann **Ergebnis**.
5. Auf der Ergebnisseite links „Details ändern“ → Schritt wählen, um weitere Varianten zu rechnen.
6. Speichern legt einen **neuen** Vergleich an, der alte bleibt.

## 7. Ergebnis lesen

- Reiter: **„Alle Anforderungen erfüllt“** (fairer Vergleich), „Alle Tarife“ (auch unter 100 %), „ohne Prämien“.
- Links **Tariffilter → Werkstattwahl**: „Freie Werkstattwahl“ oder „Werkstattbindung“ (`form_input` geht). Symbol Schraubenschlüssel = Werkstattbindung, ⚠ = Hinweis (anklicken, z. B. Allianz: Bonitätsprüfung, Angebot befristet).
- Oben **Tarif-Details**: Tabelle aller Tarife mit Gesamt, KH, Kasko, Kosten. Gut zum Ablesen per Screenshot. Schließen mit dem × oben rechts im Dialog.
- **Prozent-Plakette** neben dem Preis anklicken: zeigt, welche Anforderung fehlt. Fehlt nur etwas Kleines (oft der Auslandsschadenschutz), den Tarif als günstigere Option nennen.
- `get_page_text` **nicht** verwenden (über 40.000 Tokens). Screenshots, `find`, `read_page` auf die `ref` eines Auswahlfelds.

## 8. Speichern und Varianten

- Ergebnisseite oben **Vergleich speichern** → Beschreibung → Diskette oben rechts. Häkchen „Stammdaten übernehmen“ leer lassen.
- Beschreibung nach Muster: `Wechsel zum 01.01.JJJJ (Claude, TT.MM.): <was eingearbeitet>. Annahmen: <Liste> - vor Antrag pruefen`. Umlaute vermeiden.
- **Varianten** (z. B. 1:1 mit den Merkmalen des Altvertrags, um nur den Preis zu vergleichen) als eigenen Vergleich speichern und kennzeichnen: `NUR VERGLEICHSRECHNUNG ... NICHT fuer Antrag verwenden`. Ein Antrag braucht immer die **tatsächlichen** Angaben.
- Erfahrung: Der Abstellort (Garage oder Carport) verändert die Beiträge vieler Tarife kaum, Fahrerkreis und Werkstattbindung deutlich.

## 9. Für Hugo aufbereiten

1. **Bestand fair machen:** Beitrag Altvertrag fürs neue Jahr, überflüssige Bausteine herausrechnen (Kfz-Unfall ist neben Fahrerschutz, privater Unfallversicherung und BU fast immer überflüssig). Weichen Merkmale vom Altvertrag ab, sagen, dass der Altbeitrag nach der Meldung noch steigt oder sinkt.
2. **Zwei Listen:** günstigste Tarife **ohne** und **mit** Werkstattbindung, je 3–5, die alle Anforderungen erfüllen. Fair ist nur ohne gegen ohne. Dazu günstigere Tarife mit kleiner Lücke (Plakette).
3. **Annahmen** sichtbar auflisten und sagen, wie stark sie den Preis bewegen können.
4. **Rabatte beim Altversicherer** prüfen (z. B. WGV-Mehrvertragsbonus auf Pkw-KH/-Kasko).
5. **Fristen:** Kündigung muss am **30.11.** beim Versicherer **eingegangen** sein (AKB G.2.1). Der **JDC-Kündigungsservice** braucht früher (Hinweis auf dem JDC-Dashboard, 2026: 27.11., 14:00). Beitragserhöhung: Sonderkündigung 1 Monat ab Zugang (§ 40 VVG). Regel: **erst neuer Vertrag, dann kündigen**.
6. **Nebenbefunde:** überfällige HU (Bußgeld und erweiterte HU, siehe `agent/fachwissen.md` 9.4 im Repo hf-crm), Anhänger (§ 19 StVG), beförderte Tiere (AKB A.1.5.5), Meldepflicht bei geänderten Merkmalen.
7. Rückfragen an den Mandanten nur als **Outlook-Entwurf**, Du-Form, eine Mail mit allem, mit Frist.

## 10. Ablage

- Ergebnis und Annahmen ins **Profil des Mandanten** im OneDrive (`Dokumente/VVO Finance/Mandanten/<Vorname Nachname>/Profil <Vorname Nachname>.md`), Abschnitt „Was erklärt wurde“ und „Offene Aufgaben“.
- Dateien über 1 MB zieht Hugo selbst in den Ordner (Connector-Grenze).
- Neue Portal-Erkenntnisse in **diese Datei**, Verlauf in `docs/LOG.md` (ohne Mandantendaten).
