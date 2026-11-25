# Portal-Anleitung: JDC iCRM + NAFI-KFZ (Kfz-Vergleich)

Stand 2026-11-25 · **Am ersten echten Fall erprobt** (Pkw, Tarifwechsel zum 01.01.) · Keine Mandantendaten in dieser Datei.

Wie der Agent im JDC-Maklerportal einen Interessenten anlegt und im Kfz-Vergleichsrechner (NAFI) einen Wechselvergleich rechnet. Gilt für Claude in Chrome (Browser-Erweiterung in Hugos Edge).

## 1. Voraussetzungen und Grenzen

| Punkt | Regel |
|---|---|
| Zugang | Claude in Chrome in Hugos **Edge**. Hugo öffnet JDC (`icrm.jungdms.de`) und zieht den Tab in die Tab-Gruppe des Agenten. Der Agent sieht nur Tabs in seiner Gruppe |
| Login | **Gibt Hugo selbst ein** (JDC, Microsoft, GitHub). Erscheint eine Login- oder Kontoauswahl-Seite: stoppen, Hugo Bescheid geben, mit anderem weitermachen |
| NAFI | Öffnet sich aus JDC per Single Sign-on in einem neuen Tab, der Kunde ist dort schon ausgewählt. Sitzung läuft 16 h |
| Darf | Interessent anlegen, Rechner ausfüllen, Vergleich **speichern** (mit Beschreibung) |
| Darf nicht ohne Hugos ausdrückliches OK | **Antrag**, **eVB** anfordern, Kündigung über den JDC-Kündigungsservice, E-Mail an den Mandanten aus dem Portal, PDF/Excel herunterladen |
| Nie | IBAN/Bankdaten, Steuer-ID, Sozialversicherungsnummer eintragen. Häkchen „Eingabedaten in Kunden-Stammdaten übernehmen“, solange geschätzte Werte drin sind |
| Nicht im Rechner | Direktversicherer ohne Maklercourtage (z. B. **WGV, HUK24**). Bestandsbeitrag beim Direktversicherer aus der letzten Beitragsrechnung nehmen, HUK24 nur auf Hugos Wunsch separat |

## 2. Daten, die vor dem Start vorliegen sollten

Aus **Versicherungsschein / Beitragsrechnung**: Versicherer, Vertragsablauf, SF-Klasse **zum neuen Versicherungsbeginn** (steht auf der Beitragsrechnung fürs Folgejahr), Kasko-Art und Selbstbeteiligung, Bausteine (Schutzbrief, Fahrerschutz, Auslandsschadenschutz, Kfz-Unfall), Fahrleistung, Abstellort, Nutzung, jüngster Fahrer, Typ-/Regionalklassen, Beitrag.

Aus dem **Fahrzeugschein** (Teil I): HSN (Feld 2.1), TSN (Feld 2.2, erste 3 Zeichen), Erstzulassung (Feld B), Kennzeichen. Ein Schein vom Vorbesitzer reicht für HSN/TSN/EZ.

**Beim Mandanten erfragen** (fehlt meist, NAFI verlangt es):

| Feld | Warum | Wenn unbekannt |
|---|---|---|
| Kaufpreis | Pflichtfeld, beeinflusst 19 Konzerne | Schätzung eintragen und **als Annahme markieren** |
| Datum Führerschein | Pflichtfeld | 18. Geburtstag als Annahme |
| Fahrerkreis (wer fährt noch mit, Geburtsdaten) | großer Preishebel | „nur Versicherungsnehmer“ rechnen und markieren |
| Kilometerstand | Pflichtfeld | aus letztem Stand + Fahrleistung hochrechnen |
| Finanzierung, Garage abschließbar | Pflichtfelder | plausible Annahme, markieren |
| ADAC-Mitglied? | Schutzbrief doppelt? | nachfragen |

## 3. JDC iCRM: Interessent anlegen

