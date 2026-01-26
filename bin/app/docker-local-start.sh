#!/bin/bash

set -e

cd "$(dirname "$0")/../.."

# Start PostgreSQL first
bash bin/app/docker-postgres-start.sh
bash bin/app/docker-local-build.sh

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


IMAGE_NAME="markitos-it-svc-documents"
TAG="local"
CONTAINER_NAME="markitos-svc-documents-local"

echo "🚀 Starting Docker container: ${IMAGE_NAME}:${TAG}"
echo "📡 gRPC endpoint: localhost:${GRPC_PORT}"

# Stop and remove existing container
docker stop "${CONTAINER_NAME}" 2>/dev/null || true
docker rm "${CONTAINER_NAME}" 2>/dev/null || true

# Run container
docker run -d \
    --name "${CONTAINER_NAME}" \
    -p ${GRPC_PORT}:${GRPC_PORT} \
    -e DB_HOST=host.docker.internal \
    -e DB_PORT=${DB_PORT} \
    -e DB_USER=${DB_USER} \
    -e DB_PASSWORD=${DB_PASSWORD} \
    -e DB_NAME=${DB_NAME} \
    -e GRPC_PORT=${GRPC_PORT} \
    "${IMAGE_NAME}:${TAG}"

echo "✅ Container started: ${CONTAINER_NAME}"
echo ""
echo "View logs: docker logs -f ${CONTAINER_NAME}"
echo "Stop: make app-docker-local-stop"
