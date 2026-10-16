"""Contrôles EMB1 : entrée de donjon, banques natives, animations, mutations. Pas un test moteur."""
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

from source.maps_suite_v1.pipeline import module, sha
from .build import Map
from . import verify as V

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


class MaraisBrumeux(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.map = Map(HERE)
        cls.m = json.loads((cls.map.out / 'manifest.json').read_text())

    def test_native_reconstruction_independante(self):
        r = V.verify()
        self.assertEqual(r['native_reconstructions'], 55)
        self.assertEqual(r['banks'], 9)
        self.assertFalse(r['runtime_tested'])

    def test_marqueurs_et_acces_entree(self):
        walk = np.array(Image.open(self.map.out / 'masques/EMB1_praticable.png')) > 0
        blocked = (~walk).reshape(72, 8, 96, 8).mean((1, 3)) > .25
        marks = self.m['access']['markers']
        self.assertEqual(set(marks), {'entrance', 'donjon_seuil'})
        self.assertGreaterEqual(marks['entrance'][1], 552)
        self.assertLess(marks['donjon_seuil'][1], 288)
        self.assertTrue(V.reachable(blocked, marks['entrance'], marks['donjon_seuil']))
        self.assertTrue(blocked[0].all())
        self.assertGreater(int(walk[-8].sum()), 96)
        self.assertGreater(int(walk[280].sum()), 200)
        self.assertFalse(self.m['access']['warp'])
        self.assertFalse(self.m['access']['destination_linked'])

    def test_reference_epinglee_et_prompts(self):
        p=json.loads((HERE/'reference/provenance.json').read_text())
        self.assertEqual(p['commit'],'54d373157840500f7a8baacc723ae30f817fad8c')
        self.assertEqual(p['git_blob'],'b6a7b2c4312b3ff33db9526e739538e01f74bf16')
        self.assertEqual(p['sha256'],sha(self.map.ref))
        self.assertEqual(p['sheet_sha256'],sha(HERE/'reference/Murky_Forest_Armaldo_sheet.png'))
        sheet=Image.open(HERE/'reference/Murky_Forest_Armaldo_sheet.png').convert('RGB')
        np.testing.assert_array_equal(sheet.crop(tuple(p['crop_box'])),Image.open(self.map.ref).convert('RGB'))
        g=json.loads((HERE/'generation.json').read_text());self.assertEqual(g,self.m['generation']);self.assertEqual(len(g),3)
        for item in g:
            self.assertIn('reference/Murky_guide.png',item['images'])
            self.assertEqual(item['sha256'],sha(HERE/item['file']))
            with Image.open(HERE/item['file']) as im:
                self.assertEqual(item['actual_size'],list(im.size))
            self.assertEqual(item['reference_sha256'],sha(self.map.ref))
            for path in item['images']:self.assertTrue((HERE/path).is_file())
        self.assertIn('FULL-FRAME',g[0]['prompt']);self.assertIn('NO cave mouth',g[0]['prompt'])

    def test_fidelite_recalculee(self):
        ref = self.map.b.rgb(self.map.ref)
        for stage, a in [('brut', self.map.b.rgb(HERE / 'bruts/decor.png')),
                         ('sortie', np.array(Image.open(self.map.out / 'review/EMB1_scene_t000.png').convert('RGB')))]:
            measured = self.map.fidelity(a, ref)
            self.assertEqual(measured, self.m['fidelity'][stage])
            for name, v in measured.items():
                self.assertLess(v['distance'], 35)
                self.assertGreater(v['pixels_lot'], a.shape[0] * a.shape[1] * .1)

    def test_brume_loi_independante_et_boucle(self):
        import math
        base,metadata=self.map.prepare_fog()
        water=np.array(Image.open(self.map.out/'masques/EMB1_eau.png'))>0
        yy,xx=np.nonzero(base[...,3]);self.assertGreater(len(xx),100)
        for t in range(24):
            # Translation scalaire independante, pas fog_frame ni np.roll.
            dx=round(6*math.sin(2*math.pi*t/24));dy=round(2*(math.cos(2*math.pi*t/24)-1))
            expected=np.zeros_like(base)
            for y,x in zip(yy,xx):
                X,Y=int(x)+dx,int(y)+dy
                if 0<=X<768 and 0<=Y<576 and water[Y,X]:expected[Y,X]=base[y,x]
            actual=V.load(self.map.out/f'animation/EMB1_08_brume_f{t:02d}.png')
            np.testing.assert_array_equal(actual,expected)
            np.testing.assert_array_equal(actual,self.map.fog_frame(t+24,base,water))
        self.assertEqual(metadata,self.m['fog'])
        with Image.open(self.map.out/'review/EMB1_scene_animee.webp') as im:
            self.assertGreater(im.n_frames,1);duration=0
            for t in range(im.n_frames):im.seek(t);im.load();duration+=im.info.get('duration',0)
            self.assertEqual(duration,2000)

    def test_brume_sans_magenta_et_origine(self):
        base,meta=self.map.prepare_fog();colors=np.unique(base[base[...,3]>0,:3],axis=0)
        self.assertLessEqual(len(colors),32);self.assertGreater(len(colors),3)
        self.assertEqual(meta['sha256'],sha(HERE/'bruts/brume_magenta.png'))
        self.assertTrue(all(not (r>170 and b>170 and g<100) for r,g,b in colors.astype(int)))
        water=np.array(Image.open(self.map.out/'masques/EMB1_eau.png'))>0
        self.assertFalse(water[340,587])
        self.assertGreater(water.sum(),70000)

    def test_ora_ordonne(self):
        self.assertEqual([l['name'] for l in self.m['layers']],
                         ['sol_complet', 'vase', 'ombres', 'berges', 'racines', 'feuillage', 'profondeur', 'eau', 'brume'])
        self.assertIsNone(self.m['depth_color'])
        with zipfile.ZipFile(self.map.out / 'EMB1_calques.ora') as z:
            self.assertEqual(z.read('mimetype'), b'image/openraster')
            root = ET.fromstring(z.read('stack.xml'))
            self.assertEqual([n.attrib['name'] for n in root.find('stack')],
                             list(reversed([l['name'] for l in self.m['layers']])))

    def test_profondeur_dessinee(self):
        a = V.load(self.map.out / 'calques/EMB1_06_profondeur.png')
        pixels = a[a[..., 3] == 255, :3]
        self.assertGreater(len(pixels), 10000)
        self.assertGreater(len(np.unique(pixels, axis=0)), 12)
        self.assertGreater(float(pixels.std(axis=0).mean()), 4)
        self.assertEqual(self.map.config['depth_mode'], 'drawn')
        self.assertIsNone(self.m['depth_color'])

    def test_texture_aux_quatre_coins(self):
        # Garde-fou contre les anciens grands coins unis du décor en diorama.
        a = V.load(self.map.out / 'review/EMB1_scene_t000.png')
        for y, x in [(0, 0), (0, 704), (512, 0), (512, 704)]:
            block = a[y:y + 64, x:x + 64, :3]
            self.assertGreater(float(block.reshape(-1, 3).std(axis=0).mean()), 3)
            self.assertGreater(len(np.unique(block.reshape(-1, 3), axis=0)), 12)

    def test_installateur_fusion_protection(self):
        installer = module(self.map.stage / 'INSTALLER.py', 'emb1_staged_installer')
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
            self.assertEqual(len(installer.read_index(idx)), 10)
            self.assertIn('EXISTANT', installer.read_index(idx))
            self.assertEqual(len(list(idx.parent.glob('*.bak'))), 1)
            ground = target / f'Data/Ground/{self.map.config["asset"]}.rsground'
            ground.write_text('carte modifiee par utilisateur')
            with self.assertRaisesRegex(ValueError, 'Conflits'):
                installer.install(self.map.stage, target)
            self.assertEqual(ground.read_text(), 'carte modifiee par utilisateur')

    def test_eau_loi_independante(self):
        import math
        base = V.load(self.map.out / 'animation/EMB1_07_eau_f00.png')
        mask = base[..., 3] > 0
        y, x = np.nonzero(nd.binary_erosion(mask, iterations=6))
        picks = np.linspace(0, len(x)-1, 40).astype(int)
        for t in range(24):
            frame = V.load(self.map.out / f'animation/EMB1_07_eau_f{t:02d}.png')
            theta = 2*math.pi*t/24
            for i in picks:
                xx, yy = int(x[i]), int(y[i])
                dx = round(2*(math.sin(theta+yy/19)-math.sin(yy/19)))
                dy = round(2*(math.cos(theta+xx/23)-math.cos(xx/23)))
                np.testing.assert_array_equal(frame[yy, xx], base[yy+dy, xx+dx])

    def test_eau_bords_couleurs_et_boucle(self):
        base = V.load(self.map.out / 'animation/EMB1_07_eau_f00.png')
        mask = base[..., 3] > 0
        border = mask & ~nd.binary_erosion(mask, iterations=3)
        palette = set(map(tuple, np.unique(base[mask, :3], axis=0)))
        self.assertGreater(mask.sum(), 40000)
        walk = np.array(Image.open(self.map.out / 'masques/EMB1_praticable.png')) > 0
        self.assertFalse((walk & mask).any())
        for t in range(24):
            a = V.load(self.map.out / f'animation/EMB1_07_eau_f{t:02d}.png')
            np.testing.assert_array_equal(a[..., 3] > 0, mask)
            np.testing.assert_array_equal(a[border], base[border])
            self.assertTrue(set(map(tuple, np.unique(a[mask, :3], axis=0))) <= palette)
            np.testing.assert_array_equal(a, self.map.water_frame(t+24, base))
        np.testing.assert_array_equal(base, self.map.water_frame(0, base))

    def test_mutation_eau_figee(self):
        def change(out, stage):
            shutil.copyfile(out / 'animation/EMB1_07_eau_f00.png', out / 'animation/EMB1_07_eau_f01.png')
        self.mutation(change, 'Reconstruction')

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
            p = out / 'calques/EMB1_00_sol_complet.png'
            a = V.load(p); a[0, 0] = (255, 0, 0, 255); Image.fromarray(a).save(p)
        self.mutation(change, 'Reconstruction')

    def test_mutation_marqueur(self):
        def change(out, stage):
            p = stage / 'Data/Ground/emb1_entree_marais_brumeux.rsground'
            d = json.loads(p.read_text()); d['Object']['Entities'][0]['Markers'][1]['Collider']['X'] = 0
            p.write_text(json.dumps(d))
        self.mutation(change, 'Marqueurs')

    def test_mutation_animation(self):
        def change(out, stage):
            shutil.copyfile(out / 'animation/EMB1_08_brume_f00.png', out / 'animation/EMB1_08_brume_f01.png')
        self.mutation(change, 'Brume figée|Reconstruction')

    def test_mutation_marqueur_boss_interdit(self):
        def change(out, stage):
            p = stage / 'Data/Ground/emb1_entree_marais_brumeux.rsground'
            d = json.loads(p.read_text())
            d['Object']['Entities'][0]['Markers'][-1]['EntName'] = 'boss'
            p.write_text(json.dumps(d))
            m = json.loads((out / 'manifest.json').read_text())
            m['access']['markers']['boss'] = m['access']['markers'].pop('donjon_seuil')
            (out / 'manifest.json').write_text(json.dumps(m))
        self.mutation(change, 'Marqueurs')

    def test_mutation_collision(self):
        def change(out, stage):
            p = out / 'masques/EMB1_collisions.png'
            a = np.array(Image.open(p)); a[0, 0] = 255 - a[0, 0]; Image.fromarray(a).save(p)
        self.mutation(change, 'Masque collisions')

    def test_mutation_brume_sur_passage(self):
        def change(out,stage):
            p=out/'animation/EMB1_08_brume_f00.png';a=V.load(p)
            a[400,380]=(80,110,120,255);Image.fromarray(a).save(p)
        self.mutation(change,'Brume hors eau')


if __name__ == '__main__':
    unittest.main()
