#!/usr/bin/env bash
# Phase 1.5 – Ressourcenanbieter (Resource Provider) im Abo registrieren.
# Neue Abos haben Microsoft.Sql / Microsoft.App nicht registriert → sonst
# "MissingSubscriptionRegistration" bei infra/02-rg-sql.sh bzw. 03-containerapp.sh.
# Registrierung ist kostenlos und einmalig pro Abo. Idempotent.
# Aufruf: ./infra/01b-providers.sh
set -euo pipefail
source "$(dirname "$0")/00-vars.sh"

PROVIDERS=(Microsoft.Sql Microsoft.App)

for p in "${PROVIDERS[@]}"; do
  echo "== $p registrieren"
  az provider register --namespace "$p" --wait
done

az provider list --query "[?contains('${PROVIDERS[*]}', namespace)].{namespace:namespace, state:registrationState}" -o table
