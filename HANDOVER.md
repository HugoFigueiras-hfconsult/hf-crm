# Handover → neuer Chat

Stand: 2026-11-25 · Repo `HugoFigueiras-hfconsult/hf-crm`, Branch `main` · ersetzt `HANDOVER-CLOUD.md` (Stand 12.11.)

## In einer Minute

- **Technik läuft:** Azure SQL (leer), MCP-Server `https://mcp.hf-consult.de/mcp` (Caddy als Türsteher + DAB 2.1.5), Microsoft-Login, Claude-Connector **HF-CRM** verbunden und getestet. Kosten 0 €.
- **Ziel:** kein klassisches CRM, sondern **Gedächtnis + Verknüpfung** für Hugos Beratungs-Agenten neben JDC (Bestand), OneDrive (Dokumente) und Outlook. Alles dazu: **`agent/README.md`**.
- **Konzept steht weitgehend:**
  - Markdown-Profil je Mandant + Tabellen, drei Kontext-Schichten (`docs/02-schema.md`, mit Gesamtübersicht der Tabellen)
  - Ablauf der Update-Termine (`docs/08-update-termin.md`)
  - Analyse-Termin für Neumandanten inkl. Checkliste und Formalia (`docs/09-neumandant.md`)
  - Vorlage Unterlagen-Mail (`agent/vorlagen/unterlagen-mail.md`)
- **Noch nichts in der DB:** kein Schema, keine Routinen, keine Artefakt-Vorlagen. Hugo arbeitet **hybrid**: Claude entwirft auf Zuruf im Chat, Rohmaterial (Transkript, Whiteboard-Bild) landet schon jetzt im OneDrive-Ordner des Mandanten.

## Lesereihenfolge

1. `CLAUDE.md` (Regeln + Zusammenarbeit mit Hugo)
2. `docs/STATUS.md` (Stand, Fristen, offene Punkte)
3. `agent/README.md` (was der Agent tut, Werkzeuge, Regeln, Umsetzungsstand)
4. `docs/02-schema.md`, `docs/08-update-termin.md`, `docs/09-neumandant.md`
5. bei Technikarbeit: `docs/ARCHITEKTUR.md`, `docs/BETRIEB.md`, lokal zusätzlich `docs/LOKALE-SESSION.md`

## Nächste Schritte (in dieser Reihenfolge)

0. **Wiedervorlagen prüfen** (`docs/STATUS.md`, Fristen):
   - ab **07.12.2026** an O10/O11 erinnern
   - vor dem **11.12.2026** Testversion → Pay-As-You-Go (O1) und Budget-Alarm (O8)
1. ✅ 25.11.: Konzept-Termin + Fragerunde beschrieben (`docs/09-neumandant.md`, inkl. Fachhinweise Altersvorsorgedepot/Riester 2027 und veraltete Aussagen im VVO-Leitfaden 2018). Hugos Entscheidungen dazu stehen in `docs/00-entscheidungen.md` (25.11.). Fachwissen statt VVO-Leitfaden: `agent/fachwissen.md`. Ziel 1 Mandant = 1 Artefakt: `docs/10-mandanten-artefakt.md`. Artefakt entschieden: nur per Bildschirmfreigabe als Präsentation/Navigation, visuell hochwertig mit Animationen, Berater-Infos als Chat-Briefing. Abschluss + Empfehlungen beschrieben (25.11., `docs/09-neumandant.md`, Vorlage `agent/vorlagen/empfehlung-weiterleiten.md`, Recht in `agent/fachwissen.md` Abschnitt 8). Abschluss-Fragen beantwortet (25.11.). **Datenmodell v1 als VORSCHLAG:** `db/migrations/001_init.sql` (10 Tabellen, auf SQL Server 2022 getestet), Beschreibung in `docs/02-schema.md` „Entitäten“. **Freigegeben (Hugo, 25.11.), noch nicht ausgeführt.** Nächster Schritt: Hugo führt das SQL im Portal aus, dann DAB-Entities, Image, Test (Schritt 3 unten). Parallel möglich: Artefakt-Vorlage mit Testdaten (`docs/10-mandanten-artefakt.md`, Umsetzung Schritt 1). Vorgehen wie bei der Analyse:
   - Hugo beschreibt den Ablauf, gern mit einem Transkript als Beispiel.
   - Claude leitet Ablauf, Agent-Aufgaben und Felder ab.
   - Fachaussagen im Transkript mit Quelle prüfen.
   - Alles ohne Mandantendaten dokumentieren.
2. **Offene Modellfragen klären:**
   - Mandant = Person oder Haushalt (`02-schema` Entscheidung 2)
   - JDC-Exportformat (Entscheidung 4)
   - Beratungsdoku-Entwurf aus dem Transkript ja/nein (hängt an O11)
