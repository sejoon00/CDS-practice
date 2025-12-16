#!/bin/bash

# Configuration
BASE_URL="http://localhost:12345"
MAX_RETRIES=60
SLEEP_SECONDS=1

echo "=========================================="
echo " Starting Warmup Script"
echo " Target: $BASE_URL"
echo "=========================================="

# 1. Wait for Actuator Health
echo "[1/3] Waiting for application to be healthy..."
for i in $(seq 1 $MAX_RETRIES); do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/actuator/health")
    
    if [ "$HTTP_CODE" -eq 200 ]; then
        echo "✅ Service is UP (HTTP 200)"
        break
    else
        echo "⏳ Waiting for service... ($i/$MAX_RETRIES)"
        sleep $SLEEP_SECONDS
    fi
    
    if [ "$i" -eq "$MAX_RETRIES" ]; then
         echo "❌ Service failed to start within $((MAX_RETRIES * SLEEP_SECONDS)) seconds."
         exit 1
    fi
done

# 2. Warmup CoreHR API
echo ""
echo "[2/3] Warming up CoreHR API..."
CORE_URL="$BASE_URL/api/v2/corehr/companies/1/employees/1"
CORE_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$CORE_URL")
echo "👉 Request: GET $CORE_URL"
echo "   Response Code: $CORE_CODE"

# 3. Warmup Payroll API
echo ""
echo "[3/3] Warming up Payroll API..."
PAYROLL_URL="$BASE_URL/api/v2/payroll/companies/1/employees/1"
PAYROLL_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$PAYROLL_URL")
echo "👉 Request: GET $PAYROLL_URL"
echo "   Response Code: $PAYROLL_CODE"

echo ""
echo "=========================================="
echo " Warmup Completed"
echo "=========================================="
