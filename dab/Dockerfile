# DAB / SQL MCP Server für HF-CRM, mit Caddy als Türsteher davor (siehe Caddyfile).
# Enthält nur Config (keine Secrets). Connection String, JWT-Werte, Tenant und öffentliche Adresse kommen
# als Env-Variablen aus der Container App (DAB_CONNSTRING, DAB_JWT_AUDIENCE, DAB_JWT_ISSUER, DAB_CA_FQDN,
# TENANT_ID, MCP_PUBLIC_ORIGIN, MCP_SCOPE).
#
# Tags fest gepinnt (geprüft 2026-11-11/12: DAB 2.1.5 = neueste stabile auf MCR + NuGet, lokal getestet;
# Caddy 2.11.9 = neueste 2.x auf Docker Hub).
# DAB-Update: Tag ändern, lokal mit gleicher dab-Version testen (dotnet tool update -g Microsoft.DataApiBuilder --version X).
ARG DAB_TAG=2.1.5
ARG CADDY_TAG=2.11.9

FROM caddy:${CADDY_TAG} AS caddy

FROM mcr.microsoft.com/azure-databases/data-api-builder:${DAB_TAG}

# Caddy ist ein statisches Go-Binary und läuft auch auf dem Azure-Linux-Basisimage von DAB.
COPY --from=caddy /usr/bin/caddy /usr/local/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh
COPY dab-config.json /App/dab-config.json

# Config beim Build prüfen (Defaults im Caddyfile greifen, echte Werte erst zur Laufzeit).
RUN chmod +x /start.sh && caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile

# DAB nur intern erreichbar; von außen kommt man nur über Caddy (Port 8000 = Container-App target-port).
ENV ASPNETCORE_URLS=http://127.0.0.1:5000
EXPOSE 8000

ENTRYPOINT ["/bin/sh", "/start.sh"]
