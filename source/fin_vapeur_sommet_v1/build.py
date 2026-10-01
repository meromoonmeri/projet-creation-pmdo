"""Fin Vapeur (FVS1) — première « zone de fin de donjon » de la série des entrées, 4:3 (768 x 576, 96 x 72 cases).

Demande : « Fait des zone fin de donjon multicalque de la série entrée on passe au fin », puis « Lance toi ».
Choix de l'agent (questions laissées sans réponse) : une fin par biome de la série, dans l'ordre du mod,
en commençant par Vapeur (Steam Cave). Référence = la VRAIE fin du jeu : Steam_Cave_Peak_TDS.png (sommet de
Steam Cave, jamais prise comme référence dans la série). Layout de fin : arrivée au sud par le couloir qui sort
du donjon, grande arène (marqueur « boss »), source chaude au nord = point d'intérêt (marqueur « source »).
Aucune sortie au nord, aucun warp.

Méthode (rendu généré RÉFÉRENCÉ, comme la série) :
- bruts générés avec le rip en images= : décor complet (source = magenta), sol seul, planche de 7 poses de vapeur ;
- segmentation pleine résolution, réduction x(576/896) PAR CLASSE, recadrage centré 768 ;
- animations, chacune sur son calque, boucles fermées :
  eau de la source = eau « façon rivière Métano » de l'entrée Vapeur V2 (même palette, 4 x 10 ticks) ;
  bouillonnement = bulles de l'entrée Vapeur V2 (mêmes poses générées, 24 x 5 ticks) ;
  vapeur des évents et de la source = poses générées réduites x0,14, 24 x 5 ticks, décalées par émetteur.
Scène : PPCM 120 ticks = 2 s.
Lancer : .venv/bin/python source/fin_vapeur_sommet_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
LOT = 'fin_vapeur_sommet_v1'
OUT = R / 'renders' / LOT
NAMESPACE = 'fin_vapeur_sommet'
STAGE = R / '.cache' / LOT / NAMESPACE
ASSET = 'fvs1_fin_vapeur_sommet'
PFX = 'FVS1'
REF = 'Steam_Cave_Peak_TDS.png'
W, H = 768, 576
SRC = (1200, 896)
WATER_PHASES, WATER_TICKS = 4, 10
BUBBLE_PHASES, BUBBLE_TICKS = 24, 5
STEAM_PHASES, STEAM_TICKS = 24, 5
LOOP_TICKS = 120
STEAM_SCALE = 0.14                       # panache d'environ 100 px (0,1 donnait 40 px : trop discret)
# Planche de vapeur : cases relevées (séparateurs noirs x = 210, 420, 636 en haut ; 352, 787 en bas ; y = 260).
STEAM_CELLS = [(2, 260, 0, 210), (2, 260, 210, 420), (2, 260, 420, 636), (2, 260, 636, 1047),
               (262, 1006, 0, 352), (262, 1006, 352, 787), (262, 1006, 787, 1047)]
# Chronologie d'une bouffée : 7 poses (petite bouffée -> colonne -> panache -> dissipation) puis repos.
STEAM_TIMELINE = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 6, 6]          # 16 phases actives, 8 au repos
WISP_TIMELINE = [1, 1, 2, 2, 3, 3, 2, 1]                                  # volutes au-dessus de la source
# Positions relevées à la main sur le brut (pixels du brut 1200 x 896) : centre, demi-axes.
VENTS_RAW = {'event_nord_est': ((838, 318), (52, 45)), 'event_ouest': ((258, 482), (55, 45)),
             'event_est': ((942, 482), (55, 48))}
# Seuils mesurés : sol L11 141 / S11 12 ; parois L 103-121 / S 26 ; margelle S 27 ; évents S 28.
FLOOR_L, FLOOR_S = 125, 20
RIM_RING = 48                            # margelle : hors sol, à moins de 48 px de la source (brut)
FIDELITY_MAX = 35


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


JM = loadmod('ejn1_outils', R / 'source/entree_jungle_sud_nord_v1/build.py')     # down_class, down_full, rgba (768 x 576)
BM = JM.BM                                                                        # quantize_layers, cell_grid, write_ora
E2 = loadmod('esn2_eau_bulles', R / 'source/entree_vapeur_sud_nord_v2/build.py')  # eau et bulles de l'entrée Vapeur V2
E2.W, E2.H = W, H                                                                 # ses fonctions lisent W/H à l'appel
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
S = JM.SCALE


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def to_map(p):
    """Point du brut -> carte (x0,642857, recadrage centré)."""
    return int(round(p[0] * S)) - JM.CROP_X, int(round(p[1] * S))


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a):
    r, g, b = a.transpose(2, 0, 1); lum = a @ [.299, .587, .114]
    mag = (r > g * 1.5) & (b > g * 1.3) & (r > 150) & (b > 130)
    pool = nd.binary_fill_holes(nd.binary_dilation(mag, iterations=2))
    L = nd.uniform_filter(lum, 11); Sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 11) - L ** 2, 0))
    core = (L > FLOOR_L) & (Sd < FLOOR_S) & ~nd.binary_dilation(pool, iterations=4)
    core = nd.binary_opening(core, iterations=3)
    lab, n = nd.label(core); sizes = nd.sum(core, lab, range(1, n + 1))
    floor = nd.binary_closing(lab == int(np.argmax(sizes)) + 1, iterations=4)
    holes = nd.binary_fill_holes(floor) & ~floor                    # grains sombres de la texture : rebouchés
    hl, hn = nd.label(holes); hs = nd.sum(holes, hl, range(1, hn + 1))
    floor |= np.isin(hl, [i + 1 for i, s in enumerate(hs) if s < 2500])
    yy, xx = np.mgrid[:a.shape[0], :a.shape[1]]
    rim = (nd.distance_transform_edt(~pool) <= RIM_RING) & ~pool & ~floor
    vents = np.zeros_like(floor)
    for (cx, cy), (ax, ay) in VENTS_RAW.values():
        vents |= (((xx - cx) / ax) ** 2 + ((yy - cy) / ay) ** 2 <= 1) & ~floor
    walls = ~(pool | floor | rim | vents)
    return dict(pool=pool, floor=floor, rim=rim, vents=vents & ~rim, walls=walls)


# ---------------------------------------------------------------- vapeur générée
def steam_poses():
    src = rgb(RAW / 'vapeur_poses.png'); r, g, b = src.transpose(2, 0, 1)
    mag = (r > 150) & (b > 150) & (g < 110)
    poses = []
    for y0, y1, x0, x1 in STEAM_CELLS:
        m = ~mag[y0 + 6:y1 - 6, x0 + 6:x1 - 6]
        lab, n = nd.label(m); sizes = nd.sum(m, lab, range(1, n + 1))
        keep = lab == int(np.argmax(sizes)) + 1
        keep = nd.binary_fill_holes(keep)
        ys, xs = np.nonzero(keep); sl = (slice(ys.min(), ys.max() + 1), slice(xs.min(), xs.max() + 1))
        crop = src[y0 + 6:y1 - 6, x0 + 6:x1 - 6][sl]; km = keep[sl]
        h, w = km.shape; th, tw = max(3, round(h * STEAM_SCALE)), max(3, round(w * STEAM_SCALE))
        cov = np.array(Image.fromarray(km.astype(np.float32), 'F').resize((tw, th), Image.Resampling.BOX))
        col = np.stack([np.array(Image.fromarray((crop[..., c] * km).astype(np.float32), 'F').resize((tw, th), Image.Resampling.BOX))
                        for c in range(3)], -1) / np.maximum(cov, 1e-6)[..., None]
        o = np.zeros((th, tw, 4), 'uint8'); o[..., :3] = np.clip(np.round(col), 0, 255); o[..., 3] = 255; o[cov < 0.45] = 0
        poses.append(o)
    # Palette commune de 6 teintes ; le contour noir du générateur devient le brun le plus sombre du rip (58, 50, 47).
    opq = np.concatenate([p[p[..., 3] > 0][:, :3] for p in poses]).astype(int)
    dark = opq.sum(1) < 200; light = opq[~dark]
    q = Image.fromarray(light.reshape(-1, 1, 3).astype('uint8')).quantize(5, method=Image.Quantize.MEDIANCUT)
    pal5 = np.array(q.getpalette()[:15], int).reshape(5, 3)
    pal = np.vstack([pal5, [[88, 70, 64]]])
    for p in poses:
        m = p[..., 3] > 0; c = p[..., :3].astype(int)
        d = ((c[..., None, :] - pal[None, None]) ** 2).sum(-1)
        idx = np.where(c.sum(-1) < 200, 5, d[..., :5].argmin(-1))
        p[..., :3] = pal[idx]; p[~m] = 0
    return poses, pal


def stamp(frame, pose, cx, by):
    """Pose centrée en x sur cx, bas de la pose en by."""
    h, w = pose.shape[:2]; x0, y0 = cx - w // 2, by - h + 1
    ys, xs = np.nonzero(pose[..., 3] > 0); ty, tx = ys + y0, xs + x0
    ok = (ty >= 0) & (ty < H) & (tx >= 0) & (tx < W)
    frame[ty[ok], tx[ok]] = pose[ys[ok], xs[ok]]


def steam_frames(poses, vents_px, wisps_px):
    fr = [np.zeros((H, W, 4), 'uint8') for _ in range(STEAM_PHASES)]
    offs = {}
    for i, (name, (cx, by)) in enumerate(vents_px.items()):
        off = (i * 8) % STEAM_PHASES; offs[name] = off
        for t in range(STEAM_PHASES):
            k = (t - off) % STEAM_PHASES
            if k < len(STEAM_TIMELINE):
                stamp(fr[t], poses[STEAM_TIMELINE[k]], cx, by)
    for j, (cx, by) in enumerate(wisps_px):
        off = (j * 5 + 3) % STEAM_PHASES; offs[f'volute_{j}'] = off
        for t in range(STEAM_PHASES):
            k = (t - off) % STEAM_PHASES
            if k < len(WISP_TIMELINE):
                stamp(fr[t], poses[WISP_TIMELINE[k]], cx, by - k)              # la volute monte de 1 px par phase
    return fr, offs


# ---------------------------------------------------------------- Ground
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
    o.update(Name={'DefaultText': 'Fin Vapeur - sommet de Steam Cave (4:3)', 'LocalTexts': {}}, AssetName=ASSET, Released=False,
             TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={},
             Layers=layers, Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Fin de donjon generee 4:3 (ref. Steam Cave Peak) ; eau et bulles de l entree Vapeur V2, '
                     'vapeur generee. Arrivee au sud, arene (boss), source chaude au nord. Aucun warp.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p, d: {'EntName': n, 'Direction': d, 'EntEnabled': True, 'triggerType': 0,
                          'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', markers['entrance'], 0), mk('boss', markers['boss'], 4),
                                  mk('source', markers['source'], 0)]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    gfx.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    gfx.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
             f'-- {ASSET} : base d edition (fin de donjon), aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(tools.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Vapeur (sommet de Steam Cave) 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : fin de donjon generee au format 4:3 (ref. Steam Cave Peak), arene, source chaude qui bouillonne, events de vapeur animes. Pas une aventure jouable.</Description>
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


# ---------------------------------------------------------------- calcul
def make_all():
    a = rgb(RAW / 'decor_magenta.png'); f = rgb(RAW / 'sol_complet.png')
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m = classify(a)
    order = ['pool', 'floor', 'rim', 'vents', 'walls']
    ex, cols = JM.down_class(a, m, order)
    pool = ex['pool']
    names = {'floor': 'sol_arene', 'rim': 'margelle', 'vents': 'events', 'walls': 'stalagmites'}
    layers = {'sol_complet': JM.rgba(JM.down_full(f), ~pool)}
    for k, nm in names.items():
        layers[nm] = JM.rgba(cols[k], ex[k])
    layers = BM.quantize_layers(layers)
    land = np.zeros((H, W), bool)
    for nm in names.values():
        land |= layers[nm][..., 3] == 255
    visible = pool & ~land
    wf, dist = E2.water_phases(visible, pool)
    # bouillonnement : bulles de l'entrée Vapeur V2 (poses générées), émetteurs sur l'eau visible
    bposes = E2.bubble_poses(); cell = E2.CELL
    taken = np.zeros((H, W), bool)
    emitters = E2.place(visible & (dist > 3), (cell, cell), 4, 5, taken)
    boffs = [(i * 7) % BUBBLE_PHASES for i in range(len(emitters))]
    bf = [np.zeros((H, W, 4), 'uint8') for _ in range(BUBBLE_PHASES)]
    for (y, x), off in zip(emitters, boffs):
        for t in range(BUBBLE_PHASES):
            k = (t - off) % BUBBLE_PHASES
            if k < len(E2.BUBBLE_TIMELINE):
                p = bposes[E2.BUBBLE_TIMELINE[k]]; mm = p[..., 3] > 0
                bf[t][y:y + cell, x:x + cell][mm] = p[mm]
    for fr_ in bf:
        fr_[~visible] = 0
    # vapeur : pied de chaque panache au centre haut de l'évent (carte), volutes au-dessus de la source
    poses, spal = steam_poses()
    vents_px = {}
    vm = layers['events'][..., 3] == 255
    for name, (c, ax) in VENTS_RAW.items():
        cx, cy = to_map(c); r_ = int(ax[0] * S)
        box = vm[max(0, cy - r_):cy + r_, max(0, cx - r_):cx + r_]
        ys, xs = np.nonzero(box); top = int(ys.min()) + max(0, cy - r_)
        vents_px[name] = (int(xs.mean()) + max(0, cx - r_), top + 6)
    py, px = np.nonzero(pool)
    pcx, pcy = int(px.mean()), int(py.mean())
    wisps_px = [(pcx - 34, pcy + 10), (pcx + 6, pcy - 4), (pcx + 38, pcy + 14)]
    sf, soffs = steam_frames(poses, vents_px, wisps_px)
    return dict(a=a, m=m, ex=ex, layers=layers, names=names, visible=visible, wf=wf, bf=bf, emitters=emitters, boffs=boffs,
                bposes=bposes, poses=poses, spal=spal, sf=sf, soffs=soffs, vents_px=vents_px, wisps_px=wisps_px,
                pool_c=(pcx, pcy))


def fidelity(layers):
    rip = rgb(R / REF)
    ref = rip[250:450, 250:420].reshape(-1, 3).mean(0)                    # sol de l'arène du rip
    ours = layers['sol_arene'][layers['sol_arene'][..., 3] == 255][:, :3].astype(float).mean(0)
    return {'rip_sol_rgb': [round(float(v), 1) for v in ref], 'sol_arene_rgb': [round(float(v), 1) for v in ours],
            'distance': round(float(np.linalg.norm(ref - ours)), 2), 'seuil': FIDELITY_MAX}


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'animation', 'masques', 'review', 'poses_vapeur']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'animation/eau_source', 'animation/bulles', 'animation/vapeur', 'poses_vapeur', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    D = make_all(); layers, names, ex = D['layers'], D['names'], D['ex']
    fid = fidelity(layers); assert fid['distance'] < FIDELITY_MAX, fid
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    for i, p in enumerate(D['poses']):
        Image.fromarray(p).save(OUT / 'poses_vapeur' / f'{PFX}_vapeur_pose_{i}.png')
    # ordre bas -> haut
    static_order = ['sol_complet', 'sol_arene', 'margelle', 'events', 'stalagmites']
    stack_named = [('eau_source', D['wf'], WATER_TICKS), ('bulles', D['bf'], BUBBLE_TICKS)] + \
                  [(nm, [layers[nm]], 60) for nm in static_order] + [('vapeur', D['sf'], STEAM_TICKS)]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f'calques/{PFX}_{i:02d}_{nm}.png'; Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png'
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace('NN', f'{t:02d}'))
        files[nm] = fn
    # collisions : seul le sol de l'arène (et du couloir) est praticable
    walk = layers['sol_arene'][..., 3] == 255
    blocked = BM.cell_grid(~walk)
    gh_, gw_ = blocked.shape
    col_bottom = [c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()]
    med = int(np.median(np.nonzero(walk[H - 4])[0])) // 8
    cx = min(col_bottom, key=lambda c: abs(c - med))
    entrance = [cx * 8, H - 16]

    def free_near(x, y):
        best = None
        for dy in range(0, 20):
            for dx in sorted(range(-12, 13), key=abs):
                for sy in (1, -1):
                    gy, gx = y // 8 + sy * dy, x // 8 + dx
                    if 0 <= gy < gh_ - 1 and 0 <= gx < gw_ - 1 and not blocked[gy:gy + 2, gx:gx + 2].any():
                        return [gx * 8, gy * 8]
        return best
    fy, fx = np.nonzero(walk)
    boss = free_near(int(fx.mean()), int(fy.mean()))
    rim_rows = np.nonzero((layers['margelle'][..., 3] == 255).any(1))[0]
    source = free_near(D['pool_c'][0] - 8, int(rim_rows.max()) + 4)
    markers = {'entrance': entrance, 'boss': boss, 'source': source}
    paths = {}
    for k in ('boss', 'source'):
        ok, explored = v1.reachable(blocked, (entrance[1] // 8, entrance[0] // 8), (markers[k][1] // 8, markers[k][0] // 8))
        assert ok, k
        paths[k] = {'ok': ok, 'cases_explorees': explored}

    def scene(tick):
        idx = {'eau_source': (tick // WATER_TICKS) % WATER_PHASES, 'bulles': (tick // BUBBLE_TICKS) % BUBBLE_PHASES,
               'vapeur': (tick // STEAM_TICKS) % STEAM_PHASES}
        im = Image.new('RGBA', (W, H))
        for title, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[idx.get(title, 0)]))
        return im
    scenes = [scene(t * 5) for t in range(LOOP_TICKS // 5)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(5 * 1000 / 60), loop=0, lossless=True)
    colim = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for k, c in (('entrance', (255, 230, 40, 255)), ('boss', (255, 80, 200, 255)), ('source', (60, 220, 255, 255))):
        q = markers[k]; dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=c, width=2)
    colim.alpha_composite(ov); colim.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    sheet = Image.new('RGBA', (7 * 44, 80), (162, 132, 113, 255))
    for i, p in enumerate(D['poses']):
        sheet.alpha_composite(Image.fromarray(p), (i * 44 + (44 - p.shape[1]) // 2, 78 - p.shape[0]))
    sheet.resize((sheet.width * 3, sheet.height * 3), Image.Resampling.NEAREST).save(OUT / 'review' / f'{PFX}_planche_vapeur_x3.png')
    BM.write_ora(OUT / f'{PFX}_fin_vapeur_calques.ora',
                 {f'{i:02d}_{t}' + ('_f0' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, markers, gfx, tools)
    manifest = {
        'lot': LOT, 'serie': 'fins de donjon de la serie des entrees', 'biome': 'Vapeur (Steam Cave)',
        'entree_correspondante': ['entree_vapeur_sud_nord_v1', 'entree_vapeur_sud_nord_v2'],
        'demande': ['Fait des zone fin de donjon multicalque de la serie entree on passe au fin', 'Lance toi'],
        'choix_agent': {'ordre': 'une fin par biome, ordre du mod ; Vapeur d abord (questions laissees sans reponse)',
                        'layout': 'arrivee au sud (couloir qui sort du donjon), arene (boss), source chaude au nord (objectif), aucune sortie',
                        'reference': 'vraie fin du jeu : ' + REF},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'rendu genere reference : decor complet sur magenta (source = magenta), sol seul, planche de vapeur ; rip en images=',
        'reference_da': REF,
        'raw_inputs': [{'file': f'source/{LOT}/bruts/{n}', 'sha256': sha(RAW / n), 'size': list(Image.open(RAW / n).size),
                        'images': [REF] if n != 'sol_complet.png' else [f'source/{LOT}/bruts/decor_magenta.png']}
                       for n in ['decor_magenta.png', 'sol_complet.png', 'vapeur_poses.png']],
        'normalization': {'scale': S, 'crop_x': JM.CROP_X, 'methode': 'moyenne ponderee par classe (BOX), palette commune 96 couleurs'},
        'segmentation': {'source': 'magenta dilate 2 px', 'sol': f'moyenne 11 px > {FLOOR_L} et ecart-type 11 px < {FLOOR_S}, plus grande composante, grains < 2500 px rebouches',
                         'margelle': f'hors sol a moins de {RIM_RING} px de la source', 'events': {k: {'centre_brut': list(c), 'demi_axes': list(ax)} for k, (c, ax) in VENTS_RAW.items()},
                         'stalagmites': 'le reste'},
        'fidelite': fid,
        'layer_order_bottom_to_top': [files[t] for t, _, _ in stack_named],
        'eau_source': {'phases': WATER_PHASES, 'frame_length_ticks': WATER_TICKS, 'couleurs': {k: list(v) for k, v in E2.PAL.items()},
                       'origine': 'fonction water_phases de l entree Vapeur V2 (structure riviere Metano), recalculee sur la source ; pas de tuiles natives'},
        'bulles': {'poses': 'planche generee de l entree Vapeur V2 (bruts/bulles_8_poses.png)', 'phases': BUBBLE_PHASES,
                   'frame_length_ticks': BUBBLE_TICKS, 'emetteurs': [{'xy': [int(x), int(y)], 'decalage': o} for (y, x), o in zip(D['emitters'], D['boffs'])]},
        'vapeur': {'brut': f'source/{LOT}/bruts/vapeur_poses.png', 'cases': STEAM_CELLS, 'reduction': STEAM_SCALE,
                   'palette': D['spal'].tolist(), 'contour': 'noir du generateur -> brun sombre (88, 70, 64)',
                   'chronologie_event': STEAM_TIMELINE, 'chronologie_volute': WISP_TIMELINE, 'phases': STEAM_PHASES,
                   'frame_length_ticks': STEAM_TICKS, 'events_px': {k: list(v) for k, v in D['vents_px'].items()},
                   'volutes_px': [list(v) for v in D['wisps_px']], 'decalages': D['soffs'],
                   'origine': 'dessin GENERE, chronologie creee ; pas une animation officielle'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'markers': markers, 'chemins_16x16': paths, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquee si > 25 % hors sol de l arene'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'fidelite': fid, 'markers': markers, 'vents': D['vents_px'], 'blocked': int(blocked.sum()), 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
