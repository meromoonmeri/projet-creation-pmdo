#!/usr/bin/env python3
"""Récupère toutes les maps (MAP_BG) et les fonds de PMD Explorers of Sky, pour s'en servir comme références.

Deux sources :

  rom      Données du jeu depuis le dépôt de décompilation pret/pmd-sky (commit épinglé) : tous les MAP_BG
           (BMA + BPC + BPL + BPA) rendus par skytemple-files, avec toutes les frames d'animation (tuiles BPA et
           animation de palette). La table du jeu `bg_list.dat` (US) donne les associations exactes. Les BMA hors
           table sont rendus avec les fichiers de même nom. ATTENTION : le préfixe dNN n'est PAS le DUNGEON_ID de
           include/enums.h (vérifié : D04 = Waterfall Cave, D54 = Southern Jungle). Les noms viennent seulement des
           captures nommées du dépôt, comparées au pixel près (commande `identifie`, lancée aussi après `rom`).

  galerie  Galerie projectpokemon.org, catégorie 12 (Explorers of Sky) : liste les albums (fonds de maps, GIF
           animés, tilesets de donjon…), puis télécharge les images originales avec reprise. Il faut que
           projectpokemon.org soit joignable en HTTPS (le bac à sable Arena le coupe ; à lancer sur son poste).

Sorties (non versionnées, régénérables) : .cache/maps_pmdsky/
  rom/png/<CODE>.png             frame 0 en taille réelle
  rom/anim/<CODE>.webp           toutes les frames (ou --max-frames), WebP animé sans perte
  rom/index.json                 code, fichiers source, taille, nb de frames, BPA, collision, lettre, identification
  galerie/<album>/<fichier>      originaux de la galerie, galerie/index.json
Sorties versionnées (légères) : source/outil_maps_pmdsky/index_rom.json et planches/planche_<lettre>.jpg

Usage :
  .venv/bin/python source/outil_maps_pmdsky/recuperer_maps.py rom [--max-frames 64] [--only D06,V24P04A]
  .venv/bin/python source/outil_maps_pmdsky/recuperer_maps.py galerie [--albums 908,879] [--dry-run]
  .venv/bin/python source/outil_maps_pmdsky/recuperer_maps.py identifie         (captures nommées -> codes)
  .venv/bin/python source/outil_maps_pmdsky/recuperer_maps.py cherche jungle     (recherche dans l'index)
"""
from pathlib import Path
import argparse, contextlib, html, io, json, re, subprocess, sys, time, urllib.parse, urllib.request

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
CACHE = R / '.cache'
OUT = CACHE / 'maps_pmdsky'
PMD_SKY = 'https://github.com/pret/pmd-sky.git'
PMD_SKY_COMMIT = 'c8073235b39746a7ee74e6cea16c730bd91a1e67'
CLONE = CACHE / 'pmd-sky'
GALLERY = 'https://projectpokemon.org/home/gallery/category/12-pok%C3%A9mon-mystery-dungeon-explorers-of-sky/'
UA = 'Mozilla/5.0 (X11; Linux x86_64) guilde-treehouse-pmd/outil_maps_pmdsky'
# Première lettre du code MAP_BG. Libellés SUPPOSÉS d'après les planches (non documentés par le jeu).
CATEGORIES = {'D': 'donjons : entrées, salles de fin, arènes (supposé)', 'G': 'guilde (supposé)', 'H': 'intérieurs (supposé)',
              'P': 'lieux (supposé)', 'S': 'spéciaux, menus (supposé)', 'T': 'villes (supposé)', 'V': 'scènes et fonds (supposé)',
              'W': 'à identifier'}
CAPTURE_KEYS = ('_TD', '_TDS', '_S.png', '_Sky', 'pmdsky')                   # captures nommées à la racine du dépôt


# ---------------------------------------------------------------- source ROM
def git(*a, cwd=None):
    return subprocess.run(['git', *a], cwd=cwd, check=True, capture_output=True, text=True).stdout


def ensure_clone():
    """Clone partiel de pret/pmd-sky (MAP_BG et bg_list.dat US seulement), au commit épinglé."""
    paths = ['files/MAP_BG', 'files/language-specific/US/MAP_BG/bg_list.dat']
    if not (CLONE / '.git').exists():
        CACHE.mkdir(exist_ok=True)
        git('clone', '-q', '--filter=blob:none', '--no-checkout', PMD_SKY, str(CLONE))
    git('sparse-checkout', 'set', '--no-cone', *paths, cwd=CLONE)
    if git('rev-parse', 'HEAD', cwd=CLONE).strip() != PMD_SKY_COMMIT:
        git('fetch', '-q', 'origin', PMD_SKY_COMMIT, cwd=CLONE)
        git('checkout', '-q', PMD_SKY_COMMIT, cwd=CLONE)
    for p in paths:
        assert (CLONE / p).exists(), p
    return CLONE / 'files/MAP_BG'


