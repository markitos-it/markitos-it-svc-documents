#!/bin/bash

set -e

cd "$(dirname "$0")/../.."

bash bin/app/docker-postgres-start.sh

export GRPC_PORT=${GRPC_PORT:-8888}
export DB_HOST=${DB_HOST:-localhost}
export DB_PORT=${DB_PORT:-5432}
export DB_USER=${DB_USER:-admin}
export DB_PASSWORD=${DB_PASSWORD:-admin}
export DB_NAME=${DB_NAME:-markitos-it-svc-documents}

echo "🚀 Starting markitos-it-svc-documents (Go)..."
echo "📡 GRPC_PORT: $GRPC_PORT"
echo "🗄️  DB_HOST: $DB_HOST:$DB_PORT"
echo "👤 DB_USER: $DB_USER"
echo "📦 DB_NAME: $DB_NAME"
echo ""

go run cmd/app/main.go
