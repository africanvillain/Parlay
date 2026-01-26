from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import os

APP_NAME = os.getenv("APP_NAME", "parlay-analyzer")
APP_TRACK = os.getenv("APP_TRACK", "stable")
APP_VERSION = os.getenv("APP_VERSION", "v1")


class Handler(BaseHTTPRequestHandler):
    def _send_json(self, payload, status=200, headers=None):
        self.send_response(status)
        self.send_header("Content-Type", "application/json")

        # ✅ allow optional custom headers (for canary visibility)
        if headers:
            for key, value in headers.items():
                self.send_header(key, value)

        self.end_headers()
        self.wfile.write(json.dumps(payload).encode())

    def do_GET(self):
        if self.path == "/health":
            self._send_json({"status": "ok"})
            return

        if self.path == "/version":
            self._send_json(
                {
                    "service": APP_NAME,
                    "track": APP_TRACK,
                    "version": APP_VERSION,
                },
                headers={
                    "X-Release-Track": APP_TRACK,
                    "X-Release-Version": APP_VERSION,
                },
            )
            return

        self._send_json({"error": "not found"}, status=404)


if __name__ == "__main__":
    port = 8000
    print(f"Starting {APP_NAME} on port {port} ({APP_TRACK}, {APP_VERSION})")
    HTTPServer(("", port), Handler).serve_forever()
