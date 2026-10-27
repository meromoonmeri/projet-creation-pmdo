#!/usr/bin/env python3
"""Construit le catalogue complet des aperçus de maps (HTML + packs ZIP).

Le catalogue est fabriqué à partir de l'arbre Git du dépôt source
`meromoonmeri/projet-pmdo` et des blobs déjà présents dans le cache local
`.cache/apercus/blobs/`. Il décrit :

* les 166 aperçus HTML autonomes de la racine (avec leurs animations) ;
* les 200 archives ZIP, y compris celles qui ne contiennent que des données
  PMDO natives (.rsground/.tile) : calques, frames, animations WebP/GIF,
  aperçus HTML embarqués, cadences relevées dans les manifestes ;
* les 208 chantiers `source/`, reliés à leur aperçu ou à leur pack ;
* la liste exacte des fichiers distants à restaurer (`manifeste.json`).

Usage :
    python3 source/serveur_apercus/construire_catalogue.py \
        --arbre /tmp/arbre_main.json
    # sans --arbre : l'arbre est téléchargé depuis l'API GitHub
"""
from __future__ import annotations

import argparse
import base64
import collections
import html as html_mod
import json
import os
import posixpath
import re
import statistics
import struct
import subprocess
import sys
import urllib.request
import zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
RACINE = HERE.parents[1]
CACHE = RACINE / '.cache' / 'apercus'
BLOBS = CACHE / 'blobs'
REPO = 'meromoonmeri/projet-pmdo'
REF = '6cca4a09380211e510ab1bea454a1b1926ef4b5a'

# ---------------------------------------------------------------------------
# Arbre distant
# ---------------------------------------------------------------------------


def arbre_git(ref: str) -> list[dict]:
    try:
        token = subprocess.check_output(['gh', 'auth', 'token'], text=True).strip()
    except Exception:
        token = os.environ.get('GITHUB_TOKEN', '')
    req = urllib.request.Request(
        f'https://api.github.com/repos/{REPO}/git/trees/{ref}?recursive=1',
        headers={'Authorization': f'Bearer {token}', 'Accept': 'application/vnd.github+json',
                 'User-Agent': 'arena-apercus'})
    with urllib.request.urlopen(req, timeout=180) as r:
        data = json.load(r)
    if data.get('truncated'):
        raise RuntimeError('Arbre GitHub tronqué')
    return data['tree']


def blob(path: str, entree: dict) -> bytes:
    p = BLOBS / entree['sha']
    if p.exists():
        return p.read_bytes()
    try:
        token = subprocess.check_output(['gh', 'auth', 'token'], text=True).strip()
    except Exception:
        token = os.environ.get('GITHUB_TOKEN', '')
    req = urllib.request.Request(
        f"https://api.github.com/repos/{REPO}/git/blobs/{entree['sha']}",
        headers={'Authorization': f'Bearer {token}', 'Accept': 'application/vnd.github+json',
                 'User-Agent': 'arena-apercus'})
    with urllib.request.urlopen(req, timeout=300) as r:
        raw = base64.b64decode(json.load(r)['content'])
    BLOBS.mkdir(parents=True, exist_ok=True)
    p.write_bytes(raw)
    return raw


def titre_de(s: str, repli: str) -> str:
    m = re.search(r'<title>(.*?)</title>', s[:8000], re.S | re.I)
    return html_mod.unescape(m.group(1).strip()) if m else repli


# ---------------------------------------------------------------------------
# Catégories
# ---------------------------------------------------------------------------

