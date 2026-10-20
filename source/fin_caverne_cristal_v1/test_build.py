"""Tests FKR1 — Fin Caverne Cristal : Salle des Trois Cristaux (rendu généré référencé, pas un test moteur)."""
import hashlib, importlib.util, io, json, unittest, zipfile
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/fin_caverne_cristal_v1'
STAGE = R / '.cache/fin_caverne_cristal_v1/fin_caverne_cristal'
PFX = 'FKR1'
ASSET = 'fkr1_fin_caverne_cristal'
W, H = 768, 576


def loadmod(name, path):
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


class TestFKR1(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.m = json.loads((OUT / 'manifest.json').read_text())
        cls.bpl = json.loads((HERE / 'references/rom_bpl_palettes.json').read_text())
        cls.gen = loadmod('gen_test_fkr1', R / 'source/entree_sud_nord_generee_v1/build.py')

    def test_manifest_coherent_and_honest(self):
        m = self.m
        self.assertEqual(m['prefix'], PFX)
        self.assertEqual(m['size_px'], [W, H])
        self.assertEqual(m['grid_8px'], [96, 72])
        self.assertFalse(m['art_approved'])
        self.assertFalse(m['pmdo']['runtime_tested'])
        self.assertEqual(m['pmdo']['target'], '0.8.12')
        self.assertEqual(m['scene_loop_ticks'], 2204)
        for L in m['layers']:
            if L['phases'] > 1:
                self.assertEqual(m['scene_loop_ticks'] % (L['phases'] * L['ticks']), 0, L['file'])

    def test_raw_inputs_hashes(self):
        for it in self.m['raw_inputs']:
            p = R / it['file']
            self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(), it['sha256'], it['file'])
            self.assertEqual(list(imsize(p)), it['size'])

    def test_layers_no_magenta_and_static_exclusivity(self):
        self.assertEqual(len(self.m['layers']), 11)
        static_masks = []
        for lay in self.m['layers']:
            files = (
                [OUT / lay['file'].replace('fNN', f'f{t:02d}') for t in range(lay['phases'])]
                if 'fNN' in lay['file'] else [OUT / lay['file']]
            )
            for f in files:
                self.assertTrue(f.exists(), f)
                self.assertEqual(imsize(f), (W, H), f)
                a = rgba(f)
                op = a[..., 3] > 0
                # Note : trois_cristaux traverse légitimement l'indigo/violet de Palette 4-6 de la ROM D16P31A,
                # mais JAMAIS le magenta pur du fond (#FF00FF : r>230 & g<25 & b>230). Sur tous les autres calques,
                # aucune frange magenta/violette n'est tolérée.
                r, g, b = a[..., 0].astype(int), a[..., 1].astype(int), a[..., 2].astype(int)
                pure_magenta = op & (r > 230) & (g < 25) & (b > 230)
                self.assertEqual(int(pure_magenta.sum()), 0, f'Magenta pur dans {f}')
                if lay['id'] != 'trois_cristaux':
                    fringe = op & (r - g > 30) & (b - g > 20)
                    self.assertEqual(int(fringe.sum()), 0, f'Frange magenta/violette dans {f}')
            if lay['phases'] == 1:
                a0 = rgba(files[0])
                self.assertGreater(int((a0[..., 3] > 0).sum()), 300, lay['file'])
                if lay['id'] != 'sol_complet':
                    static_masks.append(a0[..., 3] > 0)
        self.assertEqual(int(np.sum(static_masks, axis=0).max()), 1, 'Chevauchement entre calques statiques découpés')

    def test_poses_clean_no_magenta_halo(self):
        poses = list((OUT / 'poses').glob('*.png'))
        self.assertEqual(len(poses), 4)
        for p in poses:
            a = rgba(p)
            op = a[..., 3] > 0
            self.assertGreater(int(op.sum()), 4, p.name)
            r, g, b = a[..., 0].astype(int), a[..., 1].astype(int), a[..., 2].astype(int)
            bad = op & (r > g + 6)
            self.assertEqual(int(bad.sum()), 0, f'Halo magenta sur pose {p.name}')

    def test_exact_rom_bpl_palettes_3_4_5_6(self):
        pals = self.bpl['animated_palettes']
        pal3 = pals['3']['frames_rgb']
        self.assertEqual(len(pal3), 19)
        veins = [rgba(OUT / f'animation/veines_cristal/{PFX}_08_veines_cristal_f{t:02d}.png') for t in range(19)]
        self.assertFalse(np.array_equal(veins[0], veins[9]))
        for t, fr in enumerate(veins):
            allowed = {tuple(c) for c in pal3[t]}
            seen = {tuple(v[:3]) for v in fr[fr[..., 3] > 0].tolist()}
            self.assertLessEqual(seen, allowed, f'Veines hors Palette 3 D16P31A à t={t}')

        pal4 = pals['4']['frames_rgb']
        self.assertEqual(len(pal4), 29)
        three = [rgba(OUT / f'animation/trois_cristaux/{PFX}_09_trois_cristaux_f{t:02d}.png') for t in range(29)]
        self.assertFalse(np.array_equal(three[0], three[7]))
        self.assertFalse(np.array_equal(three[7], three[14]))
        self.assertFalse(np.array_equal(three[14], three[21]))
        for t, fr in enumerate(three):
            allowed = (
                {tuple(c) for c in pals['4']['frames_rgb'][(t + 0) % 29]}
                | {tuple(c) for c in pals['5']['frames_rgb'][(t + 10) % 29]}
                | {tuple(c) for c in pals['6']['frames_rgb'][(t + 19) % 29]}
            )
            seen = {tuple(v[:3]) for v in fr[fr[..., 3] > 0].tolist()}
            self.assertLessEqual(seen, allowed, f'Trois cristaux hors Palettes 4-6 D16P31A à t={t}')

    def test_ora_and_scene_recomposition(self):
        with zipfile.ZipFile(OUT / f'{PFX}_fin_caverne_cristal_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Salle des Trois Cristaux', z.read('stack.xml'))
        comp = Image.new('RGBA', (W, H))
        for lay in self.m['layers']:
            with Image.open(OUT / lay['file'].replace('fNN', 'f00')) as im:
                comp.alpha_composite(im.convert('RGBA'))
        self.assertTrue(np.array_equal(np.array(comp), merged))
        self.assertTrue(np.array_equal(np.array(comp), rgba(OUT / f'review/{PFX}_scene_t000.png')))

    def test_closed_arena_access_and_three_markers(self):
        acc = self.m['access']
        self.assertTrue(acc['path_found_16x16'])
        self.assertGreater(acc['walkable_cells'], 1600)
        with Image.open(OUT / f'masques/{PFX}_masque_praticable.png') as im:
            walk = np.array(im) > 0
        # Fermeture intégrale du nord et des flancs est/ouest (aucune sortie de donjon)
        self.assertFalse(bool(walk[:112, :].any()))
        self.assertFalse(bool(walk[:, :16].any()))
        self.assertFalse(bool(walk[:, -16:].any()))
        for key in ('entry_px', 'boss_px', 'objectif_px'):
            x, y = acc[key]
            self.assertTrue(bool(walk[y:y + 16, x:x + 16].all()), (key, x, y))
        self.assertGreater(acc['entry_px'][1], H - 64)
        self.assertLess(acc['objectif_px'][1], H // 2)
        blocked = ~walk.reshape(72, 8, 96, 8).all(axis=(1, 3))
        ok1, _ = self.gen.reachable(blocked, (acc['entry_px'][1] // 8, acc['entry_px'][0] // 8), (acc['boss_px'][1] // 8, acc['boss_px'][0] // 8))
        ok2, _ = self.gen.reachable(blocked, (acc['entry_px'][1] // 8, acc['entry_px'][0] // 8), (acc['objectif_px'][1] // 8, acc['objectif_px'][0] // 8))
        self.assertTrue(ok1 and ok2)

    def test_fidelity_under_35(self):
        fid = self.m['fidelite_rip']
        for k, v in fid['brut'].items():
            self.assertLess(v['distance'], 35.0, k)
        for k, v in fid['calques_finaux'].items():
            self.assertLess(v['distance_rip'], 35.0, k)
        self.assertLess(fid['sol_complet'], 35.0)

    def test_ground_binary_roundtrip_and_no_exit(self):
        g = STAGE / f'Data/Ground/{ASSET}.rsground'
        self.assertTrue(g.exists())
        doc = json.loads(g.read_text())
        obj = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0')
        self.assertEqual(len(obj['Layers']), 12)
        self.assertEqual(obj['Layers'][-1]['Layer'], 4)
        self.assertEqual({mk['EntName'] for mk in obj['Entities'][0]['Markers']}, {'entrance', 'boss', 'objectif'})
        self.assertNotIn('donjon_seuil', json.dumps(obj))

        nr = loadmod('native_reader_fkr1', R / 'source/cote_v5_expeditions/audit_references.py')
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

        tools = loadmod('index_tools_fkr1_test', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(STAGE / 'Content/Tile/index.idx')), set(self.m['pmdo']['tiles_per_bank']))
        init = STAGE / f'Data/Script/fin_caverne_cristal/ground/{ASSET}/init.lua'
        self.assertNotIn('Warp', init.read_text())


if __name__ == '__main__':
    unittest.main()
