#!/usr/bin/env bash
# Phase 4/5 – Bestehende Container App auf ein neues Image + aktuelle Einstellungen bringen.
# Idempotent. Für Neuanlage: infra/03-containerapp.sh.
#
# Aufruf:  IMAGE_TAG=<git-sha> ./infra/03c-update-app.sh
#   IMAGE_TAG = Commit-SHA des GitHub-Actions-Builds (Tag :<sha> statt :latest → neue Revision zieht
#   sicher das neue Image). Ohne IMAGE_TAG wird der aktuelle HEAD-Commit verwendet.
set -euo pipefail
source "$(dirname "$0")/00-vars.sh"
: "${TENANT_ID:?TENANT_ID in infra/00-vars.sh eintragen}"

IMAGE_TAG="${IMAGE_TAG:-$(git -C "$(dirname "$0")/.." rev-parse HEAD)}"
IMAGE="${DAB_IMAGE%:*}:${IMAGE_TAG}"

CAE_DOMAIN=$(az containerapp env show -g "$RG" -n "$CAE" --query properties.defaultDomain -o tsv)
CA_FQDN="${CA}.${CAE_DOMAIN}"

# Reihenfolge: erst neue Revision (Caddy lauscht auf 8000), dann Ingress auf 8000 umstellen.
echo "== Neue Revision mit Image ${IMAGE}"
SET_ENV=(
  "DAB_CA_FQDN=${CA_FQDN}"
  "TENANT_ID=${TENANT_ID}"
  "MCP_PUBLIC_ORIGIN=${MCP_PUBLIC_ORIGIN}"
  "MCP_SCOPE=${MCP_SCOPE}"
  "DAB_JWT_ISSUER=https://login.microsoftonline.com/${TENANT_ID}/v2.0"
)
if [[ -n "${MCP_APP_CLIENT_ID:-}" ]]; then SET_ENV+=("DAB_JWT_AUDIENCE=${MCP_APP_CLIENT_ID}"); fi

az containerapp update -g "$RG" -n "$CA" \
  --image "$IMAGE" \
  --set-env-vars "${SET_ENV[@]}" \
  --query "{revision:properties.latestRevisionName, image:properties.template.containers[0].image, running:properties.runningStatus}" -o table

echo "== Ingress → Caddy (Port 8000)"
az containerapp ingress update -g "$RG" -n "$CA" --target-port 8000 --query "{port:targetPort, fqdn:fqdn}" -o table
