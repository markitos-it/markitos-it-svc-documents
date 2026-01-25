#!/bin/bash
set -e

# Start PostgreSQL first
bash bin/app/docker-postgres-start.sh

echo "🚀 Starting Docker container..."

IMAGE_NAME="markitos-it-svc-documents"
TAG="local"
CONTAINER_NAME="markitos-svc-documents-local"

# Stop and remove existing container
docker stop "${CONTAINER_NAME}" 2>/dev/null || true
docker rm "${CONTAINER_NAME}" 2>/dev/null || true

# Run new container
docker run -d \
    --name "${CONTAINER_NAME}" \
    -p 8888:8888 \
    --network host \
    "${IMAGE_NAME}:${TAG}"

echo "✅ Container started: ${CONTAINER_NAME}"
echo "📡 gRPC endpoint: localhost:8888"
echo ""
echo "View logs: docker logs -f ${CONTAINER_NAME}"
echo "Stop: make app-docker-local-stop"
