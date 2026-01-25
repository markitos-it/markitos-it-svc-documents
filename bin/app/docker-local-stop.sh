#!/bin/bash
set -e

echo "🛑 Stopping Docker containers..."

CONTAINER_NAME="markitos-svc-documents-local"

# Stop and remove app container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    docker stop "${CONTAINER_NAME}" 2>/dev/null || true
    docker rm "${CONTAINER_NAME}" 2>/dev/null || true
    echo "✅ App container stopped"
else
    echo "✅ App container is not running"
fi

# Stop PostgreSQL
bash bin/app/docker-postgres-stop.sh

echo "✅ All containers stopped"
