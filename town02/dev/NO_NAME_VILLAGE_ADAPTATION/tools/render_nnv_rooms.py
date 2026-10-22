#!/usr/bin/env python3
"""Rend les rooms de No Name Village en PNG, depuis la source GameMaker.

SOURCE
------
L'extraction officielle UndertaleModTool, dans `extracted/official/` :
inventaires JSON (Rooms, Sprites, Backgrounds, TexturePageItems,
EmbeddedTextures, GameObjects) et 471 blobs binaires. Les 96 pages de texture
sont en BZ2+QOI et se decodent avec `tools/decode_official_textures.py`.

COMPOSITION
-----------
Une room GameMaker 2 est une pile de couches ordonnees par `LayerDepth`, du
plus grand au plus petit — la profondeur decroit vers l'avant, donc on dessine
du fond vers l'avant en triant par depth DECROISSANT.

Trois types de couches sont composes :

  Tiles      grille de tuiles indexant un tileset (Backgrounds GMS2)
  Assets     sprites poses librement, avec position, echelle et teinte
  Instances  objets du jeu, dessines via leur sprite par defaut

Les tuiles portent des drapeaux de transformation dans leurs bits hauts :
miroir horizontal (bit 31), vertical (bit 30) et rotation (bit 29). Ils sont
appliques, sans quoi murs et falaises sortent a l'envers.

Rien n'est recadre : la toile fait exactement `Width x Height` de la room,
et chaque element est pose a sa coordonnee d'origine.
"""
from __future__ import annotations
import argparse, json, os, sys
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

TILE_FLIP_H = 0x80000000
TILE_FLIP_V = 0x40000000
TILE_ROTATE = 0x20000000
TILE_INDEX = 0x0FFFFFFF


def name_of(v):
    """UndertaleModTool serialise les noms tantot en chaine, tantot en objet."""
    if isinstance(v, str):
        return v
    if isinstance(v, dict):
        return v.get('Content') or v.get('Name') or ''
    return ''


CYCLE_RE = None


def resolve(node, rootdoc, depth=0):
    """Suit les $cycleRef d'UndertaleModTool.

    L'exporteur remplace toute occurrence deja serialisee par un pointeur
    JSONPath : `{"$cycleRef": "$[27].Layers[5].Data"}`. Sans le suivre, une
    couche sur deux paraissait vide — 51 102 pointeurs dans le seul
    Rooms.json.
    """
    import re
    global CYCLE_RE
    if CYCLE_RE is None:
        CYCLE_RE = re.compile(r'\[(\d+)\]|\.([A-Za-z_][A-Za-z0-9_]*)')
    seen = 0
    while isinstance(node, dict) and '$cycleRef' in node and seen < 8:
        path = node['$cycleRef']
        cur = rootdoc
        for m in CYCLE_RE.finditer(path):
            idx, key = m.group(1), m.group(2)
            try:
                cur = cur[int(idx)] if idx is not None else cur[key]
            except Exception:
                return None
        node = cur
        seen += 1
    return node


def res_index(ref):
    """Index d'une ressource via $resourceRef."""
    if isinstance(ref, dict):
        rr = ref.get('$resourceRef')
        if isinstance(rr, dict):
            return rr.get('index'), rr.get('name')
    return None, None


def layer_type(l):
    t = l.get('LayerType')
    if isinstance(t, dict):
        return t.get('name') or ''
    return str(t or '')


