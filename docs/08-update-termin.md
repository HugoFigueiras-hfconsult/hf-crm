# Update-Termin: Ablauf, Vorbereitung, Artefakte

Stand 2026-11-12 · Mit Hugo abgestimmt · Arbeitsanweisung für den Agenten (Vorbereitung + Nachbereitung) und Leitfaden für Hugo im Termin.
Datenmodell dazu: `docs/02-schema.md`. Anrede Mandanten: immer „Du“.

## Grundsätze

- **Erst der Mensch, dann der Markt.** Der Mandant redet zuerst, alles Weitere wird auf seine Lage zugeschnitten.
- **Nur Relevantes.** Neuerungen bei Vorsorge/Versicherungen nur, wenn sie diesen Mandanten betreffen.
- **Nichts doppelt erzählen.** Der Agent prüft in früheren Terminen, welche Themen schon besprochen wurden.
- **Gedächtnis zeigen.** Persönliche Anknüpfungspunkte aus dem Profil, Rückblick auf Vereinbartes.

## Rhythmus

| Lage beim Mandanten | Rhythmus |
|---|---|
| Viel los im Leben (Familie, Job, Immobilie, größere Entscheidungen) | **quartalsweise** |
| Ruhige Phase | **halbjährlich** |

Steht in `Mandant.Terminrhythmus`. Der Agent schlägt nach der Nachbereitung einen Wechsel vor, wenn sich die Lage ändert, und legt eine `Aufgabe` „Update-Termin vereinbaren“ zum fälligen Zeitpunkt an.

## Ablauf im Termin (ca. 40 min)

| # | Baustein | Dauer | Agent bereitet vor |
|---|---|---|---|
| 0 | **Einladung mit Mini-Agenda** (2–3 Tage vorher) | – | Kurzer Mail-Entwurf: „Ich bringe Markt, dein Depot und [Thema] mit. Gibt es etwas, worüber du sprechen möchtest?“ Antworten fließen in die Vorbereitung |
| 1 | **Smalltalk** | 3–5 min | 2–3 persönliche Anknüpfungspunkte aus `Mandant.Profil` (Urlaub, Kinder, Hobby, Ereignis vom letzten Mal) |
| 2 | **Was ist neu bei dir?** (Lebensereignisse) | 5–10 min | Leitfragen: Familie, Job/Einkommen, Wohnen, größere Pläne/Ausgaben, Gesundheit allgemein; dazu „steht bevor“-Punkte aus dem Profil |
| 3 | **Rückblick: Was wir letztes Mal vereinbart haben** | 2 min | Offene `Aufgabe`n beider Seiten aus dem letzten `Termin` |
| 4 | **Markt seit dem letzten Termin** | 2–4 min | Zeitraum = letzter Termin dieses Mandanten bis heute: große Indizes, wohin das Geld fließt, große Ereignisse (Crash, Rally, Zinsen). Aus dem zentralen Themen-Radar, nicht pro Mandant neu recherchiert. In unruhigen Zeiten zuerst die Sorgen abholen |
| 5 | **Dein Depot** | 3–5 min | Entwicklung seit dem letzten Stand, im Licht von Punkt 4; Zusammensetzung (Daten siehe „Depot“) |
| 6 | **Was sich bei Vorsorge und Versicherungen ändert** | 2 min | Nur große, für diesen Mandanten relevante Änderungen aus dem Themen-Radar (z. B. Altersvorsorgedepot 2027 bei Riester-Vertrag oder Kindern, Steueränderungen bei Auszahlungen, BU) |
| 7 | **Vertrags-Check** | 5 min | Fristen und Abläufe, Beitragsanpassungen, Kandidaten für bessere Konditionen; Verknüpfung mit Punkt 2 (z. B. Heirat/Kind/Hauskauf → **Nachversicherungsgarantie der BU**, nur innerhalb einer Frist) |
| 8 | **Deine Fragen und Wünsche / Beratung** | 10–15 min | Fragen aus der Einladung und aus dem Profil, vorbereitete Antworten/Optionen |
| 9 | **Abschluss** | 3 min | Zusammenfassung, wer macht was bis wann, **nächsten Termin gleich vereinbaren**. Einmal im Jahr: Ziele noch aktuell? Zufrieden? Empfehlung? |

**Aufzeichnung:** Entstehen Transkripte aus Aufnahmen, braucht es die Zustimmung des Mandanten (§ 201 StGB, unabhängig von DSGVO/AVV). Fester Satz beim Ankommen, z. B.: „Ist es okay, wenn ich mitschreiben lasse, damit ich mich voll auf dich konzentrieren kann?“

