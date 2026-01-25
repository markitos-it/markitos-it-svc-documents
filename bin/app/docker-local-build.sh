#!/bin/bash
set -e

echo "🐳 Building Docker image..."

IMAGE_NAME="markitos-it-svc-documents"
TAG="local"

docker build -t "${IMAGE_NAME}:${TAG}" .

echo "✅ Docker image built: ${IMAGE_NAME}:${TAG}"
