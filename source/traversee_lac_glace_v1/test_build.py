"""TLG1 : contrôles techniques, pas PMDO ni approbation artistique."""
from contextlib import redirect_stdout
from pathlib import Path
import io,json,math,shutil,tempfile,unittest,zipfile
import xml.etree.ElementTree as ET
import numpy as np
from PIL import Image
from source.maps_suite_v1.pipeline import ROOT,module,sha
from .build import Map
from . import verify as V
HERE=Path(__file__).resolve().parent

class FrozenLake(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.map=Map(HERE);cls.m=json.loads((cls.map.out/'manifest.json').read_text())

    def test_native(self):
        r=V.verify();self.assertEqual(r['native_reconstructions'],55);self.assertEqual(r['banks'],9)
        self.assertFalse(r['runtime_tested']);self.assertFalse(r['render_tested'])

    def test_source_hashes_et_prompts(self):
        g=json.loads((HERE/'generation.json').read_text());self.assertEqual(g,self.m['generation']);self.assertEqual(len(g),2)
        for e in g:
            self.assertEqual(sha(HERE/e['file']),e['sha256'])
            with Image.open(HERE/e['file']) as im:self.assertEqual(list(im.size),e['actual_size'])
            self.assertIn('reference/D53P11B.png',e['images'])
            for p,s in e['image_hashes'].items():self.assertEqual(sha(HERE/p),s)
        self.assertIn('NEXT MAP',g[0]['prompt']);self.assertIn('not liquid',g[0]['prompt'].lower())

    def test_reference_et_crop(self):
        p=json.loads((HERE/'reference/provenance.json').read_text());q=json.loads((HERE/'reference/D53P11B_provenance.json').read_text())
        self.assertEqual(p['entry']['code'],'D52P11C');self.assertEqual(q['entry']['code'],'D53P11B')
        self.assertEqual(p['commit'],'c8073235b39746a7ee74e6cea16c730bd91a1e67')
        self.assertEqual(sha(HERE/'reference/D52P11C.png'),p['sha256']);self.assertEqual(sha(self.map.ref),q['sha256'])
        self.assertEqual(p['render']['frames'],1);self.assertEqual(q['render']['frames'],1)
        full=Image.open(HERE/'reference/D52P11C.png').convert('RGB');crop=Image.open(HERE/'reference/D52P11C_sol_crop.png').convert('RGB')
        np.testing.assert_array_equal(full.crop((15,220,490,282)),crop)

    def test_fidelite(self):
        ref=self.map.b.rgb(self.map.ref)
        for key,a in [('brut',self.map.b.rgb(HERE/'bruts/decor.png')),('sortie',V.load(self.map.out/'review/TLG1_scene_t000.png'))]:
            measured=self.map.fidelity(a,ref);self.assertEqual(measured,self.m['fidelity'][key])
            self.assertTrue(all(v['distance']<35 and v['pixels_lot']>1000 for v in measured.values()))

    def test_acces_lac_solide(self):
        lake=np.array(Image.open(self.map.out/'masques/TLG1_lac_gele.png'))>0
        walk=np.array(Image.open(self.map.out/'masques/TLG1_praticable.png'))>0
        blocked=np.array(Image.open(self.map.out/'masques/TLG1_collisions.png'))>0
        self.assertGreater(lake.sum(),100000);self.assertTrue(walk[lake].all())
        self.assertTrue(lake[480,480]);self.assertTrue(walk[480,480])
        self.assertTrue(lake[486,480]);self.assertTrue(lake[490,490])
        m=self.m['access'];self.assertTrue(V.reachable(blocked,m['markers']['entrance'],m['markers']['donjon_seuil']))
        self.assertFalse(m['warp']);self.assertFalse(m['destination_linked']);self.assertGreater(m['markers']['donjon_seuil'][0],620)

    def test_neige_oracle(self):
        d=self.m['snow']
        for t in range(24):
            expected=np.zeros((576,768,4),np.uint8)
            for x0,y0,phase in d['emitters']:
                k=(t+phase)%24
                if k>=18:continue
                x=x0+round(4*math.sin(2*math.pi*k/18));y=y0+2*k
                expected[y,x]=expected[y-1,x]=(*d['colors'][min(k,17-k,3)],255)
            actual=V.load(self.map.out/f'animation/TLG1_08_flocons_f{t:02d}.png')
            np.testing.assert_array_equal(expected,actual)
            np.testing.assert_array_equal(actual,self.map.snow_frame(t+24,d['emitters'],d['colors']))

    def test_reflets_oracle(self):
        d=self.m['glints'];lake=np.array(Image.open(self.map.out/'masques/TLG1_lac_gele.png'))>0
        for t in range(24):
            expected=np.zeros((576,768,4),np.uint8)
            for x,y,phase in d['emitters']:
                k=(t+phase)%24
                if k>=8:continue
                n=min(k,7-k,3);offsets=[(0,0)] if n<3 else [(0,0),(-1,0),(1,0),(0,-1),(0,1)]
                for dx,dy in offsets:
                    if lake[y+dy,x+dx]:expected[y+dy,x+dx]=(*d['colors'][n],255)
            actual=V.load(self.map.out/f'animation/TLG1_07_scintillements_f{t:02d}.png')
            np.testing.assert_array_equal(actual,expected)
            np.testing.assert_array_equal(actual,self.map.glint_frame(t+24,d['emitters'],lake,d['colors']))

    def test_ora_pixels_et_ordre(self):
        with zipfile.ZipFile(self.map.out/'TLG1_calques.ora') as z:
            self.assertEqual(z.read('mimetype'),b'image/openraster');tree=ET.fromstring(z.read('stack.xml'))
            self.assertEqual([n.attrib['name'] for n in tree.find('stack')],list(reversed(V.NAMES)))
            for n,l in zip(tree.find('stack'),reversed(self.m['layers'])):
                a=np.array(Image.open(io.BytesIO(z.read(n.attrib['src']))))
                np.testing.assert_array_equal(a,V.load(self.map.out/l['file'].replace('NN','00')))

    def test_webp_et_coins(self):
        with Image.open(self.map.out/'review/TLG1_scene_animee.webp') as im:
            total=0;self.assertGreater(im.n_frames,1)
            for n in range(im.n_frames):im.seek(n);im.load();total+=im.info.get('duration',0)
            self.assertEqual(total,2000)
        a=V.load(self.map.out/'review/TLG1_scene_t000.png')
        for y,x in [(0,0),(0,704),(512,0),(512,704)]:self.assertGreater(float(a[y:y+64,x:x+64,:3].reshape(-1,3).std(0).mean()),3)

    def test_repro(self):
        r=json.loads((self.map.out/'reproducibilite.json').read_text());self.assertEqual(r['differences'],0);self.assertGreater(r['compared_files_and_ora_members'],90)

    def test_installateur_fusion_protection(self):
        installer = module(self.map.stage / 'INSTALLER.py', 'tlg1_staged_installer')
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

    def mutation(self,change,message):
        with tempfile.TemporaryDirectory(dir=ROOT/'.cache') as tmp:
            out,stage=Path(tmp)/'out',Path(tmp)/'stage'
            shutil.copytree(self.map.out,out,ignore=shutil.ignore_patterns('*.zip','*.html'));shutil.copytree(self.map.stage,stage)
            change(out,stage)
            with self.assertRaisesRegex(AssertionError,message):V.verify(out,stage)

    def test_mutation_pixel(self):
        def change(out,stage):
            p=out/'calques/TLG1_00_sol_complet.png';a=V.load(p);a[0,0]=(255,0,0,255);Image.fromarray(a).save(p)
        self.mutation(change,'Reconstruction')

    def test_mutation_warp(self):
        def change(out,stage):
            p=out/'manifest.json';m=json.loads(p.read_text());m['access']['warp']=True;p.write_text(json.dumps(m))
        self.mutation(change,'Warp')

    def test_mutation_collision(self):
        def change(out,stage):
            p=out/'masques/TLG1_collisions.png';a=np.array(Image.open(p));a[0,0]=255-a[0,0];Image.fromarray(a).save(p)
        self.mutation(change,'Masque collisions')

    def test_mutation_reflet_hors_lac(self):
        def change(out,stage):
            p=out/'animation/TLG1_07_scintillements_f00.png';a=V.load(p);a[0,0]=(*self.m['glints']['colors'][0],255);Image.fromarray(a).save(p)
        self.mutation(change,'Scintillement hors lac')

    def test_mutation_reflets_figes(self):
        def change(out,stage):shutil.copyfile(out/'animation/TLG1_07_scintillements_f00.png',out/'animation/TLG1_07_scintillements_f01.png')
        self.mutation(change,'Animation figee')

    def test_mutation_marqueur(self):
        def change(out,stage):
            p=stage/'Data/Ground/tlg1_traversee_lac_glace.rsground';m=json.loads(p.read_text());m['Object']['Entities'][0]['Markers'][1]['Collider']['X']=0;p.write_text(json.dumps(m))
        self.mutation(change,'Marqueurs')

if __name__=='__main__':unittest.main()
