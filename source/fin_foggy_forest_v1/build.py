"""Fin Foggy Forest V1 (FFF1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Salle de fin de donjon (Sanctuaire de la Stèle de Brume au cœur de Foggy Forest, cul-de-sac de boss et d'objectif) associée à EFF1.
Référence canonique `Foggy_Forest_Base_Camp_TDS.png` (504 x 576).

Calques fixes (8) :
- 00_sol_complet : sol d'herbe claire complet (plage 96x96 du brut en miroir) ;
- 01_herbe_claire : herbe vert sauge praticable de l'arène ;
- 02_chemin_terre : sentier d'arrivée sud ;
- 03_fleurs : touffes de fleurs ;
- 04_rochers : amas rocheux gris-beige sur les flancs ;
- 05_arbres_isoles : 4 arbres ronds isolés et buissons de la clairière ;
- 06_arbres_lisiere : lisière forestière dense fermant le nord et les côtés ;
- 07_autel_brume : autel pyramidal moussu entouré de racines et de runes de brume au nord-centre.

Animations (2 pistes autonomes, 24 phases x 5 ticks = 120 ticks = 2 s) :
- 08_lueur_runes : pulsation lumineuse cyan-menthe du cercle runique au pied de l'autel ;
- 09_feuilles_lucioles : feuilles et lucioles flottant dans la clairière (`feuilles_lucioles_poses.png`).
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'Foggy_Forest_Base_Camp_TDS.png'
REF = R / REF_NAME
OUT = R / 'renders/fin_foggy_forest_v1'
STAGE = R / '.cache/fin_foggy_forest_v1/fin_foggy_forest'
NAMESPACE = 'fin_foggy_forest'
ASSET = 'fff1_fin_foggy_forest'
PFX = 'FFF1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS

GEN = [
    {'file': 'decor.png', 'images': [REF_NAME],
     'prompt': 'Wide 4:3 (1200x896) top-down dungeon boss arena map for Foggy Forest (PMD Explorers of Sky), south entrance path, circular pale sage-green clearing, 4 freestanding round green trees, small rocks and flowers, stepped mossy stone Fog Shrine surrounded by glowing runes and roots at north-center backed by closed forest canopy.',
     'essais': 'premier essai retenu (chemin_terre 6.4, herbe_claire 7.3, herbe_foret 14.7 ; seuil < 35)'},
    {'file': 'feuilles_lucioles_poses.png', 'images': ['Mystifying_Forest_entrance_TDS.png'],
     'prompt': 'Sprite sheet on pure magenta (#FF00FF): drifting forest leaves and glowing motes (shared from EMF1).',
     'essais': 'planche partagee avec EFF1/EMF1 (18 poses extraites)'},
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


EFF = loadmod('eff1_build', R / 'source/entree_foggy_forest_sud_nord_v1/build.py')
FV = loadmod('fvs1_build', R / 'source/fin_vapeur_sommet_v1/build.py')
V1, JM, BM = EFF.V1, EFF.JM, EFF.BM
keep_large, cell_grid, close_, open_ = EFF.keep_large, EFF.cell_grid, EFF.close_, EFF.open_
down_class, down_full, rgba, quantize_group = EFF.down_class, EFF.down_full, EFF.rgba, EFF.quantize_group

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
sha, rgb, lum_of, materials, fidelity, sol_patch, make_sol = EFF.sha, EFF.rgb, EFF.lum_of, EFF.materials, EFF.fidelity, EFF.sol_patch, EFF.make_sol


def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    yy, xx = np.mgrid[:SRC[1], :SRC[0]]

    # Autel moussu et racines au nord-centre (y in 80..330, x in 450..750)
    autel_box = (yy >= 80) & (yy <= 330) & (xx >= 450) & (xx <= 750)
    chemin_raw = (r > g) & (g > b) & (r - b > 16) & (r - g < 32) & (lum > 110) & (lum < 190) & (yy > 580)
    hclaire_raw = (g > r + 14) & (g > b + 14) & (lum > 130) & (r > 100) & ~autel_box
    corridor = (xx >= 545) & (xx <= 655) & (yy >= 330) & (lum > 80)

    walk_seed = open_(close_(chemin_raw | hclaire_raw | corridor, 3), 2)
    lab, n = nd.label(walk_seed)
    sz = nd.sum(walk_seed, lab, range(1, n + 1))
    main_walk = lab == (int(np.argmax(sz)) + 1)
    filled_walk = nd.binary_fill_holes(main_walk) & ~autel_box
    filled_walk[yy < 96] = False

    holes = close_(open_(filled_walk & ~(chemin_raw | hclaire_raw) & ~corridor, 1), 2)
    holes = nd.binary_fill_holes(holes) & filled_walk & ~corridor
    hl, hn = nd.label(holes); hsz = nd.sum(holes, hl, range(1, hn + 1)) if hn else []
    arbres_ids, rochers_ids, fleurs_ids = [], [], []
    for i, v in enumerate(hsz, 1):
        if v < 20:
            continue
        m_c = hl == i
        if v >= 1200 or g[m_c].mean() > r[m_c].mean() + 12:
            arbres_ids.append(i)
        elif v < 260 and (r[m_c].max() > 195 or b[m_c].max() > 160):
            fleurs_ids.append(i)
        else:
            rochers_ids.append(i)
    arbres_isoles = np.isin(hl, arbres_ids)
    rochers = np.isin(hl, rochers_ids)
    fleurs = np.isin(hl, fleurs_ids)

    ground_walk = filled_walk & ~arbres_isoles & ~rochers & ~fleurs
    chemin_terre = ground_walk & (chemin_raw | ((xx >= 535) & (xx <= 665) & (yy >= 620) & (r >= g - 10)))
    herbe_claire = ground_walk & ~chemin_terre

    autel_brume = nd.binary_fill_holes(close_(autel_box & ~filled_walk, 2)) & ~filled_walk
    arbres_lisiere = ~filled_walk & ~autel_brume

    masks = dict(
        herbe_claire=herbe_claire,
        chemin_terre=chemin_terre,
        fleurs=fleurs,
        rochers=rochers,
        arbres_isoles=arbres_isoles,
        arbres_lisiere=arbres_lisiere,
        autel_brume=autel_brume,
    )
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in masks.items()}
    seg['nb_arbres_isoles'] = len(arbres_ids)
    seg['nb_rochers'] = len(rochers_ids)
    return masks, seg


def lueur_runes_frames(decor768):
    r, g, b = decor768.transpose(2, 0, 1)
    yy, xx = np.mgrid[:H, :W]
    rune_zone = (yy >= 135) & (yy <= 235) & (xx >= 285) & (xx <= 485) & (g > 195) & (b > 175)
    ang = np.arctan2(yy - 175, xx - 384)
    frames = []
    for t in range(PHASES):
        fr = np.zeros((H, W, 4), 'uint8')
        wave = np.sin(2 * np.pi * t / PHASES - 2.0 * ang)
        m_hi = rune_zone & (wave > 0.25)
        m_lo = rune_zone & (wave > -0.2) & ~m_hi
        fr[m_lo] = (145, 228, 196, 255)
        fr[m_hi] = (215, 255, 238, 255)
        frames.append(fr)
    return frames


def build():
    for d in (OUT / 'calques', OUT / 'animation/lueur_runes', OUT / 'animation/feuilles_lucioles', OUT / 'review', STAGE):
        if d.exists():
            shutil.rmtree(d)
        d.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(R / 'source/entree_mystifying_forest_sud_nord_v1/bruts/feuilles_lucioles_poses.png', RAW / 'feuilles_lucioles_poses.png')

    decor = rgb(RAW / 'decor.png')
    ref = rgb(REF)
    assert decor.shape == (SRC[1], SRC[0], 3), decor.shape
    fid = fidelity(decor, ref)
    for k, v in fid.items():
        assert v['distance'] < 35, (k, v)

    masks, seg = classify(decor)
    patch = sol_patch(decor, masks['herbe_claire'], ref[materials(ref)['herbe_claire']].mean(0))
    sol_full = make_sol(decor, patch)
    _sel_sol = materials(sol_full)['herbe_claire']
    _sol_px = sol_full[_sel_sol] if _sel_sol.sum() > 50 else sol_full.reshape(-1, 3)
    sol_dist = round(float(np.linalg.norm(_sol_px.mean(0) - ref[materials(ref)['herbe_claire']].mean(0))), 2)

    order = ['herbe_claire', 'chemin_terre', 'fleurs', 'rochers', 'arbres_isoles', 'arbres_lisiere', 'autel_brume']
    m768, c768 = down_class(decor, masks, order)
    sol768 = down_full(sol_full)

    raw_layers = {'sol_complet': rgba(sol768, np.ones((H, W), bool))}
    for k in order:
        raw_layers[k] = rgba(c768[k], m768[k])

    pal_groups = {
        'herbe': (['sol_complet', 'herbe_claire'], 48),
        'chemin': (['chemin_terre', 'rochers', 'autel_brume'], 64),
        'fleurs': (['fleurs'], 32),
        'foret': (['arbres_isoles', 'arbres_lisiere'], 64),
    }
    layers, pals = {}, {}
    for gname, (keys, n_col) in pal_groups.items():
        ql = quantize_group({k: raw_layers[k] for k in keys}, n_col)
        layers.update(ql)
        cols_u = np.vstack([ql[k][ql[k][..., 3] == 255, :3] for k in keys if (ql[k][..., 3] == 255).any()])
        pals[gname] = {'couleurs': int(len(np.unique(cols_u, axis=0))), 'max': n_col}

    fixed_names = [
        ('sol_complet', f'{PFX}_00_sol_complet.png'),
        ('herbe_claire', f'{PFX}_01_herbe_claire.png'),
        ('chemin_terre', f'{PFX}_02_chemin_terre.png'),
        ('fleurs', f'{PFX}_03_fleurs.png'),
        ('rochers', f'{PFX}_04_rochers.png'),
        ('arbres_isoles', f'{PFX}_05_arbres_isoles.png'),
        ('arbres_lisiere', f'{PFX}_06_arbres_lisiere.png'),
        ('autel_brume', f'{PFX}_07_autel_brume.png'),
    ]
    for k, fn in fixed_names:
        Image.fromarray(layers[k]).save(OUT / 'calques' / fn)

    poses = EFF.extract_forest_poses()
    EFF.write_planche(poses, OUT / 'review' / f'{PFX}_planche_poses.png')
    feuilles_frames, lucioles_frames = EFF.anim_frames(poses)
    combo_frames = []
    for t in range(PHASES):
        im = Image.fromarray(feuilles_frames[t]).copy()
        im.alpha_composite(Image.fromarray(lucioles_frames[t]))
        combo_frames.append(np.array(im))
    lueur_frames = lueur_runes_frames(down_full(decor))
    for t in range(PHASES):
        Image.fromarray(lueur_frames[t]).save(OUT / 'animation/lueur_runes' / f'{PFX}_08_lueur_runes_f{t:02d}.png')
        Image.fromarray(combo_frames[t]).save(OUT / 'animation/feuilles_lucioles' / f'{PFX}_09_feuilles_lucioles_f{t:02d}.png')

    walk = m768['herbe_claire'] | m768['chemin_terre'] | m768['fleurs']
    blocked = cell_grid(~walk)
    blocked[:6, :] = True
    blocked[:, :2] = True
    blocked[:, -2:] = True
    blocked[27:, 46:50] = False

    entry_px = [384, 560]
    boss_px = [376, 320]
    objectif_px = [376, 224]
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
        im.alpha_composite(Image.fromarray(lueur_frames[t]))
        im.alpha_composite(Image.fromarray(combo_frames[t]))
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
    ora_layers[f'{PFX}_08_lueur_runes_f00'] = lueur_frames[0]
    ora_layers[f'{PFX}_09_feuilles_lucioles_f00'] = combo_frames[0]
    BM.write_ora(OUT / f'{PFX}_fin_foggy_forest_calques.ora', ora_layers)

    stack = [(f'{i:02d}_{k}', [layers[k]], 1) for i, (k, _) in enumerate(fixed_names)] + [
        ('08_lueur_runes', lueur_frames, TICKS),
        ('09_feuilles_lucioles', combo_frames, TICKS),
    ]
    markers = {'entrance': entry_px, 'boss': boss_px, 'objectif': objectif_px}
    tiles_info = _run_ground_project(stack, blocked, markers, STAGE, NAMESPACE, ASSET, PFX, 'Fin Foggy Forest — Sanctuaire de la Stèle de Brume')

    final_fid = {}
    for k, lk in [('chemin_terre', 'chemin_terre'), ('herbe_claire', 'herbe_claire'), ('herbe_foret', 'arbres_lisiere')]:
        arr = layers[lk]; m = arr[..., 3] == 255
        px = arr[m, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        mr = ref[materials(ref)[k]].mean(0); md = px.mean(0)
        final_fid[k] = {'rip_rgb': [round(float(x), 1) for x in mr], 'calque_rgb': [round(float(x), 1) for x in md],
                        'distance': round(float(np.linalg.norm(mr - md)), 1)}
        assert final_fid[k]['distance'] < 35, (k, final_fid[k])

    layer_order = [f'calques/{fn}' for _, fn in fixed_names] + [
        f'animation/lueur_runes/{PFX}_08_lueur_runes_f00..f23.png',
        f'animation/feuilles_lucioles/{PFX}_09_feuilles_lucioles_f00..f23.png',
    ]
    manifest = {
        'lot': 'source/fin_foggy_forest_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'cell_px': 8,
        'orientation': 'cul-de-sac (entree sud -> boss central -> objectif nord)',
        'method': 'rendu genere reference sur Foggy_Forest_Base_Camp_TDS.png ; sol_complet = plage 96x96 du brut en miroir ; decoupe multicalque native 8 px',
        'reference_rip': {'file': REF_NAME, 'sha256': sha(REF), 'size': [int(ref.shape[1]), int(ref.shape[0])]},
        'raw_inputs': [
            {**GEN[0], 'file': 'source/fin_foggy_forest_v1/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC)},
            {**GEN[1], 'file': 'source/fin_foggy_forest_v1/bruts/feuilles_lucioles_poses.png', 'sha256': sha(RAW / 'feuilles_lucioles_poses.png'), 'size': [1124, 944]},
        ],
        'sol_complet': {'methode': 'plage 96x96 du brut en miroir la plus proche de l herbe claire du rip', 'plage_y0_y1_x0_x1': list(patch), 'ecart_au_rip': sol_dist},
        'segmentation': seg,
        'fidelite_rip': {'seuil_max': 35.0, 'brut': fid, 'calques_finaux': final_fid},
        'palettes': pals,
        'layer_order_bottom_to_top': layer_order,
        'animations': {
            'scene_loop_ticks': LOOP_TICKS,
            'tracks': {
                'lueur_runes': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS},
                'feuilles_lucioles': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS, 'poses': 18},
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
