#!/bin/bash
set -e

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not installed"
    exit 1
fi

# Check if PostgreSQL is running
if ! docker-compose ps markitos-it-svc-documents-postgres | grep -q "Up"; then
    echo "✅ PostgreSQL is already stopped"
    exit 0
fi

echo "🛑 Stopping PostgreSQL..."

# Stop PostgreSQL
docker-compose stop markitos-it-svc-documents-postgres

echo "✅ PostgreSQL stopped"
