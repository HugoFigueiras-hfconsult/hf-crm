# DAB / SQL MCP Server für HF-CRM.
# Enthält nur die Config (keine Secrets). Connection String + JWT-Werte kommen als Env-Variablen
# aus der Container App (DAB_CONNSTRING, DAB_JWT_AUDIENCE, DAB_JWT_ISSUER).
#
# Tag fest gepinnt (geprüft 2026-11-11: 2.1.5 = neueste stabile Version auf MCR + NuGet, lokal getestet).
# Update: Tag hier ändern, lokal mit gleicher dab-Version testen (dotnet tool update -g Microsoft.DataApiBuilder --version X).
ARG DAB_TAG=2.1.5
FROM mcr.microsoft.com/azure-databases/data-api-builder:${DAB_TAG}

COPY dab-config.json /App/dab-config.json

# DAB lauscht im Container auf 5000 (Container-App target-port 5000).
EXPOSE 5000
