#!/bin/bash
set -e

echo "🚀 Building Full DAML Agent Tokenization System..."

# Install system dependencies for DAML
apt-get update && apt-get install -y \
  curl \
  wget \
  netcat \
  unzip \
  openjdk-17-jdk \
  python3 \
  python3-pip

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH="$PATH:$JAVA_HOME/bin"

echo "☕ Java version:"
java -version

# Install DAML SDK with retries
echo "📥 Installing DAML SDK..."
for i in {1..3}; do
  echo "Attempt $i of 3..."
  if curl -sSL https://get.daml.com/ | sh; then
    echo "✅ DAML SDK installed successfully"
    break
  else
    echo "❌ DAML SDK installation failed, retrying..."
    sleep 10
  fi
done

export PATH="$HOME/.daml/bin:$PATH"

# Verify DAML installation
echo "🔍 Verifying DAML installation..."
if command -v daml >/dev/null 2>&1; then
  echo "✅ DAML command available"
  daml version
else
  echo "❌ DAML command not found after installation"
  # Try to find DAML manually
  find /root -name "daml" -type f 2>/dev/null || true
  find /home -name "daml" -type f 2>/dev/null || true
  exit 1
fi

# Build the DAML project with comprehensive V3 contracts
echo "🔨 Building DAML project..."
if daml build; then
  echo "✅ DAML build successful"

  # Verify DAR file was created
  if [ -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
    echo "✅ DAR file created: agent-tokenization-v3-3.0.0.dar"
    ls -la .daml/dist/
  else
    echo "❌ DAR file not found after build"
    ls -la .daml/dist/ || echo "dist directory not found"
    exit 1
  fi
else
  echo "❌ DAML build failed"
  exit 1
fi

# Install Canton for persistent deployment (optional)
echo "📦 Attempting to install Canton..."
if wget -q https://github.com/digital-asset/canton/releases/latest/download/canton-community-latest.tar.gz; then
  tar -xzf canton-community-latest.tar.gz
  mv canton-* canton
  export PATH="$PWD/canton/bin:$PATH"
  echo "✅ Canton installed successfully"
else
  echo "⚠️ Canton installation failed - will use DAML sandbox only"
fi

echo "✅ Full DAML build complete!"
echo "📦 Available components:"
echo "   • DAML SDK: $(daml version 2>/dev/null || echo 'Not available')"
echo "   • Canton: $(canton --version 2>/dev/null || echo 'Not available')"
echo "   • Java: $(java -version 2>&1 | head -1)"
echo "   • DAR file: $([ -f '.daml/dist/agent-tokenization-v3-3.0.0.dar' ] && echo 'Ready' || echo 'Missing')"