# Fachwissen für den Agenten (statt VVO-Leitfaden)

Stand 2026-11-25 · An Primärquellen geprüft, keine Rechts- oder Steuerberatung · **Jährlich prüfen:** Januar (Rechengrößen, Beitragssätze), Juli (Rentenanpassung), bei neuen Gesetzen.

**Warum es diese Datei gibt:** Die VVO-Leitfäden („Analysegespräch“ V1 2024, „Beratungsgespräch“ Stand 2018) sind **verkaufsgetrieben** und teils **veraltet oder falsch** (Hugo, 2026-11-25). Der Agent nutzt sie höchstens als grobe Gliederung. Inhalte, Zahlen und Formulierungen kommen aus dieser Datei bzw. aus Primärquellen. Die Leitfäden selbst liegen nicht im Repo (VVO-intern).

---

## 1. Sprache: sachlich statt verkaufsgetrieben

| Muster im Leitfaden | So macht es der Agent |
|---|---|
| Zustimmungsfragen („klasse, oder?“, „das ist doch genial?“, „Mandant hat 3x zugestimmt“) | Sachliche Aussage, dann offene Frage: „Was ist dir dabei wichtig?“ |
| Etiketten und Superlative („Premium-Anbieter“, „Bestnoten“, „Marktführer“, „enorm“) | Konkrete Kriterien: Bedingungen, Beitrag, Beitragsstabilität. Ratings nur mit Name und Datum |
| Angst-Geschichten und alte Statistiken („Zeitreise“, „Rentner unter 900 €“) | Die eigenen Zahlen des Mandanten aus der Renteninformation |
| „Vermögensvorteil von über 200.000 €“ | Hochrechnung **mit Annahmen und Bandbreite**. Erklären, woher der Unterschied kommt (Kosten, Steuern, Rendite-Annahme) |
| Bestehende Verträge schlechtreden, Präsentation „vom Guten zum Schlechten“ | Fair bewerten: Vorteile alter Verträge nennen (Abschnitt 6.3), Kosten eines Wechsels nennen |
| „Abschluss heute“, Personalausweis zücken lassen, Einwandbehandlung | Bedenkzeit ist normal. Fragen klärt die Fragerunde (Hugos Weg) |
| „vor / nach Optimierung“ | Im eigenen Artefakt und in Mails: „heute / Vorschlag“ |

Ton bleibt Hugos Ton: Du, locker, ehrlich, kein Druck (`docs/09-neumandant.md`, „Hugos Beratungsstil“).

---

## 2. Zahlen 2026: Sozialversicherung

