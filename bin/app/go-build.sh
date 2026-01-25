#!/bin/bash
set -e

echo "🔨 Building Go application..."

OUTPUT="bin/markitos-svc-documents"

go build -o "${OUTPUT}" cmd/app/main.go

echo "✅ Binary built: ${OUTPUT}"
echo ""
echo "Run with: ./${OUTPUT}"