CATEGORIES = [
    ('Entrées sud → nord', lambda n: ('entree_' in n and '_sud_nord_' in n) or n.startswith('apercu_entree_')),
    ('Fins de donjon', lambda n: n.startswith('apercu_fin_') or '_fin_' in n),
    ('Zone Zéro', lambda n: 'zone_zero' in n),
    ('Côtes & Métano', lambda n: any(k in n for k in ('cote', 'metano', 'falaise', 'abyss'))),
    ('Aurores & glace', lambda n: any(k in n for k in ('boreal', 'aurore', 'glace', 'givre', 'halcyon'))),
    ('Magma & cendres', lambda n: any(k in n for k in ('cendre', 'magma', 'groudon', 'cratere', 'lave'))),
    ('Eau & cascades', lambda n: any(k in n for k in ('cascade', 'waterfall', 'siphon', 'antre', 'bassin', 'ecume', 'eau', 'lac', 'ocean'))),
    ('Arènes', lambda n: 'arene' in n or 'arena' in n),
    ('Café Spinda', lambda n: any(k in n for k in ('cafe', 'spinda', 'casino'))),
    ('Plages', lambda n: any(k in n for k in ('beach', 'plage'))),
    ('Tours & panoramas', lambda n: any(k in n for k in ('tour', 'panorama', 'mont_horn', 'sky_peak'))),
    ('Sprites & Pokémon', lambda n: any(k in n for k in ('mega', 'carapagos', 'tirtouga', 'portrait', 'sprite', 'gardevoir', 'transformation', 'couronne', 'tera', 'expression', 'tarpaud'))),
    ('Guilde Treehouse', lambda n: any(k in n for k in ('guilde', 'structure', 'vegetation', 'pont'))),
    ('Donjons', lambda n: any(k in n for k in ('donjon', 'dungeon', 'dtef', 'zone_reveil', 'zone_'))),
]


def categorie(nom: str) -> str:
    n = nom.lower()
    for label, test in CATEGORIES:
        if test(n):
            return label
    return 'Autres lots'


def mots_de(nom: str) -> str:
    return ' '.join(re.findall(r'[a-zàâçéèêëîïôûùüÿñæœ0-9]+', nom.lower().replace('_', ' ')))


def joli(nom: str) -> str:
    s = nom.replace('_', ' ').replace('-', ' ').strip()
    return s[:1].upper() + s[1:] if s else nom


# ---------------------------------------------------------------------------
# Analyse d'une archive ZIP
# ---------------------------------------------------------------------------

GENERIQUES = {
    'animation', 'animations', 'anim', 'calques', 'layers', 'layer', 'contenu', 'content',
    'frames', 'frame', 'renders', 'render', 'exports', 'export', 'source', 'src', 'sprites',
    'sprite', 'pack', 'zip', 'data', 'assets', 'asset', 'images', 'image', 'img', 'png',
    'output', 'out', 'apercu', 'apercus', 'bruts', 'raw', 'tiles', 'tilesheets',
    'caches', 'tmp', 'build', 'dist', 'review', 'previews',
}
VARIANTES = {'jour', 'nuit', 'aube', 'crepuscule', 'soir', 'matin', 'day', 'night', 'dawn', 'dusk',
             'normal', 'fade', 'fading', 'flash', 'ete', 'hiver', 'automne', 'printemps'}
A_EXCLURE = (
    'masque', 'planche', 'composition', 'vue_ensemble', 'apercu', 'thumb', 'vignette',
    'contact', 'review', 'compare', 'comparaison', 'audit', 'test', 'temoin', 'echelle',
    'credits', 'sprite', 'atlas', 'palette', 'verification', 'mask', 'sheet', 'legend',
    'grille', 'grid', 'preview', 'diagram', 'schema', 'debug', 'montage', 'strip',
    'sequence_', 'planche_', 'reference_', 'provenance',
)
MEDIA = {'.png', '.webp', '.gif', '.jpg', '.jpeg', '.html', '.htm', '.json', '.md', '.txt', '.svg', '.apng'}
A_EXTRAIRE = MEDIA | {'.ora', '.py', '.lua', '.xml', '.cfg', '.csv', '.tmj', '.tsj', '.idx', '.tile', '.npz'}


def chemin_sur(nom: str) -> str:
    """Normalise un nom de membre ZIP en chemin relatif sûr."""
    p = nom.replace('\\', '/').lstrip('/')
    parts = [x for x in p.split('/') if x not in ('', '.', '..')]
    return '/'.join(parts)


def scene_de(rel: str, projet: str) -> str:
    parts = rel.split('/')[:-1]
    while parts and (parts[0].lower() in GENERIQUES or parts[0].lower() == projet.lower()):
        parts.pop(0)
    if not parts:
        return 'principal'
    if len(parts) > 1 and parts[1].lower() in VARIANTES:
        parts = parts[:2]
    else:
        parts = parts[:1]
    return '/'.join(parts).lower()