def bg_entries(mapbg):
    from skytemple_files.common.types.file_types import FileType
    lst = FileType.BG_LIST_DAT.deserialize((CLONE / 'files/language-specific/US/MAP_BG/bg_list.dat').read_bytes())
    seen, out = set(), []
    for i, e in enumerate(lst.level):
        code = e.bma_name.upper()
        key = (code, e.bpc_name.upper(), e.bpl_name.upper(), tuple(b.upper() if b else None for b in e.bpa_names))
        if key in seen:
            continue
        seen.add(key)
        name = code if code not in {o['code'] for o in out} else f'{code}__{e.bpc_name.upper()}'
        out.append({'code': name, 'bg_list_index': i, 'bma': e.bma_name, 'bpc': e.bpc_name, 'bpl': e.bpl_name,
                    'bpa': [b for b in e.bpa_names]})
    listed = {o['bma'].lower() for o in out}
    for p in sorted(mapbg.glob('*.bma')):                                       # BMA hors table
        s = p.stem
        if s in listed or not (mapbg / f'{s}.bpc').exists() or not (mapbg / f'{s}.bpl').exists():
            continue
        bpa = [f'{s}{k}' if (mapbg / f'{s}{k}.bpa').exists() else None for k in range(1, 9)]
        out.append({'code': s.upper(), 'bg_list_index': None, 'bma': s, 'bpc': s, 'bpl': s, 'bpa': bpa})
    return out


def render(mapbg, ent, max_frames):
    from skytemple_files.common.types.file_types import FileType
    ld = lambda n, ext: (mapbg / f'{n.lower()}.{ext}').read_bytes()
    bma = FileType.BMA.deserialize(ld(ent['bma'], 'bma'))
    bpc = FileType.BPC.deserialize(ld(ent['bpc'], 'bpc'))
    bpl = FileType.BPL.deserialize(ld(ent['bpl'], 'bpl'))
    bpas = [FileType.BPA.deserialize(ld(b, 'bpa')) if b and (mapbg / f'{b.lower()}.bpa').exists() else None for b in ent['bpa']]
    with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
        frames = bma.to_pil(bpc, bpl, bpas, include_collision=False, include_unknown_data_block=False)
    n_all = len(frames)
    info = {'taille_px': list(frames[0].size), 'frames': n_all, 'frames_gardees': min(n_all, max_frames),
            'bpa_charges': sum(b is not None for b in bpas), 'couches': bma.number_of_layers,
            'collision': bool(bma.collision), 'animation_palette': bool(getattr(bpl, 'has_palette_animation', False))}
    return frames[:max_frames], info


def cmd_rom(a):
    from PIL import Image
    mapbg = ensure_clone()
    out = OUT / 'rom'
    for d in ('png', 'anim'):
        (out / d).mkdir(parents=True, exist_ok=True)
    ents = bg_entries(mapbg)
    if a.only:
        want = {s.strip().upper() for s in a.only.split(',')}
        ents = [e for e in ents if any(e['code'].startswith(w) for w in want)]
    idx_p = out / 'index.json'
    index = {e['code']: e for e in json.loads(idx_p.read_text())['maps']} if idx_p.exists() and not a.force else {}
    t0 = time.time(); n_err = 0
    for k, e in enumerate(ents, 1):
        code = e['code']
        if code in index and (out / 'png' / f'{code}.png').exists() and not a.force:
            continue
        try:
            frames, info = render(mapbg, e, a.max_frames)
            frames[0].convert('RGBA').save(out / 'png' / f'{code}.png', optimize=True)
            if len(frames) > 1:
                fr = [f.convert('RGBA') for f in frames]
                fr[0].save(out / 'anim' / f'{code}.webp', save_all=True, append_images=fr[1:], duration=167, loop=0, lossless=True)
            e2 = dict(e, **info, categorie=CATEGORIES.get(code[0], '?'), erreur=None)
        except FileNotFoundError as ex:                                          # entrée de bg_list sans fichier dans le dépôt
            n_err += 1; e2 = dict(e, erreur=f'absent du depot pret/pmd-sky : {Path(ex.filename).name}')
        except Exception as ex:                                                  # une carte cassée n'arrête pas le lot
            n_err += 1; e2 = dict(e, erreur=f'{type(ex).__name__}: {ex}'[:300])
        index[code] = e2
        if k % 25 == 0 or k == len(ents):
            print(f'{k}/{len(ents)}  {time.time() - t0:.0f} s  erreurs {n_err}', flush=True)
            idx_p.write_text(json.dumps(meta(index), ensure_ascii=False, indent=1))
    identifie_index(index, out)
    idx_p.write_text(json.dumps(meta(index), ensure_ascii=False, indent=1))
    light = {'source': meta(index)['source'], 'maps': [{k: v for k, v in m.items() if k != 'bg_list_index'} for m in meta(index)['maps']]}
    (HERE / 'index_rom.json').write_text(json.dumps(light, ensure_ascii=False, indent=1) + '\n')
    planches(index, out)
    ok = sum(1 for m in index.values() if not m.get('erreur'))
    print(f'{ok} maps rendues, {len(index) - ok} en erreur -> {out}')


