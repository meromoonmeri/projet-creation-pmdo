"""EDR1 : rendu référencé D46P11A -> calques -> Ground PMDO 0.8.12.
Les pixels du terrain sont générés, pas extraits de la ROM. Aucun warp.
Exécution depuis n'importe quel dossier : .venv/bin/python source/entree_defile_roches_grises_v1/build.py
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import uuid
import zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
LOT = HERE.name
OUT = ROOT / 'renders' / LOT
NAMESPACE = 'entree_defile_roches_grises'
STAGE = ROOT / '.cache' / LOT / NAMESPACE
PFX, ASSET = 'EDR1', 'edr1_entree_defile_roches_grises'
W, H, PHASES, TICKS = 768, 576, 24, 5
REF = HERE / 'reference/D46P11A.png'
TEMPLATE = ROOT / 'source/cote_v5_expeditions/references/ExplorersOfSkyOrigins__drenched_bluff_entrance.rsground'
# Contour relevé sur le brut 1200 x 896 : séparation du sol / pied des parois.
# C'est un masque de découpe, non une nouvelle géométrie ni un relayout de tuiles.
FLOOR_POLYGON = [(493, 895), (483, 800), (431, 753), (340, 711), (286, 664),
                 (284, 584), (316, 509), (366, 443), (446, 398), (503, 350),
                 (558, 308), (602, 294), (646, 313), (687, 355), (730, 393),
                 (811, 440), (860, 496), (903, 564), (917, 638), (864, 696),
                 (788, 742), (725, 797), (695, 895)]
FIDELITY_MAX = 35


def loadmod(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


CODEC = loadmod('edr1_codec', ROOT / 'source/pmdo_cote/build.py')
TOOLS = loadmod('edr1_installer', ROOT / 'source/pmdo_cote/INSTALLER.py')


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def rgb(path):
    return np.array(Image.open(path).convert('RGB'))


def rgba(colors, mask):
    a = np.zeros((H, W, 4), np.uint8)
    a[..., :3] = colors
    a[mask, 3] = 255
    a[~mask] = 0
    return a


def classify(a):
    r, g, b = a.astype(float).transpose(2, 0, 1)
    mag = (r > 70) & (b > 70) & (r > g * 1.45) & (b > g * 1.45)
    # Inclure les teintes violettes de frange jusqu'au pied de la faille.
    lab, n = nd.label(mag)
    assert n and mag.sum() > 1000, 'Clé magenta absente'
    sizes = np.bincount(lab.ravel()); sizes[0] = 0
    cleft = nd.binary_dilation(lab == sizes.argmax(), iterations=3)
    fringe = (r > g * 1.1) & (b > g * 1.1)
    cleft |= nd.binary_dilation(cleft, iterations=30) & fringe
    poly = Image.new('1', (a.shape[1], a.shape[0]))
    ImageDraw.Draw(poly).polygon(FLOOR_POLYGON, fill=1)
    floor = np.array(poly, bool) & ~cleft
    # Les pixels sombres déjà dessinés au sol forment leur propre calque.
    lum = a.astype(float) @ [.299, .587, .114]
    shadow = floor & (nd.uniform_filter(lum, 5) < 125)
    foot = nd.binary_dilation(floor, iterations=24) & ~floor & ~cleft
    wall = ~(floor | foot | cleft)
    return {'sol': floor & ~shadow, 'ombres': shadow, 'talus': foot,
            'parois': wall, 'profondeur': cleft}


def reduce_classes(a, masks):
    """BOX pondéré par classe ; un seul facteur, crop centré, pas de mélange aux frontières."""
    h, w = a.shape[:2]
    scale = H / h
    scaled_w = round(w * scale)
    assert scaled_w >= W and abs(w / h - 4 / 3) < .025
    crop = (scaled_w - W) // 2

    def plane(p):
        im = Image.fromarray(p.astype(np.float32))
        return np.array(im.resize((scaled_w, H), Image.Resampling.BOX))[:, crop:crop + W]

    weights = np.stack([plane(m) for m in masks.values()])
    winner = weights.argmax(0)
    layers, reduced = {}, {}
    for i, (name, m) in enumerate(masks.items()):
        mask = winner == i
        color = np.stack([plane(a[..., c] * m) for c in range(3)], -1)
        color /= np.maximum(weights[i], 1e-6)[..., None]
        layers[name] = rgba(np.clip(np.round(color), 0, 255).astype('uint8'), mask)
        reduced[name] = mask
    return layers, reduced, plane, {'scale_xy': scale, 'scaled_width': scaled_w, 'crop_left': crop,
                                   'method': 'BOX pondéré par classe, vote maximal, palette commune 96, sans dither'}


def quantize(layers):
    px = np.concatenate([v[v[..., 3] == 255, :3] for v in layers.values()])
    palette = Image.fromarray(px.reshape(-1, 1, 3)).quantize(96, method=Image.Quantize.MEDIANCUT,
                                                         dither=Image.Dither.NONE)
    colors = np.array(palette.getpalette(), np.uint8).reshape(-1, 3)
    for name, a in layers.items():
        q = np.array(Image.fromarray(a[..., :3]).quantize(palette=palette, dither=Image.Dither.NONE))
        layers[name] = rgba(colors[q], a[..., 3] == 255)
    return layers


def materials(a):
    """Même classifieur rip / brut / sorties. Gris de sol clairs ; roche grise plus sombre.
    Les teintes de profondeur et le magenta ne sont pas inclus. Mesure de couleur, pas de structure.
    """
    a = a[..., :3].astype(float)
    lum = a @ [.299, .587, .114]
    neutral = np.ptp(a, axis=-1) < 12
    return {'sol': neutral & (lum >= 130) & (lum < 195),
            'roche': neutral & (lum >= 30) & (lum < 130)}


def fidelity(a, ref):
    am, rm = materials(a), materials(ref)
    result = {}
    for name in am:
        assert am[name].sum() >= 100 and rm[name].sum() >= 100, name
        mean_a, mean_r = a[..., :3][am[name]].mean(0), ref[..., :3][rm[name]].mean(0)
        result[name] = {'distance': round(float(np.linalg.norm(mean_a - mean_r)), 2),
                        'rgb_lot': mean_a.round(2).tolist(), 'rgb_rip': mean_r.round(2).tolist(),
                        'pixels_lot': int(am[name].sum()), 'pixels_rip': int(rm[name].sum())}
    return result


def collision_grid(walk):
    return (~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > .25


def access(blocked):
    free = np.zeros_like(blocked)
    free[:-1, :-1] = ~(blocked[:-1, :-1] | blocked[1:, :-1] | blocked[:-1, 1:] | blocked[1:, 1:])
    lab, _ = nd.label(free, structure=nd.generate_binary_structure(2, 1))
    ys, xs = np.nonzero(free)
    assert len(xs), 'Pas de passage 16 x 16'
    # Choisir la case libre la plus basse, puis la plus proche du centre.
    idx = min(range(len(xs)), key=lambda i: (H // 8 - 2 - ys[i], abs(xs[i] - W // 16)))
    ey, ex = int(ys[idx]), int(xs[idx])
    component = lab == lab[ey, ex]
    gy, gx = np.nonzero(component & (np.abs(np.indices(lab.shape)[1] - W // 16) < 9))
    idx = min(range(len(gx)), key=lambda i: (gy[i], abs(gx[i] - W // 16)))
    markers = {'entrance': [ex * 8, ey * 8], 'donjon_seuil': [int(gx[idx]) * 8, int(gy[idx]) * 8]}
    assert markers['entrance'][1] >= H - 24 and markers['donjon_seuil'][1] < H / 2
    return markers, int(component.sum())


def dust_setup(walk):
    rng = np.random.default_rng(4611)
    safe = nd.distance_transform_edt(walk) > 30
    ys, xs = np.nonzero(safe)
    indices = rng.choice(len(xs), 24, replace=False)
    return [[int(xs[i]), int(ys[i]), j % PHASES] for j, i in enumerate(indices)]


def dust_frame(t, emitters, walk, colors):
    """Vent latéral lent ; 18 phases visibles / 6 au repos, positions périodiques.
    Couleurs exactes du rip, dessin et loi inventés. Ce n'est pas une animation ROM.
    """
    out = np.zeros((H, W, 4), np.uint8)
    for x0, y0, phase in emitters:
        k = (t + phase) % PHASES
        if k >= 18:
            continue
        x = x0 + k - 9
        y = y0 + round(2 * np.sin(2 * np.pi * k / 18))
        c = colors[min(k, 17 - k, len(colors) - 1)]
        for dx, dy in ((0, 0), (-2, 1)):
            if 0 <= x + dx < W and 0 <= y + dy < H and walk[y + dy, x + dx]:
                out[y + dy, x + dx] = (*c, 255)
    return out


def native_project(stack, blocked, markers):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    doc = json.loads(TEMPLATE.read_text(encoding='utf-8-sig'))
    assert doc['Version'] == '0.8.12.0'
    layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        bank = CODEC.TileBank(f'{PFX}_{i:02d}_{title.upper()}')
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)
        pil_frames = [Image.fromarray(a) for a in frames]

        def cell(x, y):
            fs = [bank.add(im.crop((x * 8, y * 8, x * 8 + 8, y * 8 + 8)), x, y)
                  or {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}} for im in pil_frames]
            if all(f['TexLoc'] == {'X': 0, 'Y': 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs

        layers.append(CODEC.layer(f'{i:02d} {title}', W // 8, H // 8, cell, ticks))
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')
        banks.append(bank)
    layers.append(CODEC.layer('07 Vos elements avant-plan (Top)', W // 8, H // 8, draw=4))
    o = doc['Object']
    o.update(Name={'DefaultText': 'Defile des Roches grises - entree 4:3', 'LocalTexts': {}},
             AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1,
             NoSwitching=False, ViewCenter=None, ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None,
             Status={}, Layers=layers, BlankBG=False,
             Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
             Comment='EDR1 : terrain genere reference D46P11A, poussiere calculee. Aucun warp. Runtime non teste.')
    o['obstacles'] = [[{'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8},
                       'Tags': int(blocked[y, x])} for y in range(H // 8)] for x in range(W // 8)]
    o['Entities'] = [{'Name': 'Marqueurs et vos acteurs', 'Visible': True, 'MapChars': [],
                      'GroundObjects': [], 'Spawners': [], 'Markers': [
                          {'EntName': name, 'Direction': 4, 'EntEnabled': True, 'triggerType': 0,
                           'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16}}
                          for name, p in markers.items()]}]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    CODEC.save(STAGE / f'Data/Ground/{ASSET}.rsground', json.dumps(doc, ensure_ascii=False).encode())
    CODEC.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
               f'-- Base d edition, aucun warp ni destination liee.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())
    nodes = {}
    for p in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as stream:
            nodes[p.stem] = TOOLS.read_node(stream)
    (STAGE / 'Content/Tile/index.idx').write_bytes(TOOLS.encode_index(nodes))
    ident = uuid.uuid5(uuid.NAMESPACE_URL, f'https://github.com/meromoonmeri/projet-creation-pmdo/{NAMESPACE}')
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header><Name>Defile des Roches grises - EDR1</Name><Author>meromoonmeri</Author>
<Description>Base d'edition generee reference D46P11A. Aucun warp. Pas une aventure jouable.</Description>
<Namespace>{NAMESPACE}</Namespace><UUID>{ident}</UUID><Version>1.0.0.0</Version>
<GameVersion>0.8.12.0</GameVersion><ModType>Quest</ModType><Relationships /></Header>
''')
    script = (ROOT / 'source/pmdo_cote/INSTALLER.py').read_text()
    needle = '            relative = src.relative_to(source)\n'
    assert script.count(needle) == 1
    script = script.replace(needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n")
    (STAGE / 'INSTALLER.py').write_text(script)
    shutil.copyfile(HERE / 'README_PACK.md', STAGE / 'README.md')
    return {b.name: len(b.data) for b in banks}


def write_ora(stack):
    import xml.etree.ElementTree as ET
    root = ET.Element('image', w=str(W), h=str(H), name='EDR1 Defile des Roches grises')
    group = ET.SubElement(root, 'stack')
    with zipfile.ZipFile(OUT / f'{PFX}_calques.ora', 'w') as z:
        z.writestr('mimetype', 'image/openraster')
        import io
        for i, (name, frames, _) in reversed(list(enumerate(stack))):
            path = f'data/{i:02d}_{name}.png'
            buf = io.BytesIO(); Image.fromarray(frames[0]).save(buf, format='PNG')
            z.writestr(path, buf.getvalue())
            ET.SubElement(group, 'layer', name=name, src=path, opacity='1.0', visibility='visible',
                          **{'composite-op': 'svg:src-over', 'x': '0', 'y': '0'})
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8'))


def build():
    for name in ('calques', 'animation', 'review', 'masques'):
        shutil.rmtree(OUT / name, ignore_errors=True)
        (OUT / name).mkdir(parents=True)
    decor = rgb(HERE / 'bruts/decor_magenta.png')
    sol = rgb(HERE / 'bruts/sol_complet.png')
    assert decor.shape == sol.shape == (896, 1200, 3)
    layers, masks, plane, normal = reduce_classes(decor, classify(decor))
    layers['sol_complet'] = rgba(np.clip(np.round(np.stack([plane(sol[..., c]) for c in range(3)], -1)), 0, 255).astype('uint8'),
                                 np.ones((H, W), bool))
    # Le magenta n'est jamais quantifié avec le terrain. Remplacement par la profondeur bleu-noir du rip.
    ref = rgb(REF)
    dark = ref[(ref[..., 2] > ref[..., 0] + 10) & (ref[..., 0] < 45)]
    assert len(dark) > 10
    colors, counts = np.unique(dark, axis=0, return_counts=True)
    depth_color = colors[counts.argmax()]
    layers['profondeur'] = rgba(depth_color, masks['profondeur'])
    layers = {**quantize({k: a for k, a in layers.items() if k != 'profondeur'}),
              'profondeur': layers['profondeur']}
    walk = masks['sol'] | masks['ombres']
    blocked = collision_grid(walk)
    markers, explored = access(blocked)
    emitters = dust_setup(walk)
    grey = np.unique(ref.reshape(-1, 3), axis=0)
    grey = grey[(np.ptp(grey.astype(int), axis=1) < 8) & (grey.mean(1) >= 110) & (grey.mean(1) < 145)]
    grey = grey[np.argsort(grey.mean(1))]
    dust_colors = grey[np.linspace(0, len(grey) - 1, 4).astype(int)].tolist()
    dust = [dust_frame(t, emitters, walk, dust_colors) for t in range(PHASES)]
    order = ['sol_complet', 'sol', 'ombres', 'talus', 'parois', 'profondeur']
    stack = [(name, [layers[name]], 60) for name in order] + [('poussiere', dust, TICKS)]
    layer_info = []
    for i, (name, frames, ticks) in enumerate(stack):
        file = f'calques/{PFX}_{i:02d}_{name}.png' if len(frames) == 1 else f'animation/{PFX}_{i:02d}_{name}_fNN.png'
        for t, a in enumerate(frames):
            Image.fromarray(a).save(OUT / file.replace('NN', f'{t:02d}'))
        layer_info.append({'name': name, 'file': file, 'phases': len(frames), 'ticks': ticks})
    for name, mask in {**masks, 'praticable': walk, 'collisions': blocked}.items():
        Image.fromarray(mask.astype('uint8') * 255).save(OUT / 'masques' / f'{PFX}_{name}.png')
    scenes = []
    for t in range(PHASES):
        im = Image.new('RGBA', (W, H))
        for _, frames, _ in stack:
            im.alpha_composite(Image.fromarray(frames[t % len(frames)]))
        scenes.append(im)
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                   duration=[83, 83, 84] * 8, loop=0, lossless=True)
    ov = Image.new('RGBA', (W, H))
    dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle((x * 8, y * 8, x * 8 + 7, y * 8 + 7), fill=(230, 30, 30, 85))
    for name, p in markers.items():
        color = (255, 230, 40, 255) if name == 'entrance' else (40, 240, 255, 255)
        dr.rectangle((*p, p[0] + 15, p[1] + 15), outline=color, width=2)
    review = scenes[0].copy(); review.alpha_composite(ov)
    review.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')
    fid = {'brut': fidelity(decor, ref), 'sortie': fidelity(np.array(scenes[0]), ref)}
    assert all(v['distance'] < FIDELITY_MAX for stage in fid.values() for v in stage.values()), fid
    counts = native_project(stack, blocked, markers)
    write_ora(stack)
    manifest = {'lot': LOT, 'prefix': PFX, 'date': '2026-10-16', 'biome': 'Defile des Roches grises (nom descriptif, non officiel)',
                'size_px': [W, H], 'grid_8px': [W // 8, H // 8], 'format': '4:3 vaste',
                'method': 'Rendu genere reference ; calques reduits par classe puis banques natives 8 px. Pas des pixels ROM.',
                'art_approved': False, 'reference': {'file': str(REF.relative_to(ROOT)), 'sha256': sha(REF)},
                'raw_inputs': [{'file': str(p.relative_to(ROOT)), 'sha256': sha(p), 'size': list(Image.open(p).size)}
                               for p in sorted((HERE / 'bruts').glob('*.png'))],
                'generation': json.loads((HERE / 'generation.json').read_text()),
                'normalization': normal, 'segmentation': {'floor_polygon_raw': FLOOR_POLYGON,
                    'shadows': 'luminance lissee 5 px <125 dans le sol ; ombres existantes, non inventees',
                    'talus': 'bande de 24 px autour du sol ; comprend gravats et pieds de rochers, non praticable',
                    'roots': 'racines conservees dans les parois : aucune separation inventee'},
                'fidelity': fid, 'fidelity_max': FIDELITY_MAX, 'layers': layer_info,
                'depth_color': depth_color.tolist(),
                'dust': {'emitters': emitters, 'colors': dust_colors, 'phases': PHASES, 'ticks': TICKS,
                         'origin': 'calculee, couleurs exactes du rip ; reference statique, pas une animation officielle',
                         'law': 'k=(t+phase)%24 ; visible k<18 ; x=x0+k-9 ; y=y0+round(2 sin(2 pi k/18))'},
                'scene_loop_ticks': PHASES * TICKS, 'access': {'markers': markers, 'reachable_16px': True,
                    'reachable_positions': explored, 'warp': False, 'destination_linked': False},
                'origins': {'terrain': 'genere reference D46P11A', 'depth': 'recalcule, couleur exacte du rip',
                            'dust': 'recalcule, couleurs exactes du rip', 'native': 'format .tile et .rsground seulement'},
                'pmdo': {'version': '0.8.12', 'namespace': NAMESPACE, 'asset': ASSET,
                         'template': str(TEMPLATE.relative_to(ROOT)), 'template_sha256': sha(TEMPLATE),
                         'tile_counts': counts, 'runtime_tested': False, 'render_tested': False}}
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'output': str(OUT), 'fidelity': fid, 'markers': markers}, indent=2))


if __name__ == '__main__':
    build()
