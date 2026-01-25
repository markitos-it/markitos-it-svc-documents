#!/bin/bash

set -e

cd "$(dirname "$0")/../.."

# Start PostgreSQL silently
bash bin/app/docker-postgres-start.sh

# Export variables solo si no están definidas (desarrollo local)
export GRPC_PORT=${GRPC_PORT:-8888}
export DB_HOST=${DB_HOST:-localhost}
export DB_PORT=${DB_PORT:-5432}
export DB_USER=${DB_USER:-documents_user}
export DB_PASSWORD=${DB_PASSWORD:-postgres123}
export DB_NAME=${DB_NAME:-documents_db}

echo "🚀 Starting markitos-it-svc-documents (Go)..."
echo "📡 GRPC_PORT: $GRPC_PORT"
echo "🗄️  DB_HOST: $DB_HOST:$DB_PORT"
echo "👤 DB_USER: $DB_USER"
echo "📦 DB_NAME: $DB_NAME"
echo ""

go run cmd/app/main.go