def meta(index):
    return {'source': {'depot': PMD_SKY, 'commit': PMD_SKY_COMMIT, 'table': 'files/language-specific/US/MAP_BG/bg_list.dat',
                       'rendu': 'skytemple-files Bma.to_pil(bpc, bpl, bpas), sans collision',
                       'duree_frame_webp_ms': 167, 'note': 'duree nominale (10 ticks a 60 i/s) ; la vraie cadence est dans les BPA/BPL ; WebP fusionne les frames identiques successives'},
            'maps': sorted(index.values(), key=lambda m: m['code'])}


def planches(index, out, thumb=160):
    """Planches de vignettes par catégorie (versionnées, légères), code écrit sous chaque vignette."""
    from PIL import Image, ImageDraw
    (HERE / 'planches').mkdir(exist_ok=True)
    by = {}
    for m in index.values():
        if not m.get('erreur'):
            by.setdefault(m['code'][0], []).append(m)
    for cat, ms in sorted(by.items()):
        ms.sort(key=lambda m: m['code']); cols = 10; rows = (len(ms) + cols - 1) // cols
        sheet = Image.new('RGB', (cols * thumb, rows * (thumb + 14)), (18, 18, 24)); dr = ImageDraw.Draw(sheet)
        for i, m in enumerate(ms):
            im = Image.open(out / 'png' / f"{m['code']}.png").convert('RGB'); im.thumbnail((thumb, thumb))
            x, y = (i % cols) * thumb, (i // cols) * (thumb + 14)
            sheet.paste(im, (x + (thumb - im.width) // 2, y + (thumb - im.height) // 2))
            dr.text((x + 3, y + thumb), m['code'] + (f" ({m['frames']}f)" if m['frames'] > 1 else ''), fill=(230, 230, 230))
        sheet.save(HERE / 'planches' / f'planche_{cat}.jpg', quality=88)


def identifie_index(index, out):
    """Compare chaque capture nommée de la racine aux rendus (vignettes 64 x 64, BOX). Écart 0 : vérifié ; même taille et
    écart < 20 : probable (autre frame d'animation ou recadrage)."""
    import numpy as np
    from PIL import Image
    small = lambda p: np.array(Image.open(p).convert('RGB').resize((64, 64), Image.BOX)).astype(float)
    rend = {c: (Image.open(out / 'png' / f'{c}.png').size, small(out / 'png' / f'{c}.png'))
            for c, m in index.items() if not m.get('erreur')}
    for m in index.values():
        m.pop('identification', None); m.pop('donjon', None); m['categorie'] = CATEGORIES.get(m['code'][0], '?')
    found = []
    for cap in sorted(R.glob('*.png')):
        if not any(k in cap.name for k in CAPTURE_KEYS):
            continue
        with Image.open(cap) as im:
            size = im.size
        a = small(cap)
        d, code = min((float(np.abs(v[1] - a).mean()), c) for c, v in rend.items())
        same = rend[code][0] == size
        statut = 'verifie' if d < 0.5 else 'probable' if d < 20 and same else None
        if statut:
            index[code].setdefault('identification', []).append({'capture': cap.name, 'ecart_moyen': round(d, 2), 'statut': statut})
            found.append((cap.name, code, statut, round(d, 2)))
    for f in found:
        print('  %-38s -> %-9s %s (%s)' % f)
    return found


def cmd_identifie(a):
    out = OUT / 'rom'; idx_p = out / 'index.json'
    index = {m['code']: m for m in json.loads(idx_p.read_text())['maps']}
    identifie_index(index, out)
    idx_p.write_text(json.dumps(meta(index), ensure_ascii=False, indent=1))
    light = {'source': meta(index)['source'], 'maps': [{k: v for k, v in m.items() if k != 'bg_list_index'} for m in meta(index)['maps']]}
    (HERE / 'index_rom.json').write_text(json.dumps(light, ensure_ascii=False, indent=1) + '\n')


def cmd_cherche(a):
    idx = json.loads((HERE / 'index_rom.json').read_text())['maps']
    q = a.terme.lower()
    for m in idx:
        blob = ' '.join(str(v) for v in m.values()).lower()
        if q in blob:
            ident = ', '.join(i['capture'] for i in m.get('identification', []))
            print(f"{m['code']:<18} {m.get('taille_px')}  {m.get('frames')} f  {ident}  {m.get('categorie', '')}")


# ---------------------------------------------------------------- source galerie projectpokemon
def get(url, binary=False, tries=3):
    for k in range(tries):
        try:
            req = urllib.request.Request(url, headers={'User-Agent': UA})
            with urllib.request.urlopen(req, timeout=60) as r:
                data = r.read()
            return data if binary else data.decode('utf-8', 'replace')
        except Exception as ex:
            if k == tries - 1:
                raise RuntimeError(f'{url} : {ex}') from ex
            time.sleep(2 * (k + 1))


def pages(first):
    """Suit la pagination IPS (/page/N/) tant que la page apporte des liens nouveaux."""
    seen, n = set(), 1
    while True:
        url = first if n == 1 else first.rstrip('/') + f'/page/{n}/'
        txt = get(url); yield url, txt
        links = set(re.findall(r'href="(https://projectpokemon\.org/home/gallery/(?:image|album)/[^"#?]+)', txt))
        if not links - seen or f'/page/{n + 1}/' not in txt:
            return
        seen |= links; n += 1


def cmd_galerie(a):
    out = OUT / 'galerie'; out.mkdir(parents=True, exist_ok=True)
    try:
        _, cat = next(pages(GALLERY))
    except RuntimeError as ex:
        sys.exit(f'Galerie injoignable ({ex}). projectpokemon.org doit être joignable en HTTPS ; lancer cette commande '
                 f'depuis un poste avec accès internet. La source « rom » ne dépend pas de ce site.')
    albums = dict.fromkeys(re.findall(r'href="(https://projectpokemon\.org/home/gallery/album/(\d+)-[^"/]+/)"', cat))
    albums = sorted({(u, int(i)) for u, i in albums}, key=lambda t: t[1])
    if a.albums:
        want = {int(s) for s in a.albums.split(',')}; albums = [t for t in albums if t[1] in want]
    idx_p = out / 'index.json'
    index = json.loads(idx_p.read_text()) if idx_p.exists() else {'source': GALLERY, 'albums': {}}
    for aurl, aid in albums:
        slug = aurl.rstrip('/').split('/')[-1]
        imgs = []
        for _, txt in pages(aurl):
            imgs += re.findall(r'href="(https://projectpokemon\.org/home/gallery/image/\d+-[^"/]+/)"', txt)
        imgs = list(dict.fromkeys(imgs))
        print(f'album {slug} : {len(imgs)} images', flush=True)
        alb = index['albums'].setdefault(slug, {'url': aurl, 'images': {}})
        for iu in imgs:
            if iu in alb['images'] and (out / slug / alb['images'][iu]['fichier']).exists():
                continue
            txt = get(iu)
            # Original : lien de téléchargement complet (uploads/monthly_*/NOM.ext.HASH.ext) sans préfixe small./large.
            cands = re.findall(r'(https://projectpokemon\.org/home/uploads/monthly_[0-9_]+/(?!small\.|large\.|thumb\.)[^"\'\s>]+?\.(?:png|gif|jpg|jpeg))', txt)
            cands += [c.replace('/large.', '/').replace('/small.', '/') for c in
                      re.findall(r'(https://projectpokemon\.org/home/uploads/monthly_[0-9_]+/(?:large|small)\.[^"\'\s>]+?\.(?:png|gif|jpg|jpeg))', txt)]
            if not cands:
                alb['images'][iu] = {'fichier': None, 'erreur': 'aucune URL d image trouvee'}; continue
            src = max(dict.fromkeys(cands), key=len)
            m = re.match(r'(.+?\.(?:png|gif|jpg|jpeg))\.[0-9a-f]{32}\.', src.split('/')[-1])
            fname = html.unescape(urllib.parse.unquote(m.group(1) if m else src.split('/')[-1]))
            alb['images'][iu] = {'fichier': fname, 'url': src}
            if not a.dry_run:
                (out / slug).mkdir(exist_ok=True)
                (out / slug / fname).write_bytes(get(src, binary=True))
            idx_p.write_text(json.dumps(index, ensure_ascii=False, indent=1))
    idx_p.write_text(json.dumps(index, ensure_ascii=False, indent=1))
    print(f"{sum(len(v['images']) for v in index['albums'].values())} images indexées -> {out}")

SPRITERS = 'https://www.spriters-resource.com'


def liens_assets_spriters(txt, base):
    """Pages de feuilles (asset) listées sur une page de jeu Spriters Resource, sans doublon."""
    found = re.findall(r'href="((?:https://www\.spriters-resource\.com)?/[^"#?]+/asset/\d+/?)"', txt)
    out = []
    for h in found:
        u = urllib.parse.urljoin(base, h)
        if u not in out:
            out.append(u)
    return out


def media_spriters(txt, base):
    """Lien direct du fichier image d'une feuille (/media/assets/...), ou None."""
    m = re.search(r'href="([^"]*/media/assets/[^"#?]+\.(?:png|gif|webp|jpe?g))"', txt, re.I)
    return urllib.parse.urljoin(base, m.group(1)) if m else None


def cmd_spriters(a):
    """Feuilles d'une page de jeu Spriters Resource, téléchargées lentement dans .cache (non versionné)."""
    out = OUT / 'spriters'
    out.mkdir(parents=True, exist_ok=True)
    try:
        page = get(a.url)
    except RuntimeError as ex:
        sys.exit(f'Spriters Resource injoignable ({ex}). Lancer depuis un poste ayant accès à {SPRITERS}.')
    assets = liens_assets_spriters(page, a.url)[:a.max]
    slug = a.url.rstrip('/').split('/')[-1] or 'jeu'
    idx_p = out / 'index.json'
    index = json.loads(idx_p.read_text()) if idx_p.exists() else {'source': 'spriters-resource', 'pages': {}}
    print(f'{len(assets)} feuilles trouvées sur {a.url}', flush=True)
    for au in assets:
        entree = index['pages'].setdefault(slug, {'url': a.url, 'feuilles': {}})['feuilles']
        if au in entree and entree[au].get('fichier') and (out / slug / entree[au]['fichier']).exists():
            continue
        try:
            media = media_spriters(get(au), au)
        except RuntimeError as ex:
            entree[au] = {'fichier': None, 'erreur': str(ex)}; continue
        if not media:
            entree[au] = {'fichier': None, 'erreur': 'aucun fichier image trouvé'}; continue
        fname = urllib.parse.unquote(media.split('/')[-1])
        entree[au] = {'fichier': fname, 'url': media, 'licence': 'référence de travail, non redistribuée'}
        print(f'  {fname}', flush=True)
        if not a.dry_run:
            (out / slug).mkdir(exist_ok=True)
            (out / slug / fname).write_bytes(get(media, binary=True))
        idx_p.write_text(json.dumps(index, ensure_ascii=False, indent=1))
        time.sleep(a.delai)
    idx_p.write_text(json.dumps(index, ensure_ascii=False, indent=1))
    print(f'index : {idx_p}')


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sp = ap.add_subparsers(dest='cmd', required=True)
    r = sp.add_parser('rom'); r.add_argument('--max-frames', type=int, default=64); r.add_argument('--only'); r.add_argument('--force', action='store_true')
    g = sp.add_parser('galerie'); g.add_argument('--albums'); g.add_argument('--dry-run', action='store_true')
    c = sp.add_parser('cherche'); c.add_argument('terme')
    sx = sp.add_parser('spriters'); sx.add_argument('url', help='page de jeu Spriters Resource (ex. .../ds_dsi/<jeu>/)')
    sx.add_argument('--max', type=int, default=20); sx.add_argument('--delai', type=float, default=2.0); sx.add_argument('--dry-run', action='store_true')
    sp.add_parser('identifie')
    a = ap.parse_args()
    {'rom': cmd_rom, 'galerie': cmd_galerie, 'cherche': cmd_cherche, 'identifie': cmd_identifie, 'spriters': cmd_spriters}[a.cmd](a)


if __name__ == '__main__':
    main()
