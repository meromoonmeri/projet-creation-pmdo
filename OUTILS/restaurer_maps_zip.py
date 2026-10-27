#!/usr/bin/env python3
"""Restaure dans l'aperçu les maps livrées dans les archives ZIP de la racine.

Pour chaque ``*.zip`` de la racine du dépôt :

1. l'archive est extraite dans ``apercus/zips/<pack>/contenu/`` ;
2. les tilesets ``.tile`` et fonds ``.dir`` sont décodés en atlas PNG
   (``tilesets/``, ``bg/``) partagés par toutes les cartes du pack ;
3. chaque carte ``.rsground`` (GroundMap RogueEssence) est rendue fidèlement
   dans ``maps/<asset>.html`` + ``maps/<asset>.json`` : calques natifs 8 px,
   animations de tuiles (``FrameLength`` en ticks 1/60 s), fonds animés
   (``.dir`` multi-frames, défilement ``BGMovement`` en px/s, ``RepeatX``),
   marqueurs et collisions en surimpression ;
4. une vignette et une page d'index par pack, plus un stub racine
   ``apercu_zip_<pack>.html`` listé par le serveur d'aperçus.

Rendu exact des fichiers moteur : aucune tuile n'est recolorée, retournée ni
redimensionnée. Les pixels affichés sont ceux des ``.tile`` (alpha dé-prémultiplié
pour l'affichage navigateur uniquement).

Usage : ``.venv/bin/python OUTILS/restaurer_maps_zip.py`` (Pillow + numpy).
"""
from __future__ import annotations

import argparse
import html
import io
import json
import re
import struct
import sys
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
TICK_MS = 1000.0 / 60.0


# ---------------------------------------------------------------- formats natifs

