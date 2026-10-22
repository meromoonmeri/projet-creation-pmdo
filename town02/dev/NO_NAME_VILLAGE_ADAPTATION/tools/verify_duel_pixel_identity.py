#!/usr/bin/env python3
"""Garde permanente du pipeline de duel.

    Ground -> rendu de reference -> .rsmap de duel -> rendu de duel
           -> comparaison pixel-perfect -> validation

Cette garde ne fait PAS confiance aux fichiers *_proof.json produits lors de
la generation : ils pourraient etre perimes ou falsifies. Elle REFAIT le
travail depuis les sources :

  1. relit le rendu de reference du Ground (source_normalized_tick0.png) ;
  2. relit la .rsmap de duel et sa planche .tile ;
  3. RECONSTRUIT l'image que le moteur affichera, en suivant exactement la
     chaine moteur : pour chaque tuile, (Sheet, TexLoc) -> offset dans
     index.idx -> PNG a cet offset dans <Sheet>.tile ;
  4. redecoupe la fenetre correspondante dans le rendu du Ground ;
  5. compare pixel par pixel.

Si l'identite est rompue, le script sort en code 1 : la promotion doit etre
refusee. C'est le point de controle a brancher avant toute injection.

Usage :
  verify_duel_pixel_identity.py --candidates <dir>   (maps non installees)
  verify_duel_pixel_identity.py                      (maps installees)
"""
from __future__ import annotations
import argparse, glob, hashlib, io, json, os, struct, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
sys.path.insert(0, str(ROOT / '.runtime-cache/pyenv'))
from PIL import Image, ImageChops  # noqa: E402

TILE = 24
GROUND_PX = 4992
BANNED_COLOURS = {
    (255, 0, 255), (255, 0, 220), (248, 0, 248),   # magenta du damier
}


def read_index(path: Path):
    d = path.read_bytes()
    off = 0
    n = struct.unpack_from('<I', d, off)[0]
    off += 4
    out = {}
    for _ in range(n):
        ln = d[off]
        off += 1
        name = d[off:off + ln].decode('utf-8')
        off += ln
        tsize, count = struct.unpack_from('<II', d, off)
        off += 8
        pos = {}
        for _ in range(count):
            key, o = struct.unpack_from('<QQ', d, off)
            off += 16
            pos[(key & 0xffffffff, (key >> 32) & 0xffffffff)] = o
        out[name] = {'tile_size': tsize, 'pos': pos}
    return out


def read_sheet_table(path: Path):
    """Lit une planche .tile autonome (candidate, pas encore indexee)."""
    d = path.read_bytes()
    tsize, count = struct.unpack_from('<II', d, 0)
    off = 8
    pos = {}
    for _ in range(count):
        key, o = struct.unpack_from('<QQ', d, off)
        off += 16
        pos[(key & 0xffffffff, (key >> 32) & 0xffffffff)] = o
    return {'tile_size': tsize, 'pos': pos}


def load_png_at(path: Path, offset: int):
    with open(path, 'rb') as fh:
        fh.seek(offset)
        ln = struct.unpack('<q', fh.read(8))[0]
        return Image.open(io.BytesIO(fh.read(ln))).convert('RGBA')


