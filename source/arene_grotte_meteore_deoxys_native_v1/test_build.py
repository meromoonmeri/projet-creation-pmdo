"""Tests FGM1 — Grotte Météore · Arène de Deoxys (Port 100 % Natif Multicalque 576x576, 10 calques)."""
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

OUT = R / 'renders/arene_grotte_meteore_deoxys_native_v1'
STAGE = R / '.cache/arene_grotte_meteore_deoxys_native_v1/arene_grotte_meteore_deoxys'
PFX = 'FGM1'
ASSET = 'fgm1_arene_grotte_meteore'
W, H = 576, 576


def load(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def rgba_arr(p):
    with Image.open(p) as im:
        return np.array(im.convert('RGBA'))


class TestFGM1(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.m = json.loads((OUT / 'manifest.json').read_text())
        cls.ref = np.array(Image.open(HERE / 'references/b74_meteor_cave_deoxys.png').convert('RGB'))
        cls.gen = load('gen_test_fgm1', R / 'source/entree_sud_nord_generee_v1/build.py')

    def test_01_manifest_honest_and_zero_author(self):
        m = self.m
        self.assertEqual(m['prefix'], PFX)
        self.assertEqual(m['size_px'], [W, H])
        self.assertFalse(m['art_approved'])
        self.assertFalse(m['pmdo']['runtime_tested'])
        self.assertNotIn(chr(99) + 'redits', json.dumps(m).lower())
        self.assertIn('<Author></Author>', (STAGE / 'Mod.xml').read_text())

    def test_02_bit_exact_native_recomposition_at_t0(self):
        comp = Image.new('RGBA', (W, H))
        for lay in self.m['layers']:
            with Image.open(OUT / lay['file'].replace('fNN', 'f00')) as im:
                comp.alpha_composite(im.convert('RGBA'))
        comp_rgb = np.array(comp)[..., :3]
        self.assertTrue(np.array_equal(comp_rgb, self.ref), 'Recomposition t=0 doit être bit-à-bit égale à b74 !')
        for v in self.m['fidelite_rip']['calques_finaux'].values():
            self.assertEqual(v['distance_rip'], 0.0)
        with self.assertRaises(AssertionError):
            assert_fidelity_below({'dalle': {'distance_rip': 0.5}}, 0.1)

    def test_03_all_animation_frames_strictly_native_b74_palette(self):
        native_palette = {tuple(c) for c in np.unique(self.ref.reshape(-1, 3), axis=0).tolist()}
        for sub in ('onde_psionique_b74', 'levitation_meteorites'):
            idx = 8 if sub == 'onde_psionique_b74' else 9
            frames = [rgba_arr(OUT / f'animation/{sub}/{PFX}_{idx:02d}_{sub}_f{t:02d}.png') for t in range(16)]
            self.assertFalse(np.array_equal(frames[0], frames[4]))
            for t, fr in enumerate(frames):
                seen = {tuple(v[:3]) for v in fr[fr[..., 3] > 0].tolist()}
                self.assertLessEqual(seen, native_palette, f'Couleur non native sur {sub} frame {t}')

    def test_04_whole_meteorite_poses_and_ora(self):
        poses = list((OUT / 'poses').glob('*.png'))
        self.assertEqual(len(poses), 8)
        with zipfile.ZipFile(OUT / 'FGM1_arene_grotte_meteore_calques.ora') as z:
            self.assertEqual(z.namelist()[0], 'mimetype')

    def test_05_walkable_arena_and_binary_tilesets(self):
        acc = self.m['access']
        with Image.open(OUT / 'masques/FGM1_masque_praticable.png') as im:
            walk = np.array(im) > 0
        blocked = ~walk.reshape(72, 8, 72, 8).all(axis=(1, 3))
        ok, _ = self.gen.reachable(
            blocked,
            (acc['entry_px'][1] // 8, acc['entry_px'][0] // 8),
            (acc['boss_px'][1] // 8, acc['boss_px'][0] // 8),
        )
        self.assertTrue(ok)
        g = STAGE / f'Data/Ground/{ASSET}.rsground'
        obj = json.loads(g.read_text(encoding='utf-8-sig'))['Object']
        self.assertEqual(obj['TexSize'], 1)
        self.assertEqual(len(obj['Layers']), 11)
        self.assertEqual(obj['Layers'][-1]['Layer'], 4)
        nr = load('native_reader_fgm1', R / 'source/cote_v5_expeditions/audit_references.py')
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
