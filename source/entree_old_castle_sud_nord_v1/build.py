"""Entrée Old Castle sud -> nord V1 (EOC1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « passe au prochaine map » puis « continue la suite » (20 octobre, après l'abandon du
réseau Métano généré pièce par pièce). Référence `oldcastlepmd.png` (408 x 408) : salle au trésor
d'un vieux château (briques beige, grand médaillon circulaire sculpté, piliers et coffres dorés).
Seule capture de la racine libre partout (relevés des 27 septembre sur toutes les branches).
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor.png : décor complet 4:3 (1200 x 896), premier essai, validé par l'utilisateur ;
- sol_complet.png : sol de briques beige seul (texture générée d'après le rip, fond plein).
Calques : sol complet, sol, ombres, médaillon, Alcôve (plateforme au trésor), éboulis (blocs de
pierre dans la salle), trésor (coffres, statues et monceaux d'or), parois, vide (magenta).
Animation sur son calque, boucle fermée 24 x 5 ticks : scintillement — éclats dorés qui
apparaissent et s'éteignent sur le trésor et les piliers (dessin créé, couleurs du décor).
Scène : PPCM(120, 120) = 120 ticks = 2 s.
Lancer : .venv/bin/python source/entree_old_castle_sud_nord_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'oldcastlepmd.png'
REF = R / REF_NAME
OUT = R / 'renders/entree_old_castle_sud_nord_v1'
STAGE = R / '.cache/entree_old_castle_sud_nord_v1/entree_old_castle_sud_nord'
NAMESPACE = 'entree_old_castle_sud_nord'
ASSET = 'eoc1_entree_old_castle'
PFX = 'EOC1'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/entree_old_castle_sud_nord_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Decor complet 4:3 reference sur le rip Old Castle (salle au tresor : briques beige, medaillon '
     'circulaire sculpte, piliers et coffres dores) : interieur de chateau en ruines, entree au sud '
     'centree, chemin degage vers le nord, grande arene centrale au medaillon, Alcôve au tresor au '
     'nord avec coffres dores, piliers brises et eboulis sur les cotes, fond magenta pur.',
     'essais': 'premier essai ; valide par l utilisateur (« continue la suite »)'},
    {'file': 'sol_complet.png', 'images': [REF_NAME], 'prompt':
     'Sol de briques beige pale du rip, plein cadre, rien d autre.',
     'essais': 'troisieme essai (teinte ciblee (230,224,182)) ; distance 22,0 au sol du rip (seuil 35) ; essais 1-2 ecartes (trop orange, puis trop blanc)'},
]
ALCOVE_BOX = (460, 60, 740, 290)      # x0, y0, x1, y1 sur le brut 1200 x 896 : Alcôve au tresor
MEDAILLON = (600, 392, 118)           # cx, cy, rayon mesures sur le brut
# ---- Gravillons relevés sur le rip (boîte y, x, h, w de la composante de roche entourée de sol).
PEBBLES = {'petit': (113, 136, 6, 7), 'moyen': (131, 78, 7, 10), 'gros': (130, 204, 12, 12)}
SPARK_EVERY = 3          # un eclat demarre toutes les 3 phases (8 eclats par boucle)
SPARK_LIFE = 6           # duree de vie d un eclat (phases) : monte puis s eteint
SPARK_N = 28             # nombre d eclats repartis sur l or (tresor, piliers, medaillon)
SPARK_COLS = [(255, 246, 205), (255, 226, 138), (214, 164, 62)]

def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')     # utilitaires génériques
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'pierre': (['sol_complet', 'sol', 'ombres', 'medaillon', 'alcove'], 64),
                  'mur': (['parois', 'eboulis'], 64), 'or': (['tresor'], 96),
                  'sombre': (['vide'], 16)}
STATIC = ['sol', 'ombres', 'medaillon', 'alcove', 'eboulis', 'tresor', 'parois', 'vide']
ANIMS = ['scintillement']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


# ---------------------------------------------------------------- fidélité au rip (même classifieur des deux côtés)
def materials(a):
    """Pierre beige pale (lum > 170, rip (227.7,222.4,174.9)) et or sature (ecart max-min > 85, r > b)."""
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]; lum = lum_of(a)
    sat = np.maximum.reduce([r, g, b]) - np.minimum.reduce([r, g, b])
    return {'pierre': lum > 170, 'or': (sat > 85) & (r > b + 30)}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    """Seuils mesures sur le brut (1200 x 896) : magenta = fond (r > 180, b > 150, g < 120), relié ou non,
    c'est le vide ; sol = lum lissée 5 px > 168 dans la pièce, plus grande composante, trous bouchés ;
    Alcôve = sol de la boîte nord mesurée ALCOVE_BOX ; médaillon = disque mesuré MEDAILLON dans le sol ;
    trésor = or saturé (écart > 85, r > b + 30) dans la boîte Alcôve élargie ou hors sol, plus coffres
    (r-b > 55, g-b > 55, 130 < lum < 205) de la boîte ; îlots hors sol : ceux qui touchent le bord de la
    pièce sont les parois, les intérieurs >= 1200 px sont les piliers dorés, les autres les éboulis ;
    ombres = sol à lum lissée < 200 à <= 28 px d un hors-sol."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    L = nd.uniform_filter(lum, 5)
    mag = (r > 180) & (b > 150) & (g < 120)
    room = keep_large(close_(~mag, 2), 20000)
    floor = keep_large(open_(close_((L > 168) & room, 2), 2), 20000)
    floor = nd.binary_fill_holes(floor) & room
    ax0, ay0, ax1, ay1 = ALCOVE_BOX
    alc_box = np.zeros_like(room); alc_box[ay0:ay1, ax0:ax1] = True
    alcove = floor & alc_box
    cx, cy, rad = MEDAILLON
    med = floor & ((xx - cx) ** 2 + (yy - cy) ** 2 <= rad ** 2)
    sat = np.maximum.reduce([r, g, b]) - np.minimum.reduce([r, g, b])
    tresor = room & ~floor & (sat > 85) & (r > b + 30)
    tresor |= alc_box & room & (r - b > 55) & (g - b > 55) & (lum > 130) & (lum < 205)
    nonsol = room & ~floor & ~tresor
    lab, n = nd.label(nonsol)
    edge_ids = set(np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]])) - {0}
    sizes = nd.sum(nonsol, lab, range(1, n + 1))
    parois = np.isin(lab, list(edge_ids))
    piliers = np.zeros_like(parois)   # l or des statues est capte par tresor (sature) : pas de calque separe
    eboulis = nonsol & ~parois & ~piliers
    db = nd.distance_transform_edt(~(nonsol | tresor))
    omb = floor & ~alcove & ~med & (L < 200) & (db <= 28)
    omb = open_(close_(omb, 2), 1) & floor & ~alcove & ~med
    sol = floor & ~alcove & ~med & ~omb
    vide = ~room
    masks = dict(sol=sol, ombres=omb, medaillon=med, alcove=alcove, eboulis=eboulis,
                 tresor=tresor, parois=parois, vide=vide)
    seg = {'piece_px': int(room.sum()), 'sol_px': int(floor.sum()),
           'piliers': int(sum(1 for i, v in enumerate(sizes) if (i + 1) not in edge_ids and v >= 1200)),
           'eboulis_composantes': int(sum(1 for i, v in enumerate(sizes) if (i + 1) not in edge_ids and v < 1200)),
           'alcove_boite': list(ALCOVE_BOX), 'medaillon': list(MEDAILLON)}
    return masks, seg


