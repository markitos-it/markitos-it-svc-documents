#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "❌ Error: Version is required"
    echo "Usage: make app-deploy-tag 1.2.3"
    exit 1
fi

VERSION=$1
TAG="v${VERSION}"

echo "🏷️  Creating and pushing tag: ${TAG}"

# Create tag
git tag -a "${TAG}" -m "Release ${TAG}"

# Push tag
git push origin "${TAG}"

echo "✅ Tag ${TAG} created and pushed"
echo "🚀 GitHub Actions will build and deploy automatically"
