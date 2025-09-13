# Dockerfile for DAML Agent Tokenization on Render - Final Working Version
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

# Create startup script using printf (avoids heredoc issues)
RUN printf '#!/bin/bash\n\
set -e\n\
\n\
echo "🚀 Starting Agent Tokenization Platform..."\n\
\n\
# Install DAML if not already installed\n\
if ! command -v daml >/dev/null 2>&1; then\n\
    echo "📦 Installing DAML SDK..."\n\
    curl -L -o daml-sdk.tar.gz https://github.com/digital-asset/daml/releases/download/v2.10.2/daml-sdk-2.10.2-linux.tar.gz\n\
    mkdir -p /root/.daml\n\
    tar -xzf daml-sdk.tar.gz -C /root/.daml --strip-components=1\n\
    rm daml-sdk.tar.gz\n\
    chmod +x /root/.daml/daml\n\
    export PATH="/root/.daml:$PATH"\n\
    echo "✅ DAML installed successfully"\n\
else\n\
    echo "✅ DAML already available"\n\
fi\n\
\n\
# Build the project if DAR does not exist\n\
if [ ! -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then\n\
    echo "🔨 Building DAML project..."\n\
    /root/.daml/daml build\n\
fi\n\
\n\
# Wait for PostgreSQL if database variables are provided\n\
if [ ! -z "$DATABASE_HOST" ] && [ ! -z "$DATABASE_PORT" ]; then\n\
    echo "⏳ Waiting for PostgreSQL at $DATABASE_HOST:$DATABASE_PORT..."\n\
    if timeout 60 bash -c "until nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 2; echo Retrying...; done"; then\n\
        echo "✅ PostgreSQL is ready!"\n\
    else\n\
        echo "⚠️ PostgreSQL not accessible, starting anyway..."\n\
    fi\n\
else\n\
    echo "📝 No database configuration provided"\n\
fi\n\
\n\
# Start Canton/DAML\n\
echo "🔄 Starting Canton/DAML on port: $PORT"\n\
exec /root/.daml/daml start --start-navigator=no --port $PORT\n' > /app/start.sh

RUN chmod +x /app/start.sh

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=3 \
  CMD curl -f http://localhost:$PORT/readyz || exit 1

# Start the application
CMD ["/app/start.sh"]