def rang_calque(chemin: str) -> int:
    """Rang de superposition déduit de l'indice numérique du nom (01_sol, 12_bulles…)."""
    base = chemin.rsplit('/', 1)[-1]
    base = re.sub(r'(?:f)?\d{2,4}(?=\.(?:png|webp|gif|jpe?g)$)', '', base, flags=re.I)
    nombres = re.findall(r'(?<![A-Za-z0-9])(\d{1,2})(?![0-9])', base)
    valeurs = [int(x) for x in nombres if int(x) <= 60]
    return valeurs[0] if valeurs else 99


def dimensions_png(z: zipfile.ZipFile, info: zipfile.ZipInfo) -> tuple[int, int]:
    try:
        with z.open(info) as f:
            entete = f.read(24)
        if len(entete) >= 24 and entete[:8] == b'\x89PNG\r\n\x1a\n':
            return struct.unpack('>II', entete[16:24])
    except Exception:
        pass
    return (0, 0)


def cle_frame(nom: str) -> tuple[str, int] | None:
    """`aube_012.png` -> (`aube_#.png`, 12)."""
    m = re.search(r'(\d{2,4})\.(png|webp|gif|jpe?g)$', nom, re.I)
    if not m:
        return None
    return nom[:m.start(1)] + '#' + nom[m.start(1) + len(m.group(1)):], int(m.group(1))


MS_KEYS = re.compile(r'(frame_ms|duree_ms|duration_ms|delai_ms|delay_ms|tick_ms|ms_par_frame|'
                     r'ms_frame|frame_duration_ms|intervalle_ms|pas_ms|duree_frame_ms|milliseconds|^ms$)', re.I)
SEC_KEYS = re.compile(r'(seconds|secondes|duration_s|duree_s|loop_s)', re.I)
FPS_KEYS = re.compile(r'(fps|images_par_seconde)', re.I)
TICK_KEYS = re.compile(r'(frame_ticks|frame_length_ticks|framelength|duration_game_frames|'
                       r'scene_loop_ticks|tick_length|^ticks$|frame_duration_ticks)', re.I)


def valeurs(json_txt: str) -> list[tuple[int, float, str]]:
    """Renvoie (priorité, ms, origine) pour toutes les cadences trouvées."""
    try:
        obj = json.loads(json_txt)
    except Exception:
        return []
    out: list[tuple[int, float, str]] = []

    def walk(o, chemin=''):
        if isinstance(o, dict):
            for k, v in o.items():
                p = f'{chemin}.{k}' if chemin else str(k)
                kl = str(k).lower()
                if isinstance(v, (int, float)) and not isinstance(v, bool):
                    if MS_KEYS.search(kl) and 16 <= v <= 2000:
                        out.append((1, float(v), p))
                    elif SEC_KEYS.search(kl) and 0.01 <= v <= 20:
                        out.append((1, float(v) * 1000, p))
                    elif FPS_KEYS.search(kl) and 1 <= v <= 240:
                        out.append((1, 1000.0 / float(v), p))
                    elif TICK_KEYS.search(kl) and 1 <= v <= 60:
                        out.append((2, float(v) * 1000.0 / 60.0, p))
                walk(v, p)
        elif isinstance(o, list):
            for x in o[:60]:
                walk(x, chemin)
    walk(obj)
    return out


def cadence_du_pack(z: zipfile.ZipFile, noms: list[str], info_par_nom: dict) -> tuple[int, str, int]:
    candidats: list[tuple[int, float, str]] = []
    for n in noms:
        if not n.lower().endswith('.json'):
            continue
        info = info_par_nom.get(n)
        if not info or info.file_size > 1_500_000:
            continue
        try:
            candidats += valeurs(z.read(info).decode('utf-8', 'ignore'))
        except Exception:
            pass
    if candidats:
        prio = min(c[0] for c in candidats)
        vals = [c[1] for c in candidats if c[0] == prio and 16 <= c[1] <= 2000]
        if vals:
            return round(statistics.median(vals)), ('manifeste JSON' if prio == 1 else 'ticks PMDO (60 i/s)'), len(vals)
    # repli : les « NN ms » des README
    lecture: list[int] = []
    for n in noms:
        info = info_par_nom.get(n)
        if info and n.lower().endswith(('.md', '.txt')) and info.file_size < 200_000:
            t = z.read(info).decode('utf-8', 'ignore')
            lecture += [int(x) for x in re.findall(r'(\d{2,4})\s*ms\b', t, re.I) if 16 <= int(x) <= 2000]
    if lecture:
        return round(statistics.median(lecture)), 'README du pack', len(lecture)
    return 100, 'cadence par défaut (100 ms)', 0