| Wert | 2026 | Quelle |
|---|---|---|
| Beitragssätze gesamt | RV 18,6 % · AV 2,6 % · KV 14,6 % + Zusatzbeitrag (Ø 2,9 %) · PV 3,6 % (kinderlos ab 23: 4,2 %, ab dem 2. Kind unter 25 je 0,25 Punkte weniger) | [GKV-Spitzenverband](https://www.gkv-spitzenverband.de/media/dokumente/presse/zahlen_und_grafiken/20260101_Faktenblatt_Rechengroessen_Beitragsrecht.pdf), [BMG](https://www.bundesgesundheitsministerium.de/beitraege) |
| Anteil Arbeitnehmer | je die Hälfte, also RV 9,3 % · AV 1,3 % · KV 7,3 % + halber Zusatzbeitrag · PV 1,8 % (+ 0,6 % Kinderlosenzuschlag allein). Sachsen: PV-Anteil abweichend | ebd. |
| Beitragsbemessungsgrenze RV/AV | 8.450 € im Monat | [SVBezGrV 2026](https://www.gesetze-im-internet.de/svbezgrv_2026/BJNR1160A0025.html) |
| Beitragsbemessungsgrenze KV/PV | 5.812,50 € im Monat | [BMG](https://www.bundesgesundheitsministerium.de/beitraege) |
| Versicherungspflichtgrenze KV (ab da PKV möglich) | 6.450 € im Monat (77.400 € im Jahr) | [Bundesregierung](https://www.bundesregierung.de/breg-de/aktuelles/beitragsgemessungsgrenzen-2386514) |
| Bezugsgröße | 3.955 € im Monat | SVBezGrV 2026 |

---

## 3. Gesundheit

- Die Leistungen der gesetzlichen Kassen sind zum größten Teil gesetzlich vorgegeben. Unterschiede: **Zusatzbeitrag**, Zusatzleistungen, Bonusprogramme, Service.
- **Ersparnis richtig rechnen:** Arbeitnehmer zahlen nur die **Hälfte** des Zusatzbeitrags, die andere Hälfte trägt der Arbeitgeber ([§ 249 SGB V](https://www.gesetze-im-internet.de/sgb_5/__249.html)). Ersparnis = halbe Differenz der Zusatzbeiträge × beitragspflichtiges Einkommen (höchstens bis zur Beitragsbemessungsgrenze). Zusatzbeiträge ändern sich jedes Jahr, deshalb **keine** lebenslange Zinseszins-Hochrechnung als „Vermögensvorteil“.
- **Wechsel:** 12 Monate Bindung, Sonderkündigungsrecht bei Erhöhung des Zusatzbeitrags ([§ 175 Abs. 4 SGB V](https://www.gesetze-im-internet.de/sgb_5/__175.html)). Vor einem Vergleich nach dem letzten Wechseldatum fragen.
- Leitfaden-Fehler: „Einheitsbeitragssatz 14,6 %“ → richtig ist 14,6 % allgemeiner Beitragssatz **plus** kassenindividueller Zusatzbeitrag.

---

## 4. Basisrisiken

- **Privathaftpflicht:** wichtige Kriterien sind Forderungsausfalldeckung und Mitversicherung deliktunfähiger Kinder. Kinder unter 7 Jahren haften nicht, im Straßenverkehr unter 10 Jahren ([§ 828 BGB](https://www.gesetze-im-internet.de/bgb/__828.html)). Das Beispiel im Leitfaden stimmt hier inhaltlich.
- Deckungssummen und Leistungsmerkmale aus dem Tarifvergleich nennen, nicht als Verkaufsargument („zehnfache Summe“).
- Tiere (Hund, Pferd) braucht eine eigene Tierhalterhaftpflicht, siehe `agent/vorlagen/unterlagen-mail.md`.

---

## 5. Einkommen (Arbeitskraft)

**Was der Staat leistet:**

| Fall | Leistung | Quelle |
|---|---|---|
| Krank, Arbeitnehmer | 6 Wochen Entgeltfortzahlung, danach Krankengeld: 70 % vom Brutto, höchstens 90 % vom Netto, höchstens 135,63 € pro Tag (2026), insgesamt höchstens 78 Wochen in 3 Jahren für dieselbe Krankheit (inkl. Entgeltfortzahlung) | [§ 3 EntgFG](https://www.gesetze-im-internet.de/entgfg/__3.html), [§ 47](https://www.gesetze-im-internet.de/sgb_5/__47.html), [§ 48 SGB V](https://www.gesetze-im-internet.de/sgb_5/__48.html), [BMG](https://www.bundesgesundheitsministerium.de/krankengeld) |
| Krank, Selbstständige | Krankengeld nur mit Wahlerklärung bzw. Wahltarif, sonst privates Krankentagegeld | [§ 44 Abs. 2 SGB V](https://www.gesetze-im-internet.de/sgb_5/__44.html) |
| Dauerhaft eingeschränkt | Gesetzliche **Erwerbsminderungsrente**: volle bei weniger als 3 Stunden, **halbe bei 3 bis unter 6 Stunden** täglich, gemessen an **jeder** Tätigkeit auf dem allgemeinen Arbeitsmarkt. Meist befristet | [§ 43 SGB VI](https://www.gesetze-im-internet.de/sgb_6/__43.html), [§ 102 SGB VI](https://www.gesetze-im-internet.de/sgb_6/__102.html) |
| Voraussetzungen EM-Rente | 5 Jahre Wartezeit und 3 Jahre Pflichtbeiträge in den letzten 5 Jahren. Berufsanfänger haben deshalb oft noch **keinen** Anspruch (Ausnahmen z. B. Arbeitsunfall) | [§ 43 Abs. 1, 2 SGB VI](https://www.gesetze-im-internet.de/sgb_6/__43.html), [§ 53 SGB VI](https://www.gesetze-im-internet.de/sgb_6/__53.html) |
| Berufsschutz | Gibt es nur noch für vor dem 2. Januar 1961 Geborene. Alle anderen müssen sich auf jeden Job verweisen lassen | [§ 240 SGB VI](https://www.gesetze-im-internet.de/sgb_6/__240.html) |

**Leitfaden-Fehler:** „Die halbe Erwerbsminderungsrente wurde in der Praxis noch nie ausgezahlt.“ → **Falsch.** Sie wird gezahlt, wenn die Voraussetzungen vorliegen. Das richtige Argument für die BU ist ein anderes: Die EM-Rente fragt nicht nach dem Beruf, ist niedrig und setzt Wartezeiten voraus.

**BU sachlich vergleichen:**
- Kriterien: Verzicht auf abstrakte Verweisung (bei guten Tarifen heute Standard), Prognosezeitraum 6 Monate, Leistung ab 50 % BU, Nachversicherungsgarantie, Endalter passend zum Rentenbeginn, Beitragsstabilität.
- **Zahlbeitrag und Maximalbeitrag** (Bruttobeitrag) immer beide zeigen: Der Zahlbeitrag ist um Überschüsse gesenkt und kann bis zum Maximalbeitrag steigen. Der Marktvergleich weist beides aus.
- **Nie eine bestehende BU kündigen, bevor die neue angenommen ist** (neue Gesundheitsprüfung, höheres Eintrittsalter).

---

## 6. Kapital und Altersvorsorge

### 6.1 Rentenlücke richtig rechnen

1. **Bedarf im Alter** nach Hugos Folie „Einkommen in Zukunft“: Lebenshaltung, Wohnkosten, Absicherung von Risiken, dazu Kranken-/Pflegeversicherung und Steuer im Alter. **Nicht** pauschal „letztes Netto“ (wie im Leitfaden): Sparraten und Arbeitswege fallen weg.
2. **Gesetzliche Rente** aus der aktuellen **Renteninformation**. Die Beträge dort sind **brutto**.
3. **Abzüge von der gesetzlichen Rente:**
   - Kranken- und Pflegeversicherung (pflichtversicherte Rentner): 7,3 % + halber Zusatzbeitrag + Pflege voll 3,6 % bzw. 4,2 % kinderlos. Mit Ø-Zusatzbeitrag 2026 rund **12,35 %**, kinderlos **12,95 %** ([§ 249a SGB V](https://www.gesetze-im-internet.de/sgb_5/__249a.html), [§ 59 SGB XI](https://www.gesetze-im-internet.de/sgb_11/__59.html)).
   - **Steuer:** Steuerpflichtig ist der **Besteuerungsanteil** nach Jahr des Rentenbeginns: 2026 84 %, 2040 91 %, **100 % erst ab Rentenbeginn 2058** ([§ 22 Nr. 1 EStG, Tabelle](https://www.gesetze-im-internet.de/estg/__22.html), [DRV](https://www.deutsche-rentenversicherung.de/DRV/DE/Ueber-uns-und-Presse/Presse/Meldungen/2024/240402-wachstumschancengesetz-rentenbesteuerung)). Ob tatsächlich Steuer anfällt, hängt an den gesamten Einkünften (Grundfreibetrag).
4. **Kaufkraft:** Inflation als **Annahme** offen ausweisen (z. B. 2 %). Entweder alles in heutiger Kaufkraft oder alles nominal rechnen, **nie mischen** (der Leitfaden rechnet das Gehalt mit 3 % hoch und vergleicht mit der Renteninformation).
5. **Kapitalbedarf:** Lücke × 12 × erwartete Bezugsdauer oder über den Rentenfaktor eines Angebots. Zins- oder Entnahme-Annahmen offen nennen. Die „5 % Verzinsung“ im Leitfaden ist eine Annahme, kein Fakt.
6. **Rentenniveau:** Haltelinie 48 % bis zur Rentenanpassung 2031 ([Rentenpaket 2025, Bundesregierung](https://www.bundesregierung.de/breg-de/aktuelles/rentenpaket-2025-2368678)). Danach ist es offen, nicht „sicher sinkend“ behaupten.

### 6.2 Steuern und Abgaben auf Anlagen und Vorsorge

| Produkt | Besteuerung / Abgaben | Quelle |
|---|---|---|
| **Fonds/ETF im Depot** | Abgeltungsteuer 25 % + Soli = **26,375 %** (ggf. Kirchensteuer). **Teilfreistellung:** Aktienfonds 30 %, Mischfonds 15 % des Ertrags steuerfrei. **Sparerpauschbetrag** 1.000 € (Paare 2.000 €). Jährlich Vorabpauschale | [§ 32d EStG](https://www.gesetze-im-internet.de/estg/__32d.html), [§ 20 InvStG](https://www.gesetze-im-internet.de/invstg_2018/__20.html), [§ 20 Abs. 9 EStG](https://www.gesetze-im-internet.de/estg/__20.html) |
| **Lebens-/Rentenversicherung, Auszahlung als Kapital** | Ertrag mit Abgeltungsteuer. **Halbeinkünfte** (Hälfte des Ertrags mit persönlichem Steuersatz) **nur** bei mindestens 12 Jahren Laufzeit **und** Auszahlung ab 62 (Verträge ab 2012, vorher ab 60). Fondspolice zusätzlich 15 % Teilfreistellung | [§ 20 Abs. 1 Nr. 6 EStG](https://www.gesetze-im-internet.de/estg/__20.html) |
| **Altverträge (Abschluss vor 2005)** | Kapitalauszahlung unter den alten Voraussetzungen meist **steuerfrei** (u. a. 12 Jahre Laufzeit, 5 Jahre Beiträge, Todesfallschutz). Vor jeder Kündigung prüfen | Übergangsregel § 52 EStG |
| **Private Rente** (Schicht 3) **als lebenslange Rente** | **Nicht steuerfrei** (Leitfaden-Fehler): Steuerpflichtig ist nur der **Ertragsanteil**, z. B. 17 % bei Rentenbeginn mit 67, 18 % mit 65. Für pflichtversicherte Rentner keine Kranken-/Pflegebeiträge | [§ 22 Nr. 1 S. 3 a bb EStG](https://www.gesetze-im-internet.de/estg/__22.html) |
| **bAV** (Direktversicherung, Pensionskasse/-fonds) | Auszahlung voll steuerpflichtig. Dazu **volle** Kranken- und Pflegebeiträge (2026 im Schnitt rund 21 %). KV-Freibetrag 197,75 € im Monat, Pflege: Freigrenze, darüber voller Beitrag | [§ 22 Nr. 5 EStG](https://www.gesetze-im-internet.de/estg/__22.html), [§ 226 SGB V](https://www.gesetze-im-internet.de/sgb_5/__226.html) |
| **Geförderte Verträge** (Riester, Altersvorsorgedepot ab 2027) | Auszahlung voll steuerpflichtig (nachgelagert), dafür Zulagen/Sonderausgabenabzug in der Ansparphase | [§ 22 Nr. 5 EStG](https://www.gesetze-im-internet.de/estg/__22.html), [BMF-FAQ](https://www.bundesfinanzministerium.de/Content/DE/FAQ/reform-der-privaten-altersvorsorge.html) |

**Leitfaden-Fehler bei der Beispielrechnung:** Die Fondsseite wird mit „rund 27 % auf den ganzen Gewinn“ gerechnet. Ohne Teilfreistellung und Pauschbetrag ist das zu hoch. Außerdem werden unterschiedliche Rendite-Annahmen verglichen (alter Vertrag mit 3 %, neues Produkt mit 6 %). Das ist kein fairer Vergleich.

### 6.3 Bestehende Verträge fair bewerten

- **Garantiezins alter Verträge** (Höchstrechnungszins bei Abschluss): bis Mitte 2000 4 %, bis 2003 3,25 %, 2004–2006 2,75 %, 2007–2011 2,25 %, 2012–2014 1,75 %, 2015–2016 1,25 %, 2017–2021 0,9 %, 2022–2024 0,25 %, seit 2025 1,0 % ([DeckRV](https://www.gesetze-im-internet.de/deckrv_2016/__2.html)). Ein alter Vertrag mit hohem Garantiezins und ggf. Steuerfreiheit kann **besser** sein als jede Neuanlage.
- **Kündigen kostet:** Rückkaufswert liegt in den ersten Jahren oft unter den eingezahlten Beiträgen, neue Abschlusskosten, ggf. Steuer. **Alternativen nennen:** beitragsfrei stellen, Beitrag senken, laufen lassen und neu nur für die Differenz sparen.
- Riester/geförderte Verträge: nicht kündigen (Förderung wird zurückgefordert). Ab 2027 Übertragung ins neue Modell möglich.

### 6.4 Fair vergleichen

- **Gleiche Annahmen** auf beiden Seiten: Rendite vor Kosten, Laufzeit, Beitrag, Steuern nach aktueller Rechtslage.
- **Kosten** als **Effektivkosten** (Renditeminderung pro Jahr) aus dem **Basisinformationsblatt**. Nicht „53 % Kostenanteil“: Das ist ein Anteil am Ertrag, nicht am eingezahlten Geld, und klingt größer, als es ist.
- Hochrechnungen mit Bandbreite (Szenarien aus dem Basisinformationsblatt), nie als Versprechen.
- **Kurz vs. mittel bei gleicher Sparrate** (Hugos Methode) ist fair, solange beide Seiten nach Kosten und Steuern gerechnet sind.

### 6.5 Neu ab 2027

| Thema | Stand | Quelle |
|---|---|---|
| **Riester** | Ab 01.01.2027 keine neuen Verträge nach altem Modell. Bestehende laufen weiter, Wechsel ins neue Modell möglich (Wechselkosten möglich) | [BMF-FAQ](https://www.bundesfinanzministerium.de/Content/DE/FAQ/reform-der-privaten-altersvorsorge.html), [Bundesregierung](https://www.bundesregierung.de/breg-de/aktuelles/reform-private-altersvorsorge-2400072) |
| **Gefördertes Altersvorsorgedepot** (Altersvorsorgereformgesetz, BGBl. 2026 I Nr. 156) | Depot ohne Garantie (auch ETFs), gefördert werden Eigenbeiträge bis 1.800 €/Jahr plus Zulagen, Erträge in der Ansparphase steuerfrei. Standarddepot mit Kostendeckel 1,0 %, daneben Garantieprodukte (80 % / 100 %), Auszahlplan oder Rente. Stand 07.11.2026 noch kein zertifiziertes Produkt bekannt | [BMF-FAQ](https://www.bundesfinanzministerium.de/Content/DE/FAQ/reform-der-privaten-altersvorsorge.html), [DRV](https://www.deutsche-rentenversicherung.de/DRV/DE/Rente/Moeglichkeiten-der-Altersvorsorge/Altervorsorgereformgesetz) |
| **Frühstartrente** | 10 € im Monat vom Staat für Kinder von 6 bis 18 (ab Jahrgang 2020), Start 01.01.2027 | [BMF-FAQ](https://www.bundesfinanzministerium.de/Content/DE/FAQ/fruehstart-rente.html) |

### 6.6 bAV

- Bei Entgeltumwandlung muss der Arbeitgeber **15 %** dazugeben, soweit er Sozialbeiträge spart ([§ 1a Abs. 1a BetrAVG](https://www.gesetze-im-internet.de/betravg/__1a.html)). In der Analyse nach dem tatsächlichen Zuschuss fragen.
- Hugos Linie (bAV selten sinnvoll) hat gute Gründe: volle Steuer und Sozialabgaben in der Auszahlung (6.2). Sie lohnt sich eher, wenn der Arbeitgeber **deutlich mehr** als 15 % gibt.

---

## 7. Kurzliste: falsche oder veraltete Aussagen im VVO-Leitfaden „Beratungsgespräch“ (2018)

| Leitfaden (sinngemäß) | Richtig | Abschnitt |
|---|---|---|
| Halbe EM-Rente wird nie ausgezahlt | wird gezahlt, wenn die Voraussetzungen vorliegen | 5 |
| Einheitsbeitragssatz 14,6 % | 14,6 % + Zusatzbeitrag, Arbeitnehmer zahlt die Hälfte | 3 |
| Kassenersparnis mit Zinseszins lebenslang hochrechnen | halbe Differenz, Zusatzbeiträge ändern sich jährlich | 3 |
| Renten werden „deutlich höher“ besteuert | Anstieg seit 2023 verlangsamt, 100 % ab 2058 | 6.1 |
| Lücke = letztes Netto minus Rente | Bedarf im Alter, Rente brutto minus KV/PV und Steuer | 6.1 |
| Fonds: rund 27 % auf den ganzen Gewinn | 26,375 %, Teilfreistellung, Sparerpauschbetrag | 6.2 |
| Halbeinkünfte pauschal | nur 12 Jahre + Auszahlung ab 62 (bzw. 60) | 6.2 |
| Private Rente ist steuerfrei | Ertragsanteil steuerpflichtig | 6.2 |
| 53 % „Risiko- und Kostenanteil“ | Effektivkosten aus dem Basisinformationsblatt | 6.4 |
| Vergleich 3 % (alt) gegen 6 % (neu) | gleiche Rendite-Annahme vor Kosten | 6.4 |
| Statistiken von 2018 | aktuelle Werte, eigene Zahlen des Mandanten | 1 |
