#!/usr/bin/env bash
# Phase 4.10 – Custom Domain mcp.hf-consult.de mit kostenlosem Managed Certificate.
# Nötig für Phase 5.2 (App-ID-URI https://mcp.hf-consult.de/mcp verlangt verifizierte Domain).
#
# Ablauf:
#   1) ./infra/03b-custom-domain.sh records   → zeigt die DNS-Einträge (CNAME + TXT)
#   2) Hugo legt die Einträge beim DNS-Anbieter an, wartet auf Propagation
#   3) ./infra/03b-custom-domain.sh bind      → Hostname + Managed Cert binden
set -euo pipefail
source "$(dirname "$0")/00-vars.sh"

FQDN=$(az containerapp show -g "$RG" -n "$CA" --query properties.configuration.ingress.fqdn -o tsv)
VERIFY_ID=$(az containerapp show -g "$RG" -n "$CA" --query properties.customDomainVerificationId -o tsv)

case "${1:-}" in
  records)
    echo "Beim DNS-Anbieter von hf-consult.de anlegen:"
    echo "  CNAME  mcp            → ${FQDN}"
    echo "  TXT    asuid.mcp      → ${VERIFY_ID}"
    ;;
  bind)
    az containerapp hostname add  -g "$RG" -n "$CA" --hostname "$MCP_HOST"
    az containerapp hostname bind -g "$RG" -n "$CA" --hostname "$MCP_HOST" \
      --environment "$CAE" --validation-method CNAME
    az containerapp hostname list -g "$RG" -n "$CA" -o table
    ;;
  *) echo "Aufruf: $0 records|bind"; exit 1 ;;
esac
