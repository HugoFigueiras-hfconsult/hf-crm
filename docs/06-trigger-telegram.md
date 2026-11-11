# Phase 7 – Claude-Routine + Telegram-Trigger

Status: ⬜ offen. Erst nach Phase 5 (Connector läuft).

| # | Schritt | Detail | Status |
|---|---|---|---|
| 7.1 | Routine anlegen | claude.ai/code/routines, Trigger **API**. Fire-URL + Token sicher ablegen (nicht im Repo). Prompt muss `routine-fire-payload` explizit verarbeiten | ⬜ |
| 7.2 | Connectors der Routine | Nur HF-CRM-MCP + Microsoft 365. Genutzte M365-Tools auf „Always allow“ (sonst scheitern geplante Läufe) | ⬜ |
| 7.3 | Telegram-Bot | @BotFather → Bot-Token (Secret). Gruppe Hugo + Ehefrau | ⬜ |
| 7.4 | Cloudflare Worker | Webhook-Endpunkt, **Allowlist der Telegram-User-IDs**, ruft `/fire` mit Text. Cron alle 5 Min. für Graph-Delta (neue Mails/Termine), weckt Routine nur bei Relevanz, übergibt nur IDs | ⬜ |
| 7.5 | Antwortweg | Routine → Worker-Endpunkt → Telegram (Cloud-Umgebung: `api.telegram.org` ggf. in Custom-Allowlist) | ⬜ |
| 7.6 | Limits | `/fire`: 30/h pro Routine, 100/h pro Account | – |

Code für den Worker später unter `worker/` im Repo, Secrets als Worker-Secrets.

Quellen: https://code.claude.com/docs/en/routines · https://code.claude.com/docs/en/cloud-environments
