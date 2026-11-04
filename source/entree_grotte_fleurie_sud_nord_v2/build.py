"""Entrée Grotte Fleurie sud -> nord V2 (EGF2) — map PLUS LONGUE, chemin sinueux.

Demande : « fait la v2 la map était plus grande en longueur avec chemin etc stp ».
Format 2:3 PORTRAIT LONG : 768 x 1152 px (96 x 144 cases de 8 px), soit deux fois la hauteur
d'EGF1 (768x576). Le chemin de sable rosé entre au sud et serpente en S sur toute la hauteur
jusqu'à la bouche de grotte au nord.
Méthode identique à EGF1 (rendu généré référencé sur la capture utilisateur + étalonnage par
matière + réduction par classe), socle réutilisé : classifieur, poses, palettes d'EGF1.
Sol : quilting d'herbe saine prélevée dans le décor V2 (pas de second rendu).
Animations : fleurs au vent 8 x 10 ticks + 6 papillons 48 x 5 ticks. Scène PPCM 240 ticks.
Lancer : .venv/bin/python source/entree_grotte_fleurie_sud_nord_v2/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, math, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
OUT = R / 'renders/entree_grotte_fleurie_sud_nord_v2'
STAGE = R / '.cache/entree_grotte_fleurie_sud_nord_v2/entree_grotte_fleurie_sud_nord_v2'
NAMESPACE = 'entree_grotte_fleurie_sud_nord_v2'
ASSET = 'egf2_entree_grotte_fleurie'
PFX = 'EGF2'
W, H = 768, 1152                       # 2:3 portrait long, 96 x 144 cases
SRC = (848, 1264)
SCALE = H / SRC[1]                     # 0.911392
SCALED_W = round(SRC[0] * SCALE)       # 773
CROP_X = (SCALED_W - W) // 2           # 2
FLOWER_PHASES, FLOWER_TICKS = 8, 10
FLY_PHASES, FLY_TICKS = 48, 5
LOOP_TICKS = math.lcm(FLOWER_PHASES * FLOWER_TICKS, FLY_PHASES * FLY_TICKS)   # 240
BCELL = 24
FIDELITY_MAX = 35


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('egf1_build', R / 'source/entree_grotte_fleurie_sud_nord_v1/build.py')
# Le socle EGF1 lit sa géométrie au moment de l'appel : on la bascule sur le format long.
V1.W, V1.H, V1.SRC, V1.SCALE, V1.SCALED_W, V1.CROP_X = W, H, SRC, SCALE, SCALED_W, CROP_X
V1.BM.W, V1.BM.H = W, H
V1.RAW = RAW                           # planche de papillons réutilisée (copie locale)
REF = V1.REF                           # capture utilisateur d'origine (cibles colorimétriques)
BM = V1.BM
cell_grid, write_ora = BM.cell_grid, BM.write_ora
MATERIAL_ORDER, FIDELITY_SEUIL = V1.MATERIAL_ORDER, FIDELITY_MAX


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


# ---------------------------------------------------------------- Ground PMDO 0.8.12
def ground_project(stack, blocked, markers, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    with zipfile.ZipFile(R / 'mod_metano_expeditions_pmdo_0812.zip') as z:
        tpl = json.loads(z.read('metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground'))
    o = tpl['Object']; gw, gh = W // 8, H // 8; layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        bank = gfx.TileBank(f'{PFX}_{i:02d}_{title.split()[0].upper()}')
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
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')
    o.update(Name={'DefaultText': 'Entree Grotte Fleurie V2 - sud vers nord (long)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. EGF2 : version longue (768x1152) de la recreation de la capture PMDO utilisateur. '
                     'Chemin de sable en S du sud a la grotte. Fleurs au vent + papillons generes. Collisions a verifier. Seuil non raccorde.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk(n, p) for n, p in markers]}]
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
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Entree Grotte Fleurie V2 (long) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : version longue 768x1152 de l'entree Grotte Fleurie (recreation de la capture PMDO utilisateur), chemin de sable en S, fleurs au vent et papillons. Pas une aventure jouable.</Description>
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


# ---------------------------------------------------------------- main
def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1access = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    for d in ['calques', 'animation/fleurs', 'animation/papillons', 'poses_papillons', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    a0 = rgb(RAW / 'decor_magenta.png')
    assert a0.shape[:2] == (SRC[1], SRC[0])
    targets = V1.reference_targets()
    a_clean, moss = V1.clean_moss(a0)
    Image.fromarray((moss * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_mousse_nettoyee.png')
    sol = V1.quilt_sol(a_clean)                     # herbe saine prélevée dans le décor V2
    sol, _ = V1.color_correct(sol, targets)
    Image.fromarray(sol).save(RAW / 'sol_complet.png')
    m = V1.complete_masks(V1.classify(a_clean), protect_cave=True)
    a, corr_stats = V1.color_correct(a_clean, targets)
    Image.fromarray(a).save(OUT / 'review' / f'{PFX}_decor_etalo.png')
    order = ['cave', 'grass', 'path', 'boulder', 'bush', 'flower', 'rock']
    ex, cols = V1.down_class(a, m, order)
    layers = {
        'sol_complet': V1.rgba(V1.down_full(sol), np.ones((H, W), bool)),
        'entree_sombre': V1.cave_fill(ex['cave']),
        'herbe': V1.rgba(cols['grass'], ex['grass']),
        'sentier': V1.rgba(cols['path'], ex['path']),
        'rochers': V1.rgba(cols['boulder'], ex['boulder']),
        'buissons': V1.rgba(cols['bush'], ex['bush']),
        'falaises': V1.rgba(cols['rock'], ex['rock']),
    }
    flower_static = V1.rgba(cols['flower'], ex['flower'])
    layers = V1.quantize_layers(layers)
    fm = flower_static[..., 3] == 255
    if fm.any():
        fq = Image.fromarray(flower_static[fm][:, :3].reshape(-1, 1, 3)).quantize(32, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
        flower_static[..., :3] = np.array(fq.getpalette()[:96], 'uint8').reshape(-1, 3)[np.array(Image.fromarray(flower_static[..., :3]).quantize(palette=fq, dither=Image.Dither.NONE))]
    flower_static[~fm] = 0
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    ff, clusters = V1.flower_phases(flower_static, ex['flower'])
    poses = V1.butterfly_poses()
    for nm, seq in poses.items():
        for i, p in enumerate(seq):
            Image.fromarray(p).save(OUT / 'poses_papillons' / f'{PFX}_papillon_{nm}_{i}.png')
    # 6 papillons répartis sur toute la longueur, au-dessus des prairies latérales.
    flights = [((210, 330), (52, 30), 0, 'jaune'), ((560, 400), (56, 32), 17, 'bleu'),
               ((180, 640), (48, 28), 31, 'bleu'), ((600, 720), (52, 30), 8, 'jaune'),
               ((250, 900), (56, 32), 24, 'jaune'), ((540, 1010), (50, 28), 40, 'bleu')]
    bf = [np.zeros((H, W, 4), 'uint8') for _ in range(FLY_PHASES)]; tracks = []
    for (cx, cy), (ax, ay), off, colr in flights:
        pts = []
        for t in range(FLY_PHASES):
            u = 2 * np.pi * (t + off) / FLY_PHASES
            x = int(round(cx + ax * np.sin(u))); y = int(round(cy + ay * np.sin(2 * u)))
            p = poses[colr][(t + off) % 6]; mm = p[..., 3] > 0
            x0, y0 = x - BCELL // 2, y - BCELL // 2
            assert 0 <= x0 and x0 + BCELL <= W and 0 <= y0 and y0 + BCELL <= H
            bf[t][y0:y0 + BCELL, x0:x0 + BCELL][mm] = p[mm]; pts.append([x, y])
        tracks.append({'centre': [cx, cy], 'amplitude': [ax, ay], 'decalage': off, 'couleur': colr, 'positions': pts})
    for t, fr in enumerate(ff):
        Image.fromarray(fr).save(OUT / 'animation/fleurs' / f'{PFX}_03_fleurs_vent_f{t}.png')
    for t, fr in enumerate(bf):
        Image.fromarray(fr).save(OUT / 'animation/papillons' / f'{PFX}_08_papillons_f{t:02d}.png')
    numbers = {'sol_complet': 0, 'entree_sombre': 1, 'herbe': 2, 'sentier': 4, 'rochers': 5, 'buissons': 6, 'falaises': 7}
    files = {}
    for nm, nb in numbers.items():
        fn = f'{PFX}_{nb:02d}_{nm}.png'; Image.fromarray(layers[nm]).save(OUT / 'calques' / fn); files[nm] = fn
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('entree_sombre', [layers['entree_sombre']], 60),
                   ('herbe', [layers['herbe']], 60), ('fleurs_vent', ff, FLOWER_TICKS),
                   ('sentier', [layers['sentier']], 60), ('rochers', [layers['rochers']], 60),
                   ('buissons', [layers['buissons']], 60), ('falaises', [layers['falaises']], 60),
                   ('papillons', bf, FLY_TICKS)]
    walk = (layers['herbe'][..., 3] == 255) | (layers['sentier'][..., 3] == 255) | ex['flower']
    walk &= ~((layers['rochers'][..., 3] > 0) | (layers['buissons'][..., 3] > 0) | (layers['falaises'][..., 3] > 0) | ex['cave'])
    blocked = cell_grid(~walk)
    gh_, gw_ = blocked.shape
    px = np.nonzero(layers['sentier'][H - 8, :, 3])[0]; med = int(np.median(px)) // 8
    cx = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [cx * 8, H - 16]
    gy, gx = np.nonzero(ex['cave']); threshold_px = [int(gx.mean()) // 8 * 8 - 8, (int(gy.max()) + 8) // 8 * 8]
    while blocked[threshold_px[1] // 8:threshold_px[1] // 8 + 2, threshold_px[0] // 8:threshold_px[0] // 8 + 2].any():
        threshold_px[1] += 8
    ok, explored = v1access.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert ok, 'pas de chemin 16x16 sur la longueur'
    # Longueur réelle du chemin praticable (nombre de cases du BFS le plus court en 16x16).
    path_len = int(np.count_nonzero(layers['sentier'][..., 3] == 255)) // 64

    def scene(tick):
        flp = (tick // FLOWER_TICKS) % FLOWER_PHASES; fp = (tick // FLY_TICKS) % FLY_PHASES
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[{'fleurs_vent': flp, 'papillons': fp}.get(title, 0)]))
        return im
    scenes = [scene(t * 5) for t in range(LOOP_TICKS // 5)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(5 * 1000 / 60), loop=0, lossless=True)
    fid = V1.fidelity(a)
    for k, v in fid.items():
        assert v['distance'] < FIDELITY_MAX, (k, v)
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    write_ora(OUT / f'{PFX}_entree_grotte_fleurie_longue_calques.ora',
              {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked,
                            [('entrance', entry_px), ('donjon_seuil', threshold_px)], gfx, tools)
    order_files = [f'calques/{files["sol_complet"]}', f'calques/{files["entree_sombre"]}', f'calques/{files["herbe"]}',
                   f'animation/fleurs/{PFX}_03_fleurs_vent_fX.png', f'calques/{files["sentier"]}', f'calques/{files["rochers"]}',
                   f'calques/{files["buissons"]}', f'calques/{files["falaises"]}', f'animation/papillons/{PFX}_08_papillons_fXX.png']
    manifest = {
        'lot': 'entree_grotte_fleurie_sud_nord_v2', 'format': '2:3 portrait long', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'EGF1 allongee : rendu genere 2:3 reference sur la capture utilisateur, sol quilte depuis le decor, '
                  'etalonnage par matiere, reduction par classe, palette commune 96 + fleurs 32',
        'reference_da': 'source/entree_grotte_fleurie_sud_nord_v1/reference/capture_pmdo_source.png (capture PMDO utilisateur)',
        'variante_de': 'entree_grotte_fleurie_sud_nord_v1',
        'demande': 'la map etait plus grande en longueur avec chemin',
        'raw_inputs': [{'file': f'source/entree_grotte_fleurie_sud_nord_v2/bruts/{n}', 'sha256': sha(RAW / n),
                        'size': list(Image.open(RAW / n).size)} for n in ['decor_magenta.png', 'sol_complet.png', 'papillons_poses.png']],
        'normalization': {'scale': SCALE, 'scaled': [SCALED_W, H], 'crop_x': [CROP_X, SCALED_W - W - CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive, palette commune 96 couleurs'},
        'etalonnage': {'cibles': {k: list(v) for k, v in targets.items()}, 'stats': corr_stats},
        'layer_order_bottom_to_top': order_files,
        'flowers': {'phases': FLOWER_PHASES, 'frame_length_ticks': FLOWER_TICKS, 'clusters': clusters,
                    'modele': 'cisaillement horizontal ancre au pied, amplitude 1.6 px, 8 phases fermees',
                    'origine': 'pixels des fleurs du decor genere, mouvement cree par nous'},
        'butterflies': {'brut': 'source/entree_grotte_fleurie_sud_nord_v2/bruts/papillons_poses.png (reutilise EJN1/EGF1)',
                        'poses_par_couleur': 6, 'phases': FLY_PHASES, 'frame_length_ticks': FLY_TICKS,
                        'loop_s': FLY_PHASES * FLY_TICKS / 60, 'trajectoires': tracks,
                        'origine': 'dessin GENERE, trajectoires creees ; pas une animation officielle'},
        'cave': {'modele': 'remplissage procedural degrade sombre + strates discretes', 'origine': 'genere'},
        'water': None,
        'scene_loop_ticks': LOOP_TICKS,
        'fidelity': {'seuil': FIDELITY_MAX, 'mesures': fid},
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': ok, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'sentier_surface_cases_approx': path_len,
                   'rule': 'case bloquee si > 25 % hors herbe/sentier/fleurs'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(json.dumps({'format': [W, H], 'fleurs_clusters': len(clusters), 'entry': entry_px, 'threshold': threshold_px,
                      'blocked': int(blocked.sum()), 'cells': int(blocked.size), 'tiles': counts,
                      'fidelite': {k: v['distance'] for k, v in fid.items()}}, indent=1, ensure_ascii=False))


if __name__ == '__main__':
    build()
