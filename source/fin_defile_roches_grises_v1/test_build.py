"""Contrôles FDR1 : fin de donjon, textures natives, animations, mutations. Pas un test moteur."""
from contextlib import redirect_stdout
from pathlib import Path
import io
import json
import shutil
import tempfile
import unittest
import xml.etree.ElementTree as ET
import zipfile

import numpy as np
from PIL import Image
from scipy import ndimage as nd

from source.maps_suite_v1.pipeline import Map, module, sha
from . import verify as V

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


class FinDefile(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.map = Map(HERE)
        cls.m = json.loads((cls.map.out / 'manifest.json').read_text())

    def test_native_reconstruction_independante(self):
        r = V.verify()
        self.assertEqual(r['native_reconstructions'], 29)
        self.assertEqual(r['banks'], 6)
        self.assertFalse(r['runtime_tested'])

    def test_marqueurs_et_acces_de_fin(self):
        walk = np.array(Image.open(self.map.out / 'masques/FDR1_praticable.png')) > 0
        blocked = (~walk).reshape(72, 8, 96, 8).mean((1, 3)) > .25
        marks = self.m['access']['markers']
        self.assertEqual(set(marks), {'entrance', 'boss', 'objectif'})
        self.assertGreaterEqual(marks['entrance'][1], 552)
        self.assertLess(marks['objectif'][1], marks['boss'][1])
        self.assertLess(marks['boss'][1], marks['entrance'][1])
        for target in ('boss', 'objectif'):
            self.assertTrue(V.reachable(blocked, marks['entrance'], marks[target]))
        x, y = marks['boss']
        self.assertGreater(nd.distance_transform_edt(walk)[y + 8, x + 8], 40)
        self.assertTrue(blocked[0].all())
        self.assertFalse(self.m['access']['warp'])
        self.assertFalse(self.m['access']['destination_linked'])

    def test_reference_epinglee_et_prompts(self):
        p = json.loads((HERE / 'reference/provenance.json').read_text())
        self.assertEqual(p['commit'], 'c8073235b39746a7ee74e6cea16c730bd91a1e67')
        self.assertEqual(p['entry']['code'], 'D46P41A')
        self.assertEqual(p['sha256'], sha(self.map.ref))
        self.assertGreaterEqual(len(p['source_blobs']), 3)
        g = json.loads((HERE / 'generation.json').read_text())
        self.assertTrue(any('reference/D46P41A.png' in item['images'] for item in g))
        self.assertIn('FULL FRAME', g[-1]['prompt'])
        self.assertIn('no stairs', g[-1]['prompt'])

    def test_fidelite_recalculee(self):
        ref = self.map.b.rgb(self.map.ref)
        for stage, a in [('brut', self.map.b.rgb(HERE / 'bruts/decor.png')),
                         ('sortie', np.array(Image.open(self.map.out / 'review/FDR1_scene_t000.png').convert('RGB')))]:
            measured = self.map.fidelity(a, ref)
            self.assertEqual(measured, self.m['fidelity'][stage])
            for v in measured.values():
                self.assertLess(v['distance'], 35)
                self.assertGreater(v['pixels_lot'], a.shape[0] * a.shape[1] * .1)

    def test_animation_loi_couleurs_et_boucle(self):
        d = self.m['dust']
        walk = np.array(Image.open(self.map.out / 'masques/FDR1_praticable.png')) > 0
        for t in range(24):
            actual = self.map.effect(t, d['emitters'], walk, d['colors'])
            exported = V.load(self.map.out / f'animation/FDR1_05_poussiere_f{t:02d}.png')
            np.testing.assert_array_equal(actual, exported)
            np.testing.assert_array_equal(actual, self.map.effect(t + 24, d['emitters'], walk, d['colors']))
        with Image.open(self.map.out / 'review/FDR1_scene_animee.webp') as im:
            self.assertGreater(im.n_frames, 1)
            duration = 0
            for t in range(im.n_frames):
                im.seek(t); im.load(); duration += im.info.get('duration', 0)
            self.assertEqual(duration, 2000)

    def test_ora_ordonne_sans_fausse_profondeur(self):
        self.assertEqual([l['name'] for l in self.m['layers']],
                         ['sol_complet', 'sol', 'ombres', 'talus', 'parois', 'poussiere'])
        self.assertIsNone(self.m['depth_color'])
        with zipfile.ZipFile(self.map.out / 'FDR1_calques.ora') as z:
            self.assertEqual(z.read('mimetype'), b'image/openraster')
            root = ET.fromstring(z.read('stack.xml'))
            self.assertEqual([n.attrib['name'] for n in root.find('stack')],
                             list(reversed([l['name'] for l in self.m['layers']])))

    def test_falaises_plein_cadre(self):
        # Garde-fou contre les anciens grands coins unis du décor en diorama.
        a = V.load(self.map.out / 'review/FDR1_scene_t000.png')
        for y, x in [(0, 0), (0, 704), (512, 0), (512, 704)]:
            block = a[y:y + 64, x:x + 64, :3]
            self.assertGreater(float(block.std()), 10)
            self.assertGreater(len(np.unique(block.reshape(-1, 3), axis=0)), 15)

    def test_installateur_fusion_protection(self):
        installer = module(self.map.stage / 'INSTALLER.py', 'fdr1_staged_installer')
        with tempfile.TemporaryDirectory(dir=ROOT / '.cache') as tmp:
            target = Path(tmp)
            shutil.copyfile(self.map.stage / 'Mod.xml', target / 'Mod.xml')
            old = target / 'Content/Tile/EXISTANT.tile'; old.parent.mkdir(parents=True)
            shutil.copyfile(next((self.map.stage / 'Content/Tile').glob('*.tile')), old)
            with old.open('rb') as f:
                node = installer.read_node(f)
            idx = old.parent / 'index.idx'; idx.write_bytes(installer.encode_index({'EXISTANT': node}))
            before = {p.relative_to(target): p.read_bytes() for p in target.rglob('*') if p.is_file()}
            with redirect_stdout(io.StringIO()):
                installer.install(self.map.stage, target, dry_run=True)
            self.assertEqual(before, {p.relative_to(target): p.read_bytes() for p in target.rglob('*') if p.is_file()})
            with redirect_stdout(io.StringIO()):
                installer.install(self.map.stage, target)
                saved = idx.read_bytes()
                installer.install(self.map.stage, target)
            self.assertEqual(saved, idx.read_bytes())
            self.assertEqual(len(installer.read_index(idx)), 7)
            self.assertIn('EXISTANT', installer.read_index(idx))
            self.assertEqual(len(list(idx.parent.glob('*.bak'))), 1)
            ground = target / f'Data/Ground/{self.map.config["asset"]}.rsground'
            ground.write_text('carte modifiee par utilisateur')
            with self.assertRaisesRegex(ValueError, 'Conflits'):
                installer.install(self.map.stage, target)
            self.assertEqual(ground.read_text(), 'carte modifiee par utilisateur')

    def mutation(self, change, message):
        with tempfile.TemporaryDirectory(dir=ROOT / '.cache') as tmp:
            out, stage = Path(tmp) / 'out', Path(tmp) / 'stage'
            shutil.copytree(self.map.out, out, ignore=shutil.ignore_patterns('*.zip', '*.html'))
            shutil.copytree(self.map.stage, stage)
            change(out, stage)
            with self.assertRaisesRegex((AssertionError, ValueError), message):
                V.verify(out, stage)

    def test_mutation_pixel(self):
        def change(out, stage):
            p = out / 'calques/FDR1_00_sol_complet.png'
            a = V.load(p); a[0, 0] = (255, 0, 0, 255); Image.fromarray(a).save(p)
        self.mutation(change, 'Reconstruction')

    def test_mutation_marqueur(self):
        def change(out, stage):
            p = stage / 'Data/Ground/fdr1_fin_defile_roches_grises.rsground'
            d = json.loads(p.read_text()); d['Object']['Entities'][0]['Markers'][1]['Collider']['X'] = 0
            p.write_text(json.dumps(d))
        self.mutation(change, 'Marqueurs')

    def test_mutation_animation(self):
        def change(out, stage):
            shutil.copyfile(out / 'animation/FDR1_05_poussiere_f00.png', out / 'animation/FDR1_05_poussiere_f01.png')
        self.mutation(change, 'Reconstruction')

    def test_mutation_sortie_interdite(self):
        def change(out, stage):
            p = stage / 'Data/Ground/fdr1_fin_defile_roches_grises.rsground'
            d = json.loads(p.read_text())
            d['Object']['Entities'][0]['Markers'][-1]['EntName'] = 'donjon_seuil'
            p.write_text(json.dumps(d))
            m = json.loads((out / 'manifest.json').read_text())
            m['access']['markers']['donjon_seuil'] = m['access']['markers'].pop('objectif')
            (out / 'manifest.json').write_text(json.dumps(m))
        self.mutation(change, 'Marqueurs')

    def test_mutation_collision(self):
        def change(out, stage):
            p = out / 'masques/FDR1_collisions.png'
            a = np.array(Image.open(p)); a[0, 0] = 255 - a[0, 0]; Image.fromarray(a).save(p)
        self.mutation(change, 'Masque collisions')


if __name__ == '__main__':
    unittest.main()
