#!/usr/bin/env python3
"""Restaure TOUS les aperçus de maps, y compris ceux qui ne vivent que dans un ZIP.

Le script est idempotent et ne dépend que de la bibliothèque standard (+ Pillow,
facultatif, pour les vignettes). Il :

1. télécharge les 532 fichiers du `manifeste.json` (aperçus HTML, archives ZIP,
   et tous les GIF/PNG/JSON frères référencés par les pages) ;
2. extrait les médias de chaque ZIP dans `.cache/apercus/packs/<id>/` —
   calques, frames, WebP/GIF animés, HTML embarqués, manifestes ;
3. fabrique une vignette 320×180 par aperçu et par pack ;
4. écrit `.cache/apercus/etat.json` (bilan lisible par le serveur).

Les gros binaires de jeu (.rsground, .tile, .dir, .idx, .ora) restent dans le ZIP
et sont servis à la demande : rien n'est perdu, mais on évite 4,5 Go d'extraction.

Usage :
    .venv/bin/python source/serveur_apercus/restaurer.py
    python3 source/serveur_apercus/restaurer.py --sans-vignettes
"""
from __future__ import annotations

import argparse
import base64
import concurrent.futures
import io
import json
import os
import re
import subprocess
import sys
import time
import urllib.request
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
RACINE = HERE.parents[1]
CACHE = RACINE / '.cache' / 'apercus'
BLOBS = CACHE / 'blobs'
PACKS = CACHE / 'packs'
THUMBS = CACHE / 'thumbs'

MANIFESTE = json.loads((HERE / 'manifeste.json').read_text(encoding='utf-8'))
CATALOGUE = json.loads((HERE / 'catalogue.json').read_text(encoding='utf-8'))
REPO = MANIFESTE['repo']

A_EXTRAIRE = {'.png', '.webp', '.gif', '.apng', '.jpg', '.jpeg', '.html', '.htm',
              '.json', '.md', '.txt', '.svg', '.csv', '.xml', '.cfg', '.py', '.lua', '.tsx'}
THUMB_SIZE = (320, 180)

try:
    from PIL import Image, ImageDraw, ImageFont, ImageOps
    PIL = True
except ImportError:
    PIL = False


def token_github() -> str:
    try:
        return subprocess.check_output(['gh', 'auth', 'token'], text=True).strip()
    except Exception:
        return os.environ.get('GITHUB_TOKEN', '')


TOKEN = token_github()


def telecharger(item: tuple[str, list]) -> tuple[str, str]:
    chemin, (sha, taille) = item
    cible = BLOBS / sha
    if cible.exists() and cible.stat().st_size == taille:
        return chemin, 'déjà là'
    url = f'https://api.github.com/repos/{REPO}/git/blobs/{sha}'
    req = urllib.request.Request(url, headers={
        'Authorization': f'Bearer {TOKEN}', 'Accept': 'application/vnd.github+json',
        'User-Agent': 'arena-apercus'})
    for essai in range(3):
        try:
            with urllib.request.urlopen(req, timeout=300) as r:
                brut = base64.b64decode(json.load(r)['content'])
            if len(brut) != taille:
                raise ValueError(f'{len(brut)} octets au lieu de {taille}')
            tmp = cible.with_suffix('.tmp')
            tmp.write_bytes(brut)
            tmp.replace(cible)
            return chemin, 'téléchargé'
        except Exception as e:
            if essai == 2:
                return chemin, f'ERREUR {e}'
            time.sleep(1 + essai)
    return chemin, 'ERREUR'


def chemin_sur(nom: str) -> str:
    p = nom.replace('\\', '/').lstrip('/')
    return '/'.join(x for x in p.split('/') if x not in ('', '.', '..'))


