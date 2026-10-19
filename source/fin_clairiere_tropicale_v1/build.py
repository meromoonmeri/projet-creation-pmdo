"""Fin Clairière tropicale V1 (FCT3) — zone de fin de donjon de la clairière tropicale, format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Demande : « Poursuis le projet » (suite des fins de donjon dans l'ordre du mod après FST1). Prolonge l'entrée ETC1
(`entree_clairiere_tropicale_sud_nord_v1`), référence `large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png` (456 x 456).
Préfixe `FCT3` (FTC1, FCT1 et FCT2 sont déjà pris sur des branches sœurs).
Méthode « textures canoniques » = rendu généré RÉFÉRENCÉ (rip passé au générateur en images=) :
- decor_magenta.png : décor d'arène complet 4:3 (1200 x 896), mer au nord en magenta pur, tertre sanctuaire sans bouche sombre ;
- sol_complet.png : herbe seule, éditée depuis le décor (recalée (0, 0), bandes latérales x < 260 et x > 940 recouvertes par l'herbe centrale du même brut) ;
- temoin_sans_objets.png : décor sans palmiers, fleurs, touffes ni cailloux (recalé (0, 0)) ; la différence décor / témoin donne les objets ;
- papillons_poses.png : planche 2 x 6 de l'entrée ETC1, copiée sans nouvelle génération.
Calques : sol complet, herbe, ombres (l'herbe s'assombrit au pied du tertre), dalles, touffes et cailloux, fleurs,
jungle, palmiers, tertre sanctuaire, rive. Pas de profondeur (pas de bouche sombre), pas de seuil, pas de ponton.
Animations, chacune sur son calque, boucles fermées, 24 x 5 ticks, avec les fonctions, profil/crête et couleurs
EXACTES du rip de l'entrée ETC1 :
- mer : vagues du rip (profil de 48 px et crête relevés pixel par pixel, couleurs EXACTES) ; contre la terre, uniquement
  la bande sombre du rip (pas de liseré clair) ;
- papillons : poses de l'entrée ETC1 ; battement 8 phases, vol en huit fermé sur 24 phases.
Scène : PPCM(120, 120) = 120 ticks = 2 s.
Marqueurs : `entrance` (sud), `boss` (centre de la clairière), `objectif` (pied du tertre au nord). Aucune sortie, aucun warp.
Lancer : .venv/bin/python source/fin_clairiere_tropicale_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png'
REF = R / REF_NAME
OUT = R / 'renders/fin_clairiere_tropicale_v1'
STAGE = R / '.cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale'
NAMESPACE = 'fin_clairiere_tropicale'
ASSET = 'fct3_fin_clairiere_tropicale'
PFX = 'FCT3'
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = 120
LOT = 'source/fin_clairiere_tropicale_v1'


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


ETC = loadmod('etc1_build', R / 'source/entree_clairiere_tropicale_sud_nord_v1/build.py')
V1 = ETC.V1
JM, BM = ETC.JM, ETC.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_, open_ = ETC.keep_large, ETC.cell_grid, ETC.close_, ETC.open_
down_class, down_full, rgba, quantize_group = ETC.down_class, ETC.down_full, ETC.rgba, ETC.quantize_group
sha, rgb, lum_of, materials, fidelity, recalage, flower_px = (
    ETC.sha, ETC.rgb, ETC.lum_of, ETC.materials, ETC.fidelity, ETC.recalage, ETC.flower_px)
wave_model, sea_frames, sheet_poses, reduce_pose, paste, flight_pos, butterfly_frames = (
    ETC.wave_model, ETC.sea_frames, ETC.sheet_poses, ETC.reduce_pose, ETC.paste, ETC.flight_pos, ETC.butterfly_frames)
WAVE_COL, WAVE_Y0, WAVE_P, CREST_X, WAVE_STEP = ETC.WAVE_COL, ETC.WAVE_Y0, ETC.WAVE_P, ETC.CREST_X, ETC.WAVE_STEP
BANDE, CALME, SHORE_BAND, SHORE_CALM = ETC.BANDE, ETC.CALME, ETC.SHORE_BAND, ETC.SHORE_CALM
POSE_K, POSE_COV, POSE_WIN, FLAP = ETC.POSE_K, ETC.POSE_COV, ETC.POSE_WIN, ETC.FLAP

FLIGHTS = [
    ('orange', 220, 250, 42, 16, 0), ('jaune', 548, 245, 40, 18, 7),
    ('jaune', 250, 370, 36, 14, 13), ('orange', 518, 375, 44, 16, 19)]
assert PHASES % len(FLAP) == 0

SOL_BANDES_X = [260, 940]                 # bandes latérales de sol_complet recouvertes par l'herbe centrale du même brut
TERTRE_BOX = [478, 722, 305]              # x0, x1, y_max du tertre sanctuaire sur le brut 1200 x 896

GEN = [
    {'file': 'decor_magenta.png', 'images': [REF_NAME], 'prompt':
     'Use EXACTLY the same textures, palette and pixel-art style as the reference image (Pokemon Mystery Dungeon '
     'tropical clearing): same soft muted light yellow-green grass with fine blade texture (not acid yellow), same '
     'dark green dense jungle bushes with leafy outlines, same coconut palm trees, same red, yellow, cyan and pink '
     'hibiscus flower clusters, same tan sandy stepping-stone slabs, same small grey pebbles, same brown earth bank '
     'cliff edge at the shore. Create a NEW top-down map, WIDE LANDSCAPE 4:3 (1200 x 896), zoomed out so the area '
     'feels vast. Layout: along the NORTH edge (top of the image) a band of sea filled with flat pure magenta #FF00FF '
     '(no waves, no foam, no white lines), bordered just below it by the brown earth bank cliff edge running across '
     'the northern shore. In the upper-center, in front of the northern earth bank, a solid tan-brown earth and stone '
     'sanctuary mound with a darker shaded grass band at its foot (NO dark cave hole). In the CENTER, a wide round '
     'open clearing of soft light yellow-green grass, ringed on the LEFT, RIGHT and SOUTH flanks by dense dark green '
     'jungle bushes, coconut palm trees and hibiscus flower clusters. At the SOUTH edge (bottom center), a wide open '
     'corridor of light yellow-green grass and tan sandy stepping-stone slabs enters from the bottom edge between the '
     'jungle bushes and leads north across the clearing to the foot of the northern sanctuary mound. No wooden jetty, '
     'no cave opening, no signpost, no characters, no text, no UI, no border.',
     'essais': 'premier essai ; conforme dès le premier passage (herbe 2.0, jungle 6.7, dalles 7.5 < 35)'},
    {'file': 'sol_complet.png', 'images': [f'{LOT}/bruts/decor_magenta.png'], 'prompt':
     'Same image, same framing and exact pixel-art style, but only the plain soft light yellow-green clearing grass '
     'with its fine blade texture everywhere, covering the whole 1200 x 896 image, nothing else. No jungle bushes, no '
     'trees, no stepping stones, no rock mound, no earth bank, no magenta sea, no text, no border.',
     'essais': 'premier essai ; bandes latérales x < 260 et x > 940 recouvertes en miroir par l herbe centrale du même brut'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor_magenta.png'], 'prompt':
     'Same image, same framing and exact same pixel-art style. Remove every coconut palm tree, every flower cluster, '
     'every small bush tuft and every small grey pebble: replace them with what is around them (the same dense dark '
     'green jungle bushes, or the same light yellow-green grass in the clearing). Keep the northern earth and stone '
     'sanctuary mound, the darker shaded grass band at its foot, the tan stepping-stone slabs, the northern brown '
     'earth bank and the flat pure magenta #FF00FF sea exactly as they are. No text, no border.',
     'essais': 'premier essai ; témoin de segmentation, recalé (0, 0), jamais exporté'},
    {'file': 'papillons_poses.png', 'images': [REF_NAME], 'prompt':
     "REUTILISEE sans nouvelle generation : planche de l'entree ETC1 (source/entree_clairiere_tropicale_sud_nord_v1/"
     'bruts/papillons_poses.png, meme sha256), fenetres et reduction inchangees. Prompt d origine : Pixel-art sprite '
     'sheet on a flat pure magenta #FF00FF background, same pixel style and bright colors as the reference (Pokemon '
     'Mystery Dungeon tropical clearing). 2 rows of 6 small separate sprites, evenly spaced. Row 1: a small orange-red '
     'butterfly seen from above flapping its wings, six poses from wings wide open to wings closed and back. Row 2: a '
     'small bright yellow butterfly seen from above, same six flapping poses. Dark outlines, hard pixel edges, no text.',
     'essais': 'copie de la planche ETC1 (meme biome, memes poses) : aucune generation supplementaire'},
]

PALETTE_GROUPS = {
    'herbe': (['sol_complet', 'herbe', 'ombres'], 96),
    'dalles_touffes': (['dalles', 'touffes'], 64),
    'fleurs': (['fleurs'], 48),
    'vegetation': (['jungle', 'palmiers'], 96),
    'terre': (['tertre', 'rive'], 64),
}
STATIC = ['herbe', 'ombres', 'dalles', 'touffes', 'fleurs', 'jungle', 'palmiers', 'tertre', 'rive']
ANIMS = ['mer', 'papillons']


def clean_sol(f):
    """Recouvre les deux bandes latérales (x < 260 et x > 940) du brut sol_complet par l'herbe centrale du même brut."""
    x0, x1 = SOL_BANDES_X
    fc = f.copy()
    fc[:, :x0] = f[:, x0:2 * x0][:, ::-1]
    fc[:, x1:] = f[:, 2 * x1 - SRC[0]:x1][:, ::-1]
    return fc


