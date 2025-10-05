# Dockerfile for Railway deployment of Canton Agent Tokenization

FROM eclipse-temurin:17-jdk-jammy

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    gettext-base \
    python3 \
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

# JVM Memory optimization for Railway Hobby plan (8GB RAM available)
ENV JAVA_OPTS="-Xmx4g -Xms1g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
ENV JAVA_TOOL_OPTIONS="-XX:+IgnoreUnrecognizedVMOptions"
ENV _JAVA_OPTIONS="-XX:+IgnoreUnrecognizedVMOptions"

# Health check for DAML JSON API
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:${PORT:-7575}/v1/packages || exit 1

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
    echo '# Convert DATABASE_URL to proper JDBC format' >> start.sh && \
    echo 'export JDBC_DATABASE_URL=$(python3 -c "' >> start.sh && \
    echo 'import os, re' >> start.sh && \
    echo 'url = os.environ[\"DATABASE_URL\"]' >> start.sh && \
    echo '# Try with port first' >> start.sh && \
    echo 'match = re.match(r\"postgresql://([^:]+):([^@]+)@([^:]+):(\d+)/(.+)\", url)' >> start.sh && \
    echo 'if match:' >> start.sh && \
    echo '    user, password, host, port, db = match.groups()' >> start.sh && \
    echo '    print(f\"jdbc:postgresql://{host}:{port}/{db}?user={user}&password={password}\")' >> start.sh && \
    echo 'else:' >> start.sh && \
    echo '    # Try without port (defaults to 5432)' >> start.sh && \
    echo '    match = re.match(r\"postgresql://([^:]+):([^@]+)@([^/]+)/(.+)\", url)' >> start.sh && \
    echo '    if match:' >> start.sh && \
    echo '        user, password, host, db = match.groups()' >> start.sh && \
    echo '        print(f\"jdbc:postgresql://{host}:5432/{db}?user={user}&password={password}\")' >> start.sh && \
    echo '    else:' >> start.sh && \
    echo '        print(url.replace(\"postgresql:\", \"jdbc:postgresql:\"))' >> start.sh && \
    echo '")' >> start.sh && \
    echo 'echo "Original DATABASE_URL: $DATABASE_URL"' >> start.sh && \
    echo 'echo "JDBC DATABASE_URL: $JDBC_DATABASE_URL"' >> start.sh && \
    echo '# Substitute JDBC URL in config file' >> start.sh && \
    echo 'DATABASE_URL="$JDBC_DATABASE_URL" envsubst < canton-railway.conf > canton-runtime.conf' >> start.sh && \
    echo 'echo "Config created with DATABASE_URL resolved"' >> start.sh && \
    echo 'echo "=== Starting Canton ==="' >> start.sh && \
    echo 'exec daml start --sandbox-option --config=canton-runtime.conf --json-api-port=${PORT} --start-navigator=no --sandbox-port=6865' >> start.sh && \
    chmod +x start.sh

# Start with optimized script
CMD ["bash", "start.sh"]
