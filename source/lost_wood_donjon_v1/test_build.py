#!/usr/bin/env python3
"""Tests structurels du pack Lost Wood (ne remplacent pas le test moteur)."""
import json
import struct
import unittest
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
Q=ROOT/'quest_pmd_destiny'


def read_string(f):
    n=shift=0
    while True:
        b=f.read(1)
        if not b: raise AssertionError('index tronqué')
        b=b[0]; n |= (b&127)<<shift
        if b<128: break
        shift += 7
    raw=f.read(n)
    if len(raw)!=n: raise AssertionError('chaîne tronquée')
    return raw.decode('utf-8')


def read_index(path):
    import io
    f=io.BytesIO(path.read_bytes())
    count=struct.unpack('<i',f.read(4))[0]
    d={}
    for _ in range(count):
        key=read_string(f); header=f.read(8)
        if len(header)!=8: raise AssertionError('nœud tronqué')
        size,n=struct.unpack('<ii',header); tail=f.read(16*n)
        if size<=0 or len(tail)!=16*n: raise AssertionError('nœud invalide')
        d[key]=header+tail
    assert f.read()==b''
    return d


class LostWoodBuildTests(unittest.TestCase):
    def test_native_tiles_and_index(self):
        idx=read_index(Q/'Content/Tile/index.idx')
        for name,expected in [('LostWoodFloor',49),('LostWoodWall',57),('LostWoodSecondary',1535)]:
            p=Q/'Content/Tile'/f'{name}.tile'
            raw=p.read_bytes(); tile_size,count=struct.unpack_from('<ii',raw)
            self.assertEqual(tile_size,24); self.assertEqual(count,expected)
            self.assertIn(name,idx)
            self.assertEqual(idx[name],raw[:8+16*count])
            for i in range(count):
                x,y,off=struct.unpack_from('<iiQ',raw,8+i*16)
                self.assertEqual((x,y),(i%8,i//8))
                length=struct.unpack_from('<Q',raw,off)[0]
                self.assertEqual(raw[off+8:off+12],b'\x89PNG')
                self.assertGreater(length,24)

    def test_autotile_texlocs_resolve(self):
        expected={'lost_wood_floor':('LostWoodFloor',49),
                  'lost_wood_wall':('LostWoodWall',57),
                  'lost_wood_secondary':('LostWoodSecondary',1535)}
        for key,(sheet,count) in expected.items():
            with open(Q/'Data/AutoTile'/f'{key}.json',encoding='utf-8-sig') as f:
                d=json.load(f)['Object']
            found=0
            for slot,variants in d['Tiles'].items():
                if not slot.startswith('Tilex'): continue
                for groups in variants:
                    for group in groups:
                        for frame in group['Frames']:
                            self.assertEqual(frame['Sheet'],sheet)
                            x,y=frame['TexLoc']['X'],frame['TexLoc']['Y']
                            self.assertLess(y*8+x,count)
                            found+=1
            self.assertGreater(found,0)

    def test_seven_distinct_floors_use_lost_wood_textures(self):
        with open(Q/'Data/Zone/lost_wood.json',encoding='utf-8-sig') as f:
            z=json.load(f)['Object']
        floors=z['Segments'][0]['Floors']
        self.assertEqual(len(floors),7)
        self.assertEqual([len(f['GenSteps']) for f in floors],[16,16,16,18,27,21,21])
        floor_label=next(s['Name']['DefaultText'] for s in z['Segments'][0]['ZoneSteps']
                         if 'FloorNameDropZoneStep' in s.get('$type',''))
        self.assertTrue(floor_label.startswith('Lost Wood'))
        self.assertNotIn('Bramble Woods',json.dumps(z,ensure_ascii=False))
        for floor in floors:
            textures=[s['Value']['TextureMap'] for s in floor['GenSteps']
                      if 'MapDictTextureStep' in s.get('Value',{}).get('$type','')]
            self.assertEqual(len(textures),1)
            self.assertEqual(textures[0]['floor'],'lost_wood_floor')
            self.assertEqual(textures[0]['wall'],'lost_wood_wall')

    def test_tutorial_and_solo_partner_story(self):
        s=(Q/'Data/Script/destiny/ground/cliffdaytest_nuit/init.lua').read_text()
        for phrase in ['sept étages','Chaque pas prend un tour','consomme des PP',
                       'menu des objets','mon ventre','escalier du septième']:
            self.assertIn(phrase,s)
        self.assertIn('GAME:RemovePlayerTeam(0)',s)
        self.assertIn('GAME:AddPlayerAssembly(heros)',s)
        z=(Q/'Data/Script/destiny/zone/lost_wood/init.lua').read_text()
        self.assertIn('GAME:GetPlayerAssemblyMember(idx)',z)
        self.assertIn("GAME:EnterZone('personality_test', -1, 2, 0)",z)


if __name__=='__main__': unittest.main(verbosity=2)
