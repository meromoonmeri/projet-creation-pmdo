"""Fin Bassin Chauffant V1 (FBH1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Salle de fin de donjon (Sanctuaire du Grand Geyser Thermal, cul-de-sac de boss et d'objectif) associée à EBH1.
Référence canonique `bassinchauffantpmdsky.png` (504 x 408).

Calques fixes (8) :
- 00_sol_complet : sol de terre sablonneuse ocre complet (plage 96x96 du brut en miroir) ;
- 01_eau_thermale : anneau extérieur d'eau minérale chaude entourant l'arène ;
- 02_chemin_sable : allée sud à dalles et barrières de bois praticable ;
- 03_sol_arene : grand bassin central d'eau minérale peu profonde praticable (arène de boss) ;
- 04_rochers_rive : couronnes de rochers bruns bordant le bassin ;
- 05_fumerolles : 4 grands cônes de fumerolles volcaniques sur les flancs ;
- 06_herbe_arbres : forêt verte fermant le nord et les côtés + ciel d'horizon ;
- 07_autel_thermal : autel volcanique à degrés et cratère de geyser au nord-centre.

Animations (2 pistes autonomes, 24 phases x 5 ticks = 120 ticks = 2 s) :
- 08_onde_thermale : ondulations minérales dorées sur l'eau thermale (sans liseré blanc) ;
- 09_vapeur_fumerolles : panaches de vapeur montant des fumerolles et de l'autel (`vapeur_poses.png`).
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
OUT = R / 'renders/fin_bassin_chauffant_v1'
STAGE = R / '.cache/fin_bassin_chauffant_v1/fin_bassin_chauffant'
NAMESPACE = 'fin_bassin_chauffant'
ASSET = 'fbh1_fin_bassin_chauffant'
PFX = 'FBH1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS

GEN = [
    {'file': 'decor.png', 'images': [REF_NAME],
     'prompt': 'Wide 4:3 (1200x896) top-down dungeon boss arena map for Hot Spring / Bassin Chauffant (PMD Explorers of Sky), south sandy-ochre path with stepping stones and fence posts, central circular thermal arena surrounded by a ring-moat of golden-olive mineral water and 4 rocky fumarole mounds, stepped Thermal Geyser Shrine at north-center backed by closed northern forest.',
     'essais': 'premier essai retenu (eau_thermale 16.2, chemin_sable 5.6, roche_brune 5.9, herbe_arbres 3.1 ; seuil < 35)'},
    {'file': 'vapeur_poses.png', 'images': ['Steam_Cave_Peak_TDS.png'],
     'prompt': 'Sprite sheet on pure magenta (#FF00FF): rising steam plumes (shared from FVS1).',
     'essais': 'planche partagee avec EBH1/FVS1 (8 poses extraites)'},
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


EBH = loadmod('ebh1_build', R / 'source/entree_bassin_chauffant_sud_nord_v1/build.py')
FV = loadmod('fvs1_build', R / 'source/fin_vapeur_sommet_v1/build.py')
V1, JM, BM = EBH.V1, EBH.JM, EBH.BM
keep_large, cell_grid, close_, open_ = EBH.keep_large, EBH.cell_grid, EBH.close_, EBH.open_
down_class, down_full, rgba, quantize_group = EBH.down_class, EBH.down_full, EBH.rgba, EBH.quantize_group

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
sha, rgb, lum_of, materials, fidelity, sol_patch, make_sol = EBH.sha, EBH.rgb, EBH.lum_of, EBH.materials, EBH.fidelity, EBH.sol_patch, EBH.make_sol


def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    yy, xx = np.mgrid[:SRC[1], :SRC[0]]

    # Autel thermal au nord-centre (y in 90..335, x in 485..715)
    autel_box = (yy >= 90) & (yy <= 335) & (xx >= 485) & (xx <= 715) & ~(((g > r + 8) & (g > b + 12)) | (b > r + 20))
    # Arène centrale peu profonde (ellipse centrale x=600, y=490, rx=205, ry=155)
    inner_ellipse = (((xx - 600) / 205.0) ** 2 + ((yy - 490) / 155.0) ** 2) <= 1.0
    eau_raw = (r > 145) & (g > 125) & (b < 95) & (r - g < 36) & (g - b > 45) & (yy >= 250) & (yy <= 740)

    sol_arene = (inner_ellipse & eau_raw & ~autel_box) | ((xx >= 535) & (xx <= 665) & (yy >= 335) & (yy <= 645))
    sol_arene = nd.binary_fill_holes(close_(sol_arene, 2)) & ~autel_box

    eau_thermale = keep_large(eau_raw & ~sol_arene & ~autel_box, 2000)

    sable_raw = (r > 205) & (g > 158) & (b > 95) & (r - b > 65) & (yy >= 600) & (xx >= 480) & (xx <= 720)
    south_bridge = (xx >= 530) & (xx <= 670) & (yy >= 600)
    chemin_sable = open_(close_(sable_raw | south_bridge, 2), 1) & ~sol_arene & ~eau_thermale

    autel_thermal = nd.binary_fill_holes(close_(autel_box & ~sol_arene, 2)) & ~sol_arene
    rem = ~sol_arene & ~eau_thermale & ~chemin_sable & ~autel_thermal
    herbe_arbres = rem & ((g > r + 10) & (g > b + 15) | (b > r + 20) | (yy < 160))
    rem_rock = rem & ~herbe_arbres

    near_water = nd.binary_dilation(eau_thermale | sol_arene, iterations=28) & (yy >= 240) & (xx >= 240) & (xx <= 960)
    rochers_rive = rem_rock & near_water
    fumerolles = rem_rock & ~rochers_rive

    masks = dict(
        eau_thermale=eau_thermale,
        chemin_sable=chemin_sable,
        sol_arene=sol_arene,
        rochers_rive=rochers_rive,
        fumerolles=fumerolles,
        herbe_arbres=herbe_arbres,
        autel_thermal=autel_thermal,
    )
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in masks.items()}
    return masks, seg


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

    order = ['eau_thermale', 'chemin_sable', 'sol_arene', 'rochers_rive', 'fumerolles', 'herbe_arbres', 'autel_thermal']
    m768, c768 = down_class(decor, masks, order)
    sol768 = down_full(sol_full)

    raw_layers = {'sol_complet': rgba(sol768, np.ones((H, W), bool))}
    for k in order:
        raw_layers[k] = rgba(c768[k], m768[k])

    pal_groups = {
        'sable': (['sol_complet', 'chemin_sable'], 48),
        'eau': (['eau_thermale', 'sol_arene'], 48),
        'roche': (['rochers_rive', 'fumerolles', 'autel_thermal'], 64),
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
        ('sol_arene', f'{PFX}_03_sol_arene.png'),
        ('rochers_rive', f'{PFX}_04_rochers_rive.png'),
        ('fumerolles', f'{PFX}_05_fumerolles.png'),
        ('herbe_arbres', f'{PFX}_06_herbe_arbres.png'),
        ('autel_thermal', f'{PFX}_07_autel_thermal.png'),
    ]
    for k, fn in fixed_names:
        Image.fromarray(layers[k]).save(OUT / 'calques' / fn)

    poses = EBH.extract_steam_poses()
    EBH.write_planche(poses, OUT / 'review' / f'{PFX}_planche_poses.png')
    onde_frames, vapeur_frames = EBH.anim_frames(poses, {'eau_thermale': m768['eau_thermale']})
    for t in range(PHASES):
        Image.fromarray(onde_frames[t]).save(OUT / 'animation/onde_thermale' / f'{PFX}_08_onde_thermale_f{t:02d}.png')
        Image.fromarray(vapeur_frames[t]).save(OUT / 'animation/vapeur_fumerolles' / f'{PFX}_09_vapeur_fumerolles_f{t:02d}.png')

    walk = m768['chemin_sable'] | m768['sol_arene']
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
    for (px, py), col in [(entry_px, (255, 220, 40, 255)), (boss_px, (255, 80, 60, 255)), (objectif_px, (40, 240, 255, 255))]:
        dr.rectangle([px, py, px + 15, py + 15], outline=col, width=2)
    col_im.alpha_composite(ov); col_im.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    ora_layers = {fn[:-4]: layers[k] for k, fn in fixed_names}
    ora_layers[f'{PFX}_08_onde_thermale_f00'] = onde_frames[0]
    ora_layers[f'{PFX}_09_vapeur_fumerolles_f00'] = vapeur_frames[0]
    BM.write_ora(OUT / f'{PFX}_fin_bassin_chauffant_calques.ora', ora_layers)

    stack = [(f'{i:02d}_{k}', [layers[k]], 1) for i, (k, _) in enumerate(fixed_names)] + [
        ('08_onde_thermale', onde_frames, TICKS),
        ('09_vapeur_fumerolles', vapeur_frames, TICKS),
    ]
    markers = {'entrance': entry_px, 'boss': boss_px, 'objectif': objectif_px}
    tiles_info = _run_ground_project(stack, blocked, markers, STAGE, NAMESPACE, ASSET, PFX, 'Fin Bassin Chauffant — Sanctuaire du Grand Geyser')

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
        'lot': 'source/fin_bassin_chauffant_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'cell_px': 8,
        'orientation': 'cul-de-sac (entree sud -> boss central -> objectif nord)',
        'method': 'rendu genere reference sur bassinchauffantpmdsky.png ; sol_complet = plage 96x96 du brut en miroir ; decoupe multicalque native 8 px',
        'reference_rip': {'file': REF_NAME, 'sha256': sha(REF), 'size': [int(ref.shape[1]), int(ref.shape[0])]},
        'raw_inputs': [
            {**GEN[0], 'file': 'source/fin_bassin_chauffant_v1/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC)},
            {**GEN[1], 'file': 'source/fin_bassin_chauffant_v1/bruts/vapeur_poses.png', 'sha256': sha(RAW / 'vapeur_poses.png'), 'size': [1047, 1008]},
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
