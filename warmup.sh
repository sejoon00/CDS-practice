#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Configuration (overrideable)
# -----------------------------
BASE_URL="${BASE_URL:-http://localhost:8080}"
MAX_RETRIES="${MAX_RETRIES:-60}"
SLEEP_SECONDS="${SLEEP_SECONDS:-1}"
WARMUP_COUNT="${WARMUP_COUNT:-100}"

CORE_URL="$BASE_URL/api/v2/corehr/companies/1/employees/1"
PAYROLL_URL="$BASE_URL/api/v2/payroll/companies/1/employees/1"

echo "=========================================="
echo " Starting Warmup Script"
echo " Target: $BASE_URL"
echo " Warmup Count: $WARMUP_COUNT"
echo "=========================================="

# 1) Wait for Actuator Health
echo "[1/3] Waiting for application to be healthy..."
for i in $(seq 1 "$MAX_RETRIES"); do
  HTTP_CODE="$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/actuator/health" || true)"
  if [ "$HTTP_CODE" -eq 200 ]; then
    echo "✅ Service is UP (HTTP 200)"
    break
  fi

  echo "⏳ Waiting for service... ($i/$MAX_RETRIES)"
  sleep "$SLEEP_SECONDS"

  if [ "$i" -eq "$MAX_RETRIES" ]; then
    echo "❌ Service failed to start within $((MAX_RETRIES * SLEEP_SECONDS)) seconds."
    exit 1
  fi
done

# 2) Warmup CoreHR API
echo ""
echo "[2/3] Warming up CoreHR API ($WARMUP_COUNT times)..."
for i in $(seq 1 "$WARMUP_COUNT"); do
  curl -s -o /dev/null "$CORE_URL"
  (( i % 10 == 0 )) && echo "  CoreHR warmup: $i/$WARMUP_COUNT"
done
echo "✅ CoreHR warmup completed"

# 3) Warmup Payroll API
echo ""
echo "[3/3] Warming up Payroll API ($WARMUP_COUNT times)..."
for i in $(seq 1 "$WARMUP_COUNT"); do
  curl -s -o /dev/null "$PAYROLL_URL"
  (( i % 10 == 0 )) && echo "  Payroll warmup: $i/$WARMUP_COUNT"
done
echo "✅ Payroll warmup completed"

echo ""
echo "=========================================="
echo " Warmup Completed"
echo "=========================================="