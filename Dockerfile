# Dockerfile for DAML Agent Tokenization on Render - v3.0
FROM openjdk:17-jdk-slim

# Force cache invalidation - unique timestamp
ARG BUILD_DATE=62f1bdd-v3
RUN echo "Build: $BUILD_DATE"

# Install required tools
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    netcat-traditional \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install DAML SDK 2.10.2 directly from GitHub releases
RUN curl -L -o daml-sdk.tar.gz https://github.com/digital-asset/daml/releases/download/v2.10.2/daml-sdk-2.10.2-linux.tar.gz && \
    mkdir -p /root/.daml && \
    tar -xzf daml-sdk.tar.gz -C /root/.daml --strip-components=1 && \
    rm daml-sdk.tar.gz && \
    ln -s /root/.daml/daml /usr/local/bin/daml

# Verify DAML installation
RUN daml version

# Create app directory
WORKDIR /app

# Copy project files
COPY . .

# Build the DAML project
RUN daml build

# Create startup script with better error handling
RUN printf '#!/bin/bash\n\
set -e\n\
\n\
echo "🚀 Starting Agent Tokenization Platform..."\n\
\n\
# Wait for PostgreSQL if database variables are provided\n\
if [ ! -z "$DATABASE_HOST" ] && [ ! -z "$DATABASE_PORT" ]; then\n\
    echo "⏳ Waiting for PostgreSQL at $DATABASE_HOST:$DATABASE_PORT..."\n\
\n\
    # Try to connect for up to 60 seconds\n\
    if timeout 60 bash -c "until nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 2; echo Retrying...; done"; then\n\
        echo "✅ PostgreSQL is ready!"\n\
    else\n\
        echo "❌ Could not connect to PostgreSQL after 60 seconds"\n\
        echo "🔍 Database connection details:"\n\
        echo "   HOST: $DATABASE_HOST"\n\
        echo "   PORT: $DATABASE_PORT"\n\
        echo "   USER: $DATABASE_USER"\n\
        echo "   NAME: $DATABASE_NAME"\n\
        echo "⚠️  Starting anyway - DAML will retry database connections..."\n\
    fi\n\
else\n\
    echo "📝 No database connection details provided"\n\
    echo "   DATABASE_HOST: $DATABASE_HOST"\n\
    echo "   DATABASE_PORT: $DATABASE_PORT"\n\
    echo "⚠️  Starting without database wait..."\n\
fi\n\
\n\
# Start Canton with production config\n\
echo "🔄 Starting Canton/DAML..."\n\
echo "🌐 Will bind to port: $PORT"\n\
\n\
exec daml start --start-navigator=no --port $PORT\n' > /app/start.sh

RUN chmod +x /app/start.sh

# Expose port
EXPOSE $PORT

# Health check with longer startup period
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
  CMD curl -f http://localhost:$PORT/readyz || exit 1

# Start the application
CMD ["/app/start.sh"]