# Dockerfile for DAML Agent Tokenization on Render - Final Working Version
FROM openjdk:17-jdk-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    netcat-traditional \
    postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Default port for local; Render will overwrite PORT env at runtime
ENV PORT=8080

# Create app directory first
WORKDIR /app

# Copy project files (including any pre-built DAR files)
COPY . .

# Create startup script with proper port binding for Render
RUN cat > /app/start.sh <<'EOF'
#!/bin/bash
set -euo pipefail

echo "🚀 Starting Agent Tokenization Platform..."

# --- Install DAML SDK (minimal, just for runtime) ---
echo "📦 Installing DAML SDK..."
curl -L -o /tmp/daml-sdk.tar.gz https://github.com/digital-asset/daml/releases/download/v2.10.2/daml-sdk-2.10.2-linux.tar.gz
mkdir -p /root/.daml
tar -xzf /tmp/daml-sdk.tar.gz -C /root/.daml --strip-components=1
rm -f /tmp/daml-sdk.tar.gz

# Find and set up DAML executable
DAML_BIN=$(find /root/.daml -name "daml" -type f | grep -v "/lib/" | head -n 1 )
chmod +x "$DAML_BIN"
DAML_DIR=$(dirname "$DAML_BIN")
export PATH="$DAML_DIR:$PATH"
echo "✅ DAML SDK installed"

# --- Verify DAR file exists (should be copied via COPY . .) ---
echo "📁 Verifying pre-built DAR file..."
if [ -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
  echo "✅ Found pre-built DAR file"
  ls -la .daml/dist/
else
  echo "❌ Pre-built DAR file not found! Check if it was included in Docker build."
  echo "Contents of .daml/:"
  ls -la .daml/ || echo "No .daml directory"
  exit 1
fi

# --- Optional DB wait ---
if [[ -n "${DATABASE_HOST:-}" && -n "${DATABASE_PORT:-}" ]]; then
  echo "⏳ Waiting for PostgreSQL at $DATABASE_HOST:$DATABASE_PORT..."
  if timeout 60 bash -c "until nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 2; echo Retrying...; done"; then
    echo "✅ PostgreSQL is ready!"
  else
    echo "⚠️ PostgreSQL not accessible, starting anyway..."
  fi
else
  echo "📝 No database configuration provided"
fi

# --- Start ledger + JSON API (binds to $PORT for Render) ---
HTTP_PORT="${PORT:-8080}"
echo "🔄 Starting Sandbox (6865) + JSON API (HTTP $HTTP_PORT)"

# Start sandbox in the background
daml sandbox --port 6865 .daml/dist/*.dar &
# Wait for sandbox
timeout 60 bash -c 'until nc -z 127.0.0.1 6865; do sleep 2; done'
echo "✅ Sandbox is up"

# Start JSON API on $PORT (keeps container in foreground)
exec daml json-api --ledger-host 127.0.0.1 --ledger-port 6865 --http-port "$HTTP_PORT"
EOF

RUN chmod +x /app/start.sh

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=3 \
  CMD curl -f http://localhost:$PORT/readyz || exit 1

# Start the application
CMD ["/app/start.sh"]