def extraire_zip(pack: dict) -> tuple[str, int, str]:
    """Extrait les médias d'un pack. Renvoie (id, nb fichiers, erreur éventuelle)."""
    sha = next((v[0] for k, v in MANIFESTE['fichiers'].items() if k == pack['fichier']), None)
    if not sha:
        return pack['id'], 0, 'sha introuvable'
    src = BLOBS / sha
    if not src.exists():
        return pack['id'], 0, 'blob absent'
    dest = PACKS / pack['id']
    marqueur = dest / '.extrait'
    if marqueur.exists():
        try:
            return pack['id'], int(marqueur.read_text().strip() or 0), ''
        except Exception:
            return pack['id'], 0, ''
    n = 0
    try:
        with zipfile.ZipFile(src) as z:
            for info in z.infolist():
                if info.is_dir():
                    continue
                rel = chemin_sur(info.filename)
                if not rel or os.path.splitext(rel)[1].lower() not in A_EXTRAIRE:
                    continue
                if info.file_size > 60_000_000:      # sécurité
                    continue
                cible = dest / rel
                cible.parent.mkdir(parents=True, exist_ok=True)
                with z.open(info) as f, open(cible, 'wb') as out:
                    out.write(f.read())
                n += 1
        dest.mkdir(parents=True, exist_ok=True)
        marqueur.write_text(str(n))
        return pack['id'], n, ''
    except Exception as e:
        return pack['id'], n, f'ERREUR {e}'


def vignette(im: 'Image.Image', cible: Path) -> bool:
    try:
        im = im.convert('RGBA')
        fond = Image.new('RGBA', im.size, (16, 22, 28, 255))
        fond.alpha_composite(im)
        im = ImageOps.fit(fond.convert('RGB'), THUMB_SIZE, method=Image.Resampling.NEAREST, centering=(0.5, 0.5))
        cible.parent.mkdir(parents=True, exist_ok=True)
        im.save(cible, 'WEBP', quality=82, method=4)
        return True
    except Exception:
        return False


def vignette_texte(titre: str, cible: Path) -> bool:
    try:
        im = Image.new('RGB', THUMB_SIZE, (21, 30, 38))
        d = ImageDraw.Draw(im)
        for i in range(0, THUMB_SIZE[0], 16):
            d.line((i, 0, i, THUMB_SIZE[1]), fill=(27, 39, 49))
        for j in range(0, THUMB_SIZE[1], 16):
            d.line((0, j, THUMB_SIZE[0], j), fill=(27, 39, 49))
        try:
            police = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 15)
        except Exception:
            police = ImageFont.load_default()
        mots, lignes, ligne = titre.split(), [], ''
        for m in mots:
            if len(ligne + ' ' + m) > 27:
                lignes.append(ligne)
                ligne = m
            else:
                ligne = (ligne + ' ' + m).strip()
        lignes.append(ligne)
        y = THUMB_SIZE[1] // 2 - len(lignes) * 11
        for l in lignes[:5]:
            d.text((14, y), l, fill=(231, 199, 127), font=police)
            y += 22
        cible.parent.mkdir(parents=True, exist_ok=True)
        im.save(cible, 'WEBP', quality=82)
        return True
    except Exception:
        return False


def score_image(im: 'Image.Image') -> float:
    """Favorise une image vaste et largement opaque (= la scène, pas un calque isolé)."""
    try:
        aire = im.width * im.height
        if not (6000 <= aire <= 40_000_000):
            return -1
        alpha = im.convert('RGBA').getchannel('A')
        from PIL import ImageStat
        couverture = ImageStat.Stat(alpha).mean[0] / 255.0
        return aire * (0.15 + couverture)
    except Exception:
        return -1


def image_depuis_html(texte: str) -> 'Image.Image | None':
    """Recompose la scène en empilant les calques embarqués dans leur ordre.

    Un aperçu autonome ne contient pas une seule image de la map mais tous ses
    calques en data-URI. Prendre une seule image donnerait un fond vide ; on
    compose donc les calques de la taille dominante, comme le fait la page.
    """
    if not PIL:
        return None
    images: list[Image.Image] = []
    for i, m in enumerate(re.finditer(r'data:image/[^;]+;base64,([A-Za-z0-9+/=\s]+)', texte)):
        if i >= 110:
            break
        try:
            brut = base64.b64decode(re.sub(r'\s+', '', m.group(1)))
            im = Image.open(io.BytesIO(brut)).convert('RGBA')
            im.load()
            if 6000 <= im.width * im.height <= 40_000_000:
                images.append(im)
        except Exception:
            continue
    if not images:
        return None
    tailles: dict[tuple[int, int], int] = {}
    for im in images:
        tailles[im.size] = tailles.get(im.size, 0) + 1
    W, H = max(tailles, key=lambda t: (tailles[t], t[0] * t[1]))
    fond = Image.new('RGBA', (W, H), (16, 22, 28, 255))
    for im in images:
        if im.size == (W, H):
            fond.alpha_composite(im, (0, 0))
    return fond


