"""Serveur d'aperçus pour la session Arena (bibliothèque standard seulement).

    python3 source/serveur_apercus/serve.py            # 0.0.0.0:8000
    python3 source/serveur_apercus/serve.py --port 8080

Sert la racine du dépôt en lecture seule. La page « / » liste les aperçus `apercu_*.html` de la racine, du plus
récent au plus ancien d'après la date du commit qui les a ajoutés ; la série des entrées sud → nord est en tête.
Les aperçus pas encore commités sont marqués « nouveau » et placés en premier. L'index est recalculé à chaque
visite : une map ajoutée pendant que le serveur tourne apparaît sans redémarrage.
Liens relatifs seulement (le navigateur passe par le proxy de prévisualisation, pas par localhost).
"""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import argparse, html, re, subprocess, time

R = Path(__file__).resolve().parents[2]


def commit_dates():
    """Date (epoch) du premier commit qui a ajouté chaque apercu_*.html de la racine."""
    try:
        out = subprocess.run(['git', '-C', str(R), 'log', '--diff-filter=A', '--name-only', '--format=@%ct', '--',
                              'apercu_*.html'], capture_output=True, text=True, timeout=20).stdout
    except Exception:
        return {}
    dates, t = {}, 0
    for line in out.splitlines():
        if line.startswith('@'):
            t = int(line[1:])
        elif line.strip():
            dates[line.strip()] = t          # log du plus récent au plus ancien : on garde le plus ancien ajout
    return dates


def title_of(p):
    m = re.search(r'<title>(.*?)</title>', p.read_text(errors='ignore')[:4000], re.S)
    return html.unescape(m.group(1).strip()) if m else p.stem


def index_page():
    dates = commit_dates()
    rows = []
    for p in R.glob('apercu_*.html'):
        d = dates.get(p.name)
        rows.append((d is None, d or p.stat().st_mtime, p))
    rows.sort(key=lambda r: (not r[0], -r[1]))
    serie = [r for r in rows if '_sud_nord_' in r[2].name]
    autres = [r for r in rows if '_sud_nord_' not in r[2].name]

    def li(r):
        new, t, p = r
        tag = '<span class="new">nouveau</span> ' if new else ''
        day = time.strftime('%d/%m/%Y', time.localtime(t))
        return (f'<li>{tag}<a href="{html.escape(p.name)}">{html.escape(title_of(p))}</a>'
                f' <small>{html.escape(p.name)} · {day}</small></li>')

    return f'''<!doctype html><html lang="fr"><head><meta charset="utf-8"><title>Aperçus — Guilde Treehouse PMD</title>
<style>body{{background:#1d1a14;color:#eee;font:15px/1.5 system-ui,sans-serif;max-width:980px;margin:24px auto;padding:0 16px}}
a{{color:#ffd76a}}small{{color:#999}}li{{margin:4px 0}}.new{{background:#6a4;color:#fff;border-radius:4px;padding:0 6px;font-size:12px}}
h2{{border-bottom:1px solid #444;padding-bottom:4px}}</style></head><body>
<h1>Aperçus des maps PMD</h1>
<p>{len(rows)} aperçus autonomes. Chaque page contient ses calques, ses animations et ses liens de téléchargement.</p>
<h2>Entrées de donjon sud → nord ({len(serie)})</h2><ul>{''.join(li(r) for r in serie)}</ul>
<h2>Autres lots ({len(autres)})</h2><ul>{''.join(li(r) for r in autres)}</ul>
</body></html>'''


class Handler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path in ('/', '/index.html'):
            body = index_page().encode()
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Content-Length', str(len(body)))
            self.send_header('Cache-Control', 'no-store')
            self.end_headers()
            self.wfile.write(body)
            return
        if '/.git' in self.path or self.path.startswith('/.venv'):
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
            return                                # le navigateur a coupé en cours de transfert : sans gravité
        super().handle_error(request, client_address)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--port', type=int, default=8000)
    ap.add_argument('--bind', default='0.0.0.0')
    a = ap.parse_args()
    srv = Server((a.bind, a.port), partial(Handler, directory=str(R)))
    print(f'Aperçus : http://{a.bind}:{a.port}/  (racine {R})', flush=True)
    srv.serve_forever()
