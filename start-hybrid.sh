#!/bin/bash
set -e

echo "🚀 Starting Real DAML Agent Tokenization System..."

# Verify DAML is available
if ! command -v daml >/dev/null 2>&1; then
  echo "❌ DAML SDK not found"
  exit 1
fi

if [ ! -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
  echo "❌ DAR file not found"
  exit 1
fi

echo "✅ DAML SDK and DAR file confirmed"

# Add DAML to PATH
export PATH="$HOME/.daml/bin:$PATH"

# Start DAML sandbox with persistent storage
echo "🔧 Starting DAML sandbox..."
daml sandbox \
  --port 6865 \
  --address 0.0.0.0 \
  --wall-clock-time \
  .daml/dist/*.dar &
SANDBOX_PID=$!

# Wait for sandbox to be ready
echo "⏳ Waiting for DAML sandbox to start..."
timeout 120 bash -c 'until nc -z 127.0.0.1 6865; do echo "Waiting for sandbox..."; sleep 3; done' || {
  echo "❌ DAML sandbox failed to start within 2 minutes"
  kill $SANDBOX_PID 2>/dev/null || true
  exit 1
}

echo "✅ DAML sandbox is ready!"

# Initialize the system with test data
echo "🔧 Initializing system with comprehensive test data..."
timeout 60 daml script \
  --dar .daml/dist/agent-tokenization-v3-3.0.0.dar \
  --script-name ComprehensiveV3Test:comprehensiveV3Test \
  --ledger-host 127.0.0.1 \
  --ledger-port 6865 || {
  echo "⚠️ System initialization failed, but sandbox is running"
}

# Start JSON API
echo "🌐 Starting DAML JSON API on port $PORT..."
exec daml json-api \
  --ledger-host 127.0.0.1 \
  --ledger-port 6865 \
  --http-port "$PORT" \
  --address 0.0.0.0 \
  --allow-insecure-tokens