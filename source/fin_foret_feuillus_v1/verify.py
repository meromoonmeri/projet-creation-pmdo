"""Vérification des SORTIES FFF1, indépendante du générateur.
Relit les PNG, le Ground et les PNG encodés dans les banques .tile.
Ce n'est PAS une exécution de PMDO. Échec immédiat si un invariant est rompu.
"""
from pathlib import Path
import hashlib
import io
import json
import struct

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / 'renders' / HERE.name
STAGE = ROOT / '.cache' / HERE.name / 'fin_foret_feuillus_v1'
W, H, PFX = 768, 576, 'FFF1'


def require(ok, message):
    if not ok:
        raise AssertionError(message)


def load(path):
    with Image.open(path) as im:
        require(im.mode == 'RGBA', f'RGBA attendu : {path}')
        return np.array(im)


def expand(layer):
    return [load(OUT / layer['file'].replace('NN', f'{t:02d}')) for t in range(layer['phases'])]


def decode_tile(path):
    """Lecteur autonome du format TileIndexNode + BaseSheet ; aucun appel au codec d'écriture."""
    raw = path.read_bytes()
    size, count = struct.unpack_from('<ii', raw)
    require(size == 8 and count > 0, f'Taille/count .tile invalide : {path}')
    result = {}
    for i in range(count):
        x, y, offset = struct.unpack_from('<iiq', raw, 8 + i * 16)
        require(offset >= 8 + count * 16 and offset + 8 <= len(raw), 'Offset .tile invalide')
        length = struct.unpack_from('<q', raw, offset)[0]
        require(length > 0 and offset + 8 + length <= len(raw), 'PNG .tile tronqué')
        with Image.open(io.BytesIO(raw[offset + 8:offset + 8 + length])) as im:
            require(im.size == (8, 8) and im.mode == 'RGBA', 'Tuile non RGBA 8 px')
            result[(x, y)] = np.array(im)
    return result


