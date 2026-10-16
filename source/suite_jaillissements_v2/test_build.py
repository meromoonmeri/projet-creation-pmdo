"""Tests de formats et de comportement calculé, pas un test PMDO."""
from pathlib import Path
import contextlib
import io
import json
import math
import shutil
import tempfile
import unittest
import zipfile
import xml.etree.ElementTree as ET
import numpy as np
from PIL import Image
from scipy import ndimage as nd
from source.maps_suite_v1.pipeline import ROOT, sha, module
from source.suite_jaillissements_v2.build import Map
from source.suite_jaillissements_v2.verify import verify, load, OUT, HERE, names_for, reachable

IDS=sorted(p.name for p in (HERE/'maps').iterdir())
COMBINED=ROOT/'.cache/suite_jaillissements_v2/suite_jaillissements_v2'


class MapCase(unittest.TestCase):
    def __init__(self, methodName='runTest',ident=IDS[0]):
        super().__init__(methodName);self.ident=ident

    def id(self):return super().id()+'.'+self.ident
    def __str__(self):return super().__str__()+' ['+self.ident+']'

    def setUp(self):
        self.map=Map(HERE/'maps'/self.ident);self.c=self.map.config
        self.m=json.loads((self.map.out/'manifest.json').read_text());self.p=self.c['prefix']

    def test_native(self):
        r=verify(self.ident)
        self.assertEqual(r['native_reconstructions'],125 if self.c['kind']=='end' else 126)
        (self.map.out/'verification.json').write_text(json.dumps(r,indent=2)+'\n')

    def test_sources(self):
        g=json.loads((self.map.here/'generation.json').read_text());self.assertEqual(g,self.m['generation'])
        for item in g:
            self.assertEqual(sha(self.map.here/item['file']),item['sha256'])
            self.assertEqual(list(Image.open(self.map.here/item['file']).size),item['actual_size'])
            self.assertTrue(all((self.map.here/f).is_file() for f in item['images']))
        self.assertEqual(sha(self.map.ref),self.m['reference']['sha256'])
        self.assertEqual(self.m['raw_inputs'][1]['file'],'source/entree_terres_volcaniques_v1/bruts/sol_complet.png')
        self.assertEqual(sha(HERE/'shared/colonne_magenta.png'),self.m['column_sprite']['sha256'])

    def test_couleurs(self):
        ref=self.map.b.rgb(self.map.ref)
        for name,a in [('brut',self.map.b.rgb(self.map.here/'bruts/decor.png')),
                       ('sortie',load(self.map.out/f'review/{self.p}_scene_t000.png'))]:
            measured=self.map.fidelity(a,ref);self.assertEqual(measured,self.m['fidelity'][name])
            self.assertTrue(all(v['distance']<35 for v in measured.values()))

    def test_acces(self):
        walk=np.array(Image.open(self.map.out/f'masques/{self.p}_praticable.png'))>0
        blocked=(~walk).reshape(72,8,96,8).mean((1,3))>.25
        for pos in self.m['access']['markers'].values():self.assertTrue(reachable(blocked,self.m['access']['markers']['entrance'],pos))
        self.assertGreater(walk.sum(),50000);self.assertTrue(blocked[0].all())
        self.assertEqual(set(self.m['access']['markers']),{'entrance','boss','objectif'} if self.c['kind']=='end' else {'entrance','donjon_seuil'})
        self.assertFalse(self.m['access']['warp']);self.assertFalse(self.m['access']['destination_linked'])

    def test_montee_oracle_scalaire(self):
        start=names_for(self.c['kind']).index('colonnes')
        pal=self.map.columns.palette
        for col in self.m['columns']:
            pr=self.map.columns.lib.prepare(col['echelle'],col['miroir'])
            P=pr['P'];values=[]
            for t in range(25):
                u=t/24;values.append(P*(u-.6*math.sin(4*math.pi*u)/(4*math.pi)))
            self.assertTrue(all(b>a for a,b in zip(values,values[1:])))
            self.assertAlmostEqual(values[-1]-values[0],P)
            for t in [0,5,11,17,23]:
                a=load(self.map.out/f'animation/{self.p}_{start:02d}_colonnes_f{t:02d}.png')
                u=((t-col['decalage'])%24)/24
                shift=round(P*(u-.6*math.sin(4*math.pi*u)/(4*math.pi)))%P+col['graine']*37
                ox=round(col['x']-pr['body_cx']);x=col['x']-ox
                for y in [0,25,50]:
                    idx=pr['strip'][(y+shift)%P,x]
                    if idx>=0:np.testing.assert_array_equal(a[y,col['x']],(*pal[idx],255))

    def test_sommets_toujours_hors_cadre(self):
        n=names_for(self.c['kind']).index('colonnes')
        for t in range(24):
            a=load(self.map.out/f'animation/{self.p}_{n:02d}_colonnes_f{t:02d}.png')
            for c in self.m['columns']:
                band=a[:c['y']+1,max(0,c['x']-45):c['x']+46,3]>0
                self.assertGreaterEqual(band[0].sum(),8);self.assertTrue(band.any(1).all())

    def test_origine_et_palettes_jets(self):
        palette=set(map(tuple,self.map.columns.palette))
        for name in ['colonnes','jaillissements','projections']:
            i=names_for(self.c['kind']).index(name)
            for t in [0,7,15,23]:
                a=load(self.map.out/f'animation/{self.p}_{i:02d}_{name}_f{t:02d}.png')
                self.assertTrue(set(map(tuple,np.unique(a[a[...,3]>0,:3],axis=0)))<=palette)
        self.assertGreater(len(self.map.columns.lib.prepare(.23,False)['drops']),0)

    def test_boucle_et_cadences(self):
        self.assertEqual(self.m['scene_loop_ticks'],120)
        for l in self.m['layers']:
            self.assertEqual(l['phases'],24 if l['name'] in ['lave','braises','colonnes','jaillissements','projections'] else 1)
            self.assertEqual(l['ticks'],5 if l['phases']==24 else 60)
        self.assertEqual(self.map.columns.lib.shift_of(0,173),self.map.columns.lib.shift_of(1,173))

    def test_ora(self):
        with zipfile.ZipFile(self.map.out/f'{self.p}_calques.ora') as z:
            self.assertIsNone(z.testzip());self.assertEqual(z.read('mimetype'),b'image/openraster')
            root=ET.fromstring(z.read('stack.xml'))
            self.assertEqual([e.attrib['name'] for e in root.find('stack')],list(reversed(names_for(self.c['kind']))))

    def test_quatre_compositions_distinctes(self):
        hashes=[sha(HERE/'maps'/ident/'bruts/decor.png') for ident in IDS]
        self.assertEqual(len(set(hashes)),4)
        a=load(self.map.out/f'review/{self.p}_scene_t000.png')
        for y,x in [(0,0),(0,704),(512,0),(512,704)]:
            self.assertGreater(float(a[y:y+64,x:x+64,:3].reshape(-1,3).std(axis=0).mean()),3)