# ---------------------------------------------------------------- scintillement (dessin créé)
def spark_positions(gold, rng_seed=7):
    """Points d éclat : centroïdes de composantes d or, complétés par tirage déterministe espacé."""
    lab, n = nd.label(gold)
    pts = []
    for i, c in enumerate(nd.center_of_mass(gold, lab, range(1, n + 1))):
        if not np.isnan(c[0]):
            pts.append((int(c[1]), int(c[0])))
    _ , inds = nd.distance_transform_edt(~gold, return_indices=True)
    pts = [(x, y) if gold[y, x] else (int(inds[1][y, x]), int(inds[0][y, x])) for x, y in pts]
    ys, xs = np.nonzero(gold)
    rng = np.random.default_rng(rng_seed)
    while len(pts) < SPARK_N and len(ys):
        i = int(rng.integers(len(ys))); x, y = int(xs[i]), int(ys[i])
        if all((x - px) ** 2 + (y - py) ** 2 > 28 ** 2 for px, py in pts):
            pts.append((x, y))
    return pts[:SPARK_N]


def spark_frames(pts, ts=range(PHASES)):
    frames = []
    for t in ts:
        fr = np.zeros((H, W, 4), 'uint8')
        for i, (x, y) in enumerate(pts):
            u = (t - i * SPARK_EVERY) % PHASES
            if u >= SPARK_LIFE:
                continue
            k = min(u, SPARK_LIFE - 1 - u)          # 0,1,2,2,1,0 : monte puis s eteint
            col = SPARK_COLS[min(k, 2)]; arm = 1 + k
            for dx, dy in [(0, 0)] + [(d, 0) for d in range(-arm, arm + 1) if d] + [(0, d) for d in range(-arm, arm + 1) if d]:
                X, Y = x + dx, y + dy
                if 0 <= X < W and 0 <= Y < H:
                    fr[Y, X] = (*col, 255)
        frames.append(fr)
    return frames


