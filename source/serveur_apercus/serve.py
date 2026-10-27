#!/usr/bin/env python3
"""Serveur d'aperçus des maps PMDO — galerie complète, ZIP inclus.

    .venv/bin/python source/serveur_apercus/serve.py --port 8000

* `/`                        galerie de toutes les cartes (aperçus, packs, chantiers)
* `/apercu_xxx.html`         aperçu autonome d'origine, octet pour octet (animations incluses)
* `/renders/.../index.html`  pages cibles des redirections + leurs assets frères
* `/pack/<id>/`              lecteur reconstitué d'une archive ZIP
* `/pack/<id>/f/<chemin>`    fichier interne du ZIP (calque, frame, WebP animé, HTML…)
* `/pack/<id>/zip`           téléchargement du ZIP d'origine
* `/api/...`                 catalogue, état de restauration, contenu d'un pack
* `/thumb/<id>.webp`         vignette

Tous les fichiers viennent du cache `.cache/apercus/` construit par `restaurer.py`.
S'il manque un blob, le serveur le récupère à la demande depuis GitHub.
Liaisons relatives uniquement : le navigateur passe par le proxy d'aperçu.
"""
from __future__ import annotations

import argparse
import base64
import functools
import html
import io
import json
import mimetypes
import os
import posixpath
import re
import shutil
import subprocess
import sys
import urllib.parse
import urllib.request
import zipfile
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

HERE = Path(__file__).resolve().parent
RACINE = HERE.parents[1]
CACHE = RACINE / '.cache' / 'apercus'
BLOBS = CACHE / 'blobs'
PACKS = CACHE / 'packs'
THUMBS = CACHE / 'thumbs'
UI = HERE / 'ui'

CATALOGUE = json.loads((HERE / 'catalogue.json').read_text(encoding='utf-8'))
MANIFESTE = json.loads((HERE / 'manifeste.json').read_text(encoding='utf-8'))
FICHIERS = MANIFESTE['fichiers']
REPO = MANIFESTE['repo']
APERCUS = {a['id']: a for a in CATALOGUE['apercus']}
PACKS_PAR_ID = {p['id']: p for p in CATALOGUE['packs']}
PAR_FICHIER = {a['fichier']: a for a in CATALOGUE['apercus']}

mimetypes.add_type('text/html', '.html')
mimetypes.add_type('application/json', '.json')
mimetypes.add_type('image/webp', '.webp')
mimetypes.add_type('text/javascript', '.js')
mimetypes.add_type('text/css', '.css')
mimetypes.add_type('application/zip', '.zip')
mimetypes.add_type('image/vnd.openraster', '.ora')
mimetypes.add_type('application/octet-stream', '.rsground')
mimetypes.add_type('application/octet-stream', '.tile')
mimetypes.add_type('application/octet-stream', '.dir')
mimetypes.add_type('application/octet-stream', '.idx')


def etat() -> dict:
    p = CACHE / 'etat.json'
    if p.exists():
        try:
            return json.loads(p.read_text(encoding='utf-8'))
        except Exception:
            pass
    return {'fichiers_attendus': len(FICHIERS), 'fichiers_presents': 0,
            'packs_extraits': 0, 'vignettes': 0, 'erreurs': []}


def token_github() -> str:
    try:
        return subprocess.check_output(['gh', 'auth', 'token'], text=True).strip()
    except Exception:
        return os.environ.get('GITHUB_TOKEN', '')


