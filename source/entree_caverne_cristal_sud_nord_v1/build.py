"""Entrée Caverne Cristal sud -> nord V1 (EKR1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Référence canonique : capture ROM exacte `D16P11A.png` (600 x 408, *Pokémon Donjon Mystère :
Explorateurs du Ciel*, entrée de la Caverne Cristal, `pret/pmd-sky@c8073235`) + table BPL exacte
`d16p11a.bpl` (Palette 8, 22 poses x 4 ticks = 88 ticks).

Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (capture ROM passée à `images=`) :
- `bruts/decor.png` (1200 x 896) : canyon de sable doré arrivant du sud, falaises de grès stratifié,
  amas de cristaux bleu-ardoise et bouche sombre creusée dans la falaise nord ;
- `bruts/sol_complet.png` (1200 x 896) : sol complet de sable doré généré d'après `D16P11A_sol_crop.png` ;
- `bruts/particules_poses.png` (1152 x 922) : poses générées sur fond `#FF00FF` pur.

10 calques exportés + `Top` vide (`Layer = 4`) dans le Ground PMDO 0.8.12 :
- `00 sol_complet`, `01 sable`, `02 ombres`, `03 graviers`, `04 rochers`, `05 falaises`,
  `06 cristaux` (groupe de palette séparé), `07 profondeur` ;
- `08 lueur_cristal` (22 x 4 ticks : table RVB exacte Palette 8 de `d16p11a.bpl`) ;
- `09 eboulis_poussiere` (22 x 4 ticks : 3 vrais gravillons découpés dans `D16P11A.png` + 4 nuages générés).

Lancer : .venv/bin/python source/entree_caverne_cristal_sud_nord_v1/build.py
"""
from __future__ import annotations

import hashlib, importlib.util, io, json, shutil, uuid, xml.etree.ElementTree as ET, zipfile
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_PNG = HERE / 'references/D16P11A.png'
REF_SOL_CROP = HERE / 'references/D16P11A_sol_crop.png'
REF_BPL_JSON = HERE / 'references/rom_bpl_palettes.json'
OUT = R / 'renders/entree_caverne_cristal_sud_nord_v1'
STAGE = R / '.cache/entree_caverne_cristal_sud_nord_v1/entree_caverne_cristal_sud_nord'

PFX = 'EKR1'
NAMESPACE = 'entree_caverne_cristal_sud_nord'
ASSET = 'ekr1_entree_caverne_cristal'
W, H = 768, 576
SRC = (1200, 896)
N_PHASES = 22
TICKS = 4
SCENE_LOOP = N_PHASES * TICKS  # 88 ticks (1,47 s à 60 i/s — exacte durée Palette 8 de d16p11a.bpl)

STATIC = ['sable', 'ombres', 'graviers', 'rochers', 'falaises', 'cristaux', 'profondeur']
ANIMS = ['lueur_cristal', 'eboulis_poussiere']
PALETTE_GROUPS = {
    'sable': (['sol_complet', 'sable', 'graviers'], 64),
    'roche': (['ombres', 'rochers', 'falaises'], 64),
    'cristal': (['cristaux'], 48),
    'bouche': (['profondeur'], 24),
}


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


V1 = loadmod('ewc1_for_ekr1', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p: Path) -> np.ndarray:
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a: np.ndarray) -> np.ndarray:
    return a[..., :3].astype(float) @ [0.299, 0.587, 0.114]


def materials(arr: np.ndarray) -> dict[str, np.ndarray]:
    """Classifieur matière identique appliqué des deux côtés (capture ROM D16P11A et décor EKR1)."""
    f = arr[..., :3].astype(float)
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    lum = lum_of(f)
    crys = (b - r > -14.0) & (lum < 165.0)
    return {
        'sable': (~crys) & (lum > 184.0),
        'graviers': (~crys) & (lum > 152.0) & (lum <= 184.0),
        'roche_claire': (~crys) & (lum > 112.0) & (lum <= 152.0),
        'roche_sombre': (~crys) & (lum > 62.0) & (lum <= 112.0),
        'cristaux': crys,
    }


