#!/bin/bash

set -e

cd "$(dirname "$0")/../.."

IMAGE_NAME="markitos-it-svc-documents"
TAG="local"
CONTAINER_NAME="markitos-svc-documents-local"
PORT=8888

echo "🚀 Starting Docker container: ${IMAGE_NAME}:${TAG}"
echo "📡 gRPC endpoint: localhost:${PORT}"

# Stop and remove existing container
docker stop "${CONTAINER_NAME}" 2>/dev/null || true
docker rm "${CONTAINER_NAME}" 2>/dev/null || true

# Run container
docker run -d \
    --name "${CONTAINER_NAME}" \
    -p ${PORT}:${PORT} \
    -e DB_HOST=host.docker.internal \
    "${IMAGE_NAME}:${TAG}"

echo "✅ Container started: ${CONTAINER_NAME}"
echo ""
echo "View logs: docker logs -f ${CONTAINER_NAME}"
echo "Stop: make app-docker-local-stop"
