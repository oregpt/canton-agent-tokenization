#!/bin/bash
set -e

echo "🚀 Installing DAML SDK..."

# Install DAML using the official installer
curl -sSL https://get.daml.com/ | sh
export PATH="$HOME/.daml/bin:$PATH"

echo "🔨 Building DAML project..."
daml build

echo "✅ Build complete"