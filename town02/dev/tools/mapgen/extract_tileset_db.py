#!/usr/bin/env python3
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
# =============================================================================
# extract_tileset_db.py — construit la base de tilesets VALIDES du projet.
#
# PRINCIPE (preuve avant hypothese) :
#   On ne liste que ce qui est DEJA utilise par les zones du depot
#   (Data/Zone/*.json, MapTextureStep GroundTileset/BlockTileset/WaterTileset).
#   Chaque entree porte sa provenance (zones utilisatrices, segments, etages).
#   Quand docs/conception_donjons_segmentes.md arrivera, ses fiches de biome
#   PRIMERONT sur cette inférence ; cette base restera la preuve d'usage.
#
# SORTIES :
#   tools/mapgen/data/tilesets_donjons.json   triplets autotiles -> usages
#   tools/mapgen/data/biomes_zones.json       zone -> segments/elements/musiques
# =============================================================================
import json, glob, re, os, sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))
OUT_TS = os.path.join(HERE, 'data', 'tilesets_donjons.json')
OUT_BIO = os.path.join(HERE, 'data', 'biomes_zones.json')

RX = re.compile(r'"(GroundTileset|BlockTileset|WaterTileset)":\s*"([^"]*)"')
RX_EL = re.compile(r'"GroundElement":\s*"([^"]*)"')
RX_MUS = re.compile(r'"Music":\s*"([^"]+)"')


def seg_type(seg):
    return seg.get('$type', '?').split(',')[0].split('.')[-1]


def main():
    triplets = defaultdict(
        lambda: {'zones': set(), 'elements': set(), 'musiques': set(), 'etages': 0})
    biomes = {}
    for p in sorted(glob.glob(os.path.join(ROOT, 'Data', 'Zone', '*.json'))):
        zone = os.path.splitext(os.path.basename(p))[0]
        if zone in ('backup_master_zone',):
            continue
        try:
            z = json.load(open(p, encoding='utf-8-sig'))['Object']
        except Exception as e:
            print('IGNORE (illisible):', zone, e)
            continue
        segs_out = []
        for i, seg in enumerate(z.get('Segments', [])):
            info = {'type': seg_type(seg), 'plages': [], 'tilesets': set(),
                    'elements': set(), 'musiques': set()}
            floors = seg.get('Floors') or {}
            nodes = floors.get('nodes', []) if isinstance(floors, dict) else \
                [{'Item': it, 'Range': {}} for it in floors]
            for node in nodes:
                rng = node.get('Range', {})
                txt = json.dumps(node, ensure_ascii=False)
                ts = dict(RX.findall(txt))
                els = RX_EL.findall(txt)
                mus = RX_MUS.findall(txt)
                if ts.get('GroundTileset'):
                    key = (ts.get('GroundTileset'), ts.get('BlockTileset', ''),
                           ts.get('WaterTileset', ''))
                    t = triplets[key[0]]
                    t['zones'].add(zone); t['musiques'].update(mus)
                    t['etages'] += int(rng.get('Max', 0)) - int(rng.get('Min', 0))
                    t['elements'].update(els)
                    t['wall'] = key[1]; t['water_wall'] = key[2]
                    info['tilesets'].add(key[0])
                info['elements'].update(els); info['musiques'].update(mus)
                if seg_type(seg) == 'RangeDictSegment':
                    info['plages'].append([rng.get('Min'), rng.get('Max')])
            info['tilesets'] = sorted(info['tilesets'])
            info['elements'] = sorted(info['elements'])
            info['musiques'] = sorted(info['musiques'])
            segs_out.append(info)
        biomes[zone] = {
            'zones_fr': z.get('Name', {}).get('DefaultText', ''),
            'segments': segs_out,
            'groundmaps': z.get('GroundMaps', []),
        }
    ts_out = {}
    for name, t in sorted(triplets.items()):
        ts_out[name] = {
            'wall': t['wall'], 'water_wall': t['water_wall'],
            'elements': sorted(t['elements']),
            'zones': sorted(t['zones']),
            'musiques': sorted(t['musiques']),
            'etages_cumules': t['etages'],
        }
    prov = {
        '_provenance': (
            'EXTRAIT du depot (MapTextureStep reels de Data/Zone/*.json). '
            'docs/conception_donjons_segmentes.md est ABSENT du depot : '
            'quand il sera ajoute, ses fiches de biome priment et cet '
            'extracteur devra etre aligne sur elles.'),
        '_regenerer': 'python3 tools/mapgen/extract_tileset_db.py',
    }
    os.makedirs(os.path.join(HERE, 'data'), exist_ok=True)
    json.dump({**prov, 'tilesets': ts_out}, open(OUT_TS, 'w', encoding='utf-8'),
              ensure_ascii=False, indent=1)
    json.dump({**prov, 'zones': biomes}, open(OUT_BIO, 'w', encoding='utf-8'),
              ensure_ascii=False, indent=1)
    print(f'{len(ts_out)} triplets de tilesets valides -> {OUT_TS}')
    print(f'{len(biomes)} zones decrites          -> {OUT_BIO}')


if __name__ == '__main__':
    main()
