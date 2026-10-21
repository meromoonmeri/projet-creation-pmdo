"""Serveur d'aperçus pour la session Arena (bibliothèque standard seulement).

    python3 source/serveur_apercus/serve.py            # 0.0.0.0:8000
    python3 source/serveur_apercus/serve.py --port 8080

Sert la racine du dépôt en lecture seule sur 0.0.0.0:8000 (supporte GET, HEAD, ?dl=1 et les query strings du proxy).
"""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import argparse, html, io, re, subprocess, time
from urllib.parse import urlsplit

R = Path(__file__).resolve().parents[2]


def commit_dates():
    """Date (epoch) du dernier commit ayant touché chaque apercu_*.html de la racine."""
    try:
        out = subprocess.run(['git', '-C', str(R), 'log', '--name-only', '--format=@%ct', '--',
                              'apercu_*.html'], capture_output=True, text=True, timeout=20).stdout
    except Exception:
        return {}
    dates, t = {}, 0
    for line in out.splitlines():
        if line.startswith('@'):
            t = int(line[1:])
        elif line.strip() and line.strip() not in dates:
            dates[line.strip()] = t
    return dates


def title_of(p):
    m = re.search(r'<title>(.*?)</title>', p.read_text(errors='ignore')[:4000], re.S)
    return html.unescape(m.group(1).strip()) if m else p.stem


