# Dockerfile for DAML Agent Tokenization on Render
FROM openjdk:17-jdk-slim

# Install required tools
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
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

# Create startup script
RUN echo '#!/bin/bash\nset -e\n\n# Wait for PostgreSQL to be ready\necho "Waiting for PostgreSQL..."\nwhile ! nc -z $DATABASE_HOST 5432; do\n  sleep 1\ndone\necho "PostgreSQL is ready!"\n\n# Start Canton with production config\necho "Starting Canton..."\ndaml start --start-navigator=no --port $PORT' > /app/start.sh
RUN chmod +x /app/start.sh

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:$PORT/readyz || exit 1

# Start the application
CMD ["/app/start.sh"]