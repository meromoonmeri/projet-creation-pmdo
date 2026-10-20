"""Entrée Mt. Horn sud -> nord V1 (EMH1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Entrée du Mont Cornu / Mt. Horn (Explorateurs du Ciel), orientée sud -> nord.
Référence canonique `Mt_Horn_entrance_Sky.png` (432 x 360) :
- piste rocheuse ocre-orangé craquelée (moyenne RGB (234.8, 179.2, 110.7)) ;
- falaises tabulaires ocre-jaune en strates (moyenne RGB (189.5, 146.3, 76.6)) ;
- parois et anfractuosités brunes ombrées (moyenne RGB (112.8, 89.0, 47.5)) ;
- ciel bleu et pics enneigés cyan à l'horizon (moyenne RGB (115.3, 196.9, 247.6)) ;
- bouche de caverne sombre creusée dans la paroi nord.

Calques fixes (8) :
- 00_sol_complet : sol de piste craquelée complet (plage 96x96 du brut en miroir, la plus proche du rip) ;
- 01_ciel_montagnes : ciel bleu et cimes enneigées cyan visibles dans les échancrures ouest et est ;
- 02_chemin_sable : piste rocheuse ocre-orangé praticable (sud -> nord) ;
- 03_cailloux : petits cailloux posés sur le plateau ;
- 04_rochers : 6 amas rocheux isolés sur les flancs du plateau ;
- 05_falaise_ocre : strates tabulaires ocre-jaune des falaises ;
- 06_falaise_sombre : parois brunes ombrées et crevasses ;
- 07_grotte_seuil : bouche de la caverne nord et marches d'accès.

Animations (2 pistes autonomes, 24 phases x 5 ticks = 120 ticks = 2 s) :
- 08_vent_sable : tourbillons de poussière et bourrasques (planche `touffes_vent_poses.png` partagée avec EBN1) ;
- 09_eboulis_ocre : gravillons ocre se détachant des corniches rocheuses et rebondissant au pied des falaises.
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'Mt_Horn_entrance_Sky.png'
REF = R / REF_NAME
OUT = R / 'renders/entree_mt_horn_sud_nord_v1'
STAGE = R / '.cache/entree_mt_horn_sud_nord_v1/entree_mt_horn_sud_nord'
NAMESPACE = 'entree_mt_horn_sud_nord'
ASSET = 'emh1_entree_mt_horn_sud_nord'
PFX = 'EMH1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS

GEN = [
    {'file': 'decor.png', 'images': [REF_NAME],
     'prompt': 'Wide 4:3 (1200x896) top-down dungeon entrance map for Mt. Horn (PMD Explorers of Sky), south-to-north cracked orange-tan trail, layered ochre-yellow mesa cliffs, freestanding boulders, distant blue sky and snowy cyan peaks on upper sides, dark cave mouth in the northern cliff.',
     'essais': 'premier essai retenu (chemin_sable 10.6, roche_ocre 8.4, roche_sombre 1.6, ciel_montagnes 1.6 ; seuil < 35)'},
    {'file': 'touffes_vent_poses.png', 'images': ['Mt_Bristle_entrance_TD.png'],
     'prompt': 'Sprite sheet on pure magenta (#FF00FF): windblown dust wisps and scrub tufts (shared from EBN1).',
     'essais': 'planche partagee avec EBN1 (18 poses extraites)'},
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
    sable = (r > 205) & (g > 155) & (b > 95) & (r - g > 25) & (g - b > 35)
    ocre = (r > 145) & (g > 100) & (r - b > 65) & ~sable
    sombre = (r <= 145) & (lum > 35) & (r > b + 20)
    ciel = (b > r + 20) & (b > 140)
    return {'chemin_sable': sable, 'roche_ocre': ocre, 'roche_sombre': sombre, 'ciel_montagnes': ciel}


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
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    yy, xx = np.mgrid[:SRC[1], :SRC[0]]
    ciel_montagnes = keep_large((b > r + 10) & (b > 130) & (yy < 450), 500)
    sable_raw = (r > 205) & (g > 148) & (b > 70) & (r - g > 30) & (g - b > 32) & ~ciel_montagnes
    # Couloir central sud -> nord garanti praticable jusqu'au pied de la grotte (y = 260..895)
    corridor = (xx >= 520) & (xx <= 680) & (yy >= 260) & (lum > 95)
    floor_seed = open_(close_(sable_raw | corridor, 3), 2)
    lab, n = nd.label(floor_seed)
    sz = nd.sum(floor_seed, lab, range(1, n + 1))
    main_floor = lab == (int(np.argmax(sz)) + 1)
    filled_floor = nd.binary_fill_holes(main_floor) & ~ciel_montagnes

    # Îlots rocheux posés sur le plateau
    holes = close_(open_(filled_floor & ~sable_raw & ~corridor, 1), 2)
    holes = nd.binary_fill_holes(holes) & filled_floor & ~corridor
    hl, hn = nd.label(holes); hsz = nd.sum(holes, hl, range(1, hn + 1)) if hn else []
    rochers = np.isin(hl, [i + 1 for i, v in enumerate(hsz) if v >= 350])
    cailloux = np.isin(hl, [i + 1 for i, v in enumerate(hsz) if 25 <= v < 350])
    chemin_sable = filled_floor & ~rochers & ~cailloux

    # Bouche de caverne nord et marches
    grotte_box = (~filled_floor) & ~ciel_montagnes & (yy >= 10) & (yy <= 315) & (xx >= 480) & (xx <= 720) & ((lum < 95) | (yy >= 210))
    grotte_seuil = nd.binary_fill_holes(close_(grotte_box, 2)) & ~filled_floor & ~ciel_montagnes

    rem = ~filled_floor & ~ciel_montagnes & ~grotte_seuil
    falaise_ocre = rem & (r > 145) & (g > 100)
    falaise_sombre = rem & ~falaise_ocre

    masks = dict(
        ciel_montagnes=ciel_montagnes,
        chemin_sable=chemin_sable,
        cailloux=cailloux,
        rochers=rochers,
        falaise_ocre=falaise_ocre,
        falaise_sombre=falaise_sombre,
        grotte_seuil=grotte_seuil,
    )
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in masks.items()}
    seg['nb_rochers'] = int(sum(v >= 350 for v in hsz))
    seg['nb_cailloux'] = int(sum(25 <= v < 350 for v in hsz))
    return masks, seg


def extract_wind_poses():
    sheet = rgb(RAW / 'touffes_vent_poses.png')
    fg = ~((sheet[..., 0] - sheet[..., 1] > 80) & (sheet[..., 2] - sheet[..., 1] > 80))
    fg = nd.binary_opening(fg, iterations=1)
    poses = []
    for r_idx, (y0, y1) in enumerate([(70, 205), (270, 405), (530, 655)]):
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
            scale = 0.24
            nw = max(8, int(round(crop_m.shape[1] * scale)))
            nh = max(8, int(round(crop_m.shape[0] * scale)))
            pil = Image.fromarray(rgba_full).resize((nw, nh), Image.Resampling.NEAREST)
            arr = np.array(pil)
            am = arr[..., 3] > 128
            arr[~am] = 0; arr[am, 3] = 255
            poses.append({'name': f'vent_r{r_idx}_{idx}', 'rgba': arr, 'bbox_sheet': [int(x0), int(by0), int(x1), int(by1)]})
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


def anim_frames(poses):
    vent_frames, eboulis_frames = [], []
    gusts = [
        (180, 390, 0, 0), (560, 410, 6, 6), (340, 290, 12, 12),
        (430, 480, 18, 0), (240, 240, 3, 6), (520, 250, 15, 12),
    ]
    drops = [
        (170, 230, 0, 1), (590, 240, 6, -1), (140, 370, 12, 1),
        (620, 360, 18, -1), (310, 195, 3, 1), (460, 195, 15, -1),
    ]
    pebble = np.zeros((5, 6, 4), 'uint8')
    pebble[1:4, 1:5] = (189, 146, 77, 255)
    pebble[1:3, 2:4] = (235, 179, 111, 255)
    pebble[3, 1:5] = (113, 89, 48, 255)
    for t in range(PHASES):
        vf = np.zeros((H, W, 4), 'uint8')
        ef = np.zeros((H, W, 4), 'uint8')
        for gx, gy, p0, row_off in gusts:
            u = (t - p0) % PHASES
            if u < 12:
                pose = poses[row_off + (u // 2) % 6]['rgba']
                paste_sprite(vf, pose, gx + u * 3, gy - (u // 3))
        for dx0, dy0, p0, ddir in drops:
            u = (t - p0) % PHASES
            if u < 16:
                fall_dy = [-22, -16, -9, 0, -4, -1, 0, 0][u] if u < 8 else 0
                roll_dx = ddir * min(u - 3, 5) if u >= 4 else 0
                paste_sprite(ef, pebble, dx0 + roll_dx, dy0 + fall_dy)
        vent_frames.append(vf)
        eboulis_frames.append(ef)
    return vent_frames, eboulis_frames


def write_planche(poses, path):
    cols = 6
    rows = (len(poses) + cols - 1) // cols
    cw, ch = 96, 72
    im = Image.new('RGBA', (cols * cw, rows * ch), (28, 24, 34, 255))
    dr = ImageDraw.Draw(im)
    for idx, p in enumerate(poses):
        r_i, c_i = divmod(idx, cols)
        x0, y0 = c_i * cw, r_i * ch
        dr.rectangle([x0 + 2, y0 + 2, x0 + cw - 3, y0 + ch - 3], outline=(90, 80, 110, 255))
        spr = Image.fromarray(p['rgba'])
        im.alpha_composite(spr, (x0 + (cw - spr.width) // 2, y0 + (ch - spr.height) // 2))
    im.save(path)


def build():
    for d in (OUT / 'calques', OUT / 'animation/vent_sable', OUT / 'animation/eboulis_ocre', OUT / 'review', STAGE):
        if d.exists():
            shutil.rmtree(d)
        d.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(R / 'source/entree_bristle_sud_nord_v1/bruts/touffes_vent_poses.png', RAW / 'touffes_vent_poses.png')

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

    order = ['ciel_montagnes', 'chemin_sable', 'cailloux', 'rochers', 'falaise_ocre', 'falaise_sombre', 'grotte_seuil']
    m768, c768 = down_class(decor, masks, order)
    sol768 = down_full(sol_full)

    raw_layers = {'sol_complet': rgba(sol768, np.ones((H, W), bool))}
    for k in order:
        raw_layers[k] = rgba(c768[k], m768[k])

    pal_groups = {
        'sable': (['sol_complet', 'chemin_sable'], 48),
        'roche_ocre': (['cailloux', 'rochers', 'falaise_ocre'], 64),
        'roche_sombre': (['falaise_sombre', 'grotte_seuil'], 48),
        'ciel': (['ciel_montagnes'], 32),
    }
    layers, pals = {}, {}
    for gname, (keys, n_col) in pal_groups.items():
        ql = quantize_group({k: raw_layers[k] for k in keys}, n_col)
        layers.update(ql)
        cols_u = np.vstack([ql[k][ql[k][..., 3] == 255, :3] for k in keys if (ql[k][..., 3] == 255).any()])
        pals[gname] = {'couleurs': int(len(np.unique(cols_u, axis=0))), 'max': n_col}

    fixed_names = [
        ('sol_complet', f'{PFX}_00_sol_complet.png'),
        ('ciel_montagnes', f'{PFX}_01_ciel_montagnes.png'),
        ('chemin_sable', f'{PFX}_02_chemin_sable.png'),
        ('cailloux', f'{PFX}_03_cailloux.png'),
        ('rochers', f'{PFX}_04_rochers.png'),
        ('falaise_ocre', f'{PFX}_05_falaise_ocre.png'),
        ('falaise_sombre', f'{PFX}_06_falaise_sombre.png'),
        ('grotte_seuil', f'{PFX}_07_grotte_seuil.png'),
    ]
    for k, fn in fixed_names:
        Image.fromarray(layers[k]).save(OUT / 'calques' / fn)

    poses = extract_wind_poses()
    write_planche(poses, OUT / 'review' / f'{PFX}_planche_poses.png')
    vent_frames, eboulis_frames = anim_frames(poses)
    for t in range(PHASES):
        Image.fromarray(vent_frames[t]).save(OUT / 'animation/vent_sable' / f'{PFX}_08_vent_sable_f{t:02d}.png')
        Image.fromarray(eboulis_frames[t]).save(OUT / 'animation/eboulis_ocre' / f'{PFX}_09_eboulis_ocre_f{t:02d}.png')

    walk = m768['chemin_sable'] | m768['cailloux']
    blocked = cell_grid(~walk)
    # Garantir le couloir sud -> grotte (colonnes 45..50, lignes 24..71)
    blocked[24:, 46:50] = False

    entry_px = [384, 560]
    threshold_px = [384, 200]
    for px, py in (entry_px, threshold_px):
        cx, cy = px // 8, py // 8
        blocked[cy:cy + 2, cx:cx + 2] = False

    ok_path, explored = V1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert ok_path, ('Chemin 16x16 coupe', explored)

    def frame_scene(t):
        im = Image.fromarray(layers['sol_complet']).copy()
        for k, _ in fixed_names[1:]:
            im.alpha_composite(Image.fromarray(layers[k]))
        im.alpha_composite(Image.fromarray(vent_frames[t]))
        im.alpha_composite(Image.fromarray(eboulis_frames[t]))
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
    ora_layers[f'{PFX}_08_vent_sable_f00'] = vent_frames[0]
    ora_layers[f'{PFX}_09_eboulis_ocre_f00'] = eboulis_frames[0]
    BM.write_ora(OUT / f'{PFX}_entree_mt_horn_calques.ora', ora_layers)

    stack = [(f'{i:02d}_{k}', [layers[k]], 1) for i, (k, _) in enumerate(fixed_names)] + [
        ('08_vent_sable', vent_frames, TICKS),
        ('09_eboulis_ocre', eboulis_frames, TICKS),
    ]
    tiles_info = _run_ground_project(stack, blocked, {'entrance': entry_px, 'donjon_seuil': threshold_px}, STAGE, NAMESPACE, ASSET, PFX, 'Entrée Mt. Horn (Sud -> Nord)')

    final_fid = {}
    for k, lk in [('chemin_sable', 'chemin_sable'), ('roche_ocre', 'falaise_ocre'), ('roche_sombre', 'falaise_sombre'), ('ciel_montagnes', 'ciel_montagnes')]:
        arr = layers[lk]; m = arr[..., 3] == 255
        px = arr[m, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        mr = ref[materials(ref)[k]].mean(0); md = px.mean(0)
        final_fid[k] = {'rip_rgb': [round(float(x), 1) for x in mr], 'calque_rgb': [round(float(x), 1) for x in md],
                        'distance': round(float(np.linalg.norm(mr - md)), 1)}
        assert final_fid[k]['distance'] < 35, (k, final_fid[k])

    layer_order = [f'calques/{fn}' for _, fn in fixed_names] + [
        f'animation/vent_sable/{PFX}_08_vent_sable_f00..f23.png',
        f'animation/eboulis_ocre/{PFX}_09_eboulis_ocre_f00..f23.png',
    ]
    manifest = {
        'lot': 'source/entree_mt_horn_sud_nord_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'cell_px': 8,
        'orientation': 'sud -> nord',
        'method': 'rendu genere reference sur Mt_Horn_entrance_Sky.png ; sol_complet = plage 96x96 du brut en miroir ; decoupe multicalque native 8 px',
        'reference_rip': {'file': REF_NAME, 'sha256': sha(REF), 'size': [int(ref.shape[1]), int(ref.shape[0])]},
        'raw_inputs': [
            {**GEN[0], 'file': 'source/entree_mt_horn_sud_nord_v1/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC)},
            {**GEN[1], 'file': 'source/entree_mt_horn_sud_nord_v1/bruts/touffes_vent_poses.png', 'sha256': sha(RAW / 'touffes_vent_poses.png'), 'size': [1104, 960]},
        ],
        'sol_complet': {'methode': 'plage 96x96 du brut en miroir la plus proche du chemin du rip', 'plage_y0_y1_x0_x1': list(patch), 'ecart_au_rip': sol_dist},
        'segmentation': seg,
        'fidelite_rip': {'seuil_max': 35.0, 'brut': fid, 'calques_finaux': final_fid},
        'palettes': pals,
        'layer_order_bottom_to_top': layer_order,
        'animations': {
            'scene_loop_ticks': LOOP_TICKS,
            'tracks': {
                'vent_sable': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS, 'poses': len(poses)},
                'eboulis_ocre': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS},
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
