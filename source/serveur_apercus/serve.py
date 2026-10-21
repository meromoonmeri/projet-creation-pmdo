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
.dlbox{{background:#2d241d;border:2px solid #f2b84b;border-radius:10px;padding:14px 18px;margin:14px 0 22px}}
.dlbtn{{display:inline-block;background:#f2b84b;color:#1b1308;font-weight:700;padding:8px 14px;border-radius:7px;text-decoration:none;margin:6px 8px 2px 0}}
h2{{border-bottom:1px solid #444;padding-bottom:4px}}</style></head><body>
<h1>Aperçus &amp; Téléchargements PMDO</h1>
<div class="dlbox" style="border-color:#d99f66;background:#2d241c">
  <strong style="font-size:17px;color:#f6ecd6">NOUVEAU — Pack Tentes &amp; Kiosques Évoli (#0133 · Style Bourg-Trésor PMD Explorateurs du Ciel · Croisillons · Sans Bouche ni Museau · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#d99f66;color:#1b1209" href="apercu_tente_evoli_pmdo.html">Ouvrir l’aperçu &amp; téléchargements PNG / .tile (EVT1–EVT6 Jour/Nuit/Baie α=0/HD)</a>
  <a class="dlbtn" href="livrables_tente_evoli_pmdo/Evoli_Tentes_BourgTresor_PMDO.zip?dl=1">Télécharger le Pack Complet ZIP Tentes Évoli (.tile + 1× + HD)</a>
</div>
<div class="dlbox" style="border-color:#f4ced7;background:#2f2228">
  <strong style="font-size:17px;color:#ffd9e6">NOUVEAU — Maison / Monument Forgelina (Modèle Validé Style « Réserve Kangourex » PMD · 100 % Sans Visage · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#e88eb4;color:#1b1015" href="apercu_maison_forgelina_pmdo.html">Ouvrir l’aperçu &amp; téléchargements PNG / .tile (FGK1–FGK6 Jour/Nuit/Baie α=0/HD)</a>
  <a class="dlbtn" href="livrables_maison_forgelina_pmdo/Forgelina_Maisons_Style_Kangourex_PMDO.zip?dl=1">Télécharger le Pack Complet ZIP Maison Kangourex Forgelina (.tile + 1× + HD)</a>
</div>
<div class="dlbox" style="border-color:#dd4d98;background:#2a2024">
  <strong style="font-size:17px;color:#f4ced7">NOUVEAU — Pack Tentes, Huttes &amp; Kiosques Forgelina (#0959 Tinkaton · Modèle exact « Arcanine Hut » · 100 % SANS FOND RGBA)</strong><br>
  <a class="dlbtn" style="background:#dd4d98;color:#fff" href="apercu_tentes_huttes_forgelina_pmdo.html">Ouvrir la galerie interactive &amp; comparatif Arcanine Hut (8 éléments Jour/Nuit/Calques/HD)</a>
  <a class="dlbtn" href="livrables_forgelina_pmdo/Forgelina_Tentes_Huttes_ArcanineStyle_PMDO.zip?dl=1">Télécharger le Pack Complet ZIP Forgelina (.tile + 1× + HD)</a>
</div>
<div class="dlbox">
  <strong style="font-size:17px;color:#a9e39e">Grandes Treehouses Monumentales de Guilde (3–4 étages, feuillage ciselé, 100 % SANS FOND RGBA)</strong><br>
  <a class="dlbtn" href="apercu_treehouses_guilde_monumentales_v2.html">Ouvrir la galerie interactive &amp; téléchargements (9 structures Jour/Nuit/Calques/HD)</a>
  <a class="dlbtn" href="livrables_treehouses_guilde_pmdo/PACK_TREEHOUSES_GUILDE_PMDO_SANS_FOND.zip?dl=1">Télécharger le Pack Complet ZIP Treehouses Guilde (.tile + 1× + HD)</a>
</div>
<div class="dlbox">
  <strong style="font-size:17px;color:#ffd76a">Téléchargement direct — Objets Café &amp; Estrade 100 % SANS FOND (prêts pour PMDO 0.8.12)</strong><br>
  <a class="dlbtn" href="telecharger_objets_cafe_pmdo.html">Ouvrir la page de téléchargement (16 objets sans fond)</a>
  <a class="dlbtn" href="livrables_pmdo_sans_fond/PACK_PMDO_1X_ET_MOD_0812_SANS_FOND.zip?dl=1">Télécharger le ZIP PMDO 1× + Mod .tile (2 Mo)</a>
</div>
<p>{len(rows)} aperçus autonomes. Chaque page contient ses calques, ses animations et ses liens de téléchargement.</p>
<h2>Entrées de donjon sud → nord ({len(serie)})</h2><ul>{''.join(li(r) for r in serie)}</ul>
<h2>Autres lots ({len(autres)})</h2><ul>{''.join(li(r) for r in autres)}</ul>
</body></html>'''


class Handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        if '?dl=1' in getattr(self, 'path', ''):
            clean_name = Path(self.path.split('?', 1)[0]).name
            if clean_name:
                self.send_header('Content-Disposition', f'attachment; filename="{clean_name}"')
        super().end_headers()

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
