#!/bin/bash
set -e

# Start PostgreSQL silently
bash bin/app/docker-postgres-start.sh

echo "🚀 Starting gRPC service..."

go run cmd/app/main.go
