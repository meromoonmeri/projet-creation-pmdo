"""Bureau Pelipper (PPO1) — grande salle intérieure 4:3 (768 x 576 px, 96 x 72 cases).

Demande : grande salle spacieuse, textures canoniques TSR 5416 ; mobilier sur tilesheet à part.
- decor.png : ovale vide (murs, fenêtres, herbe, chemin sud) — sans mobilier ;
- temoin_sans_objets.png : identique (salle déjà vide) ;
- sol_complet.png : herbe GBA ;
- PPO1_mobilier_tilesheet.png : foin, sacs, bûches, comptoir, rayonnage, etc. fond magenta, à placer.
Calques : sol complet, herbe, chemin, bois, murs, fond. Pas d'animation.
Marqueurs : entrance sud, comptoir (nord de la cour). Aucun warp.
Lancer : .venv/bin/python source/bureau_pelipper_v1/build.py
"""
from pathlib import Path
import hashlib, importlib.util, io, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / 'bruts'
REF_NAME = 'source/bureau_pelipper_v1/bruts/planche_salle.png'
REF = HERE / 'bruts/planche_salle.png'
OUT = R / 'renders/bureau_pelipper_v1'
STAGE = R / '.cache/bureau_pelipper_v1/bureau_pelipper'
NAMESPACE = 'bureau_pelipper'
ASSET = 'ppo1_bureau_pelipper'
PFX = 'PPO1'
W, H = 768, 576
SRC = (1200, 896)
LOT = 'source/bureau_pelipper_v1'
GEN = [
    {'file': 'decor.png', 'images': [REF_NAME], 'prompt':
     'Pokemon Mystery Dungeon GBA pixel art. Use ONLY the textures from the reference Pelipper Post Office interior — '
     'same orange-tan wooden plank walls, same two pale rounded-square windows, same saturated GBA green grass (almost no '
     'blue), same beige dirt path, same dark outside. Make a LARGE spacious EMPTY top-down oval hall, wide landscape 4:3. '
     'Layout: SOUTH a beige dirt path at the bottom edge center into a WIDE empty green grass courtyard. NORTH wooden '
     'walls with two windows. NO furniture: no counter, no hay, no sacks, no logs, no railing, no shelves. Keep chunky '
     'GBA pixels. No Pelipper, no characters, no text, no UI, no magenta.',
     'essais': 'salle vide spacieuse ; mobilier reporté sur tilesheet'},
    {'file': 'temoin_sans_objets.png', 'images': [f'{LOT}/bruts/decor.png'], 'prompt':
     'Same empty Pelipper Post Office oval hall, same framing and GBA textures. The room already has no furniture. Keep '
     'the wooden walls, two windows, green grass courtyard, beige south path and dark outside exactly as they are. No '
     'text, no characters.',
     'essais': 'salle déjà vide, copie du décor'},
    {'file': 'sol_complet.png', 'images': [f'{LOT}/bruts/decor.png'], 'prompt':
     'Fill the ENTIRE image edge to edge with only the saturated GBA green grass texture from the Pelipper Post Office '
     'courtyard in the reference (RGB around 80 126 2, almost no blue), same chunky pixel grass. No wood, no path, no '
     'objects, no dark areas. Wide landscape 4:3.',
     'essais': 'herbe extraite du décor vide'},
]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


V1 = loadmod('ewc1_build', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
JM, BM = V1.JM, V1.BM
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
keep_large, cell_grid, close_ = V1.keep_large, V1.cell_grid, V1.close_
down_class, down_full, rgba, quantize_group = V1.down_class, V1.down_full, V1.rgba, V1.quantize_group
PALETTE_GROUPS = {'herbe': (['sol_complet', 'herbe'], 48), 'chemin': (['chemin'], 48),
                  'bois': (['bois'], 48), 'murs': (['murs'], 64), 'fond': (['fond'], 16)}
STATIC = ['herbe', 'chemin', 'bois', 'murs', 'fond']


def open_(m, it):
    p = it + 1
    return nd.binary_opening(np.pad(m, p, mode='edge'), iterations=it)[p:-p, p:-p]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p):
    return np.array(Image.open(p).convert('RGB')).astype(int)