def unpremult(image: Image.Image) -> Image.Image:
    """Inverse le prémultiplié des .tile/.dir pour un affichage alpha droit."""
    a = np.array(image.convert('RGBA'), dtype=np.uint16)
    rgb, al = a[:, :, :3], a[:, :, 3:4]
    with np.errstate(divide='ignore', invalid='ignore'):
        res = np.clip((rgb * 255 + al // 2) // np.maximum(al, 1), 0, 255)
    out = np.zeros_like(a)
    out[:, :, :3] = np.where(al > 0, res, 0)
    out[:, :, 3] = a[:, :, 3]
    return Image.fromarray(out.astype('uint8'))


def read_tile(path: Path) -> dict[tuple[int, int], Image.Image]:
    """TileIndexNode : <ii (8, n) puis n × <iiq (x, y, offset), PNG 8×8 par offset."""
    raw = path.read_bytes()
    size, count = struct.unpack_from('<ii', raw)
    if size != 8:
        raise ValueError(f'{path}: taille de tuile {size} != 8')
    tiles: dict[tuple[int, int], Image.Image] = {}
    cache: dict[int, Image.Image] = {}
    for i in range(count):
        x, y, off = struct.unpack_from('<iiq', raw, 8 + i * 16)
        if off not in cache:
            n, = struct.unpack_from('<q', raw, off)
            im = Image.open(io.BytesIO(raw[off + 8:off + 8 + n])).convert('RGBA')
            if im.size != (8, 8):
                raise ValueError(f'{path}: tuile {im.size} != 8×8')
            cache[off] = unpremult(im)
        tiles[x, y] = cache[off]
    return tiles


def read_dir(path: Path):
    """<q longueur + PNG prémultiplié + <4i (l, h, dirs, frames)."""
    raw = path.read_bytes()
    n, = struct.unpack_from('<q', raw)
    im = unpremult(Image.open(io.BytesIO(raw[8:8 + n])).convert('RGBA'))
    w, h, dirs, frames = struct.unpack_from('<4i', raw, 8 + n)
    if (w, h) != im.size:
        raise ValueError(f'{path}: dimensions {im.size} != {(w, h)}')
    return im, w, h, dirs, frames


def tile_atlas(tiles: dict[tuple[int, int], Image.Image]) -> Image.Image:
    cols = max(x for x, _ in tiles) + 1
    rows = max(y for _, y in tiles) + 1
    atlas = Image.new('RGBA', (cols * 8, rows * 8))
    for (x, y), im in tiles.items():
        atlas.paste(im, (x * 8, y * 8))
    return atlas


# ---------------------------------------------------------------- carte Ground

def cell_anims(tile: dict) -> list[list]:
    """[[FrameLength, [(sheet, x, y), ...]], ...] pour une case."""
    out = []
    for anim in tile.get('Layers', []):
        frames = [(f['Sheet'], f['TexLoc']['X'], f['TexLoc']['Y']) for f in anim['Frames']]
        if frames:
            out.append([int(anim.get('FrameLength', 60)), frames])
    return out


def anim_static(anims: list[list]) -> bool:
    return all(len({tuple(f) for f in frames}) <= 1 for _, frames in anims)


def build_map(doc: dict, sheets: list[str], bg_entries: list[dict],
              warn: list[str]) -> dict:
    obj = doc['Object']
    if obj.get('TexSize', 1) != 1:
        warn.append(f"TexSize={obj.get('TexSize')} non testé (tuiles 8 px supposées)")
    tiles_all = obj['Layers']
    wt = len(tiles_all[0]['Tiles'])
    ht = len(tiles_all[0]['Tiles'][0])

    layers_out = []
    for li, layer in enumerate(tiles_all):
        grid = layer['Tiles']
        if len(grid) != wt or len(grid[0]) != ht:
            raise ValueError(f"grille incohérente calque {layer.get('Name')}")
        defs: list = []
        index: dict = {}
        cells: list[int] = []
        n_anim = 0
        for x in range(wt):
            for y in range(ht):
                anims = cell_anims(grid[x][y])
                if not anims:
                    cells.append(-1)
                    continue
                for _, frames in anims:
                    for sheet, tx, ty in frames:
                        if sheet not in sheets:
                            sheets.append(sheet)
                static = anim_static(anims)
                if not static:
                    n_anim += 1
                key = (static, tuple((fl, tuple(map(tuple, fr))) for fl, fr in anims))
                if key not in index:
                    index[key] = len(defs)
                    defs.append([1 if static else 0,
                                 [[fl, [[sheets.index(s), tx, ty] for s, tx, ty in fr]]
                                  for fl, fr in anims]])
                cells.append(index[key])
        layers_out.append({
            'name': layer.get('Name', f'calque {li}'),
            'top': layer.get('Layer', 0),
            'visible': bool(layer.get('Visible', True)),
            'static': n_anim == 0,
            'defs': defs,
            'grid': cells,
            'anim_cells': n_anim,
        })
        if not layer.get('Visible', True):
            warn.append(f"calque « {layer.get('Name')} » masqué (Visible=false) : non dessiné")

    markers = []
    for ent in obj.get('Entities', []):
        for m in ent.get('Markers', []):
            c = m.get('Collider', {})
            markers.append({'name': m.get('EntName', '?'),
                            'rect': [c.get('X', 0), c.get('Y', 0),
                                     c.get('Width', 16), c.get('Height', 16)]})
        if ent.get('MapChars') or ent.get('GroundObjects') or ent.get('Spawners'):
            warn.append('entités de scène présentes mais non rendues')

    decor = sum(len(dc.get('Anims', [])) for dc in obj.get('Decorations', []))
    if decor:
        warn.append(f'{decor} décorations animées non rendues')

    obstacles = obj.get('obstacles')
    collisions = None
    if obstacles:
        flat = [int((obstacles[x][y] or {}).get('Tags', 0) or 0)
                for x in range(len(obstacles)) for y in range(len(obstacles[0]))]
        if any(flat):
            collisions = flat

    return {
        'label': obj.get('Name', {}).get('DefaultText', ''),
        'tile_px': 8,
        'wt': wt, 'ht': ht,
        'bg': bg_entries,
        'layers': layers_out,
        'markers': markers,
        'collisions': collisions,
    }


def load_backgrounds(root: Path, obj: dict, warn: list[str]) -> list[dict]:
    bg = obj.get('Background') or {}
    items = bg.get('Layers', [bg] if 'BG' in bg else [])
    out = []
    for item in items:
        g = item.get('BG', item)
        anim = g.get('BGAnim', {})
        name = anim.get('AnimIndex', '')
        path = root / 'Content' / 'BG' / f'{name}.dir'
        if not path.exists():
            warn.append(f'fond « {name} » introuvable')
            continue
        im, w, h, dirs, frames = read_dir(path)
        if dirs > 1:
            warn.append(f'fond « {name} » : {dirs} directions non rendues')
        out.append({
            'img': name, 'w': w, 'h': h,
            'frames': max(frames, 1), 'frame_time': max(int(anim.get('FrameTime', 1)), 1),
            'loc': [g.get('MapLoc', {}).get('X', 0), g.get('MapLoc', {}).get('Y', 0)],
            'move': [g.get('BGMovement', {}).get('X', 0), g.get('BGMovement', {}).get('Y', 0)],
            'repeat_x': bool(g.get('RepeatX')), 'repeat_y': bool(g.get('RepeatY')),
            'alpha': int(anim.get('Alpha', 255)),
        })
    return out


# ---------------------------------------------------------------- vignette

def render_frame0(doc_map: dict, sheet_imgs: list, bg_imgs: dict) -> Image.Image:
    """Compose la scène à la phase 0 (fond + calques), pour la vignette."""
    wpx, hpx = doc_map['wt'] * 8, doc_map['ht'] * 8
    base = Image.new('RGBA', (wpx, hpx), (16, 16, 24, 255))
    for bg in doc_map['bg']:
        im = bg_imgs[bg['img']]
        if bg['frames'] > 1:
            cols = min(4, bg['frames'])
            fw, fh = bg['w'], bg['h']
            im = im.crop((0, 0, fw, fh))
        layer = Image.new('RGBA', (wpx, hpx))
        x0, y0 = bg['loc']
        xx = x0
        if bg['repeat_x']:
            while xx > 0:
                xx -= bg['w']
        while xx < wpx:
            layer.paste(im, (xx, y0), im)
            xx += bg['w']
        base.alpha_composite(layer)
    for layer in doc_map['layers']:
        if not layer['visible']:
            continue
        over = Image.new('RGBA', (wpx, hpx))
        defs = layer['defs']
        grid = layer['grid']
        ht = doc_map['ht']
        for i, di in enumerate(grid):
            if di < 0:
                continue
            x, y = i // ht, i % ht
            st, anims = defs[di]
            for _, frames in anims:
                s, tx, ty = frames[0]
                atlas = sheet_imgs[s]
                tile = atlas.crop((tx * 8, ty * 8, tx * 8 + 8, ty * 8 + 8))
                over.paste(tile, (x * 8, y * 8), tile)
        base.alpha_composite(over)
    return base


# ---------------------------------------------------------------- HTML

PAGE_JS = r"""
const CFG = @@CFG@@, SHEETS = @@SHEETS@@, BG = @@BG@@;
const W = CFG.wt * 8, H = CFG.ht * 8, TP = CFG.tile_px;
const fond = document.getElementById('fond'), scene = document.getElementById('scène');
for (const c of [fond, scene]) { c.width = W; c.height = H; }
const sheetImgs = SHEETS.map(src => { const im = new Image(); im.src = src; return im; });
const bgImgs = BG.map(b => { const im = new Image(); im.src = '../bg/' + b.img + '.png'; return im; });

function animKey(tick) {
  let k = '';
  for (const L of CFG.layers) for (const [st, anims] of L.defs) if (!st)
    for (const [fl, fr] of anims) k += Math.floor(tick / fl) % fr.length + '.';
  return k;
}

function drawFond(tick) {
  const g = fond.getContext('2d');
  g.clearRect(0, 0, W, H);
  for (let i = 0; i < BG.length; i++) {
    const b = BG[i], im = bgImgs[i];
    if (!im.complete) continue;
    const fw = b.w, fh = b.h, cols = Math.min(4, b.frames);
    const fi = Math.floor(tick / b.frame_time) % b.frames;
    const sx = (fi % cols) * fw, sy = Math.floor(fi / cols) * fh;
    const dx = b.loc[0] + b.move[0] * tick / 60, dy = b.loc[1] + b.move[1] * tick / 60;
    g.globalAlpha = b.alpha / 255;
    let x0 = dx;
    if (b.repeat_x) { while (x0 > 0) x0 -= fw; for (let x = x0; x < W; x += fw) g.drawImage(im, sx, sy, fw, fh, x, dy, fw, fh); }
    else g.drawImage(im, sx, sy, fw, fh, dx, dy, fw, fh);
    g.globalAlpha = 1;
  }
}

const staticCanvas = {};
function buildStatic(li) {
  if (staticCanvas[li]) return staticCanvas[li];
  const c = document.createElement('canvas'); c.width = W; c.height = H;
  const g = c.getContext('2d'), L = CFG.layers[li], defs = L.defs, grid = L.grid;
  for (let i = 0; i < grid.length; i++) {
    const di = grid[i]; if (di < 0) continue;
    const x = Math.floor(i / CFG.ht) * TP, y = (i % CFG.ht) * TP;
    for (const [fl, fr] of defs[di][1]) {
      const [s, tx, ty] = fr[0];
      g.drawImage(sheetImgs[s], tx * TP, ty * TP, TP, TP, x, y, TP, TP);
    }
  }
  staticCanvas[li] = c; return c;
}

function drawScene(tick) {
  const g = scene.getContext('2d');
  g.clearRect(0, 0, W, H);
  for (let li = 0; li < CFG.layers.length; li++) {
    const L = CFG.layers[li];
    if (!L.visible) continue;
    if (L.static) { const c = buildStatic(li); if (c) g.drawImage(c, 0, 0); continue; }
    const defs = L.defs, grid = L.grid;
    for (let i = 0; i < grid.length; i++) {
      const di = grid[i]; if (di < 0) continue;
      const [st, anims] = defs[di];
      const x = Math.floor(i / CFG.ht) * TP, y = (i % CFG.ht) * TP;
      if (st) {
        for (const [fl, fr] of anims) { const [s, tx, ty] = fr[0]; g.drawImage(sheetImgs[s], tx * TP, ty * TP, TP, TP, x, y, TP, TP); }
      } else {
        g.clearRect(x, y, TP, TP);
        for (const [fl, fr] of anims) {
          const [s, tx, ty] = fr[Math.floor(tick / fl) % fr.length];
          g.drawImage(sheetImgs[s], tx * TP, ty * TP, TP, TP, x, y, TP, TP);
        }
      }
    }
  }
}

function drawOverlay() {
  const g = document.getElementById('surimpression').getContext('2d');
  g.clearRect(0, 0, W, H);
  if (document.getElementById('marqueurs').checked) {
    for (const m of CFG.markers) {
      const [x, y, w, h] = m.rect;
      g.strokeStyle = '#ffd76a'; g.lineWidth = 2; g.strokeRect(x + 1, y + 1, w - 2, h - 2);
      g.fillStyle = '#ffd76a'; g.font = '11px system-ui';
      g.fillText(m.name, x + w + 4, y + h - 3);
    }
  }
  if (CFG.collisions && document.getElementById('collisions').checked) {
    g.fillStyle = 'rgba(255,0,0,0.30)';
    for (let i = 0; i < CFG.collisions.length; i++) if (CFG.collisions[i]) {
      const x = Math.floor(i / CFG.ht) * TP, y = (i % CFG.ht) * TP;
      g.fillRect(x, y, TP, TP);
    }
  }
}

let start = performance.now(), paused = false, held = 0, lastKey = null, lastTick = -1;
const moving = BG.some(b => b.move[0] || b.move[1]);
function frame(now) {
  const tick = Math.floor((paused ? held : now - start) / 1000 * 60);
  if (tick !== lastTick) {
    const key = animKey(tick);
    if (moving) drawFond(tick);
    if (key !== lastKey) {
      if (!moving) drawFond(tick);
      drawScene(tick);
      lastKey = key;
      document.getElementById('tick').textContent = 'tick ' + tick;
    }
    lastTick = tick;
  }
  requestAnimationFrame(frame);
}

function setZoom(z) {
  for (const c of ['fond', 'scène', 'surimpression']) {
    const el = document.getElementById(c);
    el.style.width = W * z + 'px'; el.style.height = H * z + 'px';
  }
}
document.getElementById('pause').onclick = e => {
  if (paused) { start = performance.now() - held; paused = false; e.target.textContent = 'Pause'; }
  else { held = performance.now() - start; paused = true; e.target.textContent = 'Reprendre'; }
};
for (const z of [1, 2, 3]) document.getElementById('z' + z).onclick = () => setZoom(z);
for (const id of ['marqueurs', 'collisions']) document.getElementById(id).onchange = drawOverlay;
setZoom(1);
drawFond(0); drawScene(0); drawOverlay();
requestAnimationFrame(frame);
"""

PAGE_HTML = """<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>@@TITRE@@</title>
<style>
body { background:#1d1a14; color:#eee; font:15px/1.5 system-ui,sans-serif; max-width:1100px; margin:18px auto; padding:0 12px }
a { color:#ffd76a } small { color:#999 }
.bar { position:sticky; top:0; background:#1d1a14ee; padding:8px 0; z-index:5; display:flex; gap:10px; flex-wrap:wrap; align-items:center }
.stage { position:relative; line-height:0; border:1px solid #333; width:max-content; max-width:100%; overflow:auto }
.stage canvas { image-rendering: pixelated; position:absolute; left:0; top:0 }
.stage canvas:first-child { position:relative }
button { background:#3a3427; color:#eee; border:1px solid #66593b; border-radius:6px; padding:4px 10px; cursor:pointer }
table { border-collapse:collapse } td, th { border:1px solid #443c2c; padding:2px 8px; font-size:13px }
</style></head><body>
<p><a href="index.html">← Toutes les maps du pack</a> · <a href="../../../../@@ZIP@@">Télécharger l'archive</a></p>
<h1>@@TITRE@@</h1>
<p>@@SOUS-TITRE@@</p>
<div class="bar">
<button id="pause">Pause</button>
<button id="z1">×1</button><button id="z2">×2</button><button id="z3">×3</button>
<label><input type="checkbox" id="marqueurs" checked> marqueurs</label>
<label><input type="checkbox" id="collisions"> collisions</label>
<small id="tick"></small>
</div>
<div class="stage">
<canvas id="fond"></canvas><canvas id="scène"></canvas><canvas id="surimpression"></canvas>
</div>
<h2>Calques natifs</h2>
<table><tr><th>Ordre</th><th>Nom</th><th>Top</th><th>Cases animées</th></tr>
@@CALQUES@@</table>
@@AVERTISSEMENTS@@
<script>@@JS@@</script>
</body></html>
"""


def map_page(title, sub, zip_name, rows, warns, js_cfg, sheets_src, bg_cfg) -> str:
    warn_html = ''
    if warns:
        warn_html = '<h2>Notes</h2><ul>' + ''.join(
            f'<li>{html.escape(w)}</li>' for w in warns) + '</ul>'
    page = (PAGE_HTML
            .replace('@@TITRE@@', html.escape(title))
            .replace('@@SOUS-TITRE@@', sub)
            .replace('@@ZIP@@', html.escape(zip_name))
            .replace('@@CALQUES@@', rows)
            .replace('@@AVERTISSEMENTS@@', warn_html)
            .replace('@@JS@@', PAGE_JS))
    page = page.replace('@@CFG@@', json.dumps(js_cfg, separators=(',', ':')))
    page = page.replace('@@SHEETS@@', json.dumps(sheets_src))
    page = page.replace('@@BG@@', json.dumps(bg_cfg, separators=(',', ':')))
    return page


# ---------------------------------------------------------------- pages de pack

INDEX_HTML = """<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>@@TITRE@@</title>
<style>
body { background:#1d1a14; color:#eee; font:15px/1.5 system-ui,sans-serif; max-width:1100px; margin:18px auto; padding:0 12px }
a { color:#ffd76a } small { color:#999 }
.grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(230px,1fr)); gap:12px }
.card { background:#262117; border:1px solid #3a3427; border-radius:8px; padding:8px }
.card img { width:100%; image-rendering:pixelated; border:1px solid #000; background:#000 }
.gal { display:grid; grid-template-columns:repeat(auto-fill,minmax(180px,1fr)); gap:10px }
.gal a img { max-width:100%; image-rendering:pixelated; border:1px solid #333; background:#000 }
</style></head><body>
<p><a href="../../../index.html">← Index des aperçus</a> · <a href="../../../@@ZIP@@">Télécharger @@ZIP@@ (@@TAILLE@@)</a></p>
<h1>@@TITRE@@</h1>
<p>@@SOUS-TITRE@@</p>
@@SECTIONS@@
</body></html>
"""


def human_size(n: int) -> str:
    for unit in ('o', 'Ko', 'Mo', 'Go'):
        if n < 1024 or unit == 'Go':
            return f'{n:.1f} {unit}' if unit != 'o' else f'{n} o'
        n /= 1024
    return f'{n}'


def pack_index(pack: str, zip_name: str, zip_size: int, intro: str,
               maps: list[dict], gallery: dict[str, list[Path]],
               files: list[Path], base: Path) -> str:
    sections = []
    if maps:
        cards = []
        for m in maps:
            vig = f"maps/{m['asset']}_vignette.png"
            cards.append(
                f'<div class="card"><a href="maps/{html.escape(m["asset"])}.html">'
                f'<img src="{vig}" alt="{html.escape(m["label"])}"></a>'
                f'<b>{html.escape(m["label"])}</b><br><small>{html.escape(m["asset"])} · '
                f'{m["wt"]}×{m["ht"]} cases · {len(m["layers"])} calques</small></div>')
        sections.append(f'<h2>Cartes Ground natives ({len(maps)})</h2>'
                        '<p>Rendu depuis les fichiers <code>.rsground</code>/<code>.tile</code>/<code>.dir</code> '
                        'de l\'archive : tuiles 8 px natives, animations de palette et fonds animés à leur cadence moteur.</p>'
                        f'<div class="grid">{"".join(cards)}</div>')
    for folder, paths in sorted(gallery.items()):
        items = []
        for p in sorted(paths):
            rel = p.relative_to(base).as_posix()
            items.append(f'<a href="{rel}" target="_blank"><img src="{rel}" loading="lazy" alt="{html.escape(p.name)}"></a>')
        titre = 'Images du pack' if folder == '.' else f'Images — {html.escape(folder)}'
        sections.append(f'<h2>{titre} ({len(paths)})</h2><div class="gal">{"".join(items)}</div>')
    if files:
        li = ''.join(f'<li><a href="{p.relative_to(base).as_posix()}">{html.escape(p.relative_to(base).as_posix())}</a></li>'
                     for p in sorted(files))
        sections.append(f'<h2>Fichiers du pack ({len(files)})</h2><ul>{li}</ul>')
    return (INDEX_HTML
            .replace('@@TITRE@@', html.escape(pack))
            .replace('@@SOUS-TITRE@@', intro)
            .replace('@@ZIP@@', html.escape(zip_name))
            .replace('@@TAILLE@@', human_size(zip_size))
            .replace('@@SECTIONS@@', ''.join(sections)))


STUB_HTML = ('<!doctype html><html lang="fr"><head><meta charset="utf-8">'
             '<title>Maps du ZIP {nom}</title>'
             '<meta http-equiv="refresh" content="0;url=apercus/zips/{pack}/index.html"></head>'
             '<body style="background:#1d1a14;color:#eee;font:15px system-ui">'
             '<a style="color:#ffd76a" href="apercus/zips/{pack}/index.html">{titre}</a></body></html>\n')


# ---------------------------------------------------------------- traitement d'un pack

IMAGE_EXT = {'.png', '.gif', '.webp', '.jpg', '.jpeg'}
TEXT_EXT = {'.md', '.json', '.txt', '.html', '.py', '.lua', '.xml', '.tsj', '.tmj'}


def find_pack_root(contenu: Path) -> Path:
    """Certaines archives ont un sous-dossier racine (ex. cotes_v2_0812/)."""
    for p in [contenu] + sorted(contenu.iterdir()):
        if p.is_dir() and ((p / 'Content').is_dir() or (p / 'Data').is_dir()):
            return p
    return contenu


def treat_pack(zip_path: Path, out_root: Path, verbose=True) -> dict:
    pack = zip_path.stem
    base = out_root / pack
    contenu = base / 'contenu'
    contenu.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(zip_path) as z:
        for info in z.infolist():
            if not info.filename.endswith('.rsground'):
                z.extract(info, contenu)
    proot = find_pack_root(contenu)
    # les .rsground (JSON très volumineux une fois décompressés) restent dans le
    # ZIP téléchargeable : ils sont lus en mémoire, pas extraits sur le disque.
    rsground_members: list[str] = []
    with zipfile.ZipFile(zip_path) as z:
        rsground_members = sorted(n for n in z.namelist() if n.endswith('.rsground'))

    warns_global = []
    # --- tilesets et fonds partagés
    tilesets_dir = base / 'tilesets'
    bg_dir = base / 'bg'
    tile_cache: dict[str, dict] = {}
    bg_cache: dict[str, tuple] = {}

    def get_tileset(name: str):
        if name not in tile_cache:
            src = proot / 'Content' / 'Tile' / f'{name}.tile'
            tiles = read_tile(src)
            atlas = tile_atlas(tiles)
            tilesets_dir.mkdir(exist_ok=True)
            atlas.save(tilesets_dir / f'{name}.png')
            tile_cache[name] = tiles
        return tile_cache[name]

    def get_bg(name: str):
        if name not in bg_cache:
            src = proot / 'Content' / 'BG' / f'{name}.dir'
            im, w, h, dirs, frames = read_dir(src)
            bg_dir.mkdir(exist_ok=True)
            im.save(bg_dir / f'{name}.png')
            bg_cache[name] = (im, w, h, frames)
        return bg_cache[name]

    # --- cartes Ground
    maps_out = []
    maps_dir = base / 'maps'
    if rsground_members:
        maps_dir.mkdir(exist_ok=True)
    for member in rsground_members:
        rg_name = Path(member).name
        try:
            with zipfile.ZipFile(zip_path) as z:
                doc = json.loads(z.read(member).decode('utf-8'))
        except Exception as exc:  # binaire inattendu
            warns_global.append(f'{rg_name} : illisible ({exc})')
            continue
        obj = doc['Object']
        asset = obj.get('AssetName') or Path(member).stem
        warn: list[str] = []
        sheets: list[str] = []
        bg_entries = load_backgrounds(proot, obj, warn)
        data = build_map(doc, sheets, bg_entries, warn)
        for name in sheets:
            get_tileset(name)
        for b in bg_entries:
            get_bg(b['img'])
        data['asset'] = asset
        data['label'] = data['label'] or asset
        data['source'] = member

        js_cfg = {k: data[k] for k in ('label', 'asset', 'tile_px', 'wt', 'ht',
                                       'layers', 'markers', 'collisions')}
        sheets_src = [f'../tilesets/{s}.png' for s in sheets]
        rows = ''.join(
            f'<tr><td>{i}</td><td>{html.escape(L["name"])}</td><td>{L["top"]}</td>'
            f'<td>{L["anim_cells"]}</td></tr>' for i, L in enumerate(data['layers']))
        title = data['label']
        sub = (f'Carte Ground native <code>{html.escape(data["source"])}</code> — '
               f'{data["wt"]}×{data["ht"]} cases de 8 px ({data["wt"]*8}×{data["ht"]*8} px). '
               'Animations de tuiles en ticks 1/60 s (FrameLength), fonds animés à la cadence du fichier.')
        page = map_page(title, sub, zip_path.name, rows, warn, js_cfg, sheets_src, bg_entries)
        (maps_dir / f'{asset}.html').write_text(page, encoding='utf-8')
        (maps_dir / f'{asset}.json').write_text(
            json.dumps({'cfg': js_cfg, 'sheets': sheets_src, 'bg': bg_entries},
                       separators=(',', ':')), encoding='utf-8')

        sheet_imgs = [tile_atlas(get_tileset(name)) for name in sheets]
        bg_imgs = {b['img']: get_bg(b['img'])[0] for b in bg_entries}
        try:
            frame = render_frame0(data, sheet_imgs, bg_imgs)
            frame.thumbnail((420, 420))
            frame.save(maps_dir / f'{asset}_vignette.png')
        except Exception as exc:
            import traceback
            traceback.print_exc()
            warn.append(f'vignette non générée ({exc})')
        maps_out.append(data)
        if verbose:
            print(f'   carte {asset} — {data["wt"]}×{data["ht"]}, '
                  f'{sum(L["anim_cells"] for L in data["layers"])} cases animées')

    # --- galerie des images du pack (hors atlas générés)
    gallery: dict[str, list[Path]] = {}
    files: list[Path] = []
    for p in sorted(contenu.rglob('*')):
        if not p.is_file():
            continue
        rel = p.relative_to(contenu)
        if rel.suffix.lower() in IMAGE_EXT:
            gallery.setdefault(rel.parent.as_posix(), []).append(p)
        elif rel.suffix.lower() in TEXT_EXT:
            files.append(p)
        else:
            files.append(p)

    # aperçu embarqué : pointer la copie racine si elle existe
    intro_bits = []
    for p in sorted(contenu.rglob('apercu_*.html')):
        root_copy = ROOT / p.name
        target = ('../../../' + p.name) if root_copy.exists() else p.relative_to(base).as_posix()
        intro_bits.append(f'<a href="{target}">{html.escape(p.stem)}</a>')
    intro = (f"Archive <b>{html.escape(zip_path.name)}</b> "
             f"({human_size(zip_path.stat().st_size)}) extraite dans "
             f"<code>apercus/zips/{pack}/contenu/</code>. ")
    if rsground_members:
        intro += (f"Les {len(rsground_members)} fichiers <code>.rsground</code> natifs restent dans "
                  f"l'<a href=\"../../../{html.escape(zip_path.name)}\">archive ZIP</a> "
                  f"(trop volumineux decompresses). ")
    if intro_bits:
        intro += "Apercu artistique livre dans l'archive : " + ' · '.join(intro_bits) + '. '
    if maps_out:
        intro += ('Les cartes ci-dessous sont les maps reelles du ZIP, rendues depuis leurs '
                  'fichiers moteur natifs (tuiles 8 px, animations conservees). ')
    else:
        intro += 'Les images du pack sont restituees a leur taille native ci-dessous. '

    idx = pack_index(pack, zip_path.name, zip_path.stat().st_size, intro,
                     maps_out, gallery, files, base)
    (base / 'index.html').write_text(idx, encoding='utf-8')

    stub = STUB_HTML.format(pack=pack,
                            nom=html.escape(zip_path.name),
                            titre=f'Maps du ZIP {html.escape(zip_path.name)}')
    (ROOT / f'apercu_zip_{pack}.html').write_text(stub, encoding='utf-8')
    return {'pack': pack, 'maps': len(maps_out), 'images': sum(len(v) for v in gallery.values())}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--racine', default=str(ROOT))
    ap.add_argument('--seulement', help='un seul pack (nom du zip sans extension)')
    args = ap.parse_args()
    root = Path(args.racine)
    out_root = root / 'apercus' / 'zips'
    zips = sorted(root.glob('*.zip'))
    if args.seulement:
        zips = [z for z in zips if z.stem == args.seulement]
    if not zips:
        sys.exit('aucune archive *.zip à la racine')
    total_maps = 0
    for zp in zips:
        print(f'== {zp.name}')
        info = treat_pack(zp, out_root)
        total_maps += info['maps']
        print(f"   → {info['maps']} cartes Ground, {info['images']} images")
    print(f'TOTAL : {total_maps} cartes restaurées dans apercus/zips/')


if __name__ == '__main__':
    main()
