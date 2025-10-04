# Dockerfile for Railway deployment of Canton Agent Tokenization

FROM openjdk:17-jdk-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install DAML SDK with retry logic for stability
RUN for i in 1 2 3; do \
    curl -sSL https://get.daml.com/ | sh -s 2.8.0 && break || \
    (echo "DAML install attempt $i failed, retrying..." && sleep 10); \
    done

# Add DAML to PATH
ENV PATH="/root/.daml/bin:${PATH}"

# Download PostgreSQL JDBC driver for Canton
RUN mkdir -p /app/lib && \
    wget https://jdbc.postgresql.org/download/postgresql-42.6.0.jar -O /app/lib/postgresql-42.6.0.jar

# Add JDBC driver to classpath
ENV CLASSPATH="/app/lib/postgresql-42.6.0.jar:${CLASSPATH}"

# Copy project files
COPY . .

# Build the DAR file
RUN daml build

# No startup script needed - run directly

# Expose ports
EXPOSE 5011 5012 5018 5019 6865 7575

# Environment variables
ENV SUPABASE_DB_PASSWORD=""

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:${PORT:-7575}/readyz || exit 1

# Create startup script with proper JDBC driver setup
RUN echo '#!/bin/bash' > debug-start.sh && \
    echo 'echo "=== Environment Debug Info ==="' >> debug-start.sh && \
    echo 'echo "DATABASE_URL: $DATABASE_URL"' >> debug-start.sh && \
    echo 'echo "PORT: $PORT"' >> debug-start.sh && \
    echo 'echo "CLASSPATH: $CLASSPATH"' >> debug-start.sh && \
    echo 'echo "JDBC Driver exists: $(ls -la /app/lib/postgresql-42.6.0.jar)"' >> debug-start.sh && \
    echo '# Set default PORT if not provided by Railway' >> debug-start.sh && \
    echo 'export PORT=${PORT:-8080}' >> debug-start.sh && \
    echo 'echo "Using PORT: $PORT"' >> debug-start.sh && \
    echo 'echo "=== Preparing JDBC Driver ==="' >> debug-start.sh && \
    echo '# Add JDBC driver to Canton classpath' >> debug-start.sh && \
    echo 'export DAML_SDK_VERSION=2.8.0' >> debug-start.sh && \
    echo 'export CANTON_JAR_PATH="/root/.daml/sdk/${DAML_SDK_VERSION}/canton/lib"' >> debug-start.sh && \
    echo 'mkdir -p "$CANTON_JAR_PATH"' >> debug-start.sh && \
    echo 'cp /app/lib/postgresql-42.6.0.jar "$CANTON_JAR_PATH/"' >> debug-start.sh && \
    echo 'echo "JDBC driver copied to Canton lib: $(ls -la $CANTON_JAR_PATH/postgresql*.jar)"' >> debug-start.sh && \
    echo 'echo "=== Starting Canton ==="' >> debug-start.sh && \
    echo 'daml start --sandbox-option --config=canton-railway.conf --json-api-option --allow-insecure-tokens --start-navigator=no --sandbox-port=6865' >> debug-start.sh && \
    chmod +x debug-start.sh

# Start with debug script
CMD ["bash", "debug-start.sh"]