def analyse_zip(entree: dict, contenu: bytes, project_path: str) -> dict:
    import io
    z = zipfile.ZipFile(io.BytesIO(contenu))
    infos = [i for i in z.infolist() if not i.is_dir()]
    noms = [chemin_sur(i.filename) for i in infos]
    info_par_nom = {chemin_sur(i.filename): i for i in infos}
    projet = Path(project_path).stem.replace('_pack', '')

    html_embarques, animations, grounds, images = [], [], [], []
    scenes: dict[str, dict] = collections.OrderedDict()
    groupes: dict[tuple[str, str], list[tuple[int, str]]] = collections.defaultdict(list)
    compte = collections.Counter()
    poids = 0

    for nom in noms:
        info = info_par_nom[nom]
        poids += info.file_size
        ext = os.path.splitext(nom)[1].lower()
        compte[ext] += 1
        bas = nom.rsplit('/', 1)[-1]
        if ext in ('.html', '.htm'):
            html_embarques.append({'f': nom, 'taille': info.file_size,
                                   'titre': titre_de(z.read(info).decode('utf-8', 'ignore'), bas)})
        if ext in ('.webp', '.gif', '.apng'):
            animations.append({'f': nom, 'taille': info.file_size})
        if ext == '.rsground':
            grounds.append({'f': nom, 'nom': os.path.splitext(bas)[0]})
        if ext not in ('.png', '.jpg', '.jpeg'):
            continue
        if any(k in bas.lower() for k in A_EXCLURE):
            images.append({'f': nom, 'taille': info.file_size})
            continue
        scene = scene_de(nom, projet)
        grp = cle_frame(bas)
        if grp:
            cle, num = grp
            groupes[(scene, nom.rsplit('/', 1)[0] + '/' + cle)].append((num, nom))
        else:
            sc = scenes.setdefault(scene, {'id': scene, 'label': joli(scene), 'calques': [], 'largeur': 0, 'hauteur': 0})
            w, h = dimensions_png(z, info)
            sc['largeur'] = max(sc['largeur'], w)
            sc['hauteur'] = max(sc['hauteur'], h)
            sc['calques'].append({'nom': os.path.splitext(bas)[0], 'type': 'fixe', 'f': [nom], 'visible': True, 'ordre': rang_calque(nom)})

    for (scene, cle), valeurs_triees in groupes.items():
        valeurs_triees.sort()
        if len(valeurs_triees) < 2:
            nom = valeurs_triees[0][1]
            bas = nom.rsplit('/', 1)[-1]
            if any(k in bas.lower() for k in A_EXCLURE):
                continue
            sc = scenes.setdefault(scene, {'id': scene, 'label': joli(scene), 'calques': [], 'largeur': 0, 'hauteur': 0})
            w, h = dimensions_png(z, info_par_nom[nom])
            sc['largeur'], sc['hauteur'] = max(sc['largeur'], w), max(sc['hauteur'], h)
            sc['calques'].append({'nom': os.path.splitext(bas)[0], 'type': 'fixe', 'f': [nom], 'visible': True, 'ordre': rang_calque(nom)})
            continue
        fichiers = [n for _, n in valeurs_triees[:256]]
        w, h = dimensions_png(z, info_par_nom[fichiers[0]])
        sc = scenes.setdefault(scene, {'id': scene, 'label': joli(scene), 'calques': [], 'largeur': 0, 'hauteur': 0})
        sc['largeur'], sc['hauteur'] = max(sc['largeur'], w), max(sc['hauteur'], h)
        sc['calques'].append({'nom': os.path.splitext(cle.rsplit('/', 1)[-1])[0].replace('#', '').rstrip('_'),
                              'type': 'anime', 'f': fichiers, 'visible': True, 'ordre': rang_calque(fichiers[0])})

    cadence, source_cadence, nb_cadences = cadence_du_pack(z, noms, info_par_nom)
    liste_scenes = []
    for sc in scenes.values():
        sc['calques'].sort(key=lambda c: (c.get('ordre', 99), c['nom']))
        sc['nb_frames'] = max([len(c['f']) for c in sc['calques']] + [1])
        sc['cadence_ms'] = cadence
        if sc['largeur'] and sc['hauteur'] and sc['calques']:
            liste_scenes.append(sc)
    liste_scenes.sort(key=lambda s: (-s['nb_frames'], s['id']))

    return {
        'nb_fichiers': len(infos), 'poids_decompresse': poids,
        'extensions': dict(compte.most_common()),
        'html': html_embarques, 'animations': animations, 'grounds': grounds,
        'images': images[:60], 'scenes': liste_scenes[:24],
        'cadence_ms': cadence, 'cadence_source': source_cadence, 'nb_cadences': nb_cadences,
        'mod': bool(grounds) and not any(s['nb_frames'] > 1 for s in liste_scenes),
    }


