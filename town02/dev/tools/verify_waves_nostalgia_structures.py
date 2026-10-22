#!/usr/bin/env python3
"""Verify the tracked Waves of Nostalgia native structure extraction."""
from __future__ import annotations
import hashlib,json
from pathlib import Path
from verify_pmd_structure_library import png_alpha_extrema
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'docs/waves_nostalgia_structures'
ROM_SHA='5d2b5c7b9942c7eca2115d486eec69b9060418b09fc215ad6f104d46b544f0db'
EXPECTED={'house_leaf_01':(87,76),'house_leaf_02':(88,97),'shop_01':(190,156),'beach_tent_01':(50,76)}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 j=json.loads((BASE/'manifest.json').read_text())
 assert j['source']['rom_bytes']==152547776 and j['source']['rom_sha256']==ROM_SHA
 assert j['count']==4 and len(j['structures'])==4
 assert j['native_asset_search']['bpa_slots_resolved'] is True
 assert j['native_asset_search']['invalid_tile_replacements']==0
 assert set(EXPECTED)=={x['id'] for x in j['structures']}
 for x in j['structures']:
  p=BASE/x['file'];w,h=EXPECTED[x['id']]
  assert (x['width'],x['height'])==(w,h)
  assert sha(p)==x['sha256']
  assert png_alpha_extrema(p)[0]==0
  assert x['transparent_background'] and x['native_resolution'] and x['pixel_perfect']
  assert not x['terrain_included'] and not x['npc_included']
  m=json.loads((BASE/x['mapping']).read_text())
  assert m['source_map']==x['map'] and m['records'] and len(m['records'])==x['native_record_count']
  assert all(0<=r['palette_index']<16 and r['tile_index']>=0 for r in m['records'])
 for mapn in ('overw1','overw2','overw3','overw4','overw5'):
  assert (BASE/mapn/'native_composition.json').is_file()
 c=BASE/j['contact_sheet']['file'];assert sha(c)==j['contact_sheet']['sha256']
 print('WAVES_NOSTALGIA_STRUCTURES_PASS structures=4 mappings=4 maps=5 unresolved_tiles=0 terrain=0 npc=0')
if __name__=='__main__':main()
