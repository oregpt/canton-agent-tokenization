# Dockerfile for DAML Agent Tokenization on Render - Simplified Working Version
FROM openjdk:17-jdk-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    netcat-traditional \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Create app directory first
WORKDIR /app

# Copy project files (including any pre-built DAR files)
COPY . .

# Create startup script that installs DAML at runtime
RUN cat > /app/start.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Starting Agent Tokenization Platform..."

# Install DAML if not already installed
if ! command -v daml &> /dev/null; then
    echo "📦 Installing DAML SDK..."
    curl -L -o daml-sdk.tar.gz https://github.com/digital-asset/daml/releases/download/v2.10.2/daml-sdk-2.10.2-linux.tar.gz
    mkdir -p /root/.daml
    tar -xzf daml-sdk.tar.gz -C /root/.daml --strip-components=1
    rm daml-sdk.tar.gz
    chmod +x /root/.daml/daml
    export PATH="/root/.daml:$PATH"
    echo "✅ DAML installed successfully"
else
    echo "✅ DAML already available"
fi

# Build the project if DAR doesn't exist
if [ ! -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
    echo "🔨 Building DAML project..."
    /root/.daml/daml build
fi

# Wait for PostgreSQL if database variables are provided
if [ ! -z "$DATABASE_HOST" ] && [ ! -z "$DATABASE_PORT" ]; then
    echo "⏳ Waiting for PostgreSQL at $DATABASE_HOST:$DATABASE_PORT..."
    if timeout 60 bash -c "until nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 2; echo Retrying...; done"; then
        echo "✅ PostgreSQL is ready!"
    else
        echo "⚠️ PostgreSQL not accessible, starting anyway..."
    fi
else
    echo "📝 No database configuration provided"
fi

# Start Canton/DAML
echo "🔄 Starting Canton/DAML on port: $PORT"
exec /root/.daml/daml start --start-navigator=no --port $PORT
EOF

RUN chmod +x /app/start.sh

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=3 \
  CMD curl -f http://localhost:$PORT/readyz || exit 1

# Start the application
CMD ["/app/start.sh"]