# ---------------------------------------------------------------------------
# Dépendances des pages HTML
# ---------------------------------------------------------------------------


def dependances_html(par_chemin: dict[str, dict], html_initiaux: list[str]) -> set[str]:
    vus, deps, file = set(), set(), list(html_initiaux)
    while file:
        p = file.pop()
        if p in vus or p not in par_chemin:
            continue
        vus.add(p)
        s = blob(p, par_chemin[p]).decode('utf-8', 'ignore')
        for r in re.findall(r'(?:src|href|data-src)\s*=\s*["\']([^"\']+)["\']', s):
            if r.startswith(('data:', '#', 'javascript:', 'blob:', 'http://', 'https://', 'mailto:')):
                continue
            r = r.split('?')[0].split('#')[0]
            if not r:
                continue
            q = posixpath.normpath(posixpath.join(posixpath.dirname(p), r))
            if q in par_chemin:
                deps.add(q)
                if q.endswith(('.html', '.htm')):
                    file.append(q)
    return deps


# ---------------------------------------------------------------------------
# Associations
# ---------------------------------------------------------------------------


def normalise(nom: str) -> str:
    s = nom.lower()
    s = re.sub(r'^apercu[_-]', '', s)
    s = re.sub(r'\.(html?|zip)$', '', s)
    s = re.sub(r'[^a-z0-9]+', '', s)
    for suffixe in ('pack', 'calques', 'calquespng8px', 'projetpmdo0812', 'pmdo0812', 'archive'):
        if s.endswith(suffixe):
            s = s[:-len(suffixe)]
    return s


def lier(chantier: str, apercus: list[dict], packs: list[dict]) -> tuple[str | None, str | None]:
    base = os.path.basename(chantier.rstrip('/'))
    n = normalise(base)
    meilleur_a, score_a = None, 0
    for a in apercus:
        m = normalise(Path(a['fichier']).stem)
        score = (3 if n == m else 2 if n and (n in m or m in n) else
                 1 if n[:10] and n[:10] == m[:10] else 0)
        if score > score_a:
            meilleur_a, score_a = a['id'], score
    meilleur_p, score_p = None, 0
    for p in packs:
        m = normalise(Path(p['fichier']).parent.name + '_' + Path(p['fichier']).stem)
        score = (3 if n == m else 2 if n and (n in m or m in n) else
                 1 if n[:10] and n[:10] == m[:10] else 0)
        if score > score_p:
            meilleur_p, score_p = p['id'], score
    return (meilleur_a if score_a >= 2 else None, meilleur_p if score_p >= 2 else None)


# ---------------------------------------------------------------------------
# Construction
# ---------------------------------------------------------------------------


