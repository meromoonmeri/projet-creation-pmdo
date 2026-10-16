"""Fin Grotte aux vasques V1 (FGV1) — zone de fin de donjon, format 4:3 vaste (768 x 576 px, 96 x 72 cases de 8 px).

Demande (16 octobre 2026) : « Fait la zone de fin et passe ensuite au prochaine map ! » : fin du biome de l'entrée
EGV1 (grotte dorée à vasques turquoise). Biome choisi par l'agent (à confirmer). Consigne utilisateur des fins
(branches sœurs) : « pas d'artefact ni d'objet/structure en fin de donjon, seulement le décor ».
Référence principale : D56P41A (grande salle bordée de vasques, rendu ROM extrait par
`source/entree_grotte_vasques_sud_nord_v1/reference.py`), plus le décor EGV1 pour la continuité.

Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ + pipeline natif :
- decor.png : salle de fin 4:3 (1200 x 896), réf. D56P41A + décor EGV1 ;
- sol_complet.png : édité depuis le décor (sable seul bord à bord, marches gardées), recalé (0, 0) ;
- planche de bulles : celle d'EGV1, réutilisée sans nouvelle génération (même sha256).
L'eau des vasques est ramenée aux 14 couleurs EXACTES de l'eau de D56P41A (plus proche luminance) ; les pixels qui
tombent sur les 6 couleurs animées forment le calque de reflets, animé avec l'animation de palette EXACTE du BPL de
D56P41A (palettes 10 et 11 : 6 emplacements, 12 frames x 8 ticks).
Calques : sol complet, sol, ombres (marches et sable assombri), vasques, parois, fond sarcelle (derrière les
stalactites ; pas de bouche).
Animations : reflets_vasques 12 x 8 = 96 ticks ; bulles_source 24 x 4 = 96 ticks. Scène : 96 ticks.
Marqueurs : `entrance` (sud), `boss` (centre de l'arène), `objectif` (pied de la cascade de vasques au nord).
Aucune sortie, aucun warp, pas de `donjon_seuil`.
Lancer : .venv/bin/python source/fin_grotte_vasques_v1/build.py
"""
from pathlib import Path
import io, json, shutil, uuid, zipfile, importlib.util

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
EGV = R / 'source/entree_grotte_vasques_sud_nord_v1'
REFDIR = EGV / 'references'
REF = REFDIR / 'D56P41A.png'
REF2 = REFDIR / 'D56P12A.png'
POSES_SHEET = EGV / 'bruts/source_poses.png'
TEMPLATE = R / 'cliffdaytest.rsground'
OUT = R / 'renders/fin_grotte_vasques_v1'
STAGE = R / '.cache/fin_grotte_vasques_v1/fin_grotte_vasques'
NAMESPACE = 'fin_grotte_vasques'
ASSET = 'fgv1_fin_grotte_vasques'
PFX = 'FGV1'
W, H = 768, 576
SRC = (1200, 896)
SAND = (160, 144, 80)                     # sable du décor (fenêtre 560:740, 470:760)
REF_CODE = 'D56P41A'
RIP_PHASES, RIP_TICKS = 12, 8             # BPL D56P41A : palettes 10 et 11, 12 frames x 8 ticks
BUB_PHASES, BUB_TICKS = 24, 4             # bulles : 24 x 4 = 96 ticks
LOOP_TICKS = 96
GEN = [
    {'file': 'decor.png', 'images': ['source/entree_grotte_vasques_sud_nord_v1/references/D56P41A.png',
                                     'source/entree_grotte_vasques_sud_nord_v1/bruts/decor.png'], 'prompt':
     "Use the reference images' exact pixel-art style, palette and textures (Pokemon Mystery Dungeon Explorers of Sky, "
     'golden spring cave): flat golden-ochre sandy cave floor with fine speckled pixel texture and low curved sand '
     'steps; cave walls of piled rounded golden sandstone boulders; tiers of rounded turquoise travertine pools with '
     'scalloped pale-gold rims and cyan-white ripple highlights; stalactites. Create a NEW map, WIDE LANDSCAPE 4:3, '
     'zoomed out, top-down view (1200 x 896): the deepest chamber of this cave. The player arrives from the SOUTH edge '
     'through a short sandy passage between boulder walls, which opens into a very large oval golden-sand arena with a '
     'wide open floor in the middle and two low curved sand steps crossing it. All around the arena, tiers of turquoise '
     'travertine pools climb the boulder slopes. At the NORTH, a tall wide cascade of stepped turquoise travertine pools '
     'rises against the back wall, and the sand floor reaches right up to its lowest pool. Stalactites hang along the '
     'top edge. Boulder walls fill the map corners and edges, no empty black void, no tunnel, no dark hole. IMPORTANT: '
     'no characters, no objects, no altar, no crystals, no text, no UI, no border, no sparkles.',
     'essais': 'premier essai, 1200 x 896 ; cascade de vasques en pyramide au nord, trois marches courbes ; les pentes '
               'laterales reprennent celles du decor EGV1 (continuite voulue) ; aucun objet ni structure'},
    {'file': 'sol_complet.png', 'images': ['source/fin_grotte_vasques_v1/bruts/decor.png'], 'prompt':
     'Edit this pixel-art cave map, same framing and same pixel style: remove everything except the sand floor. Fill '
     'the whole image, edge to edge, with exactly the same sand floor as in the middle of this image: the same muted, '
     'desaturated olive-ochre khaki colour (not bright yellow, not orange), the same small darker speckles and the same '
     'fine pixel texture, same brightness. Keep the floor that is already visible in the middle exactly where it is, '
     'including its low curved sand steps. No boulders, no pools, no water, no stalactites, no shadows, no border.',
     'essais': 'premier essai (consigne de teinte d EGV1 reprise d emblee) ; marches gardees'},
    {'file': 'source_poses.png', 'images': ['source/entree_grotte_vasques_sud_nord_v1/references/D56P12A.png'],
     'prompt': 'REUTILISEE sans nouvelle generation : planche d EGV1 (source/entree_grotte_vasques_sud_nord_v1/bruts/'
               'source_poses.png, meme sha256), memes fenetres et reductions que l entree.',
     'essais': 'copie de la planche EGV1 (meme biome, memes poses) : aucune generation supplementaire'},
]
BUB_SEQ = (['bulle_0', 'bulle_1', 'bulle_2', 'bulle_2', 'bulle_3', 'bulle_3', 'bulle_4', 'bulle_5',
            'anneau_0', 'anneau_1', 'anneau_1', 'anneau_2', 'anneau_2', 'anneau_3', 'anneau_3'] + [None] * 9)
