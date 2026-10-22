#!/usr/bin/env python3
"""Verify the tracked current-PMUniverse native building library."""
import hashlib,json
from pathlib import Path
from verify_pmd_structure_library import png_alpha_extrema
ROOT=Path(__file__).resolve().parents[1];BASE=ROOT/'docs/pmuniverse_buildings'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 j=json.loads((BASE/'manifest.json').read_text())
 assert j['source']['download']=='PMU.zip'
 assert j['source']['download_bytes']==184181972
 assert j['source']['download_sha256']=='6262927e79b0d9278b13536b597392b20c1464de499ea93f83141a7d73898137'
 assert j['source']['upstream']=='https://pmuniverse.net/downloads'
 assert j['counts']=={'tile_archives_audited':11,'embedded_tile_records':65471,'qualified_unique_buildings':143,'exact_duplicate_variants_deduplicated':12}
 assert len(j['buildings'])==143 and len({x['id'] for x in j['buildings']})==143
 archives=set()
 for x in j['buildings']:
  p=BASE/x['file'];assert p.is_file() and sha(p)==x['sha256'];assert (x['width'],x['height'])==(x['source_atlas_bbox'][2],x['source_atlas_bbox'][3]);assert x['native_resolution'] and x['transparent_background'];assert not x['terrain_included'] and not x['npc_included'];assert png_alpha_extrema(p)[0]==0;archives.add(x['source_archive'])
 assert archives==set(j['source']['archive_sha256'])=={'Tiles0.tile','Tiles8.tile','Tiles9.tile'}
 for x in j['contact_sheets']:assert sha(BASE/x['file'])==x['sha256']
 print('PMUNIVERSE_BUILDINGS_PASS buildings=143 archives=3 audited_archives=11 records=65471 terrain=0 npc=0')
if __name__=='__main__':main()