def construire(arbre: list[dict]) -> tuple[dict, dict]:
    par_chemin = {e['path']: e for e in arbre if e['type'] == 'blob'}
    dossiers_source = sorted({e['path'].split('/')[1] for e in arbre
                              if e['type'] == 'blob' and e['path'].startswith('source/')
                              and e['path'].count('/') >= 2})

    root_html = sorted(p for p in par_chemin if '/' not in p and p.lower().endswith(('.html', '.htm')))
    renders_html = sorted(p for p in par_chemin if p.startswith('renders/') and p.lower().endswith(('.html', '.htm')))
    zips = sorted(p for p in par_chemin if p.lower().endswith('.zip'))

    deps = dependances_html(par_chemin, root_html + renders_html)
    fichiers_necessaires = set(root_html) | set(renders_html) | set(zips) | deps
    manifeste = {p: [par_chemin[p]['sha'], par_chemin[p]['size']] for p in sorted(fichiers_necessaires)}

    # --- aperçus HTML ------------------------------------------------------
    apercus = []
    for p in root_html:
        e = par_chemin[p]
        s = blob(p, e).decode('utf-8', 'ignore')
        redirect = None
        if e['size'] < 2000:
            m = re.search(r'url=([^"\'>]+)', s)
            if m and not m.group(1).startswith('URL.'):
                redirect = m.group(1)
        images_data = s.count('data:image')
        anime = bool(re.search(r'requestAnimationFrame|setInterval|setTimeout', s)) and images_data > 0
        apercus.append({
            'id': Path(p).stem, 'fichier': p, 'titre': titre_de(s, Path(p).stem),
            'taille': e['size'], 'categorie': categorie(Path(p).stem),
            'mots': mots_de(Path(p).stem + ' ' + titre_de(s, '')),
            'images': images_data, 'anime': anime,
            'canvas': '<canvas' in s, 'redirect': redirect,
        })

    # --- packs ZIP ---------------------------------------------------------
    packs = []
    for i, p in enumerate(zips):
        e = par_chemin[p]
        data = blob(p, e)
        try:
            a = analyse_zip(e, data, p)
        except Exception as ex:
            print(f'  ! ZIP illisible {p}: {ex}', file=sys.stderr)
            a = {'nb_fichiers': 0, 'poids_decompresse': 0, 'extensions': {}, 'html': [],
                 'animations': [], 'grounds': [], 'images': [], 'scenes': [],
                 'cadence_ms': 100, 'cadence_source': 'indisponible', 'nb_cadences': 0, 'mod': False}
        dossier = Path(p).parent.name if '/' in p else ''
        base = Path(p).stem
        titre = joli(base if dossier in ('renders', 'exports', 'source') else dossier + ' — ' + base)
        packs.append({
            'id': f'z{i:03d}', 'fichier': p, 'titre': titre, 'taille': e['size'],
            'categorie': categorie(base + ' ' + dossier),
            'mots': mots_de(base + ' ' + dossier + ' ' + p),
            'html': a['html'], 'animations': a['animations'], 'grounds': a['grounds'],
            'images': a['images'], 'scenes': a['scenes'],
            'nb_fichiers': a['nb_fichiers'], 'poids_decompresse': a['poids_decompresse'],
            'extensions': a['extensions'], 'cadence_ms': a['cadence_ms'],
            'cadence_source': a['cadence_source'], 'nb_cadences': a['nb_cadences'],
            'mod': a['mod'],
        })
        if (i + 1) % 25 == 0:
            print(f'  packs analysés {i + 1}/{len(zips)}', flush=True)

    # --- associations ------------------------------------------------------
    from difflib import SequenceMatcher

    def cles_pack(p: dict) -> list[str]:
        return [c for c in (normalise(Path(p['fichier']).stem),
                            normalise(Path(p['fichier']).parent.name)) if len(c) >= 4]

    def score_lien(m: str, c: str) -> float:
        if not m or not c:
            return 0
        if m == c:
            return 1000
        if len(m) >= 6 and len(c) >= 6 and (c in m or m in c):
            return 800 + min(len(m), len(c))
        return SequenceMatcher(None, m, c).ratio() * 100

    def meilleur_lien(m: str, cles: list[str]) -> float:
        return max((score_lien(m, c) for c in cles), default=0)

    # Correspondances explicites : les mods Zone Zéro / Térapagos portent un
    # préfixe (ATP1, RAZ3, EAF1…) qui ne ressemble pas au nom de leur aperçu.
    liens_manuels = {
        'arene_terapagos_v1/ATP1': 'apercu_arene_terapagos',
        'colonnes_lances_v1/CLR1': 'apercu_colonnes_lances',
        'ruines_zarbi_v1/RZD1': 'apercu_ruines_zarbi',
        'zone_zero_v1/EAZ1': 'apercu_entree_zone_zero',
        'zone_zero_v1/RAZ1': 'apercu_route_zone_zero_1',
        'zone_zero_v1/RAZ2': 'apercu_route_zone_zero_2',
        'zone_zero_v1/RAZ3': 'apercu_route_zone_zero_3',
        'zone_zero_v2/EAF1': 'apercu_entree_zone_zero_fleurie',
        'zone_zero_v2/RAF1': 'apercu_route_zone_zero_fleurie_1',
        'zone_zero_v2/RAF2': 'apercu_route_zone_zero_fleurie_2',
        'zone_zero_v2/RAF3': 'apercu_route_zone_zero_fleurie_3',
    }
    par_id = {a['id']: a for a in apercus}
    for p in packs:
        for fragment, aid in liens_manuels.items():
            if fragment in p['fichier'] and aid in par_id:
                p['apercu_lie'] = aid
                p['lien_manuel'] = True
                if 'pack' not in par_id[aid]:
                    par_id[aid]['pack'] = p['id']
                    par_id[aid]['lien_manuel_pack'] = True
                break

    normes_apercus = [(a, normalise(Path(a['fichier']).stem)) for a in apercus]
    for a, m in normes_apercus:
        if a.get('lien_manuel_pack'):
            continue
        meilleur, score = None, 52
        for p in packs:
            s = meilleur_lien(m, cles_pack(p))
            if s > score:
                meilleur, score = p, s
        if meilleur:
            a['pack'] = meilleur['id']
    for p in packs:
        if p.get('lien_manuel'):
            continue
        cles = cles_pack(p)
        meilleur, score = None, 52
        for a, m in normes_apercus:
            s = meilleur_lien(m, cles)
            if s > score:
                meilleur, score = a, s
        p['apercu_lie'] = meilleur['id'] if meilleur else None

    chantiers = []
    for d in dossiers_source:
        chemin = 'source/' + d
        la, lp = lier(chemin, apercus, packs)
        chantiers.append({'id': d, 'dossier': chemin, 'titre': joli(d),
                          'categorie': categorie(d), 'mots': mots_de(d),
                          'apercu': la, 'pack': lp})

    catalogue = {
        'version': 2,
        'source': {'repo': REPO, 'ref': REF, 'url': f'https://github.com/{REPO}/tree/{REF}'},
        'stats': {
            'apercus': len(apercus), 'packs': len(packs), 'chantiers': len(chantiers),
            'fichiers_restaurer': len(manifeste),
            'volume_mo': round(sum(e[1] for e in manifeste.values()) / 1e6, 1),
            'animations_webp_gif': sum(len(p['animations']) for p in packs),
            'frames_png': sum(sum(len(c['f']) for c in s['calques']) for p in packs for s in p['scenes']),
            'grounds': sum(len(p['grounds']) for p in packs),
            'scenes': sum(len(p['scenes']) for p in packs),
            'html_zip': sum(len(p['html']) for p in packs),
        },
        'apercus': apercus, 'packs': packs, 'chantiers': chantiers,
    }
    return catalogue, manifeste


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument('--arbre', default=None, help='JSON de l’arbre GitHub (sinon téléchargé)')
    ap.add_argument('--ref', default=REF)
    a = ap.parse_args()
    if a.arbre:
        arbre = json.loads(Path(a.arbre).read_text())['tree']
    else:
        print('Téléchargement de l’arbre GitHub…', flush=True)
        arbre = arbre_git(a.ref)
    catalogue, manifeste = construire(arbre)
    HERE.mkdir(parents=True, exist_ok=True)
    (HERE / 'catalogue.json').write_text(json.dumps(catalogue, ensure_ascii=False, separators=(',', ':')), encoding='utf-8')
    (HERE / 'manifeste.json').write_text(json.dumps({
        'repo': REPO, 'ref': REF,
        'fichiers': manifeste}, ensure_ascii=False, separators=(',', ':')), encoding='utf-8')
    print('Catalogue :', json.dumps(catalogue['stats'], ensure_ascii=False, indent=2))
    print('Tailles :', (HERE / 'catalogue.json').stat().st_size // 1024, 'Kio catalogue,',
          (HERE / 'manifeste.json').stat().st_size // 1024, 'Kio manifeste')


if __name__ == '__main__':
    main()
