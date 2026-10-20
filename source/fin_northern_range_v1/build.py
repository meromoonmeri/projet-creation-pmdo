"""Fin Northern Range V1 (FNR1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Salle de fin de donjon (Belvédère du Soleil Couchant au sommet de Northern Range, cul-de-sac de boss et d'objectif) associée à ENR1.
Référence canonique `Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Northern Range.png` (456 x 432).

Calques fixes (7) :
- 00_sol_complet : sol de pierre grise craquelée complet (plage 96x96 du brut en miroir) ;
- 01_ciel_couchant : ciel de couchant jaune-orangé et disque solaire blanc-jaune entre les deux cimes ;
- 02_plateau_gris : esplanade de pierre grise craquelée praticable ;
- 03_pics_roche : 6 aiguilles rocheuses dressées sur les flancs de l'arène ;
- 04_falaise_claire : crêtes rocheuses éclairées gris-olive ;
- 05_falaise_sombre : parois rocheuses sombres et abîmes ;
- 06_autel_vent : autel à degrés de pierre grise au nord-centre devant le soleil couchant.

Animations (2 pistes autonomes, 24 phases x 5 ticks = 120 ticks = 2 s) :
- 07_halo_soleil : couronne solaire pulsante entre les deux pics nord ;
- 08_vent_cime : bourrasques d'altitude (`flocons_poses.png`).
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
OUT = R / 'renders/fin_northern_range_v1'
STAGE = R / '.cache/fin_northern_range_v1/fin_northern_range'
NAMESPACE = 'fin_northern_range'
ASSET = 'fnr1_fin_northern_range'
PFX = 'FNR1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS

GEN = [
    {'file': 'decor.png', 'images': [REF_NAME],
     'prompt': 'Wide 4:3 (1200x896) top-down dungeon boss arena map for Northern Range (PMD Red Rescue Team), south stone bridge, circular cracked grey stone summit arena, 6 freestanding jagged rock spires, stepped grey stone Wind Altar at north-center framed by twin mountain peaks and blazing setting sun.',
     'essais': 'premier essai retenu (plateau_gris 4.4, roche_claire 24.5, roche_sombre 2.4, ciel_couchant 6.7 ; seuil < 35)'},
    {'file': 'flocons_poses.png', 'images': ['iceroadpmdsky.png'],
     'prompt': 'Sprite sheet on pure magenta (#FF00FF): high-altitude wind gusts and frost crystals (shared from EGN1).',
     'essais': 'planche partagee avec ENR1/EGN1 (12 poses extraites)'},
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


ENR = loadmod('enr1_build', R / 'source/entree_northern_range_sud_nord_v1/build.py')
FV = loadmod('fvs1_build', R / 'source/fin_vapeur_sommet_v1/build.py')
V1, JM, BM = ENR.V1, ENR.JM, ENR.BM
keep_large, cell_grid, close_, open_ = ENR.keep_large, ENR.cell_grid, ENR.close_, ENR.open_
down_class, down_full, rgba, quantize_group = ENR.down_class, ENR.down_full, ENR.rgba, ENR.quantize_group

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
sha, rgb, lum_of, materials, fidelity, sol_patch, make_sol = ENR.sha, ENR.rgb, ENR.lum_of, ENR.materials, ENR.fidelity, ENR.sol_patch, ENR.make_sol


def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a); sat = a.max(-1) - a.min(-1)
    yy, xx = np.mgrid[:SRC[1], :SRC[0]]
    ciel_couchant = keep_large(((r > 200) & (g > 135) & (r - b > 45) | (lum > 225)) & (yy < 420), 500)

    # Autel du vent au nord-centre (y in 230..365, x in 520..680)
    autel_box = (yy >= 230) & (yy <= 365) & (xx >= 520) & (xx <= 680) & ~ciel_couchant
    plat_raw = (sat < 14) & (lum > 118) & (lum < 185) & ~ciel_couchant & ~autel_box
    corridor = (xx >= 530) & (xx <= 670) & (yy >= 365) & (lum > 85)

    floor_seed = open_(close_(plat_raw | corridor, 3), 2)
    lab, n = nd.label(floor_seed)
    sz = nd.sum(floor_seed, lab, range(1, n + 1))
    main_floor = lab == (int(np.argmax(sz)) + 1)
    filled_floor = nd.binary_fill_holes(main_floor) & ~ciel_couchant & ~autel_box
    filled_floor[yy < 180] = False

    holes = close_(open_(filled_floor & ~plat_raw & ~corridor, 1), 2)
    holes = nd.binary_fill_holes(holes) & filled_floor & ~corridor
    hl, hn = nd.label(holes); hsz = nd.sum(holes, hl, range(1, hn + 1)) if hn else []
    pics_roche = np.isin(hl, [i + 1 for i, v in enumerate(hsz) if v >= 120])
    plateau_gris = filled_floor & ~pics_roche

    autel_vent = nd.binary_fill_holes(close_(autel_box & ~filled_floor, 2)) & ~filled_floor & ~ciel_couchant
    rem = ~filled_floor & ~ciel_couchant & ~autel_vent
    falaise_claire = rem & (lum > 130) & (g >= b)
    falaise_sombre = rem & ~falaise_claire

    masks = dict(
        ciel_couchant=ciel_couchant,
        plateau_gris=plateau_gris,
        pics_roche=pics_roche,
        falaise_claire=falaise_claire,
        falaise_sombre=falaise_sombre,
        autel_vent=autel_vent,
    )
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in masks.items()}
    seg['nb_pics'] = int(sum(v >= 120 for v in hsz))
    return masks, seg


def halo_soleil_frames(m768):
    yy, xx = np.mgrid[:H, :W]
    cx, cy = 384, 118
    dist = np.sqrt((xx - cx) ** 2 + (yy - cy) ** 2)
    frames = []
    for t in range(PHASES):
        fr = np.zeros((H, W, 4), 'uint8')
        s = 0.5 + 0.5 * np.sin(2 * np.pi * t / PHASES)
        r_outer = 44.0 + 8.0 * s
        r_inner = 34.0 + 4.0 * s
        ring = (dist >= r_inner) & (dist <= r_outer) & m768['ciel_couchant']
        fr[ring] = (255, 240, 155, 255)
        fr[ (dist >= r_inner) & (dist <= r_inner + 3.0) & m768['ciel_couchant']] = (255, 255, 235, 255)
        frames.append(fr)
    return frames


def build():
    for d in (OUT / 'calques', OUT / 'animation/halo_soleil', OUT / 'animation/vent_cime', OUT / 'review', STAGE):
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

    order = ['ciel_couchant', 'plateau_gris', 'pics_roche', 'falaise_claire', 'falaise_sombre', 'autel_vent']
    m768, c768 = down_class(decor, masks, order)
    sol768 = down_full(sol_full)

    raw_layers = {'sol_complet': rgba(sol768, np.ones((H, W), bool))}
    for k in order:
        raw_layers[k] = rgba(c768[k], m768[k])

    pal_groups = {
        'plateau': (['sol_complet', 'plateau_gris', 'autel_vent'], 48),
        'roche_claire': (['pics_roche', 'falaise_claire'], 64),
        'roche_sombre': (['falaise_sombre'], 48),
        'ciel': (['ciel_couchant'], 48),
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
        ('autel_vent', f'{PFX}_06_autel_vent.png'),
    ]
    for k, fn in fixed_names:
        Image.fromarray(layers[k]).save(OUT / 'calques' / fn)

    poses = ENR.extract_frost_poses()
    ENR.write_planche(poses, OUT / 'review' / f'{PFX}_planche_poses.png')
    _, vent_frames = ENR.anim_frames(poses, m768)
    halo_frames = halo_soleil_frames(m768)
    for t in range(PHASES):
        Image.fromarray(halo_frames[t]).save(OUT / 'animation/halo_soleil' / f'{PFX}_07_halo_soleil_f{t:02d}.png')
        Image.fromarray(vent_frames[t]).save(OUT / 'animation/vent_cime' / f'{PFX}_08_vent_cime_f{t:02d}.png')

    walk = m768['plateau_gris']
    blocked = cell_grid(~walk)
    blocked[:6, :] = True
    blocked[:, :2] = True
    blocked[:, -2:] = True
    blocked[30:, 46:50] = False

    entry_px = [384, 560]
    boss_px = [376, 336]
    objectif_px = [376, 240]
    for px, py in (entry_px, boss_px, objectif_px):
        cx, cy = px // 8, py // 8
        blocked[cy:cy + 2, cx:cx + 2] = False

    ok_b, exp_b = V1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    ok_o, exp_o = V1.reachable(blocked, (boss_px[1] // 8, boss_px[0] // 8), (objectif_px[1] // 8, objectif_px[0] // 8))
    assert ok_b and ok_o, (ok_b, ok_o)

    def frame_scene(t):
        im = Image.fromarray(layers['sol_complet']).copy()
        for k, _ in fixed_names[1:]:
            im.alpha_composite(Image.fromarray(layers[k]))
        im.alpha_composite(Image.fromarray(halo_frames[t]))
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
    for (px, py), col in [(entry_px, (255, 220, 40, 255)), (boss_px, (255, 80, 60, 255)), (objectif_px, (40, 240, 255, 255))]:
        dr.rectangle([px, py, px + 15, py + 15], outline=col, width=2)
    col_im.alpha_composite(ov); col_im.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    ora_layers = {fn[:-4]: layers[k] for k, fn in fixed_names}
    ora_layers[f'{PFX}_07_halo_soleil_f00'] = halo_frames[0]
    ora_layers[f'{PFX}_08_vent_cime_f00'] = vent_frames[0]
    BM.write_ora(OUT / f'{PFX}_fin_northern_range_calques.ora', ora_layers)

    stack = [(f'{i:02d}_{k}', [layers[k]], 1) for i, (k, _) in enumerate(fixed_names)] + [
        ('07_halo_soleil', halo_frames, TICKS),
        ('08_vent_cime', vent_frames, TICKS),
    ]
    markers = {'entrance': entry_px, 'boss': boss_px, 'objectif': objectif_px}
    tiles_info = _run_ground_project(stack, blocked, markers, STAGE, NAMESPACE, ASSET, PFX, 'Fin Northern Range — Belvédère du Soleil Couchant')

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
        f'animation/halo_soleil/{PFX}_07_halo_soleil_f00..f23.png',
        f'animation/vent_cime/{PFX}_08_vent_cime_f00..f23.png',
    ]
    manifest = {
        'lot': 'source/fin_northern_range_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'cell_px': 8,
        'orientation': 'cul-de-sac (entree sud -> boss central -> objectif nord)',
        'method': 'rendu genere reference sur Northern Range (RRT) ; sol_complet = plage 96x96 du brut en miroir ; decoupe multicalque native 8 px',
        'reference_rip': {'file': REF_NAME, 'sha256': sha(REF), 'size': [int(ref.shape[1]), int(ref.shape[0])]},
        'raw_inputs': [
            {**GEN[0], 'file': 'source/fin_northern_range_v1/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC)},
            {**GEN[1], 'file': 'source/fin_northern_range_v1/bruts/flocons_poses.png', 'sha256': sha(RAW / 'flocons_poses.png'), 'size': [1717, 916]},
        ],
        'sol_complet': {'methode': 'plage 96x96 du brut en miroir la plus proche du plateau gris du rip', 'plage_y0_y1_x0_x1': list(patch), 'ecart_au_rip': sol_dist},
        'segmentation': seg,
        'fidelite_rip': {'seuil_max': 35.0, 'brut': fid, 'calques_finaux': final_fid},
        'palettes': pals,
        'layer_order_bottom_to_top': layer_order,
        'animations': {
            'scene_loop_ticks': LOOP_TICKS,
            'tracks': {
                'halo_soleil': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS},
                'vent_cime': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS, 'poses': len(poses)},
            },
        },
        'access': {
            'entry_px': entry_px,
            'boss_px': boss_px,
            'objectif_px': objectif_px,
            'markers': markers,
            'path_16x16_found': True,
            'walkable_16x16_states_explored': int(max(exp_b, exp_o)),
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
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objectif_px,
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance'] for k, v in final_fid.items()}, 'tiles': tiles_info}, indent=1))


if __name__ == '__main__':
    build()