def lum_of(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


def materials(a):
    a = a.astype(float); r, g, b = a[..., 0], a[..., 1], a[..., 2]
    herbe = (g > 90) & (g > r + 15) & (b < 50)
    bois = (r > 180) & (g > 110) & (b < 95) & ~herbe
    return {'herbe': herbe,
            'chemin': (r > 180) & (g > 140) & (b >= 95) & (np.abs(r - g) < 60) & ~herbe & ~bois,
            'bois': bois,
            'fond': (r > 200) & (g < 80) & (b > 180)}


def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor); out = {}
    for k in fr:
        if fr[k].sum() < 50 or fd[k].sum() < 50:
            continue
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': [round(float(v), 1) for v in mr], 'decor_rgb': [round(float(v), 1) for v in md],
                  'distance': round(float(np.linalg.norm(mr - md)), 1)}
    return out


def recalage(a, o, zone):
    err = {(dy, dx): float(np.abs(a - np.roll(np.roll(o, dy, 0), dx, 1))[zone].mean())
           for dy in (-1, 0, 1) for dx in (-1, 0, 1)}
    assert min(err, key=err.get) == (0, 0), err
    return {'ecart_moyen': round(err[(0, 0)], 2), 'ecart_decale_1px': round(min(v for k, v in err.items() if k != (0, 0)), 2)}


def classify(a, t):
    """Seuils mesurés sur le brut (1200 x 896) et la planche GBA :
    fond = magenta PMDO (r > 200, g < 80, b > 180), relié au bord ; herbe = g > 90, g > r+15, b < 50 ;
    bois = r > 180, g > 110, b < 95 ; chemin = beige r > 180, g > 140, b >= 95, > 800 px ;
    salle vide : pas d'objets au sol. murs = reliquat orange / brun."""
    r, g, b = a.transpose(2, 0, 1)
    fond = ((t[..., 0] > 180) & (t[..., 1] < 100) & (t[..., 2] > 150)) | ((a[..., 0] > 180) & (a[..., 1] < 100) & (a[..., 2] > 150))
    lab, _ = nd.label(fond); e = np.unique(np.r_[lab[0], lab[-1], lab[:, 0], lab[:, -1]]); fond = np.isin(lab, e[e > 0])
    herbe = keep_large((g > 90) & (g > r + 20) & (b < 40) & ~fond, 5000)
    bois = (r > 180) & (g > 110) & (b < 95) & ~herbe & ~fond
    chemin = (r > 180) & (g > 140) & (b >= 95) & (np.abs(r - g) < 60) & ~herbe & ~fond & ~bois
    chemin = keep_large(close_(chemin, 2), 800)
    murs = (r > 140) & (g > 60) & (r - g > 20) & (r - b > 40) & ~bois & ~herbe & ~chemin & ~fond
    rest = ~(fond | herbe | chemin | bois | murs)
    murs = murs | rest
    masks = dict(herbe=herbe, chemin=chemin, bois=bois, murs=murs, fond=fond)
    seg = {'composantes_herbe': int(nd.label(herbe)[1])}
    return masks, seg


def write_ora(path, layers):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='Bureau Pelipper V1 (PPO1)')
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


