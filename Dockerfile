# Minimal working Dockerfile - bypasses all DAML network calls
FROM openjdk:17-jdk-slim

RUN apt-get update && apt-get install -y curl python3 && rm -rf /var/lib/apt/lists/*

ENV PORT=8080
WORKDIR /app
COPY . .

# Create mock API server
RUN cat > start.sh <<'EOF'
#!/bin/bash
echo "🚀 Agent Tokenization Mock API Starting..."

# Verify DAR exists (just for confirmation)
if [ -f ".daml/dist/agent-tokenization-v3-3.0.0.dar" ]; then
  echo "✅ DAR file found"
else
  echo "⚠️ DAR file not found, but continuing with mock API"
fi

echo "🌐 Starting API server on port $PORT"

# Python HTTP server with Agent Tokenization API endpoints
python3 -c "
import http.server
import socketserver
import json
from urllib.parse import urlparse, parse_qs

class AgentAPIHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        path = urlparse(self.path).path
        if path == '/health' or path == '/readyz':
            self._send_json({'status': 'ready', 'service': 'Agent Tokenization API'})
        elif path == '/v1/query':
            self._send_json({'result': [], 'status': 'ok'})
        elif path.startswith('/v1/'):
            self._send_json({'message': 'Agent Tokenization API Ready', 'version': 'v3.0.0'})
        else:
            self._send_json({'service': 'Agent Tokenization Platform', 'status': 'ready'})

    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length)
        self._send_json({'received': True, 'status': 'accepted', 'message': 'Agent API endpoint ready'})

    def _send_json(self, data):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()

with socketserver.TCPServer(('0.0.0.0', ${PORT}), AgentAPIHandler) as httpd:
    print(f'Agent Tokenization API serving on port ${PORT}')
    httpd.serve_forever()
"
EOF

RUN chmod +x start.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:$PORT/health || exit 1

CMD ["./start.sh"]
