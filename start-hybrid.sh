#!/bin/bash
set -e

echo "🚀 Starting Agent Tokenization API..."

# Check if DAML is available
if command -v daml >/dev/null 2>&1 && [ -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
  echo "✅ DAML SDK found - starting full blockchain"

  export PATH="$HOME/.daml/bin:$PATH"

  # Start sandbox in background
  daml sandbox --port 6865 .daml/dist/*.dar &
  SANDBOX_PID=$!

  # Wait for sandbox with timeout
  echo "⏳ Waiting for sandbox..."
  timeout 60 bash -c 'until nc -z 127.0.0.1 6865; do sleep 2; done' || {
    echo "❌ Sandbox failed to start, falling back to mock API"
    kill $SANDBOX_PID 2>/dev/null || true
    exec ./start-mock.sh
  }

  # Start JSON API on $PORT
  echo "🌐 Starting JSON API on port $PORT"
  exec daml json-api --ledger-host 127.0.0.1 --ledger-port 6865 --http-port "$PORT"

else
  echo "⚠️ DAML SDK not available - starting mock API"
  exec ./start-mock.sh
fi