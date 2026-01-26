#!/bin/bash
set -e

echo "🧹 Cleaning build artifacts..."

# Stop PostgreSQL
bash bin/app/docker-postgres-stop.sh

# Remove binary
if [ -f "bin/markitos-svc-documents" ]; then
    rm bin/markitos-svc-documents
    echo "✅ Removed binary"
fi

# Remove Docker image
if docker images | grep -q "markitos-it-svc-documents"; then
    docker rmi markitos-it-svc-documents:local 2>/dev/null || true
    echo "✅ Removed Docker image :local"
fi

echo "✨ Clean complete"
