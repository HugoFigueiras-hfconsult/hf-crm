# CLAUDE.md – Arbeitsregeln für Agenten im Repo `hf-crm`

Dieses Repo dokumentiert Aufbau und Betrieb des HF-CRM (Azure SQL + SQL MCP Server).
**Es ist die einzige Quelle der Wahrheit.** Was nicht hier steht, ist nicht passiert.

## Orientierung (in dieser Reihenfolge lesen)

1. `docs/STATUS.md`: aktueller Stand, nächster Schritt, offene Punkte
2. `HANDOVER-CLOUD.md`: aktueller Auftrag (Schema, Phase 3) inkl. was die Cloud-Session kann und was nicht
3. `docs/ARCHITEKTUR.md`: Gesamtbild mit Diagrammen (was läuft wo, Login-Ablauf, Sicherheit)
4. `docs/BETRIEB.md`: Runbook: Tabellen freigeben, SQL ausführen, Image bauen/ausrollen, Logs, Fehlerbilder, Wartung
5. `docs/LOG.md`: chronologisches Protokoll aller Aktionen
6. `docs/00-entscheidungen.md`: warum etwas so ist (nicht neu diskutieren ohne neuen Grund)
7. Die Phasen-Doku `docs/01-…` bis `docs/07-…` für den jeweiligen Schritt; `docs/08-update-termin.md` = Arbeitsanweisung für Terminvorbereitung/-nachbereitung (Ablauf, Artefakte, Depot, Themen-Radar)
8. `docs/LOKALE-SESSION.md`: Setup + Stolpersteine für die lokale Session auf Hugos Windows-PC (Azure-Login nur dort möglich)
9. `HANDOVER-LOKAL.md` (erledigt) und `docs/HANDOVER-2026-11-11.md`: historisch. **Der Schema-Entwurf im Handover vom 2026-11-11 ist ungültig, nicht verwenden.**

## Harte Regeln

| Regel | Detail |
|---|---|
| Kosten | Ziel 0 €, Obergrenze 5 €/Monat. Budget-Alarm bei 5 €. Vor jeder neuen Ressource Kosten prüfen und in der Doku nennen |
| SQL Free Offer | `free-limit-exhaustion-behavior = AutoPause`, nie „BillOverUsage“ |
| Datensparsamkeit | ⏸ **Vorerst ausgesetzt (Hugo, 2026-11-12):** Datenschutz/AVV löst Hugo später mit einem Claude-Team-Account; bis dahin keine Datenschutz-Einschränkungen im Konzept. Danach neu bewerten. Ursprünglich: Gesundheitsdaten (BU/PKV) nie in DB-Feldern, die an Claude gehen |
| Dokumente | Originaldateien (PDFs, Policen, **Transkripte**) → OneDrive, Ordner je Mandant. DB hält Zusammenfassung + Link (z. B. `Termin.TranskriptLink`). Volltexte **nicht** über Claude in die DB kopieren (Claude müsste sie abschreiben: Output-Tokens, Zeit, Kopierfehler). Entscheidung 2026-11-12, siehe `docs/02-schema.md` Entscheidung 5 |
| Schema | Portabel: nur Standardtypen, keine Trigger/Funktionen/Stored Procedures, Logik im Agenten |
| Schreibrechte Agent | Datensätze frei. **Schemaänderungen nur als Vorschlag** an Hugo (neue Datei `db/migrations/NNN_*.sql` mit Status „Vorschlag“) |
| Secrets | Nie ins Repo. GitHub Secrets / Container-App-Secrets / Managed Identity |
| Login/Zahlungsdaten | Gibt Hugo selbst ein, nie der Agent |

## Dokumentationspflicht (bei jeder Aktion)

1. Befehl als Skript in `infra/` (oder SQL in `db/migrations/`), keine reinen Portal-Klicks. Ist ein Portal-Schritt unvermeidbar, im Phasen-Dokument Klickpfad beschreiben.
2. Eintrag in `docs/LOG.md`: Datum, wer (Hugo/Agent), Befehl/Skript, Ergebnis, Ressourcen-IDs **ohne Secrets**.
3. `docs/STATUS.md` aktualisieren (Status-Tabelle + „Nächster Schritt“).
4. Commit + Push direkt nach jeder abgeschlossenen Aktion, damit Hugo auf dem Laptop per `git pull` weiterarbeiten kann. Keine Arbeit, die nur in einem Container liegt.

## Konventionen

- Ausführungsort: Azure-Befehle nur in einer **lokalen** Session auf Hugos PC (Git Bash) oder durch Hugo selbst (Portal/Cloud Shell). Aus Claude-Cloud-Sessions ist `az login` blockiert (AADSTS530035). Übersicht „was geht von wo“: `docs/BETRIEB.md` Abschnitt 5.
- DAB-Änderungen (Entities, Rechte, Türsteher) = Repo ändern → Image bauen → ausrollen per Commit-SHA. Umgebungswerte (Tenant, Client-ID, DB) = Einstellungen der Container App. Siehe `docs/BETRIEB.md`.
- Entities werden **ausdrücklich** in `dab/dab-config.json` freigegeben, keine `autoentities` (Datensparsamkeit).
- Sprache der Doku: Deutsch. Anrede Mandanten: immer „Du“.
- Namen/Region stehen zentral in `infra/00-vars.sh`. Skripte sourcen diese Datei.
- Skripte sind idempotent gedacht und brechen bei Fehlern ab (`set -euo pipefail`).
- Unsichere CLI-Flags sind im Skript mit `# VERIFIZIEREN:` markiert. Vor Ausführung mit `--help` prüfen und Ergebnis ins LOG.
- Status-Kennzeichnung in Doku: ⬜ offen · 🟡 vorbereitet (Skript da, nicht ausgeführt) · ✅ erledigt · ⛔ blockiert