# ---------------------------------------------------------------- segmentation pleine résolution
def classify(a, t):
    """a : décor, t : témoin sans objets. Seuils mesurés sur le brut :
    mer = magenta relié au bord nord + filet clair rose-blanc peint contre la rive (b > g - 15, lum > 120, à <= 5 px
    du magenta) ; tertre = massif beige-brun du sanctuaire au nord-centre (x dans 478..722, y <= 305) ; rive = berge
    brune le long de la mer au nord (hors tertre) ; objets = écart décor / témoin lissé 3 px > 24, fermé, trous
    bouchés ; palmiers > 2000 px ; fleurs = >= 12 % de pixels de fleur saturés ; le reste = touffes et cailloux ;
    dalles = beige dans la clairière (y > 280, 30 à 4500 px) ; herbe = lum lissée 9 px > 172 ; ombres = herbe
    assombrie au pied du tertre (lum lissée 5 px entre 105 et 185, à <= 45 px du tertre) ; jungle = le reste."""
    r, g, b = a.transpose(2, 0, 1); lum = lum_of(a)
    hh, ww = lum.shape; yy, xx = np.mgrid[:hh, :ww]
    mag = (r - g > 60) & (b - g > 60)
    lab, _ = nd.label(mag); water = np.isin(lab, np.unique(lab[0][lab[0] > 0]))
    filet = (b > g - 15) & (lum > 120) & nd.binary_dilation(water, iterations=5) & ~water
    water |= filet
    brown = (r >= g - 2) & (r - b > 32) & ~water & (yy < 310)
    brown = keep_large(nd.binary_fill_holes(close_(brown, 3)), 5000)
    tx0, tx1, tym = TERTRE_BOX
    tertre_box = (xx >= tx0) & (xx <= tx1) & (yy <= tym)
    tertre = keep_large(nd.binary_fill_holes(close_(brown & tertre_box, 3)), 15000) & ~water
    rive = keep_large(open_(brown & ~tertre, 1), 2000) & ~water
    diff = nd.uniform_filter(np.abs(a - t).mean(2).astype(float), 3)
    obj = keep_large(nd.binary_fill_holes(close_(diff > 24, 3)), 60) & ~water & ~tertre & ~rive
    ol, on = nd.label(obj); fpx = flower_px(a)
    pal, fle, tou = (np.zeros_like(obj) for _ in range(3)); kinds = {'palmiers': 0, 'fleurs': 0, 'touffes': 0}
    for i, s in enumerate(nd.find_objects(ol)):
        m = ol[s] == i + 1
        if m.sum() > 2000:
            pal[s] |= m; kinds['palmiers'] += 1
        elif fpx[s][m].mean() > 0.12:
            fle[s] |= m; kinds['fleurs'] += 1
        else:
            tou[s] |= m; kinds['touffes'] += 1
    dal = (r >= g) & (r - b > 55) & (lum > 140) & ~tertre & ~rive & ~obj & ~water & (yy > 280)
    dal = nd.binary_fill_holes(close_(dal, 2)) & ~tertre & ~rive & ~obj & ~water
    dl, dn = nd.label(dal); ds = nd.sum(dal, dl, range(1, dn + 1)) if dn else []
    dal = np.isin(dl, [i + 1 for i, v in enumerate(ds) if 30 <= v <= 4500])
    her = (nd.uniform_filter(lum, 9) > 172) & ~water & ~tertre & ~rive
    her = keep_large(open_(close_(her, 3), 3), 20000)
    her = nd.binary_fill_holes(her) & ~obj & ~dal & ~water & ~rive & ~tertre
    sd = np.sqrt(np.maximum(nd.uniform_filter(lum ** 2, 7) - nd.uniform_filter(lum, 7) ** 2, 0))
    Ls = nd.uniform_filter(lum, 5); db = nd.distance_transform_edt(~tertre)
    free = ~(obj | dal | her | water | rive | tertre)
    omb = (g > r) & (g - b > 45) & (Ls > 105) & (Ls < 185) & (db <= 45) & (sd < 16) & free
    omb = keep_large(close_(omb, 2) & free, 300)
    jungle = ~(water | pal | fle | tou | rive | tertre | dal | her | omb)
    masks = dict(mer=water, tertre=tertre, rive=rive, palmiers=pal, fleurs=fle, touffes=tou,
                 dalles=dal, ombres=omb, herbe=her, jungle=jungle)
    ys_, xs_ = np.nonzero(tertre)
    seg = {'objets': int(on), 'objets_par_type': kinds, 'filet_clair_rendu_a_l_eau_px': int(filet.sum()),
           'tertre_y': [int(ys_.min()), int(ys_.max())], 'tertre_x': [int(xs_.min()), int(xs_.max())],
           'ombres_lum': round(float(lum[omb].mean()), 1), 'herbe_lum': round(float(lum[her].mean()), 1)}
    return masks, seg


