#!/usr/bin/env python3
"""Reject unsafe PMDO lifecycle mutations in the rmvillage life layer."""
import hashlib, json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
script=ROOT/'generated/rmvillage/life/NNVLife.lua'; text=script.read_text()
setup=text.split('function Life.Setup()',1)[1].split('function Life.Update()',1)[0]
assert 'AI:SetCharacterAI' not in text
assert 'TASK:StartEntityTask' not in setup
assert 'GROUND:' not in setup
assert 'initialize_after_entry()' in text and 'Life.tick%30' in text
patch=json.loads((ROOT/'generated/rmvillage/life/entities_patch.json').read_text())
digest=hashlib.sha256(script.read_bytes()).hexdigest()
assert patch['script_sha256']==digest and patch['entity_count']==49
for season in ('spring','summer','autumn','winter'):
 manifest=json.loads((ROOT/f'generated/rmvillage/living/{season}/manifest.json').read_text())
 assert manifest['outputs']['life_script_sha256']==digest
 assert manifest['runtime_status']=='NOT_RUN'
print(f'RMVILLAGE_LIFE_LIFECYCLE_PASS entities=49 script={digest}')
