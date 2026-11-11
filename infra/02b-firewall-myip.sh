#!/usr/bin/env bash
# Eigene IP TEMPORÄR in die SQL-Firewall (z. B. für Migrationen vom Laptop).
#   ./infra/02b-firewall-myip.sh add
#   ./infra/02b-firewall-myip.sh remove     # danach immer entfernen!
set -euo pipefail
source "$(dirname "$0")/00-vars.sh"
RULE=TempHugoLaptop

case "${1:-}" in
  add)
    IP=$(curl -fsS https://api.ipify.org)
    az sql server firewall-rule create -g "$RG" -s "$SQL_SERVER" -n "$RULE" \
      --start-ip-address "$IP" --end-ip-address "$IP" -o table
    echo "Regel $RULE aktiv. Nicht vergessen: '$0 remove'." ;;
  remove)
    az sql server firewall-rule delete -g "$RG" -s "$SQL_SERVER" -n "$RULE"
    echo "Regel $RULE entfernt." ;;
  *) echo "Aufruf: $0 add|remove"; exit 1 ;;
esac
