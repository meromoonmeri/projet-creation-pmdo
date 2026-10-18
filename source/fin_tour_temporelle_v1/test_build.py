"""Tests du pipeline FTT1 : sources, segmentation, animations, collisions et export Ground.

.venv/bin/python -m unittest source.fin_tour_temporelle_v1.test_build -v
Ces contrôles de données ne sont pas un test du moteur PMDO.
"""
from pathlib import Path
import hashlib
import importlib.util
import io
import json
import subprocess
import sys
import tempfile
import unittest
import zipfile

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / 'renders/fin_tour_temporelle_v1'
STAGE = ROOT / '.cache/fin_tour_temporelle_v1/fin_tour_temporelle'
M = json.loads((OUT / 'manifest.json').read_text(encoding='utf-8'))


def loadmod(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


B = loadmod('ftt1_test_builder', HERE / 'build.py')


def read_image(path, mode='RGBA'):
    with Image.open(path) as im:
        return np.asarray(im.convert(mode))


def read_mask(name):
    return read_image(OUT / f'masques/FTT1_masque_{name}.png', 'L') > 0


def load_stack():
    stack = []
    for entry in M['layers']:
        rel = entry['file']
        if 'fNN' in rel:
            paths = [OUT / rel.replace('fNN', f'f{t:02d}') for t in range(entry['phases'])]
        else:
            paths = [OUT / rel]
        frames = [read_image(path) for path in paths]
        stack.append((entry['name'], frames, entry['ticks']))
    return stack


class TestFinTourTemporelle(unittest.TestCase):
    def test_format_sources_and_provenance(self):
        self.assertEqual(M['lot'], 'fin_tour_temporelle_v1')
        self.assertEqual(M['prefix'], 'FTT1')
        self.assertEqual(M['size_px'], [768, 576])
        self.assertEqual(M['grid_8px'], [96, 72])
        self.assertEqual(M['format'], '4:3 vaste')
        self.assertFalse(M['art_approved'])
        self.assertFalse(M['runtime_tested'])
        self.assertIn('non explicitement nommée', M['interpretation'])
        for raw in M['raw_inputs']:
            path = ROOT / raw['file']
            self.assertTrue(path.is_file(), path)
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), raw['sha256'])
            with Image.open(path) as im:
                self.assertEqual(list(im.size), raw['size'])
                self.assertEqual(list(im.size), [1200, 896])
        self.assertTrue(M['raw_inputs'][0]['utilise'])
        self.assertTrue(M['raw_inputs'][1]['utilise'])

    def test_reference_rips_have_hashes_and_unverified_names(self):
        index = json.loads((ROOT / 'source/outil_maps_pmdsky/index_rom.json').read_text())
        entries = {m['code']: m for m in index['maps']}
        for code, expected_size in [('D29P11A', [600, 552]), ('D30P34A', [552, 576])]:
            ref = M['references'][code]
            path = ROOT / ref['fichier']
            self.assertTrue(path.is_file(), path)
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), ref['sha256'])
            self.assertEqual(ref['taille_px'], expected_size)
            self.assertEqual(entries[code]['taille_px'], expected_size)
            self.assertIn('non vérifiée', ref['identification_du_lieu'])
        self.assertIn('pas de pixels natifs', M['method'])

    def test_target_size_masks_and_no_key_leak(self):
        for path in sorted((OUT / 'calques').glob('*.png')):
            self.assertEqual(read_image(path).shape, (576, 768, 4), path.name)
        for path in sorted((OUT / 'animation').rglob('*.png')):
            self.assertEqual(read_image(path).shape, (576, 768, 4), path.name)
        for path in sorted((OUT / 'masques').glob('*.png')):
            self.assertEqual(read_image(path, 'L').shape, (576, 768), path.name)
        key = read_mask('magenta')
        self.assertGreater(key.mean(), .12)
        self.assertLess(key.mean(), .32)
        scene = read_image(OUT / 'review/FTT1_scene_t000.png')
        r, g, b = scene[..., :3].transpose(2, 0, 1)
        residual_magenta = (r > 210) & (b > 210) & (g < 75) & (np.abs(r.astype(int) - b.astype(int)) < 60)
        self.assertEqual(int(residual_magenta.sum()), 0)
        self.assertEqual(scene.shape, (576, 768, 4))

    def test_layer_order_and_full_loop(self):
        self.assertEqual(M['layer_order_bottom_to_top'], [
            'CIEL_ABYSSE', 'SOL_COMPLET', 'NUAGES_ROUGE_NOIR', 'DECOR_SOMMET',
            'CIRCUITS_TEMPORELS', 'CRISTAL_TEMPOREL', 'POUSSIERES_TEMPORELLES'])
        self.assertEqual(M['animation']['scene_loop_ticks'], 240)
        expected = {'CIEL_ABYSSE': (1, 60), 'SOL_COMPLET': (1, 60),
                    'NUAGES_ROUGE_NOIR': (24, 10), 'DECOR_SOMMET': (1, 60),
                    'CIRCUITS_TEMPORELS': (24, 10), 'CRISTAL_TEMPOREL': (16, 15),
                    'POUSSIERES_TEMPORELLES': (48, 5)}
        for entry in M['layers']:
            self.assertEqual((entry['phases'], entry['ticks']), expected[entry['name']])
            self.assertEqual(240 % (entry['phases'] * entry['ticks']), 0, entry['name'])
        stack = load_stack()
        self.assertTrue(np.array_equal(B.compose(stack, 0), B.compose(stack, 240)))
        with zipfile.ZipFile(OUT / 'FTT1_fin_tour_temporelle_calques.ora') as z:
            self.assertEqual(z.read('mimetype'), b'image/openraster')
            self.assertEqual(len([n for n in z.namelist() if n.startswith('data/layer')]), 7)
            merged = np.asarray(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        self.assertTrue(np.array_equal(merged, B.compose(stack, 0)))
        self.assertTrue(np.array_equal(merged, read_image(OUT / 'review/FTT1_scene_t000.png')))

    def test_cloud_pulse_is_phaseful_and_stays_on_clouds(self):
        frames = load_stack()[2][1]
        masks = [f[..., 3] > 0 for f in frames]
        self.assertTrue(all(np.array_equal(masks[0], m) for m in masks[1:]))
        self.assertGreater(int(masks[0].sum()), 15000)
        self.assertGreater(len({f.tobytes() for f in frames}), 20)
        for frame in frames:
            self.assertFalse(((frame[..., 3] > 0) & ~masks[0]).any())
        self.assertFalse(np.array_equal(frames[0], frames[12]))

    def test_circuit_wave_uses_gold_ramp_only(self):
        frames = load_stack()[4][1]
        gold = read_mask('circuits_or')
        allowed = {tuple(c) for c in B.GOLD_RAMP}
        union = np.zeros_like(gold)
        active_counts = []
        for frame in frames:
            active = frame[..., 3] > 0
            active_counts.append(int(active.sum()))
            self.assertFalse((active & ~gold).any())
            union |= active
            if active.any():
                colors = {tuple(c) for c in np.unique(frame[active][:, :3], axis=0)}
                self.assertLessEqual(colors, allowed)
        self.assertEqual(active_counts[0], 0)  # front part du centre, avant l’onde
        self.assertEqual(active_counts[-1], 0)  # traîne éteinte au raccord
        self.assertGreater(sum(count > 40 for count in active_counts), 16)
        self.assertGreater(int(union.sum()), 1500)
        self.assertGreater(len({frame.tobytes() for frame in frames}), 18)

    def test_crystal_glow_and_temporal_sparks(self):
        crystal = load_stack()[5][1]
        self.assertEqual(len(crystal), 16)
        self.assertGreater(len({frame.tobytes() for frame in crystal}), 12)
        alphas = np.concatenate([frame[..., 3].ravel() for frame in crystal])
        self.assertTrue(np.any((alphas > 0) & (alphas < 255)))
        self.assertTrue(np.any(alphas == 255))
        sparks = load_stack()[6][1]
        self.assertEqual(len(sparks), 48)
        self.assertGreater(len({frame.tobytes() for frame in sparks}), 36)
        self.assertTrue(all(int((frame[..., 3] > 0).sum()) > 0 for frame in sparks))
        self.assertEqual(M['animation']['poussieres_temporelles']['nombre'], 38)

    def test_walk_grid_markers_and_bfs(self):
        walk = read_mask('praticable')
        blocked = B.BM.cell_grid(~walk)
        access = M['access']
        self.assertEqual(int(blocked.sum()), access['blocked_cells'])
        self.assertEqual(int(blocked.size), access['total_cells'])
        markers = access['markers']
        for name in ('entrance', 'boss_dialga'):
            x, y = markers[name]
            self.assertEqual(x % 8, 0); self.assertEqual(y % 8, 0)
            self.assertFalse(blocked[y // 8:y // 8 + 2, x // 8:x // 8 + 2].any(), name)
        ok, _ = B.V1.reachable(blocked,
            (markers['entrance'][1] // 8, markers['entrance'][0] // 8),
            (markers['boss_dialga'][1] // 8, markers['boss_dialga'][0] // 8))
        self.assertTrue(ok)
        self.assertTrue(access['chemin_16x16']['ok'])
        self.assertFalse(M['boss']['sprite_place'])
        self.assertFalse(M['boss']['acteur_place'])

    def test_ground_schema_tiles_and_markers(self):
        ground_path = STAGE / f'Data/Ground/{M["pmdo"]["asset"]}.rsground'
        self.assertTrue(ground_path.is_file())
        doc = json.loads(ground_path.read_text(encoding='utf-8-sig'))
        obj = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0')
        self.assertEqual(obj['TexSize'], 1)
        self.assertEqual(len(obj['Layers']), len(M['layers']) + 1)
        self.assertEqual(obj['Layers'][-1]['Layer'], 4)
        markers = {m['EntName']: m['Collider'] for m in obj['Entities'][0]['Markers']}
        self.assertEqual(set(markers), {'entrance', 'boss_dialga'})
        for name, pt in M['access']['markers'].items():
            self.assertEqual([markers[name]['X'], markers[name]['Y']], pt)
        self.assertEqual(sum(cell['Tags'] for col in obj['obstacles'] for cell in col), M['access']['blocked_cells'])
        banks = {p.stem for p in (STAGE / 'Content/Tile').glob('*.tile')}
        self.assertEqual(banks, set(M['pmdo']['banks']))
        self.assertTrue(all(name.startswith('FTT1_') for name in banks))
        self.assertEqual(set(B.INDEX.read_index(STAGE / 'Content/Tile/index.idx')), banks)
        lua = (STAGE / f'Data/Script/{M["pmdo"]["namespace"]}/ground/{M["pmdo"]["asset"]}/init.lua').read_text()
        self.assertNotIn('EnterDungeon', lua)
        self.assertNotIn('MoveToZone', lua)
        self.assertIn('aucun warp', lua)
        self.assertFalse(M['pmdo']['runtime_tested'])

    def test_installer_merges_index_without_overwriting(self):
        idx = B.INDEX.read_index(STAGE / 'Content/Tile/index.idx')
        with tempfile.TemporaryDirectory() as td:
            mod = Path(td) / 'test_mod'
            (mod / 'Content/Tile').mkdir(parents=True)
            (mod / 'Mod.xml').write_text('<Header><Name>Test</Name></Header>')
            dummy = B.INDEX.encode_index({'DUMMY': idx[next(iter(sorted(idx))) ]})
            (mod / 'Content/Tile/index.idx').write_bytes(dummy)
            subprocess.run([sys.executable, str(STAGE / 'INSTALLER.py'), str(mod)],
                           check=True, stdout=subprocess.DEVNULL)
            merged = B.INDEX.read_index(mod / 'Content/Tile/index.idx')
            self.assertIn('DUMMY', merged)
            self.assertTrue(set(M['pmdo']['banks']) <= set(merged))
            self.assertTrue((mod / f'Data/Ground/{M["pmdo"]["asset"]}.rsground').is_file())


if __name__ == '__main__':
    unittest.main()