def classify_fullres(a: np.ndarray) -> dict[str, np.ndarray]:
    """Segmentation sur le brut 1200 x 896 AVANT réduction vers 768 x 576."""
    f = a.astype(float)
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    lum = lum_of(f)
    hr, wr = lum.shape
    yy, xx = np.mgrid[0:hr, 0:wr]

    # 1. Grande cavité sombre de la bouche nord (mesurée à x=[482..718], y=[0..197] sur le brut)
    mouth_zone = (yy < 220) & (xx >= 460) & (xx <= 740)
    dark_mouth = close_(mouth_zone & (lum < 90.0), 2)
    mouth = nd.binary_fill_holes(keep_large(dark_mouth, 2000))

    # 2. Cristaux bleu-ardoise encastrés dans les parois et autour de la bouche
    crystal = (~mouth) & ((b - r > -14.0) | ((b > g - 3.0) & (b - r > -20.0) & (lum < 165.0)))
    crystal = keep_large(crystal, 45)

    # 3. Sol praticable connecté à l'entrée sud
    walk_cand = (~mouth) & (~crystal) & (lum > 124.0)
    lab_w, _ = nd.label(walk_cand)
    south_seed = np.unique(lab_w[hr - 24:, 420:780])
    south_seed = south_seed[south_seed > 0]
    open_floor = np.isin(lab_w, south_seed)

    # 4. Rochers intérieurs vs falaises périphériques
    solid_rock = (~mouth) & (~crystal) & (~open_floor)
    border = np.zeros_like(solid_rock)
    border[0, :] = border[-1, :] = border[:, 0] = border[:, -1] = True
    border[:260, :] = True
    lab_r, _ = nd.label(solid_rock)
    cliff_ids = np.unique(lab_r[solid_rock & border])
    cliff_ids = cliff_ids[cliff_ids > 0]
    falaises = np.isin(lab_r, cliff_ids)
    rochers = solid_rock & (~falaises)

    return {
        'profondeur': mouth,
        'cristaux': crystal,
        'rochers': rochers,
        'falaises': falaises,
        'ombres': open_floor & (lum <= 152.0),
        'graviers': open_floor & (lum > 152.0) & (lum <= 184.0),
        'sable': open_floor & (lum > 184.0),
    }


def extract_rom_pebbles(ref_a: np.ndarray) -> list[np.ndarray]:
    """Découpe 3 vrais gravillons/éclats minéraux exacts depuis D16P11A.png."""
    specs = [(216, 266, 5, 4), (366, 294, 6, 5), (286, 56, 5, 5)]
    out = []
    for x0, y0, pw, ph in specs:
        patch = ref_a[y0:y0 + ph, x0:x0 + pw].astype(np.uint8)
        sp = np.zeros((ph, pw, 4), np.uint8)
        sp[..., :3] = patch
        sp[..., 3] = 255
        sp[0, 0, 3] = sp[0, -1, 3] = sp[-1, 0, 3] = sp[-1, -1, 3] = 0
        out.append(sp)
    return out


