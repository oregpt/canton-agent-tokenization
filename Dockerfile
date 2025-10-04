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

# Start Canton directly without script file
CMD ["daml", "start", "--sandbox-option", "--config=canton-supabase.conf", "--json-api-option", "--allow-insecure-tokens", "--start-navigator=no", "--json-api-port=7575", "--sandbox-port=6865"]
