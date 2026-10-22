#!/usr/bin/env python3
import json

def analyze(name):
    path = f'Data/Ground/{name}.rsground'
    with open(path, encoding='utf-8-sig') as f:
        d = json.load(f)
    o = d['Object']
    layers = o['Layers']
    tiles = layers[0]['Tiles']
    h, w = len(tiles), len(tiles[0])
    obs = o.get('obstacles', [])
    
    tile_ids = {}
    sheets = {}
    blocked_count = 0
    for y in range(h):
        for x in range(w):
            t = tiles[y][x]
            data = t.get('Data', {})
            tid = data.get('ID', 'unknown') if isinstance(data, dict) else 'unknown'
            tile_ids[tid] = tile_ids.get(tid, 0) + 1
            for ly in t.get('Layers', []):
                for fr in ly.get('Frames', []):
                    s = fr.get('Sheet', '')
                    if s: sheets[s] = sheets.get(s, 0) + 1
            if y < len(obs) and x < len(obs[y]):
                if obs[y][x].get('Tags', 0) != 0:
                    blocked_count += 1
    
    ents = o.get('Entities', [])
    layer0 = ents[0] if ents else {}
    markers = layer0.get('Markers', [])
    gobjs = layer0.get('GroundObjects', [])
    chars = layer0.get('MapChars', [])
    
    print('=== ' + name + ' ===')
    print('  Size: ' + str(w) + 'x' + str(h) + ' tiles (' + str(w*8) + 'x' + str(h*8) + ' px)')
    print('  Tile IDs: ' + str(tile_ids))
    print('  Sheets: ' + str(dict(list(sheets.items())[:5])))
    print('  Blocked: ' + str(blocked_count) + '/' + str(w*h) + ' (' + str(blocked_count*100//(w*h)) + '%)')
    
    mk_names = [m.get('EntName','?') for m in markers]
    gob_names = [g.get('EntName','?') for g in gobjs]
    ch_names = [c.get('EntName','?') for c in chars]
    print('  Markers: ' + str(mk_names))
    print('  GroundObjects: ' + str(gob_names))
    print('  MapChars: ' + str(ch_names))
    
    decos = o.get('Decorations', [])
    print('  Decorations: ' + str(len(decos)) + ' layers')
    for dc in decos:
        anims = dc.get('Anims', [])
        if isinstance(anims, dict):
            vals = anims.get('$values', [])
            print('    - ' + str(dc.get('Name','?')) + ': ' + str(len(vals)) + ' anims (dict)')
    
    print('  Music: ' + str(o.get('Music','?')))
    bg_type = o.get('Background',{}).get('$type','?').split('.')[-1]
    print('  Background: ' + bg_type)
    
    cx, cy = w//2, h//2
    for label, tx, ty in [('coin HG', 0, 0), ('bord N', cx, 0), ('centre', cx, cy)]:
        if ty < h and tx < w:
            t = tiles[ty][tx]
            data = t.get('Data', {})
            tid = data.get('ID', '?') if isinstance(data, dict) else '?'
            tex = data.get('TileTex', {}) if isinstance(data, dict) else {}
            nc = tex.get('NeighborCode', -1)
            at = tex.get('AutoTileset', '')
            tl = '?'
            for ly in t.get('Layers', []):
                for fr in ly.get('Frames', []):
                    txloc = fr.get('TexLoc', {})
                    tl = '(' + str(txloc.get('X',0)) + ',' + str(txloc.get('Y',0)) + ')'
                    break
                break
            print('  ' + label + ': ID=' + str(tid) + ', NC=' + str(nc) + ', AT=' + str(at[:30]) + ', TexLoc=' + tl)

for m in ['vast_steppe_entrance', 'mount_windswept_entrance', 'searing_tunnel_entrance',
          'crooked_cavern_midpoint', 'searing_tunnel_midpoint',
          'gloomy_forest_boss', 'searing_crucible']:
    try:
        analyze(m)
    except Exception as e:
        print('\n=== ' + m + ' === ERROR: ' + str(e))
