"""Tests EST1 — Entrée de la Tour Céleste sud -> nord (768x576, 10 calques, D13P01 + D13P01.bpl)."""
import hashlib
import importlib.util
import json
import sys
import unittest
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))

from sky_tower_common import assert_fidelity_below  # noqa: E402

OUT = R / 'renders/entree_tour_celeste_sud_nord_v1'
STAGE = R / '.cache/entree_tour_celeste_sud_nord_v1/entree_tour_celeste'
PFX = 'EST1'
ASSET = 'est1_entree_tour_celeste'
W, H = 768, 576


def load(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def rgba_arr(p):
    with Image.open(p) as im:
        return np.array(im.convert('RGBA'))


class TestEST1(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.m = json.loads((OUT / 'manifest.json').read_text())
        cls.bpl = json.loads((HERE / 'references/rom_d13p01_bpl.json').read_text())
        cls.gen = load('gen_test_est1', R / 'source/entree_sud_nord_generee_v1/build.py')

    def test_01_manifest_coherent_honest_and_zero_author(self):
        m = self.m
        self.assertEqual(m['prefix'], PFX)
        self.assertEqual(m['size_px'], [W, H])
        self.assertEqual(m['grid_8px'], [96, 72])
        self.assertFalse(m['art_approved'])
        self.assertFalse(m['pmdo']['runtime_tested'])
        self.assertEqual(m['pmdo']['target'], '0.8.12')
        self.assertEqual(m['scene_loop_ticks'], 64)
        forbidden = chr(99) + 'redits'
        self.assertNotIn(forbidden, json.dumps(m).lower())
        mod_xml = (STAGE / 'Mod.xml').read_text()
        self.assertIn('<Author></Author>', mod_xml)

    def test_02_raw_inputs_hashes_and_ora_archive(self):
        for it in self.m['raw_inputs']:
            p = R / it['file']
            self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(), it['sha256'])
        ora_p = OUT / 'EST1_entree_tour_celeste_calques.ora'
        self.assertTrue(ora_p.exists())
        with zipfile.ZipFile(ora_p) as z:
            self.assertEqual(z.namelist()[0], 'mimetype')
            self.assertEqual(z.read('mimetype').decode(), 'image/openraster')
            self.assertIn('stack.xml', z.namelist())

    def test_03_ten_layers_exclusive_partition_and_zero_magenta(self):
        self.assertEqual(len(self.m['layers']), 10)
        static_sum = np.zeros((H, W), dtype=int)
        for idx, lay in enumerate(self.m['layers']):
            files = (
                [OUT / lay['file'].replace('fNN', f'f{t:02d}') for t in range(lay['phases'])]
                if 'fNN' in lay['file'] else [OUT / lay['file']]
            )
            for f in files:
                self.assertTrue(f.exists(), f)
                a = rgba_arr(f)
                self.assertEqual(a.shape, (H, W, 4))
                op = a[..., 3] > 0
                if 1 <= idx <= 7:
                    static_sum += op.astype(int)
                r, g, b = a[..., 0].astype(int), a[..., 1].astype(int), a[..., 2].astype(int)
                mag = op & (r - g > 24) & (b - g > 18)
                self.assertEqual(int(mag.sum()), 0, f'Frange magenta détectée dans {f}')
        self.assertTrue(np.all(static_sum == 1), 'Les calques statiques 01..07 doivent partitionner exactement W x H')

    def test_04_poses_clean_no_halo(self):
        poses = sorted((OUT / 'poses').glob('*.png'))
        self.assertEqual(len(poses), 8)
        for p in poses:
            a = rgba_arr(p)
            op = a[..., 3] > 0
            self.assertGreater(int(op.sum()), 4, p.name)
            r, g, b = a[..., 0].astype(int), a[..., 1].astype(int), a[..., 2].astype(int)
            self.assertEqual(int((op & (r - g > 20) & (b - g > 14)).sum()), 0, p.name)

    def test_05_exact_rom_d13p01_bpl_colors_on_layer_08(self):
        pal9 = self.bpl['palette_9_cloud_plumes']['frames']
        pal10 = self.bpl['palette_10_wind_shadows']['frames']
        frames = [rgba_arr(OUT / f'animation/courants_bpl/{PFX}_08_courants_bpl_f{t:02d}.png') for t in range(8)]
        self.assertFalse(np.array_equal(frames[0], frames[4]))
        for t, fr in enumerate(frames):
            allowed = {tuple(c[:3]) for c in pal9[t][1:]} | {tuple(c[:3]) for c in pal10[t][1:]}
            seen = {tuple(v[:3]) for v in fr[fr[..., 3] > 0].tolist()}
            self.assertLessEqual(seen, allowed, f'Couleur hors table D13P01.bpl à la phase {t}')

    def test_06_recomposition_equals_scene_t000(self):
        comp = Image.new('RGBA', (W, H))
        for lay in self.m['layers']:
            with Image.open(OUT / lay['file'].replace('fNN', 'f00')) as im:
                comp.alpha_composite(im.convert('RGBA'))
        scene = rgba_arr(OUT / 'review' / f'{PFX}_scene_t000.png')
        self.assertTrue(np.array_equal(np.array(comp), scene))

    def test_07_walkable_path_16x16_south_to_north(self):
        acc = self.m['access']
        self.assertTrue(acc['path_found_16x16'])
        self.assertGreater(acc['walkable_cells'], 800)
        with Image.open(OUT / 'masques' / f'{PFX}_masque_praticable.png') as im:
            walk = np.array(im) > 0
        for key in ('entry_px', 'threshold_px'):
            x, y = acc[key]
            self.assertTrue(bool(walk[y:y + 16, x:x + 16].all()), (key, x, y))
        blocked = ~walk.reshape(72, 8, 96, 8).all(axis=(1, 3))
        ok, _ = self.gen.reachable(
            blocked,
            (acc['entry_px'][1] // 8, acc['entry_px'][0] // 8),
            (acc['threshold_px'][1] // 8, acc['threshold_px'][0] // 8),
        )
        self.assertTrue(ok)

    def test_08_fidelity_under_35_and_mutation_rejection(self):
        fid = self.m['fidelite_rip']
        assert_fidelity_below(fid['brut'], 35.0)
        assert_fidelity_below(fid['calques_finaux'], 35.0)
        self.assertLess(fid['sol_complet'], 35.0)
        mutated = {'ciel_royal': {'distance': 38.4, 'ref_rgb': [21, 85, 251], 'mean_rgb': [59, 85, 251]}}
        with self.assertRaises(AssertionError):
            assert_fidelity_below(mutated, 35.0)

    def test_09_ground_tilesets_binary_exact(self):
        g = STAGE / f'Data/Ground/{ASSET}.rsground'
        self.assertTrue(g.exists())
        obj = json.loads(g.read_text(encoding='utf-8-sig'))['Object']
        self.assertEqual(obj['TexSize'], 1)
        self.assertEqual(len(obj['Layers']), 11)
        self.assertEqual(obj['Layers'][-1]['Layer'], 4)
        nr = load('native_reader_est1', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (STAGE / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(self.m['pmdo']['tiles_per_bank']))
        for li, lay in enumerate(self.m['layers']):
            frames = (
                [rgba_arr(OUT / lay['file'].replace('fNN', f'f{t:02d}')) for t in range(lay['phases'])]
                if lay['phases'] > 1 else [rgba_arr(OUT / lay['file'])]
            )
            for t in sorted({0, len(frames) // 2, len(frames) - 1}):
                rec = np.zeros((H, W, 4), np.uint8)
                for x, col in enumerate(obj['Layers'][li]['Tiles']):
                    for y, cell in enumerate(col):
                        for track in cell['Layers']:
                            fr_ref = track['Frames'][t % len(track['Frames'])]
                            rec[y * 8:y * 8 + 8, x * 8:x * 8 + 8] = np.array(
                                nr.straight(banks[fr_ref['Sheet']][fr_ref['TexLoc']['X'], fr_ref['TexLoc']['Y']])
                            )
                self.assertTrue(np.array_equal(rec, frames[t]), f'Écart binaire .tile calque {li} frame {t}')
        tools = load('index_tools_est1', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(STAGE / 'Content/Tile/index.idx')), set(self.m['pmdo']['tiles_per_bank']))


if __name__ == '__main__':
    unittest.main()
