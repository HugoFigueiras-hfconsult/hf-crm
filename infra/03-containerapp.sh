#!/usr/bin/env bash
# Phase 4.7–4.9 – Container-App-Umgebung + DAB-Container (Consumption, scale-to-zero).
#
# Voraussetzungen:
#   - Image ${DAB_IMAGE} wurde per GitHub Action gebaut (.github/workflows/dab-image.yml)
#   - TENANT_ID in 00-vars.sh eingetragen; MCP_APP_CLIENT_ID nach Phase 5 (vorher Platzhalter ok,
#     dann später: az containerapp update ... --set-env-vars DAB_JWT_AUDIENCE=...)
#   - GHCR-Package hf-crm-dab ist ÖFFENTLICH (Entscheidung Hugo 2026-11-11, siehe 00-entscheidungen.md).
#     Image enthält nur die DAB-Config, keine Secrets → keine Registry-Credentials nötig.
#
#   ./infra/03-containerapp.sh
set -euo pipefail
source "$(dirname "$0")/00-vars.sh"
: "${TENANT_ID:?TENANT_ID in infra/00-vars.sh eintragen}"

echo "== Image anonym abrufbar? (Package muss öffentlich sein)"
IMG_REPO="${DAB_IMAGE#ghcr.io/}"; IMG_REPO="${IMG_REPO%%:*}"; IMG_TAG="${DAB_IMAGE##*:}"
GHCR_TOKEN=$(curl -fsS "https://ghcr.io/token?scope=repository:${IMG_REPO}:pull" | sed -E 's/.*"token":"([^"]+)".*/\1/')
# Kein "-o /dev/null": MSYS_NO_PATHCONV=1 (00-vars.sh) → Git Bash übersetzt /dev/null nicht → curl exit 23.
HTTP=$(curl -s -I -w '%{http_code}' \
  -H "Authorization: Bearer ${GHCR_TOKEN}" \
  -H "Accept: application/vnd.oci.image.index.v1+json, application/vnd.docker.distribution.manifest.v2+json" \
  "https://ghcr.io/v2/${IMG_REPO}/manifests/${IMG_TAG}" | tail -n1 | tr -d '\r')
[[ "$HTTP" == "200" ]] || { echo "Image ${DAB_IMAGE} nicht anonym abrufbar (HTTP $HTTP). Package auf GitHub öffentlich?"; exit 1; }
echo "ok (HTTP 200)"

az extension add --name containerapp --upgrade -y >/dev/null

echo "== Umgebung (ohne Log Analytics → keine Log-Kosten)"
az containerapp env create -g "$RG" -n "$CAE" -l "$LOC" \
  --logs-destination none \
  --query "{name:name, id:id}" -o table

# DAB prüft den Host-Header am MCP-Endpunkt (runtime.mcp.allowed-hosts in dab/dab-config.json).
# Der Standard-Hostname der App ist <app>.<defaultDomain der Umgebung>, also schon vor dem Anlegen bekannt.
CAE_DOMAIN=$(az containerapp env show -g "$RG" -n "$CAE" --query properties.defaultDomain -o tsv)
CA_FQDN="${CA}.${CAE_DOMAIN}"

CONNSTR="Server=tcp:${SQL_FQDN},1433;Database=${SQL_DB};Authentication=Active Directory Managed Identity;Encrypt=True;TrustServerCertificate=False;"

echo "== Container App"
az containerapp create -g "$RG" -n "$CA" --environment "$CAE" \
  --image "$DAB_IMAGE" \
  --ingress external --target-port 5000 \
  --min-replicas 0 --max-replicas 1 \
  --cpu 0.25 --memory 0.5Gi \
  --system-assigned \
  --secrets "dab-connstring=${CONNSTR}" \
  --env-vars \
      "DAB_CONNSTRING=secretref:dab-connstring" \
      "DAB_JWT_ISSUER=https://login.microsoftonline.com/${TENANT_ID}/v2.0" \
      "DAB_JWT_AUDIENCE=${MCP_APP_CLIENT_ID:-PLATZHALTER-NACH-PHASE-5}" \
      "DAB_CA_FQDN=${CA_FQDN}" \
  --query "{name:name, id:id, fqdn:properties.configuration.ingress.fqdn, principalId:identity.principalId}" -o table

echo
echo "Nächster Schritt (4.8): als Entra-Admin db/setup/01_user_dab.sql ausführen,"
echo "damit die Managed Identity '${CA}' auf die DB zugreifen darf:"
echo "  ./infra/02b-firewall-myip.sh add && ./db/apply.sh db/setup/01_user_dab.sql && ./infra/02b-firewall-myip.sh remove"
