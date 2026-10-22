#!/usr/bin/env python3
"""Corrige les références musicales cassées (fichiers .ogg inexistants) vers
les pistes existantes équivalentes. Usage: python3 tools/fix_musiques.py"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json, glob, os

MAP = {
    'Boss Battle.ogg': 'Boss Battle!.ogg',
    'Boss Battle 2.ogg': 'Boss Battle!.ogg',
    'Rayquazas Domain.ogg': 'Sky Tower.ogg',
    'Desert Region.ogg': 'Forsaken Desert.ogg',
    'Threat.ogg': 'Rising Fear.ogg',
}

def fix_file(path, mutator):
    doc = json.load(open(path, encoding='utf-8-sig'))
    if mutator(doc):
        with open(path, 'w', encoding='utf-8-sig') as f:
            json.dump(doc, f, ensure_ascii=False, indent=2)
        return True
    return False

n = 0
for f in glob.glob('Data/Map/*.rsmap'):
    if fix_file(f, lambda d: (lambda o: o.get('Music') in MAP and (o.__setitem__('Music', MAP[o['Music']]) is None) if isinstance(o, dict) else False)(d['Object'])):
        n += 1; print('rsmap:', os.path.basename(f))
for f in glob.glob('Data/Ground/*.rsground'):
    if fix_file(f, lambda d: (lambda o: o.get('Music') in MAP and (o.__setitem__('Music', MAP[o['Music']]) is None) if isinstance(o, dict) else False)(d['Object'])):
        n += 1; print('rsground:', os.path.basename(f))
for f in glob.glob('Data/Zone/*.json'):
    state = {'changed': False}
    def walk(v):
        if isinstance(v, dict):
            if v.get('Music') in MAP:
                v['Music'] = MAP[v['Music']]
                state['changed'] = True
            for vv in v.values():
                walk(vv)
        elif isinstance(v, list):
            for vv in v:
                walk(vv)
    doc = json.load(open(f, encoding='utf-8-sig'))
    walk(doc)
    if state['changed']:
        with open(f, 'w', encoding='utf-8-sig') as fh:
            json.dump(doc, fh, ensure_ascii=False, indent=2)
        n += 1; print('zone:', os.path.basename(f))
print('TOTAL fichiers corrigés:', n)