def rebuild_from_engine_chain(map_path: Path, tiledir: Path, index):
    """Reconstruit l'image telle que le moteur la composera."""
    o = json.load(io.open(map_path, encoding='utf-8-sig'))['Object']
    layer = o['Layers'][0]
    W, H = len(layer['Tiles']), len(layer['Tiles'][0])
    img = Image.new('RGBA', (W * TILE, H * TILE), (0, 0, 0, 0))
    missing = []
    for tx in range(W):
        for ty in range(H):
            frames = layer['Tiles'][tx][ty]['Layers'][0]['Frames']
            f = frames[0]
            sheet, x, y = f['Sheet'], f['TexLoc']['X'], f['TexLoc']['Y']
            node = index.get(sheet)
            if node is None:
                missing.append('planche %s absente' % sheet)
                continue
            off = node['pos'].get((x, y))
            if not off or off <= 0:
                missing.append('%s (%d,%d) non resolvable' % (sheet, x, y))
                continue
            tp = tiledir / ('%s.tile' % sheet)
            if not tp.exists():
                missing.append('%s.tile absent' % sheet)
                continue
            img.paste(load_png_at(tp, off), (tx * TILE, ty * TILE))
    return img, missing, (W, H)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--candidates', default='',
                    help='dossier de maps candidates (avec leurs .tile)')
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--index', default=str(ROOT / 'Content/Tile/index.idx'))
    ns = ap.parse_args()

    if ns.candidates:
        maps = sorted(glob.glob(os.path.join(ns.candidates, 'nnv_duel_*.rsmap')))
        tiledir = Path(ns.candidates)
        index = None            # construit par planche, en local
    else:
        maps = sorted(glob.glob(str(ROOT / 'Data/Map/nnv_duel_*.rsmap')))
        tiledir = ROOT / 'Content/Tile'
        index = read_index(Path(ns.index))

    if not maps:
        print('aucune map de duel a verifier')
        return 0

    failures = []
    for mp in maps:
        mp = Path(mp)
        stem = mp.stem                       # nnv_duel_<room>_<season>
        parts = stem.split('_')
        room, season = parts[2], parts[3]

        if index is None:
            local = {}
            for tf in glob.glob(str(tiledir / '*.tile')):
                local[Path(tf).stem] = read_sheet_table(Path(tf))
            idx = local
        else:
            idx = index

        rebuilt, missing, (W, H) = rebuild_from_engine_chain(mp, tiledir, idx)
        if missing:
            failures.append('%s: %d tuile(s) non resolvable(s) -> DAMIER : %s'
                            % (stem, len(missing), missing[0]))
            continue

        # fenetre de reference dans le rendu du Ground
        proof_p = mp.with_name(stem + '_proof.json')
        if not proof_p.exists():
            # maps installees : la preuve vit dans reports/, pas dans Data/Map
            proof_p = NNV / 'reports/fauna-ecology/installed-proofs' / (stem + '_proof.json')
        if not proof_p.exists():
            failures.append('%s: origine de la fenetre inconnue (proof absent)' % stem)
            continue
        origin = json.load(open(proof_p))['origin_px']

        rp = Path(ns.reconv) / room / 'validation/source_normalized_tick0.png'
        if not rp.exists():
            failures.append('%s: rendu de reference absent (%s)' % (stem, rp))
            continue
        ground = Image.open(rp).convert('RGBA')
        if ground.size != (GROUND_PX, GROUND_PX):
            failures.append('%s: rendu de reference %s inattendu' % (stem, ground.size))
            continue
        x0, y0 = origin
        window = ground.crop((x0, y0, x0 + W * TILE, y0 + H * TILE))

        diff = ImageChops.difference(rebuilt.convert('RGB'), window.convert('RGB'))
        bbox = diff.getbbox()
        h1 = hashlib.sha256(rebuilt.convert('RGBA').tobytes()).hexdigest()
        h2 = hashlib.sha256(window.convert('RGBA').tobytes()).hexdigest()

        # couleurs interdites : damier, transparence, bandes noires
        cols = {c for _, c in rebuilt.convert('RGB').getcolors(maxcolors=1 << 22)}
        banned = cols & BANNED_COLOURS
        alpha = rebuilt.getchannel('A')
        transparent = alpha.getextrema()[0] < 255

        ok = bbox is None and h1 == h2 and not banned and not transparent
        status = 'OK' if ok else 'ECHEC'
        print('%-34s %2dx%-2d tuiles  sha=%s  %s'
              % (stem, W, H, h1[:12], status))
        if bbox is not None:
            failures.append('%s: rendu different du Ground, bbox=%s' % (stem, bbox))
        if h1 != h2:
            failures.append('%s: sha256 divergents' % stem)
        if banned:
            failures.append('%s: couleur de damier detectee %s' % (stem, banned))
        if transparent:
            failures.append('%s: pixels transparents dans le rendu' % stem)

    print('\nmaps verifiees: %d' % len(maps))
    if failures:
        print('PROMOTION REFUSEE: %d echec(s)' % len(failures))
        for f in failures[:20]:
            print('  -', f)
        return 1
    print('PIXEL-PERFECT CONFIRME: la .rsmap rend exactement le Ground')
    return 0


if __name__ == '__main__':
    sys.exit(main())