## Zwei Artefakte pro Mandant (dauerhaft, werden fortgeschrieben)

| Artefakt | Für wen | Inhalt | Regel |
|---|---|---|---|
| **Mandantenansicht** | zum Zeigen/Teilen | Marktgrafik seit letztem Termin, Depotentwicklung (wächst über die Termine), 1–2 relevante Neuerungen, Fristen als Zeitleiste, „Deine Fragen“, vereinbarte nächste Schritte | **keine internen Notizen** |
| **Berater-Ansicht** | nur Hugo | alles aus der Mandantenansicht + Anknüpfungspunkte, Leitfragen, Vertrags-Hinweise, Chancen, Dinge, die man nicht ansprechen sollte, Rückblick offene Punkte | nie teilen |

- **Pro Mandant genau zwei Artefakte, keine neuen pro Termin.** Der Agent aktualisiert die bestehenden (gleiche Adresse, neue Version). Verläufe (Depot, Termine) wachsen darin mit.
- Adressen stehen in `Mandant.ArtefaktMandantUrl` und `Mandant.ArtefaktBeraterUrl`. Vor dem Aktualisieren liest der Agent die bestehende Version und baut darauf auf.
- Teilen mit dem Mandanten: im Termin per Bildschirm zeigen oder als PDF schicken. Ob und wie ein Link für Mandanten ohne Claude-Konto funktioniert, ist noch zu prüfen. Wegen Depotwerten keinen offenen Link ohne Schutz.
- Später möglich (Phase 8): Berater-Ansicht als Live-Ansicht, die Daten direkt aus der DB lädt. Die Mandantenansicht bleibt ein fester Stand.

## Depot (FNZ Bank)

- Zugriff hat aktuell nur Kollege **Kai Stettner**; die Depots wandern mit der Zeit zu Hugo.
- Ablauf heute: Kai schickt Hugo einen **Screenshot** → Hugo gibt ihn dem Agenten → der Agent liest Positionen und Werte ab und speichert sie mit Stichtag (`Depotstand`, `DepotPosition`), legt den Screenshot im Mandantenordner ab (`01 Verträge/Depot/JJJJ-MM-TT FNZ.png`) und vermerkt Besonderheiten im Profil (Anlagestrategie, Sparplan).
- Bevor ein Stand gespeichert wird: Agent zeigt Hugo die abgelesenen Zahlen kurz zur Kontrolle (Screenshots sind fehleranfällig beim Ablesen).
- Später, wenn Hugo eigenen FNZ-Zugang hat: Export statt Screenshot prüfen.

## Themen-Radar (zentral, nicht pro Mandant)

- Einmal pro Woche oder vor einer Terminwelle: Markt (Indizes, Geldflüsse, große Ereignisse) und große Änderungen bei Vorsorge/Versicherung/Steuern als Einträge in `Thema` (was, ab wann, wen betrifft es, Quelle).
- Pro Mandant wählt der Agent nur den passenden Zeitraum (seit letztem Termin) und die passenden Themen (Abgleich mit `Vertrag` und Profil).
- Spart Recherche und Nutzungslimit gegenüber einer Recherche pro Termin.

## „Bessere Konditionen“

Der Agent kann Vergleichsrechner (Morgen & Morgen, Franke und Bornberg, JDC-Rechner) nicht bedienen. Er **markiert Kandidaten** (alter Tarif, starke Beitragserhöhung, Ablauf/Kündigungsfrist naht, Lebensereignis verändert Bedarf) und Hugo rechnet gezielt nur diese.

## Was der Agent wann tut

| Wann | Was |
|---|---|
| Wöchentlich | Themen-Radar aktualisieren; fällige Update-Termine (Rhythmus) als Liste an Hugo |
| 2–3 Tage vor dem Termin | Einladungs-Entwurf mit Mini-Agenda (Baustein 0) |
| 1 Tag vor dem Termin | Vorbereitung: Profil, letzte Termine, offene Aufgaben, Verträge/Fristen, Depotstand, passende Themen → **beide Artefakte aktualisieren**, Kurzfassung in `Termin.Vorbereitung` |
| Nach dem Termin | Nachbereitung (siehe `docs/02-schema.md`): Transkript ablegen + lesen, Zusammenfassung, Profil verdichten, Aufgaben, Rhythmus prüfen, Artefakte um Ergebnisse/nächste Schritte ergänzen, Folge-Mail nur wenn der Mandant Infos erwartet |
