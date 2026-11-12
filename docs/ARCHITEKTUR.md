# HF-CRM – Architektur (Stand 2026-11-12)

Kurz: **Claude fragt, Microsoft prüft, wer fragt, der Türsteher lässt nur Angemeldete durch, DAB übersetzt in SQL, die Datenbank antwortet.**
Alles läuft in Hugos Azure-Abo im Tenant `hf-consult.de` (Region Germany West Central), Kosten 0 € im Normalbetrieb.

## 1. Das Gesamtbild

```mermaid
flowchart LR
    subgraph Nutzer["Hugo"]
        C["Claude<br/>claude.ai / Desktop / Code<br/>Connector HF-CRM"]
    end

    subgraph Internet["Internet"]
        DNS["INWX DNS<br/>mcp.hf-consult.de<br/>CNAME → Azure"]
    end

    subgraph MS["Microsoft Entra ID (Tenant hf-consult.de)"]
        E["App hf-crm-mcp<br/>Login + MFA<br/>stellt Tokens aus"]
    end

    subgraph Azure["Azure-Abo (rg-hf-crm, Germany West Central)"]
        subgraph CA["Container App ca-hf-crm-dab (scale-to-zero)"]
            CADDY["Caddy = Türsteher<br/>Port 8000<br/>401 + Login-Hinweise"]
            DAB["DAB 2.1.5 = Übersetzer<br/>MCP-Tools → SQL<br/>prüft Token"]
        end
        SQL[("Azure SQL hfcrm<br/>Free Offer, AutoPause")]
    end

    subgraph GH["GitHub"]
        REPO["Repo hf-crm<br/>Doku + Skripte + Config"]
        GHCR["Image hf-crm-dab<br/>ghcr.io, öffentlich"]
    end

    C -- "1 Adresse nachschlagen" --> DNS
    C -- "2 MCP-Anfrage (HTTPS)" --> CADDY
    C <-. "3 Login + Token" .-> E
    CADDY -- "nur mit Token" --> DAB
    DAB -- "Managed Identity<br/>(kein Passwort)" --> SQL
    REPO -- "GitHub Actions baut" --> GHCR
    GHCR -- "Image ziehen" --> CA
```

| Baustein | Was es ist | Wo | Kosten |
|---|---|---|---|
| **Connector `HF-CRM`** | Eintrag in claude.ai, kennt Adresse + Client-ID + Secret | claude.ai (Hugos Konto) | – |
| **DNS-Eintrag `mcp`** | „Telefonbuch“: `mcp.hf-consult.de` zeigt auf die Container App | INWX | – |
| **Entra-App `hf-crm-mcp`** | Microsofts Ausweis-Stelle für den Connector; nur Hugo ist zugelassen | Entra ID | 0 € |
| **Caddy (Türsteher)** | Lässt nur Anfragen mit gültigem Login-Token durch, erklärt Claude, wo man sich anmeldet | im Container | 0 € |
| **DAB (Data API builder)** | Macht aus der Datenbank MCP-Werkzeuge (lesen, anlegen, ändern) und prüft das Token | im Container | 0 € |
| **Container App** | Die „Maschine“, auf der Caddy + DAB laufen; schläft, wenn niemand fragt | Azure | 0 € bis ≈ 200 h/Monat |
| **Azure SQL `hfcrm`** | Die eigentliche Datenbank | Azure | 0 € (pausiert statt zu kosten) |
| **GitHub-Repo + Image** | Bauplan (Skripte, Config, Doku) und fertiges Programmpaket | GitHub | 0 € |

## 2. Was bei einer Frage in Claude passiert (Login-Ablauf)

