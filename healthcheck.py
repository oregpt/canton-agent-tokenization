#!/usr/bin/env python3
"""Reverse proxy server that handles health checks and forwards to DAML JSON API"""
import http.server
import socketserver
import os
import sys
import urllib.request
import urllib.error

PORT = int(os.environ.get('PORT', 8080))
DAML_JSON_API_PORT = 7575

class ProxyHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self._proxy_request()

    def do_POST(self):
        self._proxy_request()

    def do_PUT(self):
        self._proxy_request()

    def do_DELETE(self):
        self._proxy_request()

    def _proxy_request(self):
        # Health check endpoint - respond immediately
        if self.path == '/' or self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'OK')
            return

        # Forward all other requests to DAML JSON API on port 7575
        try:
            # Read request body if present
            content_length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(content_length) if content_length > 0 else None

            # Build target URL
            target_url = f"http://localhost:{DAML_JSON_API_PORT}{self.path}"

            # Create request
            req = urllib.request.Request(target_url, data=body, method=self.command)

            # Copy headers (except Host)
            for header, value in self.headers.items():
                if header.lower() not in ['host', 'connection']:
                    req.add_header(header, value)

            # Forward request
            with urllib.request.urlopen(req, timeout=30) as response:
                # Send response status
                self.send_response(response.status)

                # Copy response headers
                for header, value in response.headers.items():
                    if header.lower() not in ['connection', 'transfer-encoding']:
                        self.send_header(header, value)
                self.end_headers()

                # Send response body
                self.wfile.write(response.read())

        except urllib.error.HTTPError as e:
            # Forward HTTP errors from JSON API
            self.send_response(e.code)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(e.read())

        except Exception as e:
            # Handle connection errors (JSON API not ready yet)
            self.send_response(503)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            error_msg = f'{{"error": "Service unavailable", "details": "{str(e)}"}}'
            self.wfile.write(error_msg.encode())

    def log_message(self, format, *args):
        # Log only errors and important requests
        if '/v1/' in self.path or 'error' in format.lower():
            sys.stderr.write(f"{self.address_string()} - {format % args}\n")

if __name__ == '__main__':
    with socketserver.TCPServer(("0.0.0.0", PORT), ProxyHandler) as httpd:
        print(f"Reverse proxy server listening on 0.0.0.0:{PORT}")
        print(f"Forwarding requests to DAML JSON API on localhost:{DAML_JSON_API_PORT}")
        sys.stdout.flush()
        httpd.serve_forever()