BUB_N = 10
assert len(BUB_SEQ) == BUB_PHASES


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


E = loadmod('egv1_build', EGV / 'build.py')                # fonctions génériques de l'entrée du même biome
V1, JM = E.V1, E.JM
keep_large, cell_grid, close_, open_ = E.keep_large, E.cell_grid, E.close_, E.open_
down_class, down_full, rgba, quantize_group = E.down_class, E.down_full, E.rgba, E.quantize_group
materials, fidelity, rip_water_palette, remap_water = E.materials, E.fidelity, E.rip_water_palette, E.remap_water
sha, rgb, lum_of, paste, spread = E.sha, E.rgb, E.lum_of, E.paste, E.spread
PALETTE_GROUPS = {'terrain': (['sol_complet', 'sol', 'ombres'], 96),
                  'roche': (['parois', 'fond'], 96),
                  'rebords': (['rebords'], 64)}
STATIC = ['sol', 'ombres', 'vasques', 'parois', 'fond']
ANIMS = ['reflets_vasques', 'bulles_source']


def palette_slots():
    """Animation de palette de D56P41A (palette_anim.json d'EGV1) : 6 emplacements ; le rendu skytemple donne 24 frames
    = deux tours du cycle BPL de 12 frames (vérifié) : on garde les 12 premières."""
    pa = json.loads((REFDIR / 'palette_anim.json').read_text())['maps'][REF_CODE]
    slots = []
    for s in pa['emplacements']:
        c = [tuple(x) for x in s['couleurs_par_frame']]
        assert c[:RIP_PHASES] == c[RIP_PHASES:2 * RIP_PHASES]
        slots.append(c[:RIP_PHASES])
    assert len(slots) == 6
    assert all((s['frames'], s['duree_par_frame']) == (RIP_PHASES, RIP_TICKS) for s in pa['specs_bpl'])
    return slots, pa


def reflet_frames(slot_map, slots, ts=range(RIP_PHASES)):
    frames = []
    for t in ts:
        a = np.zeros((H, W, 4), 'uint8')
        for k, seq in enumerate(slots):
            a[slot_map == k] = (*seq[t % RIP_PHASES], 255)
        frames.append(a)
    return frames


