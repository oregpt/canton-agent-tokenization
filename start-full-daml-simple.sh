#!/bin/bash
# Simplified startup script for cloud deployment

echo "🚀 Starting FULL DAML Agent Tokenization System (Cloud Optimized)..."

export PATH="$HOME/.daml/bin:$PATH"

# Check if DAML SDK is available
if ! command -v daml >/dev/null 2>&1; then
  echo "❌ DAML SDK not available - falling back to mock API"
  exec ./start-mock.sh
fi

echo "✅ DAML SDK found"

# Ensure we have the DAR file
if [ ! -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
  echo "🔨 Building DAML project..."
  daml build || {
    echo "❌ DAML build failed - falling back to mock API"
    exec ./start-mock.sh
  }
fi

echo "✅ DAR file ready"

# Start DAML sandbox (more reliable than Canton for cloud deployment)
echo "🔗 Starting DAML sandbox..."
daml sandbox --port 6865 .daml/dist/*.dar &
SANDBOX_PID=$!

# Function to cleanup on exit
cleanup() {
    echo "🧹 Cleaning up..."
    kill $SANDBOX_PID 2>/dev/null || true
    exit 0
}
trap cleanup SIGTERM SIGINT

# Wait for sandbox with timeout
echo "⏳ Waiting for sandbox to start..."
for i in {1..30}; do
    if nc -z 127.0.0.1 6865 2>/dev/null; then
        echo "✅ Sandbox is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Sandbox startup timeout - falling back to mock API"
        kill $SANDBOX_PID 2>/dev/null || true
        exec ./start-mock.sh
    fi
    sleep 2
done

# Deploy contracts with minimal test (faster startup)
echo "📦 Deploying basic contracts..."
daml script --dar .daml/dist/agent-tokenization-v3-3.0.0.dar \
  --script-name ComprehensiveV3Test:quickV3Test \
  --ledger-host 127.0.0.1 --ledger-port 6865 || {
  echo "⚠️ Contract deployment failed - starting without pre-deployed contracts"
}

# Start JSON API on a fixed port (7575)
echo "🌐 Starting JSON API on port 7575"
daml json-api \
  --ledger-host 127.0.0.1 \
  --ledger-port 6865 \
  --http-port 7575 \
  --allow-insecure-tokens \
  --address "0.0.0.0" &
API_PID=$!

# Add API PID to cleanup
cleanup() {
    echo "🧹 Cleaning up..."
    kill $API_PID 2>/dev/null || true
    kill $SANDBOX_PID 2>/dev/null || true
    exit 0
}
trap cleanup SIGTERM SIGINT

# Create a simple health check endpoint
echo "🏥 Setting up health check endpoint..."
cat > health-check.py << 'EOF'
#!/usr/bin/env python3
import http.server
import socketserver
import threading
import json
import requests
import os
from urllib.parse import urlparse, parse_qs

class HealthHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/readyz':
            try:
                # Check if DAML JSON API is responding
                resp = requests.get('http://localhost:7575/v1/query', timeout=2)
                if resp.status_code == 200 or resp.status_code == 400:  # 400 is ok for query without body
                    self.send_response(200)
                    self.send_header('Content-Type', 'application/json')
                    self.end_headers()
                    self.wfile.write(json.dumps({
                        'status': 'ready',
                        'service': 'full-daml',
                        'daml_api': 'available'
                    }).encode())
                else:
                    raise Exception('API not ready')
            except:
                self.send_response(503)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({
                    'status': 'not ready',
                    'service': 'full-daml',
                    'daml_api': 'unavailable'
                }).encode())
        else:
            # Proxy to DAML JSON API
            try:
                target_url = f'http://localhost:7575{self.path}'
                resp = requests.get(target_url, timeout=10)
                self.send_response(resp.status_code)
                for header, value in resp.headers.items():
                    if header.lower() not in ['connection', 'transfer-encoding']:
                        self.send_header(header, value)
                self.end_headers()
                self.wfile.write(resp.content)
            except:
                self.send_response(502)
                self.end_headers()

    def do_POST(self):
        try:
            content_length = int(self.headers.get('Content-Length', 0))
            post_data = self.rfile.read(content_length)
            target_url = f'http://localhost:7575{self.path}'
            resp = requests.post(target_url, data=post_data,
                               headers={'Content-Type': self.headers.get('Content-Type', 'application/json')},
                               timeout=30)
            self.send_response(resp.status_code)
            for header, value in resp.headers.items():
                if header.lower() not in ['connection', 'transfer-encoding']:
                    self.send_header(header, value)
            self.end_headers()
            self.wfile.write(resp.content)
        except Exception as e:
            self.send_response(502)
            self.end_headers()
            self.wfile.write(str(e).encode())

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    with socketserver.TCPServer(("0.0.0.0", port), HealthHandler) as httpd:
        httpd.serve_forever()
EOF

python3 health-check.py &
HEALTH_PID=$!

# Update cleanup function
cleanup() {
    echo "🧹 Cleaning up..."
    kill $HEALTH_PID 2>/dev/null || true
    kill $API_PID 2>/dev/null || true
    kill $SANDBOX_PID 2>/dev/null || true
    exit 0
}
trap cleanup SIGTERM SIGINT

# Wait for JSON API to be ready
echo "⏳ Waiting for JSON API..."
for i in {1..20}; do
    if curl -s http://localhost:7575/v1/query >/dev/null 2>&1; then
        echo "✅ JSON API is ready"
        break
    fi
    if [ $i -eq 20 ]; then
        echo "❌ JSON API startup failed - falling back to mock API"
        cleanup
        exec ./start-mock.sh
    fi
    sleep 3
done

echo "🎉 Full DAML system is running!"
echo "   • Sandbox: localhost:6865"
echo "   • JSON API: localhost:${PORT:-8080}"
echo "   • Health: /v1/query"

# Keep the script running
wait $API_PID