def index_page():
    dates = commit_dates()
    rows = []
    for p in R.glob('apercu_*.html'):
        d = dates.get(p.name)
        rows.append((d is None, max(d or 0, int(p.stat().st_mtime)), p))
    rows.sort(key=lambda r: (not r[0], -r[1]))
    serie = [r for r in rows if '_sud_nord_' in r[2].name]
    autres = [r for r in rows if '_sud_nord_' not in r[2].name]

    def li(r):
        new, t, p = r
        tag = '<span class="new">nouveau</span> ' if new else ''
        day = time.strftime('%d/%m/%Y', time.localtime(t))
        return (f'<li>{tag}<a href="{html.escape(p.name)}">{html.escape(title_of(p))}</a>'
                f' <small>{html.escape(p.name)} · {day}</small></li>')

    return f'''<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Aperçus — Projet Création PMDO</title>
<style>body{{background:#161b26;color:#eee;font:15px/1.55 system-ui,sans-serif;max-width:1040px;margin:24px auto;padding:0 16px}}
a{{color:#ffd76a}}small{{color:#999}}li{{margin:5px 0}}.new{{background:#2c7a5b;color:#fff;border-radius:4px;padding:0 6px;font-size:12px}}
.dlbox{{background:#1e2638;border:2px solid #f2b84b;border-radius:10px;padding:14px 18px;margin:14px 0 18px}}
.dlbtn{{display:inline-block;background:#f2b84b;color:#1b1308;font-weight:700;padding:8px 14px;border-radius:7px;text-decoration:none;margin:6px 8px 2px 0}}
h2{{border-bottom:1px solid #303f5c;padding-bottom:5px;margin-top:26px}}</style></head><body>
<h1>Aperçus &amp; Téléchargements PMDO</h1>
<div class="dlbox" style="border-color:#38bdf8;background:#17253b">
  <strong style="font-size:17px;color:#eef8ff">NOUVEAU — Pack des 10 Falaises Nord Centrées Nues · Grass Métano · Multicalque · Mer 8 Phases · Ciel Jour / Nuit (20 Cartes PMDO 0.8.12)</strong><br>
  <a class="dlbtn" style="background:#38bdf8;color:#081626" href="apercu_cliff_nord_centre_pmdo.html">🌊☀️🌙 Ouvrir le visualiseur interactif des 10 versions (Jour/Nuit + 8 calques + Mer 8 phases + Nuages 3 plans)</a>
  <a class="dlbtn" href="livrables_cliff_nord_centre_pmdo/PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip?dl=1">⬇ Pack Complet 20 Cartes PMDO 0.8.12 (.ZIP — 5,88 Mio)</a>
</div>
<div class="dlbox" style="border-color:#818cf8;background:#19213a">
  <strong style="font-size:17px;color:#eef2ff">NOUVEAU — Cliff Nord en Nuit (<code>cliffdaytest</code> &amp; <code>cliffnordouesttest1</code>) · Nuages 3 Plans &amp; Mer 8 Phases Animés (PMDO 0.8.12 · Zéro Génération IA)</strong><br>
  <a class="dlbtn" style="background:#818cf8;color:#0f1326" href="apercu_cliff_nord_nuit_pmdo.html">🌙 Ouvrir l’aperçu temps réel (Nuages 3 plans + Mer 8 phases + Cascades + Nuit/Jour)</a>
  <a class="dlbtn" href="livrables_cliff_nord_nuit_pmdo/PACK_CLIFF_NORD_NUIT_PMDO_0812.zip?dl=1">⬇ Pack Complet PMDO 0.8.12 (.ZIP — .rsground + .dir + .tile + INSTALLER.py + GIF)</a>
</div>
<div class="dlbox" style="border-color:#34d399;background:#162925">
  <strong style="font-size:17px;color:#ecfdf5">NOUVEAU — Réseau Complet des Salles Vides de la Guilde Halcyon (13 Maps Connectées · Sans Lit ni Meuble · Sans Spinda Sign · PMDO 0.8.12)</strong><br>
  <a class="dlbtn" style="background:#34d399;color:#092118" href="apercu_guilde_reseau_vide_et_cliffnorth.html">🏰 Ouvrir le réseau des salles vides de la Guilde</a>
  <a class="dlbtn" href="livrables_guilde_reseau_vide_et_cliffnorth_pmdo/PACK_GUILDE_RESEAU_VIDE_ET_CLIFFNORTH_PMDO.zip?dl=1">⬇ Pack Guilde Salles Vides (.ZIP)</a>
</div>
<div class="dlbox" style="border-color:#b2ef63;background:#1a2822">
  <strong style="font-size:17px;color:#f2ffe5">Treehouses Monumentales de Guilde SANS ESCALIER EXTÉRIEUR · Styles « Jardin Secret » &amp; « Sky Peak » (GJN1–GJN4 &amp; GSN1–GSN4 · 100 % RGBA Sans Fond)</strong><br>
  <a class="dlbtn" style="background:#b2ef63;color:#10200b" href="apercu_guilde_sans_escalier_jardin_skypeak.html">Ouvrir la galerie Sans Escalier Extérieur</a>
  <a class="dlbtn" href="livrables_guilde_sans_escalier_pmdo/PACK_GUILDE_SANS_ESCALIER_JARDIN_SKYPEAK_PMDO.zip?dl=1">Télécharger le Pack ZIP Sans Escalier</a>
</div>
<div class="dlbox" style="border-color:#6ef0a3;background:#192530">
  <strong style="font-size:17px;color:#e8fff2">Treehouses Monumentales de Guilde · Styles « Jardin Secret » &amp; « Sky Peak » (GJS1–GJS4 &amp; GSP1–GSP4 · 100 % RGBA Sans Fond)</strong><br>
  <a class="dlbtn" style="background:#6ef0a3;color:#0b1c14" href="apercu_guilde_jardin_secret_sky_peak.html">Ouvrir la galerie interactive Jardin Secret &amp; Sky Peak</a>
  <a class="dlbtn" href="livrables_guilde_jardin_secret_sky_peak_pmdo/PACK_GUILDE_JARDIN_SECRET_SKY_PEAK_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox" style="border-color:#e4b659;background:#2c2320">
  <strong style="font-size:17px;color:#f7ebd2">Les 8 Spinda Cafés Monumentaux (#0327 · Style Officiel « Dojo Makuhita » PMD · Sans Devanture · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#d95d56;color:#fff" href="apercu_spinda_cafe_dojo_pmdo.html">Ouvrir la galerie interactive (SPC1–SPC8)</a>
  <a class="dlbtn" href="livrables_spinda_cafe_dojo_pmdo/Spinda_Cafe_Style_DojoMakuhita_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox" style="border-color:#d99f66;background:#2d241c">
  <strong style="font-size:17px;color:#f6ecd6">Pack Tentes &amp; Kiosques Évoli (#0133 · Style Bourg-Trésor PMD · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#d99f66;color:#1b1209" href="apercu_tente_evoli_pmdo.html">Ouvrir l’aperçu Tentes Évoli (EVT1–EVT6)</a>
  <a class="dlbtn" href="livrables_tente_evoli_pmdo/Evoli_Tentes_BourgTresor_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox" style="border-color:#f4ced7;background:#2f2228">
  <strong style="font-size:17px;color:#ffd9e6">Maison / Monument Forgelina (Style « Réserve Kangourex » PMD · Sans Visage · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#e88eb4;color:#1b1015" href="apercu_maison_forgelina_pmdo.html">Ouvrir l’aperçu Maison Forgelina (FGK1–FGK6)</a>
  <a class="dlbtn" href="livrables_maison_forgelina_pmdo/Forgelina_Maisons_Style_Kangourex_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox" style="border-color:#dd4d98;background:#2a2024">
  <strong style="font-size:17px;color:#f4ced7">Pack Tentes, Huttes &amp; Kiosques Forgelina (#0959 · Modèle « Arcanine Hut » · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#dd4d98;color:#fff" href="apercu_tentes_huttes_forgelina_pmdo.html">Ouvrir la galerie interactive Forgelina</a>
  <a class="dlbtn" href="livrables_forgelina_pmdo/Forgelina_Tentes_Huttes_ArcanineStyle_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox">
  <strong style="font-size:17px;color:#a9e39e">Grandes Treehouses Monumentales de Guilde (3–4 étages · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" href="apercu_treehouses_guilde_monumentales_v2.html">Ouvrir la galerie interactive (9 structures)</a>
  <a class="dlbtn" href="livrables_treehouses_guilde_pmdo/PACK_TREEHOUSES_GUILDE_PMDO_SANS_FOND.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox">
  <strong style="font-size:17px;color:#ffd76a">Objets Café &amp; Estrade 100 % SANS FOND (PMDO 0.8.12)</strong><br>
  <a class="dlbtn" href="telecharger_objets_cafe_pmdo.html">Ouvrir la page de téléchargement (16 objets sans fond)</a>
  <a class="dlbtn" href="livrables_pmdo_sans_fond/PACK_PMDO_1X_ET_MOD_0812_SANS_FOND.zip?dl=1">Télécharger le ZIP</a>
</div>
<p>{len(rows)} aperçus autonomes. Chaque page contient ses calques, ses animations et ses liens de téléchargement.</p>
<h2>Lots récents &amp; conversions Nuit ({len(autres)})</h2><ul>{''.join(li(r) for r in autres)}</ul>
<h2>Entrées de donjon sud → nord ({len(serie)})</h2><ul>{''.join(li(r) for r in serie)}</ul>
</body></html>'''


class Handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        if '?dl=1' in getattr(self, 'path', ''):
            clean_name = Path(urlsplit(self.path).path).name
            if clean_name:
                self.send_header('Content-Disposition', f'attachment; filename="{clean_name}"')
        super().end_headers()

    def send_head(self):
        clean_path = urlsplit(self.path).path
        if clean_path in ('/', '/index.html'):
            body = index_page().encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Content-Length', str(len(body)))
            self.send_header('Cache-Control', 'no-store')
            self.end_headers()
            return io.BytesIO(body)
        if '/.git' in clean_path or clean_path.startswith('/.venv'):
            self.send_error(404)
            return None
        return super().send_head()

    def log_message(self, fmt, *args):
        pass


class Server(ThreadingHTTPServer):
    allow_reuse_address = True
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
    print(f'Aperçus : http://{a.bind}:{a.port}/  (racine {R})', flush=True)
    srv.serve_forever()
