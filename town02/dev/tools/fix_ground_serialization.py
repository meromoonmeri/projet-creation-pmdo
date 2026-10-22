#!/usr/bin/env python3
"""Fix écran noir au chargement des grounds importés (pmd-red + crops ch8-10).

CAUSE : RogueEssence désérialise via Json.NET (TypeNameHandling.Auto).
  1. FATAL  — "Anims": {"$values": []} SANS "$type" -> JsonSerializationException
              (un objet JSON ne peut pas se désérialiser en List<GroundAnim>
              sans indication de type) -> chargement map avorté -> écran noir.
              Forme canonique des fichiers officiels : "Anims": [].
  2. Champ   — Layers[0] : "Front": false n'existe pas dans MapLayer ;
              le champ réel est "Layer": 0 (calque de profondeur).
  3. Robuste — rand.s = [0,0,0,0] : état xorshift dégénéré (suite nulle).
              Remplacé par l'état du ground officiel altere_pond.

GARANTIE : ne touche QUE ces trois clés. Tiles, obstacles, Markers, Spawners,
Colliders, Music, Name — strictement inchangés (vérifié par empreinte avant/après).
"""
import json, io, glob, hashlib, sys

RAND_OK = {"$type": "RogueElements.ReRandom, RogueElements",
           "FirstSeed": 0,
           "s": [16294208416658607535, 7960286522194355700,
                 4876170194715417726, 12554865158188930543]}


def geometry_fingerprint(o):
    """Empreinte de tout ce qui doit rester identique."""
    keep = {
        'Tiles': o['Layers'][0]['Tiles'],
        'obstacles': o['obstacles'],
        'Markers': o['Entities'][0]['Markers'],
        'Spawners': [ (s.get('EntName'), s.get('Collider')) for s in o['Entities'][0]['Spawners'] ],
        'Music': o.get('Music'),
        'AssetName': o.get('AssetName'),
    }
    return hashlib.sha256(json.dumps(keep, sort_keys=True).encode()).hexdigest()


def fix_orphan_values(x):
    """{'$values': [...]} sans '$type' -> liste simple (récursif)."""
    n = 0
    if isinstance(x, dict):
        for k, v in list(x.items()):
            if isinstance(v, dict) and '$values' in v and '$type' not in v:
                x[k] = v['$values']
                n += 1
                n += fix_orphan_values(x[k])
            else:
                n += fix_orphan_values(v)
    elif isinstance(x, list):
        for it in x:
            n += fix_orphan_values(it)
    return n


def main():
    fixed = 0
    for f in sorted(glob.glob('Data/Ground/*.rsground')):
        d = json.load(open(f, encoding='utf-8-sig'))
        o = d['Object']
        before = geometry_fingerprint(o)
        changes = []
        n = fix_orphan_values(o)
        if n:
            changes.append(f'$values orphelin x{n}')
        L = o.get('Layers', [{}])[0]
        if 'Front' in L and 'Layer' not in L:
            del L['Front']
            # reconstruit l'ordre canonique Name/Layer/Visible/Tiles
            o['Layers'][0] = {'Name': L['Name'], 'Layer': 0,
                              'Visible': L['Visible'], 'Tiles': L['Tiles']}
            changes.append('Front->Layer')
        r = o.get('rand', {})
        if r.get('s') == [0, 0, 0, 0]:
            o['rand'] = dict(RAND_OK)
            changes.append('rand.s')
        if not changes:
            continue
        after = geometry_fingerprint(o)
        assert before == after, f'{f}: GEOMETRIE ALTEREE — abandon'
        with io.open(f, 'w', encoding='utf-8-sig') as fh:
            json.dump(d, fh, ensure_ascii=False, indent=1)
        fixed += 1
        print(f'{f.split("/")[-1]:38s} {", ".join(changes)}')
    print(f'\n{fixed} fichiers corrigés, géométrie vérifiée inchangée sur chacun')


if __name__ == '__main__':
    main()