def paste(frame, spr, x0, y0):
    hh, ww = spr.shape[:2]; x0, y0 = int(x0), int(y0)
    ys0, xs0 = max(0, -y0), max(0, -x0); ys1, xs1 = min(hh, H - y0), min(ww, W - x0)
    if ys1 <= ys0 or xs1 <= xs0:
        return
    s = spr[ys0:ys1, xs0:xs1]; m = s[..., 3] > 0
    frame[y0 + ys0:y0 + ys1, x0 + xs0:x0 + xs1][m] = s[m]


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Entree Old Castle sud-nord V1 (EOC1)')
    stack = ET.SubElement(root, 'stack'); comp = Image.new('RGBA', (W, H))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0', visibility='visible',
                          **{'composite-op': 'svg:src-over'})
            b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO(); comp.save(b, format='PNG'); z.writestr('mergedimage.png', b.getvalue())
        th = comp.copy(); th.thumbnail((256, 256)); b = io.BytesIO(); th.save(b, format='PNG')
        z.writestr('Thumbnails/thumbnail.png', b.getvalue())
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def ground_project(stack, blocked, entry_px, threshold_px, gfx, tools):
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
    o.update(Name={'DefaultText': 'Entree Old Castle - sud vers nord (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Old Castle (salle au tresor) ; '
                     'scintillement dore anime (dessin cree). Collisions de base a verifier. Seuil non '
                     'raccorde. Reference libre partout, choisie pour la suite de la serie.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('donjon_seuil', threshold_px)]}]
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
  <Name>Entree Old Castle sud-nord 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : arrivee au sud, grande salle de chateau en ruines, Alcôve au tresor au nord, generee au format 4:3 (ref. rip Old Castle), scintillement dore anime. Pas une aventure jouable.</Description>
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
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'poses', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)
    a, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'sol_complet.png'), rgb(REF)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a)
    order = ['tresor', 'eboulis', 'ombres', 'alcove', 'medaillon', 'sol', 'vide', 'parois']
    ex, cols = down_class(a, m, order)
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    layers['vide'][..., :3] = 0        # vide = noir hors carte, jamais le magenta du fond
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    mouth = ex['alcove']
    cand = ex['sol'] | ex['ombres'] | ex['medaillon'] | ex['alcove']
    cl, _ = nd.label(cand)
    _ys = np.nonzero(cand.any(1))[0]; seed = cl[_ys.max()][cand[_ys.max()]]   # composante du point praticable le plus bas (entree sud)
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    gold = ex['tresor'] | ex['medaillon']
    spots = spark_positions(gold)
    scintillement = spark_frames(spots)
    anim = {'scintillement': scintillement}
    for i, (x, y) in enumerate(spots):
        spr = np.zeros((7, 7, 4), 'uint8'); spr[3, :] = (*SPARK_COLS[1], 255); spr[:, 3] = (*SPARK_COLS[1], 255)
        Image.fromarray(spr).save(OUT / 'poses' / f'{PFX}_eclat_{i:02d}.png')
    order_names = ['sol_complet'] + STATIC + ANIMS
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        if nm in anim:
            frames, ticks = anim[nm], TICKS
            for t, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            layer_list.append({'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frames), 'ticks': ticks})
        else:
            frames, ticks = [layers[nm]], 60
            Image.fromarray(layers[nm]).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
        stack_named.append((nm, frames, ticks))
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    _wy, _wx = np.nonzero(walk); _ey = int(_wy.max()); _ex = int(np.median(_wx[_wy == _ey]))
    entry_px = [_ex // 8 * 8, _ey // 8 * 8]
    while blocked[entry_px[1] // 8:entry_px[1] // 8 + 2, entry_px[0] // 8:entry_px[0] // 8 + 2].any() and entry_px[1] > 0:
        entry_px[1] -= 8
    dys, dxs = np.nonzero(mouth)
    tx = int(round(dxs.mean())) // 8 * 8 - 8
    threshold_px = [tx, int(dys.max()) // 8 * 8 + 8]
    while blocked[threshold_px[1] // 8:threshold_px[1] // 8 + 2, threshold_px[0] // 8:threshold_px[0] // 8 + 2].any():
        threshold_px[1] += 8
    def marker16(cx, cy):
        best = None
        for dy in range(-64, 65, 8):
            for dx in range(-64, 65, 8):
                x, y = cx + dx, cy + dy
                if 0 <= x <= W - 16 and 0 <= y <= H - 16 and walk[y:y + 16, x:x + 16].all():
                    d = dx * dx + dy * dy
                    if best is None or d < best[0]:
                        best = (d, [x, y])
        assert best, (cx, cy)
        return best[1]
    entry_px = marker16(*entry_px); threshold_px = marker16(*threshold_px)
    reach, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach, 'pas de chemin 16x16'

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for _, frames, ticks in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
        return im
    step = 5
    scenes = [scene(t) for t in range(0, LOOP_TICKS, step)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(step * 1000 / 60), loop=0, lossless=True)
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    for x, y, *_ in spots:
        dr.ellipse([x - 3, y - 3, x + 3, y + 3], outline=(255, 255, 255, 255))
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    sheet = Image.new('RGBA', (W, H), (60, 50, 30, 255))
    for t in (0, 2, 4):
        sheet.alpha_composite(Image.fromarray(scintillement[t * 4]))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_entree_old_castle_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, threshold_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('pierre', 'sol'), ('pierre', 'parois'), ('or', 'tresor')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'entree_old_castle_sud_nord_v1', 'prefix': PFX, 'format': '4:3 vaste', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8], 'base': 'branche de session (EWC1 et ESN1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'interieur de vieux chateau en ruines, salle au tresor ; seule reference de la racine libre partout (« passe au prochaine map », « continue la suite »)',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet et sol '
                  'complet generes avec le rip en reference ; scintillement dessine (couleurs du decor)',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Old Castle (salle au tresor) ; capture racine oldcastlepmd.png'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid,
                         'sol_complet': round(float(np.linalg.norm(f[materials(f)['pierre']].mean(0) - np.array(fid['pierre']['rip_rgb']))), 1)},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'ombres': 'calque ombres = sol du rendu assombri au pied des parois et des blocs (separe, pas invente)',
        'layers': layer_list,
        'scintillement': {'points': [list(x) for x in spots], 'nombre': len(spots),
                          'tous_les': SPARK_EVERY, 'duree_phases': SPARK_LIFE, 'couleurs': [list(c) for c in SPARK_COLS],
                          'phases': PHASES, 'frame_length_ticks': TICKS,
                          'origine': 'dessin CREE (eclats en croix, couleurs dorees du decor) ; points sur l or '
                                     '(tresor, piliers, medaillon), apparition et extinction en boucle fermee'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'threshold_px': threshold_px, 'path_found_16x16': reach, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (sol, ombres, medaillon, Alcôve relies au bord sud)',
                   'seuil': 'premiere case 2 x 2 libre au sud de l Alcôve au tresor'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'threshold': threshold_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'eclats': len(spots),
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
