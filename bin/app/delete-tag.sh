#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "❌ Error: Version is required"
    echo "Usage: make app-delete-tag 1.2.3"
    exit 1
fi

VERSION=$1
TAG="v${VERSION}"

echo "🗑️  Deleting tag: ${TAG}"

# Delete local tag
git tag -d "${TAG}" 2>/dev/null || echo "Tag ${TAG} not found locally"

# Delete remote tag
git push origin --delete "${TAG}" 2>/dev/null || echo "Tag ${TAG} not found remotely"

echo "✅ Tag ${TAG} deleted"
