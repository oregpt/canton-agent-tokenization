#!/bin/bash
set -e

echo "🚀 Building Agent Tokenization with real DAML..."

# Always install DAML SDK - we want real DAML!
echo "🔨 Installing DAML SDK..."

# Install DAML with timeout and error handling
timeout 300 bash -c 'curl -sSL https://get.daml.com/ | sh' || {
  echo "❌ DAML installation timed out"
  exit 1
}

# Add DAML to PATH
export PATH="$HOME/.daml/bin:$PATH"

# Verify DAML installation
if ! command -v daml >/dev/null 2>&1; then
  echo "❌ DAML installation failed"
  exit 1
fi

echo "✅ DAML SDK installed successfully"

# Build the project
echo "🔨 Building DAML project..."
daml build

# Verify DAR file was created
if [ -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
  echo "✅ DAR file built successfully"
else
  echo "❌ DAR file build failed"
  exit 1
fi

echo "✅ Real DAML build complete!"