#!/bin/bash
set -e

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not installed"
    exit 1
fi

# Check if PostgreSQL is already running
if docker-compose ps postgres | grep -q "Up"; then
    echo "✅ PostgreSQL is already running"
    exit 0
fi

echo "🐘 Starting PostgreSQL with Docker Compose..."

# Start PostgreSQL
docker-compose up -d postgres

echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 3

# Check if PostgreSQL is ready
docker-compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1

echo "✅ PostgreSQL is ready!"
