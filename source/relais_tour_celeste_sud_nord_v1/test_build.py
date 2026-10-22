"""Tests MST1 — Relais Mi-Tour de la Tour Céleste sud -> nord (768x576, 10 calques, D13P02)."""
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
COMMON_DIR = R / 'source/entree_tour_celeste_sud_nord_v1'
if str(COMMON_DIR) not in sys.path:
    sys.path.insert(0, str(COMMON_DIR))

from sky_tower_common import assert_fidelity_below  # noqa: E402

OUT = R / 'renders/relais_tour_celeste_sud_nord_v1'
STAGE = R / '.cache/relais_tour_celeste_sud_nord_v1/relais_tour_celeste'
PFX = 'MST1'
ASSET = 'mst1_relais_tour_celeste'
W, H = 768, 576


def load(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def rgba_arr(p):
    with Image.open(p) as im:
        return np.array(im.convert('RGBA'))


class TestMST1(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.m = json.loads((OUT / 'manifest.json').read_text())
        cls.bpl = json.loads((HERE / 'references/rom_d13p01_bpl.json').read_text())
        cls.gen = load('gen_test_mst1', R / 'source/entree_sud_nord_generee_v1/build.py')

    def test_01_manifest_coherent_honest_and_zero_author(self):
        m = self.m
        self.assertEqual(m['prefix'], PFX)
        self.assertEqual(m['size_px'], [W, H])
        self.assertFalse(m['art_approved'])
        self.assertFalse(m['pmdo']['runtime_tested'])
        self.assertEqual(m['scene_loop_ticks'], 64)
        self.assertNotIn(chr(99) + 'redits', json.dumps(m).lower())
        self.assertIn('<Author></Author>', (STAGE / 'Mod.xml').read_text())

    def test_02_raw_inputs_hashes_and_ora(self):
        for it in self.m['raw_inputs']:
            p = R / it['file']
            self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(), it['sha256'])
        ora_p = OUT / 'MST1_relais_tour_celeste_calques.ora'
        with zipfile.ZipFile(ora_p) as z:
            self.assertEqual(z.namelist()[0], 'mimetype')

    def test_03_ten_layers_partition_and_zero_magenta(self):
        self.assertEqual(len(self.m['layers']), 10)
        static_sum = np.zeros((H, W), dtype=int)
        for idx, lay in enumerate(self.m['layers']):
            files = (
                [OUT / lay['file'].replace('fNN', f'f{t:02d}') for t in range(lay['phases'])]
                if 'fNN' in lay['file'] else [OUT / lay['file']]
            )
            for f in files:
                a = rgba_arr(f)
                self.assertEqual(a.shape, (H, W, 4))
                op = a[..., 3] > 0
                if 1 <= idx <= 7:
                    static_sum += op.astype(int)
                r, g, b = a[..., 0].astype(int), a[..., 1].astype(int), a[..., 2].astype(int)
                self.assertEqual(int((op & (r - g > 24) & (b - g > 18)).sum()), 0, f)
        self.assertTrue(np.all(static_sum == 1))

    def test_04_poses_clean_and_native_sol_complet_exact(self):
        poses = sorted((OUT / 'poses').glob('*.png'))
        self.assertEqual(len(poses), 8)
        sol_lay = rgba_arr(OUT / 'calques/MST1_00_sol_complet.png')[..., :3]
        sol_ref = np.array(Image.open(HERE / 'references/D13P02_sol_natif_768x576.png').convert('RGB'))
        self.assertTrue(np.array_equal(sol_lay, sol_ref), 'Le sol complet natif D13P02 doit être bit-à-bit exact')

    def test_05_exact_rom_bpl_colors_on_layer_08(self):
        pal9 = self.bpl['palette_9_cloud_plumes']['frames']
        pal10 = self.bpl['palette_10_wind_shadows']['frames']
        frames = [rgba_arr(OUT / f'animation/scintillement_bpl/{PFX}_08_scintillement_bpl_f{t:02d}.png') for t in range(8)]
        self.assertFalse(np.array_equal(frames[0], frames[4]))
        for t, fr in enumerate(frames):
            allowed = {tuple(c[:3]) for c in pal9[t][1:]} | {tuple(c[:3]) for c in pal10[t][1:]}
            seen = {tuple(v[:3]) for v in fr[fr[..., 3] > 0].tolist()}
            self.assertLessEqual(seen, allowed)

    def test_06_recomposition_and_walkability_south_to_north(self):
        comp = Image.new('RGBA', (W, H))
        for lay in self.m['layers']:
            with Image.open(OUT / lay['file'].replace('fNN', 'f00')) as im:
                comp.alpha_composite(im.convert('RGBA'))
        self.assertTrue(np.array_equal(np.array(comp), rgba_arr(OUT / 'review/MST1_scene_t000.png')))
        acc = self.m['access']
        with Image.open(OUT / 'masques/MST1_masque_praticable.png') as im:
            walk = np.array(im) > 0
        blocked = ~walk.reshape(72, 8, 96, 8).all(axis=(1, 3))
        ok, _ = self.gen.reachable(
            blocked,
            (acc['entry_px'][1] // 8, acc['entry_px'][0] // 8),
            (acc['threshold_px'][1] // 8, acc['threshold_px'][0] // 8),
        )
        self.assertTrue(ok)

    def test_07_fidelity_under_35_and_mutation_rejection(self):
        fid = self.m['fidelite_rip']
        assert_fidelity_below(fid['brut'], 35.0)
        assert_fidelity_below(fid['calques_finaux'], 35.0)
        self.assertEqual(fid['sol_complet'], 0.0)
        with self.assertRaises(AssertionError):
            assert_fidelity_below({'douve_celeste': {'distance': 41.2}}, 35.0)

    def test_08_ground_tilesets_binary_exact(self):
        g = STAGE / f'Data/Ground/{ASSET}.rsground'
        obj = json.loads(g.read_text(encoding='utf-8-sig'))['Object']
        self.assertEqual(obj['TexSize'], 1)
        self.assertEqual(len(obj['Layers']), 11)
        self.assertEqual(obj['Layers'][-1]['Layer'], 4)
        nr = load('native_reader_mst1', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (STAGE / 'Content/Tile').glob('*.tile')}
        for li, lay in enumerate(self.m['layers']):
            frames = (
                [rgba_arr(OUT / lay['file'].replace('fNN', f'f{t:02d}')) for t in range(lay['phases'])]
                if lay['phases'] > 1 else [rgba_arr(OUT / lay['file'])]
            )
            for t in sorted({0, len(frames) - 1}):
                rec = np.zeros((H, W, 4), np.uint8)
                for x, col in enumerate(obj['Layers'][li]['Tiles']):
                    for y, cell in enumerate(col):
                        for track in cell['Layers']:
                            fr_ref = track['Frames'][t % len(track['Frames'])]
                            rec[y * 8:y * 8 + 8, x * 8:x * 8 + 8] = np.array(
                                nr.straight(banks[fr_ref['Sheet']][fr_ref['TexLoc']['X'], fr_ref['TexLoc']['Y']])
                            )
                self.assertTrue(np.array_equal(rec, frames[t]))


if __name__ == '__main__':
    unittest.main()
