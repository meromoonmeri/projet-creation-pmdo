"""Contrôles FFF1 : entrée de donjon, banques natives, animations, mutations. Pas un test moteur."""
from contextlib import redirect_stdout
from pathlib import Path
import io
import json
import shutil
import tempfile
import unittest
import xml.etree.ElementTree as ET
import zipfile

from scipy import ndimage as nd
import numpy as np
from PIL import Image
from scipy import ndimage as nd

from source.maps_suite_v1.pipeline import module, sha
from .build import Map
from . import verify as V

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


class ForetFeuillus(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.map = Map(HERE)
        cls.m = json.loads((cls.map.out / 'manifest.json').read_text())

    def test_native_reconstruction_independante(self):
        r = V.verify()
        self.assertEqual(r['native_reconstructions'], 31)
        self.assertEqual(r['banks'], 8)
        self.assertFalse(r['runtime_tested'])

    def test_marqueurs_et_acces_fin(self):
        walk = np.array(Image.open(self.map.out / 'masques/FFF1_praticable.png')) > 0
        blocked = (~walk).reshape(72, 8, 96, 8).mean((1, 3)) > .25
        marks = self.m['access']['markers']
        self.assertEqual(set(marks), {'entrance', 'boss', 'objectif'})
        self.assertGreaterEqual(marks['entrance'][1], 552)
        self.assertLess(marks['objectif'][1], marks['boss'][1])
        self.assertLess(marks['boss'][1], marks['entrance'][1])
        for target in ('boss', 'objectif'):
            self.assertTrue(V.reachable(blocked, marks['entrance'], marks[target]))
        x, y = marks['boss']
        self.assertGreater(nd.distance_transform_edt(walk)[y+8, x+8], 40)
        self.assertTrue(blocked[0].all())
        self.assertGreater(int(walk[400].sum()), 250)
        self.assertFalse(self.m['access']['warp'])
        self.assertFalse(self.m['access']['destination_linked'])

    def test_reference_epinglee_et_prompts(self):
        p = json.loads((HERE / 'reference/provenance.json').read_text())
        self.assertEqual(p['commit'], 'c8073235b39746a7ee74e6cea16c730bd91a1e67')
        self.assertEqual(p['entry']['code'], 'D24P11A')
        self.assertEqual(p['sha256'], sha(self.map.ref))
        self.assertGreaterEqual(len(p['source_blobs']), 3)
        g = json.loads((HERE / 'generation.json').read_text())
        self.assertEqual(g, self.m['generation'])
        self.assertEqual(p['render']['frames'], 1)
        self.assertFalse(p['render']['animation_palette'])
        self.assertTrue(any('reference/D24P11A.png' in item['images'] for item in g))
        prompts = [item.get('prompt', '') for item in g]
        self.assertTrue(any('full-frame' in prompt.lower() for prompt in prompts))
        self.assertTrue(any('No cave' in prompt for prompt in prompts))
        for item in g:
            with Image.open(HERE / item['file']) as image:
                self.assertEqual(image.size, tuple(item['actual_size']))
            for path in item['images']:
                self.assertTrue((HERE / path).is_file(), path)
        for item in g:
            self.assertEqual(item['reference_sha256'], sha(self.map.ref))

    def test_fidelite_recalculee(self):
        ref = self.map.b.rgb(self.map.ref)
        for stage, a in [('brut', self.map.b.rgb(HERE / 'bruts/decor.png')),
                         ('sortie', np.array(Image.open(self.map.out / 'review/FFF1_scene_t000.png').convert('RGB')))]:
            measured = self.map.fidelity(a, ref)
            self.assertEqual(measured, self.m['fidelity'][stage])
            for v in measured.values():
                self.assertLess(v['distance'], 35)
                self.assertGreater(v['pixels_lot'], a.shape[0] * a.shape[1] * .1)

    def test_animation_loi_couleurs_et_boucle(self):
        d = self.m['dust']
        walk = np.array(Image.open(self.map.out / 'masques/FFF1_praticable.png')) > 0
        for t in range(24):
            # Loi reconstruite ici, sans appeler effect() ni le helper dust_frame().
            actual = np.zeros((576, 768, 4), np.uint8)
            for x0, y0, phase in d['emitters']:
                k = (t + phase) % 24
                if k >= 18:
                    continue
                x = x0 + round(4 * np.sin(2 * np.pi * k / 18))
                y = y0 + k - 9
                color = d['colors'][min(k, 17 - k, 3)]
                for dx, dy in ((0, 0), (1, 0), (1, 1)):
                    if 0 <= x + dx < 768 and 0 <= y + dy < 576 and walk[y + dy, x + dx]:
                        actual[y + dy, x + dx] = (*color, 255)
            exported = V.load(self.map.out / f'animation/FFF1_07_feuilles_f{t:02d}.png')
            np.testing.assert_array_equal(actual, exported)
            np.testing.assert_array_equal(actual, self.map.effect(t + 24, d['emitters'], walk, d['colors']))
        with Image.open(self.map.out / 'review/FFF1_scene_animee.webp') as im:
            self.assertGreater(im.n_frames, 1)
            duration = 0
            for t in range(im.n_frames):
                im.seek(t); im.load(); duration += im.info.get('duration', 0)
            self.assertEqual(duration, 2000)

    def test_ora_ordonne(self):
        self.assertEqual([l['name'] for l in self.m['layers']],
                         ['sol_complet', 'herbe', 'terre', 'ombres', 'sous_bois', 'troncs', 'feuillage', 'feuilles'])
        self.assertIsNone(self.m['depth_color'])
        with zipfile.ZipFile(self.map.out / 'FFF1_calques.ora') as z:
            self.assertEqual(z.read('mimetype'), b'image/openraster')
            root = ET.fromstring(z.read('stack.xml'))
            self.assertEqual([n.attrib['name'] for n in root.find('stack')],
                             list(reversed([l['name'] for l in self.m['layers']])))

    def test_matiere_effet_support_assortis_entree(self):
        from source.entree_foret_feuillus_v1.build import Map as EntryMap
        entry = EntryMap(ROOT / 'source/entree_foret_feuillus_v1')
        self.assertEqual(sha(HERE / 'bruts/sol_complet.png'), sha(entry.here / 'bruts/sol_complet.png'))
        g = json.loads((HERE / 'generation.json').read_text())
        self.assertEqual(g[-1]['source_sha256'], sha(HERE / 'bruts/sol_complet.png'))
        self.assertEqual(g[0]['secondary_reference_sha256'], sha(entry.here / 'bruts/decor.png'))
        ref = self.map.b.rgb(self.map.ref)
        self.assertEqual(self.map.fidelity(ref, ref), entry.fidelity(ref, ref))
        self.assertEqual(self.map.effect_colors(ref), entry.effect_colors(ref))
        walk = np.array(Image.open(self.map.out / 'masques/FFF1_praticable.png')) > 0
        d = self.m['dust']
        for t in range(24):
            np.testing.assert_array_equal(self.map.effect(t, d['emitters'], walk, d['colors']),
                                          entry.effect(t, d['emitters'], walk, d['colors']))
        self.assertNotIn('profondeur', [layer['name'] for layer in self.m['layers']])
        self.assertNotIn('depth_polygon_raw', self.map.config)

    def test_foret_plein_cadre(self):
        # Garde-fou contre les anciens grands coins unis du décor en diorama.
        a = V.load(self.map.out / 'review/FFF1_scene_t000.png')
        for y, x in [(0, 0), (0, 704), (512, 0), (512, 704)]:
            block = a[y:y + 64, x:x + 64, :3]
            self.assertGreater(float(block.reshape(-1, 3).std(axis=0).mean()), 10)
            self.assertGreater(len(np.unique(block.reshape(-1, 3), axis=0)), 15)

    def test_installateur_fusion_protection(self):
        installer = module(self.map.stage / 'INSTALLER.py', 'fff1_staged_installer')
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
            self.assertEqual(len(installer.read_index(idx)), 9)
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
            p = out / 'calques/FFF1_00_sol_complet.png'
            a = V.load(p); a[0, 0] = (255, 0, 0, 255); Image.fromarray(a).save(p)
        self.mutation(change, 'Reconstruction')

    def test_mutation_marqueur(self):
        def change(out, stage):
            p = stage / 'Data/Ground/fff1_fin_foret_feuillus.rsground'
            d = json.loads(p.read_text()); d['Object']['Entities'][0]['Markers'][1]['Collider']['X'] = 0
            p.write_text(json.dumps(d))
        self.mutation(change, 'Marqueurs')

    def test_mutation_animation(self):
        def change(out, stage):
            shutil.copyfile(out / 'animation/FFF1_07_feuilles_f00.png', out / 'animation/FFF1_07_feuilles_f01.png')
        self.mutation(change, 'Reconstruction')

    def test_mutation_sortie_interdite(self):
        def change(out, stage):
            p = stage / 'Data/Ground/fff1_fin_foret_feuillus.rsground'
            d = json.loads(p.read_text())
            d['Object']['Entities'][0]['Markers'][-1]['EntName'] = 'donjon_seuil'
            p.write_text(json.dumps(d))
            m = json.loads((out / 'manifest.json').read_text())
            m['access']['markers']['donjon_seuil'] = m['access']['markers'].pop('objectif')
            (out / 'manifest.json').write_text(json.dumps(m))
        self.mutation(change, 'Marqueurs')

    def test_mutation_collision(self):
        def change(out, stage):
            p = out / 'masques/FFF1_collisions.png'
            a = np.array(Image.open(p)); a[0, 0] = 255 - a[0, 0]; Image.fromarray(a).save(p)
        self.mutation(change, 'Masque collisions')


if __name__ == '__main__':
    unittest.main()