# ---------------------------------------------------------------- ORA et Ground
def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Fin Clairiere tropicale V1 (FCT3)')
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


def ground_project(stack, blocked, entry_px, boss_px, objective_px, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = json.loads((R / 'cliffdaytest.rsground').read_text(encoding='utf-8-sig'))
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
    o.update(Name={'DefaultText': 'Fin Clairiere tropicale - arene du sanctuaire (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Rendu genere 4:3 reference sur le rip Clairiere tropicale ; mer animee (profil et '
                     'couleurs exacts du rip, bande sombre contre la rive), papillons repris de l entree ETC1. '
                     'Collisions de base a verifier. Aucune sortie ni warp.')
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
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/guilde-treehouse-pmd/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Clairiere tropicale 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : zone de fin de donjon de la clairiere tropicale (arene et tertre sanctuaire face a la mer), generee au format 4:3 (ref. rip Clairiere tropicale), mer et papillons animes. Pas une aventure jouable.</Description>
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
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
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
    a, f_raw, tm, ref = (
        rgb(RAW / 'decor_magenta.png'), rgb(RAW / 'sol_complet.png'),
        rgb(RAW / 'temoin_sans_objets.png'), rgb(REF))
    assert a.shape[:2] == f_raw.shape[:2] == tm.shape[:2] == (SRC[1], SRC[0])
    f = clean_sol(f_raw)
    m, seg = classify(a, tm)
    clair = m['herbe'] & (np.abs(a - tm).mean(2) < 5)
    reg = {'sol_complet': recalage(a, f, clair),
           'temoin': recalage(a, tm, ~m['mer'] & (np.abs(a - tm).mean(2) < 15))}
    order = ['mer', 'palmiers', 'fleurs', 'touffes', 'rive', 'tertre', 'dalles', 'ombres', 'herbe', 'jungle']
    ex, cols = down_class(a, m, order)
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    water = ex['mer']
    # Praticable : herbe, ombres, dalles, touffes reliées à la clairière depuis le bord sud.
    cand = ex['herbe'] | ex['ombres'] | ex['dalles'] | ex['touffes']
    cl, _ = nd.label(cand); seed = cl[H - 1, np.nonzero(cand[H - 1])[0]]
    walk = np.isin(cl, np.unique(seed[seed > 0]))
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    prof, crest = wave_model(ref)
    mer, _ = sea_frames(water, prof, crest)
    poses, pose_pal = sheet_poses(RAW / 'papillons_poses.png')
    for name, p in poses.items():
        Image.fromarray(p).save(OUT / 'poses' / f'{PFX}_{name}.png')
    papillons = butterfly_frames(poses, FLIGHTS)
    anim = {'mer': mer, 'papillons': papillons}
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
    # Collisions : case bloquée si > 25 % hors praticable.
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    free = lambda cx, cy: 0 <= cx < gw_ - 1 and 0 <= cy < gh_ - 1 and not blocked[cy:cy + 2, cx:cx + 2].any()
    wy, wx = np.nonzero(walk); tgt = (int(wx.mean()) // 8, int(wy.mean()) // 8)
    boss_c = min(((cx, cy) for cy in range(gh_) for cx in range(gw_) if free(cx, cy)),
                 key=lambda c: (c[0] - tgt[0]) ** 2 + (c[1] - tgt[1]) ** 2)
    boss_px = [boss_c[0] * 8, boss_c[1] * 8]
    mid = W // 16
    cands = [(cx, cy) for cy in range(gh_) for cx in range(mid - 8, mid + 8) if free(cx, cy)]
    top = min(cy for _, cy in cands)
    obj_c = min((c for c in cands if c[1] <= top + 1), key=lambda c: abs(c[0] - mid))
    objective_px = [obj_c[0] * 8, obj_c[1] * 8]
    reach_boss, explored = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_c[1], boss_c[0]))
    reach_obj, _ = v1.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (obj_c[1], obj_c[0]))
    assert reach_boss and reach_obj, 'pas de chemin 16x16'
    reach = bool(reach_boss and reach_obj)

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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (255, 60, 220, 255)), (objective_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    names = list(POSE_WIN); cw = 15 * 6 + 8
    sheet = Image.new('RGBA', (6 * cw + 8, 2 * cw + 8), (191, 215, 103, 255))
    for i, nm in enumerate(names):
        im = Image.fromarray(poses[nm]); im = im.resize((im.width * 6, im.height * 6), Image.Resampling.NEAREST)
        cx0, cy0 = 8 + (i % 6) * cw, 8 + (i // 6) * cw
        sheet.alpha_composite(im, (cx0 + (cw - 8 - im.width) // 2, cy0 + (cw - 8 - im.height) // 2))
    sheet.save(OUT / 'review' / f'{PFX}_planche_poses.png')
    write_ora(OUT / f'{PFX}_fin_clairiere_tropicale_calques.ora',
              {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)})
    counts = ground_project([(t.replace('_', ' ') + (f' {len(fr)} phases' if len(fr) > 1 else ''), fr, tk)
                             for t, fr, tk in stack_named], blocked, entry_px, boss_px, objective_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('herbe', 'herbe'), ('jungle', 'jungle'), ('dalles', 'dalles')):
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    manifest = {
        'lot': 'fin_clairiere_tropicale_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'fin de donjon', 'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'base': 'branche de session (ETC1 pour les lois d animation et la planche de papillons, cliffdaytest.rsground pour le gabarit 0.8.12) ; aucun emprunt aux branches soeurs',
        'biome': 'fin de la clairiere tropicale (arene du sanctuaire face a la mer, biome de ETC1), choisie par l utilisateur dans l ordre du mod apres FST1',
        'method': 'textures canoniques = rendu genere REFERENCE : rip passe au generateur ; decor complet mer en magenta, '
                  'herbe complete et temoin sans objets edites depuis le decor, planche papillons reprise de ETC1',
        'reference_da': {'file': REF.name, 'sha256': sha(REF),
                         'titre': 'Clairiere tropicale et rive (titre de l audit zones_bg_audit_v1 ; jeu et scene non confirmes)'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'sol_complet_retouche': {'bandes_x_recouvertes': SOL_BANDES_X,
                                 'note': 'les bandes laterales x < 260 et x > 940 du brut contenaient des buissons ; recouvertes en miroir par l herbe centrale du meme brut'},
        'recalage': {**reg, 'zones': 'sol complet : herbe de la clairiere commune au decor et au temoin ; temoin : hors mer a ecart < 15'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel sur le rip et sur le brut ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid,
                         'mer': 'couleurs EXACTES du rip (test : sous-ensemble des couleurs du rip)'},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'ombres': 'calque ombres = herbe du rendu assombrie au pied du tertre sanctuaire (separee, pas inventee)',
        'layers': layer_list,
        'mer': {'phases': PHASES, 'frame_length_ticks': TICKS, 'profil': [list(c) for c in prof], 'periode_px': WAVE_P,
                'profil_source': f'rip, colonne x = {WAVE_COL}, rangees {WAVE_Y0}..{WAVE_Y0 + WAVE_P - 1}',
                'crete': crest, 'crete_source': f'rip, premiere rangee (215,231,247) par colonne, x = {CREST_X[0]}..{CREST_X[1] - 1}',
                'pas_px': WAVE_STEP, 'sens': 'vers le nord', 'bande_rive': list(BANDE), 'calme': list(CALME),
                'rive_px': {'bande': SHORE_BAND, 'calme': SHORE_CALM},
                'liseré': 'aucun : seule la couleur la plus sombre du rip touche la terre',
                'origine': 'profil, crete et couleurs EXACTS du rip (meme loi que ETC1)'},
        'papillons': {'poses': {k: list(v) for k, v in POSE_WIN.items()}, 'reduction': f'x1/{POSE_K}', 'couverture_min': POSE_COV,
                      'fond': 'magenta pur et pixels teintes de magenta (r-g > 60 et b-g > 60), ni gardes ni recolores ; '
                              'chaque fenetre ne garde que la composante qui contient son centre (voisins exclus)',
                      'palette': [[int(round(c)) for c in p] for p in pose_pal], 'battement': FLAP,
                      'vols': [list(fl) for fl in FLIGHTS], 'phases': PHASES, 'frame_length_ticks': TICKS,
                      'origine': 'planche de l entree ETC1 reutilisee sans nouvelle generation (meme sha256)'},
        'scene_loop_ticks': LOOP_TICKS,
        'access': {'entry_px': entry_px, 'boss_px': boss_px, 'objective_px': objective_px, 'path_found_16x16': reach,
                   'path_to_boss': reach_boss, 'path_to_objective': reach_obj, 'cells_explored': explored,
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (herbe, ombres, dalles, touffes reliees)',
                   'boss': 'case 2 x 2 libre la plus proche du centre de gravite du sol praticable',
                   'objectif': 'case 2 x 2 libre la plus haute de la colonne centrale (+-64 px), au pied du tertre sanctuaire',
                   'fin': 'aucune sortie, aucun warp, pas de donjon_seuil ; le bord nord et les flancs sont bloques'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'boss': boss_px, 'objectif': objective_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': sum(counts.values())}, indent=1))


if __name__ == '__main__':
    build()
