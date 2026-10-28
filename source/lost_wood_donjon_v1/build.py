#!/usr/bin/env python3
"""Génère les tiles natifs originaux du donjon Lost Wood, comme les anciens lots.

Pipeline du lot :
  * 47 masques d'adjacence canoniques (même convention cardinal/diagonale
    que les générateurs de donjons précédents) ;
  * cellules 24×24 originales, fabriquées pixel par pixel (aucun sprite ou
    tilesheet commercial copié) : sol forêt ancienne, murs racinés/moussus,
    bassin secondaire animé ;
  * empaquetage natif PMDO : Content/Tile/*.tile + Data/AutoTile/*.json,
    puis les MapDictTextureStep du donjon Lost Wood les référencent ;
  * aperçu des planches et scène de donjon générée pour l'inspection.

Les trois définitions AutoTile utilisent le schéma de données natif de PMDO;
leurs tables de cases viennent du gabarit d'AutoTiles de base et les pixels
sont des créations procédurales inédites. art_approved=false,
runtime_tested=false.

Usage : python3 source/lost_wood_donjon_v1/build.py
"""
from __future__ import annotations

import copy
import io
import json
import math
import struct
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[2]
QUEST = ROOT / 'quest_pmd_destiny'
REF = ROOT / 'source/lost_wood_donjon_v1/references'
OUT = ROOT / 'renders/lost_wood_donjon_v1'
CELL = 24
COLS = 8

# Masques d'adjacence canoniques (N,E,S,W,NE,SE,SW,NW = 1,2,4,8,16,32,64,128).
def canonical(m: int) -> int:
    for diag, a, b in [(16,1,2),(32,2,4),(64,4,8),(128,8,1)]:
        if not (m & a and m & b):
            m &= ~diag
    return m

MASKS = sorted(set(canonical(m) for m in range(256)))
assert len(MASKS) == 47

def shape(mask: int, inset: int = 1) -> np.ndarray:
    """Silhouette 24x24 associée au masque (code du générateur précédent)."""
    yy, xx = np.mgrid[:CELL, :CELL]
    a = np.ones((CELL, CELL), bool)
    for horizontal, vertical, diag, qx, qy in [
            (8,1,128,0,0),(2,1,16,1,0),(8,4,64,0,1),(2,4,32,1,1)]:
        u = xx if qx == 0 else 23-xx
        v = yy if qy == 0 else 23-yy
        q = (u < 12) & (v < 12)
        h = bool(mask & horizontal)
        vs = bool(mask & vertical)
        if h and vs:
            inside = ((u*u + v*v) >= (2 + inset) ** 2) if not mask & diag else np.ones_like(a)
        elif not h and not vs:
            inside = (u-12)**2 + (v-12)**2 <= (11-inset)**2
        elif not h:
            inside = u >= 2 + inset
        else:
            inside = v >= 2 + inset
        a[q] = inside[q]
    return a


def table_data(filename: str):
    return json.loads((REF / filename).read_text(encoding='utf-8-sig'))