3. **Datenmodell final → `db/migrations/001_init.sql` als VORSCHLAG.** Hugo gibt frei, dann:
   - SQL ausführen (`docs/BETRIEB.md` Abschnitt 3)
   - DAB-Entities freigeben, Platzhalter `Verbindungstest` entfernen (Abschnitt 2)
   - Image bauen und ausrollen (Abschnitt 4)
   - über den Connector testen

   Mit **erfundenen Testdaten** starten.
4. **OneDrive-Struktur** `Mandanten/` mit Hugo anlegen (Vorschlag in `02-schema`). Dabei den Microsoft-365-Connector mit echten Daten testen.
5. **Erste Routine: Analyse-Nachbereitung**, mit der ersten echten Analyse als Testfall (Transkript bei Hugo). Dabei das Auslesen des Whiteboard-Bilds testen.
6. Danach: Artefakt-Vorlagen (Mandanten- und Berater-Ansicht), Update-Termin-Routinen, Themen-Radar.

## Zusammenarbeit mit Hugo (wichtig)

- Deutsch, **einfache Sprache**. Hugo ist kein Entwickler. Erst erklären, was passiert und warum, Fachbegriffe übersetzen. Bei komplexen Themen **visualisieren**.
- **Alles ins Repo, Commit + Push nach jedem Schritt.** Hugo wechselt zwischen lokalen und Cloud-Sessions.
- Entscheidungen stehen in `docs/00-entscheidungen.md`: nicht neu diskutieren, außer es gibt einen neuen Grund.
- **Fachliche Korrekturen erwünscht:** Aussagen aus Hugos Gesprächen (Recht, Steuern, Produkte) an Primärquellen prüfen und mit Link nennen, schon beim ersten Durchgang. Kurz, ohne Belehrung.
- Hugo trägt bewusst Risiken (Datenschutz/AVV ausgesetzt, O10/O11 zurückgestellt). Respektieren, nur an die Wiedervorlagen erinnern.
- Vor Aktionen nach außen (Mails senden, Kündigungen, Freigaben) fragen. Mails an Mandanten nur als Entwurf.

## Daten-Hygiene

- **Keine Mandantendaten ins Repo** (Namen, Lebensumstände, Gesundheit, Zahlen), auch nicht in Commit-Nachrichten oder als „Beispiel“. Ältere Commits enthalten einige neutralisierte Formulierungen, die Historie wurde nicht umgeschrieben.
- Von Hugo hochgeladene Transkripte und Unterlagen nur im Chat bzw. in OneDrive verwenden. Temporäre Kopien nach der Auswertung löschen.
- Der VVO-Leitfaden „Analysegespräch“ ist VVO-intern und liegt nicht im Repo (Hugo hat ihn).

## Technik-Hinweise

- **Cloud-Session:** Azure-Login blockiert (AADSTS530035). SQL ausführen und Ausrollen nur durch Hugo (Portal/Cloud Shell) oder in einer lokalen Session (`docs/BETRIEB.md` Abschnitt 5).
- **Lokale Session auf Hugos PC:** Stolpersteine in `docs/LOKALE-SESSION.md` Abschnitt 5. Zum Beispiel braucht `git push` aus der Claude-App eine eigene `hosts.yml` + `GH_CONFIG_DIR`, sonst wird das falsche GitHub-Konto verwendet. Auch PATH für `az`, `sqlcmd`, `dab` steht dort.
- **Connector:** Erster Aufruf nach Leerlauf braucht bis ca. 25 s (Kaltstart). Bei „Authorization failed“ in claude.ai neu verbinden. Bearbeitete Connectors lieber löschen und neu anlegen.
- Eine einmalige Erinnerung (geplante Aufgabe `hf-crm-erinnerung-erstinfo-aufzeichnung`, 07.12.2026) liegt nur lokal auf Hugos PC.

## Start-Prompt (in den neuen Chat kopieren)

```
Wir arbeiten am Repo HugoFigueiras-hfconsult/hf-crm. Lies zuerst CLAUDE.md und HANDOVER.md,
dann docs/STATUS.md und agent/README.md. Erinnere mich an fällige Wiedervorlagen.
Danach machen wir mit dem Konzept-Termin für Neumandanten weiter (Fragen in
docs/09-neumandant.md): Ich beschreibe, was im Termin passiert, du leitest Ablauf,
Agent-Aufgaben und Felder ab. Erklär mir alles in einfacher Sprache, dokumentiere
jede Entscheidung im Repo und pushe nach jedem Schritt. Keine Mandantendaten ins Repo.
```
