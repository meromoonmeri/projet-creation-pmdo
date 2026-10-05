#!/usr/bin/env python3
"""Relecture indépendante des deux Grounds FCT2, des textures et de l'installateur.

Ce contrôle Python ne lance pas PMDO/.NET et ne certifie donc pas l'ouverture dans le moteur.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import sys
import tempfile
import zipfile
import xml.etree.ElementTree as ET

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / 'renders/fin_clairiere_tropicale_v1'
STAGE = ROOT / '.cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale'
W, H = 768, 576
VARIANTS = ('jour', 'nuit')
EXPECTED_LAYERS = {
    'jour': ['sol_complet', 'clairiere', 'ombres', 'jungle', 'roches', 'sanctuaire', 'feuilles', 'canopee_avant'],
    'nuit': ['sol_complet', 'clairiere', 'ombres', 'jungle', 'roches', 'sanctuaire', 'feuilles', 'lumieres', 'canopee_avant'],
}
EXPECTED_LAYER_TITLES = {
    'jour': [
        '00 Sol complet', '01 Clairière', '02 Ombres', '03 Jungle', '04 Roches',
        '05 Sanctuaire', '06 Feuilles', '07 Canopée avant', '08 Top (vide)',
    ],
    'nuit': [
        '00 Sol complet', '01 Clairière', '02 Ombres', '03 Jungle', '04 Roches',
        '05 Sanctuaire', '06 Feuilles', '07 Lumières', '08 Canopée avant', '09 Top (vide)',
    ],
}


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def reachable(blocked, start, goal, clearance=2):
    """BFS indépendant sur la grille de cases, avec une empreinte de 2 × 2."""
    gh, gw = blocked.shape
    ok = np.zeros_like(blocked, dtype=bool)
    for y in range(gh - clearance + 1):
        for x in range(gw - clearance + 1):
            ok[y, x] = not blocked[y:y + clearance, x:x + clearance].any()
    sy, sx = start
    if not (0 <= sy < gh and 0 <= sx < gw and ok[sy, sx]):
        return False
    seen = np.zeros_like(ok)
    pending = [(sy, sx)]
    seen[sy, sx] = True
    for y, x in pending:
        if (y, x) == goal:
            return True
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if 0 <= ny < gh and 0 <= nx < gw and ok[ny, nx] and not seen[ny, nx]:
                seen[ny, nx] = True
                pending.append((ny, nx))
    return False


def _assert_pixels(actual, expected, label):
    a = np.asarray(actual.convert('RGBA') if isinstance(actual, Image.Image) else actual)
    b = np.asarray(expected.convert('RGBA') if isinstance(expected, Image.Image) else expected)
    if a.shape != b.shape or not np.array_equal(a, b):
        raise AssertionError(f'{label}: tailles {a.shape}/{b.shape} ou pixels différents')


def verify(pack=STAGE):
    pack = Path(pack).resolve()
    manifest_path = pack / 'manifest.json'
    if not manifest_path.is_file():
        raise FileNotFoundError(f'Manifeste absent sous {pack}')
    manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
    assets = {key: manifest['variants'][key]['asset'] for key in VARIANTS}
    for asset in assets.values():
        if not (pack / 'Data/Ground' / f'{asset}.rsground').is_file():
            raise FileNotFoundError(f'Ground PMDO manquant : {asset} sous {pack}')
    if len(set(assets.values())) != 2:
        raise AssertionError(f'Les assets jour/nuit doivent rester distincts : {assets}')

    sys.path.insert(0, str(ROOT / 'source/pmdo_cote'))
    native = load_module('fct2_native_reader', ROOT / 'source/pmdo_cote/verify.py')
    installer = load_module('fct2_bundle_installer', pack / 'INSTALLER.py')

    assert manifest['lot'] == 'fin_clairiere_tropicale_v1'
    assert manifest['size_px'] == [W, H] and manifest['grid_8px'] == [W // 8, H // 8]
    assert manifest['pmdo']['target'] == '0.8.12'
    assert manifest['pmdo']['assets'] == [assets['jour'], assets['nuit']]
    assert manifest['pmdo']['runtime_tested'] is False
    assert manifest['art_approved'] is False
    assert set(manifest['variants']) == set(VARIANTS)

    # Provenance/qualité : le rip, les bruts et la mesure finale du jour sont vérifiables.
    reference = manifest['reference_da']
    reference_path = ROOT / reference['file']
    assert reference_path.is_file()
    assert hashlib.sha256(reference_path.read_bytes()).hexdigest() == reference['sha256']
    assert len(manifest['generation']) == 4
    for generated in manifest['generation']:
        generated_path = ROOT / generated['file']
        assert generated_path.is_file()
        assert hashlib.sha256(generated_path.read_bytes()).hexdigest() == generated['sha256']
    for record in manifest['raw_inputs']:
        raw_path = ROOT / record['file']
        assert raw_path.is_file(), raw_path
        with Image.open(raw_path) as im:
            assert list(im.size) == record['size_px'] == [1200, 896]
        source_path = ROOT / record['generator_file']
        assert source_path.is_file()
        assert hashlib.sha256(source_path.read_bytes()).hexdigest() == record['generator_sha256']
    for group in (manifest['fidelity']['raw'], manifest['fidelity']['final_layers_day']):
        for material, data in group.items():
            assert data['distance'] is not None and data['distance'] < 35, (material, data)
    assert [layer['name'] for layer in manifest['variants']['jour']['layers']] == EXPECTED_LAYERS['jour']
    assert [layer['name'] for layer in manifest['variants']['nuit']['layers']] == EXPECTED_LAYERS['nuit']
    assert manifest['variants']['jour']['animation']['feuilles']['phases'] == 24
    assert manifest['variants']['nuit']['animation']['feuilles']['phases'] == 24
    night_lights = manifest['variants']['nuit']['lighting']
    assert night_lights['phases'] == 24 and night_lights['alpha_max'] <= 64
    assert night_lights['max_opacity_percent'] < 26
    assert manifest['reference_da']['status'].endswith('textures du lot générées, non natives')

    # Stage de fichiers binaires, banques de tuiles et index fusionnable.
    tile_paths = sorted((pack / 'Content/Tile').glob('*.tile'))
    banks = {path.stem: native.read_tile(path) for path in tile_paths}
    assert set(banks) == set(manifest['pmdo']['banks'])
    for name, count in manifest['pmdo']['banks'].items():
        assert len(banks[name]) == count, (name, len(banks[name]), count)
    index_path = pack / 'Content/Tile/index.idx'
    native_nodes = {}
    for path in tile_paths:
        with path.open('rb') as stream:
            native_nodes[path.stem] = installer.read_node(stream)
    if index_path.is_file():
        indexed = installer.read_index(index_path)
        assert set(indexed) == set(banks)
        assert indexed == native_nodes
    else:
        # L'archive omet l'index autonome afin que l'installateur fusionne avec le mod utilisateur.
        assert not any((pack / 'Content/Tile').glob('*.idx'))

    variant_scenes = {}
    variant_walk = {}
    variant_blocked = {}
    rendered_total = 0
    animation_total = 0
    ora_total = 0
    for variant_key in VARIANTS:
        spec = manifest['variants'][variant_key]
        asset = spec['asset']
        out_dir = OUT / ('' if spec['output_dir'] == '.' else spec['output_dir'])
        ground_path = pack / f'Data/Ground/{asset}.rsground'
        document = json.loads(ground_path.read_text(encoding='utf-8'))
        assert document['Version'] == '0.8.12.0'
        obj = document['Object']
        assert obj['$type'] == 'RogueEssence.Ground.GroundMap, RogueEssence'
        assert obj['TexSize'] == 1 and obj['AssetName'] == asset and not obj['Released']
        assert obj['ActiveChar'] is None
        assert obj['Background']['$type'] == 'RogueEssence.Dungeon.LayeredBG, RogueEssence'
        assert obj['Background']['Layers'] == []
        gw, gh = W // 8, H // 8
        expected_count = len(EXPECTED_LAYER_TITLES[variant_key])
        assert len(obj['Layers']) == expected_count
        assert [layer['Name'] for layer in obj['Layers']] == EXPECTED_LAYER_TITLES[variant_key]
        assert [layer['Layer'] for layer in obj['Layers'][-2:]] == [4, 4]

        for layer in obj['Layers']:
            assert layer['Visible'] and len(layer['Tiles']) == gw
            assert all(len(column) == gh for column in layer['Tiles'])
            for column in layer['Tiles']:
                for cell in column:
                    assert cell['AutoTileset'] == '' and cell['Associates'] == []
                    for animation in cell['Layers']:
                        assert animation['FrameLength'] > 0
                        assert animation['Frames']
                        for frame in animation['Frames']:
                            sheet = frame['Sheet']
                            x = frame['TexLoc']['X']; y = frame['TexLoc']['Y']
                            assert sheet in banks and (x, y) in banks[sheet], (sheet, x, y)

        # Reconstruire chaque calque depuis les .tile (pixels prémultipliés), puis
        # composer les PNG source vérifiés pour contrôler l'aperçu straight-alpha.
        rendered_layers = []
        for index, layer_spec in enumerate(spec['layers']):
            assert layer_spec['name'] == EXPECTED_LAYERS[variant_key][index]
            native_layer = obj['Layers'][index]
            frame_count = layer_spec['phases']
            if frame_count > 1:
                animation_total += frame_count
            for phase in range(frame_count):
                rendered = native.render_layer(native_layer, banks, phase, (W, H))
                relative = layer_spec['file'] if frame_count == 1 else layer_spec['file'].replace('fNN', f'f{phase:02d}')
                expected_image = native.expected(out_dir / relative)
                _assert_pixels(rendered, expected_image, f"{variant_key}/{layer_spec['name']} phase {phase}")
                if phase == 0:
                    rendered_layers.append(Image.open(out_dir / relative).convert('RGBA'))
            rendered_total += 1

        scene = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        for layer in rendered_layers:
            scene = Image.alpha_composite(scene, layer)
        scene_path = OUT / spec['review_scene']
        _assert_pixels(scene, Image.open(scene_path), f'composition {variant_key} phase 0')
        variant_scenes[variant_key] = scene

        # Vérifier les pierres jour (gris chaud : R >= G >= B) et le plafond alpha des lumières.
        if variant_key == 'jour':
            for name in ('roches', 'sanctuaire'):
                image_spec = next(item for item in spec['layers'] if item['name'] == name)
                pixels = np.asarray(Image.open(out_dir / image_spec['file']).convert('RGBA'))
                visible = pixels[..., 3] > 0
                assert visible.any()
                assert np.all(pixels[..., 0][visible] >= pixels[..., 1][visible])
                assert np.all(pixels[..., 1][visible] >= pixels[..., 2][visible])
        else:
            for name in ('roches', 'sanctuaire'):
                image_spec = next(item for item in spec['layers'] if item['name'] == name)
                pixels = np.asarray(Image.open(out_dir / image_spec['file']).convert('RGBA'))
                visible = pixels[..., 3] > 0
                assert visible.any()
                assert np.all(pixels[..., 0][visible] <= pixels[..., 1][visible])
                assert np.all(pixels[..., 1][visible] <= pixels[..., 2][visible])
            light_spec = next(item for item in spec['layers'] if item['name'] == 'lumieres')
            alpha_max = 0
            alpha_min = 255
            for phase in range(light_spec['phases']):
                relative = light_spec['file'].replace('fNN', f'f{phase:02d}')
                alpha = np.asarray(Image.open(out_dir / relative).convert('RGBA'))[..., 3]
                positive = alpha[alpha > 0]
                assert len(positive)
                alpha_max = max(alpha_max, int(positive.max()))
                alpha_min = min(alpha_min, int(positive.min()))
            assert alpha_max == night_lights['alpha_max'] and alpha_max <= 64
            assert alpha_min == night_lights['alpha_min_positive']

        # Cases bloquées, marqueurs et chemins recalculés depuis chaque Ground.
        walk = np.zeros((H, W), dtype=bool)
        for name in ('clairiere', 'ombres'):
            layer_spec = next(item for item in spec['layers'] if item['name'] == name)
            image = np.asarray(Image.open(out_dir / layer_spec['file']).convert('RGBA'))
            walk |= image[..., 3] > 0
        blocked = (~walk).reshape(gh, 8, gw, 8).mean((1, 3)) > 0.25
        assert len(obj['obstacles']) == gw
        native_blocked = np.zeros((gh, gw), dtype=bool)
        for x, column in enumerate(obj['obstacles']):
            assert len(column) == gh
            for y, obstacle in enumerate(column):
                assert obstacle == {'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8},
                                    'Tags': int(blocked[y, x])}
                native_blocked[y, x] = obstacle['Tags'] != 0
        assert np.array_equal(blocked, native_blocked)
        variant_walk[variant_key] = walk
        variant_blocked[variant_key] = blocked

        markers = {marker['EntName']: marker for marker in obj['Entities'][0]['Markers']}
        assert set(markers) == {'entrance', 'boss', 'objectif'}
        for name, marker in markers.items():
            box = marker['Collider']
            assert box['Width'] == box['Height'] == 16
            x, y = box['X'] // 8, box['Y'] // 8
            assert box['X'] % 8 == box['Y'] % 8 == 0
            assert not blocked[y:y + 2, x:x + 2].any(), (variant_key, name)
        start = (markers['entrance']['Collider']['Y'] // 8, markers['entrance']['Collider']['X'] // 8)
        for name in ('boss', 'objectif'):
            marker = markers[name]['Collider']
            goal = (marker['Y'] // 8, marker['X'] // 8)
            assert reachable(blocked, start, goal), (variant_key, name)
        assert len(obj['Entities']) == 1
        entity = obj['Entities'][0]
        assert not entity['MapChars'] and not entity['GroundObjects'] and not entity['Spawners']

        # ORA complète et fidèle à la composition phase 0.
        ora_path = OUT / spec['ora']
        with zipfile.ZipFile(ora_path) as archive:
            assert archive.testzip() is None
            stack_root = ET.fromstring(archive.read('stack.xml'))
            assert (int(stack_root.attrib['w']), int(stack_root.attrib['h'])) == (W, H)
            for layer in stack_root.find('stack'):
                assert archive.getinfo(layer.attrib['src'])
            _assert_pixels(Image.open(archive.open('mergedimage.png')), scene, f'composite ORA {variant_key}')
        ora_total += 1

    assert np.array_equal(variant_walk['jour'], variant_walk['nuit'])
    assert np.array_equal(variant_blocked['jour'], variant_blocked['nuit'])
    assert animation_total == 72
    assert rendered_total == len(EXPECTED_LAYERS['jour']) + len(EXPECTED_LAYERS['nuit'])
    assert ora_total == 2

    # Viewer interactif, liens et documentation remis dans le pack.
    viewer_path = OUT / 'review/index.html'
    assert viewer_path.is_file()
    assert 'review/' in (OUT / 'index.html').read_text(encoding='utf-8')
    viewer_html = viewer_path.read_text(encoding='utf-8')
    for token in ('../FCT2_JN_fin_clairiere_tropicale_PMDO_0812.zip', 'manifest.variants', 'data-variant="nuit"', '../manifest.json'):
        assert token in viewer_html, token

    # Installer : dry-run, fusion d'index, sauvegarde, répétition sans changement,
    # puis refus d'écraser une Ground modifiée par l'utilisateur.
    install_report = {}
    with tempfile.TemporaryDirectory(prefix='fct2_install_') as temp:
        target = Path(temp) / 'TestMod'
        (target / 'Content/Tile').mkdir(parents=True)
        (target / 'Mod.xml').write_text('<Header><Name>Test</Name><Namespace>fct2_test_mod</Namespace></Header>',
                                        encoding='utf-8')
        existing_tile = tile_paths[0]
        shutil.copyfile(existing_tile, target / 'Content/Tile/Existing.tile')
        with existing_tile.open('rb') as stream:
            old_node = installer.read_node(stream)
        old_index = installer.encode_index({'Existing': old_node})
        (target / 'Content/Tile/index.idx').write_bytes(old_index)
        installer.install(pack, target, dry_run=True)
        assert not (target / 'Data').exists()
        installer.install(pack, target)
        merged = installer.read_index(target / 'Content/Tile/index.idx')
        assert merged['Existing'] == old_node and set(merged) == set(banks) | {'Existing'}
        backups = list((target / 'Content/Tile').glob('*.bak'))
        assert len(backups) == 1 and backups[0].read_bytes() == old_index
        before = {path.relative_to(target): path.read_bytes() for path in target.rglob('*') if path.is_file()}
        installer.install(pack, target)
        after = {path.relative_to(target): path.read_bytes() for path in target.rglob('*') if path.is_file()}
        assert before == after
        for asset in assets.values():
            for script_path in (
                target / 'Data/Script/ground' / asset / 'init.lua',
                target / 'Data/Script/fct2_test_mod/ground' / asset / 'init.lua',
            ):
                assert script_path.is_file(), script_path
        edited = target / 'Data/Ground' / f'{assets["nuit"]}.rsground'
        edited.write_text('USER EDIT - must not be overwritten', encoding='utf-8')
        before_conflict = {path.relative_to(target): path.read_bytes() for path in target.rglob('*') if path.is_file()}
        try:
            installer.install(pack, target)
        except ValueError as exc:
            assert 'Conflits' in str(exc)
        else:
            raise AssertionError('L’installateur aurait écrasé un Ground modifié')
        after_conflict = {path.relative_to(target): path.read_bytes() for path in target.rglob('*') if path.is_file()}
        assert before_conflict == after_conflict
        install_report = {'dry_run': True, 'index_merge': True, 'index_backup': True,
                          'idempotent': True, 'both_variants_installed': True, 'conflict_protected': True}

    report = {
        'result': 'PASS',
        'target': 'PMDO 0.8.12.0',
        'ground_assets': assets,
        'variants': list(VARIANTS),
        'pixels_each': [W, H],
        'grid_8px': [W // 8, H // 8],
        'tile_banks': len(banks),
        'native_layers_reconstructed': rendered_total,
        'animation_frames_reconstructed': animation_total,
        'ora_documents_checked': ora_total,
        'pixel_differences': 0,
        'stone_day': 'roches and sanctuaire R >= G >= B (warm neutral gray, no green cast)',
        'stone_night': 'roches and sanctuaire R <= G <= B (cool neutral blue-grey, no green cast)',
        'night_lights': {'alpha_min_positive': night_lights['alpha_min_positive'],
                         'alpha_max': night_lights['alpha_max'],
                         'max_opacity_percent': night_lights['max_opacity_percent']},
        'walkability': 'both blocked grids match rendered floor layers; independent 2×2-cell paths reach boss and objective',
        'installer': install_report,
        'pmdo_engine_or_dotnet_tested': False,
        'limitations': [
            'No PMDO editor/runtime opening or .NET deserialization test was run.',
            'Generated art is reference-guided, not canonical native PMD pixels or tiles.',
            'Collision visualization and gameplay still require in-engine review.',
        ],
    }
    (OUT / 'verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n',
                                            encoding='utf-8')
    (pack / 'verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n',
                                            encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return report


if __name__ == '__main__':
    verify(Path(sys.argv[1]) if len(sys.argv) > 1 else STAGE)
