#!/usr/bin/env python3
"""Vérifications de construction pour la cutscene PMDO Pichu / Team Dazzling."""
from __future__ import annotations
import base64, gzip, hashlib, io, json, re, struct, unittest, zipfile
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'source/cutscene_pichu_dazzling_pmdo'
MOD=SRC/'mod_pmdo'
HTML=ROOT/'apercu_cine_pichu_team_dazzling.html'
ZIP=ROOT/'livrables_cutscene_pichu_dazzling_pmdo/MOD_CUTSCENE_PICHU_DAZZLING_PMDO.zip'
CANONICAL_SHA='6567e19df7a073758d8d52ad1491460067a2dccc1c0d03aa0d1c72b5592e4d2f'
IDS={'pichu':'0172','adagio':'0763','sonata':'0428','aria':'0303'}

def png_size(raw:bytes):return struct.unpack('>II',raw[16:24])
def uri_png(uri:str):return base64.b64decode(uri.split(',',1)[1])

class TestCutscenePichuDazzling(unittest.TestCase):
    def test_01_canonical_map_is_unchanged(self):
        source=gzip.decompress((SRC/'assets/map/cliffdaytest_source.rsground.gz').read_bytes())
        self.assertTrue(source.startswith(b'\xef\xbb\xbf'))
        self.assertEqual(hashlib.sha256(source).hexdigest(),CANONICAL_SHA)

    def test_02_day_night_ground_schema_and_chars(self):
        for stem in ('cliffdaytest','cliffdaytest_nuit'):
            p=MOD/f'Data/Ground/{stem}.rsground';self.assertTrue(p.is_file())
            raw=p.read_bytes();self.assertTrue(raw.startswith(b'\xef\xbb\xbf'))
            obj=json.loads(raw.decode('utf-8-sig'))['Object'];ent=obj['Entities'][0]
            self.assertEqual([x['EntName'] for x in ent['MapChars']],['Pichu'])
            pichu=ent['MapChars'][0]
            self.assertEqual(pichu['serializationLoc'],{'X':608,'Y':476})
            self.assertEqual(obj['obstacles'][608//8][476//8]['Tags'],0,'Pichu doit apparaître sur une case walkable')
            self.assertEqual([x['NPCName'] for x in ent['Spawners']],['Adagio','Sonata','Aria'])
            self.assertEqual(len(ent['Markers']),6)
            expected_layers=4 if stem=='cliffdaytest' else 3
            self.assertEqual(len(obj['Layers']),expected_layers)
            for layer in obj['Layers']:
                self.assertEqual(len(layer['Tiles']),123)
                self.assertEqual(len(layer['Tiles'][0]),99)
                self.assertEqual(layer['Layer'],4 if 'Canopée' in layer['Name'] else 0)
                for col in layer['Tiles']:
                    for cell in col:
                        for sub in cell.get('Layers',[]):
                            for frame in sub.get('Frames',[]):
                                self.assertTrue((MOD/f'Content/Tile/{frame["Sheet"]}.tile').is_file(),frame['Sheet'])
        day=json.loads((MOD/'Data/Ground/cliffdaytest.rsground').read_text(encoding='utf-8-sig'))['Object']
        self.assertEqual([l['Name'] for l in day['Layers']],['Ciel — jour','Mer — animation 8 phases','Terrain — animation 4 phases','Canopée — avant-plan'])
        self.assertEqual(len(day['Background']['Layers']),3)
        for b in day['Background']['Layers']:
            name=b['BG']['BGAnim']['AnimIndex']
            self.assertTrue((MOD/f'Content/BG/{name}.dir').is_file())
        night=json.loads((MOD/'Data/Ground/cliffdaytest_nuit.rsground').read_text(encoding='utf-8-sig'))['Object']
        self.assertIn('LayeredBG',night['Background']['$type'])
        self.assertEqual(len(night['Background']['Layers']),5)
        for b in night['Background']['Layers']:
            name=b['BG']['BGAnim']['AnimIndex']
            self.assertTrue((MOD/f'Content/BG/{name}.dir').is_file())

    def test_03_walk_routes_are_walkable_after_doorway_emergence(self):
        original=json.loads(gzip.decompress((SRC/'assets/map/cliffdaytest_source.rsground.gz').read_bytes()).decode('utf-8-sig'))['Object']
        obstacles=original['obstacles']
        routes=[[(608,476),(556,476),(612,476),(640,526),(708,556),(716,650),(736,770)],
          [(739,770),(716,650),(708,560),(674,524),(696,468),(968,468)],
          [(717,772),(704,668),(702,574),(692,506),(704,468),(960,468)],
          [(765,773),(728,664),(718,578),(694,542),(712,468),(952,468)]]
        for route in routes:
            for (x0,y0),(x1,y1) in zip(route,route[1:]):
                dist=max(abs(x1-x0),abs(y1-y0));steps=max(1,dist//4)
                for i in range(steps+1):
                    x=round(x0+(x1-x0)*i/steps);y=round(y0+(y1-y0)*i/steps)
                    self.assertEqual(obstacles[x//8][y//8]['Tags'],0,(x,y))

    def test_04_lua_cutscenes_and_native_animations(self):
        for stem in ('cliffdaytest','cliffdaytest_nuit'):
            p=MOD/f'Data/Script/halcyon/ground/{stem}/init.lua';self.assertTrue(p.is_file())
            text=p.read_text(encoding='utf-8')
            seen_flag='PichuDazzlingNuit' if stem.endswith('_nuit') else 'PichuDazzling'
            for token in (f'function {stem}.Init(map)',f'function {stem}.Enter(map)',
                          f'function {stem}.Cinematique_Rencontre_Team_Dazzling()',
                          'GAME:CutsceneMode(true)','UI:WaitShowDialogue(','GROUND:MoveToPosition(',
                          f'SV.{seen_flag}.Seen = true',f'return {stem}'):
                self.assertIn(token,text)
        lua=(MOD/'Data/Script/halcyon/ground/cliffdaytest/init.lua').read_text()
        for pid,actions in {'0172':['Walk','Idle','Hop','DeepBreath','Charge','Shock','Pain','Hurt','Pose','Sit'],
                            '0763':['Walk','Idle','Kick','Rotate'],'0428':['Walk','Idle','Appeal','Rotate'],'0303':['Walk','Idle','Attack','Rotate']}.items():
            xml=ET.parse(SRC/f'assets/sprite/{pid}/AnimData.xml').getroot()
            names={n.findtext('Name') for n in xml.findall('./Anims/Anim')}
            for a in actions:self.assertIn(a,names,(pid,a))

    def test_05_preview_bundle_all_assets_and_native_viewport(self):
        text=HTML.read_text(encoding='utf-8');m=re.search(r'const BUNDLE=(\{.*?\});\s*const STEPS=',text,re.S)
        self.assertIsNotNone(m)
        b=json.loads(m.group(1));self.assertEqual((b['map']['width'],b['map']['height']),(984,792))
        self.assertEqual(png_size(uri_png(b['map']['day'])),(984,792));self.assertEqual(png_size(uri_png(b['map']['night'])),(984,792))
        m2=re.search(r'const STEPS=(\[.*?\]);\s*const LUA=',text,re.S);self.assertIsNotNone(m2);steps=json.loads(m2.group(1))
        self.assertEqual(len(steps),23)
        for step in steps:
            self.assertEqual(set(step['actors']),set(IDS))
            for key,actor in step['actors'].items():
                if not actor['visible']:continue
                pk=b['pokemon'][key];self.assertIn(actor['anim'],pk['anims'])
                anim=pk['anims'][actor['anim']];w,h=png_size(uri_png(anim['src']))
                self.assertEqual((w,h),(anim['fw']*anim['cols'],anim['fh']*anim['rows']))
            sp=b['pokemon'][step['speaker']]
            self.assertIn(step['emotion'],sp['portraits'])
        self.assertIn('width="320" height="240"',text)
        self.assertIn('imageSmoothingEnabled=false',text)
        self.assertIn('const LUA=',text)

    def test_06_mod_zip_contains_runtime_files(self):
        self.assertTrue(ZIP.is_file())
        with zipfile.ZipFile(ZIP) as z:
            names=set(z.namelist())
            self.assertIn('mod_pmdo/Mod.xml',names)
            self.assertIn('mod_pmdo/LANCER_CINEMATIQUE_WINDOWS.bat',names)
            self.assertIn('mod_pmdo/LANCER_CINEMATIQUE_LINUX.sh',names)
            self.assertIn('-dev -quest',z.read('mod_pmdo/LANCER_CINEMATIQUE_WINDOWS.bat').decode())
            self.assertIn('-dev -quest',z.read('mod_pmdo/LANCER_CINEMATIQUE_LINUX.sh').decode())
            self.assertIn('mod_pmdo/Data/Ground/cliffdaytest.rsground',names)
            self.assertIn('mod_pmdo/Data/Ground/cliffdaytest_nuit.rsground',names)
            self.assertIn('mod_pmdo/Data/Script/halcyon/ground/cliffdaytest/init.lua',names)
            self.assertIn('mod_pmdo/Data/Script/halcyon/ground/cliffdaytest_nuit/init.lua',names)
            self.assertIn('mod_pmdo/Content/Tile/index.idx',names)
            self.assertIn('mod_pmdo/Content/BG/CLIFF_PICHU_DAY_CLOUD_HORIZON.dir',names)
            for sheet in ('PICHU_CLIFF_DAY_SKY','PICHU_CLIFF_DAY_SEA','PICHU_CLIFF_DAY_TERRAIN','PICHU_CLIFF_DAY_CANOPY',
                          'PICHU_CLIFF_NIGHT_SEA','PICHU_CLIFF_NIGHT_TERRAIN','PICHU_CLIFF_NIGHT_CANOPY'):
                self.assertIn(f'mod_pmdo/Content/Tile/{sheet}.tile',names)
            self.assertIn('provenance/SpriteCollab_manifest.json',names)

if __name__=='__main__':unittest.main(verbosity=2)