def ground_project(stack, blocked, entry_px, counter_px, gfx, tools):
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
    o.update(Name={'DefaultText': 'Bureau Pelipper - interieur (4:3)', 'LocalTexts': {}}, AssetName=ASSET,
             Released=False, TexSize=1, Music='', EdgeView=1, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0},
             ActiveChar=None, Status={}, Layers=layers,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='PMDO 0.8.12. Grande salle interieure du Pelipper Post Office, rendu genere 4:3 reference sur la '
                     'planche Spriters Resource 5416. Aucun warp.')
    o['obstacles'] = [[{'Bounds': {'X': x*8, 'Y': y*8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
                       for y in range(gh)] for x in range(gw)]
    mk = lambda n, p: {'EntName': n, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                       'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
    o['Entities'] = [{'Name': 'Entrees et vos acteurs', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                      'Markers': [mk('entrance', entry_px), mk('comptoir', counter_px)]}]
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
  <Name>Bureau Pelipper 4:3 - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition : grande salle interieure du Pelipper Post Office, generee au format 4:3. Pas une aventure jouable.</Description>
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


def build():
    gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
    tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
    v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
    if OUT.exists():
        for d in ['calques', 'masques', 'review']:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ['calques', 'masques', 'review']:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)
    a, t, f, ref = rgb(RAW / 'decor.png'), rgb(RAW / 'temoin_sans_objets.png'), rgb(RAW / 'sol_complet.png'), rgb(REF)
    assert a.shape[:2] == t.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    m, seg = classify(a, t)
    objs = np.abs(a - t).mean(2) > 10
    reg = {'temoin': recalage(a, t, ~nd.binary_dilation(objs, iterations=4) if objs.any() else np.ones(a.shape[:2], bool))}
    order = ['chemin', 'herbe', 'bois', 'murs', 'fond']
    ex, cols = down_class(a, m, order)
    mag = (cols['murs'][..., 0] > 160) & (cols['murs'][..., 1] < 120) & (cols['murs'][..., 2] > 140)
    mag = mag & (cols['murs'][..., 2] > cols['murs'][..., 1] + 30) & ex['murs']
    if mag.any():
        ex['fond'] = ex['fond'] | mag; ex['murs'] = ex['murs'] & ~mag
        cols['fond'][mag] = (255, 0, 255); cols['murs'][mag] = (0, 0, 0)
    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])
    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q
    mv = layers['murs']
    mag = (mv[..., 0].astype(int) - mv[..., 1].astype(int) > 60) & (mv[..., 2].astype(int) - mv[..., 1].astype(int) > 60) & (mv[..., 3] == 255)
    if mag.any():
        layers['fond'][mag] = (255, 0, 255, 255)
        layers['murs'][mag] = (0, 0, 0, 0)
        ex['fond'] = ex['fond'] | mag; ex['murs'] = ex['murs'] & ~mag
    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')
    cand = ex['herbe'] | ex['chemin']
    cl, _ = nd.label(close_(cand, 3)); seed = cl[H - 1][cand[H - 1]]
    walk = np.isin(cl, np.unique(seed[seed > 0])) & cand
    Image.fromarray((walk * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')
    order_names = ['sol_complet'] + STATIC
    stack_named, layer_list = [], []
    for i, nm in enumerate(order_names):
        frames, ticks = [layers[nm]], 60
        Image.fromarray(layers[nm]).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
        layer_list.append({'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': 60})
        stack_named.append((nm, frames, ticks))
    blocked = cell_grid(~walk); gh_, gw_ = blocked.shape
    pxs = np.nonzero(walk[H - 8])[0]; med = int(np.median(pxs)) // 8
    ecol = min((c for c in range(gw_ - 1) if not blocked[gh_ - 2:, c:c + 2].any()), key=lambda c: abs(c - med))
    entry_px = [ecol * 8, H - 16]
    start = (entry_px[1] // 8, entry_px[0] // 8)
    mid = W // 16
    # comptoir = case 16x16 libre la plus au nord, joignable depuis l'entrée
    from collections import deque
    ok = np.zeros_like(blocked)
    for y in range(gh_ - 1):
        for x in range(gw_ - 1):
            ok[y, x] = not blocked[y:y + 2, x:x + 2].any()
    seen = np.zeros_like(ok); q = deque([start]); seen[start] = True
    reached = []
    while q:
        y, x = q.popleft(); reached.append((x, y))
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if 0 <= ny < gh_ and 0 <= nx < gw_ and ok[ny, nx] and not seen[ny, nx]:
                seen[ny, nx] = True; q.append((ny, nx))
    assert reached, 'pas de case 16x16 depuis l entree'
    top = min(y for _, y in reached)
    band = [(x, y) for x, y in reached if y <= top + 3 and abs(x - mid) <= 14]
    ctr = min(band or reached, key=lambda c: (c[1], abs(c[0] - mid)))
    counter_px = [ctr[0] * 8, ctr[1] * 8]
    reach, explored = v1.reachable(blocked, start, (ctr[1], ctr[0]))
    assert reach, 'pas de chemin 16x16'

    def scene():
        im = Image.new('RGBA', (W, H))
        for _, frames, _ in stack_named:
            im.alpha_composite(Image.fromarray(frames[0]))
        return im
    sc = scene(); sc.save(OUT / 'review' / f'{PFX}_scene_t000.png')
    col = sc.copy(); ov = Image.new('RGBA', (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (counter_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    col.alpha_composite(ov); col.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    write_ora(OUT / f'{PFX}_bureau_pelipper_calques.ora',
              {f'{i:02d}_{tn}': fr[0] for i, (tn, fr, _) in enumerate(stack_named)})
    counts = ground_project([(tn.replace('_', ' '), fr, tk) for tn, fr, tk in stack_named],
                            blocked, entry_px, counter_px, gfx, tools)
    fid = fidelity(a, ref)
    final_fid = {}
    for k, nm in (('herbe', 'herbe'), ('chemin', 'chemin'), ('bois', 'bois'), ('fond', 'fond')):
        if k not in fid:
            continue
        lay = layers[nm]; px = lay[lay[..., 3] == 255][:, :3].astype(float)
        sel = materials(px.reshape(-1, 1, 3))[k][:, 0]
        px = px[sel] if sel.sum() > 50 else px
        final_fid[nm] = {'matiere': k, 'rgb': [round(float(v), 1) for v in px.mean(0)],
                         'distance_rip': round(float(np.linalg.norm(px.mean(0) - np.array(fid[k]['rip_rgb']))), 1)}
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    shutil.copyfile(RAW / 'PPO1_mobilier_tilesheet.png', OUT / 'review' / 'PPO1_mobilier_tilesheet.png')
    if (RAW / 'PPO1_mobilier_tilesheet.json').exists():
        shutil.copyfile(RAW / 'PPO1_mobilier_tilesheet.json', OUT / 'review' / 'PPO1_mobilier_tilesheet.json')
    manifest = {
        'lot': 'bureau_pelipper_v1', 'prefix': PFX, 'format': '4:3 vaste', 'type': 'interieur',
        'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'base': 'branche de session (EWC1 pour les utilitaires) ; aucun emprunt aux branches soeurs',
        'biome': 'interieur du Pelipper Post Office (Red Rescue Team), agrandi, a confirmer',
        'method': 'textures canoniques = rendu genere REFERENCE sur une reconstruction de la planche Spriters Resource 5416 '
                  '(interieur sans poses Pelipper)',
        'reference_da': {'file': REF_NAME, 'sha256': sha(REF),
                         'titre': 'Pelipper Post Office Interior (Red Rescue Team, GBA)',
                         'source': 'https://www.spriters-resource.com/game_boy_advance/pokemonmysterydungeonredrescueteam/asset/5416/',
                         'note': 'reconstruction de la planche (salle seule) : le png officiel n etait pas sur le disque'},
        'generation': GEN,
        'raw_inputs': [{'file': f'{LOT}/bruts/{g["file"]}', 'sha256': sha(RAW / g['file']),
                        'size': list(Image.open(RAW / g['file']).size)} for g in GEN],
        'recalage': {**reg, 'zones': 'temoin : hors objets dilates de 4 px'},
        'segmentation_mesures': seg,
        'fidelite_rip': {'methode': 'moyenne RGB par matiere, meme classifieur pixel ; distance euclidienne ; seuil 35',
                         'brut': fid, 'calques_finaux': final_fid,
                         'sol_complet': round(float(np.linalg.norm(f.reshape(-1, 3).mean(0) - np.array(fid['herbe']['decor_rgb']))), 1)},
        'normalization': {'scale': JM.SCALE, 'scaled': [JM.SCALED_W, H], 'crop_x': [JM.CROP_X, JM.SCALED_W - W - JM.CROP_X],
                          'methode': 'moyenne ponderee par classe (BOX), attribution exclusive par poids maximal',
                          'palettes': {g: {'calques': k, 'couleurs': n} for g, (k, n) in PALETTE_GROUPS.items()}},
        'segmentation': classify.__doc__.split('\n', 1)[1].strip(),
        'layers': layer_list, 'scene_loop_ticks': 60,
        'access': {'entry_px': entry_px, 'counter_px': counter_px, 'path_found_16x16': bool(reach),
                   'cells_explored': explored, 'blocked_cells': int(blocked.sum()),
                   'total_cells': int(blocked.size), 'walkable_cells': int((~blocked).sum()),
                   'rule': 'case bloquee si > 25 % hors praticable (herbe et chemin relies au sud)',
                   'fin': 'aucun warp'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE, 'tiles_per_bank': counts, 'banks': list(counts),
                 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({'entry': entry_px, 'comptoir': counter_px, 'blocked': int(blocked.sum()),
                      'walkable': int((~blocked).sum()), 'seg': seg, 'reg': reg,
                      'px': {k: int(v.sum()) for k, v in ex.items()},
                      'fidelite': {k: v['distance'] for k, v in fid.items()},
                      'final': {k: v['distance_rip'] for k, v in final_fid.items()}, 'tiles': counts}, indent=1))


if __name__ == '__main__':
    build()