def composition_scene(z, par_rel: dict, scene: dict) -> 'Image.Image | None':
    """Compose la première frame de chaque calque d'une scène de pack ZIP."""
    if not PIL or not scene or not scene.get('calques'):
        return None
    couches = sorted(scene['calques'], key=lambda c: (c.get('ordre', 99), c.get('nom', '')))
    images = []
    for c in couches[:40]:
        rel = c['f'][0]
        info = par_rel.get(rel)
        if not info:
            continue
        try:
            im = Image.open(io.BytesIO(z.read(info))).convert('RGBA')
            im.load()
            images.append(im)
        except Exception:
            continue
    if not images:
        return None
    W = max(i.width for i in images)
    H = max(i.height for i in images)
    fond = Image.new('RGBA', (W, H), (16, 22, 28, 255))
    for im in images:
        fond.alpha_composite(im, (0, 0))
    return fond


def vignette_apercu(a: dict) -> tuple[str, bool]:
    cible = THUMBS / (a['id'] + '.webp')
    if cible.exists():
        return a['id'], True
    sha_taille = MANIFESTE['fichiers'].get(a['fichier'])
    if not sha_taille:
        return a['id'], False
    p = BLOBS / sha_taille[0]
    if not p.exists():
        return a['id'], False
    try:
        im = image_depuis_html(p.read_text(encoding='utf-8', errors='ignore'))
    except Exception:
        im = None
    if im is not None:
        return a['id'], vignette(im, cible)
    # page de redirection : lire la vraie page cible (renders/<lot>/index.html)
    if a.get('redirect'):
        cible_html = MANIFESTE['fichiers'].get(a['redirect'])
        if cible_html and (BLOBS / cible_html[0]).exists():
            im = image_depuis_html((BLOBS / cible_html[0]).read_text(encoding='utf-8', errors='ignore'))
            if im is not None and vignette(im, cible):
                return a['id'], True
        r = Path(a['redirect']).parent.name
        src = THUMBS / (r + '.webp')
        if src.exists():
            cible.write_bytes(src.read_bytes())
            return a['id'], True
    return a['id'], (vignette_texte(a['titre'], cible) if PIL else False)


