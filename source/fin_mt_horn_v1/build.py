"""Fin Mt. Horn V1 (FMH1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Salle de fin de donjon (Sanctuaire du Monolithe Cornu au sommet du Mont Cornu, cul-de-sac de boss et d'objectif) associée à EMH1.
Référence canonique `Mt_Horn_entrance_Sky.png` (432 x 360).

Calques fixes (9) :
- 00_sol_complet : sol de piste craquelée complet (plage 96x96 du brut en miroir) ;
- 01_ciel_montagnes : ciel bleu et cimes enneigées cyan visibles aux coins nord-ouest et nord-est ;
- 02_chemin_sable : esplanade rocheuse ocre-orangé praticable ;
- 03_cailloux : petits cailloux sur l'arène ;
- 04_piliers_roche : 6 aiguilles rocheuses dressées sur les flancs de l'arène ;
- 05_falaise_ocre : strates tabulaires ocre-jaune des falaises fermant le nord et les côtés ;
- 06_falaise_sombre : parois brunes ombrées et crevasses ;
- 07_autel_corne : grand autel pyramidal à degrés couronné des deux cornes de pierre au nord-centre.

Animations (2 pistes autonomes, 24 phases x 5 ticks = 120 ticks = 2 s) :
- 08_vent_sable : tourbillons de poussière et bourrasques (`touffes_vent_poses.png`) ;
- 09_lueur_autel : résonance dorée sur les cornes et le sanctuaire de l'autel nord.
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
OUT = R / 'renders/fin_mt_horn_v1'
STAGE = R / '.cache/fin_mt_horn_v1/fin_mt_horn'
NAMESPACE = 'fin_mt_horn'
ASSET = 'fmh1_fin_mt_horn'
PFX = 'FMH1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS

GEN = [
    {'file': 'decor.png', 'images': [REF_NAME],
     'prompt': 'Wide 4:3 (1200x896) top-down dungeon boss arena map for Mt. Horn (PMD Explorers of Sky), south entrance, circular cracked orange-tan summit arena, 6 freestanding rock spires, stepped Horn Monolith Shrine at north-center backed by closed layered ochre-yellow mesa cliffs.',
     'essais': 'premier essai retenu (chemin_sable 10.4, roche_ocre 5.1, roche_sombre 4.1, ciel_montagnes 15.9 ; seuil < 35)'},
    {'file': 'touffes_vent_poses.png', 'images': ['Mt_Bristle_entrance_TD.png'],
     'prompt': 'Sprite sheet on pure magenta (#FF00FF): windblown dust wisps and scrub tufts (shared from EBN1).',
     'essais': 'planche partagee avec EMH1/EBN1 (18 poses extraites)'},
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


EMH = loadmod('emh1_build', R / 'source/entree_mt_horn_sud_nord_v1/build.py')
FV = loadmod('fvs1_build', R / 'source/fin_vapeur_sommet_v1/build.py')
V1, JM, BM = EMH.V1, EMH.JM, EMH.BM
keep_large, cell_grid, close_, open_ = EMH.keep_large, EMH.cell_grid, EMH.close_, EMH.open_
down_class, down_full, rgba, quantize_group = EMH.down_class, EMH.down_full, EMH.rgba, EMH.quantize_group

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
sha, rgb, lum_of, materials, fidelity, sol_patch, make_sol = EMH.sha, EMH.rgb, EMH.lum_of, EMH.materials, EMH.fidelity, EMH.sol_patch, EMH.make_sol


def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    yy, xx = np.mgrid[:SRC[1], :SRC[0]]
    ciel_montagnes = keep_large((b > r + 10) & (b > 130) & (yy < 360), 500)

    # Autel à cornes au nord-centre (y in 20..340, x in 435..765)
    autel_box = (yy >= 20) & (yy <= 340) & (xx >= 435) & (xx <= 765) & ~ciel_montagnes
    sable_raw = (r > 205) & (g > 148) & (b > 65) & (r - g > 30) & (g - b > 32) & ~ciel_montagnes & ~autel_box
    corridor = (xx >= 520) & (xx <= 680) & (yy >= 340) & (lum > 95)
    floor_seed = open_(close_(sable_raw | corridor, 3), 2)
    lab, n = nd.label(floor_seed)
    sz = nd.sum(floor_seed, lab, range(1, n + 1))
    main_floor = lab == (int(np.argmax(sz)) + 1)
    filled_floor = nd.binary_fill_holes(main_floor) & ~ciel_montagnes & ~autel_box
    filled_floor[yy < 80] = False

    holes = close_(open_(filled_floor & ~sable_raw & ~corridor, 1), 2)
    holes = nd.binary_fill_holes(holes) & filled_floor & ~corridor
    hl, hn = nd.label(holes); hsz = nd.sum(holes, hl, range(1, hn + 1)) if hn else []
    piliers_roche = np.isin(hl, [i + 1 for i, v in enumerate(hsz) if v >= 450])
    cailloux = np.isin(hl, [i + 1 for i, v in enumerate(hsz) if 20 <= v < 450])
    chemin_sable = filled_floor & ~piliers_roche & ~cailloux

    autel_corne = nd.binary_fill_holes(close_(autel_box & ~filled_floor, 2)) & ~filled_floor & ~ciel_montagnes
    rem = ~filled_floor & ~ciel_montagnes & ~autel_corne
    falaise_ocre = rem & (r > 145) & (g > 100)
    falaise_sombre = rem & ~falaise_ocre

    masks = dict(
        ciel_montagnes=ciel_montagnes,
        chemin_sable=chemin_sable,
        cailloux=cailloux,
        piliers_roche=piliers_roche,
        falaise_ocre=falaise_ocre,
        falaise_sombre=falaise_sombre,
        autel_corne=autel_corne,
    )
    seg = {f'{k}_px_1200x896': int(v.sum()) for k, v in masks.items()}
    seg['nb_piliers'] = int(sum(v >= 450 for v in hsz))
    return masks, seg


def lueur_autel_frames():
    yy, xx = np.mgrid[:H, :W]
    frames = []
    sparks = [(348, 44, 0), (420, 44, 6), (368, 92, 12), (400, 92, 18), (355, 138, 4), (413, 138, 16)]
    for t in range(PHASES):
        fr = np.zeros((H, W, 4), 'uint8')
        s = 0.5 + 0.5 * np.sin(2 * np.pi * t / PHASES)
        for cx, cy, rx, ry in [(350, 40, 10, 12), (418, 40, 10, 12), (384, 118, 20, 24)]:
            d = np.sqrt(((xx - cx) / max(1.0, rx * (0.85 + 0.25 * s))) ** 2 + ((yy - cy) / max(1.0, ry * (0.85 + 0.25 * s))) ** 2)
            ring = (d >= 0.82) & (d <= 1.0) & (((xx + yy + t) % 2) == 0)
            fr[ring] = (255, 228, 148, 255)
        for sx, sy, p0 in sparks:
            u = (t - p0) % 12
            if u < 8:
                py = sy - u * 2
                fr[py - 1:py + 2, sx] = (255, 236, 168, 255)
                fr[py, sx - 1:sx + 2] = (255, 236, 168, 255)
        frames.append(fr)
    return frames


def build():
    for d in (OUT / 'calques', OUT / 'animation/vent_sable', OUT / 'animation/lueur_autel', OUT / 'review', STAGE):
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

    order = ['ciel_montagnes', 'chemin_sable', 'cailloux', 'piliers_roche', 'falaise_ocre', 'falaise_sombre', 'autel_corne']
    m768, c768 = down_class(decor, masks, order)
    sol768 = down_full(sol_full)

    raw_layers = {'sol_complet': rgba(sol768, np.ones((H, W), bool))}
    for k in order:
        raw_layers[k] = rgba(c768[k], m768[k])

    pal_groups = {
        'sable': (['sol_complet', 'chemin_sable'], 48),
        'roche_ocre': (['cailloux', 'piliers_roche', 'falaise_ocre', 'autel_corne'], 64),
        'roche_sombre': (['falaise_sombre'], 48),
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
        ('piliers_roche', f'{PFX}_04_piliers_roche.png'),
        ('falaise_ocre', f'{PFX}_05_falaise_ocre.png'),
        ('falaise_sombre', f'{PFX}_06_falaise_sombre.png'),
        ('autel_corne', f'{PFX}_07_autel_corne.png'),
    ]
    for k, fn in fixed_names:
        Image.fromarray(layers[k]).save(OUT / 'calques' / fn)

    poses = EMH.extract_wind_poses()
    EMH.write_planche(poses, OUT / 'review' / f'{PFX}_planche_poses.png')
    vent_frames, _ = EMH.anim_frames(poses)
    lueur_frames = lueur_autel_frames()
    for t in range(PHASES):
        Image.fromarray(vent_frames[t]).save(OUT / 'animation/vent_sable' / f'{PFX}_08_vent_sable_f{t:02d}.png')
        Image.fromarray(lueur_frames[t]).save(OUT / 'animation/lueur_autel' / f'{PFX}_09_lueur_autel_f{t:02d}.png')

    walk = m768['chemin_sable'] | m768['cailloux']
    blocked = cell_grid(~walk)
    blocked[:6, :] = True
    blocked[:, :2] = True
    blocked[:, -2:] = True
    blocked[28:, 46:50] = False

    entry_px = [384, 560]
    boss_px = [376, 336]
    objectif_px = [376, 232]
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
        im.alpha_composite(Image.fromarray(vent_frames[t]))
        im.alpha_composite(Image.fromarray(lueur_frames[t]))
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
    ora_layers[f'{PFX}_08_vent_sable_f00'] = vent_frames[0]
    ora_layers[f'{PFX}_09_lueur_autel_f00'] = lueur_frames[0]
    BM.write_ora(OUT / f'{PFX}_fin_mt_horn_calques.ora', ora_layers)

    stack = [(f'{i:02d}_{k}', [layers[k]], 1) for i, (k, _) in enumerate(fixed_names)] + [
        ('08_vent_sable', vent_frames, TICKS),
        ('09_lueur_autel', lueur_frames, TICKS),
    ]
    markers = {'entrance': entry_px, 'boss': boss_px, 'objectif': objectif_px}
    tiles_info = _run_ground_project(stack, blocked, markers, STAGE, NAMESPACE, ASSET, PFX, 'Fin Mt. Horn — Sanctuaire du Monolithe Cornu')

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
        f'animation/lueur_autel/{PFX}_09_lueur_autel_f00..f23.png',
    ]
    manifest = {
        'lot': 'source/fin_mt_horn_v1',
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'cell_px': 8,
        'orientation': 'cul-de-sac (entree sud -> boss central -> objectif nord)',
        'method': 'rendu genere reference sur Mt_Horn_entrance_Sky.png ; sol_complet = plage 96x96 du brut en miroir ; decoupe multicalque native 8 px',
        'reference_rip': {'file': REF_NAME, 'sha256': sha(REF), 'size': [int(ref.shape[1]), int(ref.shape[0])]},
        'raw_inputs': [
            {**GEN[0], 'file': 'source/fin_mt_horn_v1/bruts/decor.png', 'sha256': sha(RAW / 'decor.png'), 'size': list(SRC)},
            {**GEN[1], 'file': 'source/fin_mt_horn_v1/bruts/touffes_vent_poses.png', 'sha256': sha(RAW / 'touffes_vent_poses.png'), 'size': [1104, 960]},
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
                'lueur_autel': {'frames': PHASES, 'frame_length_ticks': TICKS, 'loop_ticks': LOOP_TICKS},
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
