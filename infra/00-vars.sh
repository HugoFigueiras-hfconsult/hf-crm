#!/usr/bin/env bash
# Zentrale Namen/Region für HF-CRM. KEINE Secrets in dieser Datei.
# Wird von allen anderen Skripten gesourct:  source "$(dirname "$0")/00-vars.sh"
#
# Werte, die erst nach einem Schritt bekannt sind, hier nachtragen und committen
# (IDs sind keine Secrets).

# --- Plattform ---------------------------------------------------------------
# Git Bash (Windows): verhindert, dass Argumente mit "/" in Windows-Pfade umgewandelt werden.
export MSYS_NO_PATHCONV=1
# Temp-Dateien für JSON-Bodies (az unter Windows zerlegt Inline-JSON, daher immer @datei)
HFCRM_TMP="${TMPDIR:-${TEMP:-/tmp}}/hf-crm"; mkdir -p "$HFCRM_TMP"
new_uuid() { cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null \
  || powershell.exe -NoProfile -Command "[guid]::NewGuid().ToString()" | tr -d '\r'; }

# --- Region / Gruppe ---------------------------------------------------------
LOC=germanywestcentral
RG=rg-hf-crm

# --- Azure SQL ---------------------------------------------------------------
# Global eindeutig. Suffix einmalig zufällig erzeugt (2026-11-11) und FIX.
# Falls der Name belegt ist: neuen Suffix wählen, hier eintragen, LOG-Eintrag.
SQL_SERVER=sql-hf-crm-106af6
SQL_DB=hfcrm
SQL_FQDN="${SQL_SERVER}.database.windows.net"

# --- Container Apps / DAB ----------------------------------------------------
CAE=cae-hf-crm
CA=ca-hf-crm-dab
DAB_IMAGE=ghcr.io/hugofigueiras-hfconsult/hf-crm-dab:latest   # GHCR verlangt Kleinbuchstaben
MCP_HOST=mcp.hf-consult.de
MCP_URL="https://${MCP_HOST}/mcp"

# --- Entra -------------------------------------------------------------------
ENTRA_APP_MCP=hf-crm-mcp          # App-Registrierung für Claude Custom Connector
ENTRA_APP_COPILOT=hf-crm-copilot  # Service Principal für Copilot Studio (nur lesen)
CLAUDE_REDIRECT_URI=https://claude.ai/api/mcp/auth_callback

# --- Budget ------------------------------------------------------------------
BUDGET_NAME=budget-hf-crm-5eur
BUDGET_AMOUNT=5                   # in Abrechnungswährung (EUR)

# --- Nach Ausführung nachtragen (keine Secrets) ------------------------------
SUBSCRIPTION_ID=""                # az account show --query id -o tsv
TENANT_ID=""                      # az account show --query tenantId -o tsv
MCP_APP_CLIENT_ID=""              # nach infra/04-entra.sh
