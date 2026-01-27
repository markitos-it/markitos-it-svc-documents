#!/bin/bash

set -e

cd "$(dirname "$0")/../.."

echo "🛑 Stopping markitos-it-svc-documents PostgreSQL..."
bash bin/app/docker-postgres-stop.sh
echo "✅ markitos-it-svc-documents PostgreSQL stopped."
echo
