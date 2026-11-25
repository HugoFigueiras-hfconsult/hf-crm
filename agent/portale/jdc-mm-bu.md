# JDC → Morgen & Morgen: BU-Vergleich rechnen

Stand 2026-11-25 · am ersten echten Fall erprobt (Gegenangebot eines anderen Beraters fair nachgerechnet) · keine Mandantendaten

## 1. Voraussetzungen und Grenzen

- Werkzeug: **Claude in Chrome** in Hugos Edge, Tab-Gruppe mit JDC iCRM. Login macht Hugo (wie `jdc-nafi-kfz.md` Abschnitt 1).
- Der Mandant ist in JDC angelegt. M&M übernimmt Name und Geburtsdatum aus JDC.
- **Kein Antrag** aus M&M heraus („Jetzt beantragen“) ohne Hugos ausdrückliches Ja.
- Gesundheitsangaben gehören nicht in den Rechner. Die Gesundheitsprüfung macht der Versicherer, bei Unklarheiten erst eine anonyme Risikovoranfrage.

## 2. Was vorher feststehen muss

| Angabe | Hinweis |
|---|---|
| Beruf genau so, wie er im Arbeitsvertrag steht | Bestimmt die Berufsgruppe und damit den Preis |
| Anteil Bürotätigkeit in % | wichtig für die Einstufung |
| Raucher ja/nein | Raucher zahlen deutlich mehr |
| Versicherungsbeginn | meist der nächste Monatserste |
| Versicherungs- und Leistungsendalter | in der Regel **67** (`agent/fachwissen.md` 9.1) |
| Monatliche BU-Rente | nach Netto. **Alle** Angebote im Vergleich mit derselben Rente |
| Gegenangebote | Rente, Endalter, Zahl- und Höchstbeitrag, Rabatte (z. B. Mitgliedsrabatte) notieren |

## 3. Weg zum Rechner

1. JDC iCRM → Kundenliste → Kunde öffnen.
2. Symbol **„Rechner & Beratung“** in der Kundenkopfzeile.
3. **„Leben-, Kranken-, SHU-Rechner“** → **Morgen & Morgen**. M&M Office öffnet sich in einem neuen Tab (`mumoffice.morgenundmorgen.de`), nach dem Öffnen `tabs_context_mcp` aufrufen.

## 4. Rechnen

1. Gibt es schon eine Berechnung: in der Liste der Berechnungen **duplizieren** und die Kopie bearbeiten. So bleibt das Original erhalten.
2. Reiter **Vorgaben, Person:** Beruf eintippen und aus der Vorschlagsliste wählen. Prozent Bürotätigkeit setzen.
3. Reiter **Tarifvorgaben:** Versicherungsbeginn, Versicherungsendalter, Leistungsendalter, monatliche Rente. Jedes Feld per Dreifachklick markieren, tippen, mit Tab verlassen.
4. Filter nach Bedarf, z. B. Nachversicherungsgarantie.
5. **Berechnen.** Ergebnis: Liste aller Tarife mit Zahlbeitrag und Höchstbeitrag (im Testfall rund 135 Tarife von 29 Anbietern).

**Stolpersteine:**
- Die **Anbietersuche** im Ergebnis kann die Liste auf 0 Treffer filtern, auch nach dem Leeren. Dann zurück zu den Vorgaben und neu berechnen.
- Fehlt ein Anbieter, steht der Grund in der Liste der **nicht berechneten Tarife** (Berechnungsprotokoll mit Filterfeld).
- Rabatte wie Mitgliedsrabatte rechnet M&M nicht. Im Ergebnis darauf hinweisen.
- `get_page_text` funktioniert in M&M gut (anders als in NAFI) und liefert Ergebnisliste und Vergleich als Text.

## 5. Vergleich und PDF

1. In der Ergebnisliste die Tarife über die Kästchen links auswählen. **Höchstens 5** kommen in den Vergleich, weitere werden ignoriert.
2. **Vergleich** öffnen. Ansicht „Leistungskriterien“ zeigt alle Merkmale, `get_page_text` liest sie vollständig.
3. **PDF erzeugen** öffnet einen neuen Tab mit der Druckansicht (`/app/api/Folder/PrintPage?id=…&viewType=ALL`). Der Druckdialog des Browsers lässt sich nicht bedienen.
4. Download stattdessen im Druck-Tab per `javascript_tool`: die Druck-URL mit `fetch(…, {credentials: 'include'})` laden, als Blob über einen Link mit `download`-Attribut speichern. Die Datei landet in Hugos Downloads. Hugo kurz sagen, dass der Download so gelaufen ist.
5. Ablage: PDF in den Mandantenordner `Unterlagen Konzept`. Über 1 MB oder als Binärdatei: Hugo zieht sie selbst hinein (M365-Connector-Grenze).

## 6. Ergebnis aufbereiten

- Tabelle: Anbieter und Tarif, Rente, Endalter, **Zahlbeitrag und Höchstbeitrag**, Quelle (M&M mit Datum, Angebot des Mitbewerbers).
- Leistungsmerkmale, die für den Mandanten zählen: volle Rente ab 50 %, abstrakte Verweisung, befristetes Anerkenntnis, Verzicht auf Beitragsanpassung nach § 163 VVG, Kräfteverfall, Beitragsfreistellung, Nachversicherung, Laufzeitende (Tarife enden teils an unterschiedlichen Daten).
- Sachlich bewerten (`agent/fachwissen.md` Abschnitt 1), Gegenangebote fair darstellen, Unterschiede in Rente oder Endalter immer offen nennen.
- Prüfung als Markdown in den Mandantenordner, Fehlaussagen aus Transkripten mit Quelle (`agent/fachwissen.md` Abschnitt 10).