class BundleCase(unittest.TestCase):
    def test_index_43_banques_et_quatre_cartes(self):
        installer=module(ROOT/'source/pmdo_cote/INSTALLER.py','bundle_index')
        self.assertEqual(len(installer.read_index(COMBINED/'Content/Tile/index.idx')),43)
        self.assertEqual(len(list((COMBINED/'Data/Ground').glob('*.rsground'))),4)
        self.assertEqual(len(list((COMBINED/'Data/Script').rglob('init.lua'))),4)

    def test_installation_fusion_sauvegarde_protection(self):
        installer=module(COMBINED/'INSTALLER.py','bundle_installer')
        with tempfile.TemporaryDirectory(dir=ROOT/'.cache') as tmp:
            target=Path(tmp);shutil.copyfile(COMBINED/'Mod.xml',target/'Mod.xml')
            old=target/'Content/Tile/EXISTANT.tile';old.parent.mkdir(parents=True)
            shutil.copyfile(next((COMBINED/'Content/Tile').glob('*.tile')),old)
            with old.open('rb') as f:node=installer.read_node(f)
            idx=old.parent/'index.idx';idx.write_bytes(installer.encode_index({'EXISTANT':node}))
            before={str(p.relative_to(target)):sha(p) for p in target.rglob('*') if p.is_file()}
            with contextlib.redirect_stdout(io.StringIO()):installer.install(COMBINED,target,dry_run=True)
            self.assertEqual(before,{str(p.relative_to(target)):sha(p) for p in target.rglob('*') if p.is_file()})
            with contextlib.redirect_stdout(io.StringIO()):
                installer.install(COMBINED,target);saved=idx.read_bytes();installer.install(COMBINED,target)
            self.assertEqual(saved,idx.read_bytes());self.assertEqual(len(installer.read_index(idx)),44)
            self.assertEqual(len(list(idx.parent.glob('*.bak'))),1)
            g=target/'Data/Ground/vj21_chenal.rsground';g.write_text('carte utilisateur')
            with self.assertRaisesRegex(ValueError,'Conflits'):installer.install(COMBINED,target)
            self.assertEqual(g.read_text(),'carte utilisateur')

    def mutation(self,change,message):
        ident=IDS[0];c=json.loads((HERE/'maps'/ident/'config.json').read_text())
        stage=ROOT/'.cache'/ident/c['namespace']
        with tempfile.TemporaryDirectory(dir=ROOT/'.cache') as tmp:
            out=Path(tmp)/'out';native=Path(tmp)/'native'
            shutil.copytree(OUT/ident,out);shutil.copytree(stage,native)
            change(out,native)
            with self.assertRaisesRegex(AssertionError,message):verify(ident,out,native)

    def test_mutation_sommet_visible(self):
        def change(out,stage):
            p=out/'animation/VJ21_08_colonnes_f00.png';a=load(p);a[:12]=0;Image.fromarray(a).save(p)
        self.mutation(change,'Sommet visible')

    def test_mutation_colonne_figee(self):
        def change(out,stage):
            shutil.copyfile(out/'animation/VJ21_08_colonnes_f00.png',out/'animation/VJ21_08_colonnes_f01.png')
        self.mutation(change,'Jet fige')

    def test_mutation_bouche_hors_lave(self):
        def change(out,stage):
            p=out/'manifest.json';m=json.loads(p.read_text());m['columns'][0].update(x=384,y=560);p.write_text(json.dumps(m))
        self.mutation(change,'Bouche hors lave')

    def test_mutation_pixel(self):
        def change(out,stage):
            p=out/'calques/VJ21_00_sol_complet.png';a=load(p);a[0,0]=(255,0,0,255);Image.fromarray(a).save(p)
        self.mutation(change,'Reconstruction')

    def test_mutation_warp(self):
        def change(out,stage):
            p=out/'manifest.json';m=json.loads(p.read_text());m['access']['warp']=True;p.write_text(json.dumps(m))
        self.mutation(change,'Warp')


def load_tests(loader,tests,pattern):
    suite=unittest.TestSuite()
    for ident in IDS:
        for name in loader.getTestCaseNames(MapCase):suite.addTest(MapCase(name,ident))
    suite.addTests(loader.loadTestsFromTestCase(BundleCase))
    return suite
