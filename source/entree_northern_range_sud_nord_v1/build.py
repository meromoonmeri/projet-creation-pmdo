"""Entrée Northern Range sud -> nord V1 (ENR1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Entrée de la Chaîne Nordique / Northern Range (Équipe de Secours Rouge), orientée sud -> nord.
Référence canonique `Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Northern Range.png` (456 x 432) :
- plateau rocheux gris craquelé praticable (moyenne RGB (157.5, 157.8, 157.3)) ;
- crêtes rocheuses éclairées gris-olive (moyenne RGB (176.4, 175.6, 146.9)) ;
- parois rocheuses sombres et gouffres (moyenne RGB (77.0, 76.9, 78.0)) ;
- ciel de couchant jaune-orangé doré (moyenne RGB (247.2, 208.2, 96.8)).

Calques fixes (7) :
- 00_sol_complet : sol de pierre grise craquelée complet (plage 96x96 du brut en miroir) ;
- 01_ciel_couchant : ciel de couchant doré à l'horizon nord-ouest et nord-est ;
- 02_plateau_gris : esplanade de pierre grise craquelée praticable (sud -> nord) ;
- 03_pics_roche : aiguilles rocheuses dressées sur les flancs du plateau ;
- 04_falaise_claire : crêtes rocheuses éclairées gris-olive ;
- 05_falaise_sombre : parois sombres et abîmes ;
- 06_col_seuil : goulet et caverne nord entre les deux grands pics.

Animations (2 pistes autonomes, 24 phases x 5 ticks = 120 ticks = 2 s) :
- 07_lueur_couchant : scintillation dorée de l'horizon et du col nord ;
- 08_vent_cime : bourrasques d'altitude et cristaux de givre portés par le vent (`flocons_poses.png` partagée avec EGN1).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Northern Range.png'
REF = R / REF_NAME
OUT = R / 'renders/entree_northern_range_sud_nord_v1'
STAGE = R / '.cache/entree_northern_range_sud_nord_v1/entree_northern_range_sud_nord'
NAMESPACE = 'entree_northern_range_sud_nord'
ASSET = 'enr1_entree_northern_range_sud_nord'
PFX = 'ENR1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS

GEN = [
    {'file': 'decor.png', 'images': [REF_NAME],
     'prompt': 'Wide 4:3 (1200x896) top-down dungeon entrance map for Northern Range (PMD Red Rescue Team), south-to-north cracked medium-grey stone plateau, jagged sunlit grey-olive mountain crags, dark chasm shadows, golden-yellow sunset sky on upper horizon, dark cave pass between twin northern peaks.',
     'essais': 'premier essai retenu (plateau_gris 6.5, roche_claire 31.2, roche_sombre 5.9, ciel_couchant 11.5 ; seuil < 35)'},
    {'file': 'flocons_poses.png', 'images': ['iceroadpmdsky.png'],
     'prompt': 'Sprite sheet on pure magenta (#FF00FF): high-altitude wind gusts and frost crystals (shared from EGN1).',
     'essais': 'planche partagee avec EGN1 (12 poses extraites)'},
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
JM, BM = V1.JM, V1.BM
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group

ESN1 = loadmod('esn1_build', R / 'source/entree_sud_nord_generee_v1/build.py')
V1.reachable = ESN1.reachable


def _run_ground_project(stack, blocked, markers_dict, stage, namespace, asset, pfx, title_str):
    import uuid
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    if stage.exists():
        shutil.rmtree(stage)
    tpl = json.loads((R / 'cliffdaytest.rsground').read_text(encoding='utf-8-sig'))
    o = tpl['Object']; gw, gh = W // 8, H // 8; layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        slug = title.split('_', 1)[-1].split()[0].upper()
        bank = gfx.TileBank(f'{pfx}_{i:02d}_{slug}')
        bank.ids[bytes(256)] = (0, 0); bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y*8:y*8+8, x*8:x*8+8]), x, y)
                fs.append(f if f else {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}})
            if all(f['TexLoc'] == {'X': 0, 'Y': 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs
        layers.append(gfx.layer(f'{i:02d} {title}', gw, gh, cell, ticks)); banks.append(bank)
    layers.append(gfx.layer(f'{len(layers):02d} Vos elements avant-plan (Top)', gw, gh, draw=4))
    for bank in banks:
        bank.write(stage / f'Content/Tile/{bank.name}.tile')
    o.update(Name={'DefaultText': title_str, 'LocalTexts': {}},
             AssetName=asset, Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None,
             ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment=f'PMDO 0.8.12. {title_str} (ref. {REF_NAME}). Collisions de base a verifier. Aucun warp.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': int(p[0]), 'Y': int(p[1]), 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [],
                      'Spawners': [], 'Markers': [mk(k, v) for k, v in markers_dict.items()]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(stage / f'Data/Ground/{asset}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(stage / f'Data/Script/{namespace}/ground/{asset}/init.lua',
             f'-- {asset} : base d edition, aucun warp.\nlocal {asset} = {{}}\nreturn {asset}\n'.encode())
    nodes = {}
    for p in sorted((stage / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (stage / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + namespace)
    (stage / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>{title_str} - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>{title_str} (ref. {REF_NAME}). Pas une aventure jouable.</Description>
  <Namespace>{namespace}</Namespace>
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
    (stage / 'INSTALLER.py').write_text(script)
    if (HERE / 'README_PACK.md').exists():
        shutil.copyfile(HERE / 'README_PACK.md', stage / 'README.md')
    return {b.name: len(b.data) for b in banks}


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


def materials(a):
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a); sat = a.max(-1) - a.min(-1)
    plat = (sat < 12) & (lum > 130) & (lum < 180)
    rclaire = (lum > 140) & (lum < 210) & (sat >= 10) & (sat < 42) & (g >= b)
    rsombre = (lum > 35) & (lum <= 130) & (sat < 45)
    ciel = (r > 220) & (g > 150) & (b < 180) & (r - b > 60)
    return {'plateau_gris': plat, 'roche_claire': rclaire, 'roche_sombre': rsombre, 'ciel_couchant': ciel}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


def sol_patch(a, floor, target):
    best = None; ii = nd.uniform_filter(floor.astype(float), 96)
    for y0 in range(0, SRC[1] - 96, 8):
        for x0 in range(0, SRC[0] - 96, 8):
            if ii[y0 + 48, x0 + 48] < 0.98:
                continue
            p = a[y0:y0 + 96, x0:x0 + 96].reshape(-1, 3)
            sc = float(np.abs(p.mean(0) - target).sum()) + 0.3 * float(p.std(0).mean())
            if best is None or sc < best[0]:
                best = (sc, y0, x0)
    return (best[1], best[1] + 96, best[2], best[2] + 96)


def make_sol(decor, patch):
    y0, y1, x0, x1 = patch; p = decor[y0:y1, x0:x1].astype('uint8')
    row = np.concatenate([p, p[:, ::-1]], 1); tile = np.concatenate([row, row[::-1]], 0)
    return np.tile(tile, (SRC[1] // tile.shape[0] + 1, SRC[0] // tile.shape[1] + 1, 1))[:SRC[1], :SRC[0]]


def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a); sat = a.max(-1) - a.min(-1)
    yy, xx = np.mgrid[:SRC[1], :SRC[0]]
    ciel_couchant = keep_large((r > 200) & (g > 135) & (r - b > 45) & (yy < 420), 500)
    plat_raw = (sat < 14) & (lum > 118) & (lum < 185) & ~ciel_couchant
    corridor = (xx >= 530) & (xx <= 670) & (yy >= 210) & (lum > 85)

    floor_seed = open_(close_(plat_raw | corridor, 3), 2)
    lab, n = nd.label(floor_seed)
    sz = nd.sum(floor_seed, lab, range(1, n + 1))
    main_floor = lab == (int(np.argmax(sz)) + 1)
    filled_floor = nd.binary_fill_holes(main_floor) & ~ciel_couchant

    holes = close_(open_(filled_floor & ~plat_raw & ~corridor, 1), 2)
    holes = nd.binary_fill_holes(holes) & filled_floor & ~corridor
    hl, hn = nd.label(holes); hsz = nd.sum(holes, hl, range(1, hn + 1)) if hn else []
    pics_roche = np.isin(hl, [i + 1 for i, v in enumerate(hsz) if v >= 120])
    plateau_gris = filled_floor & ~pics_roche

    col_box = (~filled_floor) & ~ciel_couchant & (yy >= 5) & (yy <= 280) & (xx >= 480) & (xx <= 720) & (lum < 75)
    col_seuil = nd.binary_fill_holes(close_(col_box, 2)) & ~filled_floor & ~ciel_couchant

    rem = ~filled_floor & ~ciel_couchant & ~col_seuil
    falaise_claire = rem & (lum > 130) & (g >= b)
    falaise_sombre = rem & ~falaise_claire

    masks = dict(
        ciel_couchant=ciel_couchant,
        plateau_gris=plateau_gris,
        pics_roche=pics_roche,
        falaise_claire=falaise_claire,
        falaise_sombre=falaise_sombre,
        col_seuil=col_seuil,
    )
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in masks.items()}
    seg['nb_pics'] = int(sum(v >= 120 for v in hsz))
    return masks, seg


def extract_frost_poses():
    sheet = rgb(RAW / 'flocons_poses.png')
    fg = ~((sheet[..., 0] - sheet[..., 1] > 80) & (sheet[..., 2] - sheet[..., 1] > 80))
    fg = nd.binary_opening(fg, iterations=1)
    poses = []
    for r_idx, (y0, y1, scale) in enumerate([(180, 430, 0.12), (565, 720, 0.16)]):
        sub = fg[y0:y1, :]
        lab, n = nd.label(nd.binary_dilation(sub, iterations=5))
        boxes = []
        for i in range(1, n + 1):
            ys, xs = np.nonzero(lab == i)
            m = sub & (lab == i)
            if m.sum() < 80:
                continue
            boxes.append((xs.min(), ys.min() + y0, xs.max() + 1, ys.max() + 1 + y0))
        boxes.sort(key=lambda b: b[0])
        for idx, (x0, by0, x1, by1) in enumerate(boxes[:6]):
            crop_rgb = sheet[by0:by1, x0:x1].astype('uint8')
            crop_m = fg[by0:by1, x0:x1]
            rgba_full = np.zeros((*crop_m.shape, 4), 'uint8')
            rgba_full[crop_m, :3] = crop_rgb[crop_m]
            rgba_full[crop_m, 3] = 255
            nw = max(6, int(round(crop_m.shape[1] * scale)))
            nh = max(6, int(round(crop_m.shape[0] * scale)))
            pil = Image.fromarray(rgba_full).resize((nw, nh), Image.Resampling.NEAREST)
            arr = np.array(pil)
            am = arr[..., 3] > 128
            arr[~am] = 0; arr[am, 3] = 255
            poses.append({'name': f'cime_r{r_idx}_{idx}', 'rgba': arr, 'bbox_sheet': [int(x0), int(by0), int(x1), int(by1)]})
    return poses


def paste_sprite(canvas, spr, cx, cy):
    sh, sw = spr.shape[:2]
    x0, y0 = int(round(cx)) - sw // 2, int(round(cy)) - sh // 2
    for dy in range(sh):
        yy = y0 + dy
        if not (0 <= yy < H):
            continue
        for dx in range(sw):
            xx = x0 + dx
            if not (0 <= xx < W):
                continue
            if spr[dy, dx, 3] == 255:
                canvas[yy, xx] = spr[dy, dx]


def anim_frames(poses, m768):
    yy, xx = np.mgrid[:H, :W]
    sky_edge = nd.binary_dilation(m768['ciel_couchant'], iterations=3) & ~m768['ciel_couchant']
    lueur_frames, vent_frames = [], []
    gusts = [
        (210, 290, 0), (540, 300, 4), (320, 390, 8), (450, 380, 12),
        (260, 210, 16), (510, 220, 20), (384, 260, 2), (384, 440, 14),
    ]
    for t in range(PHASES):
        lf = np.zeros((H, W, 4), 'uint8')
        vf = np.zeros((H, W, 4), 'uint8')
        wave = np.sin(2 * np.pi * t / PHASES + xx / 28.0)
        m_hi = sky_edge & (wave > 0.1)
        lf[m_hi] = (255, 226, 128, 255)
        for gx, gy, p0 in gusts:
            u = (t - p0) % PHASES
            if u < 14:
                spr = poses[(u // 2) % len(poses)]['rgba']
                paste_sprite(vf, spr, gx + u * 2, gy + (u // 3))
        lueur_frames.append(lf)
        vent_frames.append(vf)
    return lueur_frames, vent_frames


def write_planche(poses, path):
    cols = 6
    rows = (len(poses) + cols - 1) // cols
    cw, ch = 96, 72
    im = Image.new('RGBA', (cols * cw, rows * ch), (24, 26, 34, 255))
    dr = ImageDraw.Draw(im)
    for idx, p in enumerate(poses):
        r_i, c_i = divmod(idx, cols)
        x0, y0 = c_i * cw, r_i * ch
        dr.rectangle([x0 + 2, y0 + 2, x0 + cw - 3, y0 + ch - 3], outline=(110, 115, 130, 255))
        spr = Image.fromarray(p['rgba'])
        im.alpha_composite(spr, (x0 + (cw - spr.width) // 2, y0 + (ch - spr.height) // 2))
    im.save(path)


def build():
    for d in (OUT / 'calques', OUT / 'animation/lueur_couchant', OUT / 'animation/vent_cime', OUT / 'review', STAGE):
        if d.exists():
            shutil.rmtree(d)
        d.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(R / 'source/entree_givre_sud_nord_v1/bruts/flocons_poses.png', RAW / 'flocons_poses.png')

    decor = rgb(RAW / 'decor.png')
    ref = rgb(REF)
    assert decor.shape == (SRC[1], SRC[0], 3), decor.shape
    fid = fidelity(decor, ref)
    for k, v in fid.items():
        assert v['distance'] < 35, (k, v)

    masks, seg = classify(decor)
    patch = sol_patch(decor, masks['plateau_gris'], ref[materials(ref)['plateau_gris']].mean(0))
    sol_full = make_sol(decor, patch)
    _sel_sol = materials(sol_full)['plateau_gris']
    _sol_px = sol_full[_sel_sol] if _sel_sol.sum() > 50 else sol_full.reshape(-1, 3)
    sol_dist = round(float(np.linalg.norm(_sol_px.mean(0) - ref[materials(ref)['plateau_gris']].mean(0))), 2)

    order = ['ciel_couchant', 'plateau_gris', 'pics_roche', 'falaise_claire', 'falaise_sombre', 'col_seuil']
    m768, c768 = down_class(decor, masks, order)
    sol768 = down_full(sol_full)

    raw_layers = {'sol_complet': rgba(sol768, np.ones((H, W), bool))}
    for k in order:
        raw_layers[k] = rgba(c768[k], m768[k])

    pal_groups = {
        'plateau': (['sol_complet', 'plateau_gris'], 32),
        'roche_claire': (['pics_roche', 'falaise_claire'], 64),
        'roche_sombre': (['falaise_sombre', 'col_seuil'], 48),
        'ciel': (['ciel_couchant'], 32),
    }
    layers, pals = {}, {}
    for gname, (keys, n_col) in pal_groups.items():
        ql = quantize_group({k: raw_layers[k] for k in keys}, n_col)
        layers.update(ql)
        cols_u = np.vstack([ql[k][ql[k][..., 3] == 255, :3] for k in keys if (ql[k][..., 3] == 255).any()])
        pals[gname] = {'couleurs': int(len(np.unique(cols_u, axis=0))), 'max': n_col}

    fixed_names = [
        ('sol_complet', f'{PFX}_00_sol_complet.png'),
        ('ciel_couchant', f'{PFX}_01_ciel_couchant.png'),
        ('plateau_gris', f'{PFX}_02_plateau_gris.png'),
        ('pics_roche', f'{PFX}_03_pics_roche.png'),
        ('falaise_claire', f'{PFX}_04_falaise_claire.png'),
        ('falaise_sombre', f'{PFX}_05_falaise_sombre.png'),
        ('col_seuil', f'{PFX}_06_col_seuil.png'),
    ]
    for k, fn in fixed_names:
        Image.fromarray(layers[k]).save(OUT / 'calques' / fn)

    poses = extract_frost_poses()
    write_planche(poses, OUT / 'review' / f'{PFX}_planche_poses.png')
    lueur_frames, vent_frames = anim_frames(poses, m768)
    for t in range(PHASES):
        Image.fromarray(lueur_frames[t]).save(OUT / 'animation/lueur_couchant' / f'{PFX}_07_lueur_couchant_f{t:02d}.png')
        Image.fromarray(vent_frames[t]).save(OUT / 'animation/vent_cime' / f'{PFX}_08_vent_cime_f{t:02d}.png')

    walk = m768['plateau_gris']
    blocked = cell_grid(~walk)
    blocked[18:, 46:50] = False

    entry_px = [384, 560]
    threshold_px = [384, 152]
    for px, py in (entry_px, threshold_px):
        cx, cy = px // 8, py // 8
        blocked[cy:cy + 2, cx:cx + 2] = False

    ok_path, explored = V1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert ok_path, ('Chemin 16x16 coupe', explored)

    def frame_scene(t):
        im = Image.fromarray(layers['sol_complet']).copy()
        for k, _ in fixed_names[1:]:
            im.alpha_composite(Image.fromarray(layers[k]))
        im.alpha_composite(Image.fromarray(lueur_frames[t]))
        im.alpha_composite(Image.fromarray(vent_frames[t]))
        return im

    scenes = [frame_scene(t) for t in range(PHASES)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:], duration=round(TICKS * 1000 / 60), loop=0, lossless=True)

    col_im = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for cy in range(H // 8):
        for cx in range(W // 8):
            if blocked[cy, cx]:
                dr.rectangle([cx * 8, cy * 8, cx * 8 + 7, cy * 8 + 7], fill=(220, 40, 60, 85))
    for (px, py), col in [(entry_px, (255, 220, 40, 255)), (threshold_px, (40, 240, 255, 255))]:
        dr.rectangle([px, py, px + 15, py + 15], outline=col, width=2)
    col_im.alpha_composite(ov); col_im.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    ora_layers = {fn[:-4]: layers[k] for k, fn in fixed_names}
    ora_layers[f'{PFX}_07_lueur_couchant_f00'] = lueur_frames[0]
    ora_layers[f'{PFX}_08_vent_cime_f00'] = vent_frames[0]
    BM.write_ora(OUT / f'{PFX}_entree_northern_range_calques.ora', ora_layers)

    stack = [(f'{i:02d}_{k}', [layers[k]], 1) for i, (k, _) in enumerate(fixed_names)] + [
        ('07_lueur_couchant', lueur_frames, TICKS),
        ('08_vent_cime', vent_frames, TICKS),
    ]
    tiles_info = _run_ground_project(stack, blocked, {'entrance': entry_px, 'donjon_seuil': threshold_px}, STAGE, NAMESPACE, ASSET, PFX, 'Entrée Northern Range (Sud -> Nord)')

    final_fid = {}
    for k, lk in [('plateau_gris', 'plateau_gris'), ('roche_claire', 'falaise_claire'), ('roche_sombre', 'falaise_sombre'), ('ciel_couchant', 'ciel_couchant')]:
        arr = layers[lk]; m = arr[..., 3] == 255
        px = arr[m, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        mr = ref[materials(ref)[k]].mean(0); md = px.mean(0)
        final_fid[k] = {'rip_rgb': [round(float(x), 1) for x in mr], 'calque_rgb': [round(float(x), 1) for x in md],
                        'distance': round(float(np.linalg.norm(mr - md)), 1)}
        assert final_fid[k]['distance'] < 35, (k, final_fid[k])

    layer_order = [f'calques/{fn}' for _, fn in fixed_names] + [
        f'animation/lueur_couchant/{PFX}_07_lueur_couchant_f00..f23.png',
        f'animation/vent_cime/{PFX}_08_vent_cime_f00..f23.png',
    ]
    manifest = {
        'lot': 'source/entree_northern_range_sud_nord_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'cell_px': 8,
        'orientation': 'sud -> nord',
        'method': 'rendu genere reference sur Northern Range (RRT) ; sol_complet = plage 96x96 du brut en miroir ; decoupe multicalque native 8 px',
        'reference_rip': {'file': REF_NAME, 'sha256': sha(REF), 'size': [int(ref.shape[1]), int(ref.shape[0])]},
        'raw_inputs': [
            {**GEN[0], 'file': 'source/entree_northern_range_sud_nord_v1/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC)},
            {**GEN[1], 'file': 'source/entree_northern_range_sud_nord_v1/bruts/flocons_poses.png', 'sha256': sha(RAW / 'flocons_poses.png'), 'size': [1717, 916]},
        ],
        'sol_complet': {'methode': 'plage 96x96 du brut en miroir la plus proche du plateau gris du rip', 'plage_y0_y1_x0_x1': list(patch), 'ecart_au_rip': sol_dist},
        'segmentation': seg,
        'fidelite_rip': {'seuil_max': 35.0, 'brut': fid, 'calques_finaux': final_fid},
        'palettes': pals,
        'layer_order_bottom_to_top': layer_order,
        'animations': {
            'scene_loop_ticks': LOOP_TICKS,
            'tracks': {
                'lueur_couchant': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS},
                'vent_cime': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS, 'poses': len(poses)},
            },
        },
        'access': {
            'entry_px': entry_px,
            'threshold_px': threshold_px,
            'path_16x16_found': bool(ok_path),
            'walkable_16x16_states_explored': int(explored),
            'blocked_cells': int(blocked.sum()),
            'walkable_cells': int((~blocked).sum()),
        },
        'pmdo': {
            'target': '0.8.12.0',
            'namespace': NAMESPACE,
            'asset': ASSET,
            'tiles_per_bank': tiles_info,
            'top_layer_empty': True,
            'runtime_tested': False,
        },
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, indent=2, ensure_ascii=False))
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    shutil.copyfile(HERE / 'README_PACK.md', STAGE / 'README.md')
    print(json.dumps({'entry': entry_px, 'threshold': threshold_px, 'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance'] for k, v in final_fid.items()}, 'tiles': tiles_info}, indent=1))


if __name__ == '__main__':
    build()
