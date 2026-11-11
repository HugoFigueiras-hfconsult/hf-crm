#!/bin/sh
# Containerstart: Discovery-Dokumente erzeugen, dann DAB (intern :5000) und Caddy (Ingress :8000) starten.
# Endet einer der beiden Prozesse, endet der Container → Container Apps startet ihn neu.
set -eu

: "${TENANT_ID:?TENANT_ID fehlt}"
: "${MCP_PUBLIC_ORIGIN:?MCP_PUBLIC_ORIGIN fehlt (z. B. https://mcp.hf-consult.de)}"
: "${MCP_SCOPE:?MCP_SCOPE fehlt (z. B. https://mcp.hf-consult.de/mcp/access_as_user)}"

ENTRA="https://login.microsoftonline.com/${TENANT_ID}/oauth2/v2.0"
mkdir -p /tmp/wellknown

# RFC 9728: Wer schützt diese Ressource? → unser eigener Host (siehe Caddyfile, Punkt 2)
cat > /tmp/wellknown/oauth-protected-resource.json <<JSON
{
  "resource": "${MCP_PUBLIC_ORIGIN}/mcp",
  "resource_name": "HF-CRM",
  "authorization_servers": ["${MCP_PUBLIC_ORIGIN}"],
  "scopes_supported": ["${MCP_SCOPE}"],
  "bearer_methods_supported": ["header"]
}
JSON

# RFC 8414: Wo meldet man sich an? → Entra. Keine registration_endpoint (kein DCR) → claude.ai
# verlangt "Use your own OAuth client" (Client-ID + Secret der Entra-App hf-crm-mcp).
cat > /tmp/wellknown/oauth-authorization-server.json <<JSON
{
  "issuer": "${MCP_PUBLIC_ORIGIN}",
  "authorization_endpoint": "${ENTRA}/authorize",
  "token_endpoint": "${ENTRA}/token",
  "response_types_supported": ["code"],
  "grant_types_supported": ["authorization_code", "refresh_token"],
  "code_challenge_methods_supported": ["S256"],
  "token_endpoint_auth_methods_supported": ["client_secret_post", "client_secret_basic", "none"],
  "scopes_supported": ["${MCP_SCOPE}", "offline_access"]
}
JSON

export XDG_DATA_HOME=/tmp/caddy-data XDG_CONFIG_HOME=/tmp/caddy-config

dotnet Azure.DataApiBuilder.Service.dll &
DAB_PID=$!
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
CADDY_PID=$!

trap 'kill "$DAB_PID" "$CADDY_PID" 2>/dev/null; exit 0' TERM INT

while kill -0 "$DAB_PID" 2>/dev/null && kill -0 "$CADDY_PID" 2>/dev/null; do
  sleep 2
done
echo "DAB oder Caddy beendet, Container stoppt." >&2
kill "$DAB_PID" "$CADDY_PID" 2>/dev/null || true
exit 1
