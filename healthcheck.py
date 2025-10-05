#!/usr/bin/env python3
"""Simple HTTP health check server that responds on Railway's PORT"""
import http.server
import socketserver
import os
import sys

PORT = int(os.environ.get('PORT', 8080))

class HealthCheckHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        # Return 200 OK for any GET request
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'OK')

    def log_message(self, format, *args):
        # Suppress request logs to reduce noise
        pass

if __name__ == '__main__':
    with socketserver.TCPServer(("0.0.0.0", PORT), HealthCheckHandler) as httpd:
        print(f"Health check server listening on 0.0.0.0:{PORT}")
        sys.stdout.flush()
        httpd.serve_forever()
