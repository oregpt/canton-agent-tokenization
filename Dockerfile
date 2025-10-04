# Dockerfile for Railway deployment of Canton Agent Tokenization

FROM openjdk:17-jdk-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    gettext-base \
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

# Environment variables (DATABASE_URL will be provided by Railway)
ENV SUPABASE_DB_PASSWORD=""

# JVM Memory optimization for Railway deployment
ENV JAVA_OPTS="-Xmx1024m -Xms256m -XX:MaxMetaspaceSize=256m -XX:+UseG1GC -XX:+UseContainerSupport"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:${PORT:-7575}/readyz || exit 1

# Create startup script that resolves DATABASE_URL before starting Canton
RUN echo '#!/bin/bash' > start.sh && \
    echo 'echo "=== Environment Setup ==="' >> start.sh && \
    echo 'echo "DATABASE_URL: $DATABASE_URL"' >> start.sh && \
    echo 'echo "PORT: $PORT"' >> start.sh && \
    echo 'echo "JAVA_OPTS: $JAVA_OPTS"' >> start.sh && \
    echo '# Set default PORT if not provided by Railway' >> start.sh && \
    echo 'export PORT=${PORT:-8080}' >> start.sh && \
    echo 'echo "Using PORT: $PORT"' >> start.sh && \
    echo 'echo "=== Preparing JDBC Driver ==="' >> start.sh && \
    echo '# Add JDBC driver to Canton classpath' >> start.sh && \
    echo 'export DAML_SDK_VERSION=2.8.0' >> start.sh && \
    echo 'export CANTON_JAR_PATH="/root/.daml/sdk/${DAML_SDK_VERSION}/canton/lib"' >> start.sh && \
    echo 'mkdir -p "$CANTON_JAR_PATH"' >> start.sh && \
    echo 'cp /app/lib/postgresql-42.6.0.jar "$CANTON_JAR_PATH/"' >> start.sh && \
    echo 'echo "JDBC driver ready: $(ls -la $CANTON_JAR_PATH/postgresql*.jar)"' >> start.sh && \
    echo 'echo "=== Creating Runtime Canton Config ==="' >> start.sh && \
    echo '# Substitute DATABASE_URL in config file' >> start.sh && \
    echo 'envsubst < canton-railway.conf > canton-runtime.conf' >> start.sh && \
    echo 'echo "Config created with DATABASE_URL resolved"' >> start.sh && \
    echo 'echo "=== Starting Canton ==="' >> start.sh && \
    echo 'exec daml start --sandbox-option --config=canton-runtime.conf --json-api-option --allow-insecure-tokens --start-navigator=no --sandbox-port=6865' >> start.sh && \
    chmod +x start.sh

# Start with optimized script
CMD ["bash", "start.sh"]
