# CLAUDE.md – Arbeitsregeln für Agenten im Repo `hf-crm`

Dieses Repo dokumentiert Aufbau und Betrieb des HF-CRM (Azure SQL + SQL MCP Server).
**Es ist die einzige Quelle der Wahrheit.** Was nicht hier steht, ist nicht passiert.

## Orientierung (in dieser Reihenfolge lesen)

1. `docs/STATUS.md`: aktueller Stand, nächster Schritt, offene Punkte
2. `docs/LOG.md`: chronologisches Protokoll aller Aktionen
3. `docs/00-entscheidungen.md`: warum etwas so ist (nicht neu diskutieren ohne neuen Grund)
4. Die Phasen-Doku `docs/01-…` bis `docs/07-…` für den jeweiligen Schritt
5. `docs/HANDOVER-2026-11-11.md`: ursprüngliches Übergabedokument (historisch). **Dessen Schema-Entwurf (Phase 3) ist ungültig, nicht verwenden.**

## Harte Regeln

| Regel | Detail |
|---|---|
| Kosten | Ziel 0 €, Obergrenze 5 €/Monat. Budget-Alarm bei 5 €. Vor jeder neuen Ressource Kosten prüfen und in der Doku nennen |
| SQL Free Offer | `free-limit-exhaustion-behavior = AutoPause`, nie „BillOverUsage“ |
| Datensparsamkeit | Gesundheitsdaten (BU/PKV-Angaben) **nie** in DB-Feldern, die an Claude gehen. Prompts nur mit nötigen Feldern |
| Dokumente | PDFs, Policen, volle Transkripte → OneDrive/SharePoint. DB hält nur Zusammenfassung + Link |
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

- Sprache der Doku: Deutsch. Anrede Mandanten: immer „Du“.
- Namen/Region stehen zentral in `infra/00-vars.sh`. Skripte sourcen diese Datei.
- Skripte sind idempotent gedacht und brechen bei Fehlern ab (`set -euo pipefail`).
- Unsichere CLI-Flags sind im Skript mit `# VERIFIZIEREN:` markiert. Vor Ausführung mit `--help` prüfen und Ergebnis ins LOG.
- Status-Kennzeichnung in Doku: ⬜ offen · 🟡 vorbereitet (Skript da, nicht ausgeführt) · ✅ erledigt · ⛔ blockiert
