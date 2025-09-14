#!/bin/bash
set -e

export PATH="$HOME/.daml/bin:$PATH"

echo "🔄 Starting DAML Sandbox + JSON API on port $PORT"

# Start sandbox in background
daml sandbox --port 6865 .daml/dist/*.dar &

# Wait for sandbox
timeout 60 bash -c 'until nc -z 127.0.0.1 6865; do sleep 2; done'

# Start JSON API on $PORT
exec daml json-api --ledger-host 127.0.0.1 --ledger-port 6865 --http-port "$PORT"