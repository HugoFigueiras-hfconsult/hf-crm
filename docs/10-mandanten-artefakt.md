# Mandanten-Artefakt: ein Artefakt je Mandant

Stand 2026-11-25 · **Ziel, noch nicht gebaut**

## Ziel (Hugo, 2026-11-25)

- **1 Mandant = 1 Artefakt.** Der Agent erstellt und pflegt es.
- Es ersetzt **auf lange Sicht die VVO-Präsentation**, sowohl in der **Analyse** als auch im **Konzept-Termin** (Beratungsgespräch). Danach wird es in den Update-Terminen fortgeschrieben.
- Bis es steht, arbeitet Hugo weiter mit der VVO-Präsentation. Der Agent liefert ihm dafür die Zahlen (Spickzettel, `docs/09-neumandant.md`).

## Verhältnis zur Entscheidung vom 2026-11-12 („zwei Artefakte je Mandant“)

Damals: Mandantenansicht zum Teilen + Berater-Ansicht nur für Hugo, getrennt, damit beim Teilen nie interne Notizen sichtbar werden.

**Vorschlag des Agenten (wartet auf Hugos Bestätigung):** Das eine Artefakt ist die Mandantenansicht. Die Berater-Infos (Kandidaten, Lücken, Notizen, Spickzettel) werden **kein** zweites Artefakt, sondern ein Briefing im Chat, das der Agent vor jedem Termin aus der DB erzeugt. So gibt es ein Artefakt je Mandant, und es enthält trotzdem nie interne Notizen.

## Ansichten (Reiter, in der Reihenfolge der Termine)

| # | Reiter | Inhalt | Termin |
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
| 10 | Verlauf | Depotstand, Ziele erreicht, Termine | Update |

**Interaktiv:** Regler für Sparrate, Rendite-Annahme, Inflation, Rentenbeginn. Die Ergebnisse rechnen sofort neu, die Annahmen stehen immer daneben. Rechenregeln: `agent/fachwissen.md` Abschnitt 6.

## Regeln

- **Eigenes Design**, keine VVO-Folien, kein VVO-Branding nachbauen. Die Logik (Einkommen heute → Zukunft, Übersicht, drei Töpfe) übernimmt Hugo aus seiner Beratung.
- Taugt zur **Bildschirmfreigabe in Teams** (große Schrift, klare Zahlen) und ist auf dem Handy lesbar.
- **Sachliche Sprache** (`agent/fachwissen.md` Abschnitt 1): „heute / Vorschlag“ statt „vor / nach Optimierung“, keine Superlative, Hochrechnungen mit Bandbreite.
- **Daten im Artefakt eingebettet** (der Agent schreibt sie aus der DB und veröffentlicht neu), die Rechner laufen im Browser. **Kein Live-Zugriff auf die DB**: Der Mandant kann es dann ohne Login öffnen, und es sind nie Daten anderer Mandanten erreichbar.
- Keine internen Notizen, keine Kandidatenlisten, nichts zu Provisionen.
- Adresse in `Mandant.ArtefaktUrl` (ersetzt die zwei Felder `ArtefaktMandantUrl`/`ArtefaktBeraterUrl`, sobald Hugo den Vorschlag oben bestätigt). Vor jeder Aktualisierung liest der Agent die bestehende Version und baut darauf auf (gleiche Adresse, neue Version).

## Umsetzung (Reihenfolge)

1. Vorlage als HTML im Repo (`dashboard/mandant-vorlage.html`) mit **erfundenen Testdaten**.
2. Hugo prüft Aufbau und Sprache, Korrekturen.
3. Erster echter Fall (neben der VVO-Präsentation).
4. Danach: Analyse und Konzept nur noch mit dem Artefakt.

## Abgrenzung

Phase 8 (`docs/07-dashboard.md`) ist ein **Berater-Dashboard** über alle Mandanten (nur Hugo). Das Mandanten-Artefakt hier ist etwas anderes.

## Offen

- Hugo bestätigt den Vorschlag zur Berater-Ansicht (oben).
- Bekommt der Mandant den Link zum Artefakt (zum Nachlesen) oder sieht er es nur in der Bildschirmfreigabe bzw. als PDF? Bisherige Regel (`docs/08-update-termin.md`): wegen Depotwerten kein offener Link ohne Schutz.