def vignette_pack(pack: dict) -> tuple[str, bool]:
    cible = THUMBS / (pack['id'] + '.webp')
    if cible.exists():
        return pack['id'], True
    if not PIL:
        return pack['id'], False
    sha_taille = MANIFESTE['fichiers'].get(pack['fichier'])
    if not sha_taille:
        return pack['id'], False
    p = BLOBS / sha_taille[0]
    if not p.exists():
        return pack['id'], False
    # Priorité : composition du pack > aperçu HTML > scène recomposée > animation > calque isolé.
    try:
        with zipfile.ZipFile(p) as z:
            par_rel = {chemin_sur(i.filename): i for i in z.infolist() if not i.is_dir()}
            meilleure, meilleur_score = None, -1

            def proposer(im, bonus):
                nonlocal meilleure, meilleur_score
                if im is None:
                    return
                s = score_image(im) + bonus
                if s > meilleur_score:
                    meilleure, meilleur_score = im.copy(), s

            # 1. les images « composition » déjà composites du pack
            for x in pack['images'][:12]:
                info = par_rel.get(x['f'])
                if not info:
                    continue
                try:
                    im = Image.open(io.BytesIO(z.read(info))).convert('RGBA'); im.load()
                    proposer(im, 3_000_000)
                except Exception:
                    pass
            # 2. les aperçus HTML embarqués, recomposés calque par calque
            for h in pack['html'][:3]:
                info = par_rel.get(h['f'])
                if not info:
                    continue
                try:
                    proposer(image_depuis_html(z.read(info).decode('utf-8', 'ignore')), 2_500_000)
                except Exception:
                    pass
            # 3. la première scène du pack, recomposée depuis ses frames
            for sc in pack['scenes'][:2]:
                proposer(composition_scene(z, par_rel, sc), 2_000_000)
            # 4. première frame d'une animation native
            for an in pack['animations'][:6]:
                info = par_rel.get(an['f'])
                if not info:
                    continue
                try:
                    im = Image.open(io.BytesIO(z.read(info))).convert('RGBA'); im.load()
                    proposer(im, 1_000_000)
                except Exception:
                    pass
            # 5. à défaut, le premier calque
            for sc in pack['scenes'][:3]:
                for c in sc['calques'][:6]:
                    info = par_rel.get(c['f'][0])
                    if not info:
                        continue
                    try:
                        im = Image.open(io.BytesIO(z.read(info))).convert('RGBA'); im.load()
                        proposer(im, 0)
                    except Exception:
                        pass
            if meilleure is not None and vignette(meilleure, cible):
                return pack['id'], True
    except Exception:
        pass
    # lien vers un aperçu autonome
    if pack.get('apercu_lie'):
        src = THUMBS / (pack['apercu_lie'] + '.webp')
        if src.exists():
            cible.write_bytes(src.read_bytes())
            return pack['id'], True
    return pack['id'], vignette_texte(pack['titre'], cible)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument('--sans-vignettes', action='store_true')
    ap.add_argument('--force', action='store_true', help='réextraire tous les ZIP')
    ap.add_argument('--parallel', type=int, default=8)
    a = ap.parse_args()
    global PIL
    if a.sans_vignettes:
        PIL = False

    for d in (BLOBS, PACKS, THUMBS):
        d.mkdir(parents=True, exist_ok=True)

    fichiers = MANIFESTE['fichiers']
    t = time.time()
    print(f'1/4 — {len(fichiers)} fichiers distant ({sum(v[1] for v in fichiers.values())/1e6:.0f} Mo)', flush=True)
    erreurs = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=a.parallel) as ex:
        for i, (chemin, statut) in enumerate(ex.map(telecharger, fichiers.items()), 1):
            if statut.startswith('ERREUR'):
                erreurs.append((chemin, statut))
                print('  !', chemin, statut, flush=True)
            if i % 100 == 0:
                print(f'  {i}/{len(fichiers)}  {time.time()-t:.0f}s', flush=True)
    print(f'  téléchargement terminé en {time.time()-t:.0f}s', flush=True)

    t = time.time()
    print(f'2/4 — extraction des médias de {len(CATALOGUE["packs"])} ZIP', flush=True)
    if a.force:
        for m in PACKS.glob('*/.extrait'):
            m.unlink()
    extraits = 0
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as ex:
        for i, (pid, n, err) in enumerate(ex.map(extraire_zip, CATALOGUE['packs']), 1):
            extraits += n
            if err:
                erreurs.append((pid, err))
            if i % 50 == 0:
                print(f'  {i}/{len(CATALOGUE["packs"])}', flush=True)
    print(f'  {extraits} fichiers extraits en {time.time()-t:.0f}s', flush=True)

    thumbs = 0
    if PIL:
        t = time.time()
        print('3/4 — vignettes', flush=True)
        for a_ in CATALOGUE['apercus']:
            _, ok = vignette_apercu(a_)
            thumbs += int(ok)
        for p in CATALOGUE['packs']:
            _, ok = vignette_pack(p)
            thumbs += int(ok)
        print(f'  {thumbs} vignettes en {time.time()-t:.0f}s', flush=True)
    else:
        print('3/4 — vignettes ignorées (Pillow absent)', flush=True)

    etat = {
        'termine_le': time.strftime('%Y-%m-%d %H:%M:%S UTC', time.gmtime()),
        'fichiers_attendus': len(fichiers),
        'fichiers_presents': sum(1 for sha, taille in fichiers.values()
                                 if (BLOBS / sha).exists() and (BLOBS / sha).stat().st_size == taille),
        'volume_mo': round(sum(v[1] for v in fichiers.values()) / 1e6, 1),
        'packs_extraits': sum(1 for p in CATALOGUE['packs'] if (PACKS / p['id'] / '.extrait').exists()),
        'fichiers_extraits': extraits,
        'vignettes': thumbs,
        'erreurs': [{'fichier': f, 'erreur': e} for f, e in erreurs[:50]],
    }
    CACHE.mkdir(parents=True, exist_ok=True)
    (CACHE / 'etat.json').write_text(json.dumps(etat, ensure_ascii=False, indent=2), encoding='utf-8')
    print('4/4 — bilan :', json.dumps(etat, ensure_ascii=False)[:400], flush=True)
    if erreurs:
        print(f'ATTENTION : {len(erreurs)} erreur(s)', file=sys.stderr)


if __name__ == '__main__':
    main()