def obtenir_blob(chemin: str) -> Path | None:
    """Fichier du manifeste, téléchargé à la demande s'il manque."""
    entree = FICHIERS.get(chemin)
    if not entree:
        return None
    sha, taille = entree
    cible = BLOBS / sha
    if cible.exists() and cible.stat().st_size == taille:
        return cible
    BLOBS.mkdir(parents=True, exist_ok=True)
    try:
        req = urllib.request.Request(
            f'https://api.github.com/repos/{REPO}/git/blobs/{sha}',
            headers={'Authorization': f'Bearer {token_github()}',
                     'Accept': 'application/vnd.github+json', 'User-Agent': 'arena-apercus'})
        with urllib.request.urlopen(req, timeout=120) as r:
            brut = base64.b64decode(json.load(r)['content'])
        if len(brut) != taille:
            return None
        cible.write_bytes(brut)
        return cible
    except Exception as e:
        print(f'[apercus] échec téléchargement {chemin}: {e}', file=sys.stderr, flush=True)
        return None


def chemin_sur(nom: str) -> str:
    p = nom.replace('\\', '/').lstrip('/')
    return '/'.join(x for x in p.split('/') if x not in ('', '.', '..'))


def chemin_zip(pack: dict) -> Path | None:
    entree = FICHIERS.get(pack['fichier'])
    if not entree:
        return None
    return BLOBS / entree[0]


def membre_zip(pack: dict, rel: str) -> bytes | None:
    """Lit un membre du ZIP (même les binaires non extraits)."""
    src = chemin_zip(pack)
    if not src or not src.exists():
        return None
    try:
        with zipfile.ZipFile(src) as z:
            for info in z.infolist():
                if info.is_dir():
                    continue
                if chemin_sur(info.filename) == rel:
                    return z.read(info)
    except Exception:
        pass
    return None


def liste_zip(pack: dict) -> list[dict]:
    src = chemin_zip(pack)
    if not src or not src.exists():
        return []
    out = []
    try:
        with zipfile.ZipFile(src) as z:
            for info in z.infolist():
                if info.is_dir():
                    continue
                rel = chemin_sur(info.filename)
                out.append({'f': rel, 'taille': info.file_size})
    except Exception:
        pass
    return sorted(out, key=lambda e: e['f'])


def vignette_placeholder(texte: str) -> bytes:
    t = html.escape(texte[:38])
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="320" height="180">'
            f'<rect width="320" height="180" fill="#151e26"/>'
            f'<text x="16" y="96" fill="#e7c77f" font-family="sans-serif" font-size="16">{t}</text>'
            f'</svg>').encode('utf-8')


