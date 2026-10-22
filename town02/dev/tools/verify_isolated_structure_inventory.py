#!/usr/bin/env python3
import hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];BASE=ROOT/'docs/pmdo_isolated_structures'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 d=json.loads((BASE/'inventory.json').read_text());assert d['authority']['commit']=='9d864d1425f002b051e7a54fffc639988d8ef9c9';p=d['policy'];assert p['allowed_source_prefix']=='Content/Object/' and not p['ground_or_map_fragments_allowed'] and not p['tileset_crops_allowed'] and not p['pixel_modification_allowed'] and not p['resizing_allowed'] and not p['recoloring_allowed']
 assert len(d['qualified'])==3 and d['counts']['qualified_isolated_structures']==3 and d['counts']['reviewed_excluded']==3 and d['counts']['ground_fragments_imported']==0 and d['counts']['map_fragments_imported']==0 and d['counts']['pixels_modified']==0
 assert d['exhaustive_content_object_count']==92 and len(d['all_content_object_assets'])==92 and len({row['source'] for row in d['all_content_object_assets']})==92
 assert all(row['source'].startswith('Content/Object/') and row['source'].endswith('.dir') for row in d['all_content_object_assets'])
 merchant=d['merchant_stand_audit'];assert not merchant['kecleon_standalone_stand_found'] and not merchant['complete_merchant_stand_found'] and not merchant['tile_shop_is_physical_stand'];assert len(merchant['qualified_isolated_market_components'])==12
 for row in d['qualified']:
  assert row['source'].startswith('Content/Object/') and row['source'].endswith('.dir');preview=BASE/row['preview'];assert preview.is_file() and sha(preview)==row['preview_sha256'];assert row['status']=='QUALIFIED_ISOLATED_STRUCTURE' and row['frame_count']==1
 market=json.loads((BASE/'market_components/inventory.json').read_text());assert market['component_count']==13 and market['qualified_component_count']==12 and market['excluded_marker_count']==1 and not market['complete_stand_found'] and not market['kecleon_stand_found']
 assert sha(BASE/'market_components'/market['contact_sheet'])==market['contact_sheet_sha256']
 for row in market['components']:
  preview=BASE/'market_components'/row['preview'];assert preview.is_file() and sha(preview)==row['preview_sha256']
 assert d['integration_status']=='NOT_PLACED' and d['runtime_status']=='NOT_RUN' and not d['promotion_allowed'];print('ISOLATED_STRUCTURE_INVENTORY_PASS qualified=3 market_components=12 all_objects=92 fragments=0 modified=0')
if __name__=='__main__':main()