```mermaid
sequenceDiagram
    autonumber
    participant C as Claude
    participant T as Caddy (Türsteher)
    participant E as Microsoft Entra
    participant H as Hugo (Browser)
    participant D as DAB
    participant S as Azure SQL

    C->>T: MCP-Anfrage ohne Token
    T-->>C: 401 „Bitte anmelden, Infos unter /.well-known/…“
    C->>T: Wo meldet man sich an? (Discovery-Dokumente)
    T-->>C: Bei Microsoft (authorize + token), Scope access_as_user
    C->>H: Browser öffnet Microsoft-Login
    H->>E: hugo.figueiras@hf-consult.de + MFA
    E-->>C: Einmal-Code (über claude.ai/api/mcp/auth_callback)
    C->>E: Code + Client-ID + Client Secret
    E-->>C: Zugangs-Token (gültig ca. 1 h)
    C->>T: MCP-Anfrage MIT Token
    T->>D: durchreichen
    D->>D: Token prüfen (Aussteller = Tenant, Empfänger = hf-crm-mcp, Signatur)
    D->>S: SQL über Managed Identity
    S-->>D: Daten
    D-->>C: Ergebnis als MCP-Antwort
```

Schritte 1–9 passieren nur beim Verbinden (und wenn das Token abläuft). Danach laufen nur noch 10–15.

## 3. Sicherheitsschichten

```mermaid
flowchart TB
    A["Internet"] --> B["HTTPS-Zertifikat<br/>mcp.hf-consult.de"]
    B --> C1["Caddy: ohne Token → 401"]
    C1 --> D1["DAB: Token echt? für hf-crm-mcp? aus hf-consult.de?"]
    D1 --> E1["DAB-Rollen: anonym sieht nichts,<br/>angemeldet nur freigegebene Aktionen"]
    E1 --> F1["SQL-Rechte der App:<br/>lesen + schreiben, KEINE Schemaänderung"]
    F1 --> G1[("Daten")]
    H1["Entra: nur Hugo zugewiesen + MFA"] -.-> D1
    I1["SQL-Firewall: nur Azure-Dienste"] -.-> F1
```

- **Löschen** und **Prozeduren ausführen** sind in DAB abgeschaltet.
- **Schemaänderungen** (neue Tabellen/Spalten) kann nur Hugo als Entra-Admin der Datenbank, nie die App, nie Claude.
- **Keine Passwörter** zwischen App und Datenbank (Managed Identity). Das einzige Geheimnis ist das Client Secret im claude.ai-Connector (läuft 2028-11-11 ab).

## 4. Wie Änderungen live gehen

```mermaid
flowchart LR
    A["Änderung im Repo<br/>z. B. dab/dab-config.json"] --> B["git push"]
    B --> C["GitHub Actions:<br/>Image bauen (manuell starten)"]
    C --> D["ghcr.io/…/hf-crm-dab:&lt;commit&gt;"]
    D --> E["infra/03c-update-app.sh<br/>(lokal, mit az login)"]
    E --> F["neue Revision der Container App"]
```

Datenbank-Änderungen: SQL-Datei in `db/migrations/` als Vorschlag → Hugo gibt frei → `db/apply.sh` (lokal, kurz eigene IP in die Firewall).

## 5. Wo ist was (Spickzettel)

| Frage | Antwort |
|---|---|
| MCP-Adresse | `https://mcp.hf-consult.de/mcp` |
| Direktadresse (ohne eigene Domain) | `https://ca-hf-crm-dab.purpleflower-b72b09c0.germanywestcentral.azurecontainerapps.io` |
| Entra-App / Client-ID | `hf-crm-mcp` / `c3f40bf1-158a-4fff-8c08-de80976c7875` |
| Datenbank | `sql-hf-crm-106af6.database.windows.net`, DB `hfcrm` |
| Ressourcengruppe / Abo | `rg-hf-crm` / `b349b1a4-88aa-4b1f-82bf-8b24bbe47daa` |
| DNS | INWX (Konto auf Hugos privater E-Mail) |
| Alle Namen zentral | `infra/00-vars.sh` |
| Was ist wann passiert | `docs/LOG.md` · Stand + nächster Schritt: `docs/STATUS.md` |

## 6. Was noch fehlt

1. **Schema** (Phase 3): Tabellen für Mandanten, Termine, Verträge … → dann echte Entities statt Platzhalter `Verbindungstest`.
2. **Budget-Alarm** (O8) vor der Umstellung auf Pay-As-You-Go (11.12.2026).
3. Copilot Studio (nur lesen), Routine/Telegram, Dashboard (Phasen 6–8).
