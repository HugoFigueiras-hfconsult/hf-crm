#!/usr/bin/env bash
# Phase 1.4 – Monatsbudget 5 € mit E-Mail-Alarm bei 50 % / 100 % (Ist) und 100 % (Prognose).
# Nutzt die Consumption-Budgets-REST-API über `az rest`, weil `az consumption budget create`
# keine Benachrichtigungen setzen kann.
#
# Aufruf (E-Mail wird NICHT im Repo gespeichert):
#   BUDGET_EMAIL="hugo@hf-consult.de" ./infra/01-budget.sh
# Danach im Portal prüfen: Kostenverwaltung → Budgets → budget-hf-crm-5eur → Warnungen.
set -euo pipefail
source "$(dirname "$0")/00-vars.sh"

: "${BUDGET_EMAIL:?BUDGET_EMAIL setzen (Empfänger der Budget-Alarme)}"

SUB=$(az account show --query id -o tsv)
START=$(date -u +%Y-%m-01T00:00:00Z)   # muss der 1. eines Monats sein

BODY=$(cat <<JSON
{
  "properties": {
    "category": "Cost",
    "amount": ${BUDGET_AMOUNT},
    "timeGrain": "Monthly",
    "timePeriod": { "startDate": "${START}" },
    "notifications": {
      "Actual_50":       { "enabled": true, "operator": "GreaterThan", "threshold": 50,  "thresholdType": "Actual",     "contactEmails": ["${BUDGET_EMAIL}"] },
      "Actual_100":      { "enabled": true, "operator": "GreaterThan", "threshold": 100, "thresholdType": "Actual",     "contactEmails": ["${BUDGET_EMAIL}"] },
      "Forecasted_100":  { "enabled": true, "operator": "GreaterThan", "threshold": 100, "thresholdType": "Forecasted", "contactEmails": ["${BUDGET_EMAIL}"] }
    }
  }
}
JSON
)

# VERIFIZIEREN: api-version (falls abgelehnt: 2021-10-01 versuchen)
az rest --method put \
  --uri "https://management.azure.com/subscriptions/${SUB}/providers/Microsoft.Consumption/budgets/${BUDGET_NAME}?api-version=2023-05-01" \
  --body "$BODY" \
  --query "{name:name, amount:properties.amount, timeGrain:properties.timeGrain, start:properties.timePeriod.startDate}" -o table

echo "OK. Ins LOG: Budget ${BUDGET_NAME} (${BUDGET_AMOUNT} €/Monat) auf Abo ${SUB}. E-Mail NICHT ins LOG schreiben."
