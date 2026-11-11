#!/usr/bin/env bash
# Führt eine SQL-Datei als Entra-Admin (Hugo) gegen die HF-CRM-DB aus.
#   ./db/apply.sh db/migrations/001_init.sql
# Voraussetzung: go-sqlcmd installiert, az login, eigene IP freigegeben (infra/02b-firewall-myip.sh add).
set -euo pipefail
source "$(dirname "$0")/../infra/00-vars.sh"
FILE="${1:?SQL-Datei angeben}"
if grep -q -- "-- STATUS: VORSCHLAG" "$FILE"; then
  echo "$FILE ist noch VORSCHLAG und nicht freigegeben. Abbruch."; exit 1
fi
sqlcmd -S "$SQL_FQDN" -d "$SQL_DB" --authentication-method ActiveDirectoryDefault -b -i "$FILE"
echo "OK: $FILE ausgeführt. LOG-Eintrag nicht vergessen."
