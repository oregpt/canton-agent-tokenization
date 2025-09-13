# Dockerfile for DAML Agent Tokenization on Render
FROM openjdk:17-jdk-slim

# Install required tools
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    netcat-traditional \
    postgresql-client \
    timeout \
    && rm -rf /var/lib/apt/lists/*

# Install DAML SDK
ENV DAML_VERSION=2.10.2
RUN curl -sSL https://get.daml.com/ | sh -s $DAML_VERSION
ENV PATH="/root/.daml/bin:${PATH}"

# Create app directory
WORKDIR /app

# Copy project files
COPY . .

# Build the DAML project
RUN daml build

# Create startup script with better error handling
RUN cat > /app/start.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Starting Agent Tokenization Platform..."

# Wait for PostgreSQL if database variables are provided
if [ ! -z "$DATABASE_HOST" ] && [ ! -z "$DATABASE_PORT" ]; then
    echo "⏳ Waiting for PostgreSQL at $DATABASE_HOST:$DATABASE_PORT..."

    # Try to connect for up to 60 seconds
    if timeout 60 bash -c "until nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 2; echo 'Retrying...'; done"; then
        echo "✅ PostgreSQL is ready!"
    else
        echo "❌ Could not connect to PostgreSQL after 60 seconds"
        echo "🔍 Database connection details:"
        echo "   HOST: $DATABASE_HOST"
        echo "   PORT: $DATABASE_PORT"
        echo "   USER: $DATABASE_USER"
        echo "   NAME: $DATABASE_NAME"
        echo "⚠️  Starting anyway - DAML will retry database connections..."
    fi
else
    echo "📝 No database connection details provided"
    echo "   DATABASE_HOST: $DATABASE_HOST"
    echo "   DATABASE_PORT: $DATABASE_PORT"
    echo "⚠️  Starting without database wait..."
fi

# Start Canton with production config
echo "🔄 Starting Canton/DAML..."
echo "🌐 Will bind to port: $PORT"

exec daml start --start-navigator=no --port $PORT
EOF

RUN chmod +x /app/start.sh

# Expose port
EXPOSE $PORT

# Health check with longer startup period
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
  CMD curl -f http://localhost:$PORT/readyz || exit 1

# Start the application
CMD ["/app/start.sh"]