"""Fin Grotte Fleurie V1 (FGF1) — le FOND de la Grotte Fleurie (salle ultime / arène).

Demande : « et fait le fond de la Grotte fleurie ».
Prolonge EGF1/EGF2 : salle fermée au fond du donjon, parois ocre stratifiées sur les quatre
côtés, sol d'herbe tapiissé de fleurs R/J/B, chemin de sable rosé du sud vers une clairière
centrale, autel fleuri sur estrade de pierre au nord devant un passage sombre (magenta).
Format 4:3 vaste 768 x 576 (96 x 72 cases), comme les autres fins de la série.
Méthode EGF1 (rendu généré référencé + étalonnage par matière + réduction par classe).
Animations : fleurs au vent 8x10, lueur de l'autel 12x10, pétales qui tombent 24x5.
Scène : PPCM 240 ticks = 4 s. Marqueurs entrance / boss / objectif, aucun warp.
Lancer : .venv/bin/python source/fin_grotte_fleurie_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, math, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
OUT = R / 'renders/fin_grotte_fleurie_v1'
STAGE = R / '.cache/fin_grotte_fleurie_v1/fin_grotte_fleurie'
NAMESPACE = 'fin_grotte_fleurie'
ASSET = 'fgf1_fin_grotte_fleurie'
PFX = 'FGF1'
W, H = 768, 576
SRC = (1200, 896)
SCALE = H / SRC[1]
SCALED_W = round(SRC[0] * SCALE)       # 771
CROP_X = (SCALED_W - W) // 2           # 1
FLOWER_PHASES, FLOWER_TICKS = 8, 10
GLOW_PHASES, GLOW_TICKS = 12, 10
PETAL_PHASES, PETAL_TICKS = 24, 5
LOOP_TICKS = math.lcm(FLOWER_PHASES * FLOWER_TICKS, GLOW_PHASES * GLOW_TICKS, PETAL_PHASES * PETAL_TICKS)  # 240
FIDELITY_MAX = 35
PETAL_SPAN, PETAL_STEP, PETAL_TOP = 288, 12, 230      # 24 x 12 = 288 -> boucle verticale fermée


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('egf1_build', R / 'source/entree_grotte_fleurie_sud_nord_v1/build.py')
V1.W, V1.H, V1.SRC, V1.SCALE, V1.SCALED_W, V1.CROP_X = W, H, SRC, SCALE, SCALED_W, CROP_X
V1.BM.W, V1.BM.H = W, H
BM = V1.BM
cell_grid, write_ora = BM.cell_grid, BM.write_ora
KEYS = ['cave', 'path', 'altar', 'rock', 'boulder', 'bush', 'flower', 'grass']


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def classify_room(a):
    """Salle fermée : socle EGF1 + autel de pierre claire (estrade + fleur) au nord."""
    m = V1.classify(a)
    lum = a @ [.299, .587, .114]; sat = a.max(2) - a.min(2)
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    zone = (yy > 140) & (yy < 420) & (xx > 420) & (xx < 800)
    pale = (lum > 165) & (sat < 70) & zone
    # Silhouette pleine : la fermeture large puis le remplissage englobent la mosaïque et les
    # fleurs posées SUR l'autel, sinon elles partent en herbe/fleurs et sont repeintes en vert.
    altar = nd.binary_fill_holes(nd.binary_closing(pale, iterations=7))
    altar = V1.keep_large(altar, 2000)
    altar = nd.binary_dilation(altar, iterations=2) & ~m['cave']
    for k in ('rock', 'boulder', 'bush', 'flower', 'grass', 'path'):
        m[k] = m[k] & ~altar
    m['altar'] = altar
    # Exclusivité + couverture totale, grotte protégée (les stalactites restent de la roche).
    labels = np.zeros(a.shape[:2], np.int8)
    for i, k in enumerate(KEYS, 1):
        labels[m[k]] = i
    unc = labels == 0
    if unc.any():
        _, inds = nd.distance_transform_edt(unc | (labels == 1), return_indices=True)
        filled = labels[inds[0], inds[1]]
        for i, k in enumerate(KEYS, 1):
            if k == 'cave':
                continue
            m[k] = m[k] | (unc & (filled == i))
    taken = np.zeros(a.shape[:2], bool)
    for k in KEYS:
        m[k] = m[k] & ~taken
        taken |= m[k]
    return m


def dedicated_palette(layer, n):
    """Palette propre à un calque de petite surface (fleurs, autel) : la palette commune
    96 couleurs écraserait ses dégradés. Alpha conservé, uniquement les pixels opaques."""
    m = layer[..., 3] == 255
    if not m.any():
        return layer
    px = layer[m][:, :3]
    q = Image.fromarray(px.reshape(-1, 1, 3)).quantize(n, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    pal = np.array(q.getpalette()[:n * 3], 'uint8').reshape(-1, 3)
    idx = np.array(Image.fromarray(layer[..., :3]).quantize(palette=q, dither=Image.Dither.NONE))
    out = layer.copy()
    out[..., :3] = pal[idx]
    out[~m] = 0
    return out


BAYER4 = np.array([[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]], float) / 16


def glow_phases(altar_mask):
    """Halo qui épouse la silhouette de l'autel et respire. Dégradé obtenu en tramage ordonné
    (Bayer 4x4) pour rester en alpha BINAIRE, exigence des tuiles PMDO. 12 phases fermées."""
    d = nd.distance_transform_edt(~altar_mask)
    yy, xx = np.mgrid[:H, :W]
    frames = []
    for t in range(GLOW_PHASES):
        span = 7.0 + 2.5 * math.sin(2 * math.pi * t / GLOW_PHASES)
        inten = np.clip(1.0 - (d - 1.0) / span, 0, 1) * 0.55
        thresh = np.roll(np.roll(BAYER4, t % 4, axis=0), (t * 3) % 4, axis=1)
        keep = (d > 1.0) & (inten > np.tile(thresh, (H // 4 + 1, W // 4 + 1))[:H, :W])
        a = np.zeros((H, W, 4), 'uint8')
        a[keep] = (255, 238, 178, 255)
        a[keep & (d < 3.0)] = (255, 250, 220, 255)
        frames.append(a)
    return frames


def petal_phases(colors, seed=17):
    """Pétales qui tombent en oscillant ; défilement vertical modulo PETAL_SPAN -> boucle fermée."""
    rng = np.random.default_rng(seed)
    sprite = np.array([[0, 1, 1, 0], [1, 1, 1, 1], [0, 1, 1, 0], [0, 0, 1, 0]], bool)
    petals = []
    for i in range(28):
        petals.append({'x0': int(rng.integers(70, W - 70)), 'y0': int(rng.integers(0, PETAL_SPAN)),
                       'couleur': i % 3, 'decalage': int(rng.integers(0, PETAL_PHASES))})
    frames = [np.zeros((H, W, 4), 'uint8') for _ in range(PETAL_PHASES)]
    for t in range(PETAL_PHASES):
        for p in petals:
            y = PETAL_TOP + ((p['y0'] + t * PETAL_STEP) % PETAL_SPAN)
            x = p['x0'] + int(round(3 * math.sin(2 * math.pi * (t + p['decalage']) / PETAL_PHASES)))
            if not (0 <= x and x + 4 <= W and 0 <= y and y + 4 <= H):
                continue
            frames[t][y:y + 4, x:x + 4][sprite] = (*colors[p['couleur']], 255)
    return frames, petals


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
    o.update(Name={'DefaultText': 'Fin Grotte Fleurie - fond du donjon (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. FGF1 : fond de la Grotte Fleurie (salle ultime). Parois ocre, sol fleuri, autel au nord. '
                     'Fleurs au vent, lueur et petales generes. Collisions a verifier. Aucune sortie, aucun warp.')
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
             f'-- {ASSET} : fond de donjon, aucune sortie, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Grotte Fleurie - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Fond de la Grotte Fleurie : salle ultime fleurie, autel au nord, arene centrale. Fleurs au vent, lueur et petales animes. Pas une aventure jouable.</Description>
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
    access = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    for d in ['calques', 'animation/fleurs', 'animation/lueur', 'animation/petales', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    a0 = rgb(RAW / 'decor_magenta.png')
    assert a0.shape[:2] == (SRC[1], SRC[0])
    targets = V1.reference_targets()
    a_clean, moss = V1.clean_moss(a0)
    Image.fromarray((moss * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_mousse_nettoyee.png')
    sol = V1.quilt_sol(a_clean)
    sol, _ = V1.color_correct(sol, targets)
    Image.fromarray(sol).save(RAW / 'sol_complet.png')
    m = classify_room(a_clean)
    a, corr_stats = V1.color_correct(a_clean, targets)
    a[m['altar']] = a_clean[m['altar']]        # l'autel garde ses couleurs d'origine (pierre + mosaique)
    Image.fromarray(a).save(OUT / 'review' / f'{PFX}_decor_etalo.png')
    order = ['cave', 'grass', 'path', 'boulder', 'bush', 'flower', 'altar', 'rock']
    ex, cols = V1.down_class(a, m, order)
    layers = {
        'sol_complet': V1.rgba(V1.down_full(sol), np.ones((H, W), bool)),
        'passage_sombre': V1.cave_fill(ex['cave']),
        'herbe': V1.rgba(cols['grass'], ex['grass']),
        'sentier': V1.rgba(cols['path'], ex['path']),
        'rochers': V1.rgba(cols['boulder'], ex['boulder']),
        'autel': V1.rgba(cols['altar'], ex['altar']),
        'parois': V1.rgba(cols['rock'], ex['rock']),
    }
    flower_static = V1.rgba(cols['flower'], ex['flower'])
    layers = V1.quantize_layers(layers)
    layers['autel'] = dedicated_palette(layers['autel'], 32)
    flower_static = dedicated_palette(flower_static, 32)
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    ff, clusters = V1.flower_phases(flower_static, ex['flower'])
    ay, ax = np.nonzero(ex['altar'])
    acx, acy = int(ax.mean()), int(ay.mean())
    gf = glow_phases(ex['altar'])
    fm = flower_static[..., 3] == 255
    fpx = flower_static[fm][:, :3].astype(int)
    uniq = [tuple(int(v) for v in c) for c in np.unique(fpx, axis=0)] if len(fpx) else []
    freq = {c: int((fpx == c).all(1).sum()) for c in uniq}
    # Une couleur de pétale par famille (rouge / jaune / bleu) pour rappeler les trois bouquets.
    families = [lambda c: c[0] > c[1] + 80 and c[0] > c[2] + 80,
                lambda c: c[0] > 140 and c[1] > 120 and c[2] < c[1] - 40 and c[0] <= c[1] + 60,
                lambda c: c[2] > c[0] + 30]
    fcols = []
    for pred in families:
        cand = [c for c in uniq if pred(c) and freq[c] >= 150]
        # la teinte la plus claire de la famille : un pétale sombre se perdrait sur l'herbe
        best = max(cand, key=lambda c: 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]) if cand else (230, 187, 86)
        fcols.append(best)
    pf, petals = petal_phases(fcols)
    for t, fr in enumerate(ff):
        Image.fromarray(fr).save(OUT / 'animation/fleurs' / f'{PFX}_03_fleurs_vent_f{t}.png')
    for t, fr in enumerate(gf):
        Image.fromarray(fr).save(OUT / 'animation/lueur' / f'{PFX}_07_lueur_autel_f{t:02d}.png')
    for t, fr in enumerate(pf):
        Image.fromarray(fr).save(OUT / 'animation/petales' / f'{PFX}_09_petales_f{t:02d}.png')
    numbers = {'sol_complet': 0, 'passage_sombre': 1, 'herbe': 2, 'sentier': 4, 'rochers': 5, 'autel': 6, 'parois': 8}
    files = {}
    for nm, nb in numbers.items():
        fn = f'{PFX}_{nb:02d}_{nm}.png'; Image.fromarray(layers[nm]).save(OUT / 'calques' / fn); files[nm] = fn
    stack_named = [('sol_complet', [layers['sol_complet']], 60), ('passage_sombre', [layers['passage_sombre']], 60),
                   ('herbe', [layers['herbe']], 60), ('fleurs_vent', ff, FLOWER_TICKS),
                   ('sentier', [layers['sentier']], 60), ('rochers', [layers['rochers']], 60),
                   ('autel', [layers['autel']], 60), ('lueur_autel', gf, GLOW_TICKS),
                   ('parois', [layers['parois']], 60), ('petales', pf, PETAL_TICKS)]
    # Collisions : sol fleuri et sentier praticables ; parois, rochers, autel et passage bloquent.
    walk = (layers['herbe'][..., 3] == 255) | (layers['sentier'][..., 3] == 255) | ex['flower']
    walk &= ~((layers['rochers'][..., 3] > 0) | (layers['parois'][..., 3] > 0) | (layers['autel'][..., 3] > 0) | ex['cave'])
    blocked = cell_grid(~walk)
    gh_, gw_ = blocked.shape
    free = np.zeros_like(blocked)
    for y in range(gh_ - 1):
        for x in range(gw_ - 1):
            free[y, x] = not blocked[y:y + 2, x:x + 2].any()
    px = np.nonzero(layers['sentier'][H - 8, :, 3])[0]; med = int(np.median(px)) // 8
    cx = min((c for c in range(gw_ - 1) if free[gh_ - 2:, c].any()), key=lambda c: abs(c - med))
    entry_px = [cx * 8, H - 16]
    # Objectif : au pied de l'autel, sur le sentier ; Boss : plus large zone libre près du centre.
    obj_y = (int(ay.max()) + 8) // 8 * 8
    obj_x = acx // 8 * 8 - 8
    while obj_y < H - 24 and not free[obj_y // 8:obj_y // 8 + 1, obj_x // 8:obj_x // 8 + 1].all():
        obj_y += 8
    assert free[obj_y // 8, obj_x // 8], 'pied de l autel non praticable'
    objectif_px = [obj_x, obj_y]
    big = np.zeros_like(blocked)
    for y in range(gh_ - 3):
        for x in range(gw_ - 3):
            big[y, x] = not blocked[y:y + 4, x:x + 4].any()
    cand = np.argwhere(big)
    assert len(cand), 'aucune zone libre 32x32 pour le boss'
    ty, tx = int(H * 0.60) // 8, W // 2 // 8
    by, bx = min(cand, key=lambda p: (p[0] - ty) ** 2 + (p[1] - tx) ** 2)
    boss_px = [int(bx) * 8, int(by) * 8]
    ok, explored = access.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (objectif_px[1] // 8, objectif_px[0] // 8))
    assert ok, 'pas de chemin 16x16 entree -> autel'
    okb, _ = access.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    assert okb, 'arene centrale inaccessible'

    def scene(tick):
        flp = (tick // FLOWER_TICKS) % FLOWER_PHASES
        gp = (tick // GLOW_TICKS) % GLOW_PHASES
        pp = (tick // PETAL_TICKS) % PETAL_PHASES
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[{'fleurs_vent': flp, 'lueur_autel': gp, 'petales': pp}.get(title, 0)]))
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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 90, 90, 255)), (objectif_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    write_ora(OUT / f'{PFX}_fin_grotte_fleurie_calques.ora',
              {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked,
                            [('entrance', entry_px), ('boss', boss_px), ('objectif', objectif_px)], gfx, tools)
    order_files = [f'calques/{files["sol_complet"]}', f'calques/{files["passage_sombre"]}', f'calques/{files["herbe"]}',
                   f'animation/fleurs/{PFX}_03_fleurs_vent_fX.png', f'calques/{files["sentier"]}', f'calques/{files["rochers"]}',
                   f'calques/{files["autel"]}', f'animation/lueur/{PFX}_07_lueur_autel_fXX.png', f'calques/{files["parois"]}',
                   f'animation/petales/{PFX}_09_petales_fXX.png']
    manifest = {
        'lot': 'fin_grotte_fleurie_v1', 'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'fond de donjon : rendu genere 4:3 reference sur la capture utilisateur et le decor EGF1, '
                  'sol quilte, etalonnage par matiere, reduction par classe, palette commune 96 + fleurs 32',
        'reference_da': 'source/entree_grotte_fleurie_sud_nord_v1/reference/capture_pmdo_source.png (capture PMDO utilisateur)',
        'prolonge': ['entree_grotte_fleurie_sud_nord_v1', 'entree_grotte_fleurie_sud_nord_v2'],
        'demande': 'fait le fond de la Grotte fleurie',
        'raw_inputs': [{'file': f'source/fin_grotte_fleurie_v1/bruts/{n}', 'sha256': sha(RAW / n),
                        'size': list(Image.open(RAW / n).size)} for n in ['decor_magenta.png', 'sol_complet.png']],
        'normalization': {'scale': SCALE, 'scaled': [SCALED_W, H], 'crop_x': [CROP_X, SCALED_W - W - CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive, palette commune 96 couleurs'},
        'etalonnage': {'cibles': {k: list(v) for k, v in targets.items()}, 'stats': corr_stats},
        'segmentation': 'socle EGF1 + autel = pierre claire (lum>165, sat<70) dans la zone nord, dilate 2 px ; '
                        'parois = ocre touchant les bords ; grotte protegee lors du remplissage des pixels non classes',
        'layer_order_bottom_to_top': order_files,
        'flowers': {'phases': FLOWER_PHASES, 'frame_length_ticks': FLOWER_TICKS, 'clusters': clusters,
                    'modele': 'cisaillement ancre au pied, 8 phases fermees', 'origine': 'pixels du decor genere, mouvement cree par nous'},
        'glow': {'phases': GLOW_PHASES, 'frame_length_ticks': GLOW_TICKS, 'centre': [acx, acy],
                 'modele': 'halo trame damier, rayon 30 +/- 5 px, alpha binaire', 'origine': 'genere'},
        'petals': {'phases': PETAL_PHASES, 'frame_length_ticks': PETAL_TICKS, 'nombre': len(petals),
                   'span': PETAL_SPAN, 'step': PETAL_STEP, 'couleurs': [list(c) for c in fcols],
                   'modele': 'chute 12 px/phase modulo 288 + oscillation 3 px, boucle fermee', 'origine': 'genere',
                   'placements': petals},
        'water': None,
        'scene_loop_ticks': LOOP_TICKS,
        'fidelity': {'seuil': FIDELITY_MAX, 'mesures': fid},
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objectif_px': objectif_px,
                   'path_found_16x16': ok, 'arene_accessible': okb, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors herbe/sentier/fleurs'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun', 'sortie': 'aucune (fond de donjon)'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(json.dumps({'fleurs_clusters': len(clusters), 'petales': len(petals), 'entry': entry_px, 'boss': boss_px,
                      'objectif': objectif_px, 'blocked': int(blocked.sum()), 'tiles': counts,
                      'fidelite': {k: v['distance'] for k, v in fid.items()}}, indent=1, ensure_ascii=False))


if __name__ == '__main__':
    build()
