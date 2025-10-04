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

# Install DAML SDK using the installer script
RUN curl -sSL https://get.daml.com/ | sh -s 2.8.0

# Add DAML to PATH
ENV PATH="/root/.daml/bin:${PATH}"

# Copy project files
COPY . .

# Build the DAR file
RUN daml build

# Create startup script
RUN echo '#!/bin/bash\n\
echo "Starting Canton with Supabase..."\n\
\n\
# Start Canton with JSON API\n\
daml start \\\n\
  --sandbox-option --config=canton-supabase.conf \\\n\
  --json-api-option --allow-insecure-tokens \\\n\
  --start-navigator=no \\\n\
  --json-api-port=7575 \\\n\
  --sandbox-port=6865 \\\n\
  --script-name AgentTokenizationV2:initializeV2System\n\
' > start.sh && chmod +x start.sh

# Expose ports
EXPOSE 5011 5012 5018 5019 6865 7575

# Environment variables
ENV SUPABASE_DB_PASSWORD=""

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:7575/readyz || exit 1

# Start Canton
CMD ["./start.sh"]
