"""Tests unitaires pour Fin Foggy Forest — Sanctuaire de la Stèle de Brume (FFF1)."""
from pathlib import Path
import hashlib, importlib.util, json, struct, unittest, zipfile
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


B = loadmod('fff1_build', HERE / 'build.py')
OUT, STAGE, PFX = B.OUT, B.STAGE, B.PFX


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        m = json.loads((OUT / 'manifest.json').read_text())
        self.assertEqual(m['reference_rip']['sha256'], sha(R / m['reference_rip']['file']))
        for item in m['raw_inputs']:
            p = R / item['file']
            self.assertTrue(p.is_file(), item['file'])
            self.assertEqual(item['sha256'], sha(p), item['file'])
            with Image.open(p) as im:
                self.assertEqual(list(im.size), item['size'])

    def test_sizes_names_alpha_no_magenta(self):
        fixed = sorted((OUT / 'calques').glob('*.png'))
        self.assertEqual(len(fixed), 8)
        for p in fixed:
            self.assertTrue(p.name.startswith(PFX + '_'))
            a = np.array(Image.open(p))
            self.assertEqual(a.shape, (576, 768, 4), p.name)
            self.assertTrue(set(np.unique(a[..., 3])).issubset({0, 255}), p.name)
            v = a[a[..., 3] == 255, :3].astype(int)
            mag = (v[:, 0] - v[:, 1] > 140) & (v[:, 2] - v[:, 1] > 140) & (v[:, 0] > 200) & (v[:, 2] > 200)
            self.assertEqual(int(mag.sum()), 0, f'Magenta residuel dans {p.name}')

    def test_multicalque_full_coverage_and_order(self):
        m = json.loads((OUT / 'manifest.json').read_text())
        self.assertEqual(len(m['layer_order_bottom_to_top']), 10)
        sol = np.array(Image.open(OUT / 'calques' / f'{PFX}_00_sol_complet.png'))
        self.assertTrue((sol[..., 3] == 255).all())
        union = np.zeros((576, 768), bool)
        for p in sorted((OUT / 'calques').glob('*.png'))[1:]:
            a = np.array(Image.open(p))[..., 3] == 255
            self.assertFalse((union & a).any(), f'Chevauchement sur {p.name}')
            union |= a
        self.assertTrue(union.all(), f'Trous: {(~union).sum()} px')

    def test_access_and_closed_borders(self):
        m = json.loads((OUT / 'manifest.json').read_text())
        g = json.loads((STAGE / f'Data/Ground/{B.ASSET}.rsground').read_text(encoding='utf-8-sig'))['Object']
        obs = np.array([[c['Tags'] for c in col] for col in g['obstacles']], dtype=int).T
        ex, ey = m['access']['entry_px'][0] // 8, m['access']['entry_px'][1] // 8
        bx, by = m['access']['boss_px'][0] // 8, m['access']['boss_px'][1] // 8
        ox, oy = m['access']['objectif_px'][0] // 8, m['access']['objectif_px'][1] // 8
        self.assertLess(oy, by)
        self.assertLess(by, ey)
        self.assertTrue((obs[:4, :] > 0).all(), 'Bord nord non ferme')
        self.assertTrue((obs[:, :2] > 0).all(), 'Bord ouest non ferme')
        self.assertTrue((obs[:, -2:] > 0).all(), 'Bord est non ferme')
        self.assertEqual(obs[ey:ey + 2, ex:ex + 2].sum(), 0)
        self.assertEqual(obs[by:by + 2, bx:bx + 2].sum(), 0)
        self.assertEqual(obs[oy:oy + 2, ox:ox + 2].sum(), 0)
        ok1, _ = B.V1.reachable(obs > 0, (ey, ex), (by, bx))
        ok2, _ = B.V1.reachable(obs > 0, (by, bx), (oy, ox))
        self.assertTrue(ok1 and ok2)
        mks = {mk['EntName']: (mk['Collider']['X'], mk['Collider']['Y']) for mk in g['Entities'][0]['Markers']}
        self.assertEqual(set(mks), {'entrance', 'boss', 'objectif'})
        self.assertNotIn('donjon_seuil', mks)

    def test_recalage_temoin(self):
        m = json.loads((OUT / 'manifest.json').read_text())
        self.assertLess(m['sol_complet']['ecart_au_rip'], 15.0)
        self.assertEqual(len(m['sol_complet']['plage_y0_y1_x0_x1']), 4)

    def test_fidelite_rip(self):
        m = json.loads((OUT / 'manifest.json').read_text())
        for scope in ('brut', 'calques_finaux'):
            for k, v in m['fidelite_rip'][scope].items():
                self.assertLess(v['distance'], 35.0, (scope, k, v))

    def test_animations_boucles_fermees(self):
        m = json.loads((OUT / 'manifest.json').read_text())
        self.assertEqual(m['animations']['scene_loop_ticks'], 120)
        for sub in ('lueur_runes', 'feuilles_lucioles'):
            frames = sorted((OUT / 'animation' / sub).glob('*.png'))
            self.assertEqual(len(frames), 24, sub)
            arrs = [np.array(Image.open(p)) for p in frames]
            for a in arrs:
                self.assertEqual(a.shape, (576, 768, 4))
                self.assertTrue(set(np.unique(a[..., 3])).issubset({0, 255}))
                self.assertGreater(int((a[..., 3] == 255).sum()), 0, f'Frame vide dans {sub}')
            diffs = [not np.array_equal(arrs[i], arrs[(i + 1) % 24]) for i in range(24)]
            self.assertTrue(any(diffs), sub)

    def test_palettes_et_matieres(self):
        m = json.loads((OUT / 'manifest.json').read_text())
        for gname, info in m['palettes'].items():
            self.assertLessEqual(info['couleurs'], info['max'], gname)

    def test_ora_and_scene(self):
        ora = OUT / 'FFF1_fin_foggy_forest_calques.ora'
        self.assertTrue(ora.is_file())
        with zipfile.ZipFile(ora) as z:
            self.assertEqual(z.read('mimetype').decode(), 'image/openraster')
            self.assertIn('stack.xml', z.namelist())
        sc = Image.open(OUT / 'review' / f'{PFX}_scene_t000.png')
        self.assertEqual(sc.size, (768, 576))

    def test_ground_roundtrip(self):
        g_path = STAGE / f'Data/Ground/{B.ASSET}.rsground'
        self.assertTrue(g_path.is_file())
        doc = json.loads(g_path.read_text(encoding='utf-8-sig'))
        self.assertEqual(doc['Version'], '0.8.12.0')
        obj = doc['Object']
        self.assertEqual(obj['AssetName'], B.ASSET)
        self.assertEqual(obj['Layers'][-1]['Layer'], 4)
        tiles = {}
        for p in (STAGE / 'Content/Tile').glob('*.tile'):
            raw = p.read_bytes()
            _, count = struct.unpack_from('<ii', raw)
            tiles[p.stem] = {struct.unpack_from('<ii', raw, 8 + i * 16) for i in range(count)}
        for L in obj['Layers']:
            for col in L['Tiles']:
                for cell in col:
                    for t in cell['Layers']:
                        for f in t['Frames']:
                            self.assertIn((f['TexLoc']['X'], f['TexLoc']['Y']), tiles[f['Sheet']])

    def test_prefix_and_namespace_unique(self):
        m = json.loads((OUT / 'manifest.json').read_text())
        self.assertEqual(m['prefix'], 'FFF1')
        self.assertFalse(m['pmdo']['runtime_tested'])
        self.assertFalse(m['art_approved'])


if __name__ == '__main__':
    unittest.main()
