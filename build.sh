#!/bin/bash
set -e

echo "🚀 Installing Java and DAML SDK..."

# Install Java (required for DAML)
apt-get update
apt-get install -y openjdk-17-jdk

# Install DAML using the official installer
curl -sSL https://get.daml.com/ | sh
export PATH="$HOME/.daml/bin:$PATH"

echo "🔨 Building DAML project..."
daml build

echo "✅ Build complete"