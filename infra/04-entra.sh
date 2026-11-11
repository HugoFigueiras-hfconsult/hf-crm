#!/usr/bin/env bash
# Phase 5.1–5.5 – Entra-App-Registrierung "hf-crm-mcp" für den Claude Custom Connector.
#
# Voraussetzungen:
#   - Domain hf-consult.de ist im SELBEN Tenant verifiziert (Risiko R1!)
#   - Custom Domain mcp.hf-consult.de gebunden (infra/03b-custom-domain.sh)
#
# Das Client Secret erzeugt dieses Skript NICHT (siehe Ende), damit es nicht in Logs/Terminal-History landet.
set -euo pipefail
source "$(dirname "$0")/00-vars.sh"

echo "== 5.1 App-Registrierung (Single-Tenant) + 5.3 Redirect URI"
APP_ID=$(az ad app create \
  --display-name "$ENTRA_APP_MCP" \
  --sign-in-audience AzureADMyOrg \
  --web-redirect-uris "$CLAUDE_REDIRECT_URI" \
  --query appId -o tsv)
APP_OBJ=$(az ad app show --id "$APP_ID" --query id -o tsv)
echo "Client-ID: $APP_ID  (in infra/00-vars.sh als MCP_APP_CLIENT_ID eintragen)"

echo "== 5.2 Application ID URI = exakte MCP-URL (sonst AADSTS9010010)"
az ad app update --id "$APP_ID" --identifier-uris "$MCP_URL"

echo "== Scope access_as_user + v2-Tokens"
SCOPE_ID=$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen)
az rest --method PATCH \
  --uri "https://graph.microsoft.com/v1.0/applications/${APP_OBJ}" \
  --headers "Content-Type=application/json" \
  --body "{
    \"api\": {
      \"requestedAccessTokenVersion\": 2,
      \"oauth2PermissionScopes\": [{
        \"id\": \"${SCOPE_ID}\",
        \"value\": \"access_as_user\",
        \"type\": \"User\",
        \"isEnabled\": true,
        \"adminConsentDisplayName\": \"HF-CRM als Benutzer nutzen\",
        \"adminConsentDescription\": \"Erlaubt dem Client, im Namen des Benutzers auf den HF-CRM MCP Server zuzugreifen.\",
        \"userConsentDisplayName\": \"HF-CRM als Benutzer nutzen\",
        \"userConsentDescription\": \"Zugriff auf den HF-CRM MCP Server in deinem Namen.\"
      }]
    }
  }"

echo "== 5.5 Enterprise App: Zuweisung erforderlich, nur Hugo"
az ad sp create --id "$APP_ID" >/dev/null
SP_OBJ=$(az ad sp show --id "$APP_ID" --query id -o tsv)
az ad sp update --id "$APP_ID" --set appRoleAssignmentRequired=true
HUGO_OID=$(az ad signed-in-user show --query id -o tsv)
az rest --method POST \
  --uri "https://graph.microsoft.com/v1.0/servicePrincipals/${SP_OBJ}/appRoleAssignedTo" \
  --headers "Content-Type=application/json" \
  --body "{\"principalId\":\"${HUGO_OID}\",\"resourceId\":\"${SP_OBJ}\",\"appRoleId\":\"00000000-0000-0000-0000-000000000000\"}" \
  --query "{principal:principalDisplayName, resource:resourceDisplayName}" -o table

cat <<EOF

== Ergebnis (ins LOG, keine Secrets)
App-Name:      ${ENTRA_APP_MCP}
Client-ID:     ${APP_ID}
Object-ID:     ${APP_OBJ}
SP-Object-ID:  ${SP_OBJ}
App-ID-URI:    ${MCP_URL}
Scope:         ${MCP_URL}/access_as_user

== DAB-Audience setzen (v2-Token: 'aud' = Client-ID, NICHT die App-ID-URI)
az containerapp update -g ${RG} -n ${CA} --set-env-vars DAB_JWT_AUDIENCE=${APP_ID}
# VERIFIZIEREN: echtes Token unter https://jwt.ms dekodieren und 'aud'/'iss' prüfen.

== 5.4 Client Secret – Hugo führt SELBST aus, Wert direkt in Claude-Connector-Formular einfügen:
az ad app credential reset --id ${APP_ID} --append --display-name claude-connector --years 1 --query password -o tsv
# Nur das Ablaufdatum ins LOG schreiben:
az ad app credential list --id ${APP_ID} --query "[].{name:displayName, ende:endDateTime}" -o table
EOF
