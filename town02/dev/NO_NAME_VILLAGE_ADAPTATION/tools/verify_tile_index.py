#!/usr/bin/env python3
"""Garde anti-damier mauve : toute tuile référencée doit être résolvable.

POURQUOI index.idx EST NÉCESSAIRE — chaîne prouvée dans le moteur
-----------------------------------------------------------------
GraphicsManager.GetTile() (Content/GraphicsManager.cs l.1152) fait :

    long tilePos = TileIndex.GetPosition(tileTex.Sheet, tileTex.TexLoc);
    ...
    if (tilePos > 0) { ...charge le PNG à cet offset dans <Sheet>.tile... }
    BaseSheet newSheet = BaseSheet.LoadError();   // <- sinon

et TileGuide.GetPosition (Content/Indices/TileIndex.cs l.76) :

    if (Nodes.TryGetValue(sheet, out node)) return node.GetPosition(tex);
    else return 0;                                 // planche inconnue

    // et TileIndexNode.GetPosition (l.46) :
    if (Positions.TryGetValue(tex, out val)) return val;
    else return 0;                                 // TexLoc inconnu

Donc DEUX causes distinctes donnent tilePos == 0, et 0 n'est jamais "> 0" :
  (A) la planche n'est pas déclarée dans index.idx ;
  (B) la planche est déclarée mais le couple (X,Y) demandé n'y figure pas.

Dans les deux cas le moteur rend BaseSheet.LoadError() = la texture de
substitution : le DAMIER MAUVE/NOIR. C'est exactement l'incident
docs/DIAGNOSTIC_DAMIER_DUEL_METANO_2026-08-05.md (commit 9cbdf80).

OÙ index.idx DOIT ÊTRE INSTALLÉ
-----------------------------------------------------------------
Content/Tile/index.idx  (GraphicsManager l.552 : LoadTileIndices(CONTENT_PATH
+ "Tile/"), l.1130 : PathMod.FallforthPaths(tileDir + "index.idx")).
Le fichier <Sheet>.tile doit exister au même endroit : Content/Tile/<Sheet>.tile.

CE QUE CE SCRIPT VÉRIFIE
-----------------------------------------------------------------
Pour chaque .rsmap (et chaque .rsground) demandé :
  1. chaque Sheet référencé est déclaré dans index.idx      -> sinon damier (A)
  2. chaque couple (Sheet, TexLoc) référencé y a une entrée -> sinon damier (B)
  3. l'offset annoncé est > 0 et tombe dans le fichier .tile
  4. le fichier Content/Tile/<Sheet>.tile existe
  5. à cet offset, on lit bien un PNG (signature vérifiée)
  6. la tile_size déclarée correspond à celle attendue

Sortie : code 0 si tout est résolvable, 1 sinon (liste des tuiles fantômes).
"""
from __future__ import annotations
import argparse, glob, io, json, os, struct, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PNG_SIG = b'\x89PNG\r\n\x1a\n'


def load_index(path: Path):
    """index.idx -> {sheet: {'tile_size': int, 'pos': {(x,y): offset}}}"""
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
    if off != len(d):
        raise ValueError('index.idx malforme: %d octets lus sur %d' % (off, len(d)))
    return out


def refs_from_map(path: Path):
    """Tous les (Sheet, X, Y) référencés par une .rsmap ou un .rsground."""
    o = json.load(io.open(path, encoding='utf-8-sig'))['Object']
    refs = set()

    def walk_tile(t):
        for lay in (t.get('Layers') or []):
            for f in (lay.get('Frames') or []):
                refs.add((f['Sheet'], f['TexLoc']['X'], f['TexLoc']['Y']))

    for L in (o.get('Layers') or []):
        for col in L['Tiles']:
            for t in col:
                if t:
                    walk_tile(t)
    for col in (o.get('Tiles') or []):
        for t in col:
            if not t:
                continue
            tex = (t.get('Data') or {}).get('TileTex')
            if tex:
                walk_tile(tex)
    return refs


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('maps', nargs='*',
                    help='.rsmap/.rsground à vérifier (défaut : toutes les maps de duel NNV)')
    ap.add_argument('--index', default=str(ROOT / 'Content/Tile/index.idx'))
    ap.add_argument('--tiledir', default=str(ROOT / 'Content/Tile'))
    ns = ap.parse_args()

    idx_path = Path(ns.index)
    if not idx_path.exists():
        print('ECHEC: index.idx introuvable:', idx_path)
        return 1
    idx = load_index(idx_path)
    print('index.idx: %d planches declarees' % len(idx))

    targets = ns.maps or sorted(glob.glob(str(ROOT / 'Data/Map/nnv_duel_*.rsmap')))
    if not targets:
        print('aucune carte a verifier (aucune map de duel installee)')
        return 0

    problems = []
    checked = 0
    for m in targets:
        refs = refs_from_map(Path(m))
        sheets = sorted({s for s, _, _ in refs})
        for sheet, x, y in sorted(refs):
            checked += 1
            node = idx.get(sheet)
            if node is None:
                problems.append('%s: planche "%s" ABSENTE de index.idx -> DAMIER (cause A)'
                                % (os.path.basename(m), sheet))
                continue
            off = node['pos'].get((x, y))
            if off is None:
                problems.append('%s: %s TexLoc (%d,%d) absent de index.idx -> DAMIER (cause B)'
                                % (os.path.basename(m), sheet, x, y))
                continue
            if off <= 0:
                problems.append('%s: %s (%d,%d) offset %d <= 0 -> DAMIER'
                                % (os.path.basename(m), sheet, x, y, off))
                continue
            tp = Path(ns.tiledir) / ('%s.tile' % sheet)
            if not tp.exists():
                problems.append('%s: fichier %s.tile absent -> DAMIER'
                                % (os.path.basename(m), sheet))
                continue
            size = tp.stat().st_size
            if off + 8 > size:
                problems.append('%s: %s (%d,%d) offset %d hors du fichier (%d o)'
                                % (os.path.basename(m), sheet, x, y, off, size))
                continue
            with open(tp, 'rb') as fh:
                fh.seek(off)
                ln = struct.unpack('<q', fh.read(8))[0]
                if ln <= 0 or off + 8 + ln > size:
                    problems.append('%s: %s (%d,%d) longueur PNG invalide (%d)'
                                    % (os.path.basename(m), sheet, x, y, ln))
                    continue
                sig = fh.read(8)
                if sig != PNG_SIG:
                    problems.append('%s: %s (%d,%d) ne pointe pas sur un PNG'
                                    % (os.path.basename(m), sheet, x, y))
        print('%-42s %4d references, %2d planches'
              % (os.path.basename(m), len(refs), len(sheets)))

    print('\ntuiles verifiees: %d' % checked)
    if problems:
        print('DAMIER GARANTI EN JEU: %d probleme(s)' % len(problems))
        for p in problems[:30]:
            print('  -', p)
        return 1
    print('AUCUN DAMIER: toutes les tuiles sont resolvables')
    return 0


if __name__ == '__main__':
    sys.exit(main())