1. Dashboard → Feld **Kundensuche** (rechts über der Kundenliste) → Nachname + Enter. Erst anlegen, wenn kein Treffer.
2. Button **+ Kunde anlegen**. Kundenstatus ist automatisch **Interessent** (Maklermandat kommt erst bei der Unterschrift).
3. Felder: Anrede*, Briefanrede (Hugo: „Hallo“), Vorname*, Nachname*, Geburtsdatum (tippen `TT.MM.JJJJ`), Geschlecht, Erwerbstätigkeit (Auswahl, z. B. „Öffentlicher Dienst“), Beruf (Autovervollständigung: Anfang tippen, Vorschlag anklicken), Straße, Haus-Nr., PLZ, Ort (wird **nicht** automatisch gefüllt), E-Mail privat.
4. **Kunde anlegen** → Rückfrage „Haushalts-Nr. hinterlegen?“ → **Nein** (Hugo legt Haushalte selbst an).
5. Die Berufsliste ist nicht vollständig (neuere Berufsbezeichnungen fehlen teils). Dann den nächstliegenden Eintrag wählen und Hugo im Ergebnis darauf hinweisen.

## 4. Von JDC in den Rechner

Kundendetail → **Taschenrechner-Symbol** (erstes Symbol oben rechts, „Rechner & Beratung“) → **KFZ-Rechner** → neuer Tab „NAFI-KFZ“ mit dem Kunden oben rechts → **Pkw in Eigenverwendung**.

Weitere Rechner im selben Menü: SHU, Leben/Kranken, KV-Zusatz, GKV, BU-/Pflege-/Renten-Lückenrechner u. a. (noch nicht erprobt).

## 5. NAFI-KFZ: Schritt für Schritt

Linke Leiste: Start → Fahrzeug → Merkmale → Versicherungsnehmer → Fahrer → Deckung → SF → Anforderungen → Ergebnis. Jeweils unten rechts **Weiter**. Fehlende Pflichtfelder werden beim Weiter rot markiert.

| Schritt | Eingaben | Stolpersteine |
|---|---|---|
| **Start** | „Tarif/Versicherer wechseln“, Häkchen **„zum 01. Januar wechseln“**, Zulassung normal. Status, Halter, PLZ kommen aus JDC | Status kommt aus der JDC-Erwerbstätigkeit |
| **Fahrzeug** | HSN, TSN → NAFI zeigt Modell, Leistung, **Typklassen Vorjahr/neues Jahr**, Neuwert. Kennzeichen (3 Felder), Erstzulassung, Zulassung auf Halter, Erstbesitzer, **Kaufpreis**, Sonderausstattung | Kennzeichen und Kaufpreis sind Pflicht. Klick aufs **?** öffnet rechts eine Hilfe und **verschiebt das Formular**: danach neuen Screenshot machen |
| **Merkmale** | Fahrleistung, km-Stand, Nutzung nur EU/CH/NO/UK, Finanzierung, Nutzung, Fahrtzweck (z. B. „Priv.Nutzung – Weg zur Arbeit“), Vorsteuer, Abstellplatz, abgeschlossen | – |
| **Versicherungsnehmer** | Anrede, Familienstand, Nationalität, Führerscheindatum, Wohneigentum, Branche, Firma | Passt keine Branche, „Andere – <Bereich>“ wählen (z. B. „Andere – Gesundheit“) |
| **Fahrer** | Fahrerkreis: nur VN / festgelegt / beliebig mit Altersgrenzen / beliebig. VZR-Punkte, weiterer Pkw | „mit Altersgrenzen“ braucht Geburtsdatum des jüngsten **und** ältesten Fahrers |
| **Deckung** | Haftpflicht Höchstdeckung, Kasko-Art, **Selbstbehalt-Schieberegler**, Zahlweise, Bankeinzug | Regler reagiert nicht auf Formular-Eingabe, nur auf **Ziehen** mit der Maus |
| **SF** | Vorversicherer, dort seit, gekündigt, Wechsel in 3 Jahren, weitere Fahrzeuge, SF-Klasse **manuell zum Vertragsbeginn**, Sondereinstufung, Schäden | SF-Auswahl ist ein Suchfeld: anklicken, „SF 10“ tippen, Enter |
| **Anforderungen** | Vorbelegt: Wildschaden mind. Nutztiere, Fahrerschutz Ja, grobe Fahrlässigkeit. Für einen fairen Vergleich die Bausteine des Altvertrags auf „Ja“ (z. B. Schutzbrief, Auslandsschadenschutz). Kfz-Unfall „nicht wichtig“ | Auswahlfelder: anklicken, **Escape**, dann **Pfeil runter**. Ein Mausklick auf die Option greift nicht |
| **Ergebnis** | Reiter „Alle Anforderungen erfüllt“ / „Alle Tarife“ / „ohne Prämien“. **Tarif-Details**: Gesamt, KH, Kasko, Kosten je Tarif. Symbole: Schraubenschlüssel = Werkstattbindung, ⚠ = Hinweis anklicken | – |

