# Setup-Log

Chronologisch, neueste Einträge **unten**. Pro Eintrag: Datum · wer · Aktion/Befehl · Ergebnis · Ressourcen-IDs (ohne Secrets).

---

## 2026-11-11

### Vorgeschichte (laut Handover, vor diesem Repo)

- **Hugo**: Azure-Abo „Kostenlose Testversion“ angelegt, Verzeichnis „HF Consulting“. USt: „I am not a Tax registered entity“ angehakt. Abo-ID noch nicht notiert.
- **Hugo**: M365 Admin Center → Copilot → Einstellungen → AI providers operating as Microsoft subprocessors → Anthropic aktiviert (verfügbar ab 07.01.2027).
- **Hugo**: Claude-Connector Microsoft 365 verbunden. Supabase/Neon nicht verbunden.
- Azure-Ressourcen: **keine**.

### Repo angelegt

- **Hugo**: GitHub-Account `HugoFigueiras-hfconsult` angelegt, privates Repo `hf-crm` erstellt (leer).
- **Agent** (Claude Code, Cloud-Session): Repo geklont, Initial-Commit (README + `docs/HANDOVER-2026-11-11.md`), Push nach `main`. → ok
- **Agent**: Dokumentationsstruktur angelegt: `CLAUDE.md`, `docs/STATUS.md`, `docs/LOG.md`, `docs/00…07`, `infra/00…04` (+ `02b`, `03b`), `db/apply.sh`, `db/setup/01_user_dab.sql`, `db/setup/02_user_copilot.sql`, `dab/dab-config.json` (ohne Entities), `dab/Dockerfile`, `.github/workflows/dab-image.yml` (nur manuell). → ok
- **Hugo**: Schema-Entwurf aus dem Handover (Phase 3) für **ungültig** erklärt. → Agent: Hinweis in Handover-Kopie, `docs/02-schema.md` = offen, keine Migration, keine DAB-Entities. Offener Punkt O3.
- **Agent**: SQL-Servername festgelegt: `sql-hf-crm-106af6` (Suffix zufällig, Verfügbarkeit wird in `infra/02-rg-sql.sh` geprüft).
- **Hinweis**: Alle Skripte sind **vorbereitet, nicht ausgeführt**. In der Cloud-Session gibt es kein `az` und kein Azure-Login (Login macht Hugo selbst).
- **Agent**: Risiko R1 (möglicher separater Entra-Tenant „HF Consulting“) in `docs/STATUS.md` aufgenommen. Muss vor Phase 2 geklärt werden.

### Azure-Zugang aus Claude-Cloud-Session (Versuch)

- **Agent**: Cloud-Umgebung `hf-crm` (persönlich) angelegt, erlaubt `management.azure.com`, `login.microsoftonline.com`, `graph.microsoft.com`, `aka.ms`, `azcliextensionsync.blob.core.windows.net`, `mcp.hf-consult.de`. Azure CLI 2.92.0 in der Session installiert. Free-Offer-Flags (`--use-free-limit`, `--free-limit-exhaustion-behavior`) in dieser Version vorhanden. → ok
- **Hugo**: `az login --use-device-code` mit `hugo.figueiras@hf-consult.de` → **blockiert, AADSTS530035** („Access has been blocked by security defaults“). Ursache: Die Sicherheitsstandards (Security Defaults) im Tenant `hf-consult.de` stufen die Gerätecode-Anmeldung aus der Cloud-Session als unsicher ein.
- **Entscheidung**: Security Defaults **nicht** abschalten (würde MFA-Pflicht für den ganzen Tenant entfernen). Azure-Befehle laufen stattdessen in der **Azure Cloud Shell** (Hugo bereits angemeldet). Agent bereitet die Befehle vor, Hugo fügt sie ein, Agent dokumentiert die Ausgaben.
- **Erkenntnis zu R1**: Das Konto `hugo.figueiras@hf-consult.de` meldet sich im Tenant `hf-consult.de` an. Ob das Azure-Abo in diesem Tenant liegt, ist noch offen (erster Cloud-Shell-Schritt).

### Vorbereitung lokale Session (Windows-PC)

- **Hugo**: Entscheidung, Azure-Setup in einer lokalen Claude-Code-Session auf dem Windows-PC fortzusetzen (Claude-Cloud-Session kann sich nicht anmelden, Edge-Tab lässt sich nicht an eine Cloud-Session übergeben).
- **Agent**: `docs/LOKALE-SESSION.md` angelegt (Installation per winget, Start-Prompt, Ablauf, Weg zum Connector). Skripte Git-Bash-tauglich gemacht: `MSYS_NO_PATHCONV=1`, JSON-Bodies für `az rest` als Datei, keine interaktiven Abfragen (`CONFIRMED=j`), `new_uuid` mit PowerShell-Fallback, kein `getent`. `.gitattributes` erzwingt LF. → ok
- **Offen**: O7 (DAB ohne Entities?), O8 (Budget-E-Mail).