def extract_clean_dust_poses(sheet_a: np.ndarray, sand_ref_mean: np.ndarray) -> list[np.ndarray]:
    """Extrait les 4 nuages de poussière de la ligne basse en purgeant 100 % du magenta/violet."""
    f = sheet_a.astype(float)
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    fringe = ((r - g > 28.0) & (b - g > 20.0)) | (b > g + 6.0)
    valid = ~fringe
    hs, ws = r.shape
    row2 = np.zeros_like(valid)
    row2[hs // 2:, :] = valid[hs // 2:, :]
    row2 = nd.binary_erosion(row2, iterations=1)
    lab, n = nd.label(close_(row2, 2))
    boxes = []
    for i in range(1, n + 1):
        if int((lab == i).sum()) > 1500:
            ys, xs = np.nonzero(lab == i)
            boxes.append((int(xs.mean()), int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1, lab == i))
    boxes.sort(key=lambda t: t[0])

    sizes = [(10, 8), (14, 10), (18, 13), (20, 14)]
    poses = []
    for idx, (_, x0, y0, x1, y1, m) in enumerate(boxes[:4]):
        sub = np.zeros((y1 - y0, x1 - x0, 4), np.uint8)
        mm = m[y0:y1, x0:x1] & valid[y0:y1, x0:x1]
        px = sheet_a[y0:y1, x0:x1][mm].astype(float)
        lum_n = (px @ [0.299, 0.587, 0.114]) / 185.0
        recol = np.clip(sand_ref_mean[None, :] * lum_n[:, None], 65, 244).astype(np.uint8)
        sub[mm, :3] = recol
        sub[mm, 3] = 255
        im = Image.fromarray(sub).resize(sizes[idx], Image.NEAREST)
        arr = np.array(im)
        arr[arr[..., 3] < 128] = 0
        arr[arr[..., 3] >= 128, 3] = 255
        # Dissipation pixel-art DS authentique par tramage binaire (alpha strictement dans {0, 255})
        yy_s, xx_s = np.mgrid[0:arr.shape[0], 0:arr.shape[1]]
        if idx == 2:
            arr[((xx_s + yy_s) % 3) == 0] = 0
        elif idx == 3:
            arr[((xx_s + yy_s) % 2) == 0] = 0
        poses.append(arr)
    return poses


def build_crystal_glow_frames(crys_layer: np.ndarray, ex: dict[str, np.ndarray], pal8: list[list[list[int]]]) -> tuple[list[np.ndarray], np.ndarray]:
    """Applique la table exacte Palette 8 (22 poses x 4 ticks) de d16p11a.bpl aux facettes cristallines."""
    near_mouth = nd.binary_dilation(ex['profondeur'], iterations=22)
    lum = lum_of(crys_layer)
    crys = ex['cristaux']
    thr = float(np.percentile(lum[crys], 52))
    veins = keep_large((crys & near_mouth) | (crys & (lum > thr)), 6)
    vals = lum[veins]
    qs = np.quantile(vals, [0.16, 0.34, 0.52, 0.70, 0.86])
    ranks = np.searchsorted(qs, vals)  # 0..5 sur les 6 entrées actives de Palette 8
    frames = []
    for t in range(N_PHASES):
        row = pal8[t]
        fr = np.zeros((H, W, 4), np.uint8)
        fr[veins, :3] = np.array([row[rk] for rk in ranks], dtype=np.uint8)
        fr[veins, 3] = 255
        frames.append(fr)
    return frames, veins


def build_debris_dust_frames(pebbles: list[np.ndarray], dusts: list[np.ndarray], walk: np.ndarray, cliff: np.ndarray) -> tuple[list[np.ndarray], list[dict]]:
    """Anime 4 fins éboulis (gravillons ROM + nuages de poussière) au pied des parois hors couloir central."""
    events = []
    offsets = [0, 6, 11, 17]
    for i, (tx, ty) in enumerate([(176, 176), (592, 184), (168, 360), (600, 352)]):
        best = None
        for dy in range(-48, 49, 4):
            for dx in range(-48, 49, 4):
                x, y = tx + dx, ty + dy
                if 32 <= x < W - 40 and 80 <= y < H - 72 and walk[y, x] and cliff[max(0, y - 28):y - 6, x].any():
                    best = (x, y)
                    break
            if best:
                break
        if best:
            events.append({'id': i, 'land_px': [int(best[0]), int(best[1])], 'start_y': int(best[1] - 34),
                           'pebble_pose': i % len(pebbles), 'phase_offset': offsets[i]})

    frames = []
    for t in range(N_PHASES):
        canvas = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        for ev in events:
            k = (t - ev['phase_offset']) % N_PHASES
            lx, ly = ev['land_px']
            peb = Image.fromarray(pebbles[ev['pebble_pose']])
            if k < 6:
                py = int(round(ev['start_y'] + (ly - ev['start_y']) * (((k + 1) / 6.0) ** 1.65)))
                canvas.alpha_composite(peb, (lx - peb.width // 2, py - peb.height // 2))
            elif k < 10:
                bk = k - 6
                lift = [5, 8, 5, 1][bk]
                rx = lx + (bk + 1) * (2 if ev['id'] % 2 == 0 else -2)
                d = Image.fromarray(dusts[min(bk, len(dusts) - 1)])
                canvas.alpha_composite(d, (lx - d.width // 2, ly - d.height // 2 + 2))
                canvas.alpha_composite(peb, (rx - peb.width // 2, ly - lift - peb.height // 2))
            elif k < 13:
                d = Image.fromarray(dusts[3])
                canvas.alpha_composite(d, (lx - d.width // 2, ly - d.height // 2 + 2))
        frames.append(np.array(canvas))
    return frames, events


def write_ora(path: Path, layers: dict[str, np.ndarray]) -> None:
    root = ET.Element('image', version='0.0.5', w=str(W), h=str(H), xres='72', yres='72')
    stack = ET.SubElement(root, 'stack')
    comp = Image.new('RGBA', (W, H))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0',
                          visibility='visible', **{'composite-op': 'svg:src-over'})
            b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO(); comp.save(b, format='PNG'); z.writestr('mergedimage.png', b.getvalue())
        th = comp.copy(); th.thumbnail((256, 256))
        b = io.BytesIO(); th.save(b, format='PNG'); z.writestr('Thumbnails/thumbnail.png', b.getvalue())
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def ground_project(stack, blocked: np.ndarray, entry_px: list[int], threshold_px: list[int], gfx, tools) -> dict[str, int]:
    if STAGE.exists():
        shutil.rmtree(STAGE)
    with zipfile.ZipFile(R / 'mod_treasure_expeditions_pmdo_0812.zip') as z:
        tpl = json.loads(z.read('treasure_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground'))
    o = tpl['Object']
    gw, gh = W // 8, H // 8
    layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        bank = gfx.TileBank(f'{PFX}_{i:02d}_{title.split()[0].upper()}')
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y * 8:y * 8 + 8, x * 8:x * 8 + 8]), x, y)
                fs.append(f if f else {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}})
            if all(f['TexLoc'] == {'X': 0, 'Y': 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs

        layers.append(gfx.layer(f'{i:02d} {title}', gw, gh, cell, ticks))
        banks.append(bank)
    layers.append(gfx.layer(f'{len(layers):02d} Vos elements avant-plan (Top)', gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')
    o.update(
        Name={'DefaultText': 'Entree Caverne Cristal - sud vers nord (4:3)', 'LocalTexts': {'fr': 'Entrée Caverne Cristal'}},
        AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
        ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur la capture ROM D16P11A (Caverne Cristal) ; '
                'lueur cristalline Palette 8 exacte de d16p11a.bpl (22 x 4 ticks) + eboulis. Aucun test runtime PMDO.',
    )
    o['obstacles'] = [[{'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                      'Spawners': [], 'Markers': [mk('entrance', entry_px), mk('donjon_seuil', threshold_px)]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : base d edition, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Entree Caverne Cristal sud-nord 4:3 (EKR1) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : arrivee au sud, canyon sablonneux dore, cristaux bleu-ardoise et bouche nord de la Caverne Cristal (ref. ROM D16P11A).</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''')
    script = (R / 'source/pmdo_cote/INSTALLER.py').read_text()
    needle = '            relative = src.relative_to(source)\n'
    assert needle in script
    script = script.replace(needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n")
    (STAGE / 'INSTALLER.py').write_text(script)
    shutil.copyfile(HERE / 'README_PACK.md', STAGE / 'README.md')
    return {b.name: len(b.data) for b in banks}


def build() -> None:
    gfx = loadmod('pmdo_codec_ekr1', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools_ekr1', R / 'source/pmdo_cote/INSTALLER.py')
    esn = loadmod('esn1_ekr1', R / 'source/entree_sud_nord_generee_v1/build.py')

    if OUT.exists():
        shutil.rmtree(OUT)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF_PNG)
    parts = rgb(RAW / 'particules_poses.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    bpl_meta = json.loads(REF_BPL_JSON.read_text())
    pal8 = bpl_meta['animated_palettes']['8']['frames_rgb']

    # 1. Segmentation à pleine résolution avant réduction 768 x 576
    m_full = classify_fullres(a)
    order = ['profondeur', 'cristaux', 'rochers', 'falaises', 'ombres', 'graviers', 'sable']
    ex, cols = down_class(a, m_full, order)

    # Profondeur réelle dans la bouche nord
    mouth = ex['profondeur']
    dist_in = nd.distance_transform_edt(mouth)
    if dist_in.max() > 0:
        darken = np.clip(1.0 - 0.64 * (dist_in / float(dist_in.max())), 0.28, 1.0)
        cols['profondeur'][mouth] = np.clip(cols['profondeur'][mouth].astype(float) * darken[mouth, None], 16, 255).astype(int)

    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])

    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q

    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    # 2. Praticabilité 16x16 depuis l'entrée sud jusqu'au seuil nord
    cand = ex['sable'] | ex['ombres'] | ex['graviers']
    cl, _ = nd.label(cand)
    ys_all = np.nonzero(cand.any(1))[0]
    seed = cl[ys_all.max()][cand[ys_all.max()]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    blocked = cell_grid(~walk)
    walk_grid_px = (~blocked).repeat(8, 0).repeat(8, 1)
    Image.fromarray((walk_grid_px * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    def marker16(cx: int, cy: int) -> list[int]:
        best = None
        for dy in range(-72, 73, 8):
            for dx in range(-72, 73, 8):
                x, y = (cx // 8) * 8 + dx, (cy // 8) * 8 + dy
                if 16 <= x <= W - 32 and 16 <= y <= H - 32:
                    if not blocked[y // 8:y // 8 + 2, x // 8:x // 8 + 2].any():
                        d = dx * dx + dy * dy
                        if best is None or d < best[0]:
                            best = (d, [x, y])
        assert best is not None, (cx, cy)
        return best[1]

    wy, wx = np.nonzero(walk_grid_px)
    ey = int(wy.max()) - 24
    ex_x = int(np.median(wx[wy >= wy.max() - 8]))
    entry_px = marker16(ex_x, ey)

    dys, dxs = np.nonzero(mouth)
    threshold_px = marker16(int(round(dxs.mean())) - 8, int(dys.max()) + 12)
    reach_ok, _ = esn.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach_ok, 'Aucun chemin 16x16 praticable entre entrance et donjon_seuil'

    # 3. Animations : lueur cristalline ROM Palette 8 + éboulis/poussière
    glow_frames, veins_mask = build_crystal_glow_frames(layers['cristaux'], ex, pal8)
    Image.fromarray((veins_mask * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_lueur_cristal.png')

    rlum = lum_of(ref)
    sand_ref_mean = ref[rlum > 185].mean(0)
    pebbles = extract_rom_pebbles(ref)
    dusts = extract_clean_dust_poses(parts, sand_ref_mean)
    debris_frames, debris_events = build_debris_dust_frames(pebbles, dusts, walk_grid_px, ex['falaises'] | ex['cristaux'])

    pose_files = []
    for i, p in enumerate(pebbles):
        fp = OUT / f'poses/{PFX}_gravillon_{i:02d}.png'
        Image.fromarray(p).save(fp); pose_files.append(fp)
    for i, p in enumerate(dusts):
        fp = OUT / f'poses/{PFX}_poussiere_{i:02d}.png'
        Image.fromarray(p).save(fp); pose_files.append(fp)

    sw = max(sum(Image.open(p).width * 4 + 12 for p in pose_files) + 12, 220)
    sheet = Image.new('RGBA', (sw, 112), (42, 36, 32, 255))
    sx_p = 8
    for p in pose_files:
        im_p = Image.open(p).convert('RGBA')
        up = im_p.resize((im_p.width * 4, im_p.height * 4), Image.NEAREST)
        sheet.alpha_composite(up, (sx_p, (112 - up.height) // 2))
        sx_p += up.width + 12
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    # 4. Écriture des 10 calques + scène recomposée + ORA + Ground PMDO 0.8.12
    anim_map = {'lueur_cristal': glow_frames, 'eboulis_poussiere': debris_frames}
    order_names = ['sol_complet'] + STATIC + ANIMS
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        if nm in anim_map:
            frs = anim_map[nm]
            for t, fr in enumerate(frs):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            layer_list.append({'id': nm, 'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frs), 'ticks': TICKS})
            stack_named.append((nm, frs, TICKS))
        else:
            fr = layers[nm]
            Image.fromarray(fr).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'id': nm, 'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
            stack_named.append((nm, [fr], 60))

    scenes = []
    for t in range(N_PHASES):
        im = Image.new('RGBA', (W, H))
        for _, frs, tk in stack_named:
            im.alpha_composite(Image.fromarray(frs[t if len(frs) > 1 else 0]))
        scenes.append(im)
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(TICKS * 1000 / 60), loop=0, lossless=True)

    ov = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x * 8, y * 8, x * 8 + 7, y * 8 + 7], fill=(220, 45, 45, 95))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    ov.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    write_ora(OUT / f'{PFX}_entree_caverne_cristal_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project(
        [(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk) for t, fr, tk in stack_named],
        blocked, entry_px, threshold_px, gfx, tools,
    )

    # 5. Fidélité chromatique : MÊME classifieur matière des deux côtés (capture ROM D16P11A et décor) + calques finaux
    dist_rgb = lambda x, y: round(float(np.linalg.norm(np.asarray(x, float) - np.asarray(y, float))), 2)
    m_ref, m_raw = materials(ref), materials(a)
    raw_fid = {}
    for mk_name in m_ref:
        mr = ref[m_ref[mk_name]].mean(0)
        md = a[m_raw[mk_name]].mean(0)
        raw_fid[mk_name] = {
            'ref_rgb': [round(float(v), 1) for v in mr],
            'mean_rgb': [round(float(v), 1) for v in md],
            'distance': dist_rgb(md, mr),
        }

    # Paroi rocheuse globale du rip (toute zone hors sable clair, lum 65..184) pour comparer falaises/rochers complets
    ref_wall_mean = ref[(rlum > 65.0) & (rlum <= 184.0)].mean(0)
    ref_layer_target = {
        'sable': ref[m_ref['sable']].mean(0),
        'graviers': ref[m_ref['graviers']].mean(0),
        'ombres': ref[m_ref['roche_claire']].mean(0),
        'rochers': ref_wall_mean,
        'falaises': ref_wall_mean,
        'cristaux': np.mean(pal8[5], axis=0),
        'profondeur': np.array([39.4, 52.0, 38.0]),
    }
    final_fid = {}
    for k in STATIC:
        fin_lay = layers[k]
        fin_px = fin_lay[fin_lay[..., 3] > 0][:, :3].mean(0)
        final_fid[k] = {
            'mean_rgb': [round(float(v), 1) for v in fin_px],
            'ref_rgb': [round(float(v), 1) for v in ref_layer_target[k]],
            'distance_rip': dist_rgb(fin_px, ref_layer_target[k]),
        }
    sol_fid = dist_rgb(layers['sol_complet'][..., :3].reshape(-1, 3).mean(0), ref[m_ref['sable']].mean(0))

    manifest = {
        'id': 'entree_caverne_cristal_sud_nord_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'scene_loop_ticks': SCENE_LOOP,
        'canonical_biome': {
            'rom_code': 'D16P11A',
            'dungeon_fr': 'Caverne Cristal (entrée)',
            'dungeon_en': 'Crystal Cave Entrance',
            'pmd_sky_commit': bpl_meta['pmd_sky_commit'],
            'reference_png': REF_PNG.relative_to(R).as_posix(),
            'reference_sha256': sha(REF_PNG),
            'rom_bpl_palette': {'palette_index': 8, 'frames': 22, 'duration_per_frame_ticks': 4, 'loop_ticks': 88},
        },
        'nature': 'Décor généré référencé sur la capture ROM D16P11A (pas des tuiles natives certifiées) ; lueur cristalline pilotée par la table exacte Palette 8 de d16p11a.bpl, 3 gravillons découpés dans D16P11A.png + 4 nuages générés.',
        'art_approved': False,
        'raw_inputs': [
            {'file': (RAW / 'decor.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'decor.png').size),
             'sha256': sha(RAW / 'decor.png'), 'images': [REF_PNG.relative_to(R).as_posix()]},
            {'file': (RAW / 'sol_complet.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'sol_complet.png').size),
             'sha256': sha(RAW / 'sol_complet.png'), 'images': [REF_SOL_CROP.relative_to(R).as_posix()],
             'crop_note': 'Découpe D16P11A.png (200,240,400,390) x2 plus proche voisin.'},
            {'file': (RAW / 'particules_poses.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'particules_poses.png').size),
             'sha256': sha(RAW / 'particules_poses.png'), 'images': ['source/fin_caverne_cristal_v1/references/D16P31A.png']},
        ],
        'layers': layer_list,
        'debris_events': debris_events,
        'access': {
            'entry_px': entry_px,
            'threshold_px': threshold_px,
            'walkable_cells': int((~blocked).sum()),
            'blocked_cells': int(blocked.sum()),
            'path_found_16x16': bool(reach_ok),
        },
        'fidelite_rip': {'seuil_max': 35.0, 'brut': raw_fid, 'calques_finaux': final_fid, 'sol_complet': sol_fid},
        'pmdo': {'target': '0.8.12', 'runtime_tested': False, 'asset_name': ASSET, 'namespace': NAMESPACE,
                 'tex_size': 1, 'tiles_per_bank': counts},
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(f'OK {PFX}: walkable={int((~blocked).sum())}, entry={entry_px}, seuil={threshold_px}, sol_dist={sol_fid}')


if __name__ == '__main__':
    build()
