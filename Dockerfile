# Dockerfile for DAML Agent Tokenization on Render
FROM openjdk:17-jdk-slim

# Install required tools
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    netcat-traditional \
    postgresql-client \
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

# Create startup script with better error handling (timeout command is built-in)
RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'set -e' >> /app/start.sh && \
    echo '' >> /app/start.sh && \
    echo 'echo "🚀 Starting Agent Tokenization Platform..."' >> /app/start.sh && \
    echo '' >> /app/start.sh && \
    echo '# Wait for PostgreSQL if database variables are provided' >> /app/start.sh && \
    echo 'if [ ! -z "$DATABASE_HOST" ] && [ ! -z "$DATABASE_PORT" ]; then' >> /app/start.sh && \
    echo '    echo "⏳ Waiting for PostgreSQL at $DATABASE_HOST:$DATABASE_PORT..."' >> /app/start.sh && \
    echo '' >> /app/start.sh && \
    echo '    # Try to connect for up to 60 seconds (timeout is built-in to coreutils)' >> /app/start.sh && \
    echo '    if timeout 60 bash -c "until nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 2; echo Retrying...; done"; then' >> /app/start.sh && \
    echo '        echo "✅ PostgreSQL is ready!"' >> /app/start.sh && \
    echo '    else' >> /app/start.sh && \
    echo '        echo "❌ Could not connect to PostgreSQL after 60 seconds"' >> /app/start.sh && \
    echo '        echo "🔍 Database connection details:"' >> /app/start.sh && \
    echo '        echo "   HOST: $DATABASE_HOST"' >> /app/start.sh && \
    echo '        echo "   PORT: $DATABASE_PORT"' >> /app/start.sh && \
    echo '        echo "   USER: $DATABASE_USER"' >> /app/start.sh && \
    echo '        echo "   NAME: $DATABASE_NAME"' >> /app/start.sh && \
    echo '        echo "⚠️  Starting anyway - DAML will retry database connections..."' >> /app/start.sh && \
    echo '    fi' >> /app/start.sh && \
    echo 'else' >> /app/start.sh && \
    echo '    echo "📝 No database connection details provided"' >> /app/start.sh && \
    echo '    echo "   DATABASE_HOST: $DATABASE_HOST"' >> /app/start.sh && \
    echo '    echo "   DATABASE_PORT: $DATABASE_PORT"' >> /app/start.sh && \
    echo '    echo "⚠️  Starting without database wait..."' >> /app/start.sh && \
    echo 'fi' >> /app/start.sh && \
    echo '' >> /app/start.sh && \
    echo '# Start Canton with production config' >> /app/start.sh && \
    echo 'echo "🔄 Starting Canton/DAML..."' >> /app/start.sh && \
    echo 'echo "🌐 Will bind to port: $PORT"' >> /app/start.sh && \
    echo '' >> /app/start.sh && \
    echo 'exec daml start --start-navigator=no --port $PORT' >> /app/start.sh

RUN chmod +x /app/start.sh

# Expose port
EXPOSE $PORT

# Health check with longer startup period
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
  CMD curl -f http://localhost:$PORT/readyz || exit 1

# Start the application
CMD ["/app/start.sh"]