**Vergleich speichern** (Ergebnisseite oben) → Beschreibung eintragen, z. B. „Wechsel zum 01.01.JJJJ (Claude, vorläufig): Kaufpreis und Führerschein geschätzt, Fahrerkreis nur VN – vor Antrag prüfen“ → **Speichern**. Das Häkchen für die Stammdaten bleibt leer.

## 6. Ergebnis aufbereiten (für Hugo)

1. **Bestand fair machen**: Beitrag Altvertrag fürs neue Jahr laut Beitragsrechnung, getrennt nach KH, Kasko und Bausteinen. Überflüssige Bausteine herausrechnen (Kfz-Unfall laut Verbraucherzentrale „fast immer überflüssig“, wenn Fahrerschutz oder private Unfall/BU besteht).
2. **Zwei Listen**: günstigste Tarife **mit** und **ohne** Werkstattbindung, jeweils die besten 3 bis 5 Tarife, die alle Anforderungen erfüllen.
3. **Hinweise je Tarif** übernehmen (z. B. Allianz: Angebot 14 Tage gültig, Annahme nach Bonitätsprüfung).
4. **Annahmen** sichtbar auflisten: Was geschätzt ist und wie stark es den Preis bewegen kann.
5. **Mehrvertrags- und Bündelrabatte** beim Altversicherer prüfen (z. B. WGV: Kundenstatus ab 3 Produkten 5 % auf Pkw-KH und -Kasko). Bleiben andere Verträge dort, bleibt der Status meist erhalten.
6. **Fristen**: ordentliche Kündigung muss am **30.11.** beim Versicherer **eingegangen** sein (AKB G.2.1). Der **JDC-Kündigungsservice** braucht für den 30.11. einen früheren Eingang (Hinweis auf dem JDC-Dashboard, 2026: 27.11., 14:00 Uhr). Sonderkündigung bei Beitragserhöhung: 1 Monat ab Zugang der Mitteilung (§ 40 VVG).
7. Regel bleibt: **erst neuer Vertrag, dann kündigen**.

## 7. Technische Tipps für den Agenten

- NAFI lädt alle Schritte als eine lange Seite mit versteckten Feldern. **`get_page_text` nicht verwenden** (über 40.000 Tokens). Besser: Screenshot, `find` mit genauer Beschreibung, `read_page` nur auf die `ref` eines Auswahlfelds (zeigt alle Optionen).
- `form_input` funktioniert bei normalen Textfeldern und Auswahlfeldern in JDC und meist auch in NAFI. Bei NAFI-Reglern und Suchfeldern **nicht** (siehe Tabelle oben).
- Nach jedem Klick, der Inhalte ein- oder ausblendet, neuen Screenshot machen, bevor nach Koordinaten geklickt wird.
- Rechenlauf dauert ca. 10 s, „Tarifbausteine ändern“ ca. 15 s.

## 8. Ablage

- OneDrive (Geschäftskonto `hf-consult.de`): `Dokumente/VVO Finance/Mandanten/<Vorname Nachname>/` mit Unterordnern `Dokumente` und `Konzept` (Hugos bestehende Struktur).
- Der Microsoft-365-Connector lädt nur Dateien **bis 1 MB** hoch. Größere Dateien (Teams-Transkripte als .docx haben schnell 2 MB, fast nur durch hunderte identische Profilbilder) zieht **Hugo** per Drag-and-drop in den geöffneten OneDrive-Ordner. Über OneDrive im Browser kann der Agent nicht hochladen: „Dateien hochladen“ öffnet den Windows-Dateidialog, den Claude in Chrome nicht bedienen kann. Große Dateien als Base64 durch den Connector zu schicken, ist zu fehleranfällig.
- Teams-Transkripte liegen im **VVO-Tenant**, nicht im `hf-consult.de`-Tenant. Der Agent kommt nicht dran, Hugo exportiert sie als .docx.
