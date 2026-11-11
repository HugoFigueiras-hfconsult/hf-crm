#!/usr/bin/env bash
# Phase 4.7–4.9 – Container-App-Umgebung + DAB-Container (Consumption, scale-to-zero).
#
# Voraussetzungen:
#   - Image ${DAB_IMAGE} wurde per GitHub Action gebaut (.github/workflows/dab-image.yml)
#   - TENANT_ID in 00-vars.sh eingetragen; MCP_APP_CLIENT_ID nach Phase 5 (vorher Platzhalter ok,
#     dann später: az containerapp update ... --set-env-vars DAB_JWT_AUDIENCE=...)
#   - GHCR_USER / GHCR_PAT als Umgebungsvariablen (PAT nur mit read:packages). NIE ins Repo.
#
#   GHCR_USER=hugofigueiras-hfconsult GHCR_PAT=*** ./infra/03-containerapp.sh
set -euo pipefail
source "$(dirname "$0")/00-vars.sh"
: "${GHCR_USER:?GHCR_USER setzen}"
: "${GHCR_PAT:?GHCR_PAT setzen (read:packages)}"
: "${TENANT_ID:?TENANT_ID in infra/00-vars.sh eintragen}"

az extension add --name containerapp --upgrade -y >/dev/null

echo "== Umgebung (ohne Log Analytics → keine Log-Kosten)"
az containerapp env create -g "$RG" -n "$CAE" -l "$LOC" \
  --logs-destination none \
  --query "{name:name, id:id}" -o table

CONNSTR="Server=tcp:${SQL_FQDN},1433;Database=${SQL_DB};Authentication=Active Directory Managed Identity;Encrypt=True;TrustServerCertificate=False;"

echo "== Container App"
az containerapp create -g "$RG" -n "$CA" --environment "$CAE" \
  --image "$DAB_IMAGE" \
  --registry-server ghcr.io --registry-username "$GHCR_USER" --registry-password "$GHCR_PAT" \
  --ingress external --target-port 5000 \
  --min-replicas 0 --max-replicas 1 \
  --cpu 0.25 --memory 0.5Gi \
  --system-assigned \
  --secrets "dab-connstring=${CONNSTR}" \
  --env-vars \
      "DAB_CONNSTRING=secretref:dab-connstring" \
      "DAB_JWT_ISSUER=https://login.microsoftonline.com/${TENANT_ID}/v2.0" \
      "DAB_JWT_AUDIENCE=${MCP_APP_CLIENT_ID:-PLATZHALTER-NACH-PHASE-5}" \
  --query "{name:name, id:id, fqdn:properties.configuration.ingress.fqdn, principalId:identity.principalId}" -o table

echo
echo "Nächster Schritt (4.8): als Entra-Admin db/setup/01_user_dab.sql ausführen,"
echo "damit die Managed Identity '${CA}' auf die DB zugreifen darf:"
echo "  ./infra/02b-firewall-myip.sh add && ./db/apply.sh db/setup/01_user_dab.sql && ./infra/02b-firewall-myip.sh remove"
