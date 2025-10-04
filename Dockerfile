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
  CMD curl -f http://localhost:7575/readyz || exit 1

# Debug network connectivity before starting Canton
RUN echo '#!/bin/bash' > debug-start.sh && \
    echo 'echo "=== Environment Debug Info ==="' >> debug-start.sh && \
    echo 'echo "DATABASE_URL: $DATABASE_URL"' >> debug-start.sh && \
    echo 'echo "CLASSPATH: $CLASSPATH"' >> debug-start.sh && \
    echo 'echo "JDBC Driver exists: $(ls -la /app/lib/postgresql-42.6.0.jar)"' >> debug-start.sh && \
    echo 'echo "=== Starting Canton ==="' >> debug-start.sh && \
    echo 'export JAVA_OPTS="-cp /app/lib/postgresql-42.6.0.jar:$CLASSPATH"' >> debug-start.sh && \
    echo 'daml start --sandbox-option --config=canton-railway.conf --json-api-option --allow-insecure-tokens --start-navigator=no --json-api-port=7575 --sandbox-port=6865' >> debug-start.sh && \
    chmod +x debug-start.sh

# Start with debug script
CMD ["bash", "debug-start.sh"]
