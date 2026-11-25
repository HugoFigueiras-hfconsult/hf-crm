# Mandanten-Artefakt: ein Artefakt je Mandant

Stand 2026-11-25 · **Vorlage v1 gebaut (Fable 5.2, xhigh), Hugo prüft** · Vorlage: `dashboard/mandant-vorlage.html`, Beschreibung `dashboard/README.md`, zum Anschauen: [Artefakt „Mandanten-Artefakt Vorlage“](https://claude.ai/artifact/6cMyozFZmAAhsVzit74XuZ) (privat, nur Hugo)

## Ziel (Hugo, 2026-11-25)

- **1 Mandant = 1 Artefakt.** Der Agent erstellt und pflegt es.
- Es ist **Hugos Präsentation und Navigationsbasis** im Termin: Analyse, Konzept, später Update-Termine. Es ersetzt auf lange Sicht die VVO-Präsentation.
- Gezeigt wird es **nur per Bildschirmfreigabe** (Teams). Der Mandant bekommt **keinen Link und kein PDF** des Artefakts, sondern am Ende die Mail mit den Unterlagen (Vergleiche, Angebote; `agent/vorlagen/konzept-mail.md`).
- Es muss **visuell schön sein, mit vielen Animationen**.
- Hugos interne Infos (Kandidaten, Lücken, Leitfragen, „nicht ansprechen“) kommen **nicht** ins Artefakt, sondern als **Briefing im Chat** vor dem Termin. Der Mandant sieht das Artefakt ja mit.
- Bis das Artefakt steht, arbeitet Hugo mit der VVO-Präsentation weiter. Der Agent liefert die Zahlen als Spickzettel (`docs/09-neumandant.md`).

## Kapitel (Reihenfolge wie im Termin)

| # | Kapitel | Inhalt | Termin |
|---|---|---|---|
| 1 | Lebens-Zeitstrahl und Ziele | Ziele kurz/mittel/lang mit Betrag und Zeitpunkt | Analyse |
| 2 | Drittel-Regel | Wohnen / Leben / Leben später: Soll und Ist | Analyse |
| 3 | Heute aufgestellt | Rücklage, Sparraten und Anlagen je Topf, Risikoprofil | Analyse |
| 4 | Einkommen heute → im Alter | Brutto, Steuer, Abgaben, Netto, Verwendung; was im Alter bleibt | Konzept |
| 5 | Übersicht heute / Vorschlag | je Bereich Beitrag heute und mit Vorschlag, Summe | Konzept |
| 6 | Bereiche im Detail | Gesundheit, Basisrisiken, Einkommen: Vertrag heute, Vorschlag mit Konditionen, warum dieser (von drei verglichenen) | Konzept |
| 7 | Drei Töpfe | kurz / mittel / lang, Vermögensaufbau-Kurve, kurz vs. mittel bei gleicher Sparrate | Konzept |
| 8 | Rentenlücke | vorher / nachher, Annahmen sichtbar | Konzept |
| 9 | Nächste Schritte | Fragerunde, Unterlagen, Aufgaben beider Seiten | alle |
| 10 | Verlauf | Depotstand, erreichte Ziele, Termine, Neuerungen | Update |

## Präsentation und Navigation

- **Startseite als Übersicht** (wie die VVO-„Übersicht“): Kacheln für alle Kapitel und Bereiche. Ein Klick springt hinein, ein Klick führt zurück. So kann Hugo frei springen, wenn der Mandant eine Frage hat.
- **Vor/Zurück** mit Pfeiltasten und gut sichtbaren Schaltflächen, Fortschrittsanzeige (wo im Termin sind wir).
- **Präsentationsmodus:** Vollbild, nur Inhalte, keine Bedienelemente außer der Navigation.
- **Rechner direkt in der Präsentation:** Regler für Sparrate, Rendite-Annahme, Inflation und Rentenbeginn. Die Ergebnisse rechnen sofort neu, die Annahmen stehen immer daneben. Rechenregeln: `agent/fachwissen.md` Abschnitt 6.

## Gestaltung und Animationen

- **Hochwertig und ruhig:** eigenes Design (kein VVO-Branding), klare Farben je Topf (kurz/mittel/lang) und je Bereich, große Zahlen, viel Weißraum.
- **Viele Animationen, die die Geschichte erzählen**, zum Beispiel:
  - Zahlen zählen beim Einblenden hoch.
  - Balken wachsen; „heute → Vorschlag“ verwandelt sich sichtbar (Balken schrumpft oder wächst auf den neuen Wert).
  - Einkommen heute „fließt“ in seine Bestandteile (Steuer, Abgaben, Netto, Verwendung).
  - Die Vermögensaufbau-Kurve zeichnet sich von links nach rechts; die Rentenlücke schließt sich animiert, wenn der Vorschlag eingeblendet wird.
  - Weiche Übergänge zwischen Kapiteln, Kacheln zoomen beim Hineinspringen auf.
- **Teams-tauglich:** Teams überträgt Bildschirme mit wenigen Bildern pro Sekunde und komprimiert. Deshalb Animationen mit klarem Start und Ende (0,5–1,2 s), keine dauerhaften Hintergrundbewegungen, kein Flackern, große Schrift.
- Zusätzlich ein **Schalter „Animationen aus“** und Rücksicht auf die Systemeinstellung „Bewegung reduzieren“.
- **Sachliche Sprache** (`agent/fachwissen.md` Abschnitt 1): „heute / Vorschlag“ statt „vor / nach Optimierung“, keine Superlative, Hochrechnungen mit Bandbreite.

## Kennzahlen im Termin (Hugo, 2026-11-25)

Hugo möchte die wichtigsten Zahlen und Argumente während der Beratung vor Augen haben, damit er sich nicht verspricht. Quelle ist **`agent/fachwissen.md` Abschnitt 9** (nur geprüfte Werte mit Quelle) und Abschnitt 10 (Fehlaussagen).

- **Faktenbox im Kapitel:** Sachliche Fakten, die der Mandant sehen darf, stehen klein im passenden Kapitel, mit Quelle. Beispiele: Kapitel 6 Einkommen „volle BU-Rente ab 50 %“, „frühester Rentenbeginn 63, nur mit 35 Jahren, 14,4 % Abschlag“; Kapitel 7/8 „Abgeltungsteuer 26,375 %, Teilfreistellung 30 %“.
- **Referentenansicht nur für Hugo:** Formulierungshilfen („so nicht sagen“, Abschnitt 10) und Argumente gehören nicht auf den geteilten Bildschirm. Sie stehen in einer Referentenansicht in einem zweiten Fenster (wie in PowerPoint). Hugo gibt in Teams nur das Präsentationsfenster frei, nicht den ganzen Bildschirm. Technik beim Bauen prüfen; geht das nicht, kommen sie ins Briefing im Chat.
- Der Agent wählt je Mandant nur die Kennzahlen, die zu dessen Bereichen passen (z. B. BU-Endalter nur, wenn eine BU Thema ist).

## Daten

- **Im Artefakt eingebettet.** Der Agent schreibt sie aus der DB und veröffentlicht das Artefakt neu (gleiche Adresse, neue Version). Die Rechner laufen im Browser.
- **Kein Live-Laden aus der DB** während des Termins: Der MCP-Server braucht nach Leerlauf bis ca. 25 s zum Aufwachen (LOG 20.11.), das passt nicht in eine Präsentation. Außerdem sind so nie Daten anderer Mandanten erreichbar.
- Adresse in `Mandant.ArtefaktUrl`. Vor jeder Aktualisierung liest der Agent die bestehende Version und baut darauf auf.
- Keine internen Notizen, keine Kandidatenlisten, nichts zu Provisionen.

## Umsetzung (Reihenfolge)

1. ✅ 25.11.: Vorlage als HTML im Repo (`dashboard/mandant-vorlage.html`) mit **erfundenen Testdaten**, gebaut von Fable 5.2 (xhigh), geprüft und veröffentlicht. 16 Folien, Rechner, Animationen, Empfehlungsfolie schaltbar (`DATEN.optionen.empfehlungsfolie`). Noch nicht gebaut: Referentenansicht (zweites Fenster), Detailfolie Wohnen. Offene Fragen an Hugo: `dashboard/README.md`.
2. Hugo prüft Aufbau, Optik, Animationen und Sprache in einer Probe-Bildschirmfreigabe.
3. Erster echter Fall, zunächst neben der VVO-Präsentation.
4. Danach Analyse und Konzept nur noch mit dem Artefakt.

## Abgrenzung

Phase 8 (`docs/07-dashboard.md`) ist ein **Berater-Dashboard** über alle Mandanten (nur Hugo, live aus der DB). Das Mandanten-Artefakt hier ist etwas anderes.
