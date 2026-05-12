#!/bin/bash
set -e

echo "🚀 Starting Secrets Manager bootstrap..."

SECRET_ID="grafana/prod"
REGION="us-east-1"


command -v aws >/dev/null 2>&1 || { echo "AWS CLI not installed"; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "jq not installed"; exit 1; }


SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "$SECRET_ID" \
  --region "$REGION" \
  --query SecretString \
  --output text)

echo "🔐 Secrets fetched successfully"


cat <<EOF > .env
GRAFANA_ADMIN_USER=$(echo "$SECRET" | jq -r '.GRAFANA_ADMIN_USER')
GRAFANA_ADMIN_PASSWORD=$(echo "$SECRET" | jq -r '.GRAFANA_ADMIN_PASSWORD')
GRAFANA_ROOT_URL=$(echo "$SECRET" | jq -r '.GRAFANA_ROOT_URL')

SMTP_HOST=$(echo "$SECRET" | jq -r '.SMTP_HOST')
SMTP_USER=$(echo "$SECRET" | jq -r '.SMTP_USER')
SMTP_PASSWORD=$(echo "$SECRET" | jq -r '.SMTP_PASSWORD')
SMTP_FROM=$(echo "$SECRET" | jq -r '.SMTP_FROM')
EOF

echo "📦 .env file created"


cd /app || exit 1

git pull origin main

docker compose --env-file .env up -d --build

echo " Grafana is running successfully"