class Source:
    def __init__(self, inv_dir, tex_dir):
        from PIL import Image
        self.Image = Image
        self.inv = Path(inv_dir)
        self.tex_dir = Path(tex_dir)
        self.rooms = json.load(open(self.inv / 'Rooms.json'))
        self.sprites = json.load(open(self.inv / 'Sprites.json'))
        self.tpag = json.load(open(self.inv / 'TexturePageItems.json'))
        self.bg = json.load(open(self.inv / 'Backgrounds.json'))
        self.objects = json.load(open(self.inv / 'GameObjects.json'))
        man = json.load(open(self.tex_dir / 'manifest.json'))
        self.tex_png = {t['index']: t['png'] for t in man['textures']}
        self.sprite_by_name = {}
        for i, s in enumerate(self.sprites):
            self.sprite_by_name[name_of(s.get('Name')).casefold()] = i
        self.obj_by_name = {}
        for i, o in enumerate(self.objects):
            self.obj_by_name[name_of(o.get('Name')).casefold()] = i
        self.bg_by_name = {}
        for i, b in enumerate(self.bg):
            self.bg_by_name[name_of(b.get('Name')).casefold()] = i
        self._tex = {}
        self._tpag = {}
        self._tile = {}

    # ---------- textures ----------
    def texture(self, idx):
        if idx not in self._tex:
            p = self.tex_dir / self.tex_png[idx]
            im = self.Image.open(p).convert('RGBA')
            im.load()
            self._tex[idx] = im
        return self._tex[idx]

    def tpag_ref(self, ref):
        """Un TexturePageItem, par index direct ou via $resourceRef."""
        if isinstance(ref, int):
            return self.tpag[ref] if 0 <= ref < len(self.tpag) else None
        if isinstance(ref, dict):
            rr = ref.get('$resourceRef')
            if isinstance(rr, dict):
                i = rr.get('index')
                if isinstance(i, int) and 0 <= i < len(self.tpag):
                    return self.tpag[i]
            for k in ('Resource', 'resource'):
                if k in ref:
                    return self.tpag_ref(ref[k])
            if 'SourceX' in ref:
                return ref
        return None

    def tpag_image(self, item):
        if item is None:
            return None
        key = id(item)
        if key in self._tpag:
            return self._tpag[key]
        page = item.get('TexturePage')
        if isinstance(page, dict):
            rr = page.get('$resourceRef')
            if isinstance(rr, dict):
                page = rr.get('index')
            else:
                page = page.get('Resource') or page.get('resource')
        if isinstance(page, dict):
            page = page.get('index')
        try:
            pidx = int(page)
        except Exception:
            return None
        if pidx not in self.tex_png:
            return None
        atlas = self.texture(pidx)
        sx, sy = int(item['SourceX']), int(item['SourceY'])
        sw, sh = int(item['SourceWidth']), int(item['SourceHeight'])
        img = atlas.crop((sx, sy, sx + sw, sy + sh))
        tw, th = int(item.get('TargetWidth', sw)), int(item.get('TargetHeight', sh))
        if (tw, th) != (sw, sh) and tw > 0 and th > 0:
            img = img.resize((tw, th), self.Image.Resampling.NEAREST)
        self._tpag[key] = img
        return img

    # ---------- sprites ----------
    def sprite_frame(self, sidx, frame=0):
        if not (0 <= sidx < len(self.sprites)):
            return None
        s = self.sprites[sidx]
        tex = s.get('Textures') or []
        if not tex:
            return None
        frame %= len(tex)
        ent = tex[frame]
        if isinstance(ent, dict) and 'Texture' in ent:
            ent = ent['Texture']
        item = self.tpag_ref(ent)
        img = self.tpag_image(item)
        if img is None:
            return None
        # le sprite peut etre plus grand que sa zone d'atlas : on recompose
        W, H = int(s.get('Width') or img.width), int(s.get('Height') or img.height)
        if (W, H) == img.size and int(item.get('TargetX', 0)) == 0 \
                and int(item.get('TargetY', 0)) == 0:
            return img
        canvas = self.Image.new('RGBA', (max(W, 1), max(H, 1)), (0, 0, 0, 0))
        canvas.alpha_composite(img, (int(item.get('TargetX', 0)),
                                     int(item.get('TargetY', 0))))
        return canvas

    def sprite_of_object(self, oidx):
        if not (0 <= oidx < len(self.objects)):
            return None
        o = self.objects[oidx]
        sp = o.get('Sprite')
        if isinstance(sp, dict):
            rr = sp.get('$resourceRef')
            if isinstance(rr, dict):
                i = rr.get('index')
                if isinstance(i, int):
                    return i
                nm = rr.get('name')
                if nm:
                    return self.sprite_by_name.get(str(nm).casefold())
            sp = sp.get('Resource') or sp.get('resource') or sp
            if isinstance(sp, dict):
                nm = name_of(sp.get('Name'))
                if nm:
                    return self.sprite_by_name.get(nm.casefold())
                sp = sp.get('index')
        try:
            return int(sp)
        except Exception:
            return None

    # ---------- tuiles ----------
    def tile(self, bgidx, tid):
        """Une tuile d'un tileset GMS2, par son index."""
        key = (bgidx, tid)
        if key in self._tile:
            return self._tile[key]
        if not (0 <= bgidx < len(self.bg)):
            return None
        b = self.bg[bgidx]
        cols = int(b.get('GMS2TileColumns') or 0)
        tw = int(b.get('GMS2TileWidth') or 0)
        th = int(b.get('GMS2TileHeight') or 0)
        if cols <= 0 or tw <= 0 or th <= 0:
            return None
        ids = b.get('GMS2TileIds') or []
        per = max(1, int(b.get('GMS2ItemsPerTileCount') or 1))
        pos = tid * per
        if 0 <= pos < len(ids):
            e = ids[pos]
            mapped = e.get('ID') if isinstance(e, dict) else e
            try:
                mapped = int(mapped)
            except Exception:
                mapped = tid
        else:
            mapped = tid
        item = self.tpag_ref(b.get('Texture'))
        atlas = self.tpag_image(item)
        if atlas is None:
            return None
        bx = int(b.get('GMS2OutputBorderX') or 0)
        by = int(b.get('GMS2OutputBorderY') or 0)
        x = bx + (mapped % cols) * (tw + 2 * bx)
        y = by + (mapped // cols) * (th + 2 * by)
        if x + tw > atlas.width or y + th > atlas.height:
            return None
        t = atlas.crop((x, y, x + tw, y + th))
        self._tile[key] = t
        return t


def render_room(src, room, out_path, rootdoc):
    Image = src.Image
    W = int(room.get('Width') or 0)
    H = int(room.get('Height') or 0)
    if W <= 0 or H <= 0:
        return None
    canvas = Image.new('RGBA', (W, H), (0, 0, 0, 0))

    layers = list(room.get('Layers') or [])
    # profondeur decroissante vers l'avant : on dessine du fond vers l'avant
    layers.sort(key=lambda l: -(l.get('LayerDepth') or 0))

    stats = {'tiles': 0, 'assets': 0, 'instances': 0, 'layers': 0,
             'tiles_missing': 0, 'assets_missing': 0, 'instances_missing': 0}

    for l in layers:
        if not l.get('IsVisible', True):
            continue
        lname = str(l.get('LayerName') or '')
        # La couche `invisible` porte la collision du jeu : objbwall,
        # objcolwall, objbslope, objtreecol. GameMaker ne la dessine jamais —
        # leurs sprites sont des rectangles rouges et bleus de debogage qui
        # recouvraient le village entier.
        if lname.casefold() in ('invisible', 'inv'):
            continue
        lt = layer_type(l)
        ox = int(l.get('XOffset') or 0)
        oy = int(l.get('YOffset') or 0)
        stats['layers'] += 1

        # ---- couche de tuiles ----
        if lt == 'Tiles':
            td = resolve(l.get('Data') or l.get('TilesData'), rootdoc) or {}
            bgi, bgname = res_index(td.get('Background'))
            if bgi is None and bgname:
                bgi = src.bg_by_name.get(str(bgname).casefold())
            if bgi is None:
                continue
            b = src.bg[bgi]
            tw = int(b.get('GMS2TileWidth') or 0)
            th = int(b.get('GMS2TileHeight') or 0)
            grid = resolve(td.get('TileData'), rootdoc) or []
            for ry, row in enumerate(grid):
                for rx, raw in enumerate(row):
                    try:
                        raw = int(raw)
                    except Exception:
                        continue
                    tid = raw & TILE_INDEX
                    if tid == 0:
                        continue
                    t = src.tile(bgi, tid)
                    if t is None:
                        stats['tiles_missing'] += 1
                        continue
                    # drapeaux de transformation dans les bits hauts
                    if raw & TILE_ROTATE:
                        t = t.transpose(Image.Transpose.ROTATE_270)
                    if raw & TILE_FLIP_H:
                        t = t.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
                    if raw & TILE_FLIP_V:
                        t = t.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
                    px, py = ox + rx * tw, oy + ry * th
                    if px + t.width <= 0 or py + t.height <= 0 \
                            or px >= W or py >= H:
                        continue
                    canvas.alpha_composite(t, (max(0, px), max(0, py)))
                    stats['tiles'] += 1

        # ---- couche d'assets (sprites poses) ----
        elif lt == 'Assets':
            ad = resolve(l.get('Data') or l.get('AssetsData'), rootdoc) or {}
            items = (resolve(ad.get('LegacyBackgrounds'), rootdoc) or []) \
                + (resolve(ad.get('Sprites'), rootdoc) or [])
            for sp in items:
                sp = resolve(sp, rootdoc) or {}
                si, spname = res_index(sp.get('Sprite'))
                if si is None and spname:
                    si = src.sprite_by_name.get(str(spname).casefold())
                if si is None:
                    stats['assets_missing'] += 1
                    continue
                img = src.sprite_frame(si, int(sp.get('FrameIndex') or 0))
                if img is None:
                    stats['assets_missing'] += 1
                    continue
                sx = float(sp.get('ScaleX') or 1.0)
                sy = float(sp.get('ScaleY') or 1.0)
                if abs(sx) != 1.0 or abs(sy) != 1.0:
                    nw = max(1, int(round(img.width * abs(sx))))
                    nh = max(1, int(round(img.height * abs(sy))))
                    img = img.resize((nw, nh), Image.Resampling.NEAREST)
                if sx < 0:
                    img = img.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
                if sy < 0:
                    img = img.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
                px = ox + int(sp.get('X') or 0)
                py = oy + int(sp.get('Y') or 0)
                if px + img.width <= 0 or py + img.height <= 0 \
                        or px >= W or py >= H:
                    continue
                cut = img
                if px < 0 or py < 0:
                    cut = img.crop((max(0, -px), max(0, -py), img.width, img.height))
                    px, py = max(0, px), max(0, py)
                canvas.alpha_composite(cut, (px, py))
                stats['assets'] += 1

        # ---- couche d'instances (objets) ----
        elif lt == 'Instances':
            idd = resolve(l.get('Data') or l.get('InstancesData'), rootdoc) or {}
            for inst in (resolve(idd.get('Instances'), rootdoc) or []):
                inst = resolve(inst, rootdoc) or {}
                oi, oname = res_index(inst.get('ObjectDefinition'))
                if oi is None and oname:
                    oi = src.obj_by_name.get(str(oname).casefold())
                if oi is None:
                    stats['instances_missing'] += 1
                    continue
                si = src.sprite_of_object(oi)
                if si is None:
                    continue
                img = src.sprite_frame(si, 0)
                if img is None:
                    stats['instances_missing'] += 1
                    continue
                s = src.sprites[si]
                # origine du sprite : GameMaker positionne par ce point
                oxs = int(s.get('OriginX') or 0)
                oys = int(s.get('OriginY') or 0)
                sx = float(inst.get('ScaleX') or 1.0)
                sy = float(inst.get('ScaleY') or 1.0)
                if abs(sx) != 1.0 or abs(sy) != 1.0:
                    nw = max(1, int(round(img.width * abs(sx))))
                    nh = max(1, int(round(img.height * abs(sy))))
                    oxs = int(round(oxs * abs(sx)))
                    oys = int(round(oys * abs(sy)))
                    img = img.resize((nw, nh), Image.Resampling.NEAREST)
                if sx < 0:
                    img = img.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
                if sy < 0:
                    img = img.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
                px = ox + int(inst.get('X') or 0) - oxs
                py = oy + int(inst.get('Y') or 0) - oys
                if px + img.width <= 0 or py + img.height <= 0 \
                        or px >= W or py >= H:
                    continue
                cut = img
                if px < 0 or py < 0:
                    cut = img.crop((max(0, -px), max(0, -py), img.width, img.height))
                    px, py = max(0, px), max(0, py)
                canvas.alpha_composite(cut, (px, py))
                stats['instances'] += 1

    canvas.save(out_path)
    nz = sum(canvas.getchannel('A').histogram()[1:])
    stats['px'] = [W, H]
    stats['fill'] = round(nz / float(W * H), 4)
    return stats


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--inventory', default='/tmp/nnv/inventory')
    ap.add_argument('--textures', default='/tmp/nnv/textures')
    ap.add_argument('--out', default=str(ROOT / 'reports/room-renders'))
    ap.add_argument('--rooms', default='')
    ap.add_argument('--manifest', default=str(ROOT / 'reports/room-renders/manifest.json'))
    ap.add_argument('--start', type=int, default=0)
    ap.add_argument('--limit', type=int, default=0)
    ns = ap.parse_args()

    from PIL import Image
    Image.MAX_IMAGE_PIXELS = None
    os.makedirs(ns.out, exist_ok=True)
    src = Source(ns.inventory, ns.textures)

    want = [x.strip() for x in ns.rooms.split(',') if x.strip()] if ns.rooms else None
    rooms = [r for r in src.rooms if name_of(r.get('Name'))]
    if want:
        rooms = [r for r in rooms if name_of(r.get('Name')) in want]
    rooms = rooms[ns.start:]
    if ns.limit:
        rooms = rooms[:ns.limit]

    man = {}
    if os.path.exists(ns.manifest):
        try:
            man = json.load(open(ns.manifest)).get('rooms', {})
        except Exception:
            man = {}

    for i, r in enumerate(rooms, 1):
        nm = name_of(r.get('Name'))
        out = Path(ns.out) / ('%s.png' % nm)
        try:
            st = render_room(src, r, out, src.rooms)
        except Exception as e:
            man[nm] = {'erreur': str(e)[:140]}
            print('  %3d/%d %-16s ERREUR %s' % (i, len(rooms), nm, str(e)[:70]),
                  flush=True)
            continue
        if st is None:
            man[nm] = {'erreur': 'dimensions nulles'}
            continue
        st['png'] = out.name
        man[nm] = st
        print('  %3d/%d %-16s %5dx%-5d  tuiles %6d  assets %4d  inst %4d  '
              'rempl %5.1f%%'
              % (i, len(rooms), nm, st['px'][0], st['px'][1], st['tiles'],
                 st['assets'], st['instances'], st['fill'] * 100), flush=True)
        open(ns.manifest, 'w').write(json.dumps(
            {'schema': 'nnv-room-renders-v1', 'rooms': man}, indent=1) + '\n')

    ok = [k for k, v in man.items() if 'png' in v]
    print('\nrooms rendues : %d' % len(ok))
    return 0


if __name__ == '__main__':
    sys.exit(main())
