"""Tests EDR1 : sorties, formats natifs et mutations. PAS un test moteur."""
from contextlib import redirect_stdout
from pathlib import Path
import hashlib
import importlib.util
import io
import json
import shutil
import tempfile
import unittest
import zipfile

import numpy as np
from PIL import Image

from . import build as B
from . import verify as V


class Build(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = json.loads((B.OUT / 'manifest.json').read_text())

    def test_verification_independante_native(self):
        report = V.verify()
        self.assertEqual(report['native_reconstructions'], 30)
        self.assertFalse(report['runtime_tested'])

    def test_reference_provenance(self):
        p = json.loads((B.HERE / 'reference/provenance.json').read_text())
        self.assertEqual(p['commit'], 'c8073235b39746a7ee74e6cea16c730bd91a1e67')
        self.assertEqual(p['entry']['code'], 'D46P11A')
        self.assertEqual(p['render']['frames'], 1)
        self.assertEqual(p['sha256'], B.sha(B.REF))
        self.assertFalse(p['render']['animation_palette'])

    def test_generation_referencee(self):
        g = json.loads((B.HERE / 'generation.json').read_text())
        self.assertEqual(len(g), 2)
        for item in g:
            self.assertIn('reference/D46P11A.png', item['images'])
            self.assertGreater(len(item['prompt']), 150)
            with Image.open(B.HERE / item['file']) as im:
                self.assertEqual(im.size, (1200, 896))
        self.assertIn('bruts/decor_magenta.png', g[1]['images'])
        self.assertIn('pure magenta', g[0]['prompt'])

    def test_fidelite_recalculee_et_couverture(self):
        ref = B.rgb(B.REF)
        scene = np.array(Image.open(B.OUT / 'review/EDR1_scene_t000.png').convert('RGB'))
        for name, a in [('brut', B.rgb(B.HERE / 'bruts/decor_magenta.png')), ('sortie', scene)]:
            measured = B.fidelity(a, ref)
            self.assertEqual(measured, self.manifest['fidelity'][name])
            for k, stats in measured.items():
                self.assertLess(stats['distance'], 35)
                self.assertGreater(stats['pixels_lot'], a.shape[0] * a.shape[1] * .1)
                self.assertGreater(stats['pixels_rip'], ref.shape[0] * ref.shape[1] * .1)

    def test_reduction_par_classe_sans_contamination(self):
        a = np.zeros((896, 1200, 3), np.uint8)
        a[:, :600] = (240, 0, 0); a[:, 600:] = (0, 0, 240)
        masks = {'rouge': a[..., 0] > 0, 'bleu': a[..., 2] > 0}
        layers, reduced, _, normal = B.reduce_classes(a, masks)
        self.assertEqual(normal['scale_xy'], 576 / 896)
        self.assertEqual(normal['scaled_width'], 771)
        for name, channel in [('rouge', 0), ('bleu', 2)]:
            pixels = layers[name][reduced[name], :3]
            self.assertTrue((pixels[:, channel] == 240).all())
            self.assertTrue((pixels[:, 2 - channel] == 0).all())
        self.assertTrue((np.stack(list(reduced.values())).sum(0) == 1).all())

    def test_partition_segmentation_source(self):
        masks = B.classify(B.rgb(B.HERE / 'bruts/decor_magenta.png'))
        self.assertTrue((np.stack(list(masks.values())).sum(0) == 1).all())
        self.assertGreater(masks['profondeur'].sum(), 1000)
        self.assertTrue(masks['profondeur'][0].any())

    def test_sol_continu_et_texture(self):
        a = V.load(B.OUT / 'calques/EDR1_00_sol_complet.png')
        self.assertTrue((a[..., 3] == 255).all())
        self.assertGreater(len(np.unique(a[..., :3].reshape(-1, 3), axis=0)), 15)
        self.assertLess(np.abs(a[..., :3].astype(int).mean((0, 1)) - [155, 155, 155]).max(), 20)

    def test_loi_poussiere_et_boucle(self):
        m = self.manifest['dust']
        walk = np.array(Image.open(B.OUT / 'masques/EDR1_praticable.png')) > 0
        for t in (0, 1, 11, 23, 24):
            actual = B.dust_frame(t, m['emitters'], walk, m['colors'])
            exported = V.load(B.OUT / f'animation/EDR1_06_poussiere_f{t % 24:02d}.png')
            np.testing.assert_array_equal(actual, exported)
        for t in range(24):
            np.testing.assert_array_equal(B.dust_frame(t, m['emitters'], walk, m['colors']),
                                          B.dust_frame(t + 24, m['emitters'], walk, m['colors']))
        # Déplacement maximal 1 px horizontal et 1 px vertical par pas actif.
        y = [round(2 * np.sin(2 * np.pi * k / 18)) for k in range(18)]
        self.assertLessEqual(max(abs(a - b) for a, b in zip(y, y[1:])), 1)

    def test_cadence_webp(self):
        with Image.open(B.OUT / 'review/EDR1_scene_animee.webp') as im:
            self.assertGreater(im.n_frames, 1)
            duration = 0
            for t in range(im.n_frames):
                im.seek(t); im.load(); duration += im.info.get('duration', 0)
            self.assertEqual(duration, 2000)

    def test_ora_ordonne(self):
        import xml.etree.ElementTree as ET
        with zipfile.ZipFile(B.OUT / 'EDR1_calques.ora') as z:
            self.assertEqual(z.read('mimetype'), b'image/openraster')
            root = ET.fromstring(z.read('stack.xml'))
            names = [n.attrib['name'] for n in root.find('stack')]
            self.assertEqual(names, list(reversed([x['name'] for x in self.manifest['layers']])))
            for layer in root.find('stack'):
                with Image.open(io.BytesIO(z.read(layer.attrib['src']))) as im:
                    self.assertEqual(im.size, (768, 576))

    def test_installateur_simulation_fusion_idempotence_et_conflit(self):
        spec = importlib.util.spec_from_file_location('edr1_staged_installer', B.STAGE / 'INSTALLER.py')
        installer = importlib.util.module_from_spec(spec); spec.loader.exec_module(installer)
        with tempfile.TemporaryDirectory(dir=B.ROOT / '.cache') as tmp:
            target = Path(tmp)
            shutil.copyfile(B.STAGE / 'Mod.xml', target / 'Mod.xml')
            tile = next((B.STAGE / 'Content/Tile').glob('*.tile'))
            old = target / 'Content/Tile/EXISTANT.tile'; old.parent.mkdir(parents=True)
            shutil.copyfile(tile, old)
            with old.open('rb') as stream:
                node = installer.read_node(stream)
            idx = old.parent / 'index.idx'; idx.write_bytes(installer.encode_index({'EXISTANT': node}))
            before = {p.relative_to(target): p.read_bytes() for p in target.rglob('*') if p.is_file()}
            with redirect_stdout(io.StringIO()):
                installer.install(B.STAGE, target, dry_run=True)
            self.assertEqual(before, {p.relative_to(target): p.read_bytes() for p in target.rglob('*') if p.is_file()})
            with redirect_stdout(io.StringIO()):
                installer.install(B.STAGE, target)
                installed_index = idx.read_bytes()
                installer.install(B.STAGE, target)
            self.assertEqual(installed_index, idx.read_bytes())
            self.assertIn('EXISTANT', installer.read_index(idx))
            self.assertEqual(len(installer.read_index(idx)), 8)
            self.assertEqual(len(list(idx.parent.glob('*.bak'))), 1)
            ground = target / f'Data/Ground/{B.ASSET}.rsground'
            ground.write_text('carte utilisateur modifiee')
            with self.assertRaisesRegex(ValueError, 'Conflits'):
                installer.install(B.STAGE, target)
            self.assertEqual(ground.read_text(), 'carte utilisateur modifiee')

    def mutate(self, change, message):
        with tempfile.TemporaryDirectory(dir=B.ROOT / '.cache') as tmp:
            root = Path(tmp)
            out, stage = root / 'renders', root / 'stage'
            shutil.copytree(B.OUT, out, ignore=shutil.ignore_patterns('*.zip', '*.html'))
            shutil.copytree(B.STAGE, stage)
            change(out, stage)
            with self.assertRaisesRegex((AssertionError, ValueError), message):
                V.verify(out, stage)

    def test_mutation_pixel_calque(self):
        def change(out, stage):
            p = out / 'calques/EDR1_00_sol_complet.png'
            a = V.load(p); a[0, 0] = (255, 0, 0, 255); Image.fromarray(a).save(p)
        self.mutate(change, 'Reconstruction')

    def test_mutation_animation_figee(self):
        def change(out, stage):
            shutil.copyfile(out / 'animation/EDR1_06_poussiere_f00.png', out / 'animation/EDR1_06_poussiere_f01.png')
        self.mutate(change, 'Reconstruction')

    def test_mutation_marqueur_dans_paroi(self):
        def change(out, stage):
            p = stage / f'Data/Ground/{B.ASSET}.rsground'
            d = json.loads(p.read_text()); d['Object']['Entities'][0]['Markers'][0]['Collider']['X'] = 0
            p.write_text(json.dumps(d))
        self.mutate(change, 'Marqueurs')

    def test_mutation_masque_collision(self):
        def change(out, stage):
            p = out / 'masques/EDR1_collisions.png'
            a = np.array(Image.open(p)); a[0, 0] = 255 - a[0, 0]; Image.fromarray(a).save(p)
        self.mutate(change, 'Masque collisions')

    def test_mutation_magenta(self):
        def change(out, stage):
            p = out / 'calques/EDR1_04_parois.png'
            a = V.load(p); a[0, 0] = (255, 0, 255, 255); Image.fromarray(a).save(p)
        self.mutate(change, 'magenta')


if __name__ == '__main__':
    unittest.main()
