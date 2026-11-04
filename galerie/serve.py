"""Sert la galerie exhaustive des maps (bibliothèque standard).

    python3 galerie/serve.py --port 8000

« / » ouvre galerie/index.html ; la racine du dépôt reste accessible en lecture
seule (méthodes, salles, calques). Liens relatifs uniquement : le navigateur passe
par le proxy de prévisualisation, pas par localhost.
"""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import argparse

R = Path(__file__).resolve().parents[1]


class Handler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path in ('/', '/index.html'):
            self.send_response(302)
            self.send_header('Location', '/galerie/index.html')
            self.end_headers()
            return
        if '/.git' in self.path or '/.venv' in self.path or '/img/' in self.path and self.path.endswith('.py'):
            self.send_error(404)
            return
        super().do_GET()

    def log_message(self, fmt, *args):
        pass


class Server(ThreadingHTTPServer):
    daemon_threads = True

    def handle_error(self, request, client_address):
        import sys
        if isinstance(sys.exc_info()[1], (BrokenPipeError, ConnectionResetError)):
            return
        super().handle_error(request, client_address)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--port', type=int, default=8000)
    ap.add_argument('--bind', default='0.0.0.0')
    a = ap.parse_args()
    srv = Server((a.bind, a.port), partial(Handler, directory=str(R)))
    print(f'Galerie : http://{a.bind}:{a.port}/  (racine {R})', flush=True)
    srv.serve_forever()