def noise_texture(kind: str, seed: int, phase: int = 0, mask: int = 255) -> Image.Image:
    """Texture forêt originale (24px) à palette pixel-art contrôlée."""
    rng = np.random.default_rng(seed)
    yy, xx = np.mgrid[:CELL, :CELL]
    n = rng.integers(-14, 15, (CELL, CELL))
    if kind == 'floor':
        base = np.zeros((CELL,CELL,3), dtype=np.float32)
        base[:] = (43, 65, 39)
        # mousse en nappes souples, veinures et terre sombre en pixels francs
        moss = (np.sin((xx + yy*.35 + seed%9)/5.0) + np.cos((yy-xx*.25)/4.7))
        base[:,:,0] += n*.34 + moss*5
        base[:,:,1] += n*.48 + moss*8
        base[:,:,2] += n*.25 + moss*3
        patch = ((xx//4 + 2*(yy//4) + seed) % 7 == 0)
        base[patch] += np.array([11, 16, 4])
        veins = ((yy + seed%6) % 11 == 0) & (rng.random((CELL,CELL)) > .45)
        base[veins] = (74, 82, 47)
        # feuilles sèches et petites pierres incrustées
        for _ in range(5):
            x,y = int(rng.integers(1,23)), int(rng.integers(1,23))
            base[y:y+2, x:x+2] = (89, 82, 48) if rng.random() > .5 else (34, 49, 34)
        alpha = np.full((CELL,CELL),255,np.uint8)
    elif kind == 'wall':
        base = np.zeros((CELL,CELL,3), dtype=np.float32)
        base[:] = (61, 48, 35)
        # écorce ancienne : stries verticales discontinues, sans motif répété oblique
        grain = np.sin((xx + seed%5)/3.0)*4 + np.cos((yy+seed%7)/6.0)*3
        base[:,:,0] += grain + n*.26
        base[:,:,1] += grain*.62 + n*.20
        base[:,:,2] += grain*.36 + n*.15
        for col in range(2, CELL-2, 6):
            offset = int(rng.integers(-2,3))
            x = max(1, min(CELL-2, col+offset))
            y0 = int(rng.integers(1,7)); y1 = int(rng.integers(15,24))
            base[y0:y1, x:x+1] += np.array([19, 13, 6])
            if x+1 < CELL: base[y0+3:y1:5, x+1] -= np.array([12, 8, 4])
        # blocs de mousse irréguliers en haut et sur les creux de l'écorce
        for _ in range(4):
            x,y = int(rng.integers(0,20)), int(rng.integers(0,13))
            ww,hh=int(rng.integers(2,6)),int(rng.integers(1,3))
            base[y:y+hh,x:x+ww] = (58, 91, 43)
        # bord supérieur éclairé et profondeur de terre en bas
        base[0:2,:,:] += np.array([24, 23, 9])
        base[20:,:,:] -= np.array([9, 8, 5])
        alpha = (shape(mask, inset=1).astype(np.uint8) * 255)
    else:  # secondary: eau sombre animée, reflets verts/bleus
        base = np.zeros((CELL,CELL,3), dtype=np.float32)
        base[:] = (17, 44, 44)
        wave = np.sin((xx + phase*2.2 + seed%7)*2*np.pi/13 + np.sin(yy/5))
        base[:,:,0] += wave*3
        base[:,:,1] += wave*10 + np.sin((yy-phase)/5)*3
        base[:,:,2] += wave*13 + 7
        # reflets de lune en tirets horizontaux (les phases font glisser les lueurs)
        glint = ((yy + phase*2 + seed%5) % 8 < 2) & (wave > .55) & (rng.random((CELL,CELL)) > .28)
        base[glint] += np.array([25, 39, 37])
        alpha = (shape(mask, inset=1).astype(np.uint8)*255)
    rgb = np.clip(base,0,255).astype(np.uint8)
    rgba = np.dstack([rgb, alpha])
    return Image.fromarray(rgba, 'RGBA')


def rewrite_autotile(ref_name: str, out_name: str, sheet: str, kind: str,
                     gen_cell, cells: list[Image.Image]) -> dict:
    """Clone le schéma natif, remplace toutes les textures par cellules créées."""
    d = table_data(ref_name)
    o = d['Object']
    o['Name'] = {'DefaultText': {'lost_wood_floor':'Lost Wood — Sol ancien',
                                  'lost_wood_wall':'Lost Wood — Mur raciné',
                                  'lost_wood_secondary':'Lost Wood — Eau et marécage'}[out_name],
                 'LocalTexts': {'fr': {'lost_wood_floor':'Lost Wood — Sol ancien',
                                       'lost_wood_wall':'Lost Wood — Mur raciné',
                                       'lost_wood_secondary':'Lost Wood — Eau et marécage'}[out_name]}}
    o['Comment'] = 'Création PMD Destiny originale ; données d’autotiling PMDO natives, pixels générés (art_approved:false).'
    idx = 0
    for slot, variants in o['Tiles'].items():
        if not slot.startswith('Tilex'):
            continue
        mask = int(slot[5:], 16)
        for vi, groups in enumerate(variants):
            for gi, group in enumerate(groups):
                frames = group['Frames']
                for fi, frame in enumerate(frames):
                    x, y = idx % COLS, idx // COLS
                    frame['Sheet'] = sheet
                    frame['TexLoc'] = {'X': x, 'Y': y}
                    # frame-specific original tile, deterministic across runs
                    cells.append(gen_cell(mask, idx, vi, gi, fi))
                    idx += 1
    d['Version'] = '0.8.12.0'
    return d


def pack_tile(cells: list[Image.Image], tile_size=CELL) -> bytes:
    pngs=[]
    for im in cells:
        buf=io.BytesIO(); im.save(buf, format='PNG', optimize=True); pngs.append(buf.getvalue())
    header_len = 8 + len(pngs)*16
    offset = header_len
    records=[]
    body=bytearray()
    for i, raw in enumerate(pngs):
        x, y = i % COLS, i // COLS
        records.append(struct.pack('<iiQ', x, y, offset))
        body += struct.pack('<Q', len(raw)) + raw
        offset += 8 + len(raw)
    return struct.pack('<ii', tile_size, len(pngs)) + b''.join(records) + body


def decode_tile_records(data: bytes):
    tile_size, count = struct.unpack_from('<ii', data)
    out=[]
    for i in range(count):
        x,y,off=struct.unpack_from('<iiQ',data,8+i*16)
        n=struct.unpack_from('<Q',data,off)[0]
        out.append((x,y,data[off+8:off+8+n]))
    return tile_size,out


def sheet_preview(cells: list[Image.Image]) -> Image.Image:
    rows=math.ceil(len(cells)/COLS)
    out=Image.new('RGBA',(COLS*CELL,rows*CELL),(22,25,21,255))
    for i,im in enumerate(cells): out.alpha_composite(im,((i%COLS)*CELL,(i//COLS)*CELL))
    return out


def read_dotnet_string(f):
    size=0; shift=0
    while True:
        b=f.read(1)
        if not b: raise ValueError('index Tile tronqué')
        v=b[0]; size |= (v & 127) << shift
        if v < 128: break
        shift += 7
        if shift > 35: raise ValueError('chaîne .NET invalide')
    raw=f.read(size)
    if len(raw)!=size: raise ValueError('index Tile tronqué')
    return raw.decode('utf-8')


def write_dotnet_string(s):
    raw=s.encode('utf-8'); n=len(raw); out=bytearray()
    while n>=128: out.append((n&127)|128); n >>= 7
    out.append(n); return bytes(out)+raw


def merge_tile_index(tile_dir: Path):
    """Régénère l'index natif à partir de tous les .tile présents, sans perdre d'entrée."""
    p=tile_dir/'index.idx'; nodes={}
    if p.exists():
        import io
        f=io.BytesIO(p.read_bytes())
        count=struct.unpack('<i',f.read(4))[0]
        for _ in range(count):
            name=read_dotnet_string(f)
            head=f.read(8)
            if len(head)!=8: raise ValueError('nœud TileIndex tronqué')
            ts,n=struct.unpack('<ii',head)
            tail=f.read(n*16)
            if len(tail)!=n*16: raise ValueError('nœud TileIndex tronqué')
            nodes[name]=head+tail
    for p_tile in tile_dir.glob('*.tile'):
        raw=p_tile.read_bytes(); ts,n=struct.unpack_from('<ii',raw,0)
        if ts<=0 or n<0: raise ValueError(f'header invalide: {p_tile.name}')
        node=raw[:8+n*16]
        if len(node)!=8+n*16: raise ValueError(f'nœud incomplet: {p_tile.name}')
        nodes[p_tile.stem]=node
    p.write_bytes(struct.pack('<i',len(nodes))+b''.join(write_dotnet_string(k)+nodes[k] for k in sorted(nodes)))
    return len(nodes)


def render_demo(floor_cells, wall_cells, water_cells):
    """Planche de présentation procédurale — non substitut au rendu PMDO."""
    w,h=576,432
    im=Image.new('RGBA',(w,h),(14,24,24,255))
    # layout connected: clear rooms and winding forest corridor
    walk=np.zeros((18,24),bool)
    for x1,y1,x2,y2 in [(2,2,9,7),(14,2,22,8),(3,11,10,16),(15,11,22,16)]: walk[y1:y2,x1:x2]=1
    walk[4:6,7:17]=1; walk[4:14,6:8]=1; walk[12:14,6:19]=1; walk[5:14,18:20]=1; walk[13:18,11:13]=1
    # use sample cells as textural swatches, not validated final engine layout
    for y in range(18):
        for x in range(24):
            pos=(x*CELL,y*CELL)
            idx=(x*7+y*11)%len(floor_cells)
            im.alpha_composite(floor_cells[idx],pos)
            if not walk[y,x]:
                wi=(x*5+y*3)%len(wall_cells)
                tile=wall_cells[wi]
                if tile.getbbox(): im.alpha_composite(tile,pos)
            elif (x*3+y*5)%61==0:
                im.alpha_composite(water_cells[(x+y)%len(water_cells)],pos)
    return im


def main():
    out_aut=QUEST/'Data'/'AutoTile'; out_tile=QUEST/'Content'/'Tile'
    out_aut.mkdir(parents=True,exist_ok=True); out_tile.mkdir(parents=True,exist_ok=True)
    OUT.mkdir(parents=True,exist_ok=True)

    floor=[]; wall=[]; secondary=[]
    def fgen(m,i,v,g,fi): return noise_texture('floor', 3000+i, mask=m)
    def wgen(m,i,v,g,fi): return noise_texture('wall', 7000+i, phase=fi, mask=m)
    def sgen(m,i,v,g,fi): return noise_texture('secondary', 11000+i, phase=fi, mask=m)
    floor_obj=rewrite_autotile('mystifying_forest_floor.json','lost_wood_floor','LostWoodFloor','floor',fgen,floor)
    wall_obj=rewrite_autotile('mystifying_forest_wall.json','lost_wood_wall','LostWoodWall','wall',wgen,wall)
    sec_obj=rewrite_autotile('mystifying_forest_secondary.json','lost_wood_secondary','LostWoodSecondary','secondary',sgen,secondary)

    for name,cells,obj in [('LostWoodFloor',floor,floor_obj),('LostWoodWall',wall,wall_obj),('LostWoodSecondary',secondary,sec_obj)]:
        (out_tile/f'{name}.tile').write_bytes(pack_tile(cells))
        target={'LostWoodFloor':'lost_wood_floor','LostWoodWall':'lost_wood_wall','LostWoodSecondary':'lost_wood_secondary'}[name]
        (out_aut/f'{target}.json').write_text(json.dumps(obj,ensure_ascii=False,indent=1)+'\n',encoding='utf-8')
        sheet_preview(cells).save(OUT/f'{name}_planche.png')
        # structural package sanity
        ts,recs=decode_tile_records((out_tile/f'{name}.tile').read_bytes())
        assert ts==CELL and len(recs)==len(cells)
    tile_count=merge_tile_index(out_tile)
    demo=render_demo(floor,wall,secondary[:47])
    demo.save(OUT/'lost_wood_demo_procedural.png')
    # Lier le donjon de sept étages aux trois tilesets nouvellement construits.
    zone_path=QUEST/'Data'/'Zone'/'lost_wood.json'
    zone=json.loads(zone_path.read_text(encoding='utf-8-sig'))
    for seg in zone['Object']['Segments']:
        for step in seg.get('ZoneSteps',[]):
            if 'FloorNameDropZoneStep' in step.get('$type',''):
                step['Name']={'DefaultText':'Lost Wood\n{0}F',
                              'LocalTexts':{'fr':'Lost Wood\n{0}F'}}
        for floor_def in seg.get('Floors',[]):
            for step in floor_def.get('GenSteps',[]):
                val=step.get('Value',{})
                if 'FloorNameDropZoneStep' in val.get('$type',''):
                    val['Name']={'DefaultText':'Lost Wood\n{0}F',
                                 'LocalTexts':{'fr':'Lost Wood\n{0}F'}}
                if 'MapDictTextureStep' in val.get('$type',''):
                    val['TextureMap']={'floor':'lost_wood_floor',
                        'wall':'lost_wood_wall','unbreakable':'lost_wood_wall',
                        'water':'lost_wood_secondary','lava':'lost_wood_secondary',
                        'pit':'lost_wood_secondary','water_poison':'lost_wood_secondary'}
                    val['BlankBG']='lost_wood_wall'
                    val['LayeredGround']=True
                    val['GroundElement']='grass'
    zone_path.write_text(json.dumps(zone,ensure_ascii=False,indent=1)+'\n',encoding='utf-8')
    manifest={'lot':'lost_wood_donjon_v1','tile_px':24,'canonical_masks':MASKS,
              'tilesets':{'LostWoodFloor':len(floor),'LostWoodWall':len(wall),'LostWoodSecondary':len(secondary)},
              'autotiles':['lost_wood_floor','lost_wood_wall','lost_wood_secondary'],
              'art_approved':False,'runtime_tested':False,
              'pixel_provenance':'procedural pixels created by this build; no commercial sprite or tilesheet copied',
              'schema_source':'native PMDO AutoTileAdjacent tables (DumpAsset 0.8.12), used as schema only'}
    (OUT/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
    (ROOT/'source/lost_wood_donjon_v1/manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
    print('Tiles natifs Lost Wood générés :',manifest['tilesets'])
    print('Aperçu :',OUT/'lost_wood_demo_procedural.png')
    print('art_approved=false ; runtime_tested=false')

if __name__=='__main__': main()