def reconstruct(layer, banks, phase):
    a = np.zeros((H, W, 4), np.uint8)
    require(len(layer['Tiles']) == W // 8, 'Largeur du Ground')
    for x, col in enumerate(layer['Tiles']):
        require(len(col) == H // 8, 'Hauteur du Ground')
        for y, cell in enumerate(col):
            require(not cell['AutoTileset'], 'Autotile inattendu')
            for sub in cell['Layers']:
                frames = sub['Frames']
                if not frames:
                    continue
                frame = frames[phase % len(frames)]
                loc = frame['TexLoc']
                a[y * 8:y * 8 + 8, x * 8:x * 8 + 8] = banks[frame['Sheet']][(loc['X'], loc['Y'])]
    return a


def reachable(blocked, start, goal):
    free = ~(blocked[:-1, :-1] | blocked[1:, :-1] | blocked[:-1, 1:] | blocked[1:, 1:])
    lab, _ = nd.label(free, nd.generate_binary_structure(2, 1))
    x0, y0 = start; x1, y1 = goal
    require(all(v % 8 == 0 for v in (*start, *goal)), 'Marqueur hors grille')
    y0, x0, y1, x1 = y0 // 8, x0 // 8, y1 // 8, x1 // 8
    require(0 <= y0 < lab.shape[0] and 0 <= x0 < lab.shape[1] and
            0 <= y1 < lab.shape[0] and 0 <= x1 < lab.shape[1], 'Marqueur hors carte')
    return bool(lab[y0, x0] > 0 and lab[y0, x0] == lab[y1, x1])


def verify(out=OUT, stage=STAGE):
    # Ces arguments permettent les tests destructifs dans une COPIE, jamais sur les livrables.
    global OUT
    previous = OUT
    OUT = Path(out)
    try:
        return _verify(Path(stage))
    finally:
        OUT = previous


def _verify(stage):
    m = json.loads((OUT / 'manifest.json').read_text())
    require(m['size_px'] == [W, H] and m['grid_8px'] == [96, 72], 'Dimensions manifest')
    require(m['prefix'] == PFX, 'Préfixe')
    require(not m['art_approved'] and not m['pmdo']['runtime_tested'] and not m['pmdo']['render_tested'], 'Validation indue')
    for item in m['raw_inputs'] + [m['reference']]:
        require(hashlib.sha256((ROOT / item['file']).read_bytes()).hexdigest() == item['sha256'], 'Hash source')
    require(hashlib.sha256((ROOT / m['pmdo']['template']).read_bytes()).hexdigest() == m['pmdo']['template_sha256'], 'Hash gabarit')
    expected_names = ['sol_complet', 'herbe', 'terre', 'ombres', 'sous_bois', 'troncs', 'feuillage', 'feuilles']
    require([l['name'] for l in m['layers']] == expected_names, 'Ordre des calques')
    stack = [expand(l) for l in m['layers']]
    for i, frames in enumerate(stack):
        require(len(frames) == (24 if i == 7 else 1), 'Nombre de phases')
        for a in frames:
            require(a.shape == (H, W, 4), 'Taille PNG')
            require(set(np.unique(a[..., 3])) <= {0, 255}, 'Alpha non binaire')
            require(not a[a[..., 3] == 0].any(), 'RGB sous transparence')
            c = a.astype(float)
            mag = (c[..., 0] > 70) & (c[..., 2] > 70) & (c[..., 0] > 1.45 * c[..., 1]) & (c[..., 2] > 1.45 * c[..., 1])
            require(not mag.any(), 'Fuite magenta')
    require((stack[0][0][..., 3] == 255).all(), 'Sol complet troué')
    masks = [frames[0][..., 3] == 255 for frames in stack[1:7]]
    require((np.stack(masks).sum(0) == 1).all(), 'Partition terrain : trou / chevauchement')
    walk = masks[0] | masks[1] | masks[2]
    blocked = (~walk).reshape(72, 8, 96, 8).mean((1, 3)) > .25
    require(blocked[0].all() and blocked[:, 0].all() and blocked[:, -1].all(), 'Bord praticable inattendu')
    png_blocked = np.array(Image.open(OUT / 'masques/FFF1_collisions.png')) > 0
    require(np.array_equal(png_blocked, blocked), 'Masque collisions incorrect')
    for name, mask in zip(expected_names[1:7], masks):
        require(np.array_equal(np.array(Image.open(OUT / f'masques/FFF1_{name}.png')) > 0, mask), 'Masque incorrect : ' + name)
    doc = json.loads((stage / f'Data/Ground/{m["pmdo"]["asset"]}.rsground').read_text())
    require(doc['Version'] == '0.8.12.0', 'Version native')
    ground = doc['Object']
    require(ground['TexSize'] == 1 and ground['AssetName'] == m['pmdo']['asset'], 'Ground identité/grille')
    require(len(ground['Layers']) == 9 and ground['Layers'][-1]['Layer'] == 4, 'Top absent')
    require(all(not cell['Layers'] for col in ground['Layers'][-1]['Tiles'] for cell in col), 'Top non vide')
    require(not ground['Background']['Layers'] and ground['Music'] == '', 'Références héritées')
    entities = ground['Entities']
    require(len(entities) == 1 and all(not entities[0][k] for k in ('MapChars', 'GroundObjects', 'Spawners')), 'Entités héritées')
    marks = {mk['EntName']: [mk['Collider']['X'], mk['Collider']['Y']] for mk in entities[0]['Markers']}
    require(len(entities[0]['Markers']) == 3 and marks == m['access']['markers'] and
            set(marks) == {'entrance', 'boss', 'objectif'}, 'Marqueurs divergents/inattendus')
    require(marks['entrance'][1] >= 552 and marks['objectif'][1] < marks['boss'][1] < marks['entrance'][1], 'Sens sud -> nord')
    for target in ('boss', 'objectif'):
        require(reachable(blocked, marks['entrance'], marks[target]), 'Chemin 16 px interrompu')
    require(nd.distance_transform_edt(walk)[marks['boss'][1]+8, marks['boss'][0]+8] > 40, 'Boss trop proche du bord')
    require(not m['access']['warp'] and not m['access']['destination_linked'], 'Warp inattendu')
    require(len(ground['obstacles']) == 96 and all(len(col) == 72 for col in ground['obstacles']), 'Dimensions collisions Ground')
    for mk in entities[0]['Markers']:
        require(mk['Collider']['Width'] == 16 and mk['Collider']['Height'] == 16, 'Taille marqueur')
    for x, col in enumerate(ground['obstacles']):
        for y, cell in enumerate(col):
            require(cell['Tags'] == int(blocked[y, x]), 'Collisions Ground divergentes')
            require(cell['Bounds'] == {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}, 'Collision hors grille')
    banks = {p.stem: decode_tile(p) for p in (stage / 'Content/Tile').glob('*.tile')}
    require(len(banks) == 8 and all(k.startswith('FFF1_') for k in banks), 'Banques héritées/manquantes')
    import importlib.util
    spec = importlib.util.spec_from_file_location('edr1_index_reader', ROOT / 'source/pmdo_cote/INSTALLER.py')
    index_reader = importlib.util.module_from_spec(spec); spec.loader.exec_module(index_reader)
    index = index_reader.read_index(stage / 'Content/Tile/index.idx')
    require(set(index) == set(banks), 'Index incomplet')
    for name, node in index.items():
        with (stage / f'Content/Tile/{name}.tile').open('rb') as stream:
            require(node == index_reader.read_node(stream), 'Index différent de la banque')
    reconstructions = 0
    for i, (info, frames) in enumerate(zip(m['layers'], stack)):
        layer = ground['Layers'][i]
        for col in layer['Tiles']:
            for cell in col:
                for sub in cell['Layers']:
                    require(sub['FrameLength'] == info['ticks'], 'Cadence native divergente')
        for t, expected in enumerate(frames):
            require(np.array_equal(reconstruct(layer, banks, t), expected), f'Reconstruction .tile différente : {info["name"]} f{t}')
            reconstructions += 1
    dust = stack[-1]
    require(m['scene_loop_ticks'] == 120 and m['dust']['phases'] == 24 and m['dust']['ticks'] == 5, 'Cadence feuilles')
    ref = np.array(Image.open(ROOT / m['reference']['file']).convert('RGB'))
    rip_colors = {tuple(c) for c in np.unique(ref.reshape(-1, 3), axis=0)}
    require(all(tuple(c) in rip_colors for c in m['dust']['colors'] + ([m['depth_color']] if m['depth_color'] is not None else [])), 'Couleur effet hors rip')
    for t, a in enumerate(dust):
        require(0 < (a[..., 3] > 0).sum() < 100, 'Feuilles vide ou envahissante')
        require(not (a[..., 3] > 0)[~walk].any(), 'Feuilles hors sol')
        require(not np.array_equal(a, dust[(t + 1) % 24]), 'Feuilles figée, raccord inclus')
        require(all(tuple(c) in rip_colors for c in np.unique(a[a[..., 3] > 0, :3], axis=0)), 'Pixel feuilles hors rip')
    # Recomposer les scènes depuis les PNG exportés, et non depuis le code du build.
    for t in range(24):
        im = Image.new('RGBA', (W, H))
        for frames in stack:
            im.alpha_composite(Image.fromarray(frames[t % len(frames)]))
        if t == 0:
            require(np.array_equal(np.array(im), load(OUT / 'review/FFF1_scene_t000.png')), 'Recomposition différente')
    require(all(v['distance'] < 35 for stage_fid in m['fidelity'].values() for v in stage_fid.values()), 'Fidélité hors seuil')
    return {'passed': True, 'native_reconstructions': reconstructions, 'layers': 8, 'banks': len(banks),
            'grid': [96, 72], 'clearance_px': 16, 'runtime_tested': False}


if __name__ == '__main__':
    print(json.dumps(verify(), indent=2))
