# Lokale Claude-Code-Session auf Hugos Windows-PC

**Warum lokal:** Azure-Anmeldung aus der Claude-Cloud-Session wird von den Security Defaults des Tenants `hf-consult.de` blockiert (AADSTS530035, siehe LOG 2026-11-11). Lokal meldet sich Hugo normal im Browser an, von seinem registrierten Gerät. Der Agent kann dann alle `az`-Befehle selbst ausführen.

## 1. Einmalige Vorbereitung (Hugo, PowerShell)

```powershell
winget install --id Git.Git -e
```

```powershell
winget install --id Microsoft.AzureCLI -e
```

```powershell
winget install --id Microsoft.Sqlcmd -e
```

`sqlcmd` ist erst für DB-User/Migrationen nötig (Phase 4.8). Alternativ: Portal → SQL-Datenbank → Abfrage-Editor.
Nach der Installation ein **neues** Terminal öffnen, damit `git`/`az` im PATH sind.

Repo holen (in Git Bash oder PowerShell):

```bash
git clone https://github.com/HugoFigueiras-hfconsult/hf-crm.git
```

Claude Code starten: Claude-Desktop-App → „Code“ → lokalen Ordner `hf-crm` wählen, **oder** im Terminal im Ordner `hf-crm`: `claude`.

## 2. Start-Prompt (in die lokale Session kopieren)

```
Lies CLAUDE.md, docs/STATUS.md, docs/LOG.md und docs/LOKALE-SESSION.md.
Wir sind auf meinem Windows-PC. Ziel heute: Azure SQL (Free Offer) aufsetzen und den
HF-CRM MCP Server so weit bringen, dass sich Claude per Custom Connector verbinden kann.
Das DB-Schema definieren wir erst morgen. Arbeite die Schritte in docs/LOKALE-SESSION.md
Abschnitt 3 ab, dokumentiere jede Aktion in docs/LOG.md + docs/STATUS.md und pushe nach
jedem abgeschlossenen Schritt.
```

## 3. Ablauf für den Agenten

Alle Skripte sind Bash. Unter Windows **in Git Bash** ausführen (`"C:\Program Files\Git\bin\bash.exe"`), nicht in PowerShell. `infra/00-vars.sh` setzt `MSYS_NO_PATHCONV=1` und übergibt JSON an `az rest` immer als Datei.

| # | Schritt | Befehl | Stopp-Kriterium |
|---|---|---|---|
| 1 | Tools prüfen | `git --version`, `az version`, `bash --version` | fehlt etwas → Hugo installiert (Abschnitt 1) |
| 2 | Login | `az login` (öffnet Browser, **Hugo** meldet sich an + MFA) | Fehler → Code + Meldung ins LOG, Hugo fragen |
| 3 | **Tenant prüfen (R1)** | `az account list -o table` und `az rest --method get --uri "https://graph.microsoft.com/v1.0/organization?\$select=id,displayName,verifiedDomains"` | Abo-Tenant ≠ Tenant mit verifizierter Domain `hf-consult.de` → **STOPP**, Hugo entscheidet (Abo verschieben) |
| 4 | IDs eintragen | `SUBSCRIPTION_ID`, `TENANT_ID` in `infra/00-vars.sh`, LOG, commit + push | – |
| 5 | Budget | Hugo nach Alarm-E-Mail fragen, dann `BUDGET_EMAIL=… ./infra/01-budget.sh` | E-Mail nie ins Repo/LOG |
| 6 | SQL | `./infra/02-rg-sql.sh` (zeigt Kontext), dann `CONFIRMED=j ./infra/02-rg-sql.sh` | Servername belegt → neuen Suffix, LOG |
| 7 | Push | LOG + STATUS (Phase 1/2 ✅, Ressourcentabelle), commit + push | – |
| 8 | Connector-Vorbereitung | siehe Abschnitt 4 | – |

## 4. Weg zum Claude-Connector (Phase 4 + 5)

Reihenfolge, weil die Schritte voneinander abhängen:

1. **DAB ohne Entities testen:** Startet DAB 2.x mit `"entities": {}`? Lokal prüfen: `dotnet tool install -g Microsoft.DataApiBuilder`, dann `dab validate -c dab/dab-config.json` (Env-Variablen mit Dummy-Werten setzen). Schlüsselnamen unter `runtime.mcp` dabei verifizieren.
   - Startet DAB **nicht** ohne Entity: Hugo fragen. Option: vorläufige technische Test-Tabelle als **Vorschlag** (`db/migrations/000_verbindungstest.sql`, `-- STATUS: VORSCHLAG`). Ohne Freigabe nicht anlegen (Schemaänderungen nur durch Hugo).
2. **Image bauen:** GitHub → Actions → „DAB-Image bauen und nach GHCR pushen“ → Run workflow. Exakten DAB-Tag vorher in `dab/Dockerfile` pinnen.
3. **GHCR-PAT:** Hugo erstellt PAT (nur `read:packages`) und gibt ihn selbst als `GHCR_PAT` im Terminal ein. Nie in Chat/Repo.
4. **Container App:** `GHCR_USER=hugofigueiras-hfconsult GHCR_PAT=… ./infra/03-containerapp.sh`
5. **DB-User für Managed Identity:** `./infra/02b-firewall-myip.sh add`, `./db/apply.sh db/setup/01_user_dab.sql`, `./infra/02b-firewall-myip.sh remove`
6. **Custom Domain:** `./infra/03b-custom-domain.sh records` → Hugo legt CNAME + TXT beim DNS-Anbieter an (O2) → `./infra/03b-custom-domain.sh bind`
7. **Entra-App:** `./infra/04-entra.sh` → danach `DAB_JWT_AUDIENCE` setzen (Befehl steht in der Ausgabe)
8. **Discovery prüfen (5.6):** `curl -i https://mcp.hf-consult.de/.well-known/oauth-protected-resource`
9. **Client Secret + Connector:** Hugo erzeugt das Secret selbst (Befehl aus 04-entra.sh-Ausgabe) und trägt es in claude.ai → Einstellungen → Connectors → Benutzerdefiniert ein (`docs/04-claude-connector.md`, 5.7)
10. **Test** im Claude-Chat (5.8). Fehlschläge nummeriert ins LOG; nach 2 ernsthaften Versuchen → Fallback-Entscheidung mit Hugo.

## Hinweise

- Cloud-Umgebung `hf-crm` (claude.ai) existiert für Cloud-Sessions, wird lokal nicht gebraucht.
- Zeilenenden: `.gitattributes` erzwingt LF für `.sh`/`.sql`. Falls ein Skript mit `$'\r': command not found` abbricht: `git config core.autocrlf false`, dann `git rm --cached -r . && git reset --hard`.
