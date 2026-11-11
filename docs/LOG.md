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

### Lokale Session (Hugos Windows-PC, Claude Code Desktop)

- **Hugo**: `winget install --id Git.Git -e` (Upgrade auf 2.56.0.windows.4), `winget install --id Microsoft.AzureCLI -e` (2.92.0, 64 Bit). → ok
- **Hugo**: `gh auth login` mit `HugoFigueiras-hfconsult` (zweites Konto neben `ChasingPixel`), `gh auth setup-git`. Repo geklont. → ok
- **Hinweis Agent-Shell**: Die Claude-Desktop-App (MSIX) sieht eine virtualisierte Kopie von `%APPDATA%\GitHub CLI\hosts.yml` (nur `ChasingPixel`) → `git push` meldet „Repository not found“. Lösung: eigene `hosts.yml` mit `user: HugoFigueiras-hfconsult` außerhalb von AppData, `GH_CONFIG_DIR` darauf setzen. Token kommt aus dem Windows-Schlüsselbund. → Push ok
- **Hugo**: `az login` (Windows-Kontoauswahl, `hugo.figueiras@hf-consult.de`, MFA). → ok, **kein** AADSTS530035 lokal
- **Agent**: Tenant-Prüfung (R1):
  - `az account list` → 1 Abo: „Azure subscription 1“, `b349b1a4-88aa-4b1f-82bf-8b24bbe47daa`, Tenant `14cc25a5-e8d0-4504-90dc-cb97d813d29c`, Enabled
  - `GET /subscriptions/{id}` → `quotaId = FreeTrial_2014-09-01`, `spendingLimit = On` (= die Testversion, Anzeigename ist nicht „Kostenlose Testversion“)
  - `GET graph/v1.0/organization` → `14cc25a5-…`, „HF Consulting“, verifizierte Domains `hfconsult.onmicrosoft.com`, `hf-consult.de`
  - **Ergebnis: R1 erledigt.** Verzeichnis „HF Consulting“ **ist** der M365-Tenant `hf-consult.de`. Kein Verschieben nötig.
  - `az group list` → keine Ressourcengruppen.
- **Agent**: `SUBSCRIPTION_ID`, `TENANT_ID` in `infra/00-vars.sh` eingetragen.
- **Hugo**: Budget-Alarm (Phase 1.4, `infra/01-budget.sh`) **verschoben**, wird an einem anderen Tag eingerichtet. Schutz bis dahin: Testversion mit aktivem Ausgabenlimit (`spendingLimit = On`). O8 bleibt offen.
- **Agent**: `./infra/02-rg-sql.sh` (CONFIRMED=j) → Abbruch bei 2.2: `MissingSubscriptionRegistration` für `Microsoft.Sql`. Neues Skript `infra/01b-providers.sh` (registriert `Microsoft.Sql`, `Microsoft.App`, kostenlos) ausgeführt → beide `Registered`.
- **Agent**: `CONFIRMED=j ./infra/02-rg-sql.sh` erneut → ok. Kosten: 0 € (Free Offer, AutoPause bei Erschöpfung, Backup lokal).
  - RG `rg-hf-crm` (germanywestcentral): `/subscriptions/b349b1a4-88aa-4b1f-82bf-8b24bbe47daa/resourceGroups/rg-hf-crm`
  - SQL-Server `sql-hf-crm-106af6` (Suffix war frei), FQDN `sql-hf-crm-106af6.database.windows.net`, nur Entra-Auth, Admin `hugo.figueiras@hf-consult.de`, TLS 1.2, öffentlicher Zugriff an (Firewall regelt)
  - DB `hfcrm`: `GP_S_Gen5`, 2 vCores max / 0,5 min, Serverless, `useFreeLimit = true`, `freeLimitExhaustionBehavior = AutoPause`, AutoPause-Verzögerung 60 min, Backup `Local`, Status Online
  - Firewall `AllowAllWindowsAzureIps` (0.0.0.0) für Container App + Copilot Studio

### Phase 4: DAB lokal geprüft (O6, O7)

- **Agent**: `winget install --id Microsoft.DotNet.SDK.10 -e` (10.0.404), `dotnet tool install -g Microsoft.DataApiBuilder --version 2.1.5`. 2.1.5 = neueste stabile Version (NuGet + MCR, veröffentlicht 2026-10-01), Tool braucht .NET 10. → ok
- **Agent**: `dab validate` mit Dummy-Werten → 2 Fehler im Config-Schema: Provider heißt `EntraID` (nicht `EntraId`). → korrigiert. `$schema` auf v2.1.5 gepinnt.
- **Agent**: Neue Pflicht-Einstellung in DAB 2.1: `runtime.mcp.allowed-hosts` (Schutz gegen DNS-Rebinding). Standard = nur localhost. Eingetragen: `mcp.hf-consult.de` + `@env('DAB_CA_FQDN')` (Standard-Hostname der Container App, setzt `infra/03-containerapp.sh`).
- **Agent**: `./infra/02b-firewall-myip.sh add` (Regel `TempHugoLaptop`, eigene IP), `dab validate` gegen die echte DB (Auth: `Active Directory Default` = Hugos `az login`):
  - **O7 beantwortet: DAB 2.1.5 startet NICHT ohne Entities** („At least one entity must be defined or discovered from autoentities“).
  - Lösung **ohne Schemaänderung**: Platzhalter-Entity `Verbindungstest` auf der System-View `INFORMATION_SCHEMA.TABLES` (nur lesen, nur Rolle `authenticated`, zeigt nur Tabellennamen). → `Config is valid`. Wird entfernt, sobald echte Entities da sind. Keine Test-Tabelle angelegt.
- **Agent**: `dab start` lokal (Port 5055) mit Platzhalter:
  - MCP `initialize` → 200, `serverInfo: SQL MCP Server 2.1.5`, auch **ohne** Token (Tools sind rollenabhängig)
  - Host `mcp.hf-consult.de` → 200, fremder Host → **403** („not in the list of trusted hosts“). allowed-hosts wirkt.
  - **O6 beantwortet: `/.well-known/oauth-protected-resource` → 400**, DAB 2.1.5 liefert dieses Discovery-Dokument nicht. Folge für Phase 5 siehe STATUS (R5).
- **Agent**: `./infra/02b-firewall-myip.sh remove` → nur noch `AllowAllWindowsAzureIps`. Lokalen DAB-Prozess beendet.
- **Agent**: `dab/Dockerfile` auf `DAB_TAG=2.1.5` gepinnt. Image-Config geprüft: lauscht auf `:5000`, Arbeitsordner `/App` → passt zu Dockerfile + `--target-port 5000`.
- **Agent**: `infra/03-containerapp.sh`: setzt `DAB_CA_FQDN=<app>.<defaultDomain der Umgebung>`.
- **Agent**: `gh workflow run dab-image.yml --ref main` → Run `43113418463` (Commit `72533ba`) → **success**. Image `ghcr.io/hugofigueiras-hfconsult/hf-crm-dab:latest` + `:72533baa68287a3fada8103eda0fbb42df428ea6` (DAB 2.1.5). Package ist privat (Standard). Sichtbarkeit nicht per API geprüft: der `gh`-Token hat kein `read:packages`.
- **Hugo**: Entscheidung: GHCR-Package `hf-crm-dab` wird **öffentlich** (statt PAT). → `infra/03-containerapp.sh` ohne Registry-Login, prüft vorab anonymen Abruf (HTTP 200). Doku + `00-entscheidungen.md` angepasst. R4 erledigt.
