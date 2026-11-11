# DAB / SQL MCP Server für HF-CRM.
# Enthält nur die Config (keine Secrets). Connection String + JWT-Werte kommen als Env-Variablen
# aus der Container App (DAB_CONNSTRING, DAB_JWT_AUDIENCE, DAB_JWT_ISSUER).
#
# VERIFIZIEREN: exakten 2.x-Tag auf https://mcr.microsoft.com/artifact/mar/azure-databases/data-api-builder/tags
# prüfen und hier fest pinnen (kein "latest").
ARG DAB_TAG=2.0
FROM mcr.microsoft.com/azure-databases/data-api-builder:${DAB_TAG}

COPY dab-config.json /App/dab-config.json

# DAB lauscht im Container auf 5000 (Container-App target-port 5000).
EXPOSE 5000
