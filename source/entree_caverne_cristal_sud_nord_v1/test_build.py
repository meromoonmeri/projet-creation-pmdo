"""Tests EKR1 — Entrée Caverne Cristal sud -> nord (rendu généré référencé, pas un test moteur)."""
import hashlib, importlib.util, json, unittest
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/entree_caverne_cristal_sud_nord_v1'
STAGE = R / '.cache/entree_caverne_cristal_sud_nord_v1/entree_caverne_cristal_sud_nord'
PFX = 'EKR1'
ASSET = 'ekr1_entree_caverne_cristal'
W, H = 768, 576


def load(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def rgba(p):
    with Image.open(p) as im:
        return np.array(im.convert('RGBA'))


def imsize(p):
    with Image.open(p) as im:
        return im.size


class TestEKR1(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.m = json.loads((OUT / 'manifest.json').read_text())
        cls.bpl = json.loads((HERE / 'references/rom_bpl_palettes.json').read_text())
        cls.gen = load('gen_test_ekr1', R / 'source/entree_sud_nord_generee_v1/build.py')

    def test_manifest_coherent_and_honest(self):
        m = self.m
        self.assertEqual(m['prefix'], PFX)
        self.assertEqual(m['size_px'], [W, H])
        self.assertEqual(m['grid_8px'], [96, 72])
        self.assertFalse(m['art_approved'])
        self.assertFalse(m['pmdo']['runtime_tested'])
        self.assertEqual(m['pmdo']['target'], '0.8.12')
        self.assertEqual(m['scene_loop_ticks'], 88)

    def test_raw_inputs_hashes(self):
        for it in self.m['raw_inputs']:
            p = R / it['file']
            self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(), it['sha256'], it['file'])
            self.assertEqual(list(imsize(p)), it['size'])

    def test_layers_files_and_no_magenta_or_purple_fringe(self):
        self.assertEqual(len(self.m['layers']), 10)
        for lay in self.m['layers']:
            files = (
                [OUT / lay['file'].replace('fNN', f'f{t:02d}') for t in range(lay['phases'])]
                if 'fNN' in lay['file'] else [OUT / lay['file']]
            )
            for f in files:
                self.assertTrue(f.exists(), f)
                self.assertEqual(imsize(f), (W, H), f)
                a = rgba(f)
                opaque = a[..., 3] > 0
                if lay['phases'] == 1:
                    self.assertGreater(int(opaque.sum()), 50, lay['file'])
                r, g, b = a[..., 0].astype(int), a[..., 1].astype(int), a[..., 2].astype(int)
                magenta_fringe = opaque & (r - g > 35) & (b - g > 25)
                self.assertEqual(int(magenta_fringe.sum()), 0, f'Frange magenta/violette dans {f}')

    def test_poses_clean_no_purple_halo(self):
        poses = list((OUT / 'poses').glob('*.png'))
        self.assertEqual(len(poses), 7)
        for p in poses:
            a = rgba(p)
            op = a[..., 3] > 0
            self.assertGreater(int(op.sum()), 4, p.name)
            r, g, b = a[..., 0].astype(int), a[..., 1].astype(int), a[..., 2].astype(int)
            bad = op & (r - g > 30) & (b - g > 20)
            self.assertEqual(int(bad.sum()), 0, f'Halo magenta/violet sur pose {p.name}')

    def test_exact_rom_bpl_palette_8_on_crystal_glow(self):
        pal8 = self.bpl['animated_palettes']['8']['frames_rgb']
        self.assertEqual(len(pal8), 22)
        frames = [rgba(OUT / f'animation/lueur_cristal/{PFX}_08_lueur_cristal_f{t:02d}.png') for t in range(22)]
        self.assertFalse(np.array_equal(frames[0], frames[5]))
        for t, fr in enumerate(frames):
            allowed = {tuple(c) for c in pal8[t]}
            seen = {tuple(v[:3]) for v in fr[fr[..., 3] > 0].tolist()}
            self.assertLessEqual(seen, allowed, f'Couleur hors table BPL D16P11A à la phase {t}')

    def test_recomposition_equals_scene(self):
        comp = Image.new('RGBA', (W, H))
        for lay in self.m['layers']:
            with Image.open(OUT / lay['file'].replace('fNN', 'f00')) as im:
                comp.alpha_composite(im.convert('RGBA'))
        with Image.open(OUT / 'review' / f'{PFX}_scene_t000.png') as sc:
            scene = np.array(sc.convert('RGBA'))
        self.assertTrue(np.array_equal(np.array(comp), scene))

    def test_access_path_16x16_and_markers(self):
        acc = self.m['access']
        self.assertTrue(acc['path_found_16x16'])
        self.assertGreater(acc['walkable_cells'], 1800)
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

    def test_fidelity_under_35(self):
        fid = self.m['fidelite_rip']
        for k, v in fid['brut'].items():
            self.assertLess(v['distance'], 35.0, k)
        for k, v in fid['calques_finaux'].items():
            self.assertLess(v['distance_rip'], 35.0, k)
        self.assertLess(fid['sol_complet'], 35.0)

    def test_ground_tilesets_and_no_warp(self):
        g = STAGE / f'Data/Ground/{ASSET}.rsground'
        self.assertTrue(g.exists())
        self.assertTrue((STAGE / 'Content/Tile/index.idx').exists())
        obj = json.loads(g.read_text())['Object']
        self.assertEqual(obj['AssetName'], ASSET)
        self.assertEqual(len(obj['Layers']), 11)
        self.assertEqual(obj['Layers'][-1]['Layer'], 4)
        markers = obj['Entities'][0]['Markers']
        self.assertEqual([mk['EntName'] for mk in markers], ['entrance', 'donjon_seuil'])
        for name, n in self.m['pmdo']['tiles_per_bank'].items():
            self.assertTrue((STAGE / f'Content/Tile/{name}.tile').exists(), name)
            self.assertGreater(n, 1, name)
        nr = load('native_reader_ekr1', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (STAGE / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(self.m['pmdo']['tiles_per_bank']))
        for li, lay in enumerate(self.m['layers']):
            frames = (
                [rgba(OUT / lay['file'].replace('fNN', f'f{t:02d}')) for t in range(lay['phases'])]
                if lay['phases'] > 1 else [rgba(OUT / lay['file'])]
            )
            for t in sorted({0, len(frames) // 2, len(frames) - 1}):
                rec = np.zeros((H, W, 4), np.uint8)
                for x, col in enumerate(obj['Layers'][li]['Tiles']):
                    for y, cell in enumerate(col):
                        for track in cell['Layers']:
                            if len(track['Frames']) > 1:
                                self.assertEqual((len(track['Frames']), track['FrameLength']), (len(frames), lay['ticks']))
                            fr_ref = track['Frames'][t % len(track['Frames'])]
                            rec[y * 8:y * 8 + 8, x * 8:x * 8 + 8] = np.array(
                                nr.straight(banks[fr_ref['Sheet']][fr_ref['TexLoc']['X'], fr_ref['TexLoc']['Y']])
                            )
                self.assertTrue(np.array_equal(rec, frames[t]), f'Écart binaire .tile sur calque {li} frame {t}')
        tools = load('index_tools_ekr1_test', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(STAGE / 'Content/Tile/index.idx')), set(self.m['pmdo']['tiles_per_bank']))
        init = STAGE / f'Data/Script/entree_caverne_cristal_sud_nord/ground/{ASSET}/init.lua'
        self.assertTrue(init.exists())
        self.assertNotIn('Warp', init.read_text())
        inst = (STAGE / 'INSTALLER.py').read_text()
        self.assertIn("Content/Tile/index.idx", inst)


if __name__ == '__main__':
    unittest.main()
