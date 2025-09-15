#!/bin/bash
set -e

echo "🚀 Starting FULL DAML Agent Tokenization System..."

export PATH="$HOME/.daml/bin:$PATH"

# Check if we have DAML SDK
if command -v daml >/dev/null 2>&1; then
  echo "✅ DAML SDK found - starting full blockchain system"

  # Build with comprehensive V3 contracts
  echo "🔨 Building comprehensive V3 system..."
  daml build

  # Check if DAR file exists
  if [ -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
    echo "✅ DAR file built successfully"
  else
    echo "❌ DAR file build failed"
    exit 1
  fi

  # Start sandbox in background with PostgreSQL if available
  if [ "$DATABASE_URL" ]; then
    echo "🗄️ Starting with PostgreSQL persistence..."

    # Create canton config for production
    cat > canton-production.conf <<EOF
canton {
  features.enable-testing-commands = yes

  participants.participant1 {
    storage {
      type = postgres
      config {
        host = "${DATABASE_HOST:-localhost}"
        port = ${DATABASE_PORT:-5432}
        database = "${DATABASE_NAME:-postgres}"
        user = "${DATABASE_USER:-postgres}"
        password = "${DATABASE_PASSWORD:-}"
      }
    }
    admin-api {
      address = "0.0.0.0"
      port = 5012
    }
    ledger-api {
      address = "0.0.0.0"
      port = 6865
    }
  }

  domains.local {
    storage {
      type = postgres
      config {
        host = "${DATABASE_HOST:-localhost}"
        port = ${DATABASE_PORT:-5432}
        database = "${DATABASE_NAME:-postgres}"
        user = "${DATABASE_USER:-postgres}"
        password = "${DATABASE_PASSWORD:-}"
      }
    }
    public-api {
      address = "0.0.0.0"
      port = 5018
    }
    admin-api {
      address = "0.0.0.0"
      port = 5019
    }
  }
}
EOF

    # Try to start with Canton for persistence
    if command -v canton >/dev/null 2>&1; then
      echo "🔗 Starting Canton with PostgreSQL..."
      canton -c canton-production.conf &
      CANTON_PID=$!

      # Wait for Canton to start
      echo "⏳ Waiting for Canton to initialize..."
      sleep 60

      # Deploy DAR and run comprehensive test
      echo "📦 Deploying comprehensive V3 contracts..."
      daml script --dar .daml/dist/agent-tokenization-v3-3.0.0.dar \
        --script-name ComprehensiveV3Test:comprehensiveV3Test \
        --ledger-host 127.0.0.1 --ledger-port 6865 || {
        echo "⚠️ Comprehensive test failed, running quick test..."
        daml script --dar .daml/dist/agent-tokenization-v3-3.0.0.dar \
          --script-name ComprehensiveV3Test:quickV3Test \
          --ledger-host 127.0.0.1 --ledger-port 6865
      }

      # Start JSON API
      echo "🌐 Starting JSON API on port ${PORT:-7575}"
      exec daml json-api --ledger-host 127.0.0.1 --ledger-port 6865 --http-port "${PORT:-7575}" \
        --allow-insecure-tokens

    else
      echo "⚠️ Canton not available, using DAML sandbox..."
    fi
  fi

  # Fallback to DAML sandbox
  echo "🔗 Starting DAML sandbox..."
  daml sandbox --port 6865 .daml/dist/*.dar &
  SANDBOX_PID=$!

  # Wait for sandbox
  echo "⏳ Waiting for sandbox..."
  timeout 120 bash -c 'until nc -z 127.0.0.1 6865; do sleep 2; done' || {
    echo "❌ Sandbox failed to start within 2 minutes"
    kill $SANDBOX_PID 2>/dev/null || true
    exit 1
  }

  echo "📦 Deploying comprehensive V3 contracts..."
  # Try comprehensive test first, fall back to quick test
  daml script --dar .daml/dist/agent-tokenization-v3-3.0.0.dar \
    --script-name ComprehensiveV3Test:comprehensiveV3Test \
    --ledger-host 127.0.0.1 --ledger-port 6865 || {
    echo "⚠️ Comprehensive test failed, running quick test..."
    daml script --dar .daml/dist/agent-tokenization-v3-3.0.0.dar \
      --script-name ComprehensiveV3Test:quickV3Test \
      --ledger-host 127.0.0.1 --ledger-port 6865
  }

  # Start JSON API
  echo "🌐 Starting JSON API on port ${PORT:-7575}"
  exec daml json-api --ledger-host 127.0.0.1 --ledger-port 6865 --http-port "${PORT:-7575}" \
    --allow-insecure-tokens

else
  echo "❌ DAML SDK not available - falling back to mock API"
  exec ./start-mock.sh
fi