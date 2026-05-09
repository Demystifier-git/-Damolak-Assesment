#!/bin/bash
set -e

echo "🚀 Starting environment variable bootstrap..."

SECRET_ID="grafana/prod"
REGION="us-east-1"

# -----------------------------
# FETCH SECRET
# -----------------------------
SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "$SECRET_ID" \
  --region "$REGION" \
  --query SecretString \
  --output text)

echo "🔐 Secrets fetched successfully"

# -----------------------------
# EXPORT ENV VARS
# -----------------------------
export GRAFANA_ADMIN_USER=$(echo "$SECRET" | jq -r '.GRAFANA_ADMIN_USER')
export GRAFANA_ADMIN_PASSWORD=$(echo "$SECRET" | jq -r '.GRAFANA_ADMIN_PASSWORD')
export GRAFANA_ROOT_URL=$(echo "$SECRET" | jq -r '.GRAFANA_ROOT_URL')

export SMTP_HOST=$(echo "$SECRET" | jq -r '.SMTP_HOST')
export SMTP_USER=$(echo "$SECRET" | jq -r '.SMTP_USER')
export SMTP_PASSWORD=$(echo "$SECRET" | jq -r '.SMTP_PASSWORD')
export SMTP_FROM=$(echo "$SECRET" | jq -r '.SMTP_FROM')



sudo -i
git pull
docker compose up -d

echo "✅ Grafana is running"