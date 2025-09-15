#!/bin/bash
set -e

echo "🚀 Simple build for Render deployment..."

# Check if we're in a Render environment
if [ "$RENDER" = "true" ]; then
  echo "📦 Render deployment detected - using minimal build"

  # Install minimal dependencies
  apt-get update && apt-get install -y curl netcat-openbsd python3

  # Just verify our files exist
  if [ -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
    echo "✅ DAR file already built"
  else
    echo "⚠️ DAR file not found - will use mock API"
  fi
else
  echo "🔨 Local build - installing DAML SDK..."
  # Full DAML build for local development
  curl -sSL https://get.daml.com/ | sh
  export PATH="$HOME/.daml/bin:$PATH"
  daml build
fi

echo "✅ Build complete"