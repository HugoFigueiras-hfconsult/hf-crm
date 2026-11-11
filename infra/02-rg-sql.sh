#!/usr/bin/env bash
# Phase 2 – Ressourcengruppe, SQL-Server (nur Entra-Auth, Hugo als Admin), DB im Free Offer.
# Voraussetzung: az login als Hugo, richtiges Abo aktiv, Risiko R1 (Tenant) geklärt.
set -euo pipefail
source "$(dirname "$0")/00-vars.sh"

echo "== Kontext"
az account show --query "{abo:name, id:id, tenant:tenantId, user:user.name}" -o table
read -r -p "Richtiges Abo und richtiger Tenant? [j/N] " ok; [[ "$ok" == "j" ]] || exit 1

echo "== CLI-Flags prüfen (Free Offer braucht aktuelle az-Version)"
az sql db create --help | grep -q -- "--use-free-limit" \
  || { echo "az zu alt: --use-free-limit fehlt. 'az upgrade' ausführen."; exit 1; }
az sql db create --help | grep -q -- "--free-limit-exhaustion-behavior" \
  || { echo "az zu alt: --free-limit-exhaustion-behavior fehlt."; exit 1; }

echo "== Servername frei?"
if getent hosts "${SQL_FQDN}" >/dev/null 2>&1 && ! az sql server show -g "$RG" -n "$SQL_SERVER" >/dev/null 2>&1; then
  echo "${SQL_FQDN} ist bereits vergeben. Neuen Suffix in infra/00-vars.sh eintragen."; exit 1
fi

echo "== 2.1 Ressourcengruppe"
az group create -n "$RG" -l "$LOC" --query "{name:name, id:id}" -o table

echo "== 2.2 SQL-Server (Entra-only, Hugo als Admin)"
HUGO_UPN=$(az ad signed-in-user show --query userPrincipalName -o tsv)
HUGO_OID=$(az ad signed-in-user show --query id -o tsv)
az sql server create -g "$RG" -n "$SQL_SERVER" -l "$LOC" \
  --enable-ad-only-auth \
  --external-admin-principal-type User \
  --external-admin-name "$HUGO_UPN" \
  --external-admin-sid "$HUGO_OID" \
  --minimal-tls-version 1.2 \
  --query "{name:name, id:id, fqdn:fullyQualifiedDomainName}" -o table

echo "== 2.3 Datenbank im Free Offer, AutoPause bei Erschöpfung"
# VERIFIZIEREN: --backup-storage-redundancy Local (hält Backups in der Region; im Free Offer enthalten)
az sql db create -g "$RG" -s "$SQL_SERVER" -n "$SQL_DB" \
  -e GeneralPurpose -f Gen5 -c 2 --compute-model Serverless \
  --backup-storage-redundancy Local \
  --use-free-limit \
  --free-limit-exhaustion-behavior AutoPause \
  --query "{name:name, id:id, sku:currentSku.name, freeLimit:useFreeLimit, exhaustion:freeLimitExhaustionBehavior}" -o table

echo "== 2.4 Kontrolle: Free Offer + AutoPause aktiv?"
az sql db show -g "$RG" -s "$SQL_SERVER" -n "$SQL_DB" \
  --query "{useFreeLimit:useFreeLimit, exhaustion:freeLimitExhaustionBehavior}" -o table
echo "Zusätzlich im Portal: DB → Übersicht → 'Free monthly vCore amount' sichtbar?"

echo "== 2.5 Firewall: Azure-Dienste erlauben (für Container App + Copilot Studio)"
az sql server firewall-rule create -g "$RG" -s "$SQL_SERVER" -n AllowAllWindowsAzureIps \
  --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0 -o table

echo "Fertig. IDs oben ins docs/LOG.md und docs/STATUS.md übertragen."