def bubble_frames(poses, emitters, water, pools, ts=range(BUB_PHASES)):
    frames = [np.zeros((H, W, 4), 'uint8') for _ in ts]
    for (cx, cy, off) in emitters:
        for i, t in enumerate(ts):
            nm = BUB_SEQ[(t + off) % BUB_PHASES]
            if nm:
                paste(frames[i], poses[nm], cx, cy, clip=water if nm.startswith('anneau') else pools)
    return frames


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a, f):
    """a : décor, f : sol complet recalé. Mesures sur le brut : sable (160,144,80), écart-type 5-7 ; marches courbes
    (contremarches claires et traits sombres) ; fond sarcelle derrière les stalactites (y < 140) ; eau turquoise ;
    blocs dorés. Pas de bouche."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    m1 = nd.uniform_filter(lum, 7); sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 7) - m1 ** 2, 0))
    pure = np.abs(a - SAND).max(-1) <= 18
    core = keep_large(open_(close_(pure, 3), 2), 50000)
    holes = nd.binary_fill_holes(core) & ~core; hl, hn = nd.label(holes)
    hs = nd.sum(holes, hl, range(1, hn + 1)) if hn else np.array([])
    big = np.isin(hl, [i + 1 for i, v in enumerate(hs) if v >= 150])
    core |= holes & ~big
    sandhue = (r > g) & (g > b) & (g - b > 30) & (r - g < 30)
    dcore = nd.distance_transform_edt(~core)
    shade = (dcore > 0) & (dcore <= 30) & sandhue & (sd < 12) & (lum > 60) & (lum < 140)
    bright_w = (g - r > 55) & (b - r > 40) & (lum > 60)
    teal0 = (yy < 175) & (g - r > 25) & (b - r > 15) & (lum < 100) & ~nd.binary_dilation(bright_w, iterations=4)
    tl, tn = nd.label(teal0)
    tops = nd.minimum(yy, tl, range(1, tn + 1)) if tn else np.array([]); tsz = nd.sum(teal0, tl, range(1, tn + 1)) if tn else np.array([])
    teal = np.isin(tl, 1 + np.flatnonzero((tops < 140) & (tsz >= 40)))
    wb = close_(bright_w, 1) & (g - r > 30) & (b - r > 25)
    hue = (g - r > 15) & (b - r > 10)
    water = ((nd.binary_fill_holes(wb) & hue) | (nd.binary_dilation(wb, iterations=2) & hue)) & ~teal
    # Marches : le décor y coïncide avec le sol complet (écart médian 5 x 5 <= 12 ; bande des marches : médiane 5,
    # parois >= 19 dans 95 % des cas), près du sable, hors eau et fond. Contremarches claires -> sol ; traits sombres
    # (lum < 128) -> ombres. Sans cela, les contremarches tombaient en parois et coupaient l'arène en deux.
    dm = nd.median_filter(np.abs(a - f).max(-1), 5)
    steps = (dm <= 12) & (dcore <= 40) & ~water & ~teal
    steps = keep_large(steps | core, 50000) & ~core
    core = core | (steps & (lum >= 128))
    shade = (shade | (steps & (lum < 128))) & ~core
    shade &= ~water
    shade = keep_large(close_(shade, 1), 120) & ~core & ~water
    blocs = big & ~shade                                                        # rochers isolés sur le sable (s'il y en a)
    rim = nd.binary_dilation(water, iterations=6) & ~water & ~core & ~shade & ~blocs & ~teal
    walls = ~core & ~shade & ~teal & ~water & ~rim & ~blocs
    masks = dict(fond=teal, sol=core, ombres=shade, eau=water, rebords=rim, blocs=blocs, parois=walls)
    seg = {'rochers_isoles': int((hs >= 150).sum()), 'mouchetures_rendues_au_sol': int((hs < 150).sum()),
           'fond_sarcelle_px': int(teal.sum()), 'ombres_px_brut': int(shade.sum()), 'marches_px_brut': int(steps.sum())}
    return masks, seg


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Grotte aux vasques V1 (FGV1)')
    stack = ET.SubElement(root, 'stack'); comp = Image.new('RGBA', (W, H))
    def zi(n, method=zipfile.ZIP_DEFLATED):          # date fixe : ORA identique octet pour octet d'un build à l'autre
        info = zipfile.ZipInfo(n, date_time=(1980, 1, 1, 0, 0, 0)); info.compress_type = method; return info
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr(zi('mimetype', zipfile.ZIP_STORED), 'image/openraster')
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0', visibility='visible',
                          **{'composite-op': 'svg:src-over'})
            b = io.BytesIO(); Image.fromarray(a).save(b, format='PNG'); z.writestr(zi(fn), b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO(); comp.save(b, format='PNG'); z.writestr(zi('mergedimage.png'), b.getvalue())
        th = comp.copy(); th.thumbnail((256, 256)); b = io.BytesIO(); th.save(b, format='PNG')
        z.writestr(zi('Thumbnails/thumbnail.png'), b.getvalue())
        z.writestr(zi('stack.xml'), ET.tostring(root, encoding='utf-8', xml_declaration=True))


def ground_project(stack, blocked, entry_px, boss_px, objective_px, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = json.loads(TEMPLATE.read_text(encoding='utf-8-sig'))
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
    o.update(Name={'DefaultText': 'Fin Grotte aux vasques - salle des sources (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip PMD Sky D56P41A ; eau aux couleurs exactes du '
                     'rip, reflets animes avec l animation de palette exacte du BPL (12 x 8 ticks), bulles de source '
                     'generees. Aucune sortie ni warp. Collisions de base a verifier. Biome et portee choisis par l agent.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('boss', boss_px), mk('objectif', objective_px)]}]
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
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Grotte aux vasques 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : zone de fin de donjon dans la grotte doree a vasques turquoise (salle des sources), generee au format 4:3 (ref. rip PMD Sky D56P41A), reflets des vasques animes avec l'animation de palette du jeu, bulles de source. Pas une aventure jouable.</Description>
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


def recalage(a, f):
    """Écart moyen décor / sol complet sur le sable dégagé de l'arène (au sud des marches), à (0, 0) et au meilleur
    décalage de 1 px (le minimum doit être en (0, 0))."""
    zone = np.zeros(a.shape[:2], bool); zone[560:740, 470:760] = True
    zone &= np.abs(a - SAND).max(-1) <= 30
    err = {(dy, dx): float(np.abs(a - np.roll(np.roll(f, dy, 0), dx, 1))[zone].mean())
           for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
    assert min(err, key=err.get) == (0, 0), err
    return {'ecart_moyen_sol': round(err[(0, 0)], 2),
            'ecart_decale_1px': round(min(v for k, v in err.items() if k != (0, 0)), 2)}


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
    a = rgb(RAW / 'decor.png'); f = rgb(RAW / 'sol_complet.png'); ref = rgb(REF); ref2 = rgb(REF2)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a, f)
    order = ['fond', 'sol', 'ombres', 'eau', 'rebords', 'blocs', 'parois']
    ex, cols = down_class(a, m, order)
    wpal, wcnt = rip_water_palette(ref)
    slots, pa = palette_slots()
    slot0 = [s[0] for s in slots]
    assert set(slot0) <= set(wpal), (slot0, wpal)
    water_cols = remap_water(cols['eau'], ex['eau'], wpal)
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in ['sol', 'ombres', 'parois', 'fond', 'rebords']:
        layers[k] = rgba(cols[k], ex[k])
    # Rochers isolés : aucun dans ce décor (vérifié) ; s'il y en avait, ils iraient aux parois (blocages identiques).
    if ex['blocs'].any():
        layers['parois'][ex['blocs']] = rgba(cols['blocs'], ex['blocs'])[ex['blocs']]
        ex['parois'] = ex['parois'] | ex['blocs']
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    vas = q.pop('rebords'); wl = rgba(water_cols, ex['eau'])
    vas[ex['eau']] = wl[ex['eau']]
    q['vasques'] = vas
    layers = q
    ex_l = {k: v for k, v in ex.items() if k != 'blocs'}; ex_l['vasques'] = ex['eau'] | ex['rebords']
    for k, v in ex_l.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    walk = (layers['sol'][..., 3] == 255) | (layers['ombres'][..., 3] == 255)
    water = ex['eau']; pools = ex_l['vasques']
    slot_map = np.full((H, W), -1, int)
    for k, c in enumerate(slot0):
        slot_map[water & (layers['vasques'][..., :3] == c).all(-1)] = k
    Image.fromarray(((slot_map >= 0) * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_reflets.png')
    reflets = reflet_frames(slot_map, slots)
    # Bulles : planche d'EGV1 ; émetteurs au centre des plus grandes vasques (la cascade du nord en premier).
    poses, tinted = E.sheet_poses(POSES_SHEET, wpal)
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    lab, nlab = nd.label(water)
    areas = nd.sum(water, lab, range(1, nlab + 1))
    cands = []
    for i in np.argsort(-areas):
        if areas[i] < 250:
            break
        yy_, xx_ = np.nonzero(lab == i + 1)
        cy, cx = int(round(yy_.mean())), int(round(xx_.mean()))
        if not water[cy, cx]:
            j = int(np.argmin((yy_ - cy) ** 2 + (xx_ - cx) ** 2)); cy, cx = int(yy_[j]), int(xx_[j])
        cands.append((cy, cx))
    pick = []
    for (cy, cx) in cands:                                                      # par taille décroissante, espacés
        if all(max(abs(cy - py), abs(cx - px)) >= 56 for py, px in pick):
            pick.append((cy, cx))
        if len(pick) == BUB_N:
            break
    assert len(pick) == BUB_N, len(pick)
    emitters = [(x, y, (j * 5) % BUB_PHASES) for j, (y, x) in enumerate(sorted(pick))]
    bulles = bubble_frames(poses, emitters, water, pools)
    anim = {'reflets_vasques': (reflets, RIP_TICKS), 'bulles_source': (bulles, BUB_TICKS)}
    order_names = ['sol_complet'] + STATIC + ANIMS
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        if nm in anim:
            frames, ticks = anim[nm]
            for t, fr in enumerate(frames):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            layer_list.append({'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frames), 'ticks': ticks})
        else:
            frames, ticks = [layers[nm]], 60
            Image.fromarray(layers[nm]).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
        stack_named.append((nm, frames, ticks))
    # Collisions : sable et ombres (marches) praticables ; vasques, parois et fond bloqués.
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    free = lambda cx, cy: 0 <= cx < gw_ - 1 and 0 <= cy < gh_ - 1 and not blocked[cy:cy + 2, cx:cx + 2].any()
    wy, wx = np.nonzero(walk); tgt = (int(wx.mean()) // 8, int(wy.mean()) // 8)
    boss_c = min(((cx, cy) for cy in range(gh_) for cx in range(gw_) if free(cx, cy)),
                 key=lambda c: (c[0] - tgt[0]) ** 2 + (c[1] - tgt[1]) ** 2)
    boss_px = [boss_c[0] * 8, boss_c[1] * 8]
    # Objectif : au pied de la cascade du nord : case 2 x 2 libre la plus haute de la colonne centrale (+-64 px).
    mid = W // 16
    cands_o = [(cx, cy) for cy in range(gh_) for cx in range(mid - 8, mid + 8) if free(cx, cy)]
    top = min(cy for _, cy in cands_o)
    obj_c = min((c for c in cands_o if c[1] <= top + 1), key=lambda c: abs(c[0] - mid))
    objective_px = [obj_c[0] * 8, obj_c[1] * 8]
    reach_boss, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_c[1], boss_c[0]))
    reach_obj, explored_o = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (obj_c[1], obj_c[0]))
    assert reach_boss and reach_obj, 'pas de chemin 16x16'

    def scene(tick):
        im = Image.new('RGBA', (W, H))
        for _, frames, ticks in stack_named:
            im.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
        return im
    step = 4
    scenes = [scene(t) for t in range(0, LOOP_TICKS, step)]
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=round(step * 1000 / 60), loop=0, lossless=True)
    col = scenes[0].copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 60, 220, 255)), (objective_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    write_ora(OUT / f'{PFX}_fin_grotte_vasques_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objective_px, gfx, tools)
    fid, fid2 = fidelity(a, ref), fidelity(a, ref2)
    final_fid = {}
    for k, nm in (('sable', 'sol'), ('eau', 'vasques'), ('roche', 'parois')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'fin_grotte_vasques_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'fin de donjon', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'base': 'branche de session ; fonctions generiques et planche de bulles de l entree EGV1 ; aucun emprunt aux branches soeurs',
        'biome': 'fin de la grotte doree a vasques (biome de EGV1), choisi par l agent (« Fait la zone de fin »), a confirmer',
        'consigne_fin': 'pas d artefact ni d objet/structure en fin de donjon, seulement le decor (consigne utilisateur des branches soeurs)',
        'method': 'textures canoniques = rendu genere REFERENCE (rip D56P41A + decor EGV1) + pipeline natif ; eau ramenee aux '
                  'couleurs exactes de D56P41A ; reflets = animation de palette exacte du BPL de D56P41A',
        'reference_da': {'file': 'source/entree_grotte_vasques_sud_nord_v1/references/D56P41A.png', 'sha256': sha(REF),
                         'code_rom': REF_CODE, 'provenance': 'source/entree_grotte_vasques_sud_nord_v1/references/provenance.json',
                         'seconde_reference': {'file': 'source/entree_grotte_vasques_sud_nord_v1/references/D56P12A.png',
                                               'sha256': sha(REF2), 'code_rom': 'D56P12A'},
                         'titre': 'grande salle bordee de vasques turquoise ; nom du lieu non identifie par une capture'},
        'generation': GEN,
        'raw_inputs': [{'file': f'source/fin_grotte_vasques_v1/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN[:2]]
                      + [{'file': 'source/entree_grotte_vasques_sud_nord_v1/bruts/source_poses.png', 'sha256': sha(POSES_SHEET),
                          'size': list(Image.open(POSES_SHEET).size)}],
        'sol_complet': {'recalage_px': [0, 0], **recalage(a, f), 'note': 'sable seul bord a bord, marches gardees'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne',
                         'brut': fid, 'brut_vs_D56P12A': fid2, 'calques_finaux': final_fid,
                         'eau_et_reflets': 'couleurs EXACTES de D56P41A (test : sous-ensemble des couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive ; eau et rebords reduits '
                                     'separement puis reunis dans le calque vasques',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()},
                          'eau': {'couleurs_rip': [list(c) for c in wpal], 'pixels_rip': wcnt,
                                  'regle': 'couleur d eau du rip de luminance la plus proche'}},
        'segmentation': 'sol = sable a +-18, ferme 3 px puis ouvert 2 px, grande composante ; marches = decor egal au '
                        'sol complet (ecart median 5 x 5 <= 12, <= 40 px du sable) : claires au sol, sombres aux ombres ; '
                        'ombres = sable assombri contigu (<= 30 px, lum 60-140, ecart-type < 12) ; fond = composantes sarcelle du bandeau '
                        'du haut ; eau = turquoise franc + trainees sombres ; rebords = couronne de 6 px ; parois = le reste',
        'layers': layer_list,
        'reflets_vasques': {'phases': RIP_PHASES, 'frame_length_ticks': RIP_TICKS, 'source': 'BPL D56P41A, palettes 10 et 11',
                            'emplacements': [[list(c) for c in s] for s in slots],
                            'sequence_etats_distincts_rip': pa['sequence_etats_distincts'][:RIP_PHASES],
                            'pixels': int((slot_map >= 0).sum()),
                            'pixels_par_emplacement': [int((slot_map == k).sum()) for k in range(len(slots))],
                            'origine': 'couleurs ET sequence EXACTES de l animation de palette du jeu'},
        'bulles_source': {'planche': 'source/entree_grotte_vasques_sud_nord_v1/bruts/source_poses.png (EGV1, reutilisee)',
                          'poses': {k: list(v) for k, v in E.POSE_WIN.items()},
                          'reduction': {k: list(v) for k, v in E.POSE_K.items()}, 'pixels_teintes_ecartes': tinted,
                          'couleurs': 'ramenees a la couleur d eau de D56P41A la plus proche (RGB)',
                          'emetteurs': [list(e) for e in emitters], 'sequence': BUB_SEQ,
                          'phases': BUB_PHASES, 'frame_length_ticks': BUB_TICKS,
                          'decoupe': 'bulles sur la vasque (eau + rebord), anneaux sur l eau seule',
                          'origine': 'dessin GENERE (planche EGV1) ; chronologie et placement crees par nous'},
        'shadows': 'calque ombres = marches courbes et sable assombri du rendu genere (separe, pas invente)',
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objective_px': objective_px,
                   'path_found_16x16': bool(reach_boss and reach_obj), 'path_to_boss': reach_boss, 'path_to_objective': reach_obj,
                   'cells_explored': explored, 'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'walkable_cells': int((~blocked).sum()), 'rule': 'case bloquee si > 25 % hors sol (ombres comprises)',
                   'boss': 'case 2 x 2 libre la plus proche du centre de gravite du sol praticable',
                   'objectif': 'case 2 x 2 libre la plus haute de la colonne centrale (+-64 px), au pied de la cascade',
                   'fin': 'aucune sortie, aucun warp, pas de donjon_seuil ; la cascade et la voute ferment le nord'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'template': {'file': TEMPLATE.name, 'sha256': sha(TEMPLATE)}, 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objective_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'emitters': emitters, 'seg': seg,
                      'reflets_px': int((slot_map >= 0).sum()), 'px': {k: int(v.sum()) for k, v in ex_l.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'fidelite_D56P12A': {k: v['distance'] for k, v in fid2.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}))


if __name__ == '__main__':
    build()
