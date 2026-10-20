"""Entrée Bassin Chauffant sud -> nord V1 (EBH1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Entrée de la Source Thermale / Bassin Chauffant (Explorateurs du Ciel), orientée sud -> nord.
Référence canonique `bassinchauffantpmdsky.png` (504 x 408) :
- eau thermale jaune-olive dorée (moyenne RGB (193.8, 166.7, 65.8)) ;
- chemin de terre sablonneuse ocre (moyenne RGB (231.1, 182.2, 125.4)) ;
- rochers bruns et fumerolles volcaniques (moyenne RGB (175.6, 140.1, 80.0)) ;
- herbe et arbres verts de la lisière (moyenne RGB (75.4, 123.8, 42.7)).

Calques fixes (8) :
- 00_sol_complet : sol de terre sablonneuse ocre complet (plage 96x96 du brut en miroir) ;
- 01_eau_thermale : deux bassins d'eau minérale chaude jaune-olive ;
- 02_chemin_sable : terrasse et allée sablonneuse ocre praticable ;
- 03_dalles_pierre : chaussée centrale pavée et grand escalier nord praticables ;
- 04_rochers_rive : couronnes de rochers bruns bordant les bassins et barrières de bois ;
- 05_fumerolles : 6 cônes de fumerolles volcaniques et paroi rocheuse nord ;
- 06_herbe_arbres : herbe et arbres verts encadrant la source + ciel d'horizon ;
- 07_grotte_seuil : bouche de la caverne volcanique au sommet de l'escalier nord.

Animations (2 pistes autonomes, 24 phases x 5 ticks = 120 ticks = 2 s) :
- 08_onde_thermale : ondulations minérales dorées à l'intérieur des deux bassins (sans liseré blanc sur la rive) ;
- 09_vapeur_fumerolles : panaches de vapeur montant des fumerolles et des bassins (`vapeur_poses.png` partagée avec FVS1).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'bassinchauffantpmdsky.png'
REF = R / REF_NAME
OUT = R / 'renders/entree_bassin_chauffant_sud_nord_v1'
STAGE = R / '.cache/entree_bassin_chauffant_sud_nord_v1/entree_bassin_chauffant_sud_nord'
NAMESPACE = 'entree_bassin_chauffant_sud_nord'
ASSET = 'ebh1_entree_bassin_chauffant_sud_nord'
PFX = 'EBH1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS

GEN = [
    {'file': 'decor.png', 'images': [REF_NAME],
     'prompt': 'Wide 4:3 (1200x896) top-down dungeon entrance map for Hot Spring / Bassin Chauffant (PMD Explorers of Sky), south sandy-ochre path with stepping stones and wooden fence posts, central stone causeway between two warm golden-olive mineral hot spring pools edged with tan boulders and 4 steaming fumarole mounds, stone steps rising to a volcanic cavern mouth at north.',
     'essais': 'premier essai retenu (eau_thermale 22.2, chemin_sable 12.0, roche_brune 14.3, herbe_arbres 7.0 ; seuil < 35)'},
    {'file': 'vapeur_poses.png', 'images': ['Steam_Cave_Peak_TDS.png'],
     'prompt': 'Sprite sheet on pure magenta (#FF00FF): rising steam plumes (shared from FVS1).',
     'essais': 'planche partagee avec FVS1 (4 poses de vapeur extraites)'},
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
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    eau = (r > 155) & (g > 135) & (b < 115) & (r - g < 38) & (r - b > 60) & (lum < 195)
    sable = (r > 205) & (g > 165) & (b > 95) & (r - b > 70) & ~eau
    roche = (r > 130) & (r < 215) & (g > 90) & (g < 175) & (r - g > 22) & (g - b > 15) & ~sable & ~eau
    herbe = (g > r + 15) & (g > b + 25) & (lum > 45)
    return {'eau_thermale': eau, 'chemin_sable': sable, 'roche_brune': roche, 'herbe_arbres': herbe}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


def sol_patch(a, floor, target):
    best = None; ii = nd.uniform_filter(floor.astype(float), 96)
    mat_c = materials(a)['chemin_sable']
    for y0 in range(0, SRC[1] - 96, 8):
        for x0 in range(0, SRC[0] - 96, 8):
            if ii[y0 + 48, x0 + 48] < 0.55:
                continue
            sub_m = mat_c[y0:y0 + 96, x0:x0 + 96]
            if sub_m.sum() < 500:
                continue
            p = a[y0:y0 + 96, x0:x0 + 96][sub_m]
            sc = float(np.linalg.norm(p.mean(0) - target))
            if best is None or sc < best[0]:
                best = (sc, y0, x0)
    if best is None:
        return (416, 512, 624, 720)
    return (best[1], best[1] + 96, best[2], best[2] + 96)


def make_sol(decor, patch):
    y0, y1, x0, x1 = patch; p = decor[y0:y1, x0:x1].astype('uint8')
    row = np.concatenate([p, p[:, ::-1]], 1); tile = np.concatenate([row, row[::-1]], 0)
    return np.tile(tile, (SRC[1] // tile.shape[0] + 1, SRC[0] // tile.shape[1] + 1, 1))[:SRC[1], :SRC[0]]


def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    yy, xx = np.mgrid[:SRC[1], :SRC[0]]

    # Deux bassins d'eau thermale (y in 440..695, gauche x in 240..530, droite x in 670..960)
    eau_box = (yy >= 440) & (yy <= 695) & (((xx >= 240) & (xx <= 530)) | ((xx >= 670) & (xx <= 960)))
    eau_raw = eau_box & (r > 145) & (g > 125) & (b < 95) & (r - g < 36) & (g - b > 45)
    eau_thermale = keep_large(nd.binary_fill_holes(close_(eau_raw, 2)), 5000)

    # Bouche de la grotte nord (y in 120..265, x in 515..685)
    grotte_box = (yy >= 120) & (yy <= 265) & (xx >= 515) & (xx <= 685) & (lum < 85)
    grotte_seuil = nd.binary_fill_holes(close_(grotte_box, 2))

    # Couloir central pavé (escalier nord + chaussée centrale + pont sud)
    dalles_pierre = (xx >= 515) & (xx <= 685) & (yy >= 255) & (yy <= 710) & ~eau_thermale & ~grotte_seuil
    sable_raw = (r > 205) & (g > 158) & (b > 95) & (r - b > 65) & ~eau_thermale & ~grotte_seuil & ~dalles_pierre & (yy >= 340)
    south_path = (xx >= 530) & (xx <= 670) & (yy >= 710) & (lum > 110)
    chemin_sable = open_(close_(sable_raw | south_path, 2), 1) & ~eau_thermale & ~dalles_pierre & ~grotte_seuil

    rem = ~eau_thermale & ~grotte_seuil & ~dalles_pierre & ~chemin_sable
    herbe_arbres = rem & ((g > r + 10) & (g > b + 15) | (b > r + 20))
    rem_rock = rem & ~herbe_arbres

    # Couronne de rochers autour des bassins vs fumerolles et falaise nord
    near_pool = nd.binary_dilation(eau_thermale, iterations=34) & (yy >= 400) & (xx >= 200) & (xx <= 1000)
    rochers_rive = rem_rock & near_pool
    fumerolles = rem_rock & ~rochers_rive

    masks = dict(
        eau_thermale=eau_thermale,
        chemin_sable=chemin_sable,
        dalles_pierre=dalles_pierre,
        rochers_rive=rochers_rive,
        fumerolles=fumerolles,
        herbe_arbres=herbe_arbres,
        grotte_seuil=grotte_seuil,
    )
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in masks.items()}
    return masks, seg


def extract_steam_poses():
    sheet = rgb(RAW / 'vapeur_poses.png')
    fg = ~((sheet[..., 0] - sheet[..., 1] > 80) & (sheet[..., 2] - sheet[..., 1] > 80))
    fg = nd.binary_opening(fg, iterations=1)
    poses = []
    sub = fg[5:265, :]
    lab, n = nd.label(nd.binary_dilation(sub, iterations=5))
    boxes = []
    for i in range(1, n + 1):
        ys, xs = np.nonzero(lab == i)
        m = sub & (lab == i)
        if m.sum() < 500:
            continue
        boxes.append((xs.min(), ys.min() + 5, xs.max() + 1, ys.max() + 6))
    boxes.sort(key=lambda b: b[0])
    for idx, (x0, by0, x1, by1) in enumerate(boxes):
        crop_rgb = sheet[by0:by1, x0:x1].astype('uint8')
        crop_m = fg[by0:by1, x0:x1]
        rgba_full = np.zeros((*crop_m.shape, 4), 'uint8')
        rgba_full[crop_m, :3] = crop_rgb[crop_m]
        rgba_full[crop_m, 3] = 255
        for sc_idx, scale in enumerate([0.16, 0.22]):
            nw = max(8, int(round(crop_m.shape[1] * scale)))
            nh = max(8, int(round(crop_m.shape[0] * scale)))
            pil = Image.fromarray(rgba_full).resize((nw, nh), Image.Resampling.NEAREST)
            arr = np.array(pil)
            am = arr[..., 3] > 128
            arr[~am] = 0; arr[am, 3] = 255
            poses.append({'name': f'vapeur_{idx}_s{sc_idx}', 'rgba': arr, 'bbox_sheet': [int(x0), int(by0), int(x1), int(by1)]})
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
    inner_water = nd.binary_erosion(m768['eau_thermale'], iterations=5)
    onde_frames, vapeur_frames = [], []
    vents = [
        (125, 255, 0), (640, 255, 6), (125, 395, 12), (640, 395, 18),
        (280, 145, 3), (490, 145, 15), (245, 355, 9), (520, 355, 21),
    ]
    for t in range(PHASES):
        of = np.zeros((H, W, 4), 'uint8')
        vf = np.zeros((H, W, 4), 'uint8')
        wave = np.sin(2 * np.pi * t / PHASES + xx / 14.0 + yy / 14.0)
        m_hi = inner_water & (wave > 0.78) & (((xx + yy) % 2) == 0)
        of[m_hi] = (205, 182, 85, 255)
        for vx, vy, p0 in vents:
            u = (t - p0) % PHASES
            if u < 16:
                spr = poses[(u // 2) % len(poses)]['rgba']
                paste_sprite(vf, spr, vx, vy - u)
        onde_frames.append(of)
        vapeur_frames.append(vf)
    return onde_frames, vapeur_frames


def write_planche(poses, path):
    cols = 4
    rows = (len(poses) + cols - 1) // cols
    cw, ch = 96, 72
    im = Image.new('RGBA', (cols * cw, rows * ch), (34, 30, 24, 255))
    dr = ImageDraw.Draw(im)
    for idx, p in enumerate(poses):
        r_i, c_i = divmod(idx, cols)
        x0, y0 = c_i * cw, r_i * ch
        dr.rectangle([x0 + 2, y0 + 2, x0 + cw - 3, y0 + ch - 3], outline=(140, 120, 90, 255))
        spr = Image.fromarray(p['rgba'])
        im.alpha_composite(spr, (x0 + (cw - spr.width) // 2, y0 + (ch - spr.height) // 2))
    im.save(path)


def build():
    for d in (OUT / 'calques', OUT / 'animation/onde_thermale', OUT / 'animation/vapeur_fumerolles', OUT / 'review', STAGE):
        if d.exists():
            shutil.rmtree(d)
        d.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(R / 'source/fin_vapeur_sommet_v1/bruts/vapeur_poses.png', RAW / 'vapeur_poses.png')

    decor = rgb(RAW / 'decor.png')
    ref = rgb(REF)
    assert decor.shape == (SRC[1], SRC[0], 3), decor.shape
    fid = fidelity(decor, ref)
    for k, v in fid.items():
        assert v['distance'] < 35, (k, v)

    masks, seg = classify(decor)
    patch = sol_patch(decor, masks['chemin_sable'], ref[materials(ref)['chemin_sable']].mean(0))
    sol_full = make_sol(decor, patch)
    _sel_sol = materials(sol_full)['chemin_sable']
    _sol_px = sol_full[_sel_sol] if _sel_sol.sum() > 50 else sol_full.reshape(-1, 3)
    sol_dist = round(float(np.linalg.norm(_sol_px.mean(0) - ref[materials(ref)['chemin_sable']].mean(0))), 2)

    order = ['eau_thermale', 'chemin_sable', 'dalles_pierre', 'rochers_rive', 'fumerolles', 'herbe_arbres', 'grotte_seuil']
    m768, c768 = down_class(decor, masks, order)
    sol768 = down_full(sol_full)

    raw_layers = {'sol_complet': rgba(sol768, np.ones((H, W), bool))}
    for k in order:
        raw_layers[k] = rgba(c768[k], m768[k])

    pal_groups = {
        'sable': (['sol_complet', 'chemin_sable'], 48),
        'eau': (['eau_thermale'], 32),
        'roche': (['dalles_pierre', 'rochers_rive', 'fumerolles', 'grotte_seuil'], 64),
        'foret': (['herbe_arbres'], 64),
    }
    layers, pals = {}, {}
    for gname, (keys, n_col) in pal_groups.items():
        ql = quantize_group({k: raw_layers[k] for k in keys}, n_col)
        layers.update(ql)
        cols_u = np.vstack([ql[k][ql[k][..., 3] == 255, :3] for k in keys if (ql[k][..., 3] == 255).any()])
        pals[gname] = {'couleurs': int(len(np.unique(cols_u, axis=0))), 'max': n_col}

    fixed_names = [
        ('sol_complet', f'{PFX}_00_sol_complet.png'),
        ('eau_thermale', f'{PFX}_01_eau_thermale.png'),
        ('chemin_sable', f'{PFX}_02_chemin_sable.png'),
        ('dalles_pierre', f'{PFX}_03_dalles_pierre.png'),
        ('rochers_rive', f'{PFX}_04_rochers_rive.png'),
        ('fumerolles', f'{PFX}_05_fumerolles.png'),
        ('herbe_arbres', f'{PFX}_06_herbe_arbres.png'),
        ('grotte_seuil', f'{PFX}_07_grotte_seuil.png'),
    ]
    for k, fn in fixed_names:
        Image.fromarray(layers[k]).save(OUT / 'calques' / fn)

    poses = extract_steam_poses()
    write_planche(poses, OUT / 'review' / f'{PFX}_planche_poses.png')
    onde_frames, vapeur_frames = anim_frames(poses, m768)
    for t in range(PHASES):
        Image.fromarray(onde_frames[t]).save(OUT / 'animation/onde_thermale' / f'{PFX}_08_onde_thermale_f{t:02d}.png')
        Image.fromarray(vapeur_frames[t]).save(OUT / 'animation/vapeur_fumerolles' / f'{PFX}_09_vapeur_fumerolles_f{t:02d}.png')

    walk = m768['chemin_sable'] | m768['dalles_pierre']
    blocked = cell_grid(~walk)
    blocked[20:, 45:51] = False

    entry_px = [384, 560]
    threshold_px = [384, 168]
    for px, py in (entry_px, threshold_px):
        cx, cy = px // 8, py // 8
        blocked[cy:cy + 2, cx:cx + 2] = False

    ok_path, explored = V1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert ok_path, ('Chemin 16x16 coupe', explored)

    def frame_scene(t):
        im = Image.fromarray(layers['sol_complet']).copy()
        for k, _ in fixed_names[1:]:
            im.alpha_composite(Image.fromarray(layers[k]))
        im.alpha_composite(Image.fromarray(onde_frames[t]))
        im.alpha_composite(Image.fromarray(vapeur_frames[t]))
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
    ora_layers[f'{PFX}_08_onde_thermale_f00'] = onde_frames[0]
    ora_layers[f'{PFX}_09_vapeur_fumerolles_f00'] = vapeur_frames[0]
    BM.write_ora(OUT / f'{PFX}_entree_bassin_chauffant_calques.ora', ora_layers)

    stack = [(f'{i:02d}_{k}', [layers[k]], 1) for i, (k, _) in enumerate(fixed_names)] + [
        ('08_onde_thermale', onde_frames, TICKS),
        ('09_vapeur_fumerolles', vapeur_frames, TICKS),
    ]
    tiles_info = _run_ground_project(stack, blocked, {'entrance': entry_px, 'donjon_seuil': threshold_px}, STAGE, NAMESPACE, ASSET, PFX, 'Entrée Bassin Chauffant (Sud -> Nord)')

    final_fid = {}
    for k, lk in [('eau_thermale', 'eau_thermale'), ('chemin_sable', 'chemin_sable'), ('roche_brune', 'rochers_rive'), ('herbe_arbres', 'herbe_arbres')]:
        arr = layers[lk]; m = arr[..., 3] == 255
        px = arr[m, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        mr = ref[materials(ref)[k]].mean(0); md = px.mean(0)
        final_fid[k] = {'rip_rgb': [round(float(x), 1) for x in mr], 'calque_rgb': [round(float(x), 1) for x in md],
                        'distance': round(float(np.linalg.norm(mr - md)), 1)}
        assert final_fid[k]['distance'] < 35, (k, final_fid[k])

    layer_order = [f'calques/{fn}' for _, fn in fixed_names] + [
        f'animation/onde_thermale/{PFX}_08_onde_thermale_f00..f23.png',
        f'animation/vapeur_fumerolles/{PFX}_09_vapeur_fumerolles_f00..f23.png',
    ]
    manifest = {
        'lot': 'source/entree_bassin_chauffant_sud_nord_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'cell_px': 8,
        'orientation': 'sud -> nord',
        'method': 'rendu genere reference sur bassinchauffantpmdsky.png ; sol_complet = plage 96x96 du brut en miroir ; decoupe multicalque native 8 px',
        'reference_rip': {'file': REF_NAME, 'sha256': sha(REF), 'size': [int(ref.shape[1]), int(ref.shape[0])]},
        'raw_inputs': [
            {**GEN[0], 'file': 'source/entree_bassin_chauffant_sud_nord_v1/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC)},
            {**GEN[1], 'file': 'source/entree_bassin_chauffant_sud_nord_v1/bruts/vapeur_poses.png', 'sha256': sha(RAW / 'vapeur_poses.png'), 'size': [1047, 1008]},
        ],
        'sol_complet': {'methode': 'plage 96x96 du brut en miroir la plus proche du chemin sable du rip', 'plage_y0_y1_x0_x1': list(patch), 'ecart_au_rip': sol_dist},
        'segmentation': seg,
        'fidelite_rip': {'seuil_max': 35.0, 'brut': fid, 'calques_finaux': final_fid},
        'palettes': pals,
        'layer_order_bottom_to_top': layer_order,
        'animations': {
            'scene_loop_ticks': LOOP_TICKS,
            'tracks': {
                'onde_thermale': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS},
                'vapeur_fumerolles': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS, 'poses': len(poses)},
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
