#!/bin/bash
set -e

echo "🚀 Starting Mock Agent Tokenization API on port $PORT"

# Enhanced mock API with all the endpoints your system expects
python3 -c "
import http.server
import socketserver
import json
from urllib.parse import urlparse, parse_qs
import os

PORT = int(os.environ.get('PORT', 8080))

class AgentAPIHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        path = urlparse(self.path).path

        if path in ['/health', '/readyz', '/livez']:
            self._send_json({'status': 'ready', 'service': 'Agent Tokenization API', 'version': 'v3.0.0'})

        elif path == '/v1/parties':
            self._send_json({'result': ['Alice', 'Bob', 'SystemOrchestrator']})

        else:
            self._send_json({
                'service': 'Agent Tokenization Platform',
                'status': 'ready',
                'endpoints': ['/readyz', '/v1/query', '/v1/create', '/v1/exercise', '/v1/parties'],
                'note': 'Mock API - Deploy with full DAML for production features'
            })

    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length)
        path = urlparse(self.path).path

        try:
            request_data = json.loads(post_data) if post_data else {}
        except:
            request_data = {}

        if path == '/v1/query':
            # Mock query response
            template_ids = request_data.get('templateIds', [])
            mock_result = []

            if 'SystemOrchestrator' in str(template_ids):
                mock_result = [{
                    'contractId': 'mock-system-001',
                    'templateId': 'AgentTokenizationV2:SystemOrchestrator',
                    'payload': {
                        'orchestrator': 'SystemOrchestrator',
                        'totalRegistrations': 2,
                        'systemVersion': '3.0.0-mock'
                    }
                }]

            self._send_json({'result': mock_result, 'status': 200})

        elif path == '/v1/create':
            # Mock create response
            self._send_json({
                'result': {
                    'contractId': f'mock-contract-{hash(str(request_data)) % 10000}',
                    'templateId': 'Mock:Template'
                },
                'status': 200
            })

        elif path == '/v1/exercise':
            # Mock exercise response
            self._send_json({
                'result': {'exercised': True},
                'status': 200
            })

        else:
            self._send_json({'received': True, 'status': 'accepted', 'message': 'Mock endpoint'})

    def _send_json(self, data):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()

print(f'🌐 Mock Agent Tokenization API serving on port {PORT}')
print('📋 Available endpoints:')
print('  GET  /readyz - Health check')
print('  POST /v1/query - Query contracts')
print('  POST /v1/create - Create contracts')
print('  POST /v1/exercise - Exercise choices')

with socketserver.TCPServer(('0.0.0.0', PORT), AgentAPIHandler) as httpd:
    httpd.serve_forever()
"