class Handler(SimpleHTTPRequestHandler):
    server_version = 'ApercusPMDO/2.0'

    # ------------------------------------------------------------------
    # utilitaires de réponse
    # ------------------------------------------------------------------
    def envoyer(self, donnees: bytes, mime: str = 'text/html; charset=utf-8',
                nom: str | None = None, cache: bool = False):
        self.send_response(200)
        self.send_header('Content-Type', mime)
        self.send_header('Content-Length', str(len(donnees)))
        if nom:
            self.send_header('Content-Disposition', f'attachment; filename="{nom}"')
        self.send_header('Cache-Control', 'public, max-age=300' if cache else 'no-store')
        self.end_headers()
        try:
            self.wfile.write(donnees)
        except (BrokenPipeError, ConnectionResetError):
            pass

    def envoyer_fichier(self, p: Path, mime: str | None = None, nom: str | None = None,
                        cache: bool = True):
        if not p.is_file():
            return self.erreur(404, 'Fichier absent du cache')
        mime = mime or mimetypes.guess_type(p.name)[0] or 'application/octet-stream'
        if 'charset=' not in mime and (mime.startswith('text/') or mime in ('application/json', 'text/javascript', 'image/svg+xml')):
            mime += '; charset=utf-8'
        taille = p.stat().st_size
        self.send_response(200)
        self.send_header('Content-Type', mime)
        self.send_header('Content-Length', str(taille))
        if nom:
            self.send_header('Content-Disposition', f'attachment; filename="{nom}"')
        self.send_header('Cache-Control', 'public, max-age=600' if cache else 'no-store')
        self.end_headers()
        try:
            with p.open('rb') as f:
                shutil.copyfileobj(f, self.wfile, length=1024 * 256)
        except (BrokenPipeError, ConnectionResetError):
            pass

    def json(self, obj):
        self.envoyer(json.dumps(obj, ensure_ascii=False).encode('utf-8'), 'application/json; charset=utf-8')

    def erreur(self, code: int, message: str):
        corps = (f'<!doctype html><meta charset="utf-8"><title>{code}</title>'
                 f'<body style="background:#151e26;color:#e2edf2;font:16px system-ui;padding:40px">'
                 f'<h1>{code}</h1><p>{html.escape(message)}</p><p><a style="color:#e7c77f" href="/">← Galerie</a></p>').encode()
        self.send_response(code)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.send_header('Content-Length', str(len(corps)))
        self.end_headers()
        self.wfile.write(corps)

    def redirection(self, url: str):
        self.send_response(302)
        self.send_header('Location', url)
        self.send_header('Content-Length', '0')
        self.end_headers()

    # ------------------------------------------------------------------
    # routes
    # ------------------------------------------------------------------
    def do_GET(self):
        brut = urllib.parse.urlsplit(self.path)
        chemin = urllib.parse.unquote(brut.path)
        requete = urllib.parse.parse_qs(brut.query)
        if chemin.startswith('/.git') or chemin.startswith('/.cache') or chemin.startswith('/.venv'):
            return self.erreur(404, 'Accès interdit')

        # --- galerie et fichiers d'interface -----------------------------
        if chemin in ('/', '/index.html'):
            return self.envoyer_fichier(UI / 'galerie.html', 'text/html; charset=utf-8', cache=False)
        if chemin.startswith('/ui/'):
            nom = posixpath.basename(chemin)
            cible = UI / nom
            if cible.is_file():
                return self.envoyer_fichier(cible)
            return self.erreur(404, 'Ressource inconnue')
        if chemin == '/galerie.js' or chemin == '/galerie.css':
            return self.envoyer_fichier(UI / chemin.lstrip('/'))
        if chemin == '/lecteur.html':
            return self.envoyer_fichier(UI / 'lecteur.html', 'text/html; charset=utf-8', cache=False)
        if chemin in ('/lecteur.js', '/lecteur.css'):
            return self.envoyer_fichier(UI / chemin.lstrip('/'))

        # --- API ---------------------------------------------------------
        if chemin == '/api/catalogue':
            return self.json({'catalogue': CATALOGUE, 'etat': etat()})
        if chemin == '/sante' or chemin == '/api/etat':
            return self.json(etat())
        m = re.fullmatch(r'/api/pack/([a-z0-9]+)', chemin)
        if m:
            p = PACKS_PAR_ID.get(m.group(1))
            if not p:
                return self.erreur(404, 'Pack inconnu')
            return self.json({'pack': p, 'etat': etat()})
        m = re.fullmatch(r'/api/pack/([a-z0-9]+)/fichiers', chemin)
        if m:
            p = PACKS_PAR_ID.get(m.group(1))
            if not p:
                return self.erreur(404, 'Pack inconnu')
            return self.json({'fichiers': liste_zip(p)})
        m = re.fullmatch(r'/api/pack/([a-z0-9]+)/texte', chemin)
        if m:
            p = PACKS_PAR_ID.get(m.group(1))
            rel = requete.get('f', [''])[0]
            if not p or not rel or '..' in rel:
                return self.erreur(404, 'Fichier inconnu')
            extrait = PACKS / p['id'] / rel
            donnees = extrait.read_bytes() if extrait.is_file() else membre_zip(p, rel)
            if donnees is None:
                return self.erreur(404, 'Fichier inconnu')
            return self.envoyer(donnees[:400_000], 'text/plain; charset=utf-8')

        # --- vignettes ---------------------------------------------------
        m = re.fullmatch(r'/thumb/([A-Za-z0-9_.-]+)\.webp', chemin)
        if m:
            cible = THUMBS / (m.group(1) + '.webp')
            if cible.is_file():
                return self.envoyer_fichier(cible, 'image/webp')
            titre = APERCUS.get(m.group(1), {}).get('titre') or PACKS_PAR_ID.get(m.group(1), {}).get('titre') or m.group(1)
            return self.envoyer(vignette_placeholder(titre), 'image/svg+xml')

        # --- lecteur de pack --------------------------------------------
        m = re.fullmatch(r'/pack/([a-z0-9]+)/?', chemin)
        if m:
            if m.group(1) not in PACKS_PAR_ID:
                return self.erreur(404, 'Pack inconnu')
            return self.envoyer_fichier(UI / 'lecteur.html', 'text/html; charset=utf-8', cache=False)
        m = re.fullmatch(r'/pack/([a-z0-9]+)/zip', chemin)
        if m:
            p = PACKS_PAR_ID.get(m.group(1))
            src = chemin_zip(p) if p else None
            if not src or not src.is_file():
                return self.erreur(404, 'ZIP absent')
            return self.envoyer_fichier(src, 'application/zip', nom=posixpath.basename(p['fichier']))
        m = re.fullmatch(r'/pack/([a-z0-9]+)/f/(.+)', chemin)
        if m:
            p = PACKS_PAR_ID.get(m.group(1))
            if not p:
                return self.erreur(404, 'Pack inconnu')
            rel = chemin_sur(m.group(2))
            if not rel or rel.startswith('..'):
                return self.erreur(404, 'Chemin invalide')
            extrait = PACKS / p['id'] / rel
            if extrait.is_file():
                return self.envoyer_fichier(extrait)
            donnees = membre_zip(p, rel)
            if donnees is None:
                return self.erreur(404, 'Fichier absent du ZIP')
            mime = mimetypes.guess_type(rel)[0] or 'application/octet-stream'
            if mime.startswith('text/') or mime == 'application/json':
                mime += '; charset=utf-8'
            return self.envoyer(donnees, mime, cache=True)

        # --- fichiers d'origine (aperçus HTML, assets frères, ZIP racine) -
        rel = chemin.lstrip('/')
        if rel in FICHIERS:
            src = obtenir_blob(rel)
            if not src:
                return self.erreur(502, 'Fichier non restauré (GitHub inaccessible)')
            mime = mimetypes.guess_type(rel)[0] or 'application/octet-stream'
            if mime.startswith('text/') or mime in ('application/json', 'image/svg+xml'):
                mime += '; charset=utf-8'
            return self.envoyer_fichier(src, mime)

        # --- fichiers du dépôt de travail --------------------------------
        cible = (RACINE / rel).resolve()
        if RACINE in cible.parents or cible == RACINE:
            if cible.is_file() and '.git' not in cible.parts and '.cache' not in cible.parts:
                return self.envoyer_fichier(cible)
        return self.erreur(404, 'Aperçu introuvable')

    def log_message(self, fmt, *args):
        pass


class Server(ThreadingHTTPServer):
    daemon_threads = True
    allow_reuse_address = True

    def handle_error(self, request, client_address):
        if isinstance(sys.exc_info()[1], (BrokenPipeError, ConnectionResetError)):
            return
        super().handle_error(request, client_address)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--port', type=int, default=8000)
    ap.add_argument('--bind', default='0.0.0.0')
    a = ap.parse_args()
    srv = Server((a.bind, a.port), functools.partial(Handler, directory=str(RACINE)))
    e = etat()
    print(f'Aperçus des maps : http://{a.bind}:{a.port}/', flush=True)
    print(f"  {len(CATALOGUE['apercus'])} aperçus HTML · {len(CATALOGUE['packs'])} packs ZIP · "
          f"{len(CATALOGUE['chantiers'])} chantiers · "
          f"{e['fichiers_presents']}/{e['fichiers_attendus']} fichiers restaurés", flush=